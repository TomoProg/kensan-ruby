# 配送状況の追跡用クラス
class Shipment
  def initialize(contents, ship_date, ship_to,
                 street, city, state, zip)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  # 住所の整形メソッド
  # これはやっていることは違えどClientにもある
  def format_address_label
    <<~END
    #{@ship_to}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

# 配送状況の追跡用クラス
class Shipment
  def initialize(contents, ship_date, ship_to, address)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @address = address
  end

  # 住所の整形メソッド
  def format_address_label
    <<~END
    #{@ship_to}
    #{@address.format}
    END
  end
end
