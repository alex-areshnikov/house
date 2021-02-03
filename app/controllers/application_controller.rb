class ApplicationController < ActionController::Base
  def enable_channel(channel_name)
    @channels ||= []
    @channels << channel_name
  end
end
