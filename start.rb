require './root.rb'
class Start
  def self.run
    self.new.method(:run).call
  end

  private

  def run
    begin
      server = Server.new
      server_thread = Thread.new { server.start} 
      clients = Thread.new { start_clients }

      server_thread.join
      clients.join
    rescue SystemExit, Interrupt
      puts "\n Stopping App."
      server.stop
      server_thread.kill
      clients.kill
    end
  end

  def start_clients
    system(`gnome-terminal -- ruby _client.rb A`)
    system(`gnome-terminal -- ruby _client.rb b`)
  end

end

Start.run
