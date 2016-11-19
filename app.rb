# Requiring gems

require "sinatra"
require 'active_support/all'
require 'active_support/core_ext'
require 'json'
require 'sinatra/activerecord'
require 'haml'
require 'builder'
require 'twilio-ruby'
require 'rake'
require 'giphy'
require 'httparty'

# -------------------------------------------------------------------------------------------

# Loading environment variables using Dotenv

configure :development do
  require 'dotenv'
  Dotenv.load
end

# -------------------------------------------------------------------------------------------

# Requiring models

require_relative './models/basic_detail'
require_relative './models/education_detail'
require_relative './models/interest'
require_relative './models/project'
require_relative './models/skill'
require_relative './models/work_detail'
require_relative './models/award'

# -------------------------------------------------------------------------------------------

# Enabling sessions for this project

enable :sessions
client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]


# -------------------------------------------------------------------------------------------
#     ROUTES, END-POINTS AND ACTIONS
# -------------------------------------------------------------------------------------------


get "/" do
  #401
  "My Great Application".to_s
  ENV['TWILIO_NUMBER']
end


# -------------------------------------------------------------------------------------------
#     T0 TEST IF MESSAGES ARE GETTING SENT
# -------------------------------------------------------------------------------------------


get "/send_sms" do
  
  client.account.messages.create(
  :from => ENV["TWILIO_NUMBER"],
  :to => "+14127268237",
  :body => "Hi! I'm Sharon's CeeviBot! Ask me anything about her CV and be ready to be amazed!"
  )
  "Sent message"
  
end


# -------------------------------------------------------------------------------------------
#     ALL INTERACTIONS WITH CEEVIBOT ARE HANDLED HERE
# -------------------------------------------------------------------------------------------


get '/incoming_sms' do
  
  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
# -------------------------------------------------------------------------------------------
  
  if body == "hi!" or body == "hi" or body.include? "hello" or body.include? "hey" or body == "hola" or body.include? "howdy" or body.include? "aloha"
    message = get_about_message
    
# -------------------------------------------------------------------------------------------
  
# If the user wants to play a guessing game!
    
  elsif body == "play"
    session["last_context"] = "play"
    session["guess_it"] = rand(1...5)
    message = "Let's play! Guess what number I'm thinking of. It's between 1 and 5"
  elsif session["last_context"] == "play"
    
    # if it's not a number 
    if not body.to_i.to_s == body
      message = "Cheater cheater that's not a number. Try again"
    elsif body.to_i == session["guess_it"]
      message = "Bingo! It was #{session["guess_it"]}"
      session["last_context"] = "correct_answer"
      session["guess_it"] = -1
    else
      message = "Wrong! Try again"
    end
    
# -------------------------------------------------------------------------------------------
  
