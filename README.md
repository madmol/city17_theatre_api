# Theatre Application
The Theatre Application is a web application that allows theatre managers to manage their plays and schedules.

## Features
* The application allows theatre managers to create and manage plays.
* Each play has a title and a date range during which it will be performed.
* The application ensures that plays do not overlap, and it displays an error message if a manager tries to schedule a play during a time when another play is already scheduled.
* The application provides a RESTful API that can be used by external applications to retrieve information about plays.
* The application provides a user interface that theatre managers can use to create and manage plays.

## Getting Started
To run the application, you will need to have Ruby and Rails installed on your system. Application is built on Rails 6.1 and runs on Ruby 2.7.1 nd is only suitable for PostgreSQL databases.

## Setup
```
bundle install
rails db:create
rails db:migrate
rails server
```
You should then be able to access the application by navigating to http://localhost:3000 in your web browser.

## Documentation

Apipie is used to generate documentation for the application's RESTful API. You can view the documentation by navigating to the `/apipie` endpoint in your browser after starting the server.

## Testing
* This application has tests written using RSpec.

## API Endpoints
The following endpoints are available in the API:

`GET /api/v1/plays`: Returns a list of all plays.

`POST /api/v1/plays`: Creates a new play.

`DELETE /api/v1/plays/:id`: Deletes the specified play.

## Contributing
If you would like to contribute to the Theatre Application, please feel free to fork the repository and submit a pull request. We welcome contributions of all kinds, including bug reports, feature requests, and code improvements.

License
The Theatre Application is released under the MIT License.
