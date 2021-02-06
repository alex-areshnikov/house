class LogsPage
  TEXT_CLASS_MAPPING = {
    "error" => "text-danger",
    "warn" => "text-warning",
    "info" => "text-info"
  }

  def initialize(page_number)
    @page_number = page_number
  end

  def logs
    ::HouseLog.order(created_at: :desc).page(page_number)
  end

  def text_class(log)
    TEXT_CLASS_MAPPING.fetch(log.level, "")
  end

  private

  attr_reader :page_number
end
