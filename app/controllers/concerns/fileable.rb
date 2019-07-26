module Fileable
  extend ActiveSupport::Concern

  included do
    before_action :set_file, only: [:delete_file]
  end

  def delete_file
    @file.purge
    
    redirect_back(
      fallback_location: documents_url,
      otice: "File was successfuly deleted."
    )
  end

  private

    def set_file
      @file = ActiveStorage::Attachment.find(params[:file_id])

      return if AuthUtils.valid_user_for_file?(current_user, @file)

      redirect_back(
        fallback_location: documents_url,
        notice: "You are not the owner of the file"
      )
    end
end