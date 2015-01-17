# shortly

A URL shortening tool that uses sinatra and mongo

* First time using Sinatra
* First time using Mongo
* First time using Thin server

It's going to be fun!

## To Install

* Clone the project from git
** ```git clone https://github.com/DavidBlinn/shortly```
* In the base directory of the cloned project
** ```bundle```
* If you get an error describing a ruby version mismatch and you're using rvm, you can
** ```rvm use 2.2.0```

* To start the application
** ```thin start```
** You can then visit localhost:3000 to see the application
* To run the test suite
** ```rspec```