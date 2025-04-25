# frozen_string_literal: true

# Class with filter definitions. Feel free to add more!
class Base::QueryFilters < Auzon::FiltersTemplate
  filter(:equal) { val.present? && arel[key].eq(val) }
  filter(:includes_in_any_case) { val.present? && arel[key].matches("%#{val}%") }
  filter(:list) { val.present? && arel[key].in(val) }
end
