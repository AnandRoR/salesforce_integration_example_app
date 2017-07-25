class Salesforce::API
  #------NOTES ON SALESFORCE API------
  #  1. requires Restforce gem
  
  #------USE EXAMPLE-------
  #
  #  class User < ActiveRecord::Base 
  #    def sync_with_salesforce
  #      sf = Salesforce::API.connect_to_salesforce
  #      sf_contact = sf.query("SELECT Id, Name, Email FROM Contact")
  #    end
  #  end 

  #Establish a connection using the Restforce gem
  def self.connect_to_salesforce
    sf = nil
    begin
      sf = Restforce.new
    rescue Exception => e
      error_message = "Failed to connect to Salesforce using restforce gem!"
    end
    sf
  end

end