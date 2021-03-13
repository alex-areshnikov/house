class LogsPage
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  TEXT_CLASS_MAPPING = {
    "error" => "text-danger",
    "warn" => "text-warning",
    "info" => "text-info"
  }

  def initialize(page_number = 1)
    @page_number = page_number
  end

  def logs
    ::HouseLog.order(created_at: :desc).page(page_number)
  end

  def each_row
    logs.each { yield log_row(_1).html_safe }
  end

  def text_class(level)
    TEXT_CLASS_MAPPING.fetch(level, "")
  end

  def log_row(copart_lot)
    content_tag(:div, class: "row border-bottom highlight-background") do
      content_tag(:div, class: "col-6 col-lg-3") do
        ("#{copart_lot.created_at}" +
        content_tag(:span, " [#{copart_lot.level.humanize}]", class: text_class(copart_lot.level))).html_safe
      end +

      content_tag(:div, class: "col-6 col-lg-2") do
        copart_lot.source
      end +

      content_tag(:div, class: "col-12 col-lg-7") do
        copart_lot.description
      end
    end
  end

  private

  attr_reader :page_number
end
