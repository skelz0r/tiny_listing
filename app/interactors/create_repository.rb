class CreateRepository
  include Interactor

  def call
    context.repository = Repository.new(link: context.link, user_id: context.user_id)

    unless context.repository.save
      context.fail!(message: context.repository.errors.full_messages.join("\n"))
    end
  end
end
