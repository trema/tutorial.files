require "fdb"


class LearningSwitch < Controller
  add_timer_event :age_fdb, 5, :periodic


  def start
    @fdb = FDB.new
  end


  def packet_in dpid, message
    @fdb.learn message.macsa, message.in_port
    port_no = @fdb.lookup( message.macda )
    if port_no
      flow_mod dpid, message, port_no
      packet_out dpid, message, port_no
    else
      flood dpid, message
    end
  end


  def age_fdb
    @fdb.age
  end


  ##############################################################################
  private
  ##############################################################################


  def flow_mod dpid, message, port_no
    send_flow_mod_add(
      dpid,
      :match => ExactMatch.from( message ),
      :actions => ActionOutput.new( port_no )
    )
  end


  def packet_out dpid, message, port_no
    send_packet_out(
      dpid,
      :packet_in => message,
      :actions => ActionOutput.new( port_no )
    )
  end


  def flood dpid, message
    packet_out dpid, message, OFPP_FLOOD
  end
end
