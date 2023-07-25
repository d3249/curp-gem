# frozen_string_literal: true

require 'minitest/autorun'
require_relative '' '../../lib/curp/hash'

describe 'Curp::Hash' do

  it 'uses unly the first 17 characters (the rest are irrelevant)' do
    str1 = 'AAAA901231HDFBBB0'
    str2 = 'AAAA901231HDFBBB0X'

    assert_equal Curp::Hash.calculate(str1), Curp::Hash.calculate(str2)
  end
end
