# frozen_string_literal: true

RSpec.describe "Auzon::ActiveObject" do
  shared_examples "with attributes eq" do |example_name|
    it(example_name) { expect(object.attributes).to eq(expected_attributes) }
  end

  describe "#initialize" do
    subject(:object) { klass.new(**options) }

    context "with default values" do
      let(:klass) { Class.new(spec_class) { attribute(:title, default: "Title") } }

      context "with empty options" do
        let(:expected_attributes) { {"title" => "Title"} }
        let(:options) { {} }

        include_examples "with attributes eq", "sets default values"
      end

      context "with options for object attributes" do
        let(:expected_attributes) { {"title" => title} }
        let(:options) { {title:} }
        let(:title) { "test" }

        include_examples "with attributes eq", "sets passed values"
      end
    end

    context "without default values" do
      let(:klass) { Class.new(spec_class) { attribute(:title) } }

      context "with empty options" do
        let(:expected_attributes) { {"title" => nil} }
        let(:options) { {} }

        include_examples "with attributes eq", "initializes object with empty values"
      end

      context "with options for object attributes" do
        let(:expected_attributes) { {"title" => title} }
        let(:options) { {title:} }
        let(:title) { "test" }

        include_examples "with attributes eq", "sets passed values"
      end
    end

    context "without attributes in class" do
      let(:klass) { Class.new(spec_class) }

      context "with empty options" do
        let(:expected_attributes) { {} }
        let(:options) { {} }

        include_examples "with attributes eq", "initializes object with empty values"
      end

      context "with options for object attributes" do
        let(:expected_attributes) { {} }
        let(:options) { {title: "test"} }

        it("raises error") { expect { object }.to raise_error(ActiveModel::UnknownAttributeError) }
      end
    end
  end

  describe "#new_from_params" do
    subject(:object) { klass.new_from_params(ActionController::Parameters.new(params), **options) }

    let(:expected_attributes) { {"title" => nil} }
    let(:klass) { Class.new(spec_class) { attribute(:title) } }
    let(:options) { {} }
    let(:params) { {} }
    let(:skip_attributes_from_params) { [] }
    let(:title) { "test" }

    around do |example|
      skip_attr_names = Auzon.config.skip_attributes_from_params
      Auzon.config.skip_attributes_from_params = skip_attributes_from_params

      example.run

      Auzon.config.skip_attributes_from_params = skip_attr_names
    end

    context "with params for all attributes" do
      let(:expected_attributes) { {"title" => title} }
      let(:params) { {title:} }

      include_examples "with attributes eq", "sets passed values"
    end

    context "with unexpected params" do
      let(:params) { {avatar: "test"} }

      include_examples "with attributes eq", "skips passed values"
    end

    context "with options for object attributes" do
      let(:expected_attributes) { {"title" => title} }
      let(:options) { {title:} }

      include_examples "with attributes eq", "sets passed options"
    end

    context "with excluded attribute" do
      let(:skip_attributes_from_params) { [:title] }

      context "when passed as params" do
        let(:params) { {title:} }

        include_examples "with attributes eq", "skips passed values"
      end

      context "when passed as options" do
        let(:expected_attributes) { {"title" => title} }
        let(:options) { {title:} }

        include_examples "with attributes eq", "sets passed options"
      end
    end
  end
end
