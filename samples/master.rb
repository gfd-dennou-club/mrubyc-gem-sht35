i2c = I2C.new()
sht35 = SHT35.new(i2c, resolution_type: 3)

loop do
   sht35.measure
   puts sprintf( "Temperature:%.1f ", sht35.temperature )
   puts sprintf( "Humidity:%.1f ",    sht35.humidity )
   sleep 1
end
