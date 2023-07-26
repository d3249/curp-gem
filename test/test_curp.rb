# frozen_string_literal: true

require "test_helper"

class TestCurp < Minitest::Test

  module Helper
    EXPECTED_CURP = "PERJ901231MDFRDN04"

    DUMMY_DATA = {
      first_name: "Juan",
      first_lastname: "Pérez",
      second_lastname: "Rodríguez",
      date_of_birth: Date.parse("1990-12-31"),
      sex: Curp::Sex::MALE,
      state: Curp::State::CIUDAD_DE_MEXICO
    }.freeze

    def self.curp_builder(first_name: DUMMY_DATA[:first_name],
                          first_lastname: DUMMY_DATA[:first_lastname],
                          second_lastname: DUMMY_DATA[:second_lastname],
                          date_of_birth: DUMMY_DATA[:date_of_birth],
                          sex: DUMMY_DATA[:sex],
                          state: DUMMY_DATA[:state])

      Curp.generate(first_name, first_lastname, second_lastname, date_of_birth, sex, state)
    end
  end

  describe "basic behaviour" do
    it "must test that it has a version number" do
      refute_nil ::Curp::VERSION
    end
  end

  describe "CURP calculation" do
    before { @curp = Helper.curp_builder }

    it "must be exactly 18 characters long" do
      assert_equal 18, @curp.size
    end

    it "must be all uppercase" do
      assert_equal @curp.upcase, @curp
    end
  end

  describe 'base case' do
    before { @curp = Helper.curp_builder }

    it "must start with the first letter of the first lastname" do
      assert_equal "P", @curp[0]
    end

    it "must have the first inner vowel of the first lastname as second character" do
      assert_equal "E", @curp[1]
      assert_equal "E", Helper.curp_builder(first_lastname: 'Aegis')[1]
    end

    it "must have the first letter of the second lastname as third character" do
      assert_equal "R", @curp[2]
    end

    it "must have the first letter of the first name as fourth character" do
      assert_equal "J", @curp[3]
    end

    it "must have the correct format for the date of birth" do
      assert_equal "901231", @curp.slice(4, 6)
    end
    it "shows the sex properly" do
      assert_equal "M", @curp[10]
    end

    it "shows the state properly" do
      assert_equal "DF", @curp.slice(11, 2)
    end

    it "shows the state properly" do
      assert_equal "DF", @curp.slice(11, 2)
    end

    it "must have first inner consonants of first lastname, second lastname and first name at positions 13 - 15" do
      assert_equal "RDN", @curp.slice(13, 3)
    end

    it "must have be 0 at position 16 if birt date is in 20th century" do
      assert_equal "0", @curp[16]
    end

    it "must have be A at position 16 if birt date is in 21th century" do
      assert_equal "A", Helper.curp_builder(date_of_birth: Date.parse("2001-12-31"))[16]
    end

    it "must assign the last digit correctly" do
      assert_equal "4", @curp[17]
    end

  end

  describe "exception cases 'Ñ'" do
    it "must replace Ñ with X for the first character of any of the name elements" do
      assert_equal "X", Helper.curp_builder(first_name: "Ñandu")[3]
      assert_equal "X", Helper.curp_builder(first_lastname: "Ñañez")[0]
      assert_equal "X", Helper.curp_builder(second_lastname: "Ñañez")[2]
    end

    it "must replace Ñ with X for characters at 14 and 15" do
      assert_equal "X", Helper.curp_builder(first_lastname: "Oñate")[13]
      assert_equal "X", Helper.curp_builder(second_lastname: "Oñate")[14]
    end
  end

  describe 'exception cases, composite names' do
    it "must use the second first name if it's a composite name and it's on the forbidden list" do
      skippable_first_names = { "María Victoria" => "V", "José Manuel" => "M", "J Manuel" => "M", "J. Manuel" => "M", "Ma Victoria" => "V", "Ma. Victoria" => "V" }

      skippable_first_names.each do |name, expected_character|
        assert_equal expected_character, Helper.curp_builder(first_name: name)[3]
      end
    end

    it "must use the first name if it's simple even if it's forbidden" do

      skippable_first_names = { "María" => "M", "José" => "J", "J" => "J", "J." => "J", "Ma" => "M", "Ma." => "M" }

      skippable_first_names.each do |name, expected_character|
        assert_equal expected_character, Helper.curp_builder(first_name: name)[3]
      end
    end
  end

  describe 'exception cases, non alphabetic characters in name' do
    it 'should replace a non alphabetical character with an X' do
      assert_equal 'DXRJ', Helper.curp_builder(first_lastname: 'D/Amico').slice(0, 4)
    end
  end

  describe 'exception cases, Ü' do
    it 'should replace Ü with U' do
      assert_equal 'AURJ', Helper.curp_builder(first_lastname: 'Argüello').slice(0, 4)
    end
  end

  describe 'exception cases, composite last names' do
    it 'should use the first word' do
      assert_equal 'RIRJ', Helper.curp_builder(first_lastname: 'Riva Palacio').slice(0, 4)
    end

    it "should use the second word if the first is a preposition, conjunction or abreviation " do
      assert_equal 'PERG', Helper.curp_builder(first_name: 'Mc Gregor').slice(0, 4)
      assert_equal 'GERJ', Helper.curp_builder(first_lastname: 'Mc Gregor').slice(0, 4)
      assert_equal 'PEGJ', Helper.curp_builder(second_lastname: 'Mc Gregor').slice(0, 4)
    end
  end

  describe 'exception cases, forbidden words' do
    it 'should replace the second character for X if it forms a forbidden word' do
      assert_equal 'PXNE', Helper.curp_builder(first_name: 'Enrique', first_lastname: 'Peña', second_lastname: 'Nieto').slice(0, 4)
    end
  end

  describe 'exception cases, single lastname' do
    it 'should replace the third character with X if there is no second lastname' do
      assert_equal 'PEXJ', Helper.curp_builder(second_lastname: nil).slice(0, 4)
    end

    it 'should replace the 15th character with X if there is no second lastname' do
      assert_equal 'RXN', Helper.curp_builder(second_lastname: nil).slice(13, 3)
    end
  end

  describe 'CURP validation' do
    it 'should respond true with a valid last digit' do
      assert Curp.valid?(Helper::EXPECTED_CURP)
    end

    it 'should respond false if the last digit is invalid' do
      wrong_value = Helper::EXPECTED_CURP.dup
      wrong_value[17] = '0'

      refute Curp.valid?(wrong_value)
    end

    it 'should respond false if the string is not exactly 18 characters long' do
      too_long = Helper::EXPECTED_CURP.dup << 'X'
      too_short = Helper::EXPECTED_CURP.dup.slice(0, 17)

      refute Curp.valid?(too_long)
      refute Curp.valid?(too_short)
    end
  end
end
