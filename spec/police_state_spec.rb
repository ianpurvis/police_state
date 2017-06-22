require "spec_helper"

RSpec.describe PoliceState do
  describe "inclusion" do
    context "when class does not include ActiveModel::Dirty" do
      it "raises an ArgumentError" do
        expect {
          Class.new do
            include PoliceState
          end
        }.to raise_error(ArgumentError)
      end
    end
  end
end
