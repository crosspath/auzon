# frozen_string_literal: true

module Auzon
  module Generators
    class Domain < Base
      argument :names, type: :array, default: [], banner: "..."

      def generate_file_tree
        domain_names = [name] + names # @args

        create_directories(domain_names)
        create_example_files(domain_names)
      end

      private

      DIRECTORIES = %w[forms jobs mailers queries serializers services validators].freeze

      private_constant :DIRECTORIES

      def create_directories(domain_names)
        domain_names.each do |domain|
          DIRECTORIES.each { |dir| empty_directory("domains/#{domain}/#{dir}") }
        end
      end

      def create_example_files(domain_names)
        domain_names.each do |domain|
          module_name = domain.camelize

          template("domains/#{domain}.rb", "domain.rb.erb")
        end
      end
    end
  end
end
