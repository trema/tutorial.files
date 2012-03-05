class HelloSwitch < Controller
  def switch_ready datapath_id
    info "Hello #{ dpid.to_hex }!"
  end
end
