require 'savon'
require "gyoku"
require 'pry'

# class Demo


# end
# client = Savon.client(wsdl: "http://mail.frontierutilities.com:50388/EnrollAPI/WebAPI.asmx?wsdl")
client = Savon.client do
  wsdl "http://mail.frontierutilities.com:50388/EnrollAPI/WebAPI.asmx?wsdl"
  convert_request_keys_to :none
  env_namespace :soapenv
  pretty_print_xml true  
end

## Authentication
response = client.call(:authentication, message: { 
	'Authenticate' => {
		'UserName' => 'CMU_01',
		'Password' => 'UjtE5581'
	}
	})

session_id = response.body[:authentication_response][:authentication_result][:session_id]
data = client.call(:get_products, message: { 'SessionID' => session_id })

product_details = data.body[:get_products_response][:get_products_result][:product_details][:product_details]

product_details.each do |product|
	puts product[:product_title]
end


