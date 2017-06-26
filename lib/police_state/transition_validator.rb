class PoliceState::TransitionValidator < ActiveModel::EachValidator

  def check_validity!
    raise ArgumentError, "Options must include :from" unless options.include?(:from)
    raise ArgumentError, "Options must include :to" unless options.include?(:to)
    raise ArgumentError, "Options cannot specify array for :to" if options[:to].is_a?(Array)
  end

  def validate_each(record, attr_name, value)
    unless transition_allowed?(record, attr_name)
      record.errors.add(attr_name, "can't transition to #{value}", options)
    end
  end


  private

  def transition_allowed?(record, attr_name)
    record.attribute_transitioning?(attr_name, options.slice(:to)) ^
      !record.attribute_transitioning?(attr_name, options.slice(:from))
  end
end
