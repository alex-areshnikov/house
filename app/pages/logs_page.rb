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

  def log_row(log)
    content_tag(:div, class: "row border-bottom highlight-background") do
      content_tag(:div, class: "col-6 col-lg-3") do
        [log_timestamp(log), decorated_log_level(log), screenshot_icon(log)].compact.join.html_safe
      end +

      content_tag(:div, class: "col-6 col-lg-2") do
        log.source
      end +

      content_tag(:div, class: "col-12 col-lg-7") do
        log.description
      end
    end
  end

  private

  attr_reader :page_number

  def log_timestamp(log)
    "#{log.created_at}"
  end

  def decorated_log_level(log)
    content_tag(:span, " [#{log.level.humanize}]", class: text_class(log.level))
  end

  def screenshot_icon(log)
    return unless log.screenshot.present?

    content_tag(:a, data: { toggle: "modal", target: "#screenshot-modal-#{log.id}" }) do
      content_tag(:i, "", class: "clickable ml-1 fas fa-camera")
    end +

    content_tag(:div, id: "screenshot-modal-#{log.id}", class: "modal fade", tabindex: "-1", role: "dialog",
                aria: { labelledby: "modal-log-#{log.id}", hidden: "true" }) do
      content_tag(:div, class: "modal-dialog modal-dialog-centered modal-xl", role: "document") do
        content_tag(:div, class: "modal-content") do
          content_tag(:img, "", src: log.screenshot_url)
        end
      end
    end
  end
end
