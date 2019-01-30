require "time"
require "nokogiri"
require "./app/models/institutions.rb"

class Ead
    attr_reader :abstract, :biog_hist, :browse_terms, :bulk,
        :creators, :date, :end_year, :extent, :filing_title,
        :filing_title_sort, :id, :institution, :institution_id,
        :keywords, :languages, :repository_name, :scope_content,
        :start_year, :subjects, :title, :title_sort, :title_sort_alpha,
        :title_proper, :title_proper_sort, :unit_id

    def initialize(xml)
        @xml_doc = Nokogiri::XML(xml)
        @abstract = get_doc_abstract()
        @biog_hist = get_doc_biog_hist()
        @browse_terms = get_doc_browse_terms()
        @bulk = get_doc_bulk()
        @creators = get_doc_creators()
        @date = get_doc_date()
        @end_year = get_doc_end_year(@date)
        @extent = get_doc_extent()
        @filing_title = get_doc_filing_title()
        # @filing_title_sort
        @id = get_doc_id()
        @institution_id = get_doc_main_agency_code()
        @institution = get_doc_institution_name(@institution_id)
        @keywords = get_doc_keywords()
        @languages = get_doc_languages()
        @repository_name = get_doc_repository_name()
        @scope_content = get_doc_scope_content()
        @start_year = get_doc_start_year(@date)
        @subjects = get_doc_subjects()
        @title = get_doc_title()
        @title_sort = get_doc_title_sort(@title)
        # # title_sort_alpha
        @title_proper = get_doc_title_proper()
        # # titleproper_sort
        @unit_id = get_doc_unit_id()
        @inventory = get_doc_inventory()
    end

    def to_s()
        "#{@id}, #{@title}"
    end

    def to_solr(with_inventory = false)
        core_doc = {
            abstract_txt_en: self.abstract,
            biog_hist_txt_en: self.biog_hist,
            browse_terms_ss: self.browse_terms,
            bulk_s: self.bulk,
            creators_ss: self.creators,
            date_s: self.date,
            end_year_i: self.end_year,
            extent_s: self.extent,
            filing_title_s: self.filing_title,
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
            _text_: self.keywords
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
        #
        # TODO: I am currently keeping the inventory subjects separate
        #       from the main subjects. Make sure this works as expected
        #       when filtering via facets on the UI.
        seq = 1
        inventory.each do |inv|
            solr_doc = {
                id: core_doc[:id] + "-" + seq_str(seq),
                ead_id_s: core_doc[:id],
                title_s: core_doc[:title_s],                    # finding aid name (for faceting)
                title_txt_en: core_doc[:title_s],               # finding aid name (for searching)
                institution_s: core_doc[:institution_s],
                institution_id_s: core_doc[:institution_id_s],
                timestamp_s: DateTime.now.to_s,
                inventory_container_txt_en: inv[:container_text],
                inventory_scope_content_txt_en: inv[:scope_content],
                inventory_label_txt_en: inv[:label],
                inventory_date_s: inv[:date],
                inventory_descendent_path: inv[:full_path],     # for navigation
                inventory_path_txt_en: inv[:full_path],         # for searching
                inventory_level_s: inv[:level],
                subjects_ss: inv[:subjects],                    # for faceting
                subjects_txts_en: inv[:subjects]                # for searching
            }
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

        def get_doc_id()
            @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:eadid[1]/text()").text
        end

        def get_doc_start_year(date, sep = '/')
            return nil if date == nil
            tokens = date.split(sep)
            return nil if tokens.count != 2
            tokens[0].to_i
        end

        def get_doc_end_year(date, sep = '/')
            return nil if date == nil
            tokens = date.split(sep)
            return nil if tokens.count != 2
            tokens[1].to_i
        end

        def get_doc_bulk()
            normal = get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unitdate[@type='bulk']/@normal")
            return date_range_from_string(normal)
        end

        def get_doc_creators()
            get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:origination/xmlns:persname[@role='creator']")
        end

        def get_doc_title()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unittitle[@type='primary']/text()")
        end

        def get_doc_title_sort(title)
            return nil if title == nil
            title.upcase
        end

        def get_doc_filing_title()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:did/xmlns:unittitle[@type='filing']/text()")
        end

        def get_doc_title_proper()
            title_proper = ""
            titles = @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:filedesc/xmlns:titlestmt/xmlns:titleproper[1]")
            if titles.count > 0
                texts = titles[0].children.map {|c| c.text}
                texts = texts.map {|text| text == "\n" ? nil : text}.compact
                title_proper = trim_text(texts.join(" "))
            end
            title_proper
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

        def get_doc_biog_hist()
            get_xpath_value("xmlns:ead/xmlns:archdesc/xmlns:bioghist/xmlns:p")
        end

        def get_doc_browse_terms()
            get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:subject[@source='riamco']")
        end

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
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:genreform")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:occupation")
            subjects += get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:function")
            subjects
        end

        def get_doc_scope_content()
            # The original RIAMCO code is picking up "scopecontent" nodes in
            # the entire XML document regardless of the path for Solr indexing
            # but only the nodes in the "/ead/archdesc/descgrp/scopecontent"
            # xpath for display in the XSLT. I think we should always honor
            # the xpath. TODO: Check with Karen.
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
                    subjects: nil                   # set below
                }

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

                scope_content = node.xpath("string(xmlns:scopecontent)")
                if scope_content != ""
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

        def get_xpath_value(xpath)
            values = @xml_doc.xpath(xpath)
            return nil if values.count == 0
            values[0].text
        end

        def get_xpath_values(xpath)
            nodes = @xml_doc.xpath(xpath)
            values = []
            nodes.each do |node|
                values << node.text
            end
            values
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


