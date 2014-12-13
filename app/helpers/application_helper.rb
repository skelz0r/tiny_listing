module ApplicationHelper
  def toggle_nav_active(link)
    c = controller.controller_name
    m = controller.action_name
    klass = "active"
    if link == :search
      return klass if c == "search" 
    elsif link == :new_repository
      return klass if c == "repositories" && ["new", "create"].include?(m)
    elsif link == :repositories
      return klass if c == "repositories" && ["index", "show"].include?(m)
    end
    ""
  end

  # FIXME go decorator
  def class_for_alive(repository)
    if repository.alive?
      "success"
    else
      "danger"
    end
  end
end
