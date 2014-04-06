Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, Donethat::Application.config.omniauth_twitter_key, Donethat::Application.config.omniauth_twitter_secret
  provider :google_oauth2, Donethat::Application.config.omniauth_google_key, Donethat::Application.config.omniauth_google_secret
end

Donethat::Application.config.omniauth_provider_mapping = { google_oauth2: 'GoogleUser' }