require 'spec_helper'

describe Vacuum::ListingChecker do
  subject { Vacuum::ListingChecker.new(Vacuum::LinkSanitizer.new(link)) }

  describe "valid?" do
    context "when status != 200" do
      let(:link) { SITES["403"] }

      use_vcr_cassette "403"

      it { should_not be_valid }
    end

    context "when is not a listing" do
      let(:link) { SITES["not_a_repository"] }

      use_vcr_cassette "not_a_repository"

      it { should_not be_valid }
    end

    context "when is status is OK and it's a listing" do
      let(:link) { SITES["main_example"] }

      use_vcr_cassette "main_example"

      it { should be_valid }
    end
  end
end
