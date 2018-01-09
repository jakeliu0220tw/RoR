OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, 'GOOGLE_KEY', 'SECRET'
	provider :facebook, 'FB_ID', 'SECRET'
end

# just for debugging, ignore SSL verify
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE