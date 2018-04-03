class Order < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :patient, class_name: 'User'
end
