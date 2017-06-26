module TransitionHelpers
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods

  included do
    attribute_method_suffix "_transitioned?", "_transitioning?"
  end

  def attribute_transitioned?(attr, options={})
    !!previous_changes_include?(attr) &&
      (!options.include?(:to) || options[:to] == previous_changes[attr].last) &&
      (!options.include?(:from) || options[:from] == previous_changes[attr].first)
  end

  def attribute_transitioning?(attr, options={})
    attribute_changed?(attr, options)
  end
end
