require 'spec_helper'

describe UsersController do 
  describe "Get index" do
    it "gets the index view" do
      get "/" 
      response.status.should be 200
    end
  end
end

