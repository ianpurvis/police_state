require "spec_helper"

RSpec.describe PoliceState::TransitionValidator do

  before(:all) do
    TransitionValidator = PoliceState::TransitionValidator
  end

  describe ".initialize(options)" do
    context "when options include :attributes, :from, and :to" do
      let(:options) do
        {
          attributes: :state,
          from: :state_one,
          to: :state_two
        }
      end
      it "creates a new validator" do
        validator = TransitionValidator.new(options)
        expect(validator.attributes).to include(:state)
        expect(validator.options).to include(from: :state_one, to: :state_two)
      end
    end

    context "when options do not include :from" do
      let(:options) do
        {
          attributes: :state,
          to: :state_two
        }
      end
      it "raises an ArgumentError" do
        expect { TransitionValidator.new(options) }
          .to raise_error(ArgumentError)
      end
    end

    context "when options do not include :to state" do
      let(:options) do
        {
          attributes: :state,
          from: :state_one
        }
      end
      it "raises an ArgumentError" do
        expect { TransitionValidator.new(options) }
          .to raise_error(ArgumentError)
      end
    end

    context "when :from is an array" do
      let(:options) do
        {
          attributes: :state,
          from: [
            :state_one,
            :state_two
          ],
          to: :state_three
        }
      end
      it "creates a new validator" do
        validator = TransitionValidator.new(options)
        expect(validator.options).to include(
          from: [
            :state_one,
            :state_two
          ],
          to: :state_three
        )
      end
    end

    context "when :to is an array" do
      let(:options) do
        {
          attributes: :state,
          from: :state_one,
          to: [
            :state_two,
            :state_three
          ]
        }
      end
      it "raises an ArgumentError" do
        expect { TransitionValidator.new(options) }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "#validate_each(record, attribute, value)" do

    RSpec.shared_examples "#validate_each" do |origin_state, destination_state|

      before :each do
        subject.validate_each(record, :state, record.state)
      end

      context "when attribute value transitions :from and :to" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = origin_state
            m.save!
            m.state = destination_state
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end

      context "when attribute value transitions :from but not :to" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = origin_state
            m.save!
            m.state = :other
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end

      context "when attribute value transitions :to but not :from" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :other
            m.save!
            m.state = destination_state
          }
        }

        it "adds an error to the record" do
          expect(record.errors.messages).to include(:state)
        end
      end

      context "when attribute value transitions to neither :from or :to" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :other
            m.save!
            m.state = :another
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end

      context "when attribute value does not transition" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = destination_state
            m.save!
            m.state = :other
            m.state = destination_state
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end
    end

    context "given a validator configured with a single :from state" do
      subject {
        TransitionValidator.new(
          attributes: :state,
          from: :state_one,
          to: :state_two
        )
      }

      include_examples "#validate_each", :state_one, :state_two
    end

    context "given a validator configured with multiple :from states" do
      subject {
        TransitionValidator.new(
          attributes: :state,
          from: [ :state_one, :state_two ],
          to: :state_three
        )
      }

      context "using first :from state" do
        include_examples "#validate_each", :state_one, :state_three
      end

      context "using second :from state" do
        include_examples "#validate_each", :state_two, :state_three
      end
    end
  end
end
