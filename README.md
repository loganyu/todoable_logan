# TodoableLogan
An Wrapper for the Todoable API http://todoable.teachable.tech/

This gem was created with help from the guide at https://guides.rubygems.org/make-your-own-gem/#your-first-gem

# Installing the gem
`gem install todoable_logan`

# Usage

````ruby
require 'todoable_logan'

# intialize a TodoableLogan API Client with a user and password
@todoable = TodoableLogan.new(user, password)

# returns an array of list hashes
@todoable.get_lists()

# returns the created list hash
@todoable.create_list(list_name)

# returns the updated list hash
@todoable.update_list(new_list_name)

# returns the list hash
@todoable.get_list(list_id)

# returns true
@todoable.delete_list(list_id)

# returns the created todo item hash
@todoable.create_todo_item(name, list_id)

# returns the todo item hash
@todoable.mark_todo_item_finished(item_id, list_id)

# returns true
@todoable.delete_todo_item(item_id, list_id)

````

# Tests
In the root directory, run `rspec` to run tests for the methods `#initialize` and `#get_lists`. Tests for the other methods are still needed.

# Notes
Each method makes a request to the Todoable API but first checks to see if they `expires_at` value provided during authentication has passed and reauthentiates if necessary. Other failures from the API would raise an exception and return the errors and code from the API.