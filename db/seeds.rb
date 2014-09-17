# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'CREATING DEFAULT PRODUCTS & SERVICES'

Product.create([
	{ name: "Reconveyance Tracking", creator: user, price: 19.95, job_type: 'tracking', performs_search: true},
	{ name: "Title Defect Clearing", creator: user, price: 19.95 },
	{ name: "Documentation", creator: user, price: 19.95 }, 
  { name: "Title Search", creator: user, price: 12.95, job_type: 'search', performs_search: true }
])

puts 'LOADING STATES'

State.create([
  { :name => 'Alabama', :abbreviation => 'AL'},
  { :name => 'Alaska', :abbreviation => 'AK'},
  { :name => 'Arizona', :abbreviation => 'AZ'},
  { :name => 'Arkansas', :abbreviation => 'AR'},
  { :name => 'California', :abbreviation => 'CA'},
  { :name => 'Colorado', :abbreviation => 'CO'},
  { :name => 'Connecticut', :abbreviation => 'CT'},
  { :name => 'Delaware', :abbreviation => 'DE'},
  { :name => 'District of Columbia', :abbreviation => 'DC'},
  { :name => 'Florida', :abbreviation => 'FL'},
  { :name => 'Georgia', :abbreviation => 'GA'},
  { :name => 'Hawaii', :abbreviation => 'HI'},
  { :name => 'Idaho', :abbreviation => 'ID'},
  { :name => 'Illinois', :abbreviation => 'IL'},
  { :name => 'Indiana', :abbreviation => 'IN'},
  { :name => 'Iowa', :abbreviation => 'IA'},
  { :name => 'Kansas', :abbreviation => 'KS'},
  { :name => 'Kentucky', :abbreviation => 'KY'},
  { :name => 'Louisiana', :abbreviation => 'LA'},
  { :name => 'Maine', :abbreviation => 'ME'},
  { :name => 'Maryland', :abbreviation => 'MD'},
  { :name => 'Massachusetts', :abbreviation => 'MA'},
  { :name => 'Michigan', :abbreviation => 'MI'},
  { :name => 'Minnesota', :abbreviation => 'MN'},
  { :name => 'Mississippi', :abbreviation => 'MS'},
  { :name => 'Missouri', :abbreviation => 'MO'},
  { :name => 'Montana', :abbreviation => 'MT'},
  { :name => 'Nebraska', :abbreviation => 'NE'},
  { :name => 'Nevada', :abbreviation => 'NV'},
  { :name => 'New Hampshire', :abbreviation => 'NH'},
  { :name => 'New Jersey', :abbreviation => 'NJ'},
  { :name => 'New Mexico', :abbreviation => 'NM'},
  { :name => 'New York', :abbreviation => 'NY'},
  { :name => 'North Carolina', :abbreviation => 'NC'},
  { :name => 'North Dakota', :abbreviation => 'ND'},
  { :name => 'Ohio', :abbreviation => 'OH'},
  { :name => 'Oklahoma', :abbreviation => 'OK'},
  { :name => 'Oregon', :abbreviation => 'OR'},
  { :name => 'Pennsylvania', :abbreviation => 'PA'},
  { :name => 'Rhode Island', :abbreviation => 'RI'},
  { :name => 'South Carolina', :abbreviation => 'SC'},
  { :name => 'South Dakota', :abbreviation => 'SD'},
  { :name => 'Tennessee', :abbreviation => 'TN'},
  { :name => 'Texas', :abbreviation => 'TX'},
  { :name => 'Utah', :abbreviation => 'UT'},
  { :name => 'Vermont', :abbreviation => 'VT'},
  { :name => 'Virginia', :abbreviation => 'VA'},
  { :name => 'Washington', :abbreviation => 'WA'},
  { :name => 'West Virginia', :abbreviation => 'WV'},
  { :name => 'Wisconsin', :abbreviation => 'WI'},
  { :name => 'Wyoming', :abbreviation => 'WY'}
])
State.where(abbreviation: %w(AZ CA CO ID MT NB ND NM NV OK OR SD TX UT WA WY)).update_all(active: true)

puts 'COUNTIES'


s = State.find_by_name('Alabama')
["Autauga",         "Cleburne",        "Fayette",         "Limestone",       "Pike",           
"Baldwin",         "Coffee",          "Franklin",        "Lowndes",         "Randolph",       
"Barbour",         "Colbert",         "Geneva",          "Macon",           "Russell",        
"Bibb",            "Conecuh",         "Greene",          "Madison",         "Shelby",         
"Blount",          "Coosa",           "Hale",            "Marengo",         "St. Clair",
"Bullock",         "Covington",       "Henry",           "Marion",          "Sumter",         
"Butler",          "Crenshaw",        "Houston",         "Marshall",        "Talladega",      
"Calhoun",         "Cullman",         "Jackson",         "Mobile",          "Tallapoosa",     
"Chambers",        "Dale",            "Jefferson",       "Monroe",          "Tuscaloosa",     
"Cherokee",        "Dallas",          "Lamar",           "Montgomery",      "Walker",         
"Chilton",         "De Kalb",         "Lauderdale",      "Morgan",          "Washington",     
"Choctaw",         "Elmore",          "Lawrence",        "Perry",           "Wilcox",         
"Clarke",          "Escambia",        "Lee",             "Pickens",         "Winston",        
"Clay",            "Etowah"].each {|c| County.find_or_create_by!(state: s, name: c)}                 

s = State.find_by_name('Alaska')
["1st (SE)",        "2nd (NW)",        "3rd (SC)",        "4th (C)"].each {|c| County.find_or_create_by!(state: s, name: c)}

s = State.find_by_name('Arizona')
["Apache",          "Gila",            "La Paz",          "Navajo",          "Santa Cruz",
"Cochise",         "Graham",          "Maricopa",        "Pima",            "Yavapai",
"Coconino",        "Greenlee",        "Mohave",          "Pinal",           "Yuma "].each {|c| County.find_or_create_by!(state: s, name: c)}

s = State.find_by_name('Arkansas')
["Arkansas",        "Craighead",       "Howard",          "Miller",          "Randolph",       
"Ashley",          "Crawford",        "Independence",    "Mississippi",     "Saline",         
"Baxter",          "Crittenden",      "Izard",           "Monroe",          "Scott",          
"Benton",          "Cross",           "Jackson",         "Montgomery",      "Searcy",         
"Boone",           "Dallas",          "Jefferson",       "Nevada",          "Sebastian",      
"Bradley",         "Desha",           "Johnson",         "Newton",          "Sevier",         
"Calhoun",         "Drew",            "Lafayette",       "Ouachita",        "Sharp",          
"Carroll",         "Faulkner",        "Lawrence",        "Perry",           "St. Francis",
"Chicot",          "Franklin",        "Lee",             "Phillips",        "Stone",          
"Clark",           "Fulton",          "Lincoln",         "Pike",            "Union",          
"Clay",            "Garland",         "Little River",    "Poinsett",        "Van Buren",
"Cleburne",        "Grant",           "Logan",           "Polk",            "Washington",     
"Cleveland",       "Greene",          "Lonoke",          "Pope",            "White",          
"Columbia",        "Hempstead",       "Madison",         "Prairie",         "Woodruff",       
"Conway",          "Hot Spring",      "Marion",          "Pulaski",         "Yell"].each {|c| County.find_or_create_by!(state: s, name: c)}           

s = State.find_by_name('California')
["Alameda",         "Imperial",        "Modoc",           "San Diego",       "Solano",         
"Alpine",          "Inyo",            "Mono",            "San Francisco",   "Sonoma",         
"Amador",          "Kern",            "Monterey",        "San Joaquin",     "Stanislaus",     
"Butte",           "Kings",           "Napa",            "San Luis Obispo", "Sutter",         
"Calaveras",       "Lake",            "Nevada",          "San Mateo",       "Tehama",         
"Colusa",          "Lassen",          "Orange",          "Santa Barbara",   "Trinity",        
"Contra Costa",    "Los Angeles",     "Placer",          "Santa Clara",     "Tulare",         
"Del Norte",       "Madera",          "Plumas",          "Santa Cruz",      "Tuolumne",       
"El Dorado",       "Marin",           "Riverside",       "Shasta",          "Ventura",        
"Fresno",          "Mariposa",        "Sacramento",      "Sierra",          "Yolo",           
"Glenn",           "Mendocino",       "San Benito",      "Siskiyou",        "Yuba",           
"Humboldt",        "Merced",          "San Bernardino"].each {|c| County.find_or_create_by!(state: s, name: c)}          

