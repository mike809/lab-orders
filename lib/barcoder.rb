require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/html_outputter'

class Barcoder
  attr_reader :raw_data

  delegate :to_html, to: :html_outputter

  def initialize(raw_data)
    @raw_data = raw_data.to_s
  end

  private

  def html_outputter
    Barby::HtmlOutputter.new(barcode)
  end

  def barcode
    @barcode ||= Barby::Code39.new(raw_data)
  end
end