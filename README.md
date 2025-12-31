# mrubyc-gem-sht35
mruby/c sources for SHT35
## device
https://jp.seeedstudio.com/Grove-I2C-High-Accuracy-Temp-Humi-Sensor-SHT35.html

### data sheet
https://files.seeedstudio.com/wiki/Grove-I2C_High_Accuracy_Temp-Humi_Sensor-SHT35/res/Datasheet%20SHT3x-DIS.pdf

## Optios
```
resolution_type
1: High (default), 2: Medium, 3: Low
```

## sample code
```ruby
i2c = I2C.new()
sht35 = SHT35.new(i2c, resolution_type: 3)

loop do
   sht35.measure
   puts sprintf( "Temperature:%.1f ", sht35.temperature )
   puts sprintf( "Humidity:%.1f ",    sht35.humidity )
   sleep 1
end
```
