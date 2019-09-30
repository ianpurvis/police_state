require "spec_helper"

RSpec.describe PoliceState do

  describe ".included" do
    it "includes TransitionHelpers" do
      expect(TestModel).to include(PoliceState::TransitionHelpers)
    end

    it "extends ValidationHelpers" do
      expect(TestModel).to be_kind_of(PoliceState::ValidationHelpers)
    end
  end
end
