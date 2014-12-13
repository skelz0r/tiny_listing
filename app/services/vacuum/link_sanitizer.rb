require 'uri'
require "addressable/uri"

##
# Sanitize links for algorithms

class Vacuum::LinkSanitizer
  LINK_REGEX = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/

  ##
  # Constructor
  #
  # ==== Attributes
  #
  # +link_string+ - url in string format
  def initialize(link_string)
    @link_string = link_string
  end

  ##
  # Return an URI normalize
  def uri
    @uri ||= begin
      uri = Addressable::URI.parse(sanitize_link(@link_string))
      uri.normalize
    end
  end

  ##
  # Return a sanitize link in string
  def link
    @link ||= uri.to_s
  end

  alias :to_s :link

  ##
  # Check if link is valid according to regexp
  def valid?
    @link_string =~ LINK_REGEX
  end

  protected

  def sanitize_link(link)
    link = "http://" + link if link !~ /^(https?:\/\/)/
    link = link + '/' if link[-1] != '/'
    link
  end
end
