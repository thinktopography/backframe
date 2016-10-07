# Backframe
Backframe introduces a collection of new core objects to help you write testable
APIs for your Rails and Ruby Applications.

<table>
  <tr>
    <td>Build Status</td>
    <td>
      <a href="https://circleci.com/gh/thinktopography/backframe">
        <img src="https://circleci.com/gh/thinktopography/backframe.png?style=shield&circle-token=510e9789fad82aaa0d6e18ee15f49724bea193f8" alt="Build Status" >
      </a>
    </td>
  </tr>
  <tr>
    <td>Code Quality</td>
    <td>
      <a href="https://codeclimate.com/github/thinktopography/backframe">
        <img src="https://codeclimate.com/github/thinktopography/backframe/badges/gpa.svg" alt="Code Quality">
      </a>
      <a href="https://codeclimate.com/github/thinktopography/backframe/coverage">
        <img src="https://codeclimate.com/github/thinktopography/backframe/badges/coverage.svg" alt="Test Coverage">
      </a>
    </td>
  </tr>
</table>
![](https://codeclimate.com/github/thinktopography/backframe/badges/coverage.svg)
## API Controllers
Backframe Controllers are just like regular controllers in Rails. Here's an
example of how you might use Backframe objects to fulfill requests:

```Ruby
class API::ContactsController < API::ApplicationController

  def index
    contacts = ContactQuery.perform(request.query_parameters)
    render Backframe::Response.render(contacts, params[:format])
  end

  def show
    contact = Contact.find(params[:id])
    render json: contact, status: 200
  end

  def create
    result = CreateContactService.perform(params)
    if result.success?
      render json: result.contact, status: 201
    else
      render json: { message: result.message, errors: result.errors }, status: 422
    end
  end

  def update
    result = UpdateContactService.perform(params)
    if result.success?
      render json: result.contact, status: 201
    else
      render json: { message: result.message, errors: result.errors }, status: 422
    end
  end

  def destroy
    result = DestroyContactService.perform(params)
    if result.success?
      render json: result.contact, status: 201
    else
      render json: { message: result.message, errors: result.errors }, status: 422
    end
  end

end
```

##Query Objects
Backframe adds query objects to your application which can be placed in the
`app/queries` directory. These objects extend from `Backframe::Query` and enable
you to encapsulate and test your sorting and filtering logic.

```Ruby
class ContactQuery < Backframe::Query

  def filter(records, filters)
    records = records.where('LOWER(first_name) like ?', '%'+filters[:first_name].downcase+'%') if filters.key?(:first_name)
    records = records.where('LOWER(last_name) like ?', '%'+filters[:last_name].downcase+'%') if filters.key?(:last_name)
    records = records.where('LOWER(email) like ?', '%'+filters[:email].downcase+'%') if filters.key?(:email)
    records
  end

  def sort(sorts)
    records = records.order(sorts)
    records
  end

end
```

##Service Objects
Backframe adds service objects to your application which can be placed in the
`app/services` directory. These objects extend from `Backframe::Service` and
enable you to abandon callbacks in favor of the service pattern.

```Ruby
class CreateContactService < Backframe::Service

  def initialize(params)
    @params = params
  end

  def perform
    create_contact
    log_activity
    send_email
  end

  def create_contact
    ...
  end

  def log_activity
    ...
  end

  def send_email
    ...
  end

end
```

##Serialization
Backframe lets you serialize your data in several formats - JSON, XML, XLS, CSV,
and TSV. The library provides response adapters for each target serialization
format

## Author & Credits
Backframe was originally written by [Greg Kops](https://github.com/mochini) and
[Scott Nelson](https://github.com/scttnlsn) based upon their work at
[Think Topography](http://thinktopography.com). Backframe has been used in
production to support a handful of client applications.
