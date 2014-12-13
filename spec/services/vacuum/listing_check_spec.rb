require 'vacuum'
require 'spec_helper'

describe Vacuum::ListingChecker do
  let(:link_sanitizer) { Vacuum::LinkSanitizer.new(link) }

  describe ".valid?" do
    context "with a real repository" do
      let(:link) { SITES["main_example"] }

      use_vcr_cassette "main_example"

      it "returns true" do
        Vacuum::ListingChecker.new(link_sanitizer).should be_valid
      end
    end

    context "with a random site" do
      let(:link) { SITES["not_a_repository"] }

      use_vcr_cassette "not_a_repository"

      it "returns false" do
        Vacuum::ListingChecker.new(link_sanitizer).should_not be_valid
      end
    end

    context "with a 401" do
      let(:link) { "http://www.401.fr" }
      it 'returns false' do
        stub_request(:any, link)
          .to_return(:status => 401)

        Vacuum::ListingChecker.new(link_sanitizer).should_not be_valid
      end
    end
  end
end
