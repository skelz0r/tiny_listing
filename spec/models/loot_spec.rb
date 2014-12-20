require "spec_helper"

describe Loot do
  it "has a valid factory" do
    build(:loot).should be_valid
  end

  describe "name" do
    context "when already properly formatted" do
      let(:name) { "jesuisunebaleine" }

      it 'is extrated from link' do
        loot = create(:loot, link: "http://www.tropmarrant.fr/oki/non/#{name}.avi", name: nil)
        loot.name.should == name
      end
    end

    context "with some URI encoded" do
      let(:name_encoded) { "je%20suis%20une%20baleine" }
      let(:name) { "je suis une baleine" }

      it "is extracted from link and URI decoded" do
        loot = create(:loot, link: "http://www.tropmarrant.fr/oki/non/#{name_encoded}.avi", name: nil)
        loot.name.should == name
      end
    end

    context "with some dots" do
      let(:name) { "je.suis.une.baleine" }

      it "extracted name properly" do
        loot = create(:loot, link: "http://www.tropmarrant.fr/oki/non/#{name}.avi", name: nil)

        loot.name.should == "je suis une baleine"
      end
    end
  end

  describe "name_sanitize" do
    context "when name has special chars" do
      let(:name) { "Le%c3%a7on_d'espoir-" } # Leçon_d'espoir-
      let(:name_sanitize) { "Lecon d'espoir" }
      it "sanitize filename" do
        loot = create(:loot, link: "http://www.tropmarrant.fr/oki/non/#{name}.avi", name: nil)
        loot.name_sanitize.should == name_sanitize
      end
    end
  end

  describe "extension" do
    let(:name) { "jesuisunebaleine.avi" }
    it 'is extrated from link' do
      loot = create(:loot, link: "http://www.tropmarrant.fr/oki/non/#{name}", name: nil, extension: nil)
      loot.extension.should == "avi"
    end
  end
end
