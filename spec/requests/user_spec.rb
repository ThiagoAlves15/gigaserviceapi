require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET #index" do
    context "when page access" do
      let!(:user) { create(:user) }

      it "renders users index page" do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Users")
        expect(response.body).to include(user.name["first"])
      end
    end
  end

  describe "GET #show" do
    context "when page access" do
      let!(:user) { create(:user) }

      it "renders show user page" do
        get users_path(user.id)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.name["first"])
      end
    end
  end

  describe "GET #new" do
    let!(:user) { create(:user) }

    context "when page access" do
      it "renders new user page" do
        get new_user_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("New user")
      end
    end
  end

  describe "GET #edit" do
    let!(:user) { create(:user) }

    context "when page access" do
      it "renders edit user page" do
        get edit_user_path(user.id)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Editing user")
        expect(response.body).to include(user.name["first"])
      end
    end
  end

  xdescribe "POST #create" do
    let(:user) { create(:user) }

    context "when user info is sent" do
      it "creates new user" do
        post users_path(user.id, params: {
          user: {
            avatar: user.avatar,
            title: user.name["first_name"],
            first_name: user.name["first_name"],
            last_name: user.name["first_name"],
            email: user.email,
            gender: user.gender,
            naturalization: user.naturalization,
          }
        })

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Users")
        expect(response.body).to include(user.name["first"])
      end
    end
  end

  xdescribe "PATCH #update" do
    let(:avatar_path) { Rails.root.join("spec", "fixtures", "files", "roboto.jpg") }
    let!(:avatar_file) { Rack::Test::UploadedFile.new(avatar_path, "image/jpeg", true) }
    let!(:user) { create(:user) }

    context "when user info is patched" do
      it "updates user" do
        patch user_path(user.id, params: {
          user: {
            avatar: avatar_file,
            title: user.name["first_name"],
            first_name: user.name["first_name"],
            last_name: user.name["first_name"],
            email: user.email,
            gender: user.gender,
            naturalization: user.naturalization,
          }
        })

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Editing user")
        expect(response.body).to include(user.name["first"])
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    let!(:user_id) { user.id }

    context "when user id is passed to route" do
      it "deletes the user" do
        delete user_path(user.id)

        expect(response).to have_http_status(:found)

        expect { User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
