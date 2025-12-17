# frozen_string_literal: true

RSpec.describe "Auzon::FiltersTemplate" do
  describe "DSL" do
    subject(:result_expressions) { model_filters.new(model_class, filter_values).to_arel }

    let(:arel_table_mock) { instance_double("Arel::Table") }

    let(:filters_specification) do
      Class.new(spec_class) do
        filter(:no_options) { Arel::Nodes::Nary.new({arel:, key:, val:, options:}) }
        filter(:with_options, :option) { Arel::Nodes::Nary.new({arel:, key:, val:, options:}) }
      end
    end

    let(:model_filters) do
      Class.new(filters_specification) do
        no_options :first_key
        with_options :second_key, option: "test"
      end
    end

    let(:model_class) do
      res = class_double("ActiveRecord::Base")
      allow(res).to receive(:arel_table).and_return(arel_table_mock)
      res
    end

    context "when filter values given" do
      let(:filter_values) { {first_key: 1, second_key: 2} }

      it "adds expression for value" do
        arel = model_class.arel_table

        expect(result_expressions.children.map(&:children)).to contain_exactly(
          {arel:, key: :first_key, val: 1, options: {}},
          {arel:, key: :second_key, val: 2, options: {option: "test"}}
        )
      end
    end

    context "when filter values are empty" do
      let(:filter_values) { {} }

      it("adds expression for value") { expect(result_expressions).to be_nil }
    end
  end
end
