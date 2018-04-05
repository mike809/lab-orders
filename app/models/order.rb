class Order < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :patient, class_name: 'User'
  belongs_to :teacher, class_name: 'User'

  def barcode
    @barcode ||= begin
      Barcoder.new(id).to_html
    end
  end
end
