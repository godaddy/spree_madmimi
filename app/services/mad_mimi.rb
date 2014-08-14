class MadMimi
  include HTTParty

  ATTRIBUTES = %w( access_token refresh_token webform_id )

  base_uri MAD_MIMI_URL

  class << self

    def connected?
      access_token.present? && refresh_token.present?
    end

    ATTRIBUTES.each do |attribute|
      define_method attribute do
        ::Spree::MadMimi::Config[attribute.to_sym]
      end

      define_method "#{ attribute }=" do |value|
        ::Spree::MadMimi::Config[attribute.to_sym] = value
      end
    end

    def client_id
      Rails.application.config.madmimi[:client_id] if Rails.application.config.respond_to?(:madmimi)
    end

    def client_secret
      Rails.application.config.madmimi[:client_secret] if Rails.application.config.respond_to?(:madmimi)
    end

    def webform_visible?
      !self.webform_id.zero?
    end

    def connect(user, options={})
      new.tap do |instance|
        instance.connect(user, options)
      end
    end

    def disconnect
      new.tap do |instance|
        instance.disconnect
      end
    end

    def activate_addon(user, store_url)
      new.tap do |instance|
        instance.activate_addon(user, store_url)
      end
    end

    def deactivate_addon
      new.tap do |instance|
        instance.deactivate_addon
      end
    end

    def validate
      new.tap do |instance|
        instance.validate
      end
    end

    def fetch_webforms
      new.tap do |instance|
        instance.fetch_webforms
      end
    end

    def webforms
      result = fetch_webforms
      result.webforms
    end

    def fetch_webform(id = nil)
      new.tap do |instance|
        instance.fetch_webform(id_or_default(id))
      end
    end

    def webform(id = nil)
      result = fetch_webform(id)
      result.webform
    end

    private

      def id_or_default(id)
        !id.nil? && id != :default ? id : webform_id
      end

  end

  attr_accessor :errors, :response, :webforms, :webform

  def initialize
    @success  = true
    @errors   = []
    @webforms = []
  end

  def successful?
    @success
  end

  def connect(user, options={})
    ATTRIBUTES.each do |attribute|
      self.class.send("#{ attribute }=", options.delete(attribute.to_sym))
    end

    @success = activate_addon(user, options.delete(:store_url))
  end

  def disconnect
    @success = deactivate_addon

    ATTRIBUTES.each do |attribute|
      self.class.send("#{ attribute }=", nil)
    end
  end

  def activate_addon(user, store_url)
    return unless @success = valid?

    validate_response do
      self.class.post(
        "/spree/activate",
        body: {
          access_token: self.class.access_token,
          api_key:      user.spree_api_key,
          store_url:    store_url
        }
      )
    end
  end

  def deactivate_addon
    return unless @success = validate

    validate_response do
      self.class.post(
        "/spree/deactivate",
        body: {
          access_token: self.class.access_token
        }
      )
    end
  end

  def validate
    return @success = true if valid?

    if refresh_access_token
      self.class.access_token  = response["access_token"]
      self.class.refresh_token = response["refresh_token"]
    end
  end

  def fetch_webforms
    validate

    validate_response do
      response = self.class.get(
        "/apiv2/signups",
        body: {
          access_token: self.class.access_token
        }
      )

      if response.code == 200
        @webforms = objectify(
          response.parsed_response.try(:[], 'signups')
        )
      end

      response
    end
  end

  def fetch_webform(id)
    validate

    validate_response do
      response = self.class.get(
        "/apiv2/signups/#{ id }",
        body: {
          access_token: self.class.access_token
        }
      )

      if response.code == 200
        @webform = objectify(
          response.parsed_response
        )
      end

      response
    end
  end

  private

    def refresh_access_token
      validate_response do
        self.class.post(
          "/oauth/token",
          body: {
            client_id:     self.class.client_id,
            client_secret: self.class.client_secret,
            refresh_token: self.class.refresh_token,
            grant_type:    "refresh_token"
          }
        )
      end
    end

    def valid?
      validate_response do
        self.class.get("/oauth/token/info", body: { access_token: self.class.access_token })
      end
    end

    def handle_error(error)
      errors << error.message
      return false
    end

    def validate_response
      response = yield
      errors << response.body if response.code != 200
      @response = response.parsed_response
      @success &&= response.code == 200
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
      @success = handle_error(e)
    end

    def objectify(hash_or_collection)
      if hash_or_collection.is_a?(Array)
        hash_or_collection.map{ |o| objectify(o) }
      elsif hash_or_collection.is_a?(Hash)
        OpenStruct.new(hash_or_collection)
      end
    end

end
