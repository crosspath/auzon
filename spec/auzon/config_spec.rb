# frozen_string_literal: true

RSpec.describe "Auzon::Config" do
  describe "#validate" do
    subject(:config) { spec_class.new(**spec_class.default_values) }

    it("doesn't raise on default values") { expect { config.validate }.not_to raise_error }

    context "when skip_attributes_from_params is nil" do
      it "raises error" do
        config.skip_attributes_from_params = nil

        expect { config.validate }.to raise_error(ArgumentError)
      end
    end

    context "when skip_attributes_from_params isn't nil" do
      it "raises error" do
        config.skip_attributes_from_params = [:title]

        expect { config.validate }.not_to raise_error
      end
    end
  end
end
