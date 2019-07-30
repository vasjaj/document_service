require 'rails_helper'

RSpec.describe DocumentsController, type: :request do
  let(:user) { create(:user) }
  let(:user_1) { create(:user, email: "some_other@example.com") }
  let!(:document) { create(:document, name: "document_name", user: user) }
  let!(:document_1) { create(:document, name: "document_1_name", user: user_1) }

  describe "#index" do
    subject(:index) { get "/documents" }

    it "renders all documents" do
      index

      expect(response).to render_template(:index)
      expect(response.body).to include(*[document.name, document_1.name])
    end
  end

  describe "#show" do
    subject(:show) { get "/documents/#{id}" }

    let(:id) { document.id }

    context "when user is the owner of the document" do
      before do
        sign_in(user)
      end

      it "renders users documents" do
        show
  
        expect(response).to render_template(:show)
        expect(response.body).to include(document.name)
      end
    end

    context "when user is not the owner of the document" do
      before do
        sign_in(user_1)
      end

      it "renders users documents" do
        show
  
        expect(response).to redirect_to(documents_path)
      end
    end
  end

  describe "#new" do
    subject(:new) { get "/documents/new" }

    let(:name) { "some_new_name" }
    let(:description) { "some_new_description" }

    context "when user is signed-in" do
      before do
        sign_in(user)
      end

      it "creates new document" do
        new

        expect(response).to render_template(:new)
      end
    end

    context "when user is not signed-in" do
      it "redirects back" do
        new

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#edit" do
    subject(:edit) { get "/documents/#{document.id}/edit" }

    context "when user is the owner of the document" do
      before do
        sign_in(user)
      end

      it "renders users documents" do
        edit
  
        expect(response).to render_template(:edit)
      end
    end

    context "when user is not the owner of the document" do
      before do
        sign_in(user_1)
      end

      it "renders users documents" do
        edit
  
        expect(response).to redirect_to(documents_path)
      end
    end
  end

  describe "#create" do
    # sic!
    subject(:create_request) do
      post(
        "/documents", 
        params: {
          document: params
        }
      )
    end

    let(:name) { "some_new_name" }
    let(:description) { "some_new_description" }
    let(:params) { {name: name, description: description} }

    context "when user is signed-in" do
      before do
        sign_in(user)
      end

      context "when params are valid" do
        it "creates new document" do
          expect {create_request}.to(
            change {Document.all.count}.by(1)
          )
        end
      end

      context "when params are not valid" do
        let(:params) { {name: "", description: ""} }

        it "does not create new document" do
          expect {create_request}.to(
            change {Document.all.count}.by(0)
          )

          expect(response).to render_template(:new)
        end
      end
    end

    context "when user is not signed-in" do
      it "redirects back" do
        create_request

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#update" do
    subject(:update) do
      put("/documents/#{document.id}", params: {document: params})
    end

    let(:name) { "some_new_name" }
    let(:description) { "some_new_description" }
    let(:params) { {name: name, description: description} }

    context "when user is the owner of the document" do
      before do
        sign_in(user)
      end

      context "when params are valid" do
        it "updates existing document" do
          expect {update}.to(
            change { [document.reload.name, document.reload.description] }.
            from([document.name, document.description]).
            to([name, description])
          )
        end
      end

      context "when params are not valid" do
        let(:params) { {name: "", description: ""} }

        it "renders edit template" do
          update

          expect {update}.to_not(
            change { [document.reload.name, document.reload.description] }
          )

          expect(response).to render_template(:edit)
        end
      end

    end

    context "when user is not the owner of the document" do
      before do
        sign_in(user_1)
      end

      it "renders users documents" do
        update
  
        expect(response).to redirect_to(documents_path)
      end
    end
  end

  describe "#destroy" do
    subject(:destroy) { delete "/documents/#{document.id}" }
    
    context "when user is the owner of the document" do
      before do
        sign_in(user)
      end

      it "destroys document" do
        expect {destroy}.to(
          change {Document.all.count}.by(-1)
        )

        expect(response).to redirect_to(documents_url)
      end
    end

    context "when user is not the owner of the document" do
      before do
        sign_in(user_1)
      end

      it "does not destroy document" do
        expect {destroy}.to_not(
          change {Document.all.count}
        )
      end
    end
  end
end