s = State.find_by_name('Colorado')
["Adams",           "Custer",          "Hinsdale",        "Mineral",         "Rio Blanco",     
"Alamosa",         "Delta",           "Huerfano",        "Moffat",          "Rio Grande",     
"Arapahoe",        "Denver",          "Jackson",         "Montezuma",       "Routt",
"Archuleta",       "Dolores",         "Jefferson",       "Montrose",        "Sagua",
"Baca",            "Douglas",         "Kiowa",           "Morgan",          "San Juan",       
"Bent",            "Eagle",           "Kit Carson",      "Otero",           "San Miguel",     
"Boulder",
"Broomfield",      "El Paso",         "La Plata",        "Ouray",           "Sedgwick",       
"Chaffee",         "Elbert",          "Lake",            "Park",            "Summit",         
"Cheyenne",        "Fremont",         "Larimer",         "Phillips",        "Teller",         
"Clear Creek",     "Garfield",        "Las Animas",      "Pitkin",          "Washington",     
"Conejos",         "Gilpin",          "Lincoln",         "Prowers",         "Weld",           
"Costilla",        "Grand",           "Logan",           "Pueblo",          "Yuma",           
"Crowley",         "Gunnison",        "Mesa"].each {|c| County.find_or_create_by!(state: s, name: c)}    	              

s = State.find_by_name('Connecticut')
["Fairfield",       "Litchfield",      "New Haven",       "Tolland",         "Windham",        
"Hartford",        "Middlesex",       "New London"].each {|c| County.find_or_create_by!(state: s, name: c)}              

s = State.find_by_name('Delaware')
["Kent",            "New Castle",      "Sussex"].each {|c| County.find_or_create_by!(state: s, name: c)}          

s = State.find_by_name('Florida')
["Alachua",         "Dixie",           "Hillsborough",    "Marion",          "Santa Rosa",     
"Baker",           "Duval",           "Holmes",          "Martin",          "Sarasota",       
"Bay",             "Escambia",        "Indian River",    "Monroe",          "Seminole",       
"Bradford",        "Flagler",         "Jackson",         "Nassau",          "St. Johns",      
"Brevard",         "Franklin",        "Jefferson",       "Okaloosa",        "St. Lucie",      
"Broward",         "Gadsden",         "Lafayette",       "Okeechobee",      "Sumter",         
"Calhoun",         "Gilchrist",       "Lake",            "Orange",          "Suwannee",       
"Charlotte",       "Glades",          "Lee",             "Osceola",         "Taylor",         
"Citrus",          "Gulf",            "Leon",            "Palm Beach",      "Union",          
"Clay",            "Hamilton",        "Levy",            "Pasco",           "Volusia",        
"Collier",         "Hardee",          "Liberty",         "Pinellas",        "Wakulla",        
"Columbia",        "Hendry",          "Madison",         "Polk",            "Walton",         
"Miami-Dade",      "Hernando",        "Manatee",         "Putnam",          "Washington",     
"DeSoto",          "Highlands"].each {|c| County.find_or_create_by!(state: s, name: c)}               

s = State.find_by_name('Georgia')
["Appling",         "Cobb",            "Grady",           "McDuffie",        "Sumter",         
"Atkinson",        "Coffee",          "Greene",          "McIntosh",        "Talbot",         
"Bacon",           "Colquitt",        "Gwinnett",        "Meriwether",      "Taliaferro",     
"Baker",           "Columbia",        "Habersham",       "Miller",          "Tattnall",       
"Baldwin",         "Cook",            "Hall",            "Mitchell",        "Taylor",         
"Banks",           "Coweta",          "Hancock",         "Monroe",          "Telfair",        
"Barrow",          "Crawford",        "Haralson",        "Montgomery",      "Terrell",        
"Bartow",          "Crisp",           "Harris",          "Morgan",          "Thomas",         
"Ben Hill",        "Dade",            "Hart",            "Murray",          "Tift",           
"Berrien",         "Dawson",          "Heard",           "Muscogee",        "Toombs",         
"Bibb",            "DeKalb",          "Henry",           "Newton",          "Towns",          
"Bleckley",        "Decatur",         "Houston",         "Oconee",          "Treutlen",       
"Brantley",        "Dodge",           "Irwin",           "Oglethorpe",      "Troup",          
"Brooks",          "Dooly",           "Jackson",         "Paulding",        "Turner",         
"Bryan",           "Dougherty",       "Jasper",          "Peach",           "Twiggs",         
"Bulloch",         "Douglas",         "Jeff Davis",      "Pickens",         "Union",          
"Burke",           "Early",           "Jefferson",       "Pierce",          "Upson",          
"Butts",           "Echols",          "Jenkins",         "Pike",            "Walker",         
"Calhoun",         "Effingham",       "Johnson",         "Polk",            "Walton",         
"Camden",          "Elbert",          "Jones",           "Pulaski",         "Ware",           
"Candler",         "Emanuel",         "Lamar",           "Putnam",          "Warren",         
"Carroll",         "Evans",           "Lanier",          "Quitman",         "Washington",     
"Catoosa",         "Fannin",          "Laurens",         "Rabun",           "Wayne",          
"Charlton",        "Fayette",         "Lee",             "Randolph",        "Webster",        
"Chatham",         "Floyd",           "Liberty",         "Richmond",        "Wheeler",        
"Chattahoochee",   "Forsyth",         "Lincoln",         "Rockdale",        "White",          
"Chattooga",       "Franklin",        "Long",            "Schley",          "Whitfield",      
"Cherokee",        "Fulton",          "Lowndes",         "Screven",         "Wilcox",         
"Clarke",          "Gilmer",          "Lumpkin",         "Seminole",        "Wilkes",         
"Clay",            "Glascock",        "Macon",           "Spalding",        "Wilkinson",      
"Clayton",         "Glynn",           "Madison",         "Stephens",        "Worth",          
"Clinch",          "Gordon",          "Marion",          "Stewart"].each {|c| County.find_or_create_by!(state: s, name: c)}                 

s = State.find_by_name('Hawaii')
["Hawaii",          "Honolulu",        "Kalawao",         "Kauai",           "Maui"].each {|c| County.find_or_create_by!(state: s, name: c)}           

s = State.find_by_name('Idaho')
["Ada",             "Bonneville",      "Custer",          "Kootenai",        "Owyhee",         
"Adams",           "Boundary",        "Elmore",          "Latah",           "Payette",        
"Bannock",         "Butte",           "Franklin",        "Lemhi",           "Power",          
"Bear Lake",       "Camas",           "Fremont",         "Lewis",           "Shoshone",       
"Benewah",         "Canyon",          "Gem",             "Lincoln",         "Teton",          
"Bingham",         "Caribou",         "Gooding",         "Madison",         "Twin Falls",     
"Blaine",          "Cassia",          "Idaho",           "Minidoka",        "Valley",         
"Boise",           "Clark",           "Jefferson",       "Nez Perce",       "Washington",     
"Bonner",          "Clearwater",      "Jerome",          "Oneida"].each {|c| County.find_or_create_by!(state: s, name: c)}               

