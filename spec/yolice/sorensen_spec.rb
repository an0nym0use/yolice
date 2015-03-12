require 'spec_helper'

module Yolice
  RSpec.describe SorensenIndex do

    it "should return an index of 1 for identical strings" do
      expect(SorensenIndex.index('Apache', 'Apache')).to eq 1.0
    end

    it "should return an index of 1 for strings that differ only in case" do
      expect(SorensenIndex.index('Apache', 'aPaChE')).to eq 1.0
    end

    [
      'MIT',
      'mit',
      'it\'s mit dawg'
    ].each do |input_string|
      context "comparing to \"#{input_string}\"" do
        success_string = 'MIT'
        fail_string = 'GPL'

        it "should generate a higher index for \"#{success_string}\" than \"#{fail_string}\"" do
          expect(SorensenIndex.index(input_string, success_string)).to be > SorensenIndex.index(input_string, fail_string)
        end
      end
    end

  end
end
