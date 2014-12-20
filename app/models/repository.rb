class Repository < ActiveRecord::Base
  has_many :loots, dependent: :destroy
  belongs_to :user

  validates_presence_of :user_id
end
