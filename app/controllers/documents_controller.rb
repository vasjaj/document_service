class DocumentsController < ApplicationController
  include Fileable

  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:new, :create]

  def index
    @documents = Document.all
  end

  def show
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    @document = Document.new(document_params)

    @document.user = current_user

    if @document.save
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render :new
    end
  end

  def update
    if @document.update(document_params)
      redirect_to @document, notice: 'Document was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    
    redirect_to(documents_url, notice: "Document was successfully destroyed.")
  end

  private
    def set_document
      @document = Document.find(params[:id])

      return if AuthUtils.valid_user_for_document?(current_user, @document)

      redirect_back(
        fallback_location: documents_url,
        notice: "You are not the owner of the document"
      )
    end

    def check_user
      redirect_to(new_user_session_path) if current_user.blank?
    end

    def document_params
      params.fetch(:document, {}).permit(:name, :description, files: [])
    end
end
