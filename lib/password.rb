require './lib/string'

class Password
  CHARACTERS = [['!','@','$','%','^','&','*','(',')'],
                ('0'..'9').to_a,
                ('a'..'z').to_a]

  def generate_new(length)
    generated = []
    length.times { generated << Password.random_character }
    sanitize(generated.join(''))
  end

  def sanitize(password)
    password.add_special!(CHARACTERS[0]) if password.scan(/[!@#$%^&*()]/).empty?
    password.add_number!(CHARACTERS[1]) if password.scan(/[0-9]/).empty?
    password.add_capital_letter!(CHARACTERS[2]) if password.scan(/[A-Z]/).empty?
    password.unique_chars!
    sanitize(password) unless is_sanitary?(password)
    return password
  end

  def self.random_character
    character_set = CHARACTERS[rand(3)]
    character_set[rand(character_set.length)]
  end

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