s = State.find_by_name('Illinois')
["Adams",           "DuPage",          "Jo Daviess",      "McHenry",         "Sangamon",       
"Alexander",       "Edgar",           "Johnson",         "McLean",          "Schuyler",       
"Bond",            "Edwards",         "Kane",            "Menard",          "Scott",          
"Boone",           "Effingham",       "Kankakee",        "Mercer",          "Shelby",         
"Brown",           "Fayette",         "Kendall",         "Monroe",          "St. Clair",      
"Bureau",          "Ford",            "Knox",            "Montgomery",      "Stark",          
"Calhoun",         "Franklin",        "La Salle",        "Morgan",          "Stephenson",     
"Carroll",         "Fulton",          "Lake",            "Moultrie",        "Tazewell",       
"Cass",            "Gallatin",        "Lawrence",        "Ogle",            "Union",          
"Champaign",       "Greene",          "Lee",             "Peoria",          "Vermilion",      
"Christian",       "Grundy",          "Livingston",      "Perry",           "Wabash",         
"Clark",           "Hamilton",        "Logan",           "Piatt",           "Warren",         
"Clay",            "Hancock",         "Macon",           "Pike",            "Washington",     
"Clinton",         "Hardin",          "Macoupin",        "Pope",            "Wayne",          
"Coles",           "Henderson",       "Madison",         "Pulaski",         "White",          
"Cook",            "Henry",           "Marion",          "Putnam",          "Whiteside",      
"Crawford",        "Iroquois",        "Marshall",        "Randolph",        "Will",           
"Cumberland",      "Jackson",         "Mason",           "Richland",        "Williamson",     
"DeKalb",          "Jasper",          "Massac",          "Rock Island",     "Winnebago",      
"DeWitt",          "Jefferson",       "McDonough",       "Saline",          "Woodford",       
"Douglas",         "Jersey"].each {|c| County.find_or_create_by!(state: s, name: c)}          

s = State.find_by_name('Indiana')
["Adams",           "Elkhart",         "Jefferson",       "Noble",           "Starke",         
"Allen",           "Fayette",         "Jennings",        "Ohio",            "Steuben",        
"Bartholomew",     "Floyd",           "Johnson",         "Orange",          "Sullivan",       
"Benton",          "Fountain",        "Knox",            "Owen",            "Switzerland",    
"Blackford",       "Franklin",        "Kosciusko",       "Parke",           "Tippecanoe",     
"Boone",           "Fulton",          "La Porte",        "Perry",           "Tipton",         
"Brown",           "Gibson",          "Lagrange",        "Pike",            "Union",          
"Carroll",         "Grant",           "Lake",            "Porter",          "Vanderburgh",    
"Cass",            "Greene",          "Lawrence",        "Posey",           "Vermillion",     
"Clark",           "Hamilton",        "Madison",         "Pulaski",         "Vigo",           
"Clay",            "Hancock",         "Marion",          "Putnam",          "Wabash",         
"Clinton",         "Harrison",        "Marshall",        "Randolph",        "Warren",         
"Crawford",        "Hendricks",       "Martin",          "Ripley",          "Warrick",        
"Daviess",         "Henry",           "Miami",           "Rush",            "Washington",     
"DeKalb",          "Howard",          "Monroe",          "Scott",           "Wayne",          
"Dearborn",        "Huntington",      "Montgomery",      "Shelby",          "Wells",          
"Decatur",         "Jackson",         "Morgan",          "Spencer",         "White",          
"Delaware",        "Jasper",          "Newton",          "St. Joseph",      "Whitley",        
"Dubois",          "Jay"].each {|c| County.find_or_create_by!(state: s, name: c)}                     

s = State.find_by_name('Iowa')
["Adair",           "Clay",            "Hancock",         "Madison",         "Sac",            
"Adams",           "Clayton",         "Hardin",          "Mahaska",         "Scott",          
"Allamakee",       "Clinton",         "Harrison",        "Marion",          "Shelby",         
"Appanoose",       "Crawford",        "Henry",           "Marshall",        "Sioux",          
"Audubon",         "Dallas",          "Howard",          "Mills",           "Story",          
"Benton",          "Davis",           "Humboldt",        "Mitchell",        "Tama",           
"Black Hawk",      "Decatur",         "Ida",             "Monona",          "Taylor",         
"Boone",           "Delaware",        "Iowa",            "Monroe",          "Union",          
"Bremer",          "Des Moines",      "Jackson",         "Montgomery",      "Van Buren",      
"Buchanan",        "Dickinson",       "Jasper",          "Muscatine",       "Wapello",        
"Buena Vista",     "Dubuque",         "Jefferson",       "O'Brien",         "Warren",         
"Butler",          "Emmet",           "Johnson",         "Osceola",         "Washington",     
"Calhoun",         "Fayette",         "Jones",           "Page",            "Wayne",          
"Carroll",         "Floyd",           "Keokuk",          "Palo Alto",       "Webster",        
"Cass",            "Franklin",        "Kossuth",         "Plymouth",        "Winnebago",      
"Cedar",           "Fremont",         "Lee",             "Pocahontas",      "Winneshiek",     
"Cerro Gordo",     "Greene",          "Linn",            "Polk",            "Woodbury",       
"Cherokee",        "Grundy",          "Louisa",          "Pottawattamie",   "Worth",          
"Chickasaw",       "Guthrie",         "Lucas",           "Poweshiek",       "Wright",         
"Clarke",          "Hamilton",        "Lyon",            "Ringgold"].each {|c| County.find_or_create_by!(state: s, name: c)}        

s = State.find_by_name('Kansas')
["Allen",           "Doniphan",        "Jackson",         "Morris",          "Saline",         
"Anderson",        "Douglas",         "Jefferson",       "Morton",          "Scott",          
"Atchison",        "Edwards",         "Jewell",          "Nemaha",          "Sedgwick",       
"Barber",          "Elk",             "Johnson",         "Neosho",          "Seward",         
"Barton",          "Ellis",           "Kearny",          "Ness",            "Shawnee",        
"Bourbon",         "Ellsworth",       "Kingman",         "Norton",          "Sheridan",       
"Brown",           "Finney",          "Kiowa",           "Osage",           "Sherman",        
"Butler",          "Ford",            "Labette",         "Osborne",         "Smith",          
"Chase",           "Franklin",        "Lane",            "Ottawa",          "Stafford",       
"Chautauqua",      "Geary",           "Leavenworth",     "Pawnee",          "Stanton",        
"Cherokee",        "Gove",            "Lincoln",         "Phillips",        "Stevens",        
"Cheyenne",        "Graham",          "Linn",            "Pottawatomie",    "Sumner",         
"Clark",           "Grant",           "Logan",           "Pratt",           "Thomas",         
"Clay",            "Gray",            "Lyon",            "Rawlins",         "Trego",          
"Cloud",           "Greeley",         "Marion",          "Reno",            "Wabaunsee",      
"Coffey",          "Greenwood",       "Marshall",        "Republic",        "Wallace",        
"Comanche",        "Hamilton",        "McPherson",       "Rice",            "Washington",     
"Cowley",          "Harper",          "Meade",           "Riley",           "Wichita",        
"Crawford",        "Harvey",          "Miami",           "Rooks",           "Wilson",         
"Decatur",         "Haskell",         "Mitchell",        "Rush",            "Woodson",        
"Dickinson",       "Hodgeman",        "Montgomery",      "Russell",         "Wyandotte"].each {|c| County.find_or_create_by!(state: s, name: c)}            

s = State.find_by_name('Kentucky')
["Adair",           "Clark",           "Harrison",        "Madison",         "Perry",          
"Allen",           "Clay",            "Hart",            "Magoffin",        "Pike",           
"Anderson",        "Clinton",         "Henderson",       "Marion",          "Powell",         
"Ballard",         "Crittenden",      "Henry",           "Marshall",        "Pulaski",        
"Barren",          "Cumberland",      "Hickman",         "Martin",          "Robertson",      
"Bath",            "Daviess",         "Hopkins",         "Mason",           "Rockcastle",     
"Bell",            "Edmonson",        "Jackson",         "McCracken",       "Rowan",          
"Boone",           "Elliott",         "Jefferson",       "McCreary",        "Russell",        
"Bourbon",         "Estill",          "Jessamine",       "McLean",          "Scott",          
"Boyd",            "Fayette",         "Johnson",         "Meade",           "Shelby",         
"Boyle",           "Fleming",         "Kenton",          "Menifee",         "Simpson",        
"Bracken",         "Floyd",           "Knott",           "Mercer",          "Spencer",        
"Breathitt",       "Franklin",        "Knox",            "Metcalfe",        "Taylor",         
"Breckinridge",    "Fulton",          "Larue",           "Monroe",          "Todd",           
"Bullitt",         "Gallatin",        "Laurel",          "Montgomery",      "Trigg",          
"Butler",          "Garrard",         "Lawrence",        "Morgan",          "Trimble",        
"Caldwell",        "Grant",           "Lee",             "Muhlenberg",      "Union",          
"Calloway",        "Graves",          "Leslie",          "Nelson",          "Warren",         
"Campbell",        "Grayson",         "Letcher",         "Nicholas",        "Washington",     
"Carlisle",        "Green",           "Lewis",           "Ohio",            "Wayne",          
"Carroll",         "Greenup",         "Lincoln",         "Oldham",          "Webster",        
"Carter",          "Hancock",         "Livingston",      "Owen",            "Whitley",        
"Casey",           "Hardin",          "Logan",           "Owsley",          "Wolfe",          
"Christian",       "Harlan",          "Lyon",            "Pendleton",       "Woodford"].each {|c| County.find_or_create_by!(state: s, name: c)}      

