module TransitionHelpers

  def attribute_transitioned?(attr, options={})
    !!previous_changes_include?(attr) &&
      (!options.include?(:to) || options[:to] == previous_changes[attr].last) &&
      (!options.include?(:from) || options[:from] == previous_changes[attr].first)
  end

  def attribute_transitioning?(attr, options={})
    attribute_changed?(attr, options)
  end
end
