json.extract! user, :id, :name, :gender, :email, :picture, :naturalization, :created_at, :updated_at
json.url user_url(user, format: :json)
