require 'vacuum'
require 'nokogiri'
require 'open-uri'

##
# Check if a link is a listing (ie repository)
class Vacuum::ListingChecker
  attr_reader :link_sanitizer

  ##
  # Constructor
  #
  # ==== Attributes
  #
  # +link_sanitizer+ - Instance of Vacuum::LinkSanitizer
  def initialize(link_sanitizer)
    @link_sanitizer = link_sanitizer
  end

  ##
  # Check:
  # - is openable
  # - is a listing
  def valid?
    document_openable? && is_a_listing?
  end

  protected

  def is_a_listing?
    doc = Nokogiri::HTML(@doc_raw)
    nodes = doc.css('a')

    nodes.each do |l|
      if (l.inner_html == 'Parent Directory')
        return true
      end
    end
    false
  end

  def document_openable?
    begin
      @doc_raw ||= open(link_sanitizer.uri)
      true
    rescue OpenURI::HTTPError
      false
    end
  end
end
