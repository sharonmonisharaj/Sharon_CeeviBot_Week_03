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
  
  if body == "hi" or body == "hello" or body == "hey" or body == "hola" or body == "howdy" or body == "aloha"
    message = get_about_message
    
# -------------------------------------------------------------------------------------------
  
# If the user wants to play a guessing game!
    
  elsif body == "quiz"
    session["last_context"] = "quiz"
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
    
  elsif body.include? "name"
    INTRODUCTION = [ "My name is CeeviBot.", "CeeviBot at your service!", "I'm CeeviBot!" ]
    message = INTRODUCTION.sample
    
  elsif body.include? "who"
    message = "I am a bot created by Sharon. I'm her favorite one!"
    
  elsif body.include? "purpose" or body.include? "goal"
    message = "It is my life's goal to tell wonderful people like you about Sharon's exciting Curriculum Vitae!" 
    message += "Ask me anything you would like to know!"
  
  elsif body.include? "when" or body.include? "time"    
    #message = Time.now.strftime( "It's %A %B %e, %Y")
    message = "I was created on November 6, 2016."
  
  elsif body.include? "where"    
    message = "I was created in Pittsburgh when Sharon was pursuing her Master's degree in Human-Computer Interaction "
    message += "at Carnegie Mellon University."
  
  elsif body.include? "why"    
    message = "Sharon created me to help you learn more about her and what she has to offer to your company."
    
  elsif body.include? "time"    
    message = Time.now.strftime( "It's %A %B %e, %Y")
    
  elsif body.include? "color"
    message = "Sharon's favorite color is red!"
    
  elsif body.include? "fruit"
    message = "Apples are Sharon's favorite fruit!"
    
  elsif body.include? "city"
    message = "Sharon would love to live in Mountain View, CA one day."
    
  elsif body.include? "ambition"
    message = "Sharon's ambition is to make the world a better place through design."
    
  elsif body.include? "food" or body.include? "meal"
    message = "Not many people know this, but Sharon is a big foodie! Breakfast is her absolute favorite meal of the day!"
    message += "She loves spicy Indian and Chinese food and fresh American salads."
    message += "Most importantly, she does love the occassional sweet treat!"
    
  elsif body.include? "holiday" or body.include? "festival"
    message = "Christmas is Sharon's favorite holiday. Not only does it hold religious importance for her, "
    message += "but also she loves the spirit of joy and togetherness that the holiday brings!"
    
  elsif body.include? "relax" or body.include? "workout" or body.include? "exercise" or body.include? "gym"
    message = "Sharon loves working out in the gym! When she feels stressed out, she goes to the gym!"
    message += "I don't workout much so I just don't understand how she finds that place relaxing!"
    
  elsif body.include? "movie" or body.include? "film"
    message = "Sharon's favorite film is 'The Wizard of Oz'!"
    
    
# -------------------------------------------------------------------------------------------
# Retrieving information from the linked database to be used as SMS responses.
# -------------------------------------------------------------------------------------------


# Retrieving information from the basic_details table

  elsif body.include? "fullname" 
    message = "My creator's full name is "
    message += BasicDetail.all[0].description + "."
    
  elsif body.include? "birth" or body.include? "born"
    message = "Sharon was born on "
    message += BasicDetail.all[1].description
    message += " in " + BasicDetail.all[7].description + "."
    
  elsif body.include? "married" or body.include? "marital"
    message = "Sharon is "
    message += BasicDetail.all[2].description + "."
    
  elsif body.include? "husband" or body.include? "spouse" or body.include? "partner" or body.include? "jacob"
    message = "Sharon is married to a wonderful man named "
    message += BasicDetail.all[3].description + ". "
    message += "He is a #{BasicDetail.all[4].description}."
    
  elsif body.include? "father" or body.include? "dad" 
    message = "Sharon's father's name is "
    message += BasicDetail.all[5].description + "."
    
  elsif body.include? "mother" or body.include? "mom" 
    message = "Sharon's mother's name is "
    message += BasicDetail.all[6].description + "."
    
  elsif body.include? "old" or body.include? "age" 
    message = "Sharon is "
    message += BasicDetail.all[8].description + " years of age."
    
  elsif body.include? "workexperience" or body.include? "year"
    message = "Before coming to Carnegie Mellon University to pursue Master's in Human-Computer Interaction, "
    message += "Sharon worked as an Interaction Designer for "
    message += BasicDetail.all[9].description
    message += " in Trimble Navigation, Chennai."

# -------------------------------------------------------------------------------------------

# Retrieving information from the work_details table

  elsif body.include? "companies" or body.include? "company"  
    message = "Sharon has worked at: "
    WorkDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.company}" 
    end
    
  elsif body.include? "description"
    message = "Here are the roles that Sharon has played as a design professional:"
    WorkDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.company}\n\n#{record.job_description}" 
    end

  elsif body.include? "internship"
    work_details = WorkDetail.all.where( internship: true )
    message = "Sharon has interned at the following #{ work_details.count } companies:\n\n"
    work_details.each_with_index do |detail,index|
      message += "#{index+1}. #{detail.company} \n #{detail.location}\n\n"
    end

  elsif body.include? "hidesign"
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%hidesign%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
    
  elsif body == "designtech" or body.include? "germany" or body.include? "abroad"
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%design tech%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
    
  elsif body.include? "honeywell"    
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%honeywell%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
    
  elsif body.include? "trimble"    
    message = ""
    work_details = WorkDetail.all.where( "company LIKE ?", "%trimble%" )
    work_details.each_with_index do |record,index|
      message += "Sharon worked at #{record.company} in #{record.location} as #{record.job_title}.\n\n"
      message += "JOB DESCRIPTION:\n #{record.job_description}"
    end
    
