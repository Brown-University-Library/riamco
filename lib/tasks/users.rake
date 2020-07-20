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

  desc "Creates a new admin user"
  task :user_new_admin, [:user, :pass] => :environment do |cmd, args|
    username = args[:user]
    password = args[:pass]
    if username == nil || password == nil
      abort "No username or password was provided"
    end

    if ENV["PASSWORD_SALT"] == nil
      puts "PASSWORD_SALT is NOT defined"
    end

    if User.find_by_username(username) != nil
      abort "User #{username} already exists"
    end

    User.new_admin(username, password, "US-RPB", "Admin user #{username}")
    puts "Created admin user: #{username}"
  end

  desc "Creates a new reading room user"
  task :user_new_rr, [:user, :pass] => :environment do |cmd, args|
    username = args[:user]
    password = args[:pass]
    if username == nil || password == nil
      abort "No username or password was provided"
    end

    if ENV["PASSWORD_SALT"] == nil
      puts "PASSWORD_SALT is NOT defined"
    end

    if User.find_by_username(username) != nil
      abort "User #{username} already exists"
    end

    User.new_reading_room_user(username, password)
    puts "Created reading room user: #{username}"
  end

  desc "Exports the raw data from the Users table to the console as tab-separated values"
  task :export_users => :environment do |cmd, args|
    User.all.each do |u|
      puts "#{u.id}\t#{u.username}\t#{u.password}\t#{u.description}\t#{u.fileprefix}\t#{u.role}\t#{u.created_at}\t#{u.updated_at}"
    end
  end

  desc "Imports raw data from a TSV file into the Users table"
  task :import_users, [:filename] => :environment do |cmd, args|
    if args[:filename] == nil
      abort "No file name was provided"
    end
    File.open(args[:filename]).each do |line|
      tokens = line.split("\t")
      id = tokens[0]
      username = tokens[1]
      password = tokens[2]
      description = tokens[3]
      prefix = tokens[4]
      role = tokens[5]
      created_at = tokens[6]
      updated_at = tokens[7]
      User.new_user_raw(id, username, password, description, prefix, role, created_at, updated_at)
      Rails.logger.info("Created #{username}")
    end
  end
end
