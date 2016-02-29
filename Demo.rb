require 'savon'
require "gyoku"
require 'pry'
require 'csv'

# client = Savon.client(wsdl: "http://mail.frontierutilities.com:50388/EnrollAPI/WebAPI.asmx?wsdl")
client = Savon.client do
  wsdl "http://mail.frontierutilities.com:50388/EnrollAPI/WebAPI.asmx?wsdl"
  convert_request_keys_to :none
  env_namespace :soapenv
  pretty_print_xml true  
end

## Authentication
message = { 'Authenticate' => { 'UserName' => 'CMU_01', 'Password' => 'UjtE5581' } }
response = client.call(:authentication, message: message)

session_id = response.body[:authentication_response][:authentication_result][:session_id]
data = client.call(:get_products, message: { 'SessionID' => session_id })

product_details = data.body[:get_products_response][:get_products_result][:product_details][:product_details]

id = []
title = []
description = []
rate_type = []
type = []

CSV.open("details.csv", "wb") do |csv|
	csv << ["ID", "Title", "Description", "Type", "Rate Type"]
	product_details.each do |product|
		id = product[:product_id]
		title = product[:product_title]
		description = product[:product_description]
		type = product[:product_type]
		rate_type = product[:rate_type]
		csv << [id, title, description, type, rate_type]	
	end
end




