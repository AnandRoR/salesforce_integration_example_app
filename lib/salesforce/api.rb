class Salesforce::API
  #------NOTES ON SALESFORCE API------
  #  1. requires Restforce gem
  #  2. the "find" method returns all records if the Id is blank...this behavior means we are safer using the "query" method

  #------USE EXAMPLE-------
  #
  #  class LearnerClass < ActiveRecord::Base
  #    include Salesforce::Connect
  #
  #    def sync_with_salesforce
  #      sf_learner = find_salesforce_learner_by_sf_learner_id(self.sf_learner_id)
  #
  #      ...
  #    end

  # INTEGRATION NOTES:
  # -- Salesforce 'Account' is equivalent to FacilitatorSource 'Organization'
  # -- Salesforce 'Contact' is equivalent to FacilitatorSource 'Facilitator' (User)
  # -- Salesforce 'Classes__c' is equivalent to FacilitatorSource 'LearnerClass'
  # -- Salesforce 'Learners__c' is equivalent to FacilitatorSource 'Learner'
  # -- Salesforce 'Evaluations__c' is equivalent to FacilitatorSource 'CoreStrengthsEvaluation'

  #Establish a connection using the Restforce gem
  def self.connect_to_salesforce
    sf = nil

    begin
      sf = Restforce.new
    rescue Exception => e
      error_message = "Failed to connect to Salesforce using restforce gem!"
      Airbrake.notify_or_ignore(e, parameters: {error_message: error_message}, cgi_data: ENV.to_hash)
    end

    sf
  end

  #Find a single record in a Salesforce object that matches the id
  def self.find_in_salesforce(sf: nil, object_name: "", id: "")
    sf_object = nil

    begin
      if !sf.nil? && !id.blank?
        sf_object = sf.find("#{object_name}", "#{id}")
      end
    rescue Exception => e
      error_message = "Failed to find in Salesforce! Object: #{object_name}; Id: #{id}"
      Airbrake.notify_or_ignore(e, parameters: {error_message: error_message}, cgi_data: ENV.to_hash)
    end

    sf_object
  end

  #Account
  def self.find_salesforce_account_by_id(sf: nil, sf_account_id: "")
    self.find_in_salesforce(sf: sf, object_name: "Account", id: sf_account_id)
  end

  #Contact
  def self.find_salesforce_contact_by_id(sf: nil, sf_contact_id: "")
    self.find_in_salesforce(sf: sf, object_name: "Contact", id: sf_contact_id)
  end

  #Class
  def self.find_salesforce_class_by_id(sf: nil, sf_class_id: "")
    self.find_in_salesforce(sf: sf, object_name: "Classes__c", id: sf_class_id)
  end

  #Learner
  def self.find_salesforce_learner_by_id(sf: nil, sf_learner_id: "")
    self.find_in_salesforce(sf: sf, object_name: "Learners__c", id: sf_learner_id)
  end

  #Evaluation
  def self.find_salesforce_evaluation_by_id(sf: nil, sf_evaluation_id: "")
    self.find_in_salesforce(sf: sf, object_name: "Evaluations__c", id: sf_evaluation_id)
  end
  
  #Saleforce time format
  def self.date_format(date_time)
    date_time.strftime('%Y-%m-%dT%H:%M:%S%z').insert(-3, ':')
  end

end