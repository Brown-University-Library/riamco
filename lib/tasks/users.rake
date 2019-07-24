require "./app/models/ead_import.rb"

namespace :riamco do
  desc "Creates the initial set of users"
  task :create_users, [:filename] => :environment do |cmd, args|
    if args[:filename] == nil
      abort "No file name was provided"
    end

    if ENV["PASSWORD_SALT"] == nil
      Rails.logger.warn("PASSWORD_SALT is NOT defined")
    end

    File.open(args[:filename]).each_with_index do |line,ix|
      next if ix == 0
      tokens = line.split("\t")
      description = tokens[0]
      prefix = tokens[1]
      username = tokens[2]
      password = tokens[3]
      # contact = tokens[4]
      if username == "" || username == nil
        Rails.logger.info("Skipped empty line #{line}")
      else
        if User.find_by_username(username) == nil
          User.new_user(username, password, prefix, description)
          Rails.logger.info("Created #{username}")
        else
          Rails.logger.info("Skipped #{username} (already exists)")
        end
      end
    end
  end
end
