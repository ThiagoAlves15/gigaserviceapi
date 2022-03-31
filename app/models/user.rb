class User < ApplicationRecord
  has_one_attached :avatar

  validates :name, :gender, :email, :naturalization, presence: true
  validates :avatar, presence: true,
                     blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..(5.megabytes) }

  def attached?
    avatar.attached?
  end

  def full_name
    "#{name['title']} #{name['first']} #{name['last']}"
  end
end