# Hard-coded SMS responses
  
  # To display CeeviBot's name  
  elsif body.include? "are you"
    INTRODUCTION = [ "My name is CeeviBot.", "CeeviBot at your service!", "I'm CeeviBot!" ]
    message = INTRODUCTION.sample
  
  # To display CeeviBot's creator's name  
  elsif body.include? "creator" or body.include? "maker" or body.include? "made you"
    message = "I am a bot created by Sharon. I'm her favorite one!"
  
  # To display what Ceevibot does  
  elsif body.include? "purpose" or body.include? "goal" or body.include? "you do" or body.include? "your job"
    message = "It is my life's goal to tell wonderful people like you about Sharon's exciting Curriculum Vitae!" 
    message += "Ask me anything you would like to know!"
  
  # To display when Ceevibot was created
  elsif body.include? "when"
    message = "I was created on November 6, 2016."
  
  # To display where Ceevibot was created
  elsif body.include? "where"    
    message = "I was created in Pittsburgh when Sharon was pursuing her Master's degree in Human-Computer Interaction "
    message += "at Carnegie Mellon University."
  
  # To display why Ceevibot was created 
  elsif body.include? "why"    
    message = "Sharon created me to help you learn more about her and what she has to offer to your company."
    
  # To display the current time
  elsif body.include? "time"  
    message = Time.now.strftime( "It's %I:%M, %A, %B %e, %Y")
    
  # To display Sharon's contact details
  elsif body.include? "contact" 
    message = "Here are Sharon's contact details: \n\n"
    message += "Phone number: #{CONTACT["cell"]}\n\n"
    message += "Personal Email ID: #{CONTACT["personal_email"]}\n\n"
    message += "CMU Email ID: #{CONTACT["cmu_email"]}\n\n"
    message += "Facebook page: #{CONTACT["facebook"]}\n\n"
    message += "LinkedIn page: #{CONTACT["linkedin"]}\n\n"
    message += "Online portfolio: #{CONTACT["portfolio"]}"
    
  # To display Sharon's email IDs
  elsif body.include? "email" or body.include? "message"
    message = "Personal Email ID: #{CONTACT["personal_email"]}\n"
    message += "CMU Email ID: #{CONTACT["cmu_email"]}\n"
    
  # To display Sharon's phone number
  elsif body.include? "phone"
    message = "Phone number: #{CONTACT["cell"]}"
    
  # To give information about Sharon's address
  elsif body.include? "address"
    message = "Call Sharon at #{CONTACT["cell"]} to get her address."
    
  # To display Sharon's social media links
  elsif body.include? "social" or body.include? "media"
    message = "Facebook page: #{CONTACT["facebook"]}\n"
    message += "LinkedIn page: #{CONTACT["linkedin"]}\n"
    message += "Online portfolio: #{CONTACT["portfolio"]}"
    
  # To display the link to Sharon's Facebook page 
  elsif body.include? "facebook"
    message = "Facebook page: #{CONTACT["facebook"]}"
  
  # To display the link to Sharon's LinkeIn page  
  elsif body.include? "linkedin"
    message = "LinkedIn page: #{CONTACT["linkedin"]}"
  
  # To display the link to Sharon's online portfolio  
  elsif body.include? "portfolio"
    message = "Online portfolio: #{CONTACT["portfolio"]}"
    
  # To display Sharon's favorite color
  elsif body.include? "color"
    message = "Sharon's favorite color is red!"
    
  # To display Sharon's favorite fruit
  elsif body.include? "fruit"
    message = "Apples are Sharon's favorite fruit!"
    
  # To display Sharon's favorite city
  elsif body.include? "city"
    message = "Sharon would love to live in Mountain View, CA one day."
    
  # To display Sharon's ambition
  elsif body.include? "ambition" or body.include? "dream"
    message = "Sharon's ambition is to make the world a better place through design. "
    message += "She strongly believes that this can be done by bridging the gap between "
    message += "what users really want and what makers think they want or want them to want."
    
  # To display Sharon's favorite food
  elsif body.include? "food" or body.include? "meal" or body.include? "eat"
    message = "Not many people know this, but Sharon is a big foodie! Breakfast is her absolute favorite meal of the day!"
    message += " She loves spicy Indian and Chinese food and fresh American salads."
    message += " Most importantly, she does love the occassional sweet treat!"
    
  # To display Sharon's favorite holiday
  elsif body.include? "holiday" or body.include? "festival"
    message = "Christmas is Sharon's favorite holiday. Not only does it hold religious importance for her, "
    message += "but also she loves the spirit of joy and togetherness that the holiday brings!"
    
  # To display Sharon's favorite means of relaxation
  elsif body.include? "relax" or body.include? "workout" or body.include? "exercise" or body.include? "gym"
    message = "Sharon loves working out in the gym! When she feels stressed out, she goes to the gym!"
    message += "I don't workout much so I just don't understand how she finds that place relaxing!"
    
  # To display Sharon's favorite movie
  elsif body.include? "movie" or body.include? "film"
    message = "Sharon's favorite film is 'The Wizard of Oz'!"
    
  # To display what Sharon dislikes
  elsif body.include? "dislike" or body.include? "hate"
    message = "Sharon is not a fan of procrastination. She cannot stand injustice and always stands up for the affected party when
    she encounters it. Oh and this is an important one - She hates skipping meals!"
    
  # To display information about Sharon's eligibility to work in the USA
  elsif body.include? "work" and body.include? "permit" or body.include? "eligible" or body.include? "citizen" or body.include? "visa"
    message = "Sharon is a citizen of India. She is in the US as a student with an F1 visa. She is eligible to work under this 
    visa status for three years after completing her graduate program using Optional Practical Training (OPT)."
    
  # To display information about the countries Sharon has visited
  elsif body.include? "countries" or body.include? "country" or body.include? "visit" or body.include? "travel"
    message = "Sharon loves to travel! She has so far however only been to five countries - India, USA, UK, Germany and Mauritius. 
    She plans to visit all the countries in the world within the next ten years! Isn't she ambitious!"
    
  # To display where Sharon is from and where she currently lives
  elsif body.include? "from" or body.include? "city" or body.include? "current" or body.include? "live" or body.include? "reside" or body.include? "origin"
    message = "Sharon is from Chennai, India. She currently lives in Pittsburgh, PA, USA. You can reach her on her cellphone at +14127268237."
          
  # If abusive words are used
  elsif body.include? "dumb" or body.include? "stupid" or body.include? "idiot" or body.include? "fuc" or body.include? "fool" or body.include? "gger" or body.include? "egro" or body.include? "astard" or body.include? "oundrel" or body.include? "ascal"
    POLITE = ["Please be polite.", "I'm sorry, that's not the kind of language I am comfortable with.", "I have feelings too you know.", "Uh oh, Sharon wouldn't be happy if she heard that.", "I'm going to pretend I didn't hear that.", "I'm sure I misheard you. There's no way you could have said that to me!"]
    message = POLITE.sample
    
  # If the user thanks CeeviBot
  elsif body.include? "thank"
    WELCOME = ["You're welcome!", "Sure!", "Any time!", "It's my pleasure!", "The pleasure is all mine!"]
    message = WELCOME.sample
 
  # If compliments are given
  elsif body.include? "awesome" or body.include? "great" or body.include? "nice" or body.include? "sweet" or body.include? "amazing" or body.include? "wonderful" or body.include? "spectacular"
    THANK = ["😀 I know I'm awesome. But hey! So are you!"]#, "😊 That's nice of you to say!", "😌 You're too kind."]
    message = "Thank you! " + THANK.sample
    
  # If 'cool' is said
  elsif body.include? "cool"
    message = "😎 Yup, she's cool alright!"
    
  # If the user laughs
  elsif body.include? "lol" or body.include? "funny" or body.include? "😂" or body.include? "😀" or body.include? "😊" or body.include? "🙃" or body.include? "😜" or body.include? "😄"
    message = "🤖"
 
  # Saying goodbye
  elsif body.include? "bye" or body.include? "aurevoir" or body.include? "ciao" or body.include? "farewell" or body.include? "seeyou"
    FAREWELL = ["🤓 Goodbye, dear friend!", "See you! 🙃 Hope we get to chat again soon!", "This was fun! 😀 We should totally do this again! Bye for now!", "Till we meet again, goodbye good luck and godspeed to you my friend! 😊"]
    message = FAREWELL.sample
  
  # If the user needs help  
  elsif body.include? "help"
    message = get_help_message
    
    
