require 'rails_helper'

RSpec.describe AuthUtils do
  let(:user) { create(:user) }
  let(:document) { create(:document) }
  let(:file) { create(:file) }

  describe ".valid_user_for_file?" do
    subject { described_class.valid_user_for_file? }

    it {binding.pry}
  end

  describe ".valid_user_for_document?" do
    subject { described_class.valid_user_for_document? }
  end
end