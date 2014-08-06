require 'spec_helper'

describe MadMimi do
  subject { MadMimi }

  before(:each) do
    ::Spree::MadMimi::Config[:access_token]  = ''
    ::Spree::MadMimi::Config[:refresh_token] = ''
  end

  let(:sample_access_token)  { '33a5253abc24e6359072bc245f7682a4ada6629b6f893a4df379808d20bf60bd' }
  let(:sample_refresh_token) { 'd479bb6fd732ac29cec4fd145e3ae6cfa77b262856da07595b5674704485821b' }
  let(:sample_api_key)       { 'fa7521dbbdbe80a3107ab96890b1485a968e2b736e316ac8' }
  let(:sample_store_url)     { 'http://localhost:4000' }

  let(:sample_connect_params) do
    {
      access_token:  sample_access_token,
      refresh_token: sample_refresh_token,
      store_url:     sample_store_url
    }
  end

  let(:sample_activate_addon_params) do
    {
      body: {
        access_token:  sample_access_token,
        api_key:       sample_api_key,
        store_url:     sample_store_url
      }
    }
  end

  let(:sample_deactivate_addon_params) do
    {
      body: {
        access_token:  sample_access_token
      }
    }
  end

  let!(:user) { create(:admin_user, spree_api_key: sample_api_key) }

  context 'when MadMimi API works' do
    use_vcr_cassette "mad_mimi/success", record: :new_episodes

    context '.access_token' do
      it "reads from config" do
        ::Spree::MadMimi::Config[:access_token] = sample_access_token
        subject.access_token.should eq(sample_access_token)
      end
    end

    context '.access_token=' do
      it "assigns to config" do
        expect { subject.access_token = sample_access_token }
          .to change{ ::Spree::MadMimi::Config[:access_token] }
            .from('')
            .to(sample_access_token)
      end
    end

    context '.refresh_token' do
      it "reads from config" do
        ::Spree::MadMimi::Config[:refresh_token] = sample_refresh_token
        subject.refresh_token.should eq(sample_refresh_token)
      end
    end

    context '.refresh_token=' do
      it "assigns to config" do
        expect { subject.refresh_token = sample_refresh_token }
          .to change{ ::Spree::MadMimi::Config[:refresh_token] }
            .from('')
            .to(sample_refresh_token)
      end
    end

    context '.connect' do
      it "should be successful" do
        subject.connect(user, sample_connect_params).should be_successful
      end

      it "assigns config values" do
        MadMimi.access_token.should  be_empty
        MadMimi.refresh_token.should be_empty

        subject.connect(user, sample_connect_params)

        MadMimi.access_token.should  eq(sample_access_token)
        MadMimi.refresh_token.should eq(sample_refresh_token)
      end

      it "activates addon" do
        MadMimi.any_instance.should_receive(:activate_addon).with(user, sample_store_url)

        subject.connect(user, sample_connect_params)
      end
    end

    context '.disconnect' do
      it "should be successful" do
        subject.disconnect.should be_successful
      end

      it "clears config values" do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token

        subject.disconnect

        MadMimi.access_token.should  be_empty
        MadMimi.refresh_token.should be_empty
      end

      it "deactivates addon" do
        MadMimi.any_instance.should_receive(:deactivate_addon)

        subject.disconnect
      end
    end

    context '.activate_addon' do
      before(:each) do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token
      end

      it "should be successful" do
        subject.activate_addon(user, sample_store_url).should be_successful
      end

      it "makes a post request to MadMimi API" do
        user.spree_api_key = sample_api_key

        MadMimi.should_receive(:post).with(
          "/spree/activate", sample_activate_addon_params
        ).and_call_original

        subject.activate_addon(user, sample_store_url)
      end
    end

    context '.deactivate_addon' do
      before(:each) do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token
      end

      it "should be successful" do
        result = subject.deactivate_addon
        result.should be_successful
      end

      it "makes a post request to MadMimi API" do
        MadMimi.should_receive(:post).with(
          "/spree/deactivate", sample_deactivate_addon_params
        ).and_call_original

        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token

        subject.deactivate_addon
      end
    end

    context '.connected?' do
      it "returns true if both access_token and refresh_token are present" do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token

        subject.connected?.should be_truthy
      end

      it "returns false if only access_token is present" do
        MadMimi.access_token = sample_access_token

        subject.connected?.should be_falsy
      end

      it "returns false if only refresh_token is present" do
        MadMimi.refresh_token = sample_refresh_token

        subject.connected?.should be_falsy
      end

      it "returns false if both access_token and refresh_token are empty" do
        subject.connected?.should be_falsy
      end
    end

    context '.validate' do
      it "should be successful if valid" do
        MadMimi.any_instance.stub(:valid? => true)

        subject.validate.should be_successful
      end

      it "should be successful if not valid but successfully refreshed access token" do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token

        MadMimi.any_instance.stub(:valid? => false)

        subject.validate.should be_successful
      end

      it "does not update tokens if valid" do
        MadMimi.any_instance.stub(:valid? => true)

        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token

        subject.validate

        MadMimi.access_token.should  eq(sample_access_token)
        MadMimi.refresh_token.should eq(sample_refresh_token)
      end

      it "updates tokens if not valid" do
        MadMimi.any_instance.stub(:valid? => false)
        MadMimi.any_instance.stub(:refresh_access_token => true)
        MadMimi.any_instance.stub(:response => {
          'access_token'  => 'TEST_ACCESS_TOKEN',
          'refresh_token' => 'TEST_REFRESH_TOKEN'
        })

        subject.validate

        MadMimi.access_token.should  eq('TEST_ACCESS_TOKEN')
        MadMimi.refresh_token.should eq('TEST_REFRESH_TOKEN')
      end
    end
  end

  shared_examples "failing MadMimi API calls" do
    context '.connect' do
      it "should not be successful" do
        subject.connect(user, sample_connect_params).should_not be_successful
      end

      it "holds an error message" do
        subject.connect(user, sample_connect_params).tap do |result|
          result.errors.should_not be_empty
        end
      end
    end

    context '.disconnect' do
      it "should not be successful" do
        subject.disconnect.should_not be_successful
      end

      it "holds an error message" do
        subject.disconnect.tap do |result|
          result.errors.should_not be_empty
        end
      end
    end

    context '.activate_addon' do
      it "should not be successful" do
        subject.activate_addon(user, sample_store_url).should_not be_successful
      end

      it "holds an error message" do
        subject.activate_addon(user, sample_store_url).tap do |result|
          result.errors.should_not be_empty
        end
      end
    end

    context '.deactivate_addon' do
      it "should not be successful" do
        subject.deactivate_addon.should_not be_successful
      end

      it "holds an error message" do
        subject.deactivate_addon.tap do |result|
          result.errors.should_not be_empty
        end
      end
    end

    context '.validate' do
      it "should not be successful if not valid and unsuccessfully refreshed access tokens" do
        MadMimi.any_instance.stub(:valid? => false)

        subject.validate.should_not be_successful
      end
    end
  end

  context "when MadMimi API fails" do
    use_vcr_cassette "mad_mimi/failure", record: :new_episodes

    include_examples "failing MadMimi API calls"
  end

  context "when no connection" do
    before(:each) do
      MadMimi.stub(:get).and_raise  Errno::EHOSTUNREACH
      MadMimi.stub(:post).and_raise Errno::EHOSTUNREACH
    end

    include_examples "failing MadMimi API calls"
  end

end
