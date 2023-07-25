# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../lib/curp/sex"

describe "Curp::Sex" do
  it "has exactly two values" do
    assert_equal 2, Curp::Sex.values.size
  end

  it "has MALE and FEMALE values" do
    values = Curp::Sex.values.map(&:value)
    assert values.include? :M
    assert values.include? :F
  end
end
