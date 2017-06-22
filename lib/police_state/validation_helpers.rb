module ValidationHelpers

  def validates_transition_of(*attr_names)
    validates_with TransitionValidator, _merge_attributes(attr_names)
  end
end
