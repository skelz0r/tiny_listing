require 'uri'

class Loot < ActiveRecord::Base
  include ActiveSupport::Inflector

  BASIC_EXTENSIONS = %w(
    avi mkv mp4
    mp3 ogg flac
    pdf epub
    tar.gz tgz rar zip
    dmg iso
  )
  belongs_to :repository

  before_save :extract_name_from_link
  before_save :extract_name_sanitize
  before_save :extract_extension_from_link

  def extract_name_from_link
    if self[:name].blank?
      name = self[:link].split('/').last
      self[:name] = URI.decode(name.split('.').first)
    end
  end

  def extract_name_sanitize
    if self[:name_sanitize].blank?
      self[:name_sanitize] = transliterate(self[:name]).gsub(/-|_/," ").strip
    end
  end

  def extract_extension_from_link
    self[:extension] = self[:link].split('.').last if self[:extension].blank?
  end
end
