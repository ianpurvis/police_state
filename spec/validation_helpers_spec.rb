require "spec_helper"

RSpec.describe PoliceState::ValidationHelpers do

  describe ".validates_transition_of" do
    after do
      TestModel.clear_validators!
    end

    it "adds a TransitionValidator to the validators list" do
      TestModel.validates_transition_of :state, from: :state_one, to: :state_two

      validator = TestModel.validators.last
      expect(validator).to be_a(PoliceState::TransitionValidator)
      expect(validator.attributes).to eq([:state])
      expect(validator.options).to include(from: :state_one, to: :state_two)
    end
  end
end
