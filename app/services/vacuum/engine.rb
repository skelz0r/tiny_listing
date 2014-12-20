require 'nokogiri'
require 'open-uri'

class Vacuum::Engine
  def initialize(repository)
    @link_sanitizer = Vacuum::LinkSanitizer.new(repository.link)
    @repository = repository
  end

  def suck_up!
    VacuumWorker.perform_async(@repository.id) if valid?
  end

  def valid?
    @link_sanitizer.valid? && Vacuum::ListingChecker.new(@link_sanitizer).valid?
  end
end
