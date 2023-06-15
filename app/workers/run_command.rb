class RunCommand
  include Sidekiq::Worker

  def perform(commands, final_path, path, timestamp)
    if timestamp.nil?
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
    else
      path_before = path

      # create a file with the timestamp name
      file = File.open("#{final_path}#{timestamp}.sh", "w")

      # write the commands to the file
      file.write("cd #{final_path}")
      file.write("\n")
      file.write("mkdir #{timestamp}")
      file.write("\n")
      final_path = "#{final_path}#{timestamp}/"
      path = "#{path}#{timestamp}/"
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
      File.chmod(0755, "#{path_before}#{timestamp}.sh")

      # run the command
      system("#{path_before}#{timestamp}.sh")

      # return final_path
      final_path
    end
  end
end
