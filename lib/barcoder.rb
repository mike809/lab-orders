require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/html_outputter'

class Barcoder
  attr_reader :raw_data

  delegate :to_html, to: :html_outputter

  def initialize(raw_data)
    @raw_data = raw_data
  end

  private

  def html_outputter
    Barby::HtmlOutputter.new(barcode)
  end

  def barcode
    @barcode ||= Barby::EAN13.new(formatted_data)
  end

  def formatted_data
    raw_data.to_s.rjust(12, '0')
  end
end