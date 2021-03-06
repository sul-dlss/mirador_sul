# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Workspaces', type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET /collections/:collection_id/workspaces/new' do
    context 'an authorized user' do
      let(:collection) { create(:collection, user: user) }

      it 'is allowed' do
        get new_collection_workspace_path(collection)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'an authorized user' do
      let(:collection) { create(:collection) }

      it 'is not allowed' do
        expect do
          get new_collection_workspace_path(collection)
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET /workspaces/:id' do
    context 'an authorized user' do
      let(:workspace) { create(:workspace, user: user) }
      it 'is allowed' do
        get workspace_path(workspace)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'a public workspace' do
      let(:workspace) { create(:workspace, public: true) }

      it 'is allowed' do
        get workspace_path(workspace)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'an authorized user' do
      let(:workspace) { create(:workspace) }

      it 'is not allowed' do
        expect do
          get workspace_path(workspace)
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET /workspaces/:id/edit' do
    context 'an authorized user' do
      let(:workspace) { create(:workspace, user: user) }
      it 'is allowed' do
        get edit_workspace_path(workspace)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'an authorized user' do
      let(:workspace) { create(:workspace) }
      it 'is not allowed' do
        expect do
          get edit_workspace_path(workspace)
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'POST /collections/:collection_id/manifests' do
    context 'an authorized user' do
      let(:collection) { create(:collection, user: user) }
      it 'is allowed' do
        post collection_workspaces_path(collection_id: collection.id, workspace: { name: 'New Workspace 1' })
        expect(response).to have_http_status(:found)
        expect(Workspace.last.name).to eq 'New Workspace 1'
      end
    end

    context 'an anonymous user' do
      let(:collection) { create(:collection) }
      it 'is not allowed' do
        expect do
          post collection_workspaces_path(collection_id: collection.id, workspace: { name: 'does not matter' })
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'PUT /manifests/:manifest_id' do
    context 'an authorized user' do
      let(:workspace) { create(:workspace, user: user, data: { height: '100px' }.to_json) }
      it 'is allowed' do
        put workspace_path(id: workspace.id, workspace: { name: 'New Workspace 1' })

        expect(response).to have_http_status(:found)
        expect(Workspace.last.name).to eq 'New Workspace 1'
      end
    end

    context 'an anonymous user' do
      let(:workspace) { create(:workspace, data: { height: '100px' }.to_json) }
      it 'is not allowed' do
        expect do
          put workspace_path(id: workspace.id, workspace: { name: 'does not matter' })
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'DELETE /workspaces/:id' do
    context 'an authorized user' do
      let(:workspace) { create(:workspace, user: user) }
      it 'is allowed' do
        delete workspace_path(workspace)
        expect(response).to have_http_status(:found)
      end
    end

    context 'an anonymous user' do
      let(:workspace) { create(:workspace) }
      it 'is not allowed' do
        expect do
          delete workspace_path(workspace)
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end
