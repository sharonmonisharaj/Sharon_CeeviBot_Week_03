BasicDetail.destroy_all

#BasicDetail.reset_autoincrement

BasicDetail.create!([{
  title: "Name",
  description: "Sharon Monisha Rajkumar"
},
{
  title: "Date of Birth",
  description: "August 17, 1991"
},
{
  title: "Marital Status",
  description: "Married"
},
{
  title: "Husband's Name",
  description: "Jacob Thomas Davidson"
},
{
  title: "Husband's Occupation",
  description: "Student pusuing his second Master's degree at Carnegie Mellon University"
},
{
  title: "Father's Name",
  description: "Rajkumar Fredrick"
},
{
  title: "Mother's Name",
  description: "Nirmala Rajkumar"
},
{
  title: "Place of Birth",
  description: "Madurai"
},
{
  title: "Age",
  description: "25"
},
{
  title: "Work Experience",
  description: "2 years and 7 months"
}])

p "Created #{BasicDetail.count} details"

# -----------------------------------------------------------------

Skill.destroy_all

Skill.create!([{
  title: "Design",
  description: "Freehand sketching and storyboarding, Adobe Photoshop, Illustrator and Indesign, Balsamiq, Autodesk Alias Automotive, Autodesk Maya and Keyshot"
},
{
  title: "Programming",
  description: "Basic knowledge of C, Java, HTML, CSS, Javascript, jQuery, Ruby and Sinatra"
},
{
  title: "Prototyping Skills",
  description: "Prototyping with paper, wood, aluminium, mild steel, medium density fiber, polyurethance foam, hard polystyrene and thermocol"
},
{
  title: "Soft Skills",
  description: "Ability to lead design teams, conduct events, learn fast, be meticulous, organized and reliable"
},
{
  title: "Language Skills",
  description: "English, Tamil, Malayalam and Hindi"
}])

p "Created #{Skill.count} skills"

# -----------------------------------------------------------------

Project.destroy_all

Project.create!([{
  title: "Power Paper Prototyping",
  description: "Paper-Prototyping has the power to capture crucial feedback using rapid iterations of the paper-prototype from target users regarding an application's usefulness and usability before diving into the time-consuming and expensive implementation process. Here are samples of a paper prototype created for a task management application conceptualized for the course 'Programming Usable Interfaces' at Carnegie Mellon University.",
  url: "https://www.behance.net/gallery/43064215/Power-Paper-Prototyping"
},
{
  title: "Geospatial Data Manager App",
  description: "A mobile app that enables an organization to centrally store, organize and easily access all its geospatial data collected during various projects. This enables efficient reuse of previously collected data in new projects and eliminates the possibility of the same data getting unnecessarily recollected.",
  url: "https://www.behance.net/gallery/31915229/Geospatial-Data-Manager-App"
},
{
  title: "ConnectU Mobile App",
  description: "A mobile app offered as a service by airlines for the parents of children traveling alone by flight. It aims to offer the parents real-time visibility regarding the travel status and overall wellbeing of their child from the moment they bid goodbye at the origin airport till they are handed over to the appointed guardian at the destination airport.",
  url: "https://www.behance.net/gallery/11542717/Connectu-Unaccompanied-minor-travel-app"
},
{
  title: "SafeNav Mobile App",
  description: "A mobile app that could be offered as a service by airports. It generates the shortest route that the user can follow on a detailed indoor map of the airport to find lost belongings using indoor navigation and Bluetooth technologies.",
  url: "https://www.behance.net/gallery/11463227/SafeNav-Location-based-tracking-app"
},
{
  title: "Next-Gen Business Jet Concept Illustration",
  description: "A series of hand-drawn illustrations that depict futuristic Internet of Things use-cases onboard a business jet.",
  url: "https://www.behance.net/gallery/33557409/Next-Gen-Business-Jet-Concept-Illustration"
},
{
  title: "System Design - Saving maternal lives at birth",
  description: "A medical project undertaken jointly with biomedical engineering students from Johns Hopkins University, Baltimore, USA. The aim of the project was to come up with design interventions that would issues in the maternal healthcare system and bring down the maternal mortality rate in rurarl India.",
  url: "https://www.behance.net/gallery/11463445/Systems-design-Saving-maternal-lives-at-birth"
},
{
  title: "Branding for a South Indian Feature Film",
  description: "A freelance project undertaken for a South India feature film that involved designing the film logo, title in Tamil and in Engligh, posters and souvenirs.",
  url: "https://www.behance.net/gallery/21746297/September-5-Tamil-Movie-Branding"
},
{
  title: "3D Modeling",
  description: "Seismic Field Vehicles modeled and rendered using Autodesk Maya. The UV texture map wrapped around the model has been created using Adobe Photoshop.",
  url: "https://www.behance.net/gallery/32297207/Autodesk-Maya-Modeling"
},
{
  title: "Leg Elevator for Ankle Fracture Rehabilitation",
  description: "A portable, light-weight and stable leg elevator designed for individuals recovering from an ankle fracture who are required to keep the affected foot elevated above the level of the heart in order to prevent swelling.",
  url: "https://www.behance.net/gallery/9926557/Leg-elevator-for-ankle-fracture-rehabilitation"
},
{
  title: "Integrated Library Book-Drop",
  description: "An integrated library book-drop system which enables patrons to instantly return borrowed books without having to wait in long queues just to complete this simple transaction. Its modular structure enables it to function as a chair, a book drop and an information kiosk.",
  url: "https://www.behance.net/gallery/11463617/Integrated-library-book-drop"
},
{
  title: "Sketch Projects",
  description: "A series of hand-drawn illustrations of everyday objects.",
  url: "https://www.behance.net/gallery/9926525/Sketch-projects"
},
{
  title: "Photography",
  description: "Photographs of man's best friend captured on a pleasant summer's evening in Ahmedabad, India",
  url: "https://www.behance.net/gallery/11463349/Photographing-life"
}])

