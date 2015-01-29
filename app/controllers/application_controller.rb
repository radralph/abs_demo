class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  #protect_from_forgery with: :exception

  ##Charging API
  def chargeUser(msisdn,amount,userToken)
  	content = open('https://devapi.globelabs.com.ph/payments/2307').read
	json = JSON.parse(content)
	increment = json['result'].first['reference_code'].to_i+1
	uri = URI.parse("https://devapi.globelabs.com.ph/payment/v1/transactions/amount/")
    uri.query = "access_token=#{userToken}"
    response = HTTParty.post(uri,
	:body => {:description => 'desc', :endUserId => msisdn, :amount => amount, :referenceCode => 91131000001,
	:transactionOperationStatus => 'charged'})
    output(response)
    response.code.eql?(201) ? (Transaction.successful(msisdn,amount) ; sendSms(msisdn,amount,userToken)) : (Transaction.failed(msisdn,amount))
  end

  ##SMS API
  def sendSms(msisdn,amount,userToken)
  	uri = "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/9113/requests?access_token=" + userToken 
	message = "You have successfully purchased a Video Package worth #{amount} . This package will be valid until Feb 28, 2015.\nFor concerns email video@mail.com"
	response = HTTParty.post(uri,
		:body => {:address => msisdn, :message => message})
	output(response)
  end

  def sendSmsInvalid(msisdn,msg,userToken)
	message = "Invalid amount.\nPlease see avaialable keywords:\nBuy 0\nBuy 1\nBuy 2"
	uri = "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/9113/requests?access_token=" + userToken 
	response = HTTParty.post(uri,
		:body => {:address => msisdn, :message => message})
	Transaction.invalid(msisdn,msg)
	output(response)
  end

  def output(response)
	puts "---RESPONSE---"
	puts "code:"
	puts response.code
	puts "--------------"
	puts "message:"
	puts response.message
	puts "--------------"
	puts "body:"
	puts response.body
	puts "---RESPONSE---"
  end
end
