require "#{PATH}/lib/string"

# Handles all password generation
class Password

  # 2-D array of all possible characters that can be used in a password
  CHARACTERS = [['!','$','%','+','/','=','@','~'],
                ('0'..'9').to_a,
                ('a'..'z').to_a]

  # Generate a new password of given length
  #
  # @param [Integer] length length of characters of generated password
  # @return [String] generated password
  def generate_new(length)
    generated = []
    length.times { generated << Password.random_character }
    sanitize(generated.join(''))
  end

  # Sanitize password to ensure there are all unique characters and there is at
  # least one special character, capital letter, lowercase letter, and number
  #
  # @param [String] password pre-sanitized/ initially generated password
  # @return [String] sanitized and completely unique password
  def sanitize(password)
    password.add_special!(CHARACTERS[0]) if password.scan(/[!@#$%^&*()]/).empty?
    password.add_number!(CHARACTERS[1]) if password.scan(/[0-9]/).empty?
    password.add_capital_letter!(CHARACTERS[2]) if password.scan(/[A-Z]/).empty?
    password.unique_chars!
    sanitize(password) unless is_sanitary?(password)
    return password
  end

  # @return [String] a random character from the constant CHARACTERS
  def self.random_character
    character_set = CHARACTERS[rand(3)]
    character_set[rand(character_set.length)]
  end

  # Get a unique character that is not in current password
  #
  # @param [String] password generated password
  # @return [String] unique character that is not present in password
  def self.new_character(password)
    CHARACTERS.each do |set|
      set.each do |char|
        return char unless password.include?(char)
        return char.upcase unless password.include?(char.upcase)
      end
    end
  end

  private
    def is_sanitary?(password)
      password.scan(/[!@#$%^&*()]/).count > 0 &&
      password.scan(/[0-9]/).count > 0 &&
      password.scan(/[A-Z]/).count > 0 &&
      password.scan(/[a-z]/).count > 0 &&
      is_all_unique_characters?(password)
    end

    def is_all_unique_characters?(password)
      password.length.times do |i|
        password.chars.each_with_index do |char, index|
          unless i == index
            return false if password[i] == char
          end
        end
      end
      true
    end
end
