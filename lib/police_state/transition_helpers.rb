module PoliceState::TransitionHelpers
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods

  included do
    raise ArgumentError, "Including class must implement ActiveModel::Dirty" unless include?(ActiveModel::Dirty)
    attribute_method_suffix "_transitioned?", "_transitioning?"
  end

  def attribute_transitioned?(attr, options={})
    options = _transform_options_for_attribute(attr, options)
    !!previous_changes_include?(attr) &&
      (!options.include?(:to) || options[:to] == previous_changes[attr].last) &&
      (!options.include?(:from) || options[:from] == previous_changes[attr].first)
  end

  def attribute_transitioning?(attr, options={})
    options = _transform_options_for_attribute(attr, options)
    attribute_changed?(attr, options)
  end


  private

  # Facilitates easier change checking for ActiveRecord::Enum attributes
  # by casting any symbolized :to and :from values into their native strings.
  def _transform_options_for_attribute(attr, options={})
    return options unless self.class.respond_to?(:attribute_types)
    options.transform_values {|value|
      self.class.attribute_types.with_indifferent_access[attr].cast(value)
    }
  end
end
