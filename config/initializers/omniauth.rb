Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  if ENV['TWITTER_KEY']
    provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
    Rails.logger.info "twitter oauth enabled"
  end
  if ENV['GOOGLE_KEY']
    provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
    Rails.logger.info "google oauth enabled"
  end
end

Donethat::Application.config.omniauth_provider_mapping = { google_oauth2: 'GoogleUser' }