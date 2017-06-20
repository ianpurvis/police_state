class TestModel
  include ActiveModel::Validations
  include PoliceState
  attr_accessor :state
end
