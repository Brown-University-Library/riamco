require "time"
require "nokogiri"
require "./app/models/institutions.rb"

class Ead
    attr_reader :abstract, :biog_hist, :bulk, :call_no,
        :creators, :date, :date_display, :end_year, :extent,
        :formats, :id, :institution, :institution_id,
        :keywords, :languages, :repository_name, :scope_content,
        :start_year, :subjects,
        :title, :title_sort, :title_filing, :title_proper,
        :unit_id

    def initialize(xml, parse = true)
        @xml_doc = Nokogiri::XML(xml)
        if parse != true
            return
        end
        @abstract = get_doc_abstract()
        @biog_hist = get_doc_biog_hist()
        @bulk = get_doc_bulk()
        @call_no = get_doc_call_no()
        @creators = get_doc_creators()

        @date = get_doc_date()
        years = get_doc_years(@date)
        @end_year = years[1]
        @start_year = years[0]

        @date_display = get_doc_date_display()

        @extent = get_doc_extent()
        @title_filing = get_doc_title_filing()
        @formats = get_doc_formats()
        @id = get_doc_id()
        @institution_id = get_doc_main_agency_code()
        @institution = get_doc_institution_name(@institution_id)
        @keywords = get_doc_keywords()
        @languages = get_doc_languages()
        @repository_name = get_doc_repository_name()
        @scope_content = get_doc_scope_content()
        @subjects = get_doc_subjects()
        @title = get_doc_title()
        @title_sort = get_doc_title_sort(@title_filing || @title)
        @title_proper = get_doc_title_proper()
        @unit_id = get_doc_unit_id()
        @inventory = get_doc_inventory()
    end

    def to_s()
        "#{@id}, #{@title}"
    end

    def inventory_scope_content(inv_id, trim_tag = true)
        # https://www.bennadel.com/blog/2142-using-and-expressions-in-xpath-xml-search-directives-in-coldfusion.htm
        elements = @xml_doc.xpath("//xmlns:c[@id='#{inv_id}']/xmlns:scopecontent")
        if elements.count != 1
            return nil
        end

        html = elements.to_s
        if trim_tag
            html.gsub!("<scopecontent>", "")
            html.gsub!("</scopecontent>", "")
        end
        html
    end

    def to_solr(with_inventory = false)
        core_doc = {
            abstract_txt_en: self.abstract,
            biog_hist_txt_en: self.biog_hist,
            bulk_s: self.bulk,
            call_no_s: self.call_no,
            creators_ss: self.creators,
            creators_txts_en: self.creators,
            date_s: self.date,
            date_range_s: date_facet(self.start_year),
            date_display_s: self.date_display,
            end_year_i: self.end_year,
            extent_s: self.extent,
            filing_title_s: self.title_filing,
            formats_ss: self.formats,
            formats_txts_en: self.formats,
            id: self.id,
            ead_id_s: self.id,
            institution_s: self.institution,
            institution_id_s: self.institution_id,
            languages_ss: self.languages,
            title_s: self.title,                        # for faceting
            title_txt_en: self.title,                   # for searching
            title_sort_s: self.title_sort,
            title_proper_s: self.title_proper,
            timestamp_s: DateTime.now.to_s,
            scope_content_txts_en: self.scope_content,
            start_year_i: self.start_year,
            repository_name_s: self.repository_name,
            subjects_ss: self.subjects,                 # for faceting
            subjects_txts_en: self.subjects,            # for searching
            unit_id_s: self.unit_id,
            inventory_level_s: "Finding Aid",
            keywords_t: self.keywords
        }

        if with_inventory == false
            return [core_doc]
        end

        # Return one Solr document for the finding aid...
        solr_data = []
        solr_data << core_doc

        # ...plus one document per each entry in the inventory.
        # The "core" data is the same for all of them, but the
        # inventory_* fields are different and the ID has a
        # sequence to force them to be different.
        seq = 1
        inventory.each do |inv|

            # TODO: flag/report/skip items that don't have an inv[:id]

            solr_doc = {}
            if inv[:level] == "item"
                solr_doc = {
                    id: core_doc[:id] + "-" + inv[:id],
                    ead_id_s: {"set" => core_doc[:id]},
                    sequence_s: {"set" => core_doc[:id] + "-" + seq_str(seq)},
                    title_s: {"set" => core_doc[:title_s]},                    # finding aid name (for faceting)
                    title_txt_en: {"set" => core_doc[:title_s]},               # finding aid name (for searching)
                    institution_s: {"set" => core_doc[:institution_s]},
                    institution_id_s: {"set" => core_doc[:institution_id_s]},
                    timestamp_s: {"set" => DateTime.now.to_s},
                    inventory_id_s: {"set" => inv[:id]},
                    inventory_container_txt_en: {"set" => inv[:container_text]},
                    inventory_scope_content_txt_en: {"set" => inv[:scope_content]},
                    inventory_label_txt_en: {"set" => inv[:label]},
                    inventory_date_s: {"set" => inv[:date]},
                    inventory_descendent_path: {"set" => inv[:full_path]},     # for navigation
                    inventory_path_txt_en: {"set" => inv[:full_path]},         # for searching
                    inventory_level_s: {"set" => inv[:level]},
                    inventory_filename_s: {"set" => inv[:filename]},
                    inventory_file_description_txt_en: {"set" => inv[:file_description]},
                    subjects_ss: {"set" => inv[:subjects]},                    # for faceting
                    subjects_txts_en: {"set" => inv[:subjects]},               # for searching
                    creators_ss: {"set" => inv[:creators]},
                    creators_txts_en: {"set" => inv[:creators]},
                    is_file_b: {"set" => inv[:is_file]}
                }
            else
                solr_doc = {
                    id: core_doc[:id] + "-" + inv[:id],
                    sequence_s: core_doc[:id] + "-" + seq_str(seq),
                    ead_id_s: core_doc[:id],
                    title_s: core_doc[:title_s],                    # finding aid name (for faceting)
                    title_txt_en: core_doc[:title_s],               # finding aid name (for searching)
                    institution_s: core_doc[:institution_s],
                    institution_id_s: core_doc[:institution_id_s],
                    timestamp_s: DateTime.now.to_s,
                    inventory_id_s:inv[:id],
                    inventory_container_txt_en: inv[:container_text],
                    inventory_scope_content_txt_en: inv[:scope_content],
                    inventory_label_txt_en: inv[:label],
                    inventory_date_s: inv[:date],
                    inventory_descendent_path: inv[:full_path],     # for navigation
                    inventory_path_txt_en: inv[:full_path],         # for searching
                    inventory_level_s: inv[:level],
                    inventory_filename_s: inv[:filename],
                    inventory_file_description_txt_en: inv[:file_description],
                    subjects_ss: inv[:subjects],                    # for faceting
                    subjects_txts_en: inv[:subjects],               # for searching
                    creators_ss: inv[:creators],
                    creators_txts_en: inv[:creators],
                    is_file_b: inv[:is_file]
                }
            end
            solr_data << solr_doc
            seq += 1
        end
        solr_data
    end

    def inventory()
        @inventory ||= get_doc_inventory()
    end

    private
        # Mimics the logic used in the original RIAMCO XSLT.
        def date_range_from_string(date_str)
            if date_str == nil || date_str.length < 4
                return nil
            end

            if date_str.length == 4
                # single year
                return date_str
            end

            # multiple year, take the first two
            years = date_str.split("/")
            if years.count < 2
                return years[0]
            end
            return years[0] + "/" + years[1]
        end

        def date_facet(year)
            if year == nil
                return "undated"
            end

            if year < 1
                # TODO: handle BCE dates
                return "other"
            end

            century = (year / 100).to_i
            range_start = century.to_s.rjust(2,"0") + "01"
            range_end = (century+1).to_s.rjust(2,"0") + "00"
            range_start + " - " + range_end
        end

        def get_doc_id()
            @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:eadid[1]/text()").text
        end

        def get_doc_years(date_str, sep = '/')
            return [nil,nil] if date_str == nil
            tokens = date_str.split(sep)
            return [nil,nil] if tokens.count != 2
            year1 = get_year(tokens[0]).to_i
            year2 = get_year(tokens[1]).to_i
            [year1, year2]
        end

        def get_year(token)
            return token if token.length <= 4
            token[0..3]
        end

        def get_doc_bulk()
            normal = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitdate[@type='bulk']/@normal")
            return date_range_from_string(normal)
        end

        def get_doc_creators()
            values = []
            values += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:origination/xmlns:corpname")
            values += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:origination/xmlns:persname")
            values += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:origination/xmlns:famname")
            values
        end

        def get_doc_title()
            t = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unittitle[@type='primary']/text()")
            strip_safe(t)
        end

        def get_doc_call_no()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitid/text()")
        end

        def get_doc_title_sort(title)
            return nil if title == nil
            title.upcase
        end

        def get_doc_title_filing()
            t = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unittitle[@type='filing']/text()")
            strip_safe(t)
        end

        def get_doc_formats()
            formats = []
            formats += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:genreform")
            formats
        end

        def get_doc_title_proper()
            title_proper = ""
            titles = @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:filedesc/xmlns:titlestmt/xmlns:titleproper[1]")
            if titles.count > 0
                texts = titles[0].children.map {|c| c.text}
                texts = texts.map {|text| text == "\n" ? nil : text}.compact
                title_proper = trim_text(texts.join(" "))
            end
            strip_safe(title_proper)
        end

        def get_doc_languages()
            langs = []
            doc_langs = @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:profiledesc/xmlns:langusage/xmlns:language")
            doc_langs.each do |l|
                lang = trim_text(l.text)
                if lang == "eng"
                    lang = "English"
                end
                langs << lang
            end
            langs.uniq
        end

        def get_doc_main_agency_code()
            get_xpath_value("xmlns:ead/xmlns:eadheader/xmlns:eadid[1]/@mainagencycode")
        end

        def get_doc_date()
            date_str = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitdate[@type='inclusive']/@normal")
            return date_range_from_string(date_str)
        end

        def get_doc_date_display()
            inclusive = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitdate[@type='inclusive']/text()")
            bulk = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitdate[@type='bulk']/text()")
            case
                when inclusive == nil && bulk == nil
                    return nil
                when inclusive != nil && bulk == nil
                    return inclusive
                when inclusive == nil && bulk != nil
                    return bulk
                else
                    return inclusive + " " + bulk
            end
        end


        def get_doc_biog_hist()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:bioghist/xmlns:p")
        end

        # not used anymore
        # def get_doc_browse_terms()
        #     path = "xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:subject[@source='riamco']"
        #     get_xpath_values(path, true)
        # end

        def get_doc_repository_name()
            name = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:repository/xmlns:corpname[1]/text()")
            trim_text(name)
        end

        def get_doc_subjects()
            subjects = []
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:persname")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:corpname")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:famname")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:geogname")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:subject")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:title")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:occupation")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:function")
            subjects
        end

        def get_doc_scope_content()
            # The original RIAMCO code is picking up "scopecontent" nodes in
            # the entire XML document regardless of the path for Solr indexing
            # but only the nodes in the "/ead/archdesc/descgrp/scopecontent"
            # xpath for display in the XSLT. I think we should always honor
            # the xpath.
            #
            # TODO: Karen said we should pick them all up. I need to make sure
            #       that I keep the ones for the inventory items within their
            #       corresponding inventory Solr document.
            get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:scopecontent/xmlns:p")
        end

        def get_doc_extent()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:physdesc/xmlns:extent/text()")
        end

        def get_doc_abstract()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:abstract/text()")
        end

        def get_doc_unit_id()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitid/text()")
        end

        def get_doc_institution_name(institution_id)
            inst = Institutions.for_code(institution_id)
            return inst[:name] if inst != nil
            nil
        end

        def get_doc_inventory()
            inventory = []
            root_c_nodes = @xml_doc.xpath("xmlns:ead/xmlns:archdesc/xmlns:dsc/xmlns:c")
            process_inventory_nodes(inventory, 1, root_c_nodes, nil)
            inventory
        end

        def get_doc_keywords()
            root = @xml_doc.xpath("xmlns:ead")
            texts = root.children.map {|node| node.text}
            texts.join(" ")
        end

        def process_inventory_nodes(inventory, depth, nodes, parent_path)
            nodes.each do |node|
                data = {
                    id: node.xpath("string(@id)"),  # this can be null
                    full_path: nil,                 # set below
                    depth: depth,
                    level: node.xpath("string(@level)"),
                    container_text: nil,            # set below
                    scope_content: nil,             # set below
                    label: trim_text(node.xpath("xmlns:did/xmlns:unittitle[1]/text()").text),
                    date: node.xpath("string(xmlns:did/xmlns:unitdate[1])"),
                    subjects: nil,                  # set below
                    creators: nil,                  # set below
                    filename: nil,                  # set below
                    file_description: nil           # set below
                }

                # Get the "digital files" for this inventory node.
                # Note that we get first the NORMALIZEDFILE_ID (e.g. 123.pdf) and then the
                # ORIGINALFILE_ID (e.g. book_contract.pages)
                #
                # TODO: revisit this logic, it works but seems less than optimal
                daos = node.xpath("xmlns:dao")
                daos.each do |dao|
                    href = dao.attributes["href"]
                    role = dao.attributes["role"]
                    if href != nil && role != nil && role.value == "NORMALIZEDFILE_ID"
                        data[:filename] = "#{href.value}"
                        data[:file_description] = "#{href.value}"
                        break
                    end
                end

                daos.each do |dao|
                    href = dao.attributes["href"]
                    role = dao.attributes["role"]
                    if href != nil && role != nil && role.value == "ORIGINALFILE_ID"
                        data[:file_description] = "#{href.value}"
                        break
                    end
                end

                # Get the containers for this inventory node
                containers = node.xpath("xmlns:did/xmlns:container")
                if containers.count > 0
                    # collect the containers into a single string (e.g. "box 1 folder 2")
                    data[:container_text] = ""
                    containers.each do |container|
                        if container.attributes["label"]
                            data[:container_text] += container.attributes["label"].value + " " + container.text + " "
                        end
                    end
                end

                # Get the subjects for this inventory node
                subjects = []
                subject_paths = ["persname", "corpname", "famname", "subject", "genreform"]
                subject_paths.each do |path|
                    values = node.xpath("xmlns:controlaccess/xmlns:#{path}")
                    values.each do |value|
                        subjects << value.text
                    end
                end
                if subjects.count > 0
                    data[:subjects] = subjects
                end

                # Get the creators for this inventory node
                creators = []
                creators_paths = ["persname", "corpname", "famname"]
                creators_paths.each do |path|
                    values = node.xpath("xmlns:did/xmlns:origination/xmlns:#{path}")
                    values.each do |value|
                        creators << value.text
                    end
                end
                if creators.count > 0
                    data[:creators] = creators
                end

                scope_content = node.xpath("string(xmlns:scopecontent)")
                if scope_content != ""
                    # TODO: We should further parse scopecontent when is_file is true
                    data[:scope_content] = trim_text(scope_content)
                end

                if parent_path == nil
                    # top level node
                    data[:full_path] = safe_path(data[:label])
                else
                    # child level node
                    data[:full_path] = parent_path + " / " + safe_path(data[:label])
                end

                # Add node to the inventory...
                inventory << data

                # ...and process its children
                process_inventory_nodes(inventory, depth+1, node.xpath("xmlns:c"), data[:full_path])
            end
        end

        def get_xpath_value(xpath, trim = false)
            values = @xml_doc.xpath(xpath)
            return nil if values.count == 0
            if trim
                trim_text(values[0].text)
            else
                values[0].text
            end
        end

        def get_xpath_values(xpath, trim = false)
            nodes = @xml_doc.xpath(xpath)
            values = []
            nodes.each do |node|
                if trim
                    values << trim_text(node.text)
                else
                    values << node.text
                end
            end
            values.uniq
        end

        def strip_safe(text)
            return nil if text == nil
            text.strip
        end

        def trim_text(text)
            return nil if text == nil
            # remove trailing line breaks, spaces, and periods
            clean = text.chomp.strip.chomp(".")
        end

        # By default the descendent_path field type in Solr uses the
        # forward slash (/) as the delimiter. Make sure the value to use
        # does not contain the delimiter.
        def safe_path(path)
            path.gsub("/", "^^")
        end

        def seq_str(seq)
            seq.to_s.rjust(7,"0")
        end
end


