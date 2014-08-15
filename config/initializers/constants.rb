unless defined?(CONSTANTS)
  MAD_MIMI_URL = case Rails.env.to_sym
    when :production
      "https://madmimi.com"
    when :staging
      "http://madmimi.staging.loudlucy.co"
    else
      "http://localhost:3000"
    end

  SPREE_AUTH_PATH = "/auth/madmimi"

  CONSTANTS        = true
end
