module Apivore
  class SwaggerFileChecker < SwaggerChecker

    def has_matching_document_for(path, method, code, body)
      fragment = fragment(path, method, code)
      schema_fragment = path_schema(fragment)

      JSON::Validator.fully_validate(schema_fragment[:schema], body, fragment: schema_fragment[:fragment])
    end

    private

    attr_reader :mappings

    def load_swagger_doc!
      @swagger = Apivore::Swagger.new(fetch_swagger!)
    end

    def fetch_swagger!
      return JSON.parse File.read(swagger_file_path)
      JSON.parse(session.response.body)
    end

    def swagger_file_path
      uri  = JSON::Util::URI.parse(@swagger_path)
      uri.path
    end

    def path_schema(fragment)
      schema_fragment = swagger
      fragment[1..-1].each { |key| schema_fragment = schema_fragment[key] }

      schema_ref = schema_fragment["$ref"]

      if schema_fragment.key?("$ref")
        schema_ref = schema_fragment["$ref"]

        return {schema: @swagger_path, fragment: schema_ref} if schema_ref.start_with?("#/")
        return {schema: File.join(Pathname.new(@swagger_path).dirname, schema_ref)}
      end

      return {schema: @swagger_path, fragment: fragment}
    end

  end
end