s = State.find_by_name('Louisiana')
["Acadia",          "Claiborne",       "Jefferson Davis", "Rapides",         "Tangipahoa",     
"Allen",           "Concordia",       "La Salle",        "Red River",       "Tensas",         
"Ascension",       "DeSoto",          "Lafayette",       "Richland",        "Terrebonne",     
"Assumption",      "E. Baton Rouge",  "Lafourche",       "Sabine",          "Union",          
"Avoyelles",       "E. Carroll",      "Lincoln",         "St. Bernard",     "Vermilion",      
"Beauregard",      "E. Feliciana",    "Livingston",      "St. Charles",     "Vernon",         
"Bienville",       "Evangeline",      "Madison",         "St. Helena",      "W. Baton Rouge", 
"Bossier",         "Franklin",        "Morehouse",       "St. James",       "Washington",     
"Caddo",           "Grant",           "Natchitoches",    "St. Landry",      "Webster",        
"Calcasieu",       "Iberia",          "Orleans",         "St. Martin",      "W. Carroll",   
"Caldwell",        "Iberville",       "Ouachita",        "St. Mary",        "W. Feliciana", 
"Cameron",         "Jackson",         "Plaquemines",     "St. Tammany",     "Winn",           
"Catahoula",       "Jefferson",       "Pointe Coupee",   "St. John the Baptist"].each {|c| County.find_or_create_by!(state: s, name: c)}         

s = State.find_by_name('Maine')
["Androscoggin",    "Hancock",         "Lincoln",         "Piscataquis",     "Waldo",          
"Aroostook",       "Kennebec",        "Oxford",          "Sagadahoc",       "Washington",     
"Cumberland",      "Knox",            "Penobscot",       "Somerset",        "York",           
"Franklin"].each {|c| County.find_or_create_by!(state: s, name: c)}                

s = State.find_by_name('Maryland')
["Allegany",        "Caroline",        "Frederick",       "Montgomery",      "Talbot",         
"Anne Arundel",    "Carroll",         "Garrett",         "Prince George's", "Washington",     
"Baltimore",       "Cecil",           "Harford",         "Queen Anne's",    "Wicomico",       
"Baltimore City",  "Charles",         "Howard",          "Somerset",        "Worcester",      
"Calvert",         "Dorchester",      "Kent",            "St. Mary's"].each {|c| County.find_or_create_by!(state: s, name: c)}             

s = State.find_by_name('Massachusetts')
["Barnstable",      "Dukes",           "Hampden",         "Nantucket",       "Suffolk",        
"Berkshire",       "Essex",           "Hampshire",       "Norfolk",         "Worcester",     
"Bristol",         "Franklin",        "Middlesex",       "Plymouth"].each {|c| County.find_or_create_by!(state: s, name: c)}

s = State.find_by_name('Michigan')      
["Alcona",          "Clare",           "Iosco",           "Marquette",       "Oscoda",         
"Alger",           "Clinton",         "Iron",            "Mason",           "Otsego",         
"Allegan",         "Crawford",        "Isabella",        "Mecosta",         "Ottawa",         
"Alpena",          "Delta",           "Jackson",         "Menominee",       "Presque Isle",   
"Antrim",          "Dickinson",       "Kalamazoo",       "Midland",         "Roscommon",      
"Arenac",          "Eaton",           "Kalkaska",        "Missaukee",       "Saginaw",        
"Baraga",          "Emmet",           "Kent",            "Monroe",          "Sanilac",        
"Barry",           "Genesee",         "Keweenaw",        "Montcalm",        "Schoolcraft",    
"Bay",             "Gladwin",         "Lake",            "Montmorency",     "Shiawassee",     
"Benzie",          "Gogebic",         "Lapeer",          "Muskegon",        "St. Clair",      
"Berrien",         "Grand Traverse",  "Leelanau",        "Newaygo",         "St. Joseph",     
"Branch",          "Gratiot",         "Lenawee",         "Oakland",         "Tuscola",        
"Calhoun",         "Hillsdale",       "Livingston",      "Oceana",          "Van Buren",      
"Cass",            "Houghton",        "Luce",            "Ogemaw",          "Washtenaw",      
"Charlevoix",      "Huron",           "Mackinac",        "Ontonagon",       "Wayne",          
"Cheboygan",       "Ingham",          "Macomb",          "Osceola",         "Wexford",        
"Chippewa",        "Ionia",           "Manistee"].each {|c| County.find_or_create_by!(state: s, name: c)}              

s = State.find_by_name('Minnesota')
["Aitkin",          "Dakota",          "Lake of the Woods", "Norman",          "Sibley",         
"Anoka",           "Dodge",           "Lac qui Parle",     "Olmsted",         "St. Louis",      
"Becker",          "Douglas",         "Lake",              "Otter Tail",      "Stearns",        
"Beltrami",        "Faribault",       "Le Sueur",          "Pennington",      "Steele",         
"Benton",          "Fillmore",        "Lincoln",           "Pine",            "Stevens",        
"Big Stone",       "Freeborn",        "Lyon",              "Pipestone",       "Swift",          
"Blue Earth",      "Goodhue",         "Mahnomen",          "Polk",            "Todd",           
"Brown",           "Grant",           "Marshall",          "Pope",            "Traverse",       
"Carlton",         "Hennepin",        "Martin",            "Ramsey",          "Wabasha",        
"Carver",          "Houston",         "McLeod",            "Red Lake",        "Wadena",         
"Cass",            "Hubbard",         "Meeker",            "Redwood",         "Waseca",         
"Chippewa",        "Isanti",          "Mille Lacs",        "Renville",        "Washington",     
"Chisago",         "Itasca",          "Morrison",          "Rice",            "Watonwan",       
"Clay",            "Jackson",         "Mower",             "Rock",            "Wilkin",         
"Clearwater",      "Kanabec",         "Murray",            "Roseau",          "Winona",         
"Cook",            "Kandiyohi",       "Nicollet",          "Scott",           "Wright",         
"Cottonwood",      "Kittson",         "Nobles",            "Sherburne",       "Yellow Medicine",
"Crow Wing",       "Koochiching"].each {|c| County.find_or_create_by!(state: s, name: c)}

s = State.find_by_name('Mississippi')
["Adams",           "Forrest",         "Kemper",          "Newton",          "Sunflower",      
"Alcorn",          "Franklin",        "Lafayette",       "Noxubee",         "Tallahatchie",   
"Amite",           "George",          "Lamar",           "Oktibbeha",       "Tate",           
"Attala",          "Greene",          "Lauderdale",      "Panola",          "Tippah",         
"Benton",          "Grenada",         "Lawrence",        "Pearl River",     "Tishomingo",     
"Bolivar",         "Hancock",         "Leake",           "Perry",           "Tunica",         
"Calhoun",         "Harrison",        "Lee",             "Pike",            "Union",          
"Carroll",         "Hinds",           "Leflore",         "Pontotoc",        "Walthall",       
"Chickasaw",       "Holmes",          "Lincoln",         "Prentiss",        "Warren",         
"Choctaw",         "Humphreys",       "Lowndes",         "Quitman",         "Washington",     
"Claiborne",       "Issaquena",       "Madison",         "Rankin",          "Wayne",          
"Clarke",          "Itawamba",        "Marion",          "Scott",           "Webster",        
"Clay",            "Jackson",         "Marshall",        "Sharkey",         "Wilkinson",      
"Coahoma",         "Jasper",          "Monroe",          "Simpson",         "Winston",        
"Copiah",          "Jefferson",       "Montgomery",      "Smith",           "Yalobusha",      
"Covington",       "Jefferson Davis", "Neshoba",         "Stone",           "Yazoo",          
"DeSoto",          "Jones"].each {|c| County.find_or_create_by!(state: s, name: c)}                   

