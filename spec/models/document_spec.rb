require 'rails_helper'

RSpec.describe Document, type: :model do
  it { is_expected.to belong_to(:user) }
  
  describe "included modules" do
    subject { described_class.ancestors }

    it { is_expected.to include(FileableModel) }
  end
end