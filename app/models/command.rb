class Command < ApplicationRecord
  def run_command(command, flags, final_path, path, timestamp)
    command_string = create_command(command, flags)
    RunCommand.perform_async([command_string], final_path, path, timestamp, false)
  end

  def create_command(command, flags)
    # create command string
    command_string = command.name

    # add flags
    flags.each do |flag|
      command_string += " #{flag}"
    end

    command_string
  end
end
