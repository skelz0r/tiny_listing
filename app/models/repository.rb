class Repository < ActiveRecord::Base
  has_many :loots
  belongs_to :user

  validates_presence_of :user_id

  before_create :set_alive

  def set_alive
    self[:alive] = true
  end
end
