require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'
require 'barby/outputter/html_outputter'

class Barcoder
  attr_reader :raw_data

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def to_html
    Barby::HtmlOutputter.new(barcode).to_html
  end

  def to_png
    unless png_exists?
      blob = Barby::PngOutputter.new(barcode).to_png
      File.open(filepath, 'wb'){|f| f.write blob }
    end

    filename
  end

  private

  def png_exists?
    File.exists?(filepath)
  end

  def filepath
    "app/assets/images/#{filename}"
  end

  def filename
    "#{raw_data}-barcode.png"
  end

  def barcode
    @barcode ||= Barby::EAN13.new(formatted_data)
  end

  def formatted_data
    raw_data.to_s.rjust(12, '0')
  end
end