class FlagsController < ApplicationController
  before_action :set_flag, only: %i[ show edit update destroy ]

  # GET /flags or /flags.json
  def index
    @flags = Flag.all
  end

  # GET /flags/1 or /flags/1.json
  def show
  end

  # GET /flags/new
  def new
    @flag = Flag.new
  end

  # GET /flags/1/edit
  def edit
  end

  # POST /flags or /flags.json
  def create
    @flag = Flag.new(flag_params)

    respond_to do |format|
      if @flag.save
        format.html { redirect_to flag_url(@flag), notice: "Flag was successfully created." }
        format.json { render :show, status: :created, location: @flag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flags/1 or /flags/1.json
  def update
    respond_to do |format|
      if @flag.update(flag_params)
        format.html { redirect_to flag_url(@flag), notice: "Flag was successfully updated." }
        format.json { render :show, status: :ok, location: @flag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flags/1 or /flags/1.json
  def destroy
    @flag.destroy

    respond_to do |format|
      format.html { redirect_to flags_url, notice: "Flag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flag
      @flag = Flag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flag_params
      params.require(:flag).permit(:name, :value)
    end
end
