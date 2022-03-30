require 'rails_helper'

RSpec.describe CreateUsers do
  describe "#call" do
    subject(:create_users) { described_class.call(payload) }

    let(:local_image_path) { OpenStruct.new(path: "spec/fixtures/files/animalespiritual.jpg") }
    before { allow(Down).to receive(:download).and_return(local_image_path) }

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

    context "when account is created" do
      let(:expected_result) { ApplicationService::Result.new(true, nil, nil) }

      it { is_expected.to eql(expected_result) }

      it "creates new users" do
        create_users

        expect(User.count).to be > 2
      end
    end

    context "when payload is invalid" do
      let(:payload) {
        {
          "results"=>[ {"aaa": "vvv"} ],
          "info"=>{"seed"=>"giga", "results"=>0, "page"=>1, "version"=>"1.3"}
        }
      }


      it "raises an error" do
        expect { subject }.to raise_error(CreateUsers::CreateUsersFailed)
      end
    end
  end
end
