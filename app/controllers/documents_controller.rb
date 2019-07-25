class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :set_file, only: [:delete_file]
  before_action :check_user, only: [:new, :create]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    @document.user = current_user

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_file
    @file.purge
    
    redirect_back(fallback_location: documents_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])

      return if AuthUtils.valid_user_for_document?(current_user, @document)

      redirect_back(
        fallback_location: documents_url,
        notice: "You are not the owner of the document"
      )
    end

    def set_file
      @file = ActiveStorage::Attachment.find(params[:id])

      return if AuthUtils.valid_user_for_file?(current_user, @file)

      redirect_back(
        fallback_location: documents_url,
        notice: "You are not the owner of the file"
      )
    end

    def check_user
      redirect_to(new_user_session_path) if current_user.blank?
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.fetch(:document, {}).permit(:name, :description, files: [])
    end
end
