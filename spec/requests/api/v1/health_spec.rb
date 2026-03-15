# frozen_string_literal: true

require "swagger_helper"

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe "Api::V1::Health", type: :request do
  path "/api/v1/health" do
    get "API health check" do
      tags "Health"
      produces "application/json"

      response "200", "healthy" do
        schema type: :object,
               required: ["status"],
               properties: {
                 status: { type: :string, example: "ok" }
               }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["status"]).to eq("ok")
        end
      end
    end
  end
end
# rubocop:enable RSpec/EmptyExampleGroup
