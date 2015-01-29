class Transaction < ActiveRecord::Base

	def self.successful(msisdn,amount)
		create(subscriber_number:msisdn,amount:amount,status:"Charged Successfully")
	end

	def self.failed(msisdn,amount)
		create(subscriber_number:msisdn,amount:amount,status:"Insufficient Balance")
	end

	def self.invalid(msisdn,msg)
		create(subscriber_number:msisdn,status:"Invalid Keyword: #{msg}")
	end
end