s = State.find_by_name('Missouri')
["Adair",           "Clay",            "Iron",           "Montgomery",      "Schuyler",       
"Andrew",          "Clinton",         "Jackson",         "Morgan" ,         "Scotland",       
"Atchison",        "Cole",            "Jasper",          "New Madrid",     "Scott",          
"Audrain",         "Cooper",          "Jefferson",       "Newton",          "Shannon",        
"Barry",           "Crawford",        "Johnson",         "Nodaway",        "Shelby",         
"Barton",          "Dade",            "Knox",            "Oregon",          "St. Charles",    
"Bates",           "Dallas",          "Laclede",         "Osage",           "St. Clair",      
"Benton",          "Daviess",         "Lafayette",       "Ozark",           "St. Francois",   
"Bollinger",       "DeKalb",          "Lawrence",        "Pemiscot",        "St. Louis",      
"Boone",           "Dent",            "Lewis",           "Perry",           "St. Louis City", 
"Buchanan",        "Douglas",         "Lincoln",         "Pettis",          "Ste. Genevieve", 
"Butler",          "Dunklin",         "Linn",            "Phelps",          "Stoddard",       
"Caldwell",        "Franklin",        "Livingston",      "Pike",            "Stone",          
"Callaway",        "Gasconade",       "Macon",           "Platte",          "Sullivan",       
"Camden",          "Gentry",          "Madison",         "Polk",            "Taney",          
"Cape Girardeau",  "Greene",          "Maries",          "Pulaski",         "Texas",          
"Carroll",         "Grundy",          "Marion",          "Putnam",          "Vernon",         
"Carter",          "Harrison",        "McDonald",        "Ralls",           "Warren",         
"Cass",            "Henry",           "Mercer",          "Randolph",        "Washington",     
"Cedar",           "Hickory",         "Miller",          "Ray",             "Wayne",          
"Chariton",        "Holt",            "Mississippi",     "Reynolds",        "Webster",        
"Christian",       "Howard",          "Moniteau",        "Ripley",          "Worth",          
"Clark",           "Howell",          "Monroe",          "Saline",          "Wright"].each {|c| County.find_or_create_by!(state: s, name: c)}         

s = State.find_by_name('Montana')
["Beaverhead",      "Fallon",          "Lake",            "Petroleum",       "Sheridan",       
"Big Horn",        "Fergus",          "Lewis & Clark",   "Phillips",        "Silver Bow",     
"Blaine",          "Flathead",        "Liberty",         "Pondera",         "Stillwater",     
"Broadwater",      "Gallatin",        "Lincoln",         "Powder River",    "Sweet Grass",    
"Carbon",          "Garfield",        "Madison",         "Powell",          "Teton",          
"Carter",          "Glacier",         "McCone",          "Prairie",         "Toole",          
"Cascade",         "Golden Valley",   "Meagher",         "Ravalli",         "Treasure",       
"Chouteau",        "Granite",         "Mineral",         "Richland",        "Valley",         
"Custer",          "Hill",            "Missoula",        "Roosevelt",       "Wheatland",      
"Daniels",         "Jefferson",       "Musselshell",     "Rosebud",         "Wibaux",         
"Dawson",          "Judith Basin",    "Park",            "Sanders",         "Yellowstone",    
"Deer Lodge"].each {|c| County.find_or_create_by!(state: s, name: c)}              

s = State.find_by_name('Nebraska')
["Adams",           "Cuming",          "Greeley",         "Loup",            "Saline",         
"Antelope",        "Custer",          "Hall",            "Madison",         "Sarpy",          
"Arthur",          "Dakota",          "Hamilton",        "McPherson",       "Saunders",       
"Banner",          "Dawes",           "Harlan",          "Merrick",         "Scotts Bluff",   
"Blaine",          "Dawson",          "Hayes",           "Morrill",         "Seward",         
"Boone",           "Deuel",           "Hitchcock",       "Nance",           "Sheridan",       
"Box Butte",       "Dixon",           "Holt",            "Nemaha",          "Sherman",        
"Boyd",            "Dodge",           "Hooker",          "Nuckolls",        "Sioux",          
"Brown",           "Douglas",         "Howard",          "Otoe",            "Stanton",        
"Buffalo",         "Dundy",           "Jefferson",       "Pawnee",          "Thayer",         
"Burt",            "Fillmore",        "Johnson",         "Perkins",         "Thomas",         
"Butler",          "Franklin",        "Kearney",         "Phelps",          "Thurston",       
"Cass",            "Frontier",        "Keith",           "Pierce",          "Valley",         
"Cedar",           "Furnas",          "Keya Paha",       "Platte",          "Washington",     
"Chase",           "Gage",            "Kimball",         "Polk",            "Wayne",          
"Cherry",          "Garden",          "Knox",            "Red Willow",      "Webster",        
"Cheyenne",        "Garfield",        "Lancaster",       "Richardson",      "Wheeler",        
"Clay",            "Gosper",          "Lincoln",         "Rock",            "York",           
"Colfax",          "Grant",           "Logan"].each {|c| County.find_or_create_by!(state: s, name: c)}                   

s = State.find_by_name('Nevada')
["Churchill",      "Esmeralda",       "Lander",          "Mineral",         "Storey",         
"Clark",           "Eureka",          "Lincoln",         "Nye",             "Washoe",         
"Douglas",         "Humboldt",        "Lyon",            "Pershing",        "White Pine",     
"Elko"].each {|c| County.find_or_create_by!(state: s, name: c)}                    

s = State.find_by_name('New Hampshire')
["Belknap",         "Cheshire",        "Grafton",         "Merrimack",       "Strafford",      
"Carroll",         "Coos",            "Hillsborough",    "Rockingham",      "Sullivan"].each {|c| County.find_or_create_by!(state: s, name: c)}       

s = State.find_by_name('New Jersey')
["Atlantic",        "Cumberland",      "Hunterdon",       "Morris",          "Somerset",       
"Bergen",          "Essex",           "Mercer",          "Ocean",           "Sussex",         
"Burlington",      "Gloucester",      "Middlesex",       "Passaic",         "Union",          
"Camden",          "Hudson",          "Monmouth",        "Salem",           "Warren",         
"Cape May"].each {|c| County.find_or_create_by!(state: s, name: c)}                

s = State.find_by_name('New Mexico')
["Bernalillo",      "Dona Ana",        "Lincoln",         "Rio Arriba",      "Sierra",         
"Catron",          "Eddy",            "Los Alamos",      "Roosevelt",       "Socorro",        
"Chaves",          "Grant",           "Luna",            "San Juan",        "Taos",           
"Cibola",          "Guadalupe",       "McKinley",        "San Miguel",      "Torrance",       
"Colfax",          "Harding",         "Mora",            "Sandoval",        "Union",          
"Curry",           "Hidalgo",         "Otero",           "Santa Fe",        "Valencia",       
"De Baca",         "Lea",             "Quay"].each {|c| County.find_or_create_by!(state: s, name: c)}                    

s = State.find_by_name('New York')
["Albany",          "Dutchess",        "Madison",         "Otsego",          "Steuben",        
"Allegany",        "Erie",            "Monroe",          "Putnam",          "Suffolk",        
"Bronx",           "Essex",           "Montgomery",      "Queens",          "Sullivan",       
"Broome",          "Franklin",        "Nassau",          "Rensselaer",      "Tioga",          
"Cattaraugus",     "Fulton",          "New York",        "Rockland",        "Tompkins",       
"Cayuga",          "Genesee",         "Niagara",         "Saratoga",        "Ulster",         
"Chautauqua",      "Greene",          "Oneida",          "Schenectady",     "Warren",         
"Chemung",         "Hamilton",        "Onondaga",        "Schoharie",       "Washington",     
"Chenango",        "Herkimer",        "Ontario",         "Schuyler",        "Wayne",          
"Clinton",         "Jefferson",       "Orange",          "Seneca",          "Westchester",    
"Columbia",        "Kings",           "Orleans",         "St. Lawrence",    "Wyoming",        
"Cortland",        "Lewis",           "Oswego",          "Richmond",        "Yates",          
"Delaware",        "Livingston"].each {|c| County.find_or_create_by!(state: s, name: c)}

