module Auzon
  module Generators
    class Init < Base
      def change_configuration
        application(CONFIG_APPLICATION)
      end

      def create_directories
        empty_directory("domains/base/mailers")
      end

      def copy_example_files
        use_slim = gemfile_lock.match?(/^\sslim\s\(/m)
        layout = ["layout.text.erb", use_slim ? "layout.html.slim" : "layout.html.erb"]

        directory(".", "domains/base", recursive: false)

        layout.each { |fn| copy_file("mailers/#{fn}", "domains/base/mailers/#{fn}") }
      end

      private

      CONFIG_APPLICATION = <<~RUBY
        config.autoload_paths << root.join("domains")
        config.eager_load_paths << root.join("domains")
      RUBY

      private_constant :CONFIG_APPLICATION

      def gemfile_lock
        path = File.expand_path("Gemfile.lock", destination_root)

        File.exist?(path) ? File.read(path) : ""
      end
    end
  end
end