# -------------------------------------------------------------------------------------------

# Retrieving information from the education_details table

  elsif body.include? "education" or body.include? "studies"  
    message = "Sharon has the following educational qualifications: "
    EducationDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.program}\n#{record.institute}\n#{record.location}\n#{record.score}\n" 
    end
    
  elsif body.include? "school"
    message = "Sharon's class 10 and 12 board examination details:\n\n"
    education_detail_array = EducationDetail.all.where( college: false )
    education_detail_array.each_with_index do |record,index|
    message += "#{index+1}. #{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end

  elsif body.include? "college"
    message = "Sharon's college education details:\n\n"
    education_detail_array = EducationDetail.all.where( college: true )
    education_detail_array.each_with_index do |record,index|
    message += "#{index+1}. #{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end
  
  elsif body.include? "undergrad" or body.include? "ug" or body.include? "bachelors"
    message = ""
    education_detail_array = EducationDetail.all.where( "institute LIKE ?", "%national institute of design%" )
    education_detail_array.each_with_index do |record,index|
    message += "Sharon's Bachelor's Study Details:\n\n"
    message += "#{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end
   
  elsif body.include? "master\'s" or body.include? "masters" or body.include? "graduate"
    message = ""
    education_detail_array = EducationDetail.all.where( "institute LIKE ?", "%carnegie mellon university%" )
    education_detail_array.each_with_index do |record,index|
    message += "Sharon's Master's Study Details:\n\n"
    message += "#{record.program}\n#{record.institute}\n#{record.location}\n"
    message += "COMPLETED ON: #{record.completed_on.strftime("%B %Y")}\n"
    message += "SCORE: #{record.score}\n"
  end
  
# -------------------------------------------------------------------------------------------

# Retrieving information from the interests table

    elsif body.include? "interest" or body.include? "enjoy" or body.include? "hobbies" or body.include? "hobby" 
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

  elsif body.include? "project" or body.include? "task"
    message = "Here are Sharon's projects!\n\n"
    Project.all.each_with_index do |record,index|
      message += "#{index+1}. #{record.title}\n"
      message += "Portfolio Link: #{record.url}\n\n" 
    end

  elsif body.include? "random"
    message = "Here's an interesting project that Sharon has worked on!"
    random = Project.all.sample(1).first
      message += "\n\n#{random.title}\n\nDESCRIPTION: #{random.description}\n\n"
      message += "Portfolio Link: #{random.url}\n\n"

# -------------------------------------------------------------------------------------------

# Connecting to Behance API using the gem httparty.
# https://www.behance.net is an online portfolio website.
# I have had my online portfolio on Behance since 2013.
  
  elsif body.include? "passion" or body.include? "philosophy" or body.include? "belief" or body.include? "summary" or body.include? "about"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    message = "Here's what Sharon is about!\n\n"
    about = json["user"]
    philosophy = about["sections"] 
    message += "'" + philosophy["About"] + "'"
    message += "\n- Sharon"
    
    
  elsif body.include? "stat" or body.include? "metric" or body.include? "analytic"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/stats?client_id=dxM9p6oMEBAeYx7c7Sj0UNQtzCXcYRqR")
    message = "Here are the statistics related to Sharon's online portfolio:\n\n"
    stats = json["stats"]["all_time"]
    message += "Project Views: #{stats["project_views"]}\n"
    message += "Project Appreciations: #{stats["project_appreciations"]}\n"
    message += "Project Comments: #{stats["project_comments"]}\n"
    message += "Profile Views: #{stats["profile_views"]}\n"
    
    
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
 
 
  elsif body.include? "resume" or body.include? "cv"
    json = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/projects?client_id=dxM9p6oMEBAeYx7c7Sj0UNQtzCXcYRqR")
    projects = json["projects"]
    resume = projects[1]
    url = resume["url"]
    message = "Here's the link to Sharon's resume: #{url}"
  
# -------------------------------------------------------------------------------------------
    
  else 
    message = error_response
    session["last_context"] = "error"
  end
  
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

GREETINGS = ["Hi","Yo", "Hey","Howdy", "Hello", "Ahoy", "‘Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa"]

COMMANDS = "who, what, where, when, why, age, marital status, parents, job, internship, education, interests, skills, awards or play."

def get_commands
  error_prompt = ["You could ask about ", "Try asking about ", "You can ask me about ", "I can tell you about ", "I'm awesome at answering questions about "].sample
  
  return error_prompt + COMMANDS
end

def get_greeting
  return GREETINGS.sample
end

def get_about_message
  get_greeting + "! I\'m Sharon's CeeviBot 🤖! " + get_commands
end

def get_help_message
  "You're stuck, eh? " + get_commands
end

def error_response
  error_prompt = ["I'm sorry, I didn't catch that.", "Hmmm... I don't know that word.", "Could you please rephrase that? "].sample
  error_prompt + " " + get_commands
end

# -------------------------------------------------------------------------------------------