require "spec_helper"

RSpec.describe PoliceState do

  describe "inclusion" do
    it "includes TransitionHelpers" do
      expect(TestModel).to include(TransitionHelpers)
    end

    it "extends ValidationHelpers" do
      expect(TestModel).to be_kind_of(ValidationHelpers)
    end
  end
end
