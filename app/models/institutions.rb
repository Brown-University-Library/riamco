class Institutions
    @@all = nil

    def self.for_code(code)
        all().find {|org| org[:code] == code}
    end

    def self.all()
        # TODO: Create an Institution class rather than keep expanding the hash,
        #       at one poin we want to move this to a database anyway. But for
        #       now this would do :)
        @@all ||= begin
            orgs = []

            orgs << {code: "US-RBrHi",
                name: "Bristol Historical & Preservation Society",
                link: "http://www.bhpsri.org/",
                active: "Y", email: "info@bhps.necoxmail.com"}

            brown = {code: "US-RPB", name: "Brown University Library", active: "Y", email: nil, contacts: []}
            brown[:contacts] << {text: "Brown University Special Collections", link: "http://library.brown.edu/about/hay/index.php", email: "hay@brown.edu"}
            brown[:contacts] << {text: "Brown University Archives", link: "http://library.brown.edu/collections/archives/", email: "archives@brown.edu"}
            orgs << brown

            orgs << {code: "US-RiBrHMA",
                name: "Haffenreffer Museum of Anthropology", active: "Y",
                link: "http://www.brown.edu/Facilities/Haffenreffer/",
                email: "haffenreffermuseum@brown.edu"}

            orgs << {code: "US-MaBoHNE",
                name: "Historic New England",
                link: "http://www.historicnewengland.org/",
                active: "Y", email: "archives@historicnewengland.org"}

            orgs << {code: "US-RiJaHS", 
                name: "Jamestown Historical Society", 
                link: "http://www.jamestownhistoricalsociety.org/",
                active: "Y", email: "collections@jamestownhistoricalsociety.org"}

            orgs << {code: "US-RPJCB", 
                name: "John Carter Brown Library", 
                link: "http://www.brown.edu/Facilities/John_Carter_Brown_Library/",
                active: "Y", email: "JCBL_Archives@Brown.edu"}

            # orgs << {code: "US-RPJW", name: "Johnson & Wales University", active: "N"}
            orgs << {code: "US-RNN", 
                name: "Naval War College", 
                link: "http://www.usnwc.edu/Departments---Colleges/Library/RightsideLinks/Naval-Historical-Collection.aspx/", 
                active: "Y", email: "nhc@usnwc.edu"}

            orgs << {
                code: "XX", 
                name: "Newport Art Museum", 
                link: "http://www.newportartmuseum.org/",
                active: "N"}

            orgs << {code: "US-RNHi", 
                name: "Newport Historical Society", 
                link: "http://www.newporthistorical.org/",
                active: "Y", email: "research@newporthistory.org"}

            orgs << {code: "US-RNk", 
                name: "North Kingstown Free Library", 
                link: "http://www.nklibrary.org/",
                active: "Y", email: "nkiref@nklibrary.org"}

            orgs << {code: "US-RiNpPs", 
                name: "Preservation Society of Newport County", 
                link: "http://www.newportmansions.org/",
                active: "Y", email: "info@newportmansions.org"}

            orgs << {code: "US-PUM", 
                name: "Providence Athenaeum", 
                link: "https://providenceathenaeum.org/",
                active: "N", email: "info@providenceathenaeum.org"}

            orgs << {code: "US-RiPrCA", name: "Providence City Archives", link: "https://www.providenceri.com/archives", active: "N"}

            pc = {code: "US-RPPC", name: "Providence College", active: "Y", email: "", contacts: []}
            pc[:contacts] << {text: "Providence College Special and Archival Collections", link: "http://www.providence.edu/library/spcol/", email: "pml.specoll@providence.edu"}
            orgs << pc

            orgs << {code: "US-RP", 
                name: "Providence Public Library", 
                link: "http://www.provlib.org/special-collections",
                active: "Y", email: "jgoffin@provlib.org"}

            orgs << {code: "US-RNR", 
                name: "Redwood Library and Athenaeum", 
                link: "http://www.redwoodlibrary.org/",
                active: "Y", email: "redwood@redwoodlibrary.org"}

            ric = {code: "US-RPRC", name: "Rhode Island College", active: "Y", contacts: []}
            ric[:contacts] << {text: "Rhode Island College Special Collections", link: "http://library.ric.edu/", email: "digitalcommons@ric.edu"}
            orgs << ric

            orgs << {code: "US-RHi", 
                name: "Rhode Island Historical Society", 
                link: "http://www.rihs.org/libraryhome.htm",
                active: "Y", email: "reference@rihs.org"}

            risd = {code: "US-RPD", name: "Rhode Island School of Design", active: "Y", contacts: []}
            risd[:contacts] << {text: "Rhode Island School of Design Archives", link: "http://www.risd.edu/archives.cfm", email: "risdarchives@risd.edu"}
            orgs << risd

            orgs << {code: "US-R-Ar", name: "Rhode Island State Archives", link: "http://sos.ri.gov/archives/", active: "Y", email: "statearchives@sos.ri.gov"}

            rwu = {code: "US-RBrRW", name: "Roger Williams University", active: "Y", contacts: []}
            rwu[:contacts] << {text: "Roger Williams University Archives", link: "http://library.rwu.edu/about/archives.php", email: "archives@rwu.edu"}
            orgs << rwu

            # orgs << {code: "US-RBrRW-L", name: "Roger Williams University School of Law", active: "N"}

            salve = {code: "US-RNSRU", name: "Salve Regina University", active: "Y", contacts: []}
            salve[:contacts] << {text: "Salve Regina University Archives", link: "http://library.salve.edu/archives/", email: "archives@salve.edu"}
            salve[:contacts] << {text: "Salve Regina University Special Collections", link: "http://library.salve.edu/spec-col/"}
            orgs << salve

            orgs << {code: "US-RiExTM", name: "Tomaquag Museum", link: "https://www.tomaquagmuseum.org/", active: "N", email: "slarose@tomaquagmuseum.org"}

            uri = {code: "US-RUn", name: "University of Rhode Island", active: "Y", contacts: []}
            uri[:contacts] << {text: "University of Rhode Island Special Collections and University Archives", link: "http://www.uri.edu/library/special_collections/", email: "archives@etal.uri.edu"}
            orgs << uri

            westerly = {code: "US-RWe", name: "Westerly Public Library", active: "Y", contacts: []}
            westerly[:contacts] << {text: "Westerly Public Library Special Collections", link: "http://www.westerlylibrary.org/contentmgr/showdetails.php/id/18", email: "reference@westerlylibrary.org"}
            orgs << westerly

            orgs
        end
    end
end