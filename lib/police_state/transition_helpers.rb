module PoliceState

  # == Police State \Transition Helpers
  #
  # Provides a way to monitor attribute state transitions for Active Record and Active Model objects.
  #
  # If using with Active Model, make sure that your class implements +ActiveModel::Dirty+.
  module TransitionHelpers
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    # :stopdoc:
    included do
      raise ArgumentError, "Including class must implement ActiveModel::Dirty" unless include?(ActiveModel::Dirty)
      attribute_method_suffix "_transitioned?", "_transitioning?"
    end
    # :startdoc:

    # Returns +true+ if +attribute+ transitioned at the last save event, otherwise +false+.
    #
    # You can specify origin and destination states using the +:from+ and +:to+
    # options. If +attribute+ is an +ActiveRecord::Enum+, these may be
    # specified as either symbol or their native enum value.
    #
    #  model = Model.create!(status: :complete)
    #  # => #<Model:0x007fa94844d088 @status=:complete>
    #
    #  model.status_transitioned?                            # => true
    #  model.status_transitioned?(from: nil)                 # => true
    #  model.status_transitioned?(to: :complete)             # => true
    #  model.status_transitioned?(to: "complete")            # => true
    #  model.status_transitioned?(from: nil, to: :complete)  # => true
    def attribute_transitioned?(attr, options={})
      options = _transform_options_for_attribute(attr, options)
      !!previous_changes_include?(attr) &&
        (!options.include?(:to) || options[:to] == previous_changes[attr].last) &&
        (!options.include?(:from) || options[:from] == previous_changes[attr].first)
    end

    # Returns +true+ if +attribute+ is currently transitioning but not saved, otherwise +false+.
    #
    # You can specify origin and destination states using the +:from+ and +:to+
    # options. If +attribute+ is an +ActiveRecord::Enum+, these may be
    # specified as either symbol or their native enum value.
    #
    #  model = Model.new(status: :complete)
    #  # => #<Model:0x007fa94844d088 @status=:complete>
    #
    #  model.status_transitioning?                            # => true
    #  model.status_transitioning?(from: nil)                 # => true
    #  model.status_transitioning?(to: :complete)             # => true
    #  model.status_transitioning?(to: "complete")            # => true
    #  model.status_transitioning?(from: nil, to: :complete)  # => true
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
end
