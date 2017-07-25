class User < ActiveRecord::Base

  after_update :update_contact_in_salesforce	

  #connect to salesforce and try to get all updated or new Contacts
  def self.create_or_update_user_contact_in_salesforce
    search_critera = "LastModifiedDate >= YESTERDAY AND LastModifiedDate <= TODAY"
    #connect to salesforce
    sf = Salesforce::API.connect_to_salesforce
    sf_contacts = sf.query("SELECT Id, Name, Email FROM Contact WHERE #{search_critera}")
    sf_contacts.each do |contact|
      if User.exists?(sf_contact_id: contact.Id)
        user = User.where(sf_contact_id: contact.Id).first
        begin
          if user.present?
            user.update(name: contact.Name)
          else
            User.create( sf_contact_id: contact.Id, first_name: contact.Name, email: contact.Email )
          end
        rescue Exception => e
          error_message = "Failed to update Contact.Id: #{sf_contact_id}; Contact.Email: #{sf_contact_email}"
        end
      end
    end
  end

  #Update Contact in saleforce
  def update_contact_in_salesforce
  	sf = Salesforce::API.connect_to_salesforce
  	contact_id = self.sf_contact_id
  	sf.update(
        "Contact",
        Id: "#{contact_id}",
        Name: "#{self.first_name}",
        Email: "#{self.email}",
      )
  end
end
