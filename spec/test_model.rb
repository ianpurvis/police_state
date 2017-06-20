require "active_model"

class TestModel
  include ActiveModel::Dirty
  include ActiveModel::Validations
  include PoliceState

  define_attribute_methods :state

  def initialize(state: nil)
    @state = state
  end

  def state
    @state
  end

  def state=(val)
    state_will_change! unless val == @state
    @state = val
  end

  def save!
    changes_applied
  end

  def reload!
    clear_changes_information
  end
end
