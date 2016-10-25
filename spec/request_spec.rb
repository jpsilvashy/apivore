require 'spec_helper'

describe "Example API", type: :apivore, order: :defined do
  swagger_checkers = [
    Apivore::SwaggerFileChecker.instance_for(File.expand_path("../data/01_sample2.0.json", __FILE__)),
    Apivore::SwaggerChecker.instance_for("/swagger-doc.json")
    ]
  swagger_checkers.each do |swagger_checker|
    subject { swagger_checker }
    describe "using #{swagger_checker.class}" do
      context "has valid paths" do
        it 'allows the same path (with response documented) to be tested twice' do
          expect(subject).to validate(:get, "/services.json", 200)
          expect(subject).to validate(:get, "/services.json", 200)
        end

        it do
          expect(subject).to validate(
            :post, "/services.json", 204, {'name' => 'hello world'}
          )
        end

        it do
          expect(subject).to validate(
            :get, "/services/{id}.json", 200, {'id' => 1}
          )
        end

        it do
          expect(subject).to validate(
            :put, "/services/{id}.json", 204, {'id' => 1}
          )
        end

        it do
          expect(subject).to validate(
            :delete, "/services/{id}.json", 204, {'id' => 1}
          )
        end

        it do
          expect(subject).to validate(
            :patch, "/services/{id}.json", 204, {'id' => 1}
          )
        end
      end

      context 'and' do
        it 'has had all documented routes tested' do
          expect(subject).to validate_all_paths
        end

        it 'additionally conforms to a custom schema' do
          expect(subject).to conform_to(Apivore::CustomSchemaValidator::WF_SCHEMA)
        end
        # it 'has definitions consistent with the master docs' do
        #   expect(subject).to be_consistent_with_swagger_definitions(
        #     "api.westfield.io", 'deal'
        #   )
        # end
      end
    end
  end

end
