class VacuumWorker
  include Sidekiq::Worker

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/vacuum.log")
  end

  def perform(repository_id)
    begin
      raise "No id for repository" if repository_id.blank?

      repository = Repository.find(repository_id)
      raise "No repository" if repository.blank?

      link_sanitizer = Vacuum::LinkSanitizer.new(repository.link)
      Vacuum::LootPlace.new(root_link: link_sanitizer, link: link_sanitizer, repository: repository).sack_it!
    rescue => e
      logger.error "Unable to loot repository: #{e}"
    end
  end
end
