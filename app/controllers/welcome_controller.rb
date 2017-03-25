class WelcomeController < ApplicationController
  def index
    @invalid_model = nil
    @message_search = MessageSearch.new
  end
end
