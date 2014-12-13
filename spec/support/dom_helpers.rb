module DomHelpers
  def launch_search
    within('#search') do
      find('button').click
    end
  end
end

RSpec.configure do |config|
  config.include DomHelpers, type: :feature
end
