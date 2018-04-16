require 'rails_helper'

RSpec.feature "Orders", js: true do

  given(:admin) { FactoryBot.create(:administrator) }

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

    context 'when user is an admin' do
      given(:user) { admin }
      given!(:order) { FactoryBot.create(:order) }

      scenario 'User see list of orders creates an order' do
        visit orders_path

        within('table tbody') do
          expect(page).to have_css('tr', count: 1)
        end

        click_on('Nueva Orden')

        select('Student Pucmm', from: 'order_student_id')
        select('Teacher Pucmm', from: 'order_teacher_id')
        select('Patient Pucmm', from: 'order_patient_id')
        fill_in('Balance',	with: 5550)

        click_button('Crear orden')
        expect(page).to have_text 'Teacher Pucmm'
        expect(page).to have_text 'Patient Pucmm'
        expect(page).to have_text 'Student Pucmm'

        expect(page.current_path).to eq order_path(Order.last)
        expect(Order.last.balance).to eq(5550)
      end

      scenario 'User receives an order' do
        visit orders_path
        click_on('Nueva Orden')

        select('Student Pucmm', from: 'order_student_id')
        select('Teacher Pucmm', from: 'order_teacher_id')
        select('Patient Pucmm', from: 'order_patient_id')
        fill_in('Balance',	with: 5550)

        click_button('Crear orden')
        visit orders_path

        find('tr', text: 'Patient Pucmm Teacher Pucmm Student Pucmm RD$5,550').click
        expect(page.current_path).to eq edit_order_path(Order.last)

        click_on('Recibir orden')
        expect(email_count).to eq(1)
        expect(last_email.body).to have_content('Patient Pucmm')
      end
    end

    context 'when user is an student and there are other orders' do
      given(:user) { student }
      given(:other_student){ FactoryBot.create(:student)}
      given!(:other_order) { FactoryBot.create(:order, student: other_student) }

      scenario 'User creates and order and cannot receive it' do
        visit orders_path

        expect(page).not_to have_selector('table tbody')

        click_on('Nueva Orden')

        select('Teacher Pucmm', from: 'order_teacher_id')
        select('Patient Pucmm', from: 'order_patient_id')
        fill_in('Balance',	with: 5550)

        click_button('Crear orden')
        expect(page).to have_text 'Teacher Pucmm'
        expect(page).to have_text 'Patient Pucmm'
        expect(page).to have_text 'Student Pucmm'

        expect(page.current_path).to eq order_path(Order.last)
        visit orders_path

        within('table tbody tr') do
          expect(page).not_to have_content(other_student.full_name)
          expect(page).to have_content('2 Patient Pucmm Teacher Pucmm Student Pucmm RD$5,550.00')
        end

        find('tr', text: 'Patient Pucmm Teacher Pucmm Student Pucmm RD$5,550').click
        expect(page.current_path).to eq edit_order_path(Order.last)

        expect(page).not_to have_content('Recibir orden')
      end
    end
  end
end
