require "spec_helper"
require "test_model"

RSpec.describe TransitionValidator do

  after do
    TestModel.clear_validators!
  end

  describe "#check_validity!" do
    describe "when options do not include :from or :to state" do
      it "raises an ArgumentError" do
        expect {
          TestModel.validates_transition_of :state
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
