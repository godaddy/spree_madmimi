require 'spec_helper'

describe MadMimi do
  subject { MadMimi }

  before(:each) do
    @originals = MadMimi::ATTRIBUTES.inject({}) do |hash, attribute|
      hash.tap do |h|
        h[attribute] = ::Spree::MadMimi::Config[attribute]
        ::Spree::MadMimi::Config[attribute] = ''
      end
    end
  end

  after(:each) do
    @originals.each_pair do |attribute, value|
      ::Spree::MadMimi::Config[attribute] = value
    end
  end

  let(:sample_access_token)  { 'fef30b33104f976f842d6c06da8c34afedd7c6089d872d41857a76d411b6266e' }
  let(:sample_refresh_token) { '81cfd40cbfa3a246e84198892a6e0792d4393afaef7e035da54054f7f8e121cd' }
  let(:sample_api_key)       { 'fa7521dbbdbe80a3107ab96890b1485a968e2b736e316ac8' }
  let(:sample_store_url)     { 'http://localhost:4000' }
  let(:sample_webform_id)    { 29 }

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

  let(:sample_fetch_webforms_params) do
    sample_deactivate_addon_params
  end

  let(:sample_fetch_webform_params) do
    sample_fetch_webforms_params
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

    context '.webform_id' do
      it "reads from config" do
        ::Spree::MadMimi::Config[:webform_id] = sample_webform_id
        subject.webform_id.should eq(sample_webform_id)
      end
    end

    context '.webform_id=' do
      it "assigns to config" do
        expect { subject.webform_id = sample_webform_id }
          .to change{ ::Spree::MadMimi::Config[:webform_id] }
            .from(0)
            .to(sample_webform_id)
      end
    end

    context '.webform_visible?' do
      it "returns true if .webform_id is not zero" do
        subject.webform_id = 3
        subject.webform_visible?.should be_truthy
      end

      it "returns false if .webform_id is zero" do
        subject.webform_id = 0
        subject.webform_visible?.should be_falsy
      end
    end

    context '.api_user_id' do
      it "reads from config" do
        ::Spree::MadMimi::Config[:api_user_id] = user.id
        subject.api_user_id.should eq(user.id)
      end
    end

    context '.api_user_id=' do
      it "assigns to config" do
        expect { subject.api_user_id = user.id }
          .to change{ ::Spree::MadMimi::Config[:api_user_id] }
            .from(0)
            .to(user.id)
      end
    end

    context '.api_user' do
      it "returns user if it exists" do
        ::Spree::MadMimi::Config[:api_user_id] = user.id
        subject.api_user.should eq(user)
      end

      it "returns nil if user does not exist" do
        ::Spree::MadMimi::Config[:api_user_id] = 0
        subject.api_user.should be_nil
      end
    end

    context '.api_user_exists?' do
      it "returns true if user exists" do
        ::Spree::MadMimi::Config[:api_user_id] = user.id
        subject.api_user_exists?.should be_truthy
      end

      it "returns nil if user does not exist" do
        ::Spree::MadMimi::Config[:api_user_id] = 0
        subject.api_user_exists?.should be_falsy
      end
    end

    context '.api_user_or_admin' do
      let(:api_user) { create(:admin_user) }

      it "returns api_user if it exists" do
        ::Spree::MadMimi::Config[:api_user_id] = api_user.id
        subject.api_user_or_admin.should eq(api_user)
        subject.api_user_or_admin.should_not eq(user)
      end

      it "returns admin if user does not exist" do
        ::Spree::MadMimi::Config[:api_user_id] = 0
        subject.api_user_or_admin.should eq(user)
      end
    end

    context '.connect' do
      it "should be successful" do
        subject.connect(sample_connect_params).should be_successful
      end

      it "assigns config values" do
        MadMimi.access_token.should  be_empty
        MadMimi.refresh_token.should be_empty

        subject.connect(sample_connect_params)

        MadMimi.access_token.should  eq(sample_access_token)
        MadMimi.refresh_token.should eq(sample_refresh_token)
      end

      it "activates addon" do
        MadMimi.any_instance.should_receive(:activate_addon).with(sample_store_url)

        subject.connect(sample_connect_params)
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
        subject.activate_addon(sample_store_url).should be_successful
      end

      it "makes a post request to MadMimi API" do
        MadMimi.should_receive(:post).with(
          "/spree/activate", sample_activate_addon_params
        ).and_call_original

        subject.activate_addon(sample_store_url)
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
        MadMimi.any_instance.stub(:valid? => true)
        MadMimi.should_receive(:post).with(
          "/spree/deactivate", sample_deactivate_addon_params
        ).and_call_original

        subject.deactivate_addon
      end
    end

    context '.fetch_webforms' do
      before(:each) do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token
      end

      it "should be successful" do
        result = subject.fetch_webforms
        result.should be_successful
      end

      it "makes a get request to MadMimi API" do
        MadMimi.any_instance.stub(:valid? => true)
        MadMimi.should_receive(:get).with(
          "/apiv2/signups", sample_fetch_webforms_params
        ).and_call_original

        subject.fetch_webforms
      end

      it "populates webforms attribute" do
        subject.fetch_webforms.tap do |result|
          result.webforms.should be_present
        end
      end
    end

    context '.webforms' do
      before(:each) do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token
      end

      it "should not be empty" do
        subject.webforms.should be_present
      end
    end

    context '.fetch_webform' do
      before(:each) do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token
      end

      it "should be successful" do
        result = subject.fetch_webform(sample_webform_id)
        result.should be_successful
      end

      it "makes a get request to MadMimi API" do
        MadMimi.any_instance.stub(:valid? => true)
        MadMimi.should_receive(:get).with(
          "/apiv2/signups/#{ sample_webform_id }", sample_fetch_webform_params
        ).and_call_original

        subject.fetch_webform(sample_webform_id)
      end

      it "populates webforms attribute" do
        subject.fetch_webform(sample_webform_id).tap do |result|
          result.webform.should be_present
        end
      end
    end

    context '.webform' do
      before(:each) do
        MadMimi.access_token  = sample_access_token
        MadMimi.refresh_token = sample_refresh_token
      end

      it "should not be empty" do
        subject.webform(sample_webform_id).should be_present
      end

      it "should use webform_id from config if nothing specified" do
        MadMimi.webform_id = sample_webform_id
        subject.webform.should be_present
        subject.webform.id.should eq(sample_webform_id)
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
        subject.connect(sample_connect_params).should_not be_successful
      end

      it "holds an error message" do
        subject.connect(sample_connect_params).tap do |result|
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
        subject.activate_addon(sample_store_url).should_not be_successful
      end

      it "holds an error message" do
        subject.activate_addon(sample_store_url).tap do |result|
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

    context '.fetch_webforms' do
      it "should not be successful" do
        subject.fetch_webforms.should_not be_successful
      end

      it "holds an error message" do
        subject.fetch_webforms.tap do |result|
          result.errors.should_not be_empty
        end
      end
    end

    context '.webforms' do
      it "should be empty" do
        subject.webforms.should be_blank
      end
    end

    context '.fetch_webform' do
      it "should not be successful" do
        subject.fetch_webform(sample_webform_id).should_not be_successful
      end

      it "holds an error message" do
        subject.fetch_webform(sample_webform_id).tap do |result|
          result.errors.should_not be_empty
        end
      end
    end

    context '.webform' do
      it "should be empty" do
        subject.webform(sample_webform_id).should be_blank
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