s = State.find_by_name('North Carolina')
["Alamance",        "Chowan",          "Guilford",        "Mitchell",        "Rutherford",     
"Alexander",       "Clay",            "Halifax",         "Montgomery",      "Sampson",        
"Alleghany",       "Cleveland",       "Harnett",         "Moore",           "Scotland",       
"Anson",           "Columbus",        "Haywood",         "Nash",            "Stanly",         
"Ashe",            "Craven",          "Henderson",       "New Hanover",     "Stokes",         
"Avery",           "Cumberland",      "Hertford",        "Northampton",     "Surry",          
"Beaufort",        "Currituck",       "Hoke",            "Onslow",          "Swain",          
"Bertie",          "Dare",            "Hyde",            "Orange",          "Transylvania",   
"Bladen",          "Davidson",        "Iredell",         "Pamlico",         "Tyrrell",        
"Brunswick",       "Davie",           "Jackson",         "Pasquotank",      "Union",          
"Buncombe",        "Duplin",          "Johnston",        "Pender",          "Vance",          
"Burke",           "Durham",          "Jones",           "Perquimans",      "Wake",           
"Cabarrus",        "Edgecombe",       "Lee",             "Person",          "Warren",         
"Caldwell",        "Forsyth",         "Lenoir",          "Pitt",            "Washington",     
"Camden",          "Franklin",        "Lincoln",         "Polk",            "Watauga",        
"Carteret",        "Gaston",          "Macon",           "Randolph",        "Wayne",          
"Caswell",         "Gates",           "Madison",         "Richmond",        "Wilkes",         
"Catawba",         "Graham",          "Martin",          "Robeson",         "Wilson",         
"Chatham",         "Granville",       "McDowell",        "Rockingham",      "Yadkin",         
"Cherokee",        "Greene",          "Mecklenburg",     "Rowan",           "Yancey"].each {|c| County.find_or_create_by!(state: s, name: c)}                 

s = State.find_by_name('North Dakota')
["Adams",           "Divide",          "LaMoure",         "Pembina",         "Slope",          
"Barnes",          "Dunn",            "Logan",           "Pierce",          "Stark",          
"Benson",          "Eddy",            "McHenry",         "Ramsey",          "Steele",         
"Billings",        "Emmons",          "McIntosh",        "Ransom",          "Stutsman",       
"Bottineau",       "Foster",          "McKenzie",        "Renville",        "Towner",         
"Bowman",          "Golden Valley",   "McLean",          "Richland",        "Traill",         
"Burke",           "Grand Forks",     "Mercer",          "Rolette",         "Walsh",          
"Burleigh",        "Grant",           "Morton",          "Sargent",         "Ward",           
"Cass",            "Griggs",          "Mountrail",       "Sheridan",        "Wells",          
"Cavalier",        "Hettinger",       "Nelson",          "Sioux",           "Williams",       
"Dickey",          "Kidder",          "Oliver"].each {|c| County.find_or_create_by!(state: s, name: c)}          

s = State.find_by_name('Ohio')
["Adams",           "Darke",           "Hocking",         "Miami",           "Sandusky",       
"Allen",           "Defiance",        "Holmes",          "Monroe",          "Scioto",         
"Ashland",         "Delaware",        "Huron",           "Montgomery",      "Seneca",         
"Ashtabula",       "Erie",            "Jackson",         "Morgan",          "Shelby",         
"Athens",          "Fairfield",       "Jefferson",       "Morrow",          "Stark",          
"Auglaize",        "Fayette",         "Knox",            "Muskingum",       "Summit",         
"Belmont",         "Franklin",        "Lake",            "Noble",           "Trumbull",       
"Brown",           "Fulton",          "Lawrence",        "Ottawa",          "Tuscarawas",     
"Butler",          "Gallia",          "Licking",         "Paulding",        "Union",          
"Carroll",         "Geauga",          "Logan",           "Perry",           "Van Wert",       
"Champaign",       "Greene",          "Lorain",          "Pickaway",        "Vinton",         
"Clark",           "Guernsey",        "Lucas",           "Pike",            "Warren",         
"Clermont",        "Hamilton",        "Madison",         "Portage",         "Washington",     
"Clinton",         "Hancock",         "Mahoning",        "Preble",          "Wayne",          
"Columbiana",      "Hardin",          "Marion",          "Putnam",          "Williams",       
"Coshocton",       "Harrison",        "Medina",          "Richland",        "Wood",           
"Crawford",        "Henry",           "Meigs",           "Ross",            "Wyandot",        
"Cuyahoga",        "Highland",        "Mercer"].each {|c| County.find_or_create_by!(state: s, name: c)}

s = State.find_by_name('Oklahoma')
["Adair",           "Cotton",          "Jackson",        "McCurtain",       "Pottawatomie",   
"Alfalfa",         "Craig",           "Jefferson",      "McIntosh",        "Pushmataha",     
"Atoka",           "Creek",           "Johnston",       "Murray",          "Roger Mills",    
"Beaver",          "Custer",          "Kay",            "Muskogee",        "Rogers",         
"Beckham",         "Delaware",        "Kingfisher",     "Noble",           "Seminole",       
"Blaine",          "Dewey",           "Kiowa",          "Nowata",          "Sequoyah",       
"Bryan",           "Ellis",           "Latimer",        "Okfuskee",        "Stephens",       
"Caddo",           "Garfield",        "Le Flore",       "Oklahoma",        "Texas",          
"Canadian",        "Garvin",          "Lincoln",        "Okmulgee",        "Tillman",        
"Carter",          "Grady",           "Logan",          "Osage",           "Tulsa",          
"Cherokee",        "Grant",           "Love",           "Ottawa",          "Wagoner",        
"Choctaw",         "Greer",           "Major",          "Pawnee",          "Washington",     
"Cimarron",        "Harmon",          "Marshall",       "Payne",           "Washita",        
"Cleveland",       "Harper",          "Mayes",          "Pittsburg",       "Woods",          
"Coal",            "Haskell",         "McClain",        "Pontotoc",        "Woodward",       
"Comanche",        "Hughes"].each {|c| County.find_or_create_by!(state: s, name: c)}                  

s = State.find_by_name('Oregon')
["Baker",           "Deschutes",       "Jefferson",       "Malheur",         "Umatilla",       
"Benton",          "Douglas",         "Josephine",       "Marion",          "Union",          
"Clackamas",       "Gilliam",         "Klamath",         "Morrow",          "Wallowa",        
"Clatsop",         "Grant",           "Lake",            "Multnomah",       "Wasco",          
"Columbia",        "Harney",          "Lane",            "Polk",            "Washington",     
"Coos",            "Hood River",      "Lincoln",         "Sherman",         "Wheeler",        
"Crook",           "Jackson",         "Linn",            "Tillamook",       "Yamhill",        
"Curry"].each {|c| County.find_or_create_by!(state: s, name: c)}           

s = State.find_by_name('Pennsylvania')
["Adams",           "Chester",         "Fulton",          "McKean",          "Snyder",         
"Allegheny",       "Clarion",         "Greene",          "Mercer",          "Somerset",       
"Armstrong",       "Clearfield",      "Huntingdon",      "Mifflin",         "Sullivan",       
"Beaver",          "Clinton",         "Indiana",         "Monroe",          "Susquehanna",    
"Bedford",         "Columbia",        "Jefferson",       "Montgomery",      "Tioga",          
"Berks",           "Crawford",        "Juniata",         "Montour",         "Union",          
"Blair",           "Cumberland",      "Lackawanna",      "Northampton",     "Venango",        
"Bradford",        "Dauphin",         "Lancaster",       "Northumberland",  "Warren",         
"Bucks",           "Delaware",        "Lawrence",        "Perry",           "Washington",     
"Butler",          "Elk",             "Lebanon",         "Philadelphia",    "Wayne",          
"Cambria",         "Erie",            "Lehigh",          "Pike",            "Westmoreland",   
"Cameron",         "Fayette",         "Luzerne",         "Potter",          "Wyoming",        
"Carbon",          "Forest",          "Lycoming",        "Schuylkill",      "York",           
"Centre",          "Franklin"].each {|c| County.find_or_create_by!(state: s, name: c)}                

