require 'rails_helper'

RSpec.describe "Api::V1::UsersBatchController", type: :request do
  describe "POST #create" do
    before { allow(CreateUsers).to receive(:call).and_return(expected_result) }
    let(:user_info) {
      {
        "gender"=>Faker::Gender.binary_type,
        "name"=>{
          "title"=>Faker::Job.position,
          "first"=>Faker::Name.first_name,
          "last"=>Faker::Name.last_name
        },
        "email"=>Faker::Internet.unique.email,
        "picture"=>{
          "large"=>Faker::Avatar.image,
          "medium"=>Faker::Avatar.image,
          "thumbnail"=>Faker::Avatar.image
        },
        "nat"=>Faker::Nation.nationality
      }
    }
    let(:expected_result) { ApplicationService::Result.new(true, nil, nil) }

    context "when valid params" do
      let(:payload) {
        {
          "results"=>[
            user_info,
            user_info,
            user_info
          ],
          "info"=>{"seed"=>"giga", "results"=>3, "page"=>1, "version"=>"1.3"}
        }
      }

      it "renders 200 success" do
        post api_v1_users_batch_index_path(params: payload)

        expect(response).to have_http_status(:see_other)
      end
    end

    context "when too much users" do
      before { allow(User).to receive(:count).and_return(101) }

      let(:payload) {
        {
          "results"=>[
            user_info
          ],
          "info"=>{"seed"=>"giga", "results"=>1, "page"=>1, "version"=>"1.3"}
        }
      }

      it "redirects with message" do
        post api_v1_users_batch_index_path(params: payload)

        expect(response).to have_http_status(:found)
      end
    end

    context "when invalid params" do
      let(:expected_result) { ApplicationService::Result.new(false, nil, "Invalid users params") }
      let(:payload) { "aa" }

      it "renders 402 unprocessable entity" do
        post api_v1_users_batch_index_path(params: payload)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
