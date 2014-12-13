require "spec_helper"

describe Repository do
  describe "alive" do
    context "on creation (with loots)" do
      it "has a true default value" do
        create(:repository, alive: nil).alive.should be true
      end
    end
  end
end
