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
  end

  class Statement
    def self.success(password)
      "Generated password for account: #{password}\nInformation successfully saved locally"
    end
  end
end
