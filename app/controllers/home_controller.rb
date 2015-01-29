class HomeController < ApplicationController
  
  ##ROOT
  def index
  	@transactions = Transaction.all
  end

  ##REDIRECT URI
  ##expected format:
  ##{"access_token":"PFfCtDm1nbH5dBCqOBCpIWcTrJjYw-k9juP42vlUnP4", "subscriber_number":"9170000000"}
  def redirect
  	msisdn,token = params[:subscriber_number],params[:access_token]
  	User.saveToken(msisdn,token)
  end

  ##NOTIFU URI
  def notify
  	## opt-out expected format:
  	## {"unsubscribed":{"subscriber_number":"9170000000", 
  	##  "access_token":"PFfCtDm1nbH5dBCqOBCpIWcTrJjYw-k9juP42vlUnP4", 
  	## "timestamp":"2015-01-29T03:04:02.989Z"}}}
  	if params['unsubscribed']
		
		##INIT VARS
	  	p = params['unsubscribed']
	  	msisdn,token,timestamp = p['subscriber_number'],p['access_token'],p['timestamp']
	  	User.deleteUser(token,timestamp)
  	
  	else
  	
  	## SMS-MO expected format:
  	## {"inboundSMSMessageList":{"inboundSMSMessage":
  	## 	[{"dateTime":"Thu Jan 29 2015 03:20:22 GMT+0000 (UTC)", "destinationAddress":"tel:21589113", 
  	## 		"messageId":"54c9a6f699d81cf92c0b1b1c", "message":"Adfgg", "resourceURL"=>nil, 
  	## 		"senderAddress":"tel:+63917000000"}], 
	##       "numberOfMessagesInThisBatch":1, "resourceURL":nil, "totalNumberOfPendingMessages":0}}}
  	
  	##INIT VARS
  	p = params['inboundSMSMessageList']['inboundSMSMessage'].first
  	msisdn,msg  = p['senderAddress'], p['message']
	msisdn = msisdn[7..msisdn.length]
	##from +63917000000 to 917000000

	userToken = User.find_by_msisdn(msisdn).token
  		case msg.downcase
  		when 'buy 0'		
			chargeUser(msisdn,"0.00",userToken)
  		when 'buy 1'
  			chargeUser(msisdn,"1.0",userToken)
  		when 'buy 2'
  			chargeUser(msisdn,"2.00",userToken)
  		else
  			sendSmsInvalid(msisdn,msg,userToken)
  		end
  	end
  end

end
