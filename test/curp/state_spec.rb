# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/curp/state'

describe 'Curp::State' do
  it 'has exactly 33 values' do
    assert_equal 33, Curp::State.values.size
  end

  it 'has all expected values' do
    expected_pairs = {
      FOREIGN: :NE,
      AGUASCALIENTES: :AS,
      BAJA_CALIFORNIA: :BC,
      BAJA_CALIFORNIA_SUR: :BS,
      CAMPECHE: :CC,
      COAHUILA: :CL,
      COLIMA: :CM,
      CHIAPAS: :CS,
      CHIHUAHUA: :CH,
      CIUDAD_DE_MEXICO: :DF,
      DURANGO: :DG,
      GUANAJUATO: :GT,
      GUERRERO: :GR,
      HIDALGO: :HG,
      JALISCO: :JC,
      ESTADO_DE_MEXICO: :MC,
      MICHOACAN: :MN,
      MORELOS: :MS,
      NAYARIT: :NT,
      NUEVO_LEON: :NL,
      OAXACA: :OC,
      PUEBLA: :PL,
      QUERETARO: :QT,
      QUINTANA_ROO: :QR,
      SAN_LUIS_POTOSI: :SP,
      SINALOA: :SL,
      SONORA: :SR,
      TABASCO: :TC,
      TAMAULIPAS: :TS,
      TLAXCALA: :TL,
      VERACRUZ: :VZ,
      YUCATAN: :YN,
      ZACATECAS: :ZS
    }

    expected_pairs.each { |key, value| assert_equal value, Object.const_get("Curp::State::#{key}").value }
  end

end
