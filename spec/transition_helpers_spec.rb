require "spec_helper"

RSpec.describe PoliceState::TransitionHelpers do

  RSpec.shared_examples "TransitionHelpers" do
    describe "#attribute_transitioned?(attribute, options={})" do
      let(:attribute) { :state }

      def test
        model.attribute_transitioned?(attribute, options)
      end

      context 'when options are empty' do
        let(:options) do
          {}
        end

        context 'when attribute changed before the model was saved' do
          before do
            model.state = :example_state
            model.save!
          end
          it 'returns true' do
            expect(test).to eq(true)
          end
        end
        context 'when attribute did not change before the model was saved' do
          before do
            model.save!
          end
          it 'returns false' do
            expect(test).to eq(false)
          end
        end
      end
      context 'when options include :to' do
        let(:options) do
          {
            to: :example_state
          }
        end

        context 'when attribute changed before the model was saved' do
          context 'when new value was :to' do
            before do
              model.state = :example_state
              model.save!
            end
            it 'returns true' do
              expect(test).to eq(true)
            end
          end
          context 'when new value was not :to' do
            before do
              model.state = :other
              model.save!
            end
            it 'returns false' do
              expect(test).to eq(false)
            end
          end
        end
        context 'when attribute did not change before the model was saved' do
          before do
            model.save!
          end
          it 'returns false' do
            expect(test).to eq(false)
          end
        end
      end
      context 'when options include :from' do
        let(:options) do
          {
            from: :example_state
          }
        end

        context 'when attribute changed before the model was saved' do
          context 'when original value was :from' do
            before do
              model.state = :example_state
              model.save!
              model.state = :other
              model.save!
            end
            it 'returns true'do
              expect(test).to eq(true)
            end
          end
          context 'when original value was not :from' do
            before do
              model.state = :other
              model.save!
              model.state = :example_state
              model.save!
            end
            it 'returns false' do
              expect(test).to eq(false)
            end
          end
        end
        context 'when attribute did not change before the model was saved' do
          before do
            model.save!
          end
          it 'returns false' do
            expect(test).to eq(false)
          end
        end
      end
    end


    describe "#attribute_transitioning?(attribute, options={})" do
      let(:attribute) { :state }

      def test
        model.attribute_transitioning?(attribute, options)
      end

      context 'when options are empty' do
        let(:options) do
          {}
        end

        context 'when attribute has changed' do
          before do
            model.state = :example_state
          end
          it 'returns true' do
            expect(test).to eq(true)
          end
        end
        context 'when attribute has not changed' do
          before do
            model.save!
          end
          it 'returns false' do
            expect(test).to eq(false)
          end
        end
      end
      context 'when options include :to' do
        let(:options) do
          {
            to: :example_state
          }
        end

        context 'when attribute has changed' do
          context 'when new value is :to' do
            before do
              model.state = :example_state
            end
            it 'returns true' do
              expect(test).to eq(true)
            end
          end
          context 'when new value is not :to' do
            before do
              model.state = :other
            end
            it 'returns false' do
              expect(test).to eq(false)
            end
          end
        end
        context 'when attribute has not changed' do
          it 'returns false' do
            expect(test).to eq(false)
          end
        end
      end
      context 'when options include :from' do
        let(:options) do
          {
            from: :example_state
          }
        end

        context 'when attribute has changed' do
          context 'when original value was :from' do
            before do
              model.state = :example_state
              model.save!
              model.state = :other
            end
            it 'returns true' do
              expect(test).to eq(true)
            end
          end
          context 'when original value was not :from' do
            before do
              model.state = :other
              model.save!
              model.state = :example_state
            end
            it 'returns false' do
              expect(test).to eq(false)
            end
          end
        end
        context 'when attribute has not changed' do
          it 'returns false' do
            expect(test).to eq(false)
          end
        end
      end
    end

    describe ".define_attribute_methods" do
      before do
        # Workaround for inconsistency between ActiveModel and ActiveRecord api
        case model
        when TestModel then model.class.define_attribute_methods(:state)
        when TestRecord then model.class.define_attribute_methods
        else raise 'Unsupported model type!'
        end
      end

      it "defines _transitioned? suffix methods" do
        expect(model.class.attribute_method?(:state_transitioned?)).to eq(true)
      end

      it "defines _transitioning? suffix methods" do
        expect(model.class.attribute_method?(:state_transitioning?)).to eq(true)
      end
    end
  end

  context "given an Active Record object" do
    let(:model) { TestRecord.new }

    include_examples "TransitionHelpers"
  end

  context "given an Active Model object" do
    let(:model) { TestModel.new }

    include_examples "TransitionHelpers"
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
