module Apivore
  class SwaggerFileChecker < SwaggerChecker

    private

    def fetch_swagger!
      YAML.load(File.read(swagger_file_path))
    end

    def swagger_file_path
      uri  = JSON::Util::URI.parse(@swagger_path)
      uri.path
    end
  end
end