# -------------------------------------------------------------------------------------------
# Retrieving information from the linked database to be used as SMS responses.
# -------------------------------------------------------------------------------------------


# Retrieving information from the basic_details table

  # To display Sharon's full name
  elsif body.include? "full name" or body.include? "surname"
    message = "My creator's full name is "
    message += BasicDetail.all[0].description + "."
  
  # To display Sharon's date and place of birth  
  elsif body.include? "birth" or body.include? "born"
    message = "Sharon was born on "
    message += BasicDetail.all[1].description
    message += " in " + BasicDetail.all[7].description + "."
  
  # To display Sharon's marital status  
  elsif body.include? "married" or body.include? "marital"
    message = "Sharon is "
    message += BasicDetail.all[2].description + "."
  
  # To display Sharon's husband's name  
  elsif body.include? "husband" or body.include? "spouse" or body.include? "partner" or body.include? "jacob"
    message = "Sharon is married to a wonderful man named "
    message += BasicDetail.all[3].description + ". "
    message += "He is a #{BasicDetail.all[4].description}."
  
  # To display Sharon's father's name  
  elsif body.include? "father" or body.include? "dad" 
    message = "Sharon's father's name is "
    message += BasicDetail.all[5].description + "."
  
  # To display Sharon's mother's name  
  elsif body.include? "mother" or body.include? "mom" 
    message = "Sharon's mother's name is "
    message += BasicDetail.all[6].description + "."
  
  # To display Sharon's age  
  elsif body.include? "old" or body.include? "age" 
    message = "Sharon is "
    message += BasicDetail.all[8].description + " years of age."
  
  # To display Sharon's work experience  
  elsif body.include? "workexperience" or body.include? "year"
    message = "Before coming to Carnegie Mellon University to pursue Master's in Human-Computer Interaction, "
    message += "Sharon worked as an Interaction Designer for "
    message += BasicDetail.all[9].description
    message += " in Trimble Navigation, Chennai."
    message += "Ask me about her internships!"

