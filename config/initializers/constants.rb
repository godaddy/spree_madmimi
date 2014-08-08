unless defined?(CONSTANTS)
  case Rails.env.to_sym
  when :staging
    MAD_MIMI_ID     = "1133a46ee7f0aee3c2a33ba10e4eb4ef3a1d1fbedf9866b265a1cfcf2622c42c"
    MAD_MIMI_SECRET = "a49a34921fcae3f7bfc41593be76b8dbf2f8df7f8148f2e1cd0cca8866d3a2ab"

    MAD_MIMI_URL    = "http://madmimi.staging.loudlucy.co"
    MAD_MIMI_API    = MAD_MIMI_URL

    SPREE_URL       = "https://test-spree-madmimi.herokuapp.com"
    SPREE_AUTH_URL  = "#{SPREE_URL}/auth/madmimi"
  else
    MAD_MIMI_ID     = "1133a46ee7f0aee3c2a33ba10e4eb4ef3a1d1fbedf9866b265a1cfcf2622c42c"
    MAD_MIMI_SECRET = "a49a34921fcae3f7bfc41593be76b8dbf2f8df7f8148f2e1cd0cca8866d3a2ab"

    MAD_MIMI_URL    = "http://localhost:3000"
    MAD_MIMI_API    = MAD_MIMI_URL

    SPREE_URL       = "http://localhost:4000"
    SPREE_AUTH_URL  = "#{SPREE_URL}/auth/madmimi"
  end

  CONSTANTS       = true
end
