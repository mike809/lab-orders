require 'rails_helper'

RSpec.feature 'Users', js: true do
  given(:user) { FactoryBot.create(:administrator) }

  scenario 'User creates an user' do
    sign_in user

    visit orders_path
    click_on('Usuarios')
    click_on('Crear usuario')
    expect(page).to have_text('Crear nuevo usuario')

    select('Paciente', from: 'user_role')

    click_button('Crear usuario')
    expect(page).to have_text('Nombre completo no puede estar en blanco')

    fill_in('fullname',	with: 'Jose Reyes')
    click_button('Crear usuario')
    expect(page).to have_current_path admin_users_path
  end
end
