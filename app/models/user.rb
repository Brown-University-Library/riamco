class User < ActiveRecord::Base
    def self.new_admin(username, password, prefix, description)
        info = {
            username: username,
            password: hash_password(password),
            description: description,
            fileprefix: prefix,
            role: "admin"
        }
        user = User.new(info)
        user.save!
    end

    def self.new_user(username, password, prefix, description)
        info = {
            username: username,
            password: hash_password(password),
            description: description,
            fileprefix: prefix,
            role: "user"
        }
        user = User.new(info)
        user.save!
    end

    def self.authenticate(username, password)
        user = User.find_by_username(username)
        if user != nil && user.password.strip == hash_password(password)
            return true, user
        end
        return false, nil
    end

    def self.hash_password(password)
        salt = ENV["PASSWORD_SALT"] || ""
        Digest::SHA2.hexdigest(password + salt)
    end
end