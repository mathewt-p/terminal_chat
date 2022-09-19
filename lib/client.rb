class Client
  attr_reader :selected_port, :selected_host, :username

  def initialize(port: 3000, host: "localhost", username: "name")
    @selected_port = port
    @selected_host = host
    @username = username
  end

  def run
    name = ARGV.shift
    s = TCPSocket.new selected_host, selected_port

    s.puts "#{username}"
    begin
      lt = Thread.new { local_typing(s) }
      rfs = Thread.new { receive_from_server(s, lt) }

      lt.join
      rfs.join
    rescue SystemExit, Interrupt
      puts "\n Stopping connecting."
    end

    s.close             
  end

  private

  def local_typing socket
    loop do
      print "(me)> "
      text_to_send = gets.chomp
      socket.puts text_to_send
    end
  end

  def receive_from_server socket, local_process
    while line = socket.gets
      if line.chomp == "_stop_connection_"
        local_process.kill
        break # Kills this thread as well
      end
      puts line
    end
  end
end