# -------------------------------------------------------------------------------------------

# Retrieving information from the work_details table

  # To display the Sharon's has worked at
  elsif body.include? "companies" or body.include? "company" or body.include? "work"
    message = "Sharon has worked at: "
    WorkDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.company}" 
    end
  
  # To display Sharon's job descriptions  
  elsif body.include? "description"
    message = "Here are the roles that Sharon has played as a design professional:"
    WorkDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.job_title.upcase}\n#{record.company}, #{record.location}\n\n#{record.job_description}" 
    end

  # To display Sharon's internship deatils
  elsif body.include? "internship" or body.include? "apprentice"
    work_details = WorkDetail.all.where( internship: true )
    message = "Sharon has interned at the following #{ work_details.count } companies:\n\n"
    work_details.each_with_index do |detail,index|
      message += "#{index+1}. #{detail.company} \n #{detail.location}\n\n"
    end

  # To display information about Sharon's job at Hidesign
  elsif body.include? "hidesign"
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%hidesign%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
  
  # To display information about Sharon's foreign work experience  
  elsif body == "designtech" or body.include? "german" or body.include? "abroad" or body.include? "foreign"
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%design tech%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
 
  # To display information about Sharon's job at Honeywell  
  elsif body.include? "honeywell"    
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%honeywell%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
  
  # To display information about Sharon's job at Trimble  
  elsif body.include? "trimble"    
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%trimble%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
    
# -------------------------------------------------------------------------------------------

