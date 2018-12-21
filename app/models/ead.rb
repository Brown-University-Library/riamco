require "time"
require "nokogiri"
require "./app/models/institutions.rb"

class Ead
    attr_reader :abstract, :biog_hist, :browse_terms, :bulk,
        :creators, :date, :end_year, :extent, :filing_title,
        :filing_title_sort, :id, :institution, :institution_id,
        :keyword, :languages, :repository_name, :scope_content,
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
        # @keyword Should this be a copy field in Solr instead?
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
        @inventory = nil
    end

    def to_s()
        "#{@id}, #{@title}"
    end

    def to_solr()
        # For now create a single Solr document but once we include the inventory
        # we should create multiple documents (once for each level)
        solr_data = {
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
            institution_s: self.institution,
            institution_id_s: self.institution_id,
            languages_ss: self.languages,
            title_s: self.title,
            title_sort_s: self.title_sort,
            title_proper_s: self.title_proper,
            timestamp_s: DateTime.now.to_s,
            scope_content_txts_en: self.scope_content,
            start_year_i: self.start_year,
            repository_name_s: self.repository_name,
            subjects_ss: self.subjects,
            unit_id_s: self.unit_id
        }
        solr_data
    end

    def inventory()
        @inventory ||= get_doc_inventory()
    end

    private
        def get_doc_id()
            @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:eadid[1]/text()").text
        end

        def get_doc_start_year(date)
            return nil if date == nil
            tokens = date.split("-")
            return nil if tokens.count != 2
            tokens[0].to_i
        end

        def get_doc_end_year(date)
            return nil if date == nil
            tokens = date.split("-")
            return nil if tokens.count != 2
            tokens[1].to_i
        end

        def get_doc_bulk()
            get_xpath_value("xmlns:ead/xmlns:eadheader/xmlns:filedesc/xmlns:titlestmt/xmlns:titleproper/xmlns:date/@normal")
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
            titles = @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:filedesc/xmlns:titlestmt/xmlns:titleproper/text()")
            if titles.count > 0
                title_proper += titles[0].text
            end
            year = @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:filedesc/xmlns:titlestmt/xmlns:titleproper/xmlns:date/@normal")
            if year.count > 0
                title_proper += " " + year[0].value  # use "value" because it's an attribute
            end
            title_proper
        end

        def get_doc_languages()
            langs = []
            doc_langs = @xml_doc.xpath("xmlns:ead/xmlns:eadheader/xmlns:profiledesc/xmlns:langusage/xmlns:language")
            doc_langs.each do |l|
                langs << trim_text(l.text)
            end
            langs.uniq
        end

        def get_doc_main_agency_code()
            get_xpath_value("xmlns:ead/xmlns:eadheader/xmlns:eadid[1]/@mainagencycode")
        end

        def get_doc_date()
            get_xpath_value("xmlns:ead/xmlns:eadheader/xmlns:filedesc/xmlns:titlestmt/xmlns:titleproper/xmlns:date/text()")
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
            # This is incomplete, we pick subjects from other nodes too.
            # TODO: look at the original indexing code.
            get_xpath_values("xmlns:ead/xmlns:archdesc/xmlns:descgrp/xmlns:controlaccess/xmlns:subject")
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
            puts "calculating inventory"
            # TODO: this should be changed to a recursive method
            # to walk each level in order and be able to build the
            # path series/subseries/item+file.
            #
            # As-is seems to work since it's picking up the C nodes
            # in the order they are on the XML, but I am not sure
            # this will be consistent.
            inventory = []
            c_nodes = @xml_doc.xpath("//xmlns:c")
            c_nodes.each do |node|

                label = ""
                unit_title = node.xpath("xmlns:did/xmlns:unittitle/text()")
                if unit_title.count > 0
                    label += unit_title[0].text
                end

                unit_id = node.xpath("xmlns:did/xmlns:unitid/text()")
                if unit_id.count > 0
                    label += " " + unit_id[0].text
                end

                inv = {
                    id: node["id"],
                    level: node["level"],
                    label: label
                }
                inventory << inv
            end
            inventory
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
end


