class Warehouse

  attr_accessor :id, :name, :code, :city, :state, :address, :postal_code, :area, :description
  def initialize(id:, name:, code:, city:, state:, address:, postal_code:, area:, description:)
    @id = id
    @name = name
    @code = code
    @city = city
    @state = state
    @address = address
    @postal_code = postal_code
    @area = area
    @description = description
  end

  def self.all
    warehouses = []
    response = Faraday.get('http://localhost:4000/api/v1/warehouses')
    if response.status == 200
      data = JSON.parse(response.body)
      data.each do |d|
        warehouses << Warehouse.new(id: d["id"], name: d["name"], code: d["code"], city: d["city"], state: d["state"], address: d["address"], postal_code: d["postal_code"], area: d["area"], description: d["description"])
      end
    end
    warehouses
  end

end
