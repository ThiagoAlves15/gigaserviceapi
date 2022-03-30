FactoryBot.define do
  factory :user do
    name { { "title": Faker::Job.position, "first": Faker::Name.first_name, "last": Faker::Name.last_name } }
    gender { Faker::Gender.binary_type }
    email { Faker::Internet.unique.email }
    picture { { "large": Faker::Avatar.image } }
    naturalization { Faker::Nation.nationality }

    after(:build) do |user|
      avatar_path = Rails.root.join("spec", "fixtures", "files", "roboto.jpg")

      user.avatar.attach(
        io: File.open(avatar_path),
        filename: "avatar.jpg",
        content_type: "image/jpeg"
      )
    end
  end
end
