require "active_model"
require "active_support/core_ext/array/wrap.rb"
require "police_state/transition_validator"

module PoliceState
  extend ActiveSupport::Concern

  included do
    raise ArgumentError, "Including class must implement ActiveModel::Dirty" unless include?(ActiveModel::Dirty)
    extend HelperMethods
  end

  def attribute_transitioned_to?(attr_name, state)
    attribute_changed?(attr_name, to: state)
  end

  def attribute_transitioned_from_any_of?(attr_name, states)
    Array.wrap(states).any? {|state| attribute_changed?(attr_name, from: state) }
  end
end
