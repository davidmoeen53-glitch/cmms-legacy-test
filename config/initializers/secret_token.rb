# Secret used to verify signed cookies.
# Vercel/test deployments must provide SECRET_TOKEN as an environment variable.
secret_token = ENV['SECRET_TOKEN']

if Rails.env.production? && (secret_token.nil? || secret_token.length < 64)
  raise 'SECRET_TOKEN must be set to a random value of at least 64 characters'
end

Cmms::Application.config.secret_token = secret_token || 'development-only-secret-token-change-me-1234567890'
