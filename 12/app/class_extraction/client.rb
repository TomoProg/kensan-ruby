# 顧客情報
class Client
  def initialize(first_name, last_name, street, city,
                 state, zip, phone)
    @first_name = first_name
    @last_name = last_name
    @street = street
    @city = city
    @state = state
    @zip = zip
    @phone = phone
  end

  def update_phone(phone)
    @phone = phone
  end

  def update_address(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  # 住所の整形メソッド
  # これはやっていることは違えどShipmentにもある
  def format_address_label
    <<~END
    #{@first_name} #{@last_name}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

# 顧客情報
class Client
  def initialize(first_name, last_name, address, phone)
    @first_name = first_name
    @last_name = last_name
    @address = address
    @phone = phone
  end

  def update_phone(phone)
    @phone = phone
  end

  def update_address(address)
    @address = address
  end

  # 住所の整形メソッド
  # これはやっていることは違えどShipmentにもある
  def format_address_label
    <<~END
    #{@first_name} #{@last_name}
    #{@address.format}
    END
  end
end
