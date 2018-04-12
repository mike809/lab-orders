require 'rails_helper'

RSpec.feature "Orders", js: true do

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

  context 'As an authenticated user ' do
    before do
      sign_in user
    end

    scenario 'User creates and receives an order' do
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

    scenario 'User receives an order' do
      visit orders_path
      click_on('Nueva Orden')

      select('Student Pucmm', from: 'order_student_id')
      select('Teacher Pucmm', from: 'order_teacher_id')
      select('Patient Pucmm', from: 'order_patient_id')

      click_button('Crear orden')
      visit orders_path

      find('tr', text: 'Patient Pucmm Teacher Pucmm Student Pucmm').click
      expect(page.current_path).to eq edit_order_path(Order.last)

      click_on('Recibir orden')
      expect(email_count).to eq(1)
      expect(last_email.body).to have_content('Patient Pucmm')
    end
  end
end
