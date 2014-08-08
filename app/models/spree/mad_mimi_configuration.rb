module Spree
  class MadMimiConfiguration < Preferences::Configuration
    preference :access_token,  :string
    preference :refresh_token, :string
    preference :webform_id,    :integer
  end
end
