# Namespace all messsaging for RyPass
module Message

  # Handles all error messages for RyPass
  class Error

    # @param [Exception] exception Ruby generated exception
    # @return [String] general Ruby generated exceptions and errors
    def self.general(exception)
      "Error: #{exception}"
    end

    # @return [String] error message if length is too high for generated password
    def self.too_many_characters
      'Error: Length too large, password length must be below 50 characters'
    end

    # @param [String] username username entered by user
    # @return [String] error message if username is already registered in given account
    def self.username_exists(username)
      "Error: Cannot create new username. Username: #{username} already registered"
    end

    # @param [String] username username entered by user
    # @return [String] error message if username is not found in given account
    def self.username_not_found(username)
      "Error: Password not found for username #{username}"
    end

    # @param [String] account account entered by user
    # @return [String] error message if account can not be found at given destination or path
    def self.account_not_found(account)
      "Error: Users not found for account #{account}"
    end

    # @param [String] destination destination entered by user
    # @return [String] error message if destination or path can not be found
    def self.path_not_found(destination)
      "Error: Path '#{destination}' not found"
    end
  end

  # Handles all prompt messages for RyPass
  class Prompt

    # @return [String] prompt user to enter name of account
    def self.account_name
      "Enter the name of the account connected to the username and generated password\n> "
    end

    # @param [String] account account name
    # @return [String] prompt user to enter username
    def self.username(account)
      "Enter the username for the account #{account}\n> "
    end

    # @return [String] prompt user to enter length of generated password
    def self.password_length
      "Enter the length of the generated password (max 50)\n> "
    end

    # @return [String] prompt user whether or not to save generated password with an account and username
    def self.save_to_existing
      "This password is not saved to any account or username. Would you like to save it (y/n)?\n> "
    end
  end

  # Handles all general statements for RyPass
  class Statement

    # @param [Hash] params data used in successful account creation
    # @option params [String] :username username saved in account creation
    # @option params [String] :account name of account in account creation
    # @option params [String] :password generated password for username in the account
    # @option params [String] :destination path where account data was saved
    # @return [String] success message containing all of the data used in the account creation
    def self.success(params)
      "Generated password for username `#{params[:username]}` with account `#{params[:account]}`: #{params[:password]}\n" +
      "Information successfully saved locally to `#{params[:destination]}`"
    end

    # @param [String] password generated password
    # @return [String] generated password
    def self.password_generated(password)
      "Password generated: #{password}"
    end

    # @param [Array] raw_data raw CSV data
    # @return [String] list of all raw data loaded from CSV
    def self.display_all_account_data(raw_data)
      raw_data.map do |data|
        "#{data[0]} | #{data[1]}"
      end.unshift('Username | Password').join("\n")
    end

    # @param [Array] usernames all usernames saved in CSV
    # @return [String] list of usernames saved in CSV
    def self.display_usernames(usernames)
      usernames.unshift('Username').join("\n")
    end

    # @param [String] password password loaded from CSV
    # @return [String] password loaded from CSV
    def self.display_password(password)
      "Password: #{password}"
    end

    # @param [String] destination destination file path of exported data
    # @return [String] message following successful export of data
    def self.export_successful(destination)
      "Account(s) successfully exported to destination '#{destination}'"
    end

    # @return [String] uninstalling RyPass was successful
    def self.uninstalled
      "RyPass successfully uninstalled."
    end

    # @return [String] list of RyPass commands
    def self.command_list
      "The following commands are available:\n" +
      "\s - `new` or `n` - Generate a password for an account and username attached to that account.\n" +
      "\s - `generate` or `g` - Generates a random password and displays it. Password is not attached to an account, username, or saved in the system.\n" +
      "\s - `account` or `a` - Displays usernames and passwords attached to account.\n" +
      "\s\s\sSecondary Actions:\n" +
      "\s\s\s - `A` or `--all` displays all usernames and passwords.\n" +
      "\s\s\s - `-U` or `--usernames` displays only usernames attached to account.\n" +
      "\s\s\s - `-P` or `--get-password` displays password for given username in account.\n" +
      "\s - `export` or `e` - Exports all accounts, including usernames and passwords, to a given path.\n" +
      "\s - `uninstall` or `U` - Uninstall RyPass. All csvs and data will NOT be deleted and will still be accessible in the given directory.\n" +
      "The following commands are available:\n" +
      "\s - `--account=` or `-a` - Name of account\n" +
      "\s - `--username=` or `-u` - Name of username\n" +
      "\s - `--destination=` or `-d` - Path of destination for csv\n" +
      "\s - `--length=` or `-l` - Length of generated password (12 character default)\n" +
      "\s - `--path=` or `-p` - Path of RyPass data\n"
    end
  end
end
