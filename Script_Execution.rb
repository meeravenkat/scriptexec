#!/usr/bin/env ruby

require 'ap'
require 'optparse'

options = {}
OptionParser.new do |opts|
   opts.on("--list x,y,z", String, "Example 'list' of arguments") do |list|
      options.list = list
   end
end
str = ARGV[0]
ap options

arrlist = []
arrlist = str.split(",")
ap arrlist
if ARGV.empty?
   ap "nothing there"
   exit
else
   if arrlist[0] == "A"
      puts "we're running list [#{arrlist[1]} and #{arrlist[2]}]  on station #{arrlist[0]}"
   end
end