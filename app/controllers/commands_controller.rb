class CommandsController < ApplicationController
  before_action :set_command, only: %i[ show edit update destroy ]

  # GET /commands or /commands.json
  def index
    @commands = Command.all
  end

  # GET /commands/1 or /commands/1.json
  def show
  end

  # GET /commands/new
  def new
    @command = Command.new
  end

  # GET /commands/1/edit
  def edit
  end

  # POST /commands or /commands.json
  def create
    @command = Command.new(command_params)

    flags = params[:flags]

    @command.flags = flags

    # Command.new.delay.run_command(@command, flags)
    # execute = run_command(@command, flags)

    respond_to do |format|
      if @command.save
        final_path = "/Users/adialexiu/Desktop/cmd_results/"
        path = "./cmd_results/"
        timestamp = Time.now.to_i
        @command.run_command(@command, flags, final_path, final_path, timestamp)
        created_path = final_path + timestamp.to_s + "/"
        format.html { redirect_to command_url(@command), notice: "Command was successfully created." }
        # send the created path to the json response
        format.json { render json: { path: created_path } }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commands/1 or /commands/1.json
  def update
    respond_to do |format|
      if @command.update(command_params)
        format.html { redirect_to command_url(@command), notice: "Command was successfully updated." }
        format.json { render :show, status: :ok, location: @command }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commands/1 or /commands/1.json
  def destroy
    @command.destroy

    respond_to do |format|
      format.html { redirect_to commands_url, notice: "Command was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_command
    @command = Command.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def command_params
    params.require(:command).permit(:name, :is_available, :requires_admin)
  end

  def run_command_by_id(id)
    system(create_command(Command.find(id)))
  end
end
