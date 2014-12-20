require "spec_helper"

describe Vacuum::Engine do
  describe "suck_up!", sidekiq: :inline do
    let(:repository) { Repository.create!(link: link) }

    context "with a tiny example" do
      let(:link) { SITES["main_example"] }
      let(:number_of_files) { NUMBER_OF_FILES['main_example'] }

      use_vcr_cassette "main_example"

      before do
        Vacuum::Engine.new(repository).suck_up!
        repository.reload
      end

      it "extract files from link" do
        repository.loots.count.should eq number_of_files
      end
    end
  end
end
