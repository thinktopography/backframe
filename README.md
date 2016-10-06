# Backframe
Backframe is a library of functionality to help build robust REST APIs in Ruby.

##Resource Actions
```Ruby
class ContactsController < ApplicationController

  def index
    contacts = ContactQuery.perform(request.query_parameters)
    render Backframe::Response::Base.index(contacts, params[:format])
  end

end
```

##Sorting & Filtering
Backframe supports a new type of object in your application - a query object.
These objects extend from `Backframe::Query` and enable you to encapsulate and
test your sorting and filtering logic.

```Ruby
class ContactQuery < Backframe::Query

  def self.filter(records, filters)
    records = records.where('LOWER(first_name) like ?', '%'+filters[:first_name].downcase+'%') if filters.key?(:first_name)
    records = records.where('LOWER(last_name) like ?', '%'+filters[:last_name].downcase+'%') if filters.key?(:last_name)
    records = records.where('LOWER(email) like ?', '%'+filters[:email].downcase+'%') if filters.key?(:email)
    records
  end

  def self.sort(sorts)
    records = records.order(sorts)
    records
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
