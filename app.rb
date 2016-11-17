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

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end

# -------------------------------------------------------------------------------------------

# require any models 
# you add to the folder
# using the following syntax:
# require_relative './models/<model_name>'
require_relative './models/basic_detail'
require_relative './models/education_detail'
require_relative './models/interest'
require_relative './models/project'
require_relative './models/skill'
require_relative './models/work_detail'
require_relative './models/award'

# -------------------------------------------------------------------------------------------

# enable sessions for this project
enable :sessions

client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]


# -------------------------------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# -------------------------------------------------------------------------------------------


get "/" do
  #401
  "My Great Application".to_s
  ENV['TWILIO_NUMBER']
end


# -------------------------------------------------------------------------------------------
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
# -------------------------------------------------------------------------------------------


# get "/incoming_sms" do
#
#   session["counter"] ||= 0
#   sms_count = session["counter"]
#
#   sender = params[:From] || ""
#   body = params[:Body] || ""
#
#   if sms_count == 0
#     message = "Hello and thanks for the new message!"
#
#   else
#     message = "Hello and thanks for the #{sms_count + 1} message you've sent today!"
#   end
#
#   twilm = Twilio::TwiML::Response.new do |response|
#     #response.Message "Thanks for your message. From #{sender} saying #{body}"
#     response.Message message
#   end
#
#   session["counter"] += 1
#   twilm.text
#
# end


# -------------------------------------------------------------------------------------------
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
  
# If the user wants to play a game!
    
  elsif body == "quiz"
    session["last_context"] = "quiz"
    session["guess_it"] = rand(1...5)
    message = "Guess what number I'm thinking of. It's between 1 and 5"
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
    
  elsif body.include? "who"
    message = "Im a bot created by Sharon. I'm her favorite one!"
    
  elsif body.include? "purpose" or body.include "goal"
    message = "It is my life's goal to tell anyone who would listen about Sharon's exciting Curriculum Vitae! Ask me anything you would like to know!"
  
  elsif body.include? "when" or body.include? "time"    
    #message = Time.now.strftime( "It's %A %B %e, %Y")
    message = "I was created on November 6, 2016."
  
  elsif body.include? "where"    
    message = "I was created in Pittsburgh when Sharon was pursuing her Master's degree in Human-Computer Interaction at Carnegie Mellon University."
  
  elsif body.include? "why"    
    message = "Sharon created me to help you learn more about her and what she has to offer to your company."
    
  elsif body.include? "time"    
    message = Time.now.strftime( "It's %A %B %e, %Y")
    
# -------------------------------------------------------------------------------------------
# Retrieving information from the linked database to be used as SMS responses.
# -------------------------------------------------------------------------------------------

# Retrieving information from the work_details table

  elsif body.include? "companies" or body.include? "company"  
    message = "Sharon has worked at: "
    WorkDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.company}" 
    end
    
  elsif body.include? "description"
    message = "Here are Sharon's job descriptions:"
    WorkDetail.all.each_with_index do |record,index|
      message += "\n\n#{index+1}. #{record.company}\n\n#{record.job_description}" 
    end
  
  elsif body == "internship"
    work_detail_array = WorkDetail.all
    message = "Sharon has interned at the following three companies:\n\n1. #{work_detail_array[0].company}\n#{work_detail_array[0].location}\n\n2. #{work_detail_array[1].company}\n#{work_detail_array[1].location}\n\n 3. #{work_detail_array[2].company}\n#{work_detail_array[2].location}"
 
  elsif body == "Hidesign" or body.include? "first"
    message = "Sharon worked at #{work_detail_array[0].company} as #{work_detail_array[0].job_title} from #{work_detail_array[0].started_on} to #{work_detail_array[0].completed_on} in #{work_detail_array[0].location}."
 
  elsif body.include? "Design Tech" or body.include? "Germany" or body.include? "second"
    message = "Sharon worked at #{work_detail_array[1].company} as #{work_detail_array[1].job_title} from #{work_detail_array[1].started_on} to #{work_detail_array[1].completed_on} in #{work_detail_array[1].location}."
    
  elsif body.include? "Honeywell" or body == "third internship" or body.include? "third"
    message = "Sharon worked at #{work_detail_array[2].company} as #{work_detail_array[2].job_title} from #{work_detail_array[2].started_on} to #{work_detail_array[2].completed_on} in #{work_detail_array[2].location}."
    
  elsif body.include? "Trimble" or body == "full time" or body.include? "last"
    message = "Sharon worked at #{work_detail_array[3].company} as #{work_detail_array[3].job_title} from #{work_detail_array[3].started_on} to #{work_detail_array[3].completed_on} in #{work_detail_array[3].location}."


# -------------------------------------------------------------------------------------------

# Connecting to Behance API using the gem httparty.
# https://www.behance.net is an online portfolio website.
# I have had my online portfolio on Behance since 2013.
  
  elsif body.include? "basic" or body.include? "personal" or body.include? "bio"
    message = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    
  elsif body == "projects"
    message = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/projects?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    
  elsif body == "project"
    message = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/projects?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd").sample
    
  elsif body.include? "appreciation"
    message = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/appreciations?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
  
  elsif body.include? "experience"
    message = HTTParty.get("https://www.behance.net/v2/users/sharonmonisharaj/work_experience?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
  
  elsif body.include? "following"
    message = HTTParty.get("http://www.behance.net/v2/users/sharonmonisharaj/following?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    
  elsif body.include? "followers"
    message = HTTParty.get("http://www.behance.net/v2/users/sharonmonisharaj/followers?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    
  elsif body.include? "statistics" or body.include? "stats"
    message = HTTParty.get("https://api.behance.net/v2/users/sharonmonisharaj/stats?client_id=z7ceYH2Sfb0Qea7nIW5xuEMui44ESMLd")
    
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
# -------------------------------------------------------------------------------------------


get '/incoming_sms_giphy' do

  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  query = body.downcase.strip
  
  Giphy::Configuration.configure do |config|
    config.api_key = ENV["GIPHY_API_KEY"]
  end
  
  results = Giphy.search( query, {limit: 3})
  gif = nil
  unless results.empty? 
    
    gif = results.first.original_image.url
    text = "Powered by Giphy.com and Twilio MMS: twilio.com/mms"
    
  else 
 
    message = "Hmmm, that's odd. I couldn't find anything for '#{query}'. Try something else?"
  end 
  
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message do |m|
        m.Body message
        unless gif.nil?
            m.Media gif
        end
    end
  end
  twiml.text

end

# -------------------------------------------------------------------------------------------
#     ERRORS
# -------------------------------------------------------------------------------------------


error 401 do 
  "Not allowed!!!"
end


# -------------------------------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# -------------------------------------------------------------------------------------------

private 

GREETINGS = ["Hi","Yo", "Hey","Howdy", "Hello", "Ahoy", "‘Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa"]

COMMANDS = "who, what, where, when, why, age, marital status, parents, job, internship, education, interests, skills, awards or quiz."

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