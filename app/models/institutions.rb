class Institutions
    @@all = nil

    def self.for_code(code)
        all().find {|org| org[:code] == code}
    end

    def self.all()
        # TODO: Create an Institution class rather than keep expanding the hash,
        #       at one point we want to move this to a database anyway. But for
        #       now this would do :)
        @@all ||= begin
            orgs = []

            orgs << {code: "US-RBrHi",
                name: "Bristol Historical & Preservation Society",
                link: "http://www.bhpsri.org/",
                active: "Y", email: "info@bhps.necoxmail.com"}

            brown_sc = {code: "US-RPB", name: "Brown University Special Collections", active: "Y", link: "http://library.brown.edu/about/hay/index.php", email: "hay@brown.edu"}
            orgs << brown_sc

            brown_ar = {code: "US-RPB", name: "Brown University Archives", active: "Y", link: "http://library.brown.edu/collections/archives/", email: "archives@brown.edu"}
            orgs << brown_ar

            orgs << {code: "US-RiBrHMA",
                name: "Haffenreffer Museum of Anthropology", active: "Y",
                link: "http://www.brown.edu/Facilities/Haffenreffer/",
                email: "haffenreffermuseum@brown.edu"}

            orgs << {code: "US-MaBoHNE",
                name: "Historic New England",
                link: "http://www.historicnewengland.org/",
                active: "Y", email: "archives@historicnewengland.org"}

            iyrs = {code: "", name: "IYRS Maritime Library", active: "Y", link: "https://www.iyrs.edu/about/library", email: "ffrost@iyrs.edu"}
            orgs << iyrs

            orgs << {code: "US-RiJaHS",
                name: "Jamestown Historical Society",
                link: "http://www.jamestownhistoricalsociety.org/",
                active: "Y", email: "collections@jamestownhistoricalsociety.org"}

            orgs << {code: "US-RPJCB",
                name: "John Carter Brown Library",
                link: "http://www.brown.edu/Facilities/John_Carter_Brown_Library/",
                active: "Y", email: "JCBL_Archives@Brown.edu"}

            jwu = {code: "US-RPJW", name: "Johnson & Wales University", active: "Y", link: "http://pvd.library.jwu.edu/archives", email: "providencecampuslibrary@jwu.edu"}
            orgs << jwu

            orgs << {code: "US-RNN",
                name: "Naval War College",
                link: "https://usnwc.libguides.com/nhc",
                active: "Y", email: "nhc@usnwc.edu"}

            orgs << {
                code: "",
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
                active: "Y", email: "museumaffairs@newportmansions.org"}

            orgs << {code: "US-PUM",
                name: "Providence Athenaeum",
                link: "https://providenceathenaeum.org/",
                active: "N", email: "info@providenceathenaeum.org"}

            orgs << {code: "US-RiPrCA", name: "Providence City Archives", link: "https://www.providenceri.gov/cityarchives/", active: "N"}

            pc = {
                code: "US-RPPC",
                name: "Providence College Archives and Special Collections",
                active: "Y",
                link: "https://pml.providence.edu/digital-special-collections/",
                email: "pcarchives@providence.edu"}
            orgs << pc

            orgs << {code: "US-RP",
                name: "Providence Public Library",
                link: "http://www.provlib.org/special-collections",
                active: "Y", email: "jgoffin@provlib.org"}

            orgs << {code: "US-RNR",
                name: "Redwood Library and Athenaeum",
                link: "http://www.redwoodlibrary.org/",
                active: "Y", email: "redwood@redwoodlibrary.org"}

            ric = {code: "US-RPRC", name: "Rhode Island College Special Collections", active: "Y", link: "http://library.ric.edu/", email: "digitalcommons@ric.edu"}
            orgs << ric

            rhi = {code: "US-RHi", name: "Rhode Island Historical Society", link: "http://www.rihs.org/libraryhome.htm", active: "Y", email: "reference@rihs.org"}
            orgs << rhi

            risd = {code: "US-RPD", name: "Rhode Island School of Design Archives", active: "Y", link: "http://www.risd.edu/archives.cfm", email: "risdarchives@risd.edu"}
            orgs << risd

            orgs << {code: "US-R-Ar", name: "Rhode Island State Archives", link: "http://sos.ri.gov/archives/", active: "Y", email: "statearchives@sos.ri.gov"}

            rwu = {code: "US-RBrRW", name: "Roger Williams University Archives", active: "Y", link: "http://library.rwu.edu/about/archives.php", email: "archives@rwu.edu"}
            orgs << rwu

            rwusl = {code: "US-RBrRW-L", name: "Roger Williams University School of Law", active: "Y", link: "https://law.rwu.edu/library", email: "lawlibraryhelp@rwu.edu"}
            orgs << rwusl

            salve = {code: "US-RNSRU", name: "Salve Regina Archives and Special Collections", active: "Y", link: "http://library.salve.edu/archives", email: "archives@salve.edu"}
            orgs << salve

            orgs << {code: "US-RiWarSHS", name: "Steamship Historical Society of America", link: "https://www.sshsa.org/", active: "Y", email: "info@sshsa.org"}

            orgs << {code: "US-RiExTM", name: "Tomaquag Museum", link: "https://www.tomaquagmuseum.org/", active: "N", email: "slarose@tomaquagmuseum.org"}

            uri = {code: "US-RUn", name: "University of Rhode Island Special Collections and University Archives", active: "Y", link: "http://www.uri.edu/library/special_collections/", email: "archives@etal.uri.edu"}
            orgs << uri

            orgs << {code: "US-RiCrWLA", name: "Wanderground Lesbian Archive/Library", link: "https://wanderground.org/", active: "Y", email: "info@wanderground.org"}            

            westerly = {code: "US-RWe", name: "Westerly Public Library Special Collections", active: "Y", link: "http://www.westerlylibrary.org/contentmgr/showdetails.php/id/18", email: "reference@westerlylibrary.org"}
            orgs << westerly

            orgs
        end
    end
end