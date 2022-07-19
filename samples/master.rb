
puts("SHT35 HumiditySensor")

i2c = I2C.new(22, 21)
sht35 = SHT35.new( i2c )

while true
  if sht35.is_ready?
  
    puts sprintf( "Temperature:%5.1f ", sht35.temperature )
    puts sprintf( "Humidity:%5.1f ",    sht35.humidity    )

  end
  sleep 1
end

