require 'rails_helper'

RSpec.describe AuthUtils do
  let(:user) { create(:user) }
  let(:another_user) { create(:user, email: "other@example.com") }
  
  let!(:document) { create(:document, user: user) }
  let(:file) do
    fixture_file_upload(
      Rails.root.join('public', 'apple-touch-icon.png'), 'image/png'
    )
  end

  let(:attachment) { document.files.first }

  before do
    document.files.attach(file)
  end

  describe ".valid_user_for_file?" do
    subject { described_class.valid_user_for_file?(*args) }

    context "when userr is blank" do
      let(:args) { [nil, attachment] }

      it { is_expected.to eq(false) }
    end

    context "when user is not the owner" do
      let(:args) { [another_user, attachment] }

      it { is_expected.to eq(false) }
    end

    context "when user is owner" do
      let(:args) { [user, attachment] }

      it { is_expected.to eq(true) }
    end
  end

  describe ".valid_user_for_document?" do
    subject { described_class.valid_user_for_document?(*args) }

    context "when user is blank" do
      let(:args) { [nil, attachment] }

      it { is_expected.to eq(false) }
    end

    context "when user is not the owner" do
      let(:args) { [another_user, document] }

      it { is_expected.to eq(false) }
    end

    context "when user is owner" do
      let(:args) { [user, document] }

      it { is_expected.to eq(true) }
    end
  end
end