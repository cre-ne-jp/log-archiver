class WelcomeController < ApplicationController
  def index
    @channels = Channel.all
    @today = Time.now.to_date
    @yesterday = @today.prev_day
  end
end
