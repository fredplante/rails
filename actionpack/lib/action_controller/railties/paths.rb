module ActionController
  module Railties
    module Paths
      def self.with(_app)
        Module.new do
          define_method(:inherited) do |klass|
            super(klass)
            if namespace = klass.parents.detect {|m| m.respond_to?(:_railtie) }
              app = namespace._railtie
            else
              app = _app
            end

            paths   = app.config.paths
            options = app.config.action_controller

            options.assets_dir           ||= paths.public.to_a.first
            options.javascripts_dir      ||= paths.public.javascripts.to_a.first
            options.stylesheets_dir      ||= paths.public.stylesheets.to_a.first
            options.page_cache_directory ||= paths.public.to_a.first
            options.helpers_path         ||= paths.app.helpers.to_a
            options.each { |k,v| klass.send("#{k}=", v) }
          end
        end
      end
    end
  end
end
