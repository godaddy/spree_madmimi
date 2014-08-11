OmniAuth::Strategies::Madmimi.option(
  :authorize_params,
  layout: "compact",
  scope: "public write"
)

OmniAuth::Strategies::Madmimi.option(
  :client_options,
  site: MAD_MIMI_URL)

OmniAuth.config.failure_raise_out_environments = []
