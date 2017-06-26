require "active_model"
require "active_support/core_ext/hash/slice.rb"
require "police_state/transition_helpers"
require "police_state/transition_validator"
require "police_state/validation_helpers"

module PoliceState
  extend ActiveSupport::Concern

  included do
    include PoliceState::TransitionHelpers
    extend PoliceState::ValidationHelpers
  end
end
