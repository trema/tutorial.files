class PacketinDumper < Controller
  def packet_in dpid, event
    puts "received a packet_in"
    info "dpid: #{ dpid.to_hex }"
    info "in_port: #{ event.in_port }"
  end
end
