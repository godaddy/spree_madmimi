Rails.application.config.middleware.use OmniAuth::Builder do
  provider :madmimi, MAD_MIMI_ID, MAD_MIMI_SECRET
end

OmniAuth::Strategies::Madmimi.option(
  :authorize_params,
  layout: "compact",
  scope: "public write"
)

OmniAuth::Strategies::Madmimi.option(
  :client_options,
  site: MAD_MIMI_URL) if Rails.env.development?

OmniAuth.config.failure_raise_out_environments = []
