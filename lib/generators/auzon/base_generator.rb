module Auzon
  module Generators
    class Base < Rails::Generators::NamedBase
      def self.source_root
        File.expand_path(File.join(generator_name, "templates"), __dir__)
      end
    end
  end
end
