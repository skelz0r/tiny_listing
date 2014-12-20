class VacuumWorker
  include Sidekiq::Worker

  def perform(repository_id)
    repository = Repository.find(repository_id)
    link_sanitizer = Vacuum::LinkSanitizer.new(repository.link)

    Vacuum::LootPlace.new(root_link: link_sanitizer, link: link_sanitizer, repository: repository).sack_it!
  end
end