p "Created #{Project.count} projects"

# -----------------------------------------------------------------

WorkDetail.destroy_all

WorkDetail.create!([{
  job_title: "Product Design Intern",
  company: "Hidesign Luxury Leather",
  started_on: Time.new(2011, 5),
  completed_on: Time.new(2011, 6),
  job_description: "As part of a campaign by Hidesign called 'Art of Reuse' , the task was to design a dustbin and a stool for customers, to be used in all the Hidesign showrooms. The materials to be used for this purpose were to be scrap leather produced as a by-product in the bag-making unit and recycled brass and wood.",
  location: "Pondicherry, India", 
  internship: "true"
},
{
  job_title: "Product Design Intern",
  company: "Design Tech Product Design Firm",
  started_on: Time.new(2012, 4),
  completed_on: Time.new(2012, 7),
  job_description: "Actively involved in the process of product styling from the sketching stage, through 3D modeling and digital rendering to process documentation.",
  location: "Ammerbuch, Germany",
  internship: "true"
},
{
  job_title: "Interaction Design Intern",
  company: "Honeywell",
  started_on: Time.new(2013, 2),
  completed_on: Time.new(2013, 8),
  job_description: "Final year project in the field of user interface and service design, in the context of connectivity applications to enhance air passenger experience.",
  location: "Bangalore, India",
  internship: "true"
},
{
  job_title: "User Experience Designer",
  company: "Trimble Navigation",
  started_on: Time.new(2013, 11),
  completed_on: Time.new(2016, 6),
  job_description: "Actively involved in all stages of the mobile application design process starting from interaction with the client, writing use-cases, designing workflows, wireframes, high-fidelity mockups and icons, workflow user-testing and user-experience testing.",
  location: "Chennai, India",
  internship: "false"
}])

p "Created #{WorkDetail.count} work details"

# -----------------------------------------------------------------

EducationDetail.destroy_all

EducationDetail.create!([{
  program: "Class 10 Board Examination",
  institute: "Kendriya Vidyalaya",
  completed_on: Time.new(2007, 4),
  score: "95%",
  location: "Pondicherry, India",
  college: "false"
},
{
  program: "Class 12 Board Examination",
  institute: "St. Patrick Matriculation Higher Secondary School",
  completed_on: Time.new(2009, 4),
  score: "93.4%",
  location: "Pondicherry, India",
  college: "false"
},
{
  program: "Professional Educational Diploma in Product Design",
  institute: "National Institute of Design",
  completed_on: Time.new(2013, 12),
  score: "GPA 3.86",
  location: "Ahmedabad, India",
  college: "true"
},
{
  program: "Master's in Human-Computer Interaction",
  institute: "Carnegie Mellon University",
  completed_on: Time.new(2016, 8),
  score: "GPA 3.80",
  location: "Pittsburgh, USA",
  college: "true"
}])

p "Created #{EducationDetail.count} education details"

# -----------------------------------------------------------------

Interest.destroy_all

Interest.create!([{
  title: "Travel",
  description: "Sharon and her husband Jacob enjoy making weekend trips to different parts of the country whenever they get the chance. They particularly enjoy driving there by themselved. Even better would be riding there on Jacob's Royal Enfield motorcyle!"
},
{
  title: "Art",
  description: "Sharon loves to sketch buildings, people and places teeming with activity. She also finds great comfort in painting sceneries on canvas with acrylic. She started drawing when she was 3 years old when her mother introduced her to the beautiful world of art. She motivated her to create her very first piece of art which was a cute drawing of a beach, neatly outlined with a black felt tip pen and colored in with crayons! There was no turning back."
},
{
  title: "Baking",
  description: "Sharon finds great pleasure in baking sweet treats for family and friends and occassionally, for herself too!"
},
{
  title: "Programming Chat Bots",
  description: "Sharon's latest craze is building chat bots! And it all started with me, CeeviBot! I'm her very first creation! Keep an eye out for the awesome bots she's going to bring to life very soon!"
}])

p "Created #{Interest.count} interests"

# -----------------------------------------------------------------

Award.destroy_all

Award.create!([{
  title: "Best paper under 'Customer Insight' category at the Trimble Technology Conference 2015",
  description: "Sharon's paper on 'Trimble in the fantasy world of Augmented Reality' was voted as the best under the 'Customer Insight' category at the Biannual Trimble Technology Conference. To qualify for this honor, the paper had to demonstrate a unique customer insight and/or clearly put the customer in the center of the development process.",
  awarded_on: Time.new(2015, 10)
},
{
  title: "Recipient of TATA Ford Foundation Scholarship",
  description: "Sharon was one of three students who were hand-picked from a class of 90 students to receive this prestigious scholarship award for academic excellence.",
  awarded_on: Time.new(2010, 2)
},
{
  title: "Recipient of Deutscher Akademischer Austasch Dienst (DAAD) Scholarship",
  description: "This cholarship awarded to Sharon through Pforzheim University of Applied Sciences, Pforzheim, Germany, on being selected as a meritorious student who qualified to attend the 6 month Student Exchange Programme at the German University.",
  awarded_on: Time.new(2015, 10)
}])

p "Created #{Award.count} awards"

# -----------------------------------------------------------------

