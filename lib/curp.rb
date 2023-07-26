# frozen_string_literal: true
# typed: strong

require 'yaml'

require_relative "curp/version"
require_relative 'curp/sex'
require_relative 'curp/state'
require_relative 'curp/hash'

# Module to calculate and validate mexican CURPs
module Curp

  EXCEPTIONS = YAML.load_file('lib/special_cases.yml')

  CONSONANTS = "[BCDFGHJKLMNÑPQRSTVWXYZ]"
  NO_CONSONANTS = "[^BCDFGHJKLMNÑPQRSTVWXYZ]"

  def self.valid?(curp)
    given = curp[-1]
    calculated = Curp::Hash.calculate(curp)

    given == calculated
  end

  def self.generate(first_name, first_lastname, second_lastname, date_of_birth, sex, state)
    first_name = fix_symbols(fix_first_name(fix_composite(first_name.upcase)))
    first_lastname = fix_symbols(fix_composite(first_lastname.upcase))
    second_lastname = fix_symbols(fix_composite(second_lastname&.upcase || 'X'))

    elements = []
    elements << first_lastname[0]
    elements << first_inner_vowel(first_lastname)
    elements << second_lastname[0]
    elements << first_name[0]
    elements << date_of_birth.strftime("%y%m%d")
    elements << sex.value
    elements << state.value
    elements << first_inner_consonant(first_lastname)
    elements << first_inner_consonant(second_lastname)
    elements << first_inner_consonant(first_name)
    elements << century_identifier(date_of_birth)

    elements = elements.map { |it| fix_invalid_character(it) }

    pre_curp = fix_forbidden_words(elements.join)

    "#{pre_curp}#{Curp::Hash.calculate(pre_curp)}"
  end

  def self.fix_forbidden_words(word)
    word[1] = "X" if EXCEPTIONS["forbidden_words"].include?(word.slice(0, 4))

    word
  end

  def self.century_identifier(date_of_birth)
    (date_of_birth.year / 1000) < 2 ? "0" : "A"
  end

  def self.first_inner_consonant(word)
    matches = word.match(/^.#{NO_CONSONANTS}*(#{CONSONANTS}).*$/)

    return 'X' unless matches

    matches[1].sub(/[^A-Z]/, "X")
  end

  def self.fix_first_name(first_name)
    names = first_name.split(/\s+/)

    return names.first if names.size == 1

    EXCEPTIONS["skippable_first_names"].include?(names[0]) ? names[1] : names[0]
  end

  def self.fix_symbols(word)
    word.gsub(/Á/, "A")
        .gsub(/É/, "E")
        .gsub(/Í/, "I")
        .gsub(/Ó/, "O")
        .gsub(/[ÚÜ]/, "U")
        .gsub(/\./, "")
  end

  def self.fix_invalid_character(input_character)
    input_character == 'Ñ' ? 'X' : input_character
  end

  def self.first_inner_vowel(word)
    word.match(/^.[#{CONSONANTS}]*(#{NO_CONSONANTS})/)[1].sub(/[^A-Z]/, 'X')
  end

  def self.fix_composite(name)
    elements = name.split
    return name if elements.size < 2

    elements.shift if must_drop_first(elements.first)

    elements.join(" ")
  end

  def self.must_drop_first(element)
    EXCEPTIONS["prepositions"].include?(element) ||
      EXCEPTIONS["conjunctions"].include?(element) ||
      EXCEPTIONS["abbreviations"].include?(element)
  end
end
