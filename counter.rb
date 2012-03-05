class Counter
  def initialize
    @db = {}
  end


  def add mac, packet_count, byte_count
    @db[ mac ] ||= { :packet_count => 0, :byte_count => 0 }
    @db[ mac ][ :packet_count ] += packet_count
    @db[ mac ][ :byte_count ] += byte_count
  end


  def each_pair &block
    @db.each_pair &block
  end
end
