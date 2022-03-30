require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    context "with a valid image" do
      let (:valid_user) { FactoryBot.build(:user) }

      it "is attached" do
        avatar_path = Rails.root.join("spec", "fixtures", "files", "roboto.jpg")

        valid_user.avatar.attach(
          io: File.open(avatar_path),
          filename: 'avatar.jpg',
          content_type: 'image/jpeg'
        )

        expect(valid_user.avatar).to be_attached
      end
    end
  end
end
