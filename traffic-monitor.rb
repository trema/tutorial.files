require "counter"
require "fdb"


class TrafficMonitor < Controller
  periodic_timer_event :show_counter, 10


  def start
    @counter = Counter.new
    @fdb = FDB.new
  end


  def packet_in dpid, message
    macsa = message.macsa
    macda = message.macda

    @fdb.learn macsa, message.in_port
    @counter.add macsa, 1, message.total_len
    out_port = @fdb.lookup( macda )
    if out_port
      packet_out dpid, message, out_port
      flow_mod dpid, macsa, macda, out_port
    else
      flood dpid, message
    end
  end


  def flow_removed dpid, message
    @counter.add message.match.dl_src, message.packet_count, message.byte_count
  end


  ##############################################################################
  private
  ##############################################################################


  def show_counter
    puts Time.now
    @counter.each_pair do | mac, counter |
      puts "#{ mac } #{ counter[ :packet_count ] } packets (#{ counter[ :byte_count ] } bytes)"
    end
  end


  def flow_mod dpid, macsa, macda, out_port
    send_flow_mod_add(
      dpid,
      :hard_timeout => 10,
      :match => Match.new( :dl_src => macsa, :dl_dst => macda ),
      :actions => ActionOutput.new( out_port )
    )
  end


  def packet_out dpid, message, out_port
    send_packet_out(
      dpid,
      :packet_in => message,
      :actions => ActionOutput.new( out_port )
    )
  end


  def flood dpid, message
    packet_out dpid, message, OFPP_FLOOD
  end
end
