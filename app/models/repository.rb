class Repository < ActiveRecord::Base
  has_many :loots

  before_create :set_alive

  def set_alive
    self[:alive] = true
  end
end
