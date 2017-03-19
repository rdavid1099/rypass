class String
  def add_special!(special_chars)
    sanitized = self
    sanitized[rand(sanitized.length)] = special_chars[rand(special_chars.length)]
    self.replace(sanitized)
  end

  def add_number!(numbers)
    sanitized = self
    sanitized[rand(sanitized.length)] = numbers[rand(numbers.length)]
    self.replace(sanitized)
  end

  def add_capital_letter!(letters)
    sanitized = self
    sanitized[rand(sanitized.length)] = letters[rand(letters.length)].upcase
    self.replace(sanitized)
  end

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
