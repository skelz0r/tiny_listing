require "spec_helper"

describe Repository do
  it { should have_many(:loots).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }

  describe "alive" do
    context "on creation (with loots)" do
      it "has a true default value" do
        repository = create(:repository)
        repository.reload
        repository.alive.should be true
      end
    end
  end
end
