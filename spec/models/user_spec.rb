require 'spec_helper'

describe User do
  it { should have_many(:repositories) }

  it "has a valid factory" do
    build(:user).should be_valid
  end

  describe "email" do
    it "is uniq" do
      user = create(:user)
      build(:user, email: user.email).should_not be_valid
    end

    it "has a valid format" do
      build(:user, email: "lol").should_not be_valid
    end
  end

  describe "password" do
    it "has a 6 min length" do
      build(:user, password: "a"*5).should_not be_valid
    end
  end
end