s = State.find_by_name('Rhode Island')
["Bristol",         "Kent",            "Newport",         "Providence",      
	"Washington"].each {|c| County.find_or_create_by!(state: s, name: c)}             

s = State.find_by_name('South Carolina')
["Abbeville",       "Cherokee",        "Fairfield",       "Lancaster",       "Orangeburg",     
"Aiken",           "Chester",         "Florence",        "Laurens",         "Pickens",        
"Allendale",       "Chesterfield",    "Georgetown",      "Lee",             "Richland",       
"Anderson",        "Clarendon",       "Greenville",      "Lexington",       "Saluda",         
"Bamberg",         "Colleton",        "Greenwood",       "Marion",          "Spartanburg",    
"Barnwell",        "Darlington",      "Hampton",         "Marlboro",        "Sumter",         
"Beaufort",        "Dillon",          "Horry",           "McCormick",       "Union",          
"Berkeley",        "Dorchester",      "Jasper",          "Newberry",        "Williamsburg",   
"Calhoun",         "Edgefield",       "Kershaw",         "Oconee",          "York",           
"Charleston"].each {|c| County.find_or_create_by!(state: s, name: c)}              

s = State.find_by_name('South Dakota')
["Aurora",          "Corson",          "Hamlin",          "Lincoln",         "Roberts",        
"Beadle",          "Custer",          "Hand",            "Lyman",           "Sanborn",        
"Bennett",         "Davison",         "Hanson",          "Marshall",        "Shannon",        
"Bon Homme",       "Day",             "Harding",         "McCook",          "Spink",          
"Brookings",       "Deuel",           "Hughes",          "McPherson",       "Stanley",        
"Brown",           "Dewey",           "Hutchinson",      "Meade",           "Sully",          
"Brule",           "Douglas",         "Hyde",            "Mellette",        "Todd",           
"Buffalo",         "Edmunds",         "Jackson",         "Miner",           "Tripp",          
"Butte",           "Fall River",      "Jerauld",         "Minnehaha",       "Turner",         
"Campbell",        "Faulk",           "Jones",           "Moody",           "Union",          
"Charles Mix",     "Grant",           "Kingsbury",       "Pennington",      "Walworth",       
"Clark",           "Gregory",         "Lake",            "Perkins",         "Yankton",        
"Clay",            "Haakon",          "Lawrence",        "Potter",          "Ziebach",        
"Codington"].each {|c| County.find_or_create_by!(state: s, name: c)}       

s = State.find_by_name('Tennessee')
["Anderson",        "DeKalb",          "Henderson",       "Maury",           "Sequatchie",     
"Bedford",         "Decatur",         "Henry",           "McMinn",          "Sevier",         
"Benton",          "Dickson",         "Hickman",         "McNairy",         "Shelby",         
"Bledsoe",         "Dyer",            "Houston",         "Meigs",           "Smith",          
"Blount",          "Fayette",         "Humphreys",       "Monroe",          "Stewart",        
"Bradley",         "Fentress",        "Jackson",         "Montgomery",      "Sullivan",       
"Campbell",        "Franklin",        "Jefferson",       "Moore",           "Sumner",         
"Cannon",          "Gibson",          "Johnson",         "Morgan",          "Tipton",         
"Carroll",         "Giles",           "Knox",            "Obion",           "Trousdale",      
"Carter",          "Grainger",        "Lake",            "Overton",         "Unicoi",         
"Cheatham",        "Greene",          "Lauderdale",      "Perry",           "Union",          
"Chester",         "Grundy",          "Lawrence",        "Pickett",         "Van Buren",      
"Claiborne",       "Hamblen",         "Lewis",           "Polk",            "Warren",         
"Clay",            "Hamilton",        "Lincoln",         "Putnam",          "Washington",     
"Cocke",           "Hancock",         "Loudon",          "Rhea",            "Wayne",          
"Coffee",          "Hardeman",        "Macon",           "Roane",           "Weakley",        
"Crockett",        "Hardin",          "Madison",         "Robertson",       "White",          
"Cumberland",      "Hawkins",         "Marion",          "Rutherford",      "Williamson",     
"Davidson",        "Haywood",         "Marshall",        "Scott",           "Wilson"].each {|c| County.find_or_create_by!(state: s, name: c)}        

s = State.find_by_name('Texas')
["Anderson",        "Crane",           "Hartley",         "Madison",         "San Patricio",   
"Andrews",         "Crockett",        "Haskell",         "Marion",          "San Saba",       
"Angelina",        "Crosby",          "Hays",            "Martin",          "Schleicher",     
"Aransas",         "Culberson",       "Hemphill",        "Mason",           "Scurry",         
"Archer",          "Dallam",          "Henderson",       "Matagorda",       "Shackelford",    
"Armstrong",       "Dallas",          "Hidalgo",         "Maverick",        "Shelby",         
"Atascosa",        "Dawson",          "Hill",            "McCulloch",       "Sherman",        
"Austin",          "DeWitt",          "Hockley",         "McLennan",        "Smith",          
"Bailey",          "Deaf Smith",      "Hood",            "McMullen",        "Somervell",      
"Bandera",         "Delta",           "Hopkins",         "Medina",          "Starr",          
"Bastrop",         "Denton",          "Houston",         "Menard",          "Stephens",       
"Baylor",          "Dickens",         "Howard",          "Midland",         "Sterling",       
"Bee",             "Dimmit",          "Hudspeth",        "Milam",           "Stonewall",      
"Bell",            "Donley",          "Hunt",            "Mills",           "Sutton",         
"Bexar",           "Duval",           "Hutchinson",      "Mitchell",        "Swisher",        
"Blanco",          "Eastland",        "Irion",           "Montague",        "Tarrant",        
"Borden",          "Ector",           "Jack",            "Montgomery",      "Taylor",         
"Bosque",          "Edwards",         "Jackson",         "Moore",           "Terrell",        
"Bowie",           "El Paso",         "Jasper",          "Morris",          "Terry",          
"Brazoria",        "Ellis",           "Jeff Davis",      "Motley",          "Throckmorton",   
"Brazos",          "Erath",           "Jefferson",       "Nacogdoches",     "Titus",          
"Brewster",        "Falls",           "Jim Hogg",        "Navarro",         "Tom Green",      
"Briscoe",         "Fannin",          "Jim Wells",       "Newton",          "Travis",         
"Brooks",          "Fayette",         "Johnson",         "Nolan",           "Trinity",        
"Brown",           "Fisher",          "Jones",           "Nueces",          "Tyler",          
"Burleson",        "Floyd",           "Karnes",          "Ochiltree",       "Upshur",         
"Burnet",          "Foard",           "Kaufman",         "Oldham",          "Upton",          
"Caldwell",        "Fort Bend",       "Kendall",         "Orange",          "Uvalde",         
"Calhoun",         "Franklin",        "Kenedy",          "Palo Pinto",      "Val Verde",      
"Callahan",        "Freestone",       "Kent",            "Panola",          "Van Zandt",      
"Cameron",         "Frio",            "Kerr",            "Parker",          "Victoria",       
"Camp",            "Gaines",          "Kimble",          "Parmer",          "Walker",         
"Carson",          "Galveston",       "King",            "Pecos",           "Waller",         
"Cass",            "Garza",           "Kinney",          "Polk",            "Ward",           
"Castro",          "Gillespie",       "Kleberg",         "Potter",          "Washington",     
"Chambers",        "Glasscock",       "Knox",            "Presidio",        "Webb",           
"Cherokee",        "Goliad",          "La Salle",        "Rains",           "Wharton",        
"Childress",       "Gonzales",        "Lamar",           "Randall",         "Wheeler",        
"Clay",            "Gray",            "Lamb",            "Reagan",          "Wichita",        
"Cochran",         "Grayson",         "Lampasas",        "Real",            "Wilbarger",      
"Coke",            "Gregg",           "Lavaca",          "Red River",       "Willacy",        
"Coleman",         "Grimes",          "Lee",             "Reeves",          "Williamson",     
"Collin",          "Guadalupe",       "Leon",            "Refugio",         "Wilson",         
"Collingsworth",   "Hale",            "Liberty",         "Roberts",         "Winkler",        
"Colorado",        "Hall",            "Limestone",       "Robertson",       "Wise",           
"Comal",           "Hamilton",        "Lipscomb",        "Rockwall",        "Wood",           
"Comanche",        "Hansford",        "Live Oak",        "Runnels",         "Yoakum",         
"Concho",          "Hardeman",        "Llano",           "Rusk",            "Young",          
"Cooke",           "Hardin",          "Loving",          "Sabine",          "Zapata",         
"Coryell",         "Harris",          "Lubbock",         "San Augustine",   "Zavala",         
"Cottle",          "Harrison",        "Lynn",            "San Jacinto"].each {|c| County.find_or_create_by!(state: s, name: c)}     

