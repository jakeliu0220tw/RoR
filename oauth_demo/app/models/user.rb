class User < ActiveRecord::Base

	def self.from_omniauth(auth)
		Rails.logger.debug "User.from_omniauth"
		Rails.logger.debug "auth = #{auth}"
		Rails.logger.debug "auth.provider = #{auth.provider}"
		Rails.logger.debug "auth.uid = #{auth.uid}"
		Rails.logger.debug "auth.credentials = #{auth[:credentials]}"
		Rails.logger.debug "auth.info = #{auth[:info]}"
		
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		unless user
			user = User.new
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
		user		
	end

end
