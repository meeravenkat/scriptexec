require 'socket'

hostname = 'localhost'
port = 2000
SIZE = 1024 * 1024 * 10

# server = TCPSocket.open(hostname, port)

# send = server.puts("dir")
# response = server.read
# puts response

# server.close
file_array = []
file_array = ["PL-UIDDB-266.rb","PL-UIDDB-266.xml"]

dir_path = 'M:\socket_programming\filehandle'
TCPSocket.open(hostname, port) do |server|
   server.puts file_array
   # file_array.each do |readFile|
      txt = File.open("#{dir_path}/#{file_array[1]}")
      # p txt.read()
      puts "Here's your file #{file_array[1]}"
      server.write(txt.read())
   # end   
end