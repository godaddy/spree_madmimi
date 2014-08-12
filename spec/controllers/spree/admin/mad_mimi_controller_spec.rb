require 'spec_helper'

describe Spree::Admin::MadMimiController do
  routes { Spree::Core::Engine.routes }

  let!(:user)  { create(:admin_user) }

  before(:each) do
    Spree::BaseController.any_instance.stub(:current_spree_user => user)
  end

  context "GET 'edit'" do
    it "is successful" do
      get :edit
      response.should be_successful
    end

    it "renders edit template" do
      get :edit
      response.should render_template("edit")
    end
  end

  context "PUT 'update'" do
    it "is successful" do
      put :update, webform_id: 1
      response.should be_redirect
    end

    it "renders edit template" do
      put :update, webform_id: 1
      response.should redirect_to("/admin/mad_mimi/edit")
    end

    it "updates config file" do
      MadMimi.stub(:connected? => true)
      expect { put :update, webform_id: 123 }
        .to change{ ::Spree::MadMimi::Config[:webform_id] }
          .to(123)
    end
  end

end
