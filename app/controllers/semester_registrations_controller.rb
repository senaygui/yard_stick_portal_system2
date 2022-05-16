class SemesterRegistrationsController < ApplicationController
  before_action :set_registration, only: %i[ show edit update destroy ]

  # GET /registrations or /registrations.json
  def index
    @semester_registrations = current_student.semester_registrations.all
  end

  # GET /registrations/1 or /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    @semester_registration = SemesterRegistration.new
  end

  # GET /registrations/1/edit
  def edit
    @curriculums = current_student.program.curriculums.where(year: current_student.year, semester: current_student.semester)

    if @semester_registration.year == 1 && @semester_registration.semester == 1
      @fee = 550
    elsif @semester_registration.semester == 1
      @fee = 250
    end
      
  end

  # POST /registrations or /registrations.json
  def create
    @semester_registration = SemesterRegistration.new(semester_registration_params)

    respond_to do |format|
      if @semester_registration.save
        format.html { redirect_to @semester_registration, notice: "semester_registration was successfully created." }
        format.json { render :show, status: :created, location: @semester_registration }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @semester_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrations/1 or /registrations/1.json
  def update
    respond_to do |format|
      if @semester_registration.update(semester_registration_params)
        format.html { redirect_to invoice_path(@semester_registration.invoices.last.id), notice: "Registration was successfully updated." }
        format.json { render :show, status: :ok, location: @semester_registration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @semester_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1 or /registrations/1.json
  def destroy
    @semester_registration.destroy
    respond_to do |format|
      format.html { redirect_to semester_registrations_url, notice: "semester_registration was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @semester_registration = SemesterRegistration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def semester_registration_params
      params.fetch(:semester_registration, {}).permit(:mode_of_payment)
    end
end