# Retrieving information from the education_details table

  # To display information about Sharon's current graduate program
  elsif body.include? "study" or body.include? "studies" or body.include? "graduat" or body.include? "convocat" 
    message = ""
    education_detail_array = EducationDetail.all.where( "institute LIKE ?", "%carnegie mellon university%" )
    education_detail_array.each do |record|
    message += "Sharon is currently pursuing "
    message += "#{record.program} at #{record.institute}\n#{record.location}.\n"
    message += "She graduates in #{record.completed_on.strftime("%B %Y")}.\n"
    message += "Her current score: #{record.score}.\n"
  end
  
  # To display information about Sharon's educational qualifications
  elsif body.include? "education"  
    message = "Sharon has the following educational qualifications: "
    EducationDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.program}\n#{record.institute}\n#{record.location}\n"
      message += "SCORE: #{record.score}\n" 
    end
  
  # To display information about Sharon's score and GPAs  
  elsif body.include? "score" or body.include? "gpa" or body.include? "grade" or body.include? "perform"
    message = ""
    EducationDetail.all.each_with_index do |record,index|
      message += "#{index+1}. #{record.institute}\n"
      message += "SCORE: #{record.score}\n\n"
    end
  
  # To display information about Sharon's school education  
  elsif body.include? "school"
    message = "Sharon's class 10 and 12 board examination details:\n\n"
    education_detail_array = EducationDetail.all.where( college: false )
    education_detail_array.each_with_index do |record,index|
    message += "#{index+1}. #{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end

  # To display information about Sharon's college education
  elsif body.include? "college"
    message = "Sharon's college education details:\n\n"
    education_detail_array = EducationDetail.all.where( college: true )
    education_detail_array.each_with_index do |record,index|
    message += "#{index+1}. #{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end
  
  # To display information about Sharon's undergraduate degree
  elsif body.include? "undergrad" or body.include? "ug" or body.include? "bachelors"
    message = ""
    education_detail_array = EducationDetail.all.where( "institute LIKE ?", "%national institute of design%" )
    education_detail_array.each do |record|
    message += "Sharon's Bachelor's Study Details:\n\n"
    message += "#{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end
  
  # To display information about Sharon's master's degree 
  elsif body.include? "master\'s" or body.include? "masters"
    message = ""
    education_detail_array = EducationDetail.all.where( "institute LIKE ?", "%carnegie mellon university%" )
    education_detail_array.each do |record|
    message += "Sharon's Master's Study Details:\n\n"
    message += "#{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end
  
# -------------------------------------------------------------------------------------------

# Retrieving information from the interests table

    elsif body.include? "interest" or body.include? "enjoy" or body.include? "hobbies" or body.include? "hobby" or body.include? "like"
      message = "Here are Sharon's interests!"
      Interest.all.each_with_index do |record,index|
        message += "\n\n#{record.title.upcase}\n#{record.description}" 
      end
      
# -------------------------------------------------------------------------------------------

# Retrieving information from the skills table

  elsif body.include? "skill" or body.include? "expert" 
    message = "Here are Sharon's skills!"
    Skill.all.each_with_index do |record,index|
      message += "\n\n#{record.title.upcase}\n#{record.description}" 
    end
    
# -------------------------------------------------------------------------------------------

# Retrieving information from the awards table

  elsif body.include? "award" or body.include? "honor" or body.include? "accomplish"
    message = "Here are Sharon's awards!"
    Award.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.title}\n#{record.description}\nAWARDED ON: #{record.awarded_on.strftime("%B %Y")}" 
    end
    
# -------------------------------------------------------------------------------------------

# Retrieving information from the projects table

  # To diplay the list of Sharon's projects with links to view them on her online portfolio
  elsif body.include? "project" or body.include? "task"
    message = "Here are Sharon's projects!\n\n"
    Project.all.each_with_index do |record,index|
      message += "#{index+1}. #{record.title}\n"
      message += "Portfolio Link: #{record.url}\n\n" 
    end

  # To display a random project with description and the link to view it on her online portfolio
  elsif body.include? "random"
    message = "Here's an interesting project that Sharon has worked on!"
    random = Project.all.sample(1).first
      message += "\n\n#{random.title}\n\nDESCRIPTION: #{random.description}\n\n"
      message += "Portfolio Link: #{random.url}\n\n"

# -------------------------------------------------------------------------------------------

