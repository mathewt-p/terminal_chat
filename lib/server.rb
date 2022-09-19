require 'socket'
class Server
  attr_reader :selected_port
  def initialize(port: 3000)
    @selected_port = port # Server bound to port 3000
    @clients = []
  end
  
  def start
    server = TCPServer.new selected_port 
    puts "Server running on port: #{selected_port}"

    clients = @clients

    loop do
      begin
        # we wait for a client to connect, and assign it to client
        client = server.accept
        clients << client
        Thread.new {
          handle_client(clients, client)
        }

      rescue SystemExit, Interrupt
        puts "\n Stopping server."
        break
      end
    end
  end

  def stop
    @clients.each { |client| client.puts "_stop_connection_" }
  end
  
  private
  def handle_client(clients, client)
    # client_name will take whatever name the client put when it will connect to the server. We will see later how it's sent from the client perspective.
    client_name = client.gets.chomp

    # here we will display a welcome message and show how many clients are already connected
    client.puts "Hello #{client_name}! Clients connected: #{clients.count}"

    # this method is described below. It announces to all clients who is the new client.
    announce_to_everyone(clients, "#{client_name} joined!")

    # this is another loop. gets will take any text coming from the client...
    while line = client.gets
      incoming_data_from_client = line.chomp
      #... and this text will be shared to all the clients. A little bit of formatting to indicate who said what.
      announce_to_everyone clients, "#{client_name}: #{incoming_data_from_client}"
    end

    # it will close the client connexion and remove it from the clients array. And other clients will receive a notification.
    client.close
    clients.delete(client)
    announce_to_everyone(clients, "#{client_name} left!")
  end

  # this method takes the text sent by a client, and the clients connected. For each client from clients, the text will be displayed
  def announce_to_everyone(clients, text)
    clients.each { |client| client.puts text }
  end
end