require 'todoable_logan'

describe TodoableLogan do
  let(:token) {"97f7fb33-c0ac-408a-a280-a5ff31f0d03c"}
  let(:expires_at) {(Time.now.utc + 20*60).to_s}
  let(:user){"yu.logan@gmail.com"}
  let(:password){"todoable"}
  let(:authenticate_response){
    {
      :token => token,
      :expires_at => expires_at,
    }.to_json
  }  
  before :each do
    allow(RestClient::Request).to receive(:execute).with(
      hash_including({:url => "#{TodoableLogan::BASE_URL}/authenticate"})
    ).and_return(authenticate_response)
  end

  context "#initialize" do
    it "authenticates the user" do
      
      expect(RestClient::Request).to receive(:execute).with(
        hash_including(user: user, password: password)
      )

      TodoableLogan.new(user, password)
    end

    context "the API returns an error" do
      it "returns an error with the error code" do
        allow_any_instance_of(RestClient::Unauthorized).to receive_message_chain(:response, :code).and_return(403)
        allow_any_instance_of(RestClient::Unauthorized).to receive_message_chain(:response, :body).and_return("body")
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::Unauthorized)

        expect{TodoableLogan.new(user, password)}.to raise_error(/403/)
      end
    end
  end

  context "#get_lists" do
    let(:lists){
      [
        {
          "name"=>"first list",
          "src"=>"http://todoable.teachable.tech/api/lists/8673e60d-4489-435c-8c66-f9e30cfc3113",
          "id"=>"8673e60d-4489-435c-8c66-f9e30cfc3113"
        }
      ]
    }
    let(:get_lists_response) {
      {
        lists: lists
      }.to_json
    }
    before :each do
      response = double("response")
      allow(response).to receive(:body).and_return(get_lists_response)
      allow(RestClient::Request).to receive(:execute).with(
        hash_including({:url => "#{TodoableLogan::BASE_URL}/lists"})
      ).and_return(response)
    end

    it "returns the lists" do
      todoable = TodoableLogan.new(user, password)
      expect(todoable.get_lists()).to eq(lists)
    end

    it "makes an API request for the todoable lists with a token" do
      expect(RestClient::Request).to receive(:execute).with(
        hash_including(:headers => {authorization: "Token token=\"#{token}\""})
      )

      todoable = TodoableLogan.new(user, password)
      todoable.get_lists()
    end

    it "does not make an authentiation request" do
      todoable = TodoableLogan.new(user, password)

      expect(RestClient::Request).to_not receive(:execute).with(
        hash_including({:url => "#{TodoableLogan::BASE_URL}/authenticate"})
      )
      
      todoable.get_lists()
    end

    context "when the token is expired" do
      let(:expires_at) {(Time.now.utc - 20*60).to_s}

      it "makes an authentication request to get another token" do
        todoable = TodoableLogan.new(user, password)
        
        expect(RestClient::Request).to receive(:execute).with(
          hash_including({:url => "#{TodoableLogan::BASE_URL}/authenticate"})
        )

        expect(todoable.get_lists()).to eq(lists)
      end
    end
  end

  context "#create_list" do
    skip "creates a new list item" do
    end
  end

  context "#update_list" do
    skip "updates the name of a list" do
    end

    skip "raises an error if the list is not found" do
    end
  end

  context "#get_list" do
    skip "returns the list item" do
    end

    skip "raises an error if the list is not found" do
    end
  end

  context "#delete_list" do
    skip "deletes the list item list item" do
    end
  end

  context "#create_todo_item" do
    skip "creates a todo item" do
    end

    skip "raises an error if the list is not found" do
    end
  end

  context "#mark_todo_item_finished" do
    skip "marks the todo item finished" do
    end

    skip "raises an error if the list or item is not found" do
    end
  end

  context "#delete_todo_item" do
    skip "deletes the todo item" do
    end

    skip "raises an error if the list or item is not found" do
    end
  end
end