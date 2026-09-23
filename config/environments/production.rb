Cmms::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # The Vercel container directly serves this legacy Rails app, so Rails must
  # serve files from /public instead of relying on an external nginx/apache.
  config.action_dispatch.x_sendfile_header = nil
  config.serve_static_assets = true

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
end
