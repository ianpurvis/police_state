module PoliceState

  # == Police State Validation Helpers
  module ValidationHelpers

    # Validates that the specified attributes are transitioning to a
    # destination state from one or more origin states.
    #
    #   class Model < ActiveRecord::Base
    #     validates_transition_of :status, from: nil, to: :queued
    #     validates_transition_of :status, from: :queued, to: :active
    #     validates_transition_of :status, from: :active, to: :complete
    #     validates_transition_of :status, from: [:queued, :active], to: :failed
    #   end
    #
    # Note: This check is only performed if the attribute is transitioning to the
    # destination state.
    #
    # You can specify +nil+ states for nullable attributes.
    #
    # Configuration options:
    #
    # * <tt>:from</tt> - The origin state(s) of the attribute. This can be supplied as a
    #   single value or an array.
    # * <tt>:to</tt> - The destination state of the attribute.
    #
    # There is also a list of default options supported by every validator:
    # +:if+, +:unless+, +:on+, +:allow_nil+, +:allow_blank+, and +:strict+.
    # See <tt>ActiveModel::Validation#validates</tt> for more information
    def validates_transition_of(*attr_names)
      validates_with PoliceState::TransitionValidator, _merge_attributes(attr_names)
    end
  end
end
