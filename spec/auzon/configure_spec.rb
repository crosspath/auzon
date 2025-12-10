# frozen_string_literal: true

RSpec.describe "Auzon" do
  describe "#configure" do
    context "without block" do
      it "raises error" do
        expect { spec_class.configure }.to raise_error(LocalJumpError)
      end
    end

    context "with block" do
      context "with correct parameters" do
        it "does not raise error" do
          expect do
            spec_class.configure { |config| config.skip_attributes_from_params = [:id] }
          end.not_to raise_error
        end

        it "updates configuration" do
          spec_class.configure { |config| config.skip_attributes_from_params = [:id] }
          expect(spec_class.config.skip_attributes_from_params).to eq([:id])
        end
      end

      context "with incorrect parameter values" do
        it "raises error" do
          expect do
            spec_class.configure { |config| config.skip_attributes_from_params = nil }
          end.to raise_error(ArgumentError)
        end
      end

      context "with unknown parameter names" do
        it "raises error" do
          expect do
            spec_class.configure { |config| config.__nonexistent_method }
          end.to raise_error(NoMethodError)
        end
      end
    end
  end
end
