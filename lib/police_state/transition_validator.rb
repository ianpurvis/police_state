module PoliceState
  class TransitionValidator < ActiveModel::EachValidator # :nodoc:

    def check_validity!
      raise ArgumentError, "Options must include :from" unless options.include?(:from)
      raise ArgumentError, "Options must include :to" unless options.include?(:to)
      raise ArgumentError, "Options cannot specify array for :to" if options[:to].is_a?(Array)
    end

    def validate_each(record, attr_name, value)
      unless transition_allowed?(record, attr_name)
        record.errors.add(attr_name, "can't transition to #{value}", **options)
      end
    end


    private

    def allowed_destination
      options[:to]
    end

    def allowed_origins
      options[:from].instance_eval {nil? ? [nil] : Array.wrap(self)}
    end

    def transition_allowed?(record, attr_name)
      !record.attribute_transitioning?(attr_name, to: allowed_destination) ||
        allowed_origins.any? {|origin| record.attribute_transitioning?(attr_name, from: origin)}
    end
  end
end
