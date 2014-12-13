class SearchController < ApplicationController
  before_filter :loot

  def new
  end

  def create
    if loot_params.empty?
      @loots = []
      flash.now.alert = "No matches found"
    else
      @loots = Loot.basic_search(loot_params)

      if @loots.empty?
        flash.now.alert = "No matches found"
      else
        flash.now.notice = "Found #{@loots.to_a.count} results"
      end
    end
  end

  protected

  def loot
    @loot = params.key?(:loot) ? Loot.new(loot_params) : Loot.new
  end

  def loot_params
    params[:loot].delete_if { |k,v| v.blank? }
    if params[:loot].empty?
      {}
    else
      params.require(:loot).permit(:name, :name_sanitize, :extension)
    end
  end
end
