require 'rails_helper'

RSpec.describe FileableController, type: :request do  

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

  describe "#delete_file" do
    subject(:delete_file) do
      delete(
        "/documents/#{document.id}/files/#{attachment.id}"
      )
    end

    context "when user is owner of the document" do
      before do
        sign_in(user)
      end

      it "deletes files" do
        expect {delete_file}.to(
          change {ActiveStorage::Attachment.all.count}.
          by(-1)
        )

        expect(response).to redirect_to(documents_url)
      end
    end

    context "when user is not owner of the document" do
      before do
        sign_in(another_user)
      end

      it "does not delete file" do
        expect {delete_file}.to_not(
          change {ActiveStorage::Attachment.all.count}
        )

        expect(response).to redirect_to(documents_url)
      end
    end
  end
end