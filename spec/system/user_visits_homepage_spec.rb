require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e visualiza galpões' do
    warehouses_json = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: warehouses_json)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit root_path

    expect(page).to have_content('E-Commerce App')
    expect(page).to have_content('Galpão Fortaleza')
    expect(page).to have_content('Galpão Jampa')
    expect(page).to have_content('Galpão Maceió')
    expect(page).to have_content('Galpão Rio')
  end

  it 'mas não existem galpões' do
    fake_response = double("faraday_response", status: 200, body: "[]")
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit root_path

    expect(page).to have_content('Nenhum galpão encontrado')
  end
end