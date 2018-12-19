class Institutions
    @@all = nil

    def self.for_code(code)
        all().find {|org| org[:code] == code}
    end

    def self.all()
        @@all ||= begin
            orgs = []
            orgs << {code: "US-RBrHi", name: "Bristol Historical & Preservation Society", active: "Y"}
            orgs << {code: "US-RPB", name: "Brown University Library", active: "Y"}
            orgs << {code: "US-RiBrHMA", name: "Haffenreffer Museum of Anthropology", active: "Y"}
            orgs << {code: "US-MaBoHNE", name: "Historic New England", active: "Y"}
            orgs << {code: "US-RiJaHS", name: "Jamestown Historical Society", active: "Y"}
            orgs << {code: "US-RPJCB", name: "John Carter Brown Library", active: "Y"}
            orgs << {code: "US-RPJW", name: "Johnson & Wales University", active: "N"}
            orgs << {code: "US-RNN", name: "Naval War College", active: "Y"}
            # orgs << {code: "XX", name: "Newport Art Museum", active: "N"}
            orgs << {code: "US-RNHi", name: "Newport Historical Society", active: "Y"}
            orgs << {code: "US-RNk", name: "North Kingstown Free Library", active: "Y"}
            orgs << {code: "US-RiNpPs", name: "Preservation Society of Newport County", active: "Y"}
            orgs << {code: "US-PUM", name: "Providence Athenaeum", active: "N"}
            orgs << {code: "US-RiPrCA", name: "Providence City Archives", active: "N"}
            orgs << {code: "US-RPPC", name: "Providence College", active: "Y"}
            orgs << {code: "US-RP", name: "Providence Public Library", active: "Y"}
            orgs << {code: "US-RNR", name: "Redwood Library and Athenaeum", active: "Y"}
            orgs << {code: "US-RPRC", name: "Rhode Island College", active: "Y"}
            orgs << {code: "US-RHi", name: "Rhode Island Historical Society", active: "Y"}
            orgs << {code: "US-RPD", name: "Rhode Island School of Design", active: "Y"}
            orgs << {code: "US-R-Ar", name: "Rhode Island State Archives", active: "Y"}
            orgs << {code: "US-RBrRW", name: "Roger Williams University", active: "Y"}
            orgs << {code: "US-RBrRW-L", name: "Roger Williams University School of Law", active: "N"}
            orgs << {code: "US-RNSRU", name: "Salve Regina University", active: "Y"}
            orgs << {code: "US-RiExTM", name: "Tomaquag Museum", active: "N"}
            orgs << {code: "US-RUn", name: "University of Rhode Island", active: "Y"}
            orgs << {code: "US-RWe", name: "Westerly Public Library", active: "Y"}
            orgs
        end
    end
end