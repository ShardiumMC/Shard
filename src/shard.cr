require "socket"
require "json"

module Shard
  VERSION = "0.1.0"

  def self.start_server(port = 25565)
    server = TCPServer.new("0.0.0.0", port)
    puts "Shard is running on 0.0.0.0:#{port}"

    loop do
      client = server.accept
      spawn { handle_client(client) }
    end
  end

  def self.handle_client(client : TCPSocket)
    puts "New connection: #{client.remote_address}"
    packet_length = read_varint(client)
    packet_id = read_varint(client)
    protocol_version = read_varint(client)
    server_address_length = read_varint(client)
    server_address = Bytes.new(server_address_length)
    client.read(server_address)
    port = Bytes.new(2)
    client.read(port)
    next_state = read_varint(client)

    if next_state == 1
      send_status_response(client)
    else
      client.puts "Login not supported currently"
    end
    client.close
  rescue ex
    puts "Error at connection: #{ex.message}"
    client.close
  end

  def self.send_status_response(client : TCPSocket)
    motd = {
      "version" => { "name" => "Shard 0.1.0", "protocol" => 760 },
      "players" => { "max" => 20, "online" => 0 },
      "description" => { "text" => "Shard Crystal Server" }
    }

    json_str = motd.to_json
    json_bytes = json_str.to_slice

    # Build packet: packet_id (0) + string_length + string_data
    io = IO::Memory.new
    io.write(encode_varint(0))
    io.write(encode_varint(json_bytes.size.to_i32))
    io.write(json_bytes)

    packet_data = io.to_slice
    client.write(encode_varint(packet_data.size.to_i32))
    client.write(packet_data)
  end


  def self.read_varint(io : IO) : Int32
    num = 0i32
    shift = 0
    loop do
      byte = io.read_byte
      raise "Unexpected end of stream" if byte.nil?
      byte_value = byte.not_nil!
      num |= ((byte_value & 0x7F).to_i32 << shift)
      break if (byte_value & 0x80) == 0
      shift += 7
    end
    num
  end

  def self.encode_varint(value : Int32) : Bytes
    v = value
    result = [] of UInt8
    loop do
      temp = v & 0x7F
      v >>= 7
      if v != 0
        result << (temp | 0x80).to_u8
      else
        result << temp.to_u8
        break
      end
    end
    Bytes.new(result.to_unsafe, result.size)
  end
end

Shard.start_server
