class SwitchMonitor < Controller
  periodic_timer_event :show_switches, 10


  def start
    @switches = []
  end


  def switch_ready dpid
    @switches << dpid.to_hex
    info "Switch #{ dpid.to_hex } is UP"
  end


  def switch_disconnected dpid
    @switches -= [ dpid.to_hex ]
    info "Switch #{ dpid.to_hex } is DOWN"
  end


  private


  def show_switches
    info "All switches = " + @switches.sort.join( ", " )
  end
end
