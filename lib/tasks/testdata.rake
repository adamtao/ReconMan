namespace :testdata do

	desc "Generates a bunch of records to work with in development"
	task load: :environment do
		dev_only!
		generate_data
	end

	desc "Delete out all test data"
	task clear: :environment do
		dev_only!
		clear_data
	end

	desc "Delete and re-generate test data"
	task reload: :environment do
		dev_only!
		clear_data
		generate_data
	end

	def dev_only!
		raise "This should only be run in the development environment" unless Rails.env.development?
	end

	def generate_data
		puts "Loading up internal employees"
		employees = User.processors
		existing_users = employees.count
		if existing_users < 5
			1..(5 - existing_users).times do 
				name = Forgery::Name.full_name
				pw = Forgery(:basic).password(:at_least => 7, :at_most => 10)
				employees << User.find_or_create_by!(email: "#{name.parameterize}@#{Rails.application.secrets.domain_name}", name: name) do |user|
			        user.password = pw
			        user.password_confirmation = pw
			        # user.confirm!
			        user.processor!
			      end
				puts "Created User: #{User.last.name}"
			end
		end
		puts "Loading up clients"
		puts "============================="
		existing_clients = Client.all.count
		if existing_clients < 10
			1..(10 - existing_clients).times do 
				Client.create(name: "#{Bazaar.object.to_s.titleize} #{['Co.', 'Inc.', 'LLC'].sample}",
					creator: employees.sample)
				puts "Created Client: #{Client.last.name}"
			end
		end
		puts "Loading up branches"
		puts "============================="
		Client.all.each do |client|
			branches = client.branches.count
			if branches < 3
				1..(3 - branches).times do 
					city = Forgery::Address.city
					client.branches << Branch.new(
						name: "#{client.name.split(" ").map {|name| name[0].chr }[0,2].join.upcase} #{city}", 
						address: Forgery::Address.street_address,
						city: city,
						state: states_with_counties.sample,
						zipcode: Forgery::Address.zip,
						phone: Forgery::Address.phone,
						creator: employees.sample
					)
					puts "Created #{client.name} Branch: #{client.branches.last.name}"
				end
			end
		end
		puts "Loading up branch users"
		puts "============================="
		Branch.all.each do |branch|
			users = branch.users.count
			if users < 2
				1..(2 - users).times do 
					name = Forgery::Name.full_name
					pw = Forgery(:basic).password(:at_least => 7, :at_most => 10)
					User.find_or_create_by!(email: "#{name.parameterize}@#{branch.client.name.parameterize}.com", name: name) do |user|
				        user.password = pw
				        user.password_confirmation = pw
				        user.branch_id = branch.id
				        # user.confirm!
				        user.client!
				      end
					puts "Created #{branch.client.name} (#{branch.name}) user: #{User.last.name} #{User.last.email}"
				end
			end
		end
		puts "Loading up New Jobs"
		puts "============================="
		new_jobs = Job.where.not(workflow_state: 'new').count
		if new_jobs < 5
			(10 - new_jobs).times do
				user = User.where.not(branch_id: nil).sample
				puts "Creating a job on behalf of #{user.name} of #{user.branch.client.name}/#{user.branch.name}"
				job_type = Job.job_types.sample
				Job.create!(
					requestor: user,
					client: user.branch.client,
					address: Forgery::Address.street_address,
					city: Forgery::Address.city,
					state: user.branch.state,
					zipcode: Forgery::Address.zip,
					county: user.branch.state.counties.sample,
					old_owner: Forgery::Name.full_name,
					new_owner: Forgery::Name.full_name,
					job_type: job_type,
					job_products_attributes: {
						"0" => {
				          product_id: Product.where(job_type: job_type.to_s).id,
				          deed_of_trust_number: Forgery::CreditCard.number[2,6] + "-" + Forgery::CreditCard.number[6,5],
				          beneficiary_name: "#{Bazaar.object.to_s.titleize} Holdings",
				          beneficiary_account: Forgery::CreditCard.number[2,8] + "-" + Forgery::CreditCard.number[6,5],
				          payoff_amount: 999.99,
				          developer: Bazaar.object.to_s.titleize,
				          parcel_number: Forgery::CreditCard.number[2,3] + "-" + Forgery::CreditCard.number[6,5],
				          parcel_legal_description: "A #{['residential', 'industrial', 'commercial'].sample} property"
				        }
					},
					creator: employees.sample
				)
			end
		end

		puts "Loading up Open Jobs"
		puts "============================="
		open_jobs = Job.where.not(workflow_state: 'new').count
		if open_jobs < 15
			(15 - open_jobs).times do
				user = User.where.not(branch_id: nil).sample
				puts "Creating a job on behalf of #{user.name} of #{user.branch.client.name}/#{user.branch.name}"
				job = Job.create!(
					requestor: user,
					client: user.branch.client,
					address: Forgery::Address.street_address,
					city: Forgery::Address.city,
					state: user.branch.state,
					zipcode: Forgery::Address.zip,
					county: user.branch.state.counties.sample,
					old_owner: Forgery::Name.full_name,
					new_owner: Forgery::Name.full_name,
					job_type: job_type,
					job_products_attributes: {
						"0" => {
				          product_id: Product.where(job_type: job_type.to_s).id,
				          deed_of_trust_number: Forgery::CreditCard.number[2,6] + "-" + Forgery::CreditCard.number[6,5],
				          beneficiary_name: "#{Bazaar.object.to_s.titleize} Holdings",
				          beneficiary_account: Forgery::CreditCard.number[2,8] + "-" + Forgery::CreditCard.number[6,5],
				          payoff_amount: 999.99,
				          developer: Bazaar.object.to_s.titleize,
				          parcel_number: Forgery::CreditCard.number[2,3] + "-" + Forgery::CreditCard.number[6,5],
				          parcel_legal_description: "A #{['residential', 'industrial', 'commercial'].sample} property"
				        }
					},
					creator: employees.sample,
					modifier: employees.sample
				)
				reconveyance = job.dashboard_product
				reconveyance.search!
			end
		end

		puts "Loading up Closed Jobs"
		puts "============================="
		closed_jobs = Job.where(workflow_state: 'complete').count
		if closed_jobs < 10
			(10 - closed_jobs).times do
				user = User.where.not(branch_id: nil).sample
				puts "Creating a closed job on behalf of #{user.name} of #{user.branch.client.name}/#{user.branch.name}"
				job = Job.create!(
					requestor: user,
					client: user.branch.client,
					address: Forgery::Address.street_address,
					city: Forgery::Address.city,
					state: user.branch.state,
					zipcode: Forgery::Address.zip,
					county: user.branch.state.counties.sample,
					old_owner: Forgery::Name.full_name,
					new_owner: Forgery::Name.full_name,
					created_at: 4.weeks.ago,
					job_type: job_type,
					job_products_attributes: {
						"0" => {
				          product_id: Product.where(job_type: job_type.to_s).id,
				          deed_of_trust_number: Forgery::CreditCard.number[2,6] + "-" + Forgery::CreditCard.number[6,5],
				          beneficiary_name: "#{Bazaar.object.to_s.titleize} Holdings",
				          beneficiary_account: Forgery::CreditCard.number[2,8] + "-" + Forgery::CreditCard.number[6,5],
				          payoff_amount: 999.99,
				          developer: Bazaar.object.to_s.titleize,
				          parcel_number: Forgery::CreditCard.number[2,3] + "-" + Forgery::CreditCard.number[6,5],
				          parcel_legal_description: "A #{['residential', 'industrial', 'commercial'].sample} property"
				        }
					},
					creator: employees.sample,
					modifier: employees.sample
				)
				reconveyance = job.dashboard_product
				reconveyance.search!
				reconveyance.mark_complete!
				# this should also make the job complete
				
			end
		end				
	end

	def clear_data
		puts "Clearing out clients, branches, client users and jobs"
		Client.destroy_all
		Branch.destroy_all
		Job.destroy_all
		User.where(role: 1).destroy_all
	end

	def states_with_counties
		State.active.select{|s| s if s.counties.count > 0}
	end

end