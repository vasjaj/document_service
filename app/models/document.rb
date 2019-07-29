class Document < ApplicationRecord
  include FileableModel

  belongs_to :user
end
