require 'nokogiri'
require 'open-uri'

class Vacuum::Engine
  attr_reader :loots_count

  def initialize(repository)
    @link_sanitizer = Vacuum::LinkSanitizer.new(repository.link)
    @repository = repository
  end

  def suck_up!
    if valid?
      @repository.save unless @repository.persisted?
      suck_nodes
      true
    else
      false
    end
  end

  def link
    @repository.link
  end

  private

  def suck_nodes
    loot_place = Vacuum::LootPlace.new(root_link: @link_sanitizer, link: @link_sanitizer, repository: @repository)

    loot_place.sack_it!

    @loots_count = loot_place.loots_count
  end

  def valid?
    @link_sanitizer.valid? && Vacuum::ListingChecker.new(@link_sanitizer).valid?
  end
end
