require 'rails_helper'

describe Admin::EmbeddableHostsController do
  it "is a subclass of AdminController" do
    expect(Admin::EmbeddableHostsController < Admin::AdminController).to eq(true)
  end

  context 'while logged in as an admin' do
    let(:admin) { Fabricate(:admin) }
    let(:embeddable_host) { Fabricate(:embeddable_host) }

    before do
      sign_in(admin)
    end

    describe '#create' do
      it "logs embeddable host create" do
        post "/admin/embeddable_hosts.json", params: {
          embeddable_host: { host: "test.com" }
        }

        expect(response.status).to eq(200)
        expect(UserHistory.where(acting_user_id: admin.id,
                                 action: UserHistory.actions[:embeddable_host_create]).exists?).to eq(true)
      end
    end

    describe '#update' do
      it "logs embeddable host update" do
        put "/admin/embeddable_hosts/#{embeddable_host.id}.json", params: {
          embeddable_host: { host: "test.com", class_name: "test-class", category_id: "3" }
        }

        expect(response.status).to eq(200)
        expect(UserHistory.where(acting_user_id: admin.id,
                                 action: UserHistory.actions[:embeddable_host_update],
                                 new_value: "host: test.com, class_name: test-class, category_id: 3").exists?).to eq(true)
      end
    end

    describe '#destroy' do
      it "logs embeddable host destroy" do
        delete "/admin/embeddable_hosts/#{embeddable_host.id}.json", params: {}

        expect(response.status).to eq(200)
        expect(UserHistory.where(acting_user_id: admin.id, action: UserHistory.actions[:embeddable_host_destroy]).exists?).to eq(true)
      end
    end
  end
end
