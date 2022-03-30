class CreateUsers < ApplicationService
  class CreateUsersFailed < StandardError; end

  def initialize(users)
    @users = users
  end

  def call
    raise CreateUsersFailed unless valid_payload?

    @users["results"].each do |user_data|
      params = user_parameters(user_data)
      user = User.new(params)
      download_and_attach_avatar(user)
      user.save!
    end

    Result.new(true, nil)
  rescue StandardError
    Rails.logger.error("Could not create user")

    raise CreateUsersFailed
  end

  private

  def valid_payload?
    @users["results"].present? &&
    @users["results"].all? { |user_data|
      user_data.assert_valid_keys("name", "gender", "email", "nat", "picture")
    }
  end

  def user_parameters(user_data)
    {
      name: user_data["name"],
      gender: user_data["gender"],
      email: user_data["email"],
      naturalization: user_data["nat"],
      picture: user_data["picture"],
    }
  end

  def download_and_attach_avatar(user)
    file_name = generate_file_name
    download_image = Down.download(user.picture["large"])

    user.avatar.attach(
      io: File.open(download_image.path),
      filename: file_name,
      content_type: 'image/jpeg'
    )
  end

  def generate_file_name
    "#{random_seed}#{just_numbers_from_time}.jpg"
  end

  def random_seed
    Random.alphanumeric
  end

  def just_numbers_from_time
    Time.now.to_s.delete(" \t\r\n:-")
  end
end