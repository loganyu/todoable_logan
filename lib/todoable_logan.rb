require 'rest-client'
require 'json'

class TodoableLogan
  BASE_URL = "http://todoable.teachable.tech/api"

  def initialize(user, password)
    @user = user
    @password = password
    authenticate()
  end

  # return array list hashes
  def get_lists
    response = rest("get", "lists")

    return response["lists"]
  end

  # param name (string)
  # return list hash
  def create_list(name)
    data = {
      list: {
        name: name
      }
    }
    rest("post", "lists", data)
  end

  # param list_id (string)
  # param name (string)
  # return list hash
  def update_list(list_id, name)
    data = {
      list: {
        name: name
      }
    }
    rest("patch", "lists/#{list_id}", data)
  end

  # param list_id (string)
  # return list hash
  def get_list(list_id)
    rest("get", "lists/#{list_id}")
  end

  # param list_id (string)
  # return boolean true
  def delete_list(list_id)
    rest("delete", "lists/#{list_id}")

    return true
  end

  # param name (string)
  # param list_id (string)
  # return list hash
  def create_todo_item(name, list_id)
    data = {
      item: {
        name: name
      }
    }
    rest("post", "lists/#{list_id}/items", data)
  end

  # param item_id (string)
  # param list_id (string)
  # return success message (string)
  def mark_todo_item_finished(item_id, list_id)
    rest("put", "lists/#{list_id}/items/#{item_id}/finish")
  end
  
  # param item_id (string)
  # param list_id (string)
  # return boolean true
  def delete_todo_item(item_id, list_id)
    rest("delete", "/lists/#{list_id}/items/#{item_id}")

    return true
  end

  private

  def rest(method, endpoint, data = {})
    if Time.now >= @expires_at
      authenticate()
    end

    begin
      response = RestClient::Request.execute(
        headers: {
          :authorization => "Token token=\"#{@token}\""
        },
        method: method,
        accept: :json,
        content_type: :json,
        payload: data.to_json,
        url: "#{BASE_URL}/#{endpoint}",
      )
    rescue => e
      return raise "Error making API request. Code: #{e.response.code}. Body: #{e.response.body}"
    end

    begin
      body = JSON.parse(response.body)
    rescue
      body = response.body
    end

    return body
  end

  def authenticate
    begin
      response = RestClient::Request.execute(
        method: :post,
        accept: :json,
        content_type: :json,
        url: "#{BASE_URL}/authenticate",
        user: @user,
        password: @password,
      )
    rescue => e
      return raise "Error authenticating. Code: #{e.response.code}. Body: #{e.response.body}"
    end
    parsed_response = JSON.parse(response)

    @token = parsed_response['token']
    @expires_at = Time.parse(parsed_response['expires_at'])
  end
end