s = State.find_by_name('Utah')
["Beaver",          "Duchesne",        "Kane",            "San Juan",        "Utah",           
"Box Elder",       "Emery",           "Millard",         "Sanpete",         "Wasatch",        
"Cache",           "Garfield",        "Morgan",          "Sevier",          "Washington",     
"Carbon",          "Grand",           "Piute",           "Summit",          "Wayne",          
"Daggett",         "Iron",            "Rich",            "Tooele",          "Weber",          
"Davis",           "Juab",            "Salt Lake",       "Uintah"].each {|c| County.find_or_create_by!(state: s, name: c)}        

s = State.find_by_name('Vermont')
["Addison",         "Chittenden",      "Grand Isle",      "Orleans",         "Windham",        
"Bennington",      "Essex",           "Lamoille",        "Rutland",         "Windsor",        
"Caledonia",       "Franklin",        "Orange",          "Washington"].each {|c| County.find_or_create_by!(state: s, name: c)}      

s = State.find_by_name('Virginia')
["Accomack",        "Charlotte",       "Greene",          "Mecklenburg",     "Roanoke",        
"Albemarle",       "Chesterfield",    "Greensville",     "Middlesex",       "Rockbridge",     
"Alleghany",       "Clarke",          "Halifax",         "Montgomery",      "Rockingham",     
"Amelia",          "Craig",           "Hanover",         "Nelson",          "Russell",        
"Amherst",         "Culpeper",        "Henrico",         "New Kent",        "Scott",          
"Appomattox",      "Cumberland",      "Henry",           "Northampton",     "Shenandoah",     
"Arlington",       "Dickenson",       "Highland",        "Northumberland",  "Smyth",          
"Augusta",         "Dinwiddie",       "Isle of Wight",   "Nottoway",        "Southampton",    
"Bath",            "Essex",           "James City",      "Orange",          "Spotsylvania",   
"Bedford",         "Fairfax",         "King and Queen",  "Page",            "Stafford",       
"Bland",           "Fauquier",        "King George",     "Patrick",         "Surry",          
"Botetourt",       "Floyd",           "King William",    "Pittsylvania",    "Sussex",         
"Brunswick",       "Fluvanna",        "Lancaster",       "Powhatan",        "Tazewell",       
"Buchanan",        "Franklin",        "Lee",             "Prince Edward",   "Warren",         
"Buckingham",      "Frederick",       "Loudoun",         "Prince George",   "Washington",     
"Campbell",        "Giles",           "Louisa",          "Prince William",  "Westmoreland",   
"Caroline",        "Gloucester",      "Lunenburg",       "Pulaski",         "Wise",           
"Carroll",         "Goochland",       "Madison",         "Rappahannock",    "Wythe",          
"Charles City",    "Grayson",         "Mathews",         "Richmond",        "York"].each {|c| County.find_or_create_by!(state: s, name: c)}           

s = State.find_by_name('Washington')
["Adams",           "Douglas",         "King",            "Pacific",         "Stevens",        
"Asotin",          "Ferry",           "Kitsap",          "Pend Oreille",    "Thurston",       
"Benton",          "Franklin",        "Kittitas",        "Pierce",          "Wahkiakum",      
"Chelan",          "Garfield",        "Klickitat",       "San Juan",        "Walla Walla",    
"Clallam",         "Grant",           "Lewis",           "Skagit",          "Whatcom",        
"Clark",           "Grays Harbor",    "Lincoln",         "Skamania",        "Whitman",        
"Columbia",        "Island",          "Mason",           "Snohomish",       "Yakima",
"Cowlitz",         "Jefferson",       "Okanogan",        "Spokane"].each {|c| County.find_or_create_by!(state: s, name: c)}         

s = State.find_by_name('West Virginia')
["Barbour",         "Grant",           "Logan",           "Nicholas",        "Summers",        
"Berkeley",        "Greenbrier",      "Marion",          "Ohio",            "Taylor",         
"Boone",           "Hampshire",       "Marshall",        "Pendleton",       "Tucker",         
"Braxton",         "Hancock",         "Mason",           "Pleasants",       "Tyler",          
"Brooke",          "Hardy",           "McDowell",        "Pocahontas",      "Upshur",         
"Cabell",          "Harrison",        "Mercer",          "Preston",         "Wayne",          
"Calhoun",         "Jackson",         "Mineral",         "Putnam",          "Webster",        
"Clay",            "Jefferson",       "Mingo",           "Raleigh",         "Wetzel",         
"Doddridge",       "Kanawha",         "Monongalia",      "Randolph",        "Wirt",           
"Fayette",         "Lewis",           "Monroe",          "Ritchie",         "Wood",           
"Gilmer",          "Lincoln",         "Morgan",          "Roane",           "Wyoming"].each {|c| County.find_or_create_by!(state: s, name: c)}        

s = State.find_by_name('Wisconsin')
["Adams",           "Douglas",         "Kewaunee",        "Outagamie",       "Sheboygan",      
"Ashland",         "Dunn",            "La Crosse",       "Ozaukee",         "St. Croix",      
"Barron",          "Eau Claire",      "Lafayette",       "Pepin",           "Taylor",         
"Bayfield",        "Florence",        "Langlade",        "Pierce",          "Trempealeau",    
"Brown",           "Fond du Lac",     "Lincoln",         "Polk",            "Vernon",         
"Buffalo",         "Forest",          "Manitowoc",       "Portage",         "Vilas",          
"Burnett",         "Grant",           "Marathon",        "Price",           "Walworth",       
"Calumet",         "Green",           "Marinette",       "Racine",          "Washburn",       
"Chippewa",        "Green Lake",      "Marquette",       "Richland",        "Washington",     
"Clark",           "Iowa",            "Menominee",       "Rock",            "Waukesha",       
"Columbia",        "Iron",            "Milwaukee",       "Rusk",            "Waupaca",        
"Crawford",        "Jackson",         "Monroe",          "Sauk",            "Waushara",       
"Dane",            "Jefferson",       "Oconto",          "Sawyer",          "Winnebago",      
"Dodge",           "Juneau",          "Oneida",          "Shawano",         "Wood",           
"Door",            "Kenosha"].each {|c| County.find_or_create_by!(state: s, name: c)}         

s = State.find_by_name('Wyoming')
["Albany",          "Crook",           "Laramie",         "Platte",          "Teton",          
"Big Horn",        "Fremont",         "Lincoln",         "Sheridan",        "Uinta",          
"Campbell",        "Goshen",          "Natrona",         "Sublette",        "Washakie",       
"Carbon",          "Hot Springs",     "Niobrara",        "Sweetwater",      "Weston",         
"Converse",        "Johnson",         "Park"].each {|c| County.find_or_create_by!(state: s, name: c)}            
        
puts "LOADING ZIPCODE DATABASE"
Zipcode.import_from_csv(Rails.root.join('db', 'zip_code_database.csv'))

if Rails.env.development?
  puts "==============================="
  puts "Now you can load test clients, jobs, etc. with this command:"
  puts ""
  puts "  rake testdata:reload  "
  puts ""
  puts "==============================="
end

