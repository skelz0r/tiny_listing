require 'spec_helper'

describe Vacuum::LinkSanitizer do
  describe "uri" do
    subject { Vacuum::LinkSanitizer.new(link).uri }

    context "with a valid URL string" do
      let(:link) { "www.oki.fr" }

      it { should be_kind_of(Addressable::URI) }
    end

    context "with a valid URI string" do
      let(:link) { "http://www.oki.fr" }

      it { should be_kind_of(Addressable::URI) }
    end
  end

  describe "link" do
    it "returns a string" do
      Vacuum::LinkSanitizer.new("www.oki.fr").link.should be_kind_of(String)
    end

    it "adds an extra / to the link if missing" do
      link = Vacuum::LinkSanitizer.new("www.oki.fr").link

      link.should =~ /\/$/
      link.should == "http://www.oki.fr/"
    end

    it "add scheme" do
      link = Vacuum::LinkSanitizer.new("oki.fr").link

      link.should =~ /^http:\/\//
      link.should == "http://oki.fr/"
    end

    context "when link finished with '/'" do
      it "doesn't add a '/'" do
        link = Vacuum::LinkSanitizer.new("oki.fr/").link

        link.should == "http://oki.fr/"
      end
    end
  end

  describe "valid?" do
    it "returns false on non-url" do
      Vacuum::LinkSanitizer.new("lol").should_not be_valid
      Vacuum::LinkSanitizer.new("http://lol").should_not be_valid
    end

    it "returns true on url" do
      Vacuum::LinkSanitizer.new("http://www.lol.fr").should be_valid
      Vacuum::LinkSanitizer.new("www.lol.fr").should be_valid
      Vacuum::LinkSanitizer.new("lol.fr").should be_valid
    end
  end
end
