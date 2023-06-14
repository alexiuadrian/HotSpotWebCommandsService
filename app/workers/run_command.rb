class RunCommand
  include Sidekiq::Worker

  def perform(commands, final_path, path)
    timestamp = Time.now.to_i
    file = File.open("#{path}#{timestamp}.sh", "w")
    file.write("cd #{final_path}")
    # write empty line
    file.write("\n")
    commands.each do |command|
      file.write("#{command}")
      # write empty line
      file.write("\n")
    end
    file.close

    # make file executable
    File.chmod(0755, "#{path}#{timestamp}.sh")

    # run the command
    system("#{path}#{timestamp}.sh")
  end
end
