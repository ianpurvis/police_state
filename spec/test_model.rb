require "active_model"

class TestModel
  include ActiveModel::AttributeAssignment
  include ActiveModel::Dirty
  include ActiveModel::Validations
  include PoliceState

  attr_reader :state

  def initialize(attributes={})
    assign_attributes(attributes)
  end

  def state=(value)
    if value != attribute_was(:state)
      attribute_will_change!(:state)
    else
      clear_attribute_changes(:state)
    end
    @state = value
  end

  def save!
    changes_applied
  end

  def reload!
    clear_changes_information
  end
end
