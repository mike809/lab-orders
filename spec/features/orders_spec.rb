require 'rails_helper'

RSpec.feature "Orders", type: :feature do

  given(:user) { FactoryBot.create(:administrator) }

  given!(:teacher) do
    FactoryBot.create(:teacher, full_name: 'Teacher Pucmm')
  end

  given!(:patient) do
    FactoryBot.create(:patient, full_name: 'Patient Pucmm')
  end

  given!(:student) do
    FactoryBot.create(:student, full_name: 'Student Pucmm')
  end

  scenario 'User creates an order' do
    sign_in user

    visit orders_path
    click_on('Nueva Orden')

    select('Student Pucmm', from: 'order_student_id')
    select('Teacher Pucmm', from: 'order_teacher_id')
    select('Patient Pucmm', from: 'order_patient_id')

    click_button('Crear orden')
    expect(page).to have_text 'Teacher Pucmm'
    expect(page).to have_text 'Patient Pucmm'
    expect(page).to have_text 'Student Pucmm'
    expect(page.current_path).to eq order_path(Order.last)
  end
end
