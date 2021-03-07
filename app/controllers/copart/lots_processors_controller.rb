module Copart
  class LotsProcessorsController < ::Copart::ApplicationController
    def index
      @page = ::Copart::LotsProcessorsPage.new(params[:process])
      @page.process

      flash.notice = @page.flash_notice_message
    end
  end
end
