class CreateRepository
  include Interactor

  def call
    context.repository = Repository.new(link: context.link)

    unless context.repository.save
      context.fail!(message: context.repository.errors.full_messages.join("\n"))
    end
  end
end
