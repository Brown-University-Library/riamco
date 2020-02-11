class EadUtils
    def self.valid_id?(id)
        return false if (id || "").length == 0
        match = /[[:alnum:]\-\_\.]*/.match(id)
        # If the resulting match is identical to the received id it means
        # the id includes only valid characters.
        return match[0] == id
    end
end