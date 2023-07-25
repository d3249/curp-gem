# frozen_string_literal: true
# typed: strong

require_relative "curp/version"
require_relative 'curp/sex'
require_relative 'curp/state'
require_relative 'curp/hash'

# Module to calculate and validate mexican CURPs
module Curp

  class Error < StandardError; end

  SKIPPABLE_FIRST_NAMES = %w(JOSE JOSÉ J J. MARÍA MARIA MA MA.).freeze

  def self.generate(first_name, first_lastname, second_lastname, date_of_birth, sex, state)
    first_name = fix_symbols(fix_first_name(first_name.upcase))
    first_lastname = fix_symbols(first_lastname.upcase)
    second_lastname = fix_symbols(second_lastname.upcase)

    elements = []
    elements << first_lastname[0]
    elements << nth_vowel(first_lastname)
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

    pre_curp = elements.join

    "#{pre_curp}#{Curp::Hash.calculate(pre_curp)}"
  end

  def self.century_identifier(date_of_birth)
    (date_of_birth.year / 1000) < 2 ? "0" : "A"
  end

  def self.first_inner_consonant(word)
    matches = word.match(/^.[AEIOU]*([^AEIOU]).*$/)

    matches ? matches[1] : "X"
  end

  def self.fix_first_name(first_name)
    names = first_name.split(/\s+/)

    return names.first if names.size == 1

    SKIPPABLE_FIRST_NAMES.include?(names[0]) ? names[1] : names[0]
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
    case input_character
    when "Ñ"
      "N"
    else
      input_character
    end
  end

  def self.nth_vowel(word, nth: 0)
    word.match(/[AEIOU]/)[nth]
  end
end
