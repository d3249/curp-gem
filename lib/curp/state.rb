# frozen_string_literal: true

module Curp

  # sealed class for State enum
  class State
    attr_reader :value

    def initialize(value)
      @value = value
    end

    FOREIGN = State.new(:NE).freeze
    AGUASCALIENTES = State.new(:AS).freeze
    BAJA_CALIFORNIA = State.new(:BC).freeze
    BAJA_CALIFORNIA_SUR = State.new(:BS).freeze
    CAMPECHE = State.new(:CC).freeze
    COAHUILA = State.new(:CL).freeze
    COLIMA = State.new(:CM).freeze
    CHIAPAS = State.new(:CS).freeze
    CHIHUAHUA = State.new(:CH).freeze
    CIUDAD_DE_MEXICO = State.new(:DF).freeze
    DURANGO = State.new(:DG).freeze
    GUANAJUATO = State.new(:GT).freeze
    GUERRERO = State.new(:GR).freeze
    HIDALGO = State.new(:HG).freeze
    JALISCO = State.new(:JC).freeze
    ESTADO_DE_MEXICO = State.new(:MC).freeze
    MICHOACAN = State.new(:MN).freeze
    MORELOS = State.new(:MS).freeze
    NAYARIT = State.new(:NT).freeze
    NUEVO_LEON = State.new(:NL).freeze
    OAXACA = State.new(:OC).freeze
    PUEBLA = State.new(:PL).freeze
    QUERETARO = State.new(:QT).freeze
    QUINTANA_ROO = State.new(:QR).freeze
    SAN_LUIS_POTOSI = State.new(:SP).freeze
    SINALOA = State.new(:SL).freeze
    SONORA = State.new(:SR).freeze
    TABASCO = State.new(:TC).freeze
    TAMAULIPAS = State.new(:TS).freeze
    TLAXCALA = State.new(:TL).freeze
    VERACRUZ = State.new(:VZ).freeze
    YUCATAN = State.new(:YN).freeze
    ZACATECAS = State.new(:ZS).freeze

    def self.values
      constants.map { |c| const_get("Curp::State::#{c}") }
    end

    class << self
      private :new
    end
  end
end
