class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :already_authenticate

  def index
    @user = User.new
  end

  protected

  def already_authenticate
    redirect_to search_path if user_signed_in?
  end
end
