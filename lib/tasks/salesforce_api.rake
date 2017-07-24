namespace :salesforce_api do
  desc "sync with saleforce and get updates of contact"
  task :update_user_details => :environment do
  	User.create_or_update_user_contact_in_salesforce
  end
end