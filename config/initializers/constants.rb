unless defined?(CONSTANTS)
  case Rails.env.to_sym
  when :staging
    MAD_MIMI_ID     = "1133a46ee7f0aee3c2a33ba10e4eb4ef3a1d1fbedf9866b265a1cfcf2622c42c"
    MAD_MIMI_SECRET = "a49a34921fcae3f7bfc41593be76b8dbf2f8df7f8148f2e1cd0cca8866d3a2ab"

    MAD_MIMI_URL    = "http://madmimi.staging.loudlucy.co"
    MAD_MIMI_API    = MAD_MIMI_URL
  else
    MAD_MIMI_ID     = "aeead7844f1ff7c7fb2922829439363df2472a3dae7f239ee6a46f7a70adf4df"
    MAD_MIMI_SECRET = "33fbeeeb5e98262bdcaf7d15f9fbf98461b76d1fba121cc0148fddd79554e0e8"

    MAD_MIMI_URL    = "http://localhost:3000"
    MAD_MIMI_API    = MAD_MIMI_URL
  end

  SPREE_AUTH_PATH  = "/auth/madmimi"

  CONSTANTS       = true
end
