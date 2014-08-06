require 'spec_helper'

describe Spree::Admin::SessionsController do
  use_vcr_cassette "mad_mimi/success", record: :new_episodes

  routes { Spree::Core::Engine.routes }

  let!(:user)  { create(:admin_user) }

  before(:each) do
    Spree::BaseController.any_instance.stub(:current_spree_user => user)
  end

  context "GET 'create'" do
    let(:params) do
      {
        access_token:  '33a5253abc24e6359072bc245f7682a4ada6629b6f893a4df379808d20bf60bd',
        refresh_token: 'd479bb6fd732ac29cec4fd145e3ae6cfa77b262856da07595b5674704485821b',
        store_url:     'http://localhost:4000'
      }
    end

    before(:each) do
      subject.stub(:store_url => params[:store_url])

      request.env['omniauth.auth'] = OpenStruct.new({
        credentials: OpenStruct.new({
          token:         params[:access_token],
          refresh_token: params[:refresh_token]
        })
      })
    end

    shared_examples "successful response" do
      it "is successful" do
        get :create, { provider: :madmimi }
        response.should be_successful
      end

      it "renders close_window template" do
        get :create, { provider: :madmimi }
        response.should render_template("close_window")
      end
    end

    context "when MadMimi API works" do
      include_examples "successful response"

      it "connects MadMimi" do
        MadMimi.should_receive(:connect).with(user, params).and_call_original
        get :create, { provider: :madmimi }
      end

      it "shows a notice" do
        get :create, { provider: :madmimi }
        request.flash[:success].should be_present
      end
    end

    context "when MadMimi API fails" do
      use_vcr_cassette "mad_mimi/failure", record: :new_episodes

      include_examples "successful response"

      it "shows an error" do
        get :create, { provider: :madmimi }
        request.flash[:error].should be_present
      end
    end
  end

  context "GET 'failure'" do
    it "is successful" do
      get :failure
      response.should be_successful
    end

    it "renders close_window template" do
      get :failure
      response.should render_template("close_window")
    end

    it "shows an error" do
      get :failure, { message: 'test' }
      request.flash[:error].should include('test')
    end
  end

  context "DELETE 'destroy'" do
    shared_examples "successful response" do
      it "is successful" do
        delete :destroy
        response.should be_successful
      end

      it "disconnects MadMimi" do
        MadMimi.should_receive(:disconnect).and_call_original
        delete :destroy
      end
    end

    context "when MadMimi API works" do
      include_examples "successful response"

      it "shows a notice" do
        delete :destroy
        request.flash[:success].should be_present
      end
    end

    context "when MadMimi API fails" do
      use_vcr_cassette "mad_mimi/failure", record: :new_episodes

      include_examples "successful response"

      it "shows an error" do
        delete :destroy
        request.flash[:error].should be_present
      end
    end
  end

end
