#
# Sensirion SHT35
# Humidity and Temperature Sensor
#

class SHT35
  ADDR = 0x45

  # 解像度設定 [MSB, LSB, 待ち時間(秒)]
  # 1: High, 2: Medium, 3: Low
  MEASURE_COMMANDS = {
    1 => [0x2c, 0x06, 0.015],
    2 => [0x2c, 0x0d, 0.006],
    3 => [0x2c, 0x10, 0.004]
  }

  attr_reader :temperature, :humidity

  def initialize(i2c, resolution_type: 1)
    @i2c = i2c
    
    # 解像度設定の取得（デフォルトは High: 1）
    config = MEASURE_COMMANDS[resolution_type] || MEASURE_COMMANDS[1]
    @cmd_msb    = config[0]
    @cmd_lsb    = config[1]
    @wait_time  = config[2]

    # デバイスのリセット
    @i2c.write(ADDR, 0x30, 0xa2)
    sleep 0.01 # リセット待ち

    # ステータスの確認
    res = @i2c.read(ADDR, 3, 0xf3, 0x2d)
    if res.nil? || crc8(res[0, 2]) != res.getbyte(2)
      raise "SHT35: Sensor not found or CRC error during initialization"
    end
  end

  def measure
    # 計測コマンドの送信
    @i2c.write(ADDR, @cmd_msb, @cmd_lsb)
    
    # 計測待ち (解像度に応じた時間)
    sleep @wait_time
    
    # データの読み取り (T_MSB, T_LSB, T_CRC, H_MSB, H_LSB, H_CRC)
    res = @i2c.read(ADDR, 6)
    return false if res.nil?

    # 温度データのCRC確認と計算
    if crc8(res[0, 2]) == res.getbyte(2)
      st = to_uint16(res.getbyte(0), res.getbyte(1)).to_f
      @temperature = -45 + 175 * st / 65535
    else
      @temperature = nil
    end

    # 湿度データのCRC確認と計算
    if crc8(res[3, 2]) == res.getbyte(5)
      srh = to_uint16(res.getbyte(3), res.getbyte(4)).to_f
      @humidity = 100 * srh / 65535
    else
      @humidity = nil
    end

    !@temperature.nil?
  end

  private

  def to_uint16(b1, b2)
    (b1 << 8 | b2)
  end

  def crc8(data)
    crc = 0xff
    data.each_byte do |b|
      crc ^= b
      8.times do
        crc = (crc << 1) ^ (crc & 0x80 != 0 ? 0x31 : 0)
        crc &= 0xff
      end
    end
    crc
  end
end
