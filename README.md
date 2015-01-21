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
* At my current client, one of the challenges we've been facing is how to keep controller actions short and clean and to avoid bloated models. One solution we've been discussing is the use of [service objects](https://netguru.co/blog/service-objects-in-rails-will-help). The UrlShortener class is an attempt at a service object that keeps business logic out of the controller (or in this case, the Sinatra::Application). After adding in logic to memoize repeated method calls and detect and handle the case of own urls being submitted, the url_shortener is probably due for a refactor, particularly if it were to expand anymore.
* Somewhat late in the application design, I noticed it was possible for the user to generate short urls for shortly's own short urls. This could lead to messy repeated redirects. Also, there was a missing feature that if you're given a shortly url that you don't really trust, there is no way to look up where that url will take you without actually visiting the site. My solution to both these problems was to perform a reverse lookup when a user attempts to shorten one of shortly's own short urls.
* It wasn't intentional, but it wound up that no URL-specific logic ended up in my ShortUrl model. It should actually be possible to use the class as a general purpose mapping between some string field and a randomly generated unique access token. For example, it might be a useful component in a system that obfuscates social security numbers in a medical application to meet HIPAA data storage requirements.
* Why use Sinatra over Rails?
    - It's lighter weight and this is a small, simple application
    - The application has only a few routes. It was also easy to add in the route matcher for redirecting by access token when receiving a short url
* Why use Mongo instead of a relational DB?
    - I usually abide by the rule of thumb that if your data is relational, you're better off starting with a relational DB. I thought through the application requirements before I started, and the data weren't relational, so it seemed like I had good freedom to choose from a variety of technologies.
    - Because I've never used Mongo before but I know it enjoys fairly wide use, I thought this would prove a good opportunity to learn.
    - Redis probably would have also been a fine chose, but I wanted to play with Mongo.
* You may have noticed that the ShortUrl model collects more statistics than are displayed in the top 100 page. I originally intended to put together a nice visualization that displayed these additional data but didn't have time.

### Challenges
* I couldn't get shoulda matchers to work on mongoid models. I tried a number fo different strategies, but kept getting errors when attempting to expect validate_presence_of on short_url fields.
* Some URL shortener services (ie bit.ly) offer a handy copy button that you can click to copy the short url to your copy buffer. At first, I wanted the same feature and even designed an interface for it. Unfortunately, most of the solutions seem to involve using flash (which seems to be what bit.ly does to solve this problem). Rather than get into that mess, I removed the copy button from the interface and instead highlight the resulting short url text after a user submits a url to shorten.
* Callback ordering when doing a find_or_create_by on the ShortUrl class was a bit tricky because I wanted to auto-generate an access_token when creating a ShortUrl, but I also wanted the access_token to be required.

### Future Work
- better test coverage (particularly on the front end) jasmine/karma
- improve logo
- display more metrics
- d3.js display for the top hundred (An [animated bubble chart](http://www.nytimes.com/interactive/2012/02/13/us/politics/2013-budget-proposal-graphic.html?_r=0) would be really cool)
- security audit
- custom (short) domain name