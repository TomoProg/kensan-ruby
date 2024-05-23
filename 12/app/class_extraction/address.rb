class Address
  def initialize(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  def format
    <<~END
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end