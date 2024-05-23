class Database
  def insert(*args)
    _execute(insert_sql(*args))
  end

  def update(*args)
    _execute(update_sql(*args))
  end

  def delete(*args)
    _execute(delete_sql(*args))
  end

  private

  def _checkout
    conn = checkout_connection
    yield conn
  ensure
    checkin_connection(conn) if conn
  end

  def _execute(sql)
    _checkout do |conn|
      conn.execute(sql)
    end
  end
end