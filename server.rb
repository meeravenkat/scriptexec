require 'socket'

port = 2000
SIZE = 1024 * 1024 * 10
dir_path = 'M:\socket_programming\emailed'

server = TCPServer.open(port)
puts "Server Listening..."
files_array, threads = []
loop {
   thread = Thread.start(server.accept) do |client|
      while file_values = client.gets
          files_array.push(file_values)
      end
      
      # files_array.each do |writeFile|
         File.open("#{dir_path}/#{files_array[1]}", "w") do |file1|
      # #    # while chunk = client.read(SIZE)
            file1.write(client.read)
         end
      # end
      client.close
      threads << thread
   end
}

threads.each do |thread| 
   p "exec begins here"
   thread.join
end