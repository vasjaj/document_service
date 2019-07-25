class AuthUtils
  class << self
    def valid_user_for_file?(user, file)
      return false if user.blank?
      return false if user != file.record.user
      
      true
    end

    def valid_user_for_document?(user, document)
      return false if user.blank?
      return false if user != document.user

      true
    end
  end 
end