require 'rails_helper'

RSpec.feature 'Workspace Management', type: :feature do
  before { sign_in user }

  context 'As an owner of a collection' do
    let(:user) { create(:user) }
    let(:manifest1) { create(:manifest) }
    let(:manifest2) { create(:manifest) }
    let(:manifests) { [manifest1, manifest2] }
    let(:collection) { create(:collection, user: user, manifests: manifests) }

    before { sign_in(user) }

    scenario 'A mirador instance is available on the new workspace form' do
      visit "/collections/#{collection.id}"
      click_link 'New Workspace'

      expect(page).to have_css('script', visible: false, text: /Mirador/)
      expect(page).to have_css('script', visible: false, text: /#{manifest1.url}/)
      expect(page).to have_css('script', visible: false, text: /#{manifest2.url}/)
    end

    scenario 'I can create a new workspace from a collection' do
      visit "/collections/#{collection.id}"

      click_link 'New Workspace'

      fill_in 'Name', with: 'My New Workspace'
      click_button 'Create Workspace'

      expect(page).to have_css('h1', text: 'Workspace: My New Workspace')
      expect(Workspace.last.name).to eq 'My New Workspace'
    end

    scenario 'I can view a workspace (with mirador instance)' do
      url = 'http://manifest-host/iiif/manifest.json'
      workspace = create(:workspace, collection: collection, data: {
        options: { data: [url] }
      }.to_json)
      visit "/collections/#{collection.id}/workspaces/#{workspace.id}"

      expect(page).to have_css('h1', text: "Workspace: #{workspace.name}")
      expect(page).to have_css('script', visible: false, text: /Mirador/)
      expect(page).to have_css('script', visible: false, text: /#{url}/)
    end
  end
end
