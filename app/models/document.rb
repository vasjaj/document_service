class Document < ApplicationRecord
  include FileableModel

  belongs_to :user

  validates :name, :description, presence: true
end
