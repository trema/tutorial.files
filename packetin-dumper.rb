class PacketinDumper < Controller
  def packet_in dpid, message
    puts "received a packet_in"
    info "dpid: #{ dpid.to_hex }"
    info "in_port: #{ message.in_port }"
  end
end
