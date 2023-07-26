# frozen_string_literal: true

module Curp
  # sealed class for Sex enum
  class Sex
    attr_reader :value

    def initialize(value)
      @value = value
    end

    MALE = Sex.new(:H).freeze
    FEMALE = Sex.new(:M).freeze

    def self.values
      constants.map { |c| const_get("Curp::Sex::#{c}") }
    end

    class << self
      private :new
    end

  end
end
