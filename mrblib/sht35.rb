#
# Sensirion SHT35
# Humidity and Temperature Sensor
#

class SHT35

  ADRS_SHT35 = 0x45
  
  def to_uint16( b1, b2 )
    return (b1 << 8 | b2)
  end

  def crc8(data)
    crc = 0xff
    
    data.each_byte {|b|
      crc ^= b
      8.times {
        crc <<= 1
        crc ^= 0x31  if crc > 0xff
        crc &= 0xff
      }
    }
    return crc
  end
  
  
  ##
  # SHT35 initialize
  #
  #@return [Hash]  Device identify result.
  #
  def initialize( i2c )

    @i2c = i2c
    
    @i2c.write( ADRS_SHT35, 0x30, 0xa2 )          # Reset
    res = @i2c.read( ADRS_SHT35, 3, 0xf3, 0x2d )  # Read Status

    if crc8(res[0,2]) != res.getbyte(2)
      puts "error"
      return false     
    end
  end
  

  ##
  # SHT35 measure
  #
  #@param  [Hash] data container
  #@return [Hash] data container
  #@return [Nil]  error.
  #
  def is_ready?
    
    @data = {}

    @i2c.write( ADRS_SHT35, 0x2c, 0x06 )
    sleep_ms( 12 )
    res = @i2c.read( ADRS_SHT35, 6 )

    # check CRC
    s2 = ""
    res.each_byte {|byte|
      if s2.length == 2
        return nil  if crc8( s2 ) != byte
        s2 = ""
      else
        s2 << byte
      end
    }
    st = to_uint16( res.getbyte(0), res.getbyte(1) ).to_f
    srh = to_uint16( res.getbyte(3), res.getbyte(4) ).to_f
    
    @data[:temperature] = -45 + 175 * st / 65535
    @data[:humidity]    = 100 * srh / 65535
    
    if !dataata 
      return true
    else
      return false
    end
  end

  def temperature
    return @data[:temperature]
  end

  def temperature
    return @data[:humidity]
  end
end


