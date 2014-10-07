require 'csv'
require 'open-uri'

namespace :import do

  desc "Imports a CSV for Security Title"
  task sectitle: :environment do
    csv_file_path = ENV['CSV']
    debug = !!(ENV['debug'])
    raise "Must provide CSV" if csv_file_path.blank?
    if csv_file_path.match(/^http/i)
      csv_file_path = open(csv_file_path)
    end
    client = Client.find_by(name: "Security Title Company")
    product = Product.find_by(name: "Tracking")
    CSV.foreach(csv_file_path, headers: true) do |line|
      j = line.to_hash
      next if j["File Number"].blank?
      puts "Line data: #{j.inspect}" if debug
      state = State.find_by(abbreviation: j["State"].chomp)
      county_name = j["County"].gsub(/^\s*|\s$/, '')
      county = state.counties.find_by(name: county_name)
      emp_name = j["Employee"].gsub(/^\s*|\s$/, '').upcase.gsub(/MCC/, 'McC')
      requestor = client.users.where(name: emp_name).first_or_initialize
      puts "Employee data: #{requestor.inspect}" if debug
      if !requestor.new_record?
        begin
          close_date = Date.strptime(j["Close Date"], "%m/%d/%y")
        rescue
          close_date = Date.today
        end
        file_number = j["File Number"].to_s
        unless file_number.match(/^R/)
          file_number = "R#{file_number}"
        end
        job = Job.where(job_type: 'tracking',
           client: client,
           requestor: requestor,
           file_number: file_number,
           state: state,
           county: county,
           close_on: close_date
         ).first_or_initialize
        job_product = JobProduct.where(
          job: job,
          product: product,
          price_cents: 100,
          deed_of_trust_number: j["DOT #"]
        ).first_or_initialize
        if j["Lender"].present?
          job_product.beneficiary_name = j["Lender"]
        end
        if debug
          puts "Job data: #{job.inspect}"
          puts "Job Product data: #{job_product.inspect}"
          puts "######################################################"
        else
          job.save!
          job_product.save!
          if j["Release #"].present? && j["Recording Date"].present?
            recording_date = Date.strptime(j["Recording Date"], "%m/%d/%y")
            job_product.recorded_on = recording_date
            job_product.new_deed_of_trust_number = j["Release #"]
            job_product.save
          end
        end
      else
        puts "Problem importing File Number: #{j["File Number"]}"
      end
    end
  end

  desc "Verifies all required dependencies exist before performing import"
  task prepare: :environment do
    csv_file_path = ENV['CSV']
    if csv_file_path.match(/^http/i)
      csv_file_path = open(csv_file_path)
    end
    client = Client.find_by(name: "Security Title Company")
    raise "Client doesn't exist!" unless client
    product = Product.find_by(name: "Tracking")
    raise "Tracking product doesn't exist!" unless product
    missing_states = []
    missing_counties = []
    missing_people = []

    CSV.foreach(csv_file_path, headers: true) do |line|
      j = line.to_hash
      next if j["File Number"].blank?
      state = State.find_by(abbreviation: j["State"].chomp)
      unless state
        missing_states << j["State"]
      else
        county_name = j["County"].gsub(/^\s*|\s$/, '')
        county = state.counties.find_by(name: county_name)
        missing_counties << county_name unless county
      end
      emp_name = j["Employee"].gsub(/^\s*|\s$/, '').upcase.gsub(/MCC/, 'McC')
      requestor = client.users.where(name: emp_name).first_or_initialize
      missing_people << emp_name if requestor.new_record?
    end

    missing_states.uniq!
    missing_counties.uniq!
    missing_people.uniq!

    if missing_states.length > 0
      puts "####################################"
      puts " The following STATES are missing:"
      puts missing_states.to_yaml
    end

    if missing_counties.length > 0
      puts "#####################################"
      puts " The following COUNTIES are missing:"
      puts missing_counties.to_yaml
    end

    if missing_people.length > 0
      puts "####################################"
      puts " The following PEOPLE are missing:"
      puts missing_people.to_yaml
    end

    if missing_people.length > 0 || missing_counties.length > 0 || missing_states.length > 0
      puts "--------------------> Summary <----------------------"
      puts "  -> Missing states:   #{missing_states.length}"
      puts "  -> Missing counties: #{missing_counties.length}"
      puts "  -> Missing people:   #{missing_people.length}"
      puts " "
      puts " You must clear these problems, then run this again. Make sure all errors are clear before importing."
    else
      puts "-------> Everything looks good. Go for it. <------------"
    end
  end

end


