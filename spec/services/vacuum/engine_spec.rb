require "spec_helper"

describe Vacuum::Engine do
  describe "suck_up!" do
    let(:repository) { Repository.new(link: link) }

    context "with a tiny example" do
      let(:link) { SITES["main_example"] }
      let(:number_of_files) { NUMBER_OF_FILES['main_example'] }

      use_vcr_cassette "main_example"

      before do
        Vacuum::Engine.new(repository).suck_up!
        repository.reload
      end

      it "creates the repository with link" do
        repository.link.should == link
      end

      it "extract files from link" do
        repository.loots.count.should eq number_of_files
      end
    end

    context "with a non-repository" do
      let(:link) { SITES["not_a_repository"] }
      let(:number_of_files) { NUMBER_OF_FILES['not_a_repository'] }

      use_vcr_cassette "not_a_repository"

      it "doesn't create the repository" do
        expect {
          Vacuum::Engine.new(repository).suck_up!
        }.to_not change{Repository.count}
      end
    end
  end
end

