# shortly

A URL shortening tool that uses sinatra and mongo

* First time using Sinatra
* First time using Mongo
* First time using Thin server

It's going to be fun!

## To Install

* Clone the project from git
    - ```git clone https://github.com/DavidBlinn/shortly```
* In the base directory of the cloned project
    - ```bundle```
* If you get an error describing a ruby version mismatch and you're using rvm, you can
    - ```rvm use 2.2.0```

* To set up the mongoDB database
    - Install [mongoDB](http://docs.mongodb.org/manual/installation/) if you haven't already
    - Make sure you have mongod running. The development and test environments assumes a default mongo port of 27017
    - The production environment is set to the heroku instance I set up.

* To start the application
    - ```thin start```
    - You can then visit localhost:3000 to see the application
    - localhost:3000/top_hundred will show a table with the top 100 most accessed links
* To run the test suite
    - ```rspec```

* To view the app on Heroku visit [https://shortly-app.herokuapp.com/](https://shortly-app.herokuapp.com/)

Please contact me if you have any problems getting the application to run. It uses the latest version of Ruby, Mongo, and a number of Ruby gems. If something about your environment causes the pickup of old versions of things, I could see it being quite easy to end up in dependency hell.

## Design notes

### Challenges

### Future Work
* TODO
- better test coverage (particularly on javascript) jasmine/karma
- self references (links to shortly links should just return the original link and shouldn't be counted)
- update logo
- display more metrics
- d3.js display (bubbles)
- rake task to clean up bad data (the what's up doc link, etc.)
- security audit
- custom (short) domain name