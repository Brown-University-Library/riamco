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
            brown[:contacts] << {text: "Brown University Special Collections", email: "hay@brown.edu"}
            brown[:contacts] << {text: "Brown University Archives", email: "archives@brown.edu"}
            orgs << brown

            orgs << {code: "US-RiBrHMA",
                name: "Haffenreffer Museum of Anthropology", active: "Y",
                link: "http://www.brown.edu/Facilities/Haffenreffer/",
                email: "haffenreffermuseum@brown.edu"}

            orgs << {code: "US-MaBoHNE",
                name: "Historic New England",
                link: "http://www.historicnewengland.org/",
                active: "Y", email: "archives@historicnewengland.org"}

            orgs << {code: "US-RiJaHS", name: "Jamestown Historical Society", active: "Y", email: "collections@jamestownhistoricalsociety.org"}
            orgs << {code: "US-RPJCB", name: "John Carter Brown Library", active: "Y", email: "JCBL_Archives@Brown.edu"}
            orgs << {code: "US-RPJW", name: "Johnson & Wales University", active: "N"}
            orgs << {code: "US-RNN", name: "Naval War College", active: "Y", email: "nhc@usnwc.edu"}
            # orgs << {code: "XX", name: "Newport Art Museum", active: "N"}
            orgs << {code: "US-RNHi", name: "Newport Historical Society", active: "Y", email: "research@newporthistory.org"}
            orgs << {code: "US-RNk", name: "North Kingstown Free Library", active: "Y", email: "nkiref@nklibrary.org"}
            orgs << {code: "US-RiNpPs", name: "Preservation Society of Newport County", active: "Y", email: "info@newportmansions.org"}
            orgs << {code: "US-PUM", name: "Providence Athenaeum", active: "N", email: "info@providenceathenaeum.org"}
            orgs << {code: "US-RiPrCA", name: "Providence City Archives", active: "N"}

            pc = {code: "US-RPPC", name: "Providence College", active: "Y", email: "", contacts: []}
            pc[:contacts] << {text: "Providence College Special and Archival Collections", email: "pml.specoll@providence.edu"}
            orgs << pc

            orgs << {code: "US-RP", name: "Providence Public Library", active: "Y", email: "jgoffin@provlib.org"}
            orgs << {code: "US-RNR", name: "Redwood Library and Athenaeum", active: "Y", email: "redwood@redwoodlibrary.org"}

            ric = {code: "US-RPRC", name: "Rhode Island College", active: "Y", contacts: []}
            ric[:contacts] << {text: "Rhode Island College Special Collections", email: "digitalcommons@ric.edu"}
            orgs << ric

            orgs << {code: "US-RHi", name: "Rhode Island Historical Society", active: "Y", email: "reference@rihs.org"}

            risd = {code: "US-RPD", name: "Rhode Island School of Design", active: "Y", contacts: []}
            risd[:contacts] << {text: "Rhode Island School of Design Archives", email: "risdarchives@risd.edu"}
            orgs << risd

            orgs << {code: "US-R-Ar", name: "Rhode Island State Archives", active: "Y", email: "statearchives@sos.ri.gov"}

            rwu = {code: "US-RBrRW", name: "Roger Williams University", active: "Y", contacts: []}
            rwu[:contacts] << {text: "Roger Williams University Archives", email: "archives@rwu.edu"}
            orgs << rwu

            orgs << {code: "US-RBrRW-L", name: "Roger Williams University School of Law", active: "N"}

            salve = {code: "US-RNSRU", name: "Salve Regina University", active: "Y", contacts: []}
            salve[:contacts] << {text: "Salve Regina University Archives", email: "archives@salve.edu"}
            salve[:contacts] << {text: "Salve Regina University Special Collections", email: ""}
            orgs << salve

            orgs << {code: "US-RiExTM", name: "Tomaquag Museum", active: "N", email: "slarose@tomaquagmuseum.org"}

            uri = {code: "US-RUn", name: "University of Rhode Island", active: "Y", contacts: []}
            uri[:contacts] << {text: "University of Rhode Island Special Collections and University Archives", email: "archives@etal.uri.edu"}
            orgs << uri

            westerly = {code: "US-RWe", name: "Westerly Public Library", active: "Y", contacts: []}
            westerly[:contacts] << {text: "Westerly Public Library Special Collections", email: "reference@westerlylibrary.org"}
            orgs << westerly

            orgs
        end
    end
end