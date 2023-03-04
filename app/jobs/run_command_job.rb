class RunCommandJob < ActiveJob::Base
  queue_as :default

  def perform(command)
    # folder = "../cmd_results/"

    # system("cd #{folder} & " + command)
    folder_name = "cmd_results"
    system("mkdir ~/Desktop/test/#{folder_name}")
  end
end
