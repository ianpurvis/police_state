require "spec_helper"

RSpec.describe TransitionHelpers do
  let(:attribute) { :state }

  describe "#attribute_transitioned?" do
    context "given a model where attribute previously changed" do
      let(:model) {
        TestModel.new.tap {|m|
          m.state = :state_one
          m.save!
        }
      }

      context "when options do not include :to or :from" do
        it "returns true" do
          expect(model.attribute_transitioned?(:state)).to eq(true)
        end
      end

      context "when :to equals previously changed state" do
        it "returns true" do
          expect(model.attribute_transitioned?(attribute, to: :state_one)).to eq(true)
        end
      end

      context "when :to does not equal previously changed state" do
        it "returns false" do
          expect(model.attribute_transitioned?(attribute, to: :state_two)).to eq(false)
        end
      end

      context "when :from equals previously original state" do
        it "returns true" do
          expect(model.attribute_transitioned?(attribute, from: nil)).to eq(true)
        end
      end

      context "when :from does not equal previously original state" do
        it "returns false" do
          expect(model.attribute_transitioned?(attribute, from: :state_two)).to eq(false)
        end
      end
    end

    context "given a model where attribute has not previously changed" do
      let(:model) {
        TestModel.new.tap {|m|
          m.state = :state_one
          m.save!
          m.save!
        }
      }

      context "when options do not include :to or :from" do
        it "returns false" do
          expect(model.attribute_transitioned?(attribute)).to eq(false)
        end
      end
    end
  end

  describe "#attribute_transitioning?" do
    context "given a model where attribute has changed" do
      let(:model) {
        TestModel.new.tap {|m|
          m.state = :state_one
        }
      }

      context "when options do not include :to or :from" do
        it "returns true" do
          expect(model.attribute_transitioning?(:state)).to eq(true)
        end
      end

      context "when :to equals changed state" do
        it "returns true" do
          expect(model.attribute_transitioning?(attribute, to: :state_one)).to eq(true)
        end
      end

      context "when :to does not equal changed state" do
        it "returns false" do
          expect(model.attribute_transitioning?(attribute, to: :state_two)).to eq(false)
        end
      end

      context "when :from equals original state" do
        it "returns true" do
          expect(model.attribute_transitioning?(attribute, from: nil)).to eq(true)
        end
      end

      context "when :from does not equal original state" do
        it "returns false" do
          expect(model.attribute_transitioning?(attribute, from: :state_two)).to eq(false)
        end
      end
    end


    context "given a model where attribute has not changed" do
      let(:model) { TestModel.new }

      context "when options do not include :to or :from" do
        it "returns false" do
          expect(model.attribute_transitioning?(attribute)).to eq(false)
        end
      end
    end
  end
end
