# frozen_string_literal: true

module Curp
  module Hash
    CHARACTERS = "0123456789ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

    def self.calculate(curp)
      int_factor = curp.slice(0, 17).split('').map { |c| CHARACTERS.index(c) }

      sum = int_factor.map.with_index { |value, idx| value * (18 - idx) }
                      .reduce(&:+)

      digit = 10 - (sum % 10)

      digit == 10 ? '0' : digit.to_s
    end

  end
end
