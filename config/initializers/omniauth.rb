if MadMimi.client_id.present? && MadMimi.client_secret.present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :madmimi, MadMimi.client_id, MadMimi.client_secret
  end
end

OmniAuth::Strategies::Madmimi.option(
  :authorize_params,
  layout: "compact",
  scope: "public write"
)

OmniAuth::Strategies::Madmimi.option(
  :client_options,
  site: MAD_MIMI_URL)

OmniAuth.config.failure_raise_out_environments = []
