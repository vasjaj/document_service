class Document < ApplicationRecord
  belongs_to :user, optional: true

  has_many_attached :files
end
