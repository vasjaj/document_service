require 'rails_helper'

RSpec.describe FileableModel do
  let(:model) { create(:document) }

  describe "#files" do
    subject { model.files }

    it { is_expected.to be_a(ActiveStorage::Attached::Many) }
  end
end