class RunCommand
  include Sidekiq::Worker

  def perform(command)
    system(command)
  end
end
