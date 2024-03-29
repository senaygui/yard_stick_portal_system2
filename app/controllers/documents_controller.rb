class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]

  # GET /documents or /documents.json
  def index
    @document = current_student
  end

  # GET /documents/1 or /documents/1.json
  def show
  end

  # GET /documents/new
  # def new
  #   @document = Student.new
  # end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents or /documents.json
  # def create
  #   @document = Student.new(document_params)

  #   respond_to do |format|
  #     if @document.save
  #       format.html { redirect_to @document, notice: "Document was successfully created." }
  #       format.json { render :show, status: :created, location: @document }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @document.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to documents_path, notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = current_student
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.fetch(:student, {}).permit(:grade_8_ministry,:grade_10_matric,:grade_12_matric,:coc,:highschool_transcript,:diploma_certificate,:degree_certificate,:temporary_degree_certificate,:student_copy,:offical)
    end
end
