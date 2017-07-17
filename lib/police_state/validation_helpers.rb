module PoliceState
  module ValidationHelpers

    def validates_transition_of(*attr_names)
      validates_with PoliceState::TransitionValidator, _merge_attributes(attr_names)
    end
  end
end
