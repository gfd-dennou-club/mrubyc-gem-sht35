# mrubyc-gem-sht35
mruby/c sources for SHT35
## device
https://jp.seeedstudio.com/Grove-I2C-High-Accuracy-Temp-Humi-Sensor-SHT35.html

### data sheet
https://files.seeedstudio.com/wiki/Grove-I2C_High_Accuracy_Temp-Humi_Sensor-SHT35/res/Datasheet%20SHT3x-DIS.pdf

## sample code
```ruby
puts("SHT35 HumiditySensor")

i2c = I2C.new(22, 21)
sht35 = SHT35.new( i2c )

while true
  if sht35.is_ready?

    puts sprintf( "Temperature:%5.1f ", sht35.temp )
    puts sprintf( "Humidity:%5.1f ",    sht35.humi )

  end
  sleep 1
end
```
