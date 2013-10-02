filenames = ["PL-UIDDB-266.rb","PL-UIDDB-266.xml"]
dir_path = 'M:\socket_programming\emailed'

filenames.each do |file|
   txt = File.open(file)
   puts "Here's your file #{file}"
   # puts txt.read()
   File.open("#{dir_path}/#{file}", "w") do |file2|
      file2.write(txt.read())
   end
end