require 'rails_helper'

describe Warehouse do
  context '.all' do
    it 'deve retornar todos os galpões' do
      warehouses_json = File.read(Rails.root.join('spec/support/json/warehouses.json'))
      fake_response = double('faraday_response', status: 200, body: warehouses_json)
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

      result = Warehouse.all

      expect(result.length).to eq(4)

      expect(result[0].id).to eq(3)
      expect(result[0].name).to eq('Galpão Fortaleza')
      expect(result[0].code).to eq('FOR')
      expect(result[0].city).to eq('Fortaleza')
      expect(result[0].state).to eq('CE')
      expect(result[0].address).to eq('Av. Silas Munguba, 150')
      expect(result[0].postal_code).to eq('60818-159')
      expect(result[0].area).to eq(34_500)
      expect(result[0].description).to eq('Galpão de FortalCity')

      expect(result[1].id).to eq(4)
      expect(result[1].name).to eq('Galpão Jampa')
      expect(result[1].code).to eq('JPA')
      expect(result[1].city).to eq('João Pessoa')
      expect(result[1].state).to eq('PB')
      expect(result[1].address).to eq('Avenida do aeroporto, 1501')
      expect(result[1].postal_code).to eq('78150-618')
      expect(result[1].area).to eq(21_500)
      expect(result[1].description).to eq('Galpão do aeroporto de João Pessoa')

      expect(result[2].id).to eq(2)
      expect(result[2].name).to eq('Galpão Maceió')
      expect(result[2].code).to eq('MCZ')
      expect(result[2].city).to eq('Maceió')
      expect(result[2].state).to eq('AL')
      expect(result[2].address).to eq('Rua do Jacintinho, 59')
      expect(result[2].postal_code).to eq('35106-959')
      expect(result[2].area).to eq(50_000)
      expect(result[2].description).to eq('Galpão localizado no setor industrial de Maceió')

      expect(result[3].id).to eq(1)
      expect(result[3].name).to eq('Galpão Rio')
      expect(result[3].code).to eq('SDU')
      expect(result[3].city).to eq('Rio de Janeiro')
      expect(result[3].state).to eq('RJ')
      expect(result[3].address).to eq('Avenida Atlantica, 10')
      expect(result[3].postal_code).to eq('20000-000')
      expect(result[3].area).to eq(1_151)
      expect(result[3].description).to eq('Galpão do aeroporto Santos Dumont (Rio de Janeiro-RJ)')
    end

    it 'deve retornar vazio se a API estiver indisponível' do
      error_response = double('faraday_error_response', status: 500, body: "{ error: 'Erro ao obter dados' }")
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(error_response)

      result = Warehouse.all

      expect(result).to eq([])
    end
  end
end