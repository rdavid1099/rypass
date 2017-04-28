# Extends Ruby String Class to handle special bang methods for password generating
class String
  # Add a special character to given string
  #
  # @param [Array] special_chars list of special characters
  # @return [String] replaces self with a special character in the place another random character
  def add_special!(special_chars)
    sanitized = self
    sanitized[rand(sanitized.length)] = special_chars[rand(special_chars.length)]
    self.replace(sanitized)
  end

  # Add a number to given string
  #
  # @param [Array] numbers list of numbers, preferably single digits (0-9)
  # @return [String] replaces self with a number in the place another random character
  def add_number!(numbers)
    sanitized = self
    sanitized[rand(sanitized.length)] = numbers[rand(numbers.length)]
    self.replace(sanitized)
  end

  # Add a capital letter to given string
  #
  # @param [Array] letters list of letters, preferably entire lowercase alphabet (a-z)
  # @return [String] replaces self with an upper case letter in the place another random character
  def add_capital_letter!(letters)
    sanitized = self
    sanitized[rand(sanitized.length)] = letters[rand(letters.length)].upcase
    self.replace(sanitized)
  end

  # Make string entirely unique characters
  #
  # @return [String] replaces self with a string that is made up of all unique characters
  def unique_chars!
    sanitized = self
    sanitized.length.times do |i|
      sanitized.chars.each_with_index do |char, index|
        unless i == index
          sanitized[i] = Password.new_character(sanitized) if sanitized[i] == char
        end
      end
    end
    self.replace(sanitized)
  end
end
