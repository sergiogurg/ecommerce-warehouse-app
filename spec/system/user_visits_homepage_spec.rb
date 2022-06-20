require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'e visualiza galpões' do
    warehouses = []
    warehouses << Warehouse.new(id: 1, name: 'Galpão Fortaleza', code: 'FOR', city: 'Fortaleza', state: 'CE', address: 'Avenida Tal, 50', postal_code: '15000-000', area: 10_000, description: 'Um galpão')
    warehouses << Warehouse.new(id: 2, name: 'Galpão Jampa', code: 'JPA', city: 'João Pessoa', state: 'PB', address: 'Avenida Birimbelo, 819', postal_code: '55710-000', area: 7_500, description: 'Um outro galpão')
    allow(Warehouse).to receive(:all).and_return(warehouses)

    visit root_path

    expect(page).to have_content('E-Commerce App')
    expect(page).to have_content('Galpão Fortaleza')
    expect(page).to have_content('Galpão Jampa')
  end

  it 'mas não existem galpões' do
    fake_response = double("faraday_response", status: 200, body: "[]")
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit root_path

    expect(page).to have_content('Nenhum galpão encontrado')
  end

  it 'e vê detalhes de um galpão' do
    warehouses_json = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double('faraday response', status: 200, body: warehouses_json)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    warehouse_json = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    fake_response = double('faraday_response', status: 200, body: warehouse_json)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/3').and_return(fake_response)

    visit root_path
    click_on 'Galpão Fortaleza'

    expect(page).to have_content('Detalhes de FOR - Galpão Fortaleza')
    expect(page).to have_content('Fortaleza - CE')
    expect(page).to have_content('34500 m²')
    expect(page).to have_content('Av. Silas Munguba, 150 - CEP 60818-159')
    expect(page).to have_content('Galpão de FortalCity')
  end

  it 'mas não é possível carregar o galpão' do
    warehouses_json = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double('faraday_response', status: 200, body: warehouses_json)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    error_response = double('faraday_error_response', status: 500, body: "{}")
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/3').and_return(error_response)

    visit root_path
    click_on 'Galpão Fortaleza'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Não foi possível carregar o galpão')
  end
end