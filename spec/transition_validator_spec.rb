require "spec_helper"

RSpec.describe PoliceState::TransitionValidator do

  before(:all) do
    TransitionValidator = PoliceState::TransitionValidator
  end

  describe ".initialize" do
    context "when options include :arguments, :from, and :to" do
      it "creates a new validator" do
        validator = TransitionValidator.new(
          attributes: :state,
          from: :state_one,
          to: :state_two
        )
        expect(validator.attributes).to include(:state)
        expect(validator.options).to include(from: :state_one, to: :state_two)
      end
    end

    context "when options do not include :from" do
      it "raises an ArgumentError" do
        expect {
          TransitionValidator.new(attributes: :state, to: :state_two)
        }.to raise_error(ArgumentError)
      end
    end

    context "when options do not include :to state" do
      it "raises an ArgumentError" do
        expect {
          TransitionValidator.new(attributes: :state, from: :state_one)
        }.to raise_error(ArgumentError)
      end
    end

    context "when :from is an array" do
      it "creates a new validator" do
        validator = TransitionValidator.new(
          attributes: :state,
          from: [
            :state_one,
            :state_two
          ],
          to: :state_three
        )
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
      it "raises an ArgumentError" do
        expect {
          TransitionValidator.new(
            attributes: :state,
            from: :state_one,
            to: [
              :state_two,
              :state_three
            ]
          )
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#validate_each" do

    before :each do
      subject.validate_each(record, :state, record.state)
    end

    context "given a :from state and :to state" do
      subject {
        TransitionValidator.new(
          attributes: :state,
          from: :state_one,
          to: :state_two
        )
      }

      context "when attribute transitions :from and :to" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :state_one
            m.save!
            m.state = :state_two
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end

      context "when attribute transitions :from but not :to" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :state_one
            m.save!
            m.state = :state_three
          }
        }

        it "adds an error to the record" do
          expect(record.errors.messages).to include(:state)
        end
      end

      context "when attribute transitions :to but not :from" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :state_four
            m.save!
            m.state = :state_two
          }
        }

        it "adds an error to the record" do
          expect(record.errors.messages).to include(:state)
        end
      end

      context "when attribute transitions to neither :from or :to" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :state_three
            m.save!
            m.state = :state_four
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end

      context "when attribute does not transition" do
        let(:record) {
          TestModel.new.tap {|m|
            m.state = :state_two
            m.save!
            m.state = :state_three
            m.state = :state_two
          }
        }

        it "does not add an error to the record" do
          expect(record.errors.messages).to_not include(:state)
        end
      end
    end
  end
end
