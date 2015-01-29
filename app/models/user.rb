class User < ActiveRecord::Base
	
	def self.saveToken(msisdn,token)
		create(msisdn:msisdn,token:token)
	end

	def self.deleteUser(token,timestamp)
		user = self.find_by_token(token)
    	destroy(user.id)
	end

end
