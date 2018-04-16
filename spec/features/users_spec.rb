require 'rails_helper'

RSpec.feature 'Users', js: true do
  given(:user) { FactoryBot.create(:administrator, full_name: 'Tony Stark') }

  context 'as an authenticated user' do
    before do
      sign_in user
    end

    context 'as a non admin user' do
      context 'when the user is student' do
        given(:user) { FactoryBot.create(:student) }
        scenario 'User gets redirected to orders index' do
          visit admin_users_path
          expect(page).to have_current_path orders_path
        end
      end

      context 'when the user is student' do
        given(:user) { FactoryBot.create(:teacher) }
        scenario 'User gets redirected to orders index' do
          visit admin_users_path
          expect(page).to have_current_path orders_path
        end
      end
    end

    scenario 'User creates an user reorders the table and edits a user' do
      visit orders_path
      click_on('Usuarios')
      click_on('Crear usuario')
      expect(page).to have_text('Crear nuevo usuario')

      select('Estudiante', from: 'user_role')

      click_button('Crear usuario')
      expect(page).to have_text('Nombre completo no puede estar en blanco')

      fill_in('fullname',	with: 'Jose Reyes')
      click_button('Crear usuario')
      expect(page).to have_current_path admin_users_path

      within('#users_without_orders table tbody tr:nth-child(1)') do
        expect(page).to have_content('Tony Stark tony.stark tony.stark@estomatologia.pucmm.edu.do Personal de Administracion')
      end

      within('#users_without_orders table tbody tr:nth-child(2)') do
        expect(page).to have_content('Jose Reyes jose.reyes jose.reyes@estomatologia.pucmm.edu.do Estudiante')
        click_on(class: 'edit')
        select('Docente de Planta', from: 'user_role')
        click_button('Cancelar')
        expect(page).to have_content('Jose Reyes jose.reyes jose.reyes@estomatologia.pucmm.edu.do Estudiante')

        click_on(class: 'edit')
        select('Docente de Planta', from: 'user_role')
        click_button('Actualizar usuario')
        expect(page).to have_content('Jose Reyes jose.reyes jose.reyes@estomatologia.pucmm.edu.do Docente de Planta')
      end

      click_link('Tipo de usuario')

      within('#users_without_orders table tbody tr:nth-child(1)') do
        expect(page).to have_content('Jose Reyes jose.reyes jose.reyes@estomatologia.pucmm.edu.do Docente de Planta')
      end

      within('#users_without_orders table tbody tr:nth-child(2)') do
        expect(page).to have_content('Tony Stark tony.stark tony.stark@estomatologia.pucmm.edu.do Personal de Administracion')
      end
    end
  end
end
