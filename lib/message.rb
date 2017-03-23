module Message
  class Error
    def self.general(exception)
      "Error: #{exception}"
    end

    def self.too_many_characters
      'Error: Length too large, password length must be below 50 characters'
    end

    def self.username_exists(username)
      "Error: Cannot create new username. Username: #{username} already registered"
    end

    def self.username_not_found(username)
      "Error: Password not found for username #{username}"
    end

    def self.account_not_found(account)
      "Error: Users not found for account #{account}"
    end

    def self.path_not_found(destination)
      "Error: Path '#{destination}' not found"
    end
  end

  class Prompt
    def self.account_name
      "Enter the name of the account connected to the username and generated password\n> "
    end

    def self.username(account)
      "Enter the username for the account #{account}\n> "
    end

    def self.password_length
      "Enter the length of the generated password (max 50)\n> "
    end

    def self.save_to_existing
      "This password is not saved to any account or username. Would you like to save it (y/n)?\n> "
    end
  end

  class Statement
    def self.success(password)
      "Generated password for account: #{password}\nInformation successfully saved locally"
    end

    def self.password_generated(password)
      "Password generated: #{password}"
    end

    def self.display_all_account_data(raw_data)
      raw_data.map do |data|
        "#{data[0]} | #{data[1]}"
      end.unshift('Username | Password').join("\n")
    end

    def self.display_usernames(usernames)
      usernames.unshift('Username').join("\n")
    end

    def self.display_password(password)
      "Password: #{password}"
    end

    def self.export_successful(destination)
      "Account(s) successfully exported to destination '#{destination}'"
    end

    def self.uninstalled
      "RyPass successfully uninstalled."
    end

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
