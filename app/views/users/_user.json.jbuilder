json.extract! user, :id, :name, :gender, :location, :email, :birthday, :registered, :phone, :cellphone, :picture, :naturalization, :created_at, :updated_at
json.url user_url(user, format: :json)
