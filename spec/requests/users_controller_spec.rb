require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user_info) do
    {
      avatar: uploaded_file,
      title: Faker::Job.position,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      gender: Faker::Gender.binary_type,
      naturalization: Faker::Nation.nationality
    }
  end
  let(:post_headers) do
    {
      "ACCEPT": 'text/html, application/xhtml+xml',
      "HTTP_ACCEPT": 'text/html, application/xhtml+xml',
      "Content-Type": 'multipart/form-data',
      "Content-Disposition": 'form-data'
    }
  end

  describe 'GET #index' do
    context 'when page accessed' do
      let!(:user) { create(:user) }

      it 'renders users index page' do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Users')
        expect(response.body).to include(user.full_name)
      end
    end

    context 'when search is done' do
      let!(:mr_world_wide) { create(:user, name: { "title": 'Mr', "first": 'World', "last": 'Wide' }) }
      let!(:mrs_world_wide) { create(:user, name: { "title": 'Mrs', "first": 'World', "last": 'Wide' }) }
      let!(:ms_world_wide) { create(:user, name: { "title": 'Ms', "first": 'Universe', "last": 'Wide' }) }
      let!(:junior) { create(:user, name: { "title": 'Mr', "first": 'World', "last": 'Junior' }) }

      it 'renders users filtered by title, first and last name' do
        get users_path(params: { search: 'Mr World Wide' })

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Users')
        expect(response.body).to include(mr_world_wide.full_name)
        expect(response.body).to_not include(mrs_world_wide.full_name)
        expect(response.body).to_not include(ms_world_wide.full_name)
        expect(response.body).to_not include(junior.full_name)
      end
    end
  end

  describe 'GET #show' do
    context 'when page access' do
      let!(:user) { create(:user) }

      it 'renders show user page' do
        get "#{users_path}/#{user.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Presenting:')
      end
    end
  end

  describe 'GET #new' do
    let!(:user) { create(:user) }

    context 'when page access' do
      it 'renders new user page' do
        get new_user_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('New user')
      end
    end
  end

  describe 'GET #edit' do
    let!(:user) { create(:user) }

    context 'when page access' do
      it 'renders edit user page' do
        get "#{users_path}/#{user.id}/edit"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Editing user')
      end
    end
  end

  describe 'POST #create' do
    let(:avatar_path) { Rails.root.join('spec', 'fixtures', 'files', 'animalespiritual.jpg') }
    let(:uploaded_file) { fixture_file_upload(avatar_path, 'image/jpeg') }

    context 'when user info is sent' do
      it 'creates new user' do
        post users_path, params: {
          user: user_info
        },
        headers: post_headers

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('User was successfully created.')
      end
    end

    context 'when user info is missing' do
      it 'returns unprocessable_entity ' do
        post users_path, params: {
          user: {
            avatar: uploaded_file,
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name
          }
        },
        headers: post_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('New user')
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user) }
    let(:avatar_path) { Rails.root.join('spec', 'fixtures', 'files', 'roboto.jpg') }
    let(:uploaded_file) { fixture_file_upload(avatar_path, 'image/jpeg') }

    context 'when user info is patched' do
      it 'updates user' do
        patch "#{users_path}/#{user.id}", params: {
          user: user_info
        },
        headers: post_headers

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('User was successfully updated.')
      end
    end

    context 'when user info is missing' do
      it 'returns unprocessable_entity ' do
        patch "#{users_path}/#{user.id}", params: {
          user: {
            avatar: uploaded_file,
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name
          }
        },
        headers: post_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Editing user')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:user_id) { user.id }

    context 'when user id is passed to route' do
      it 'deletes the user' do
        delete user_path(user.id)

        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('User was successfully deleted.')
        expect { User.find(user_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