# Connecting to Behance API using the gem httparty.
# https://www.behance.net is an online portfolio website.
# I have had my online portfolio on Behance since 2013.
  
  # To display Sharon's work phisolophy
  elsif body.include? "passion" or body.include? "philosophy" or body.include? "belief" or body.include? "summary" or body.include? "about"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    message = "Here's what Sharon is about!\n\n"
    about = json["user"]
    philosophy = about["sections"] 
    message += "'" + philosophy["About"] + "'"
    message += "\n- Sharon"
    
  
  # To diplay the statistics of Sharon's online portfolio  
  elsif body.include? "stat" or body.include? "metric" or body.include? "analytic"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/stats?client_id=dxM9p6oMEBAeYx7c7Sj0UNQtzCXcYRqR")
    message = "Here are the statistics related to Sharon's online portfolio:\n\n"
    stats = json["stats"]["all_time"]
    message += "Project Views: #{stats["project_views"]}\n"
    message += "Project Appreciations: #{stats["project_appreciations"]}\n"
    message += "Project Comments: #{stats["project_comments"]}\n"
    message += "Profile Views: #{stats["profile_views"]}\n"
    
  
  # To display the views and appreciations received by a random project on Sharon's online portfolio  
  elsif body.include? "view" or body.include? "appreciation"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/projects?client_id=dxM9p6oMEBAeYx7c7Sj0UNQtzCXcYRqR")
    random = json["projects"].sample(1).first
    message = "Here are statistics for one of Sharon's projects!"
    name = random["name"]
    url = random["url"]
    stats = random["stats"]
    views = stats["views"]
    appreciations = stats["appreciations"]	
    message += "#{name}\n"
    message += "Number of views: #{views}\n\n"
    message += "Number of appreciations: #{appreciations}\n\n"
    message += "Online Portfolio Link : #{url}\n\n"
 
 
  # To display the link to Sharon's resume on her online portfolio
  elsif body.include? "resume" or body.include? "cv"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/projects?client_id=dxM9p6oMEBAeYx7c7Sj0UNQtzCXcYRqR")
    projects = json["projects"]
    resume = projects[1]
    url = resume["url"]
    message = "Here's the link to Sharon's resume: #{url}"
  
# -------------------------------------------------------------------------------------------
  
  # If the message sent by the user matches none of the above  
  else 
    message = error_response
    session["last_context"] = "error"
  end
  
# -------------------------------------------------------------------------------------------


  twiml = Twilio::TwiML::Response.new do |r|
    r.Message message
  end
  twiml.text
end


# -------------------------------------------------------------------------------------------
#   ERRORS
# -------------------------------------------------------------------------------------------


error 401 do 
  "Not allowed!!!"
end


# -------------------------------------------------------------------------------------------
#   METHODS
# -------------------------------------------------------------------------------------------

private 

GREETINGS = ["Hi","Yo", "Hey","Howdy", "Hello", "Ahoy", 
  "‘Ello", "Aloha", "Hola", "Bonjour", "Ciao", "Konnichiwa"]

COMMANDS = "Sharon's likes, dislikes, beliefs, work experience, internships, education, skills, awards, age, marital status, parents and the what, where, when and why of my existence. 
We can also play a game if you said 'play'!"

HELP = ["You're stuck, eh? ", "I know I can be difficult at times. ", 
  "I'm sorry that I'm giving you a hard time. ", 
  "Don't worry, it's my fault, not yours if you're having trouble talking to me. ", 
  "Tired of dealing with me? I'll try my best to be on my best behavior! "]
  
CONTACT = {"cell" => "+1-412-726-8237",
    "address" => "Call her to find out!",
    "personal_email" => "sharonmonisharaj@gmail.com",
    "cmu_email" => "srajkuma@andrew.cmu.edu",
    "facebook" => "https://www.facebook.com/sharon.m.rajkumar",
    "linkedin" => "https://www.linkedin.com/in/sharonmonisharaj",
    "portfolio" => "https://www.behance.net/sharonmonisharaj"}

def get_commands
  error_prompt = ["You could ask about ", "Try asking about ", "You can ask me about ", 
    "I can tell you about ", "I'm awesome at answering questions about "].sample
  
  return error_prompt + COMMANDS
end

def get_greeting
  return GREETINGS.sample
end

def get_about_message
  get_greeting + "! I\'m Sharon's CeeviBot 🤖!\n" + get_commands
end

def get_help_message
  HELP.sample + get_commands
end

def error_response
  error_prompt = ["I'm sorry, I didn't catch that.\n", "Hmmm... I'm not sure what you mean.\n", 
    "Could you please rephrase that?\n"].sample
  error_prompt + " " + get_commands
end

# -------------------------------------------------------------------------------------------