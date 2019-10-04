require "active_record"

class TestRecord < ActiveRecord::Base
  include PoliceState

  enum state: {
    example_state: 0,
    other: 1,
  }
end
