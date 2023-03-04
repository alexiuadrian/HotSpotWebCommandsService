class RunCommand
  include Sidekiq::Worker

  def perform(command)
    final_path = "~/Desktop/cmd_results/"
    path = "./cmd_results/"
    timestamp = Time.now.to_i
    file = File.open("#{path}#{timestamp}.sh", "w")
    file.write("cd #{final_path}")
    # write empty line
    file.write("\n")
    file.write("#{command}")
    file.close

    # make file executable
    File.chmod(0755, "#{path}#{timestamp}.sh")

    # run the command
    system("./#{path}#{timestamp}.sh")
  end
end
