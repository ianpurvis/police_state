require "spec_helper"

RSpec.describe PoliceState::TransitionHelpers do
  let(:model) { TestModel.new }

  describe "#attribute_transitioned?" do
    context 'given an attribute' do
      let(:attribute) { :state }

      context 'when attribute changed before the model was saved' do
        before do
          model.state = :example_state
          model.save!
        end
        it 'returns true' do
          expect(model.attribute_transitioned?(attribute)).to eq(true)
        end
      end
      context 'when attribute did not change before the model was saved' do
        before do
          model.save!
        end
        it 'returns false' do
          expect(model.attribute_transitioned?(attribute)).to eq(false)
        end
      end
    end
    context 'given an attribute and :to' do
      let(:attribute) { :state }
      let(:to) { :example_state }

      context 'when attribute changed before the model was saved' do
        context 'when new value equaled :to' do
          before do
            model.state = :example_state
            model.save!
          end
          it 'returns true' do
            expect(model.attribute_transitioned?(attribute, to: to)).to eq(true)
          end
        end
        context 'when new value did not equal :to' do
          before do
            model.state = :other
            model.save!
          end
          it 'returns false' do
            expect(model.attribute_transitioned?(attribute, to: to)).to eq(false)
          end
        end
      end
      context 'when attribute did not change before the model was saved' do
        before do
          model.save!
        end
        it 'returns false' do
          expect(model.attribute_transitioned?(attribute, to: to)).to eq(false)
        end
      end
    end
    context 'given an attribute and :from' do
      let(:attribute) { :state }
      let(:from) { :example_state }

      context 'when attribute changed before the model was saved' do
        context 'when original value equaled :from' do
          before do
            model.state = :example_state
            model.save!
            model.state = :other
            model.save!
          end
          it 'returns true'do
            expect(model.attribute_transitioned?(attribute, from: from)).to eq(true)
          end
        end
        context 'when original value did not equal :from' do
          before do
            model.state = :other
            model.save!
            model.state = :example_state
            model.save!
          end
          it 'returns false' do
            expect(model.attribute_transitioned?(attribute, from: from)).to eq(false)
          end
        end
      end
      context 'when attribute did not change before the model was saved' do
        before do
          model.save!
        end
        it 'returns false' do
          expect(model.attribute_transitioned?(attribute, from: from)).to eq(false)
        end
      end
    end
  end


  describe "#attribute_transitioning?" do
    context 'given an attribute' do
      let(:attribute) { :state }

      context 'when attribute has changed' do
        before do
          model.state = :example_state
        end
        it 'returns true' do
          expect(model.attribute_transitioning?(attribute)).to eq(true)
        end
      end
      context 'when attribute has not changed' do
        before do
          model.save!
        end
        it 'returns false' do
          expect(model.attribute_transitioning?(attribute)).to eq(false)
        end
      end
    end
    context 'given an attribute and :to' do
      let(:attribute) { :state }
      let(:to) { :example_state }

      context 'when attribute has changed' do
        context 'when new value equals :to' do
          before do
            model.state = :example_state
          end
          it 'returns true' do
            expect(model.attribute_transitioning?(attribute, to: to)).to eq(true)
          end
        end
        context 'when new value does not equal :to' do
          before do
            model.state = :other
          end
          it 'returns false' do
            expect(model.attribute_transitioning?(attribute, to: to)).to eq(false)
          end
        end
      end
      context 'when attribute has not changed' do
        it 'returns false' do
          expect(model.attribute_transitioning?(attribute, to: to)).to eq(false)
        end
      end
    end
    context 'given an attribute and :from' do
      let(:attribute) { :state }
      let(:from) { :example_state }

      context 'when attribute has changed' do
        context 'when original value equals :from' do
          before do
            model.state = :example_state
            model.save!
            model.state = :other
          end
          it 'returns true' do
            expect(model.attribute_transitioning?(attribute, from: from)).to eq(true)
          end
        end
        context 'when original value does not equal :from' do
          before do
            model.state = :other
            model.save!
            model.state = :example_state
          end
          it 'returns false' do
            expect(model.attribute_transitioning?(attribute, from: from)).to eq(false)
          end
        end
      end
      context 'when attribute has not changed' do
        it 'returns false' do
          expect(model.attribute_transitioning?(attribute, from: from)).to eq(false)
        end
      end
    end
  end


  describe ".define_attribute_methods" do
    before do
      TestModel.define_attribute_methods :state
    end

    it "defines _transitioned? suffix methods" do
      expect(TestModel.attribute_method?(:state_transitioned?)).to eq(true)
    end

    it "defines _transitioning? suffix methods" do
      expect(TestModel.attribute_method?(:state_transitioning?)).to eq(true)
    end
  end


  describe ".included" do
    context "when class does not include ActiveModel::Dirty" do
      it "raises an ArgumentError" do
        expect { Class.new { include PoliceState } }
          .to raise_error(ArgumentError)
      end
    end
  end
end
