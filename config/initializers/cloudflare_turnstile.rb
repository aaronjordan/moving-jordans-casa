# https://github.com/instrumentl/rails-cloudflare-turnstile
RailsCloudflareTurnstile.configure do |c|
  c.site_key = Rails.application.credentials.dig(:cloudflare_turnstile, :site_key) || ""
  c.secret_key = Rails.application.credentials.dig(:cloudflare_turnstile, :secret_key) || ""
  c.fail_open = true
end
