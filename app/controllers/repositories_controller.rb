require 'vacuum'

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def new
    @repository = Repository.new
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def update
    repository = Repository.find(params[:id])

    vacuum = Vacuum::Engine.new(repository)

    if vacuum.suck_up!
      flash.notice = "Repository #{vacuum.link} is now up to date !"
    else
      flash.alert = 'Repository not available'
    end

    redirect_to repository
  end

  def create
    @repository = Repository.new(repository_params)

    vacuum = Vacuum::Engine.new(@repository)

    if vacuum.suck_up!
      redirect_to root_path, notice: "Success, there's #{vacuum.loots_count} more coins!"
    else
      flash.now.alert = "Something went wrong!"
      render 'new'
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:link)
  end
end
