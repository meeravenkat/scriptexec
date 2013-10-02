require 'optparse'
require 'pp'

# the options eventually get put here
options = {}

optparse = OptionParser.new do|opts|

# the help info
opts.banner = "Usage: script.rb [options] input-file output-file"

# This sets the default of 'flag' to 'false' and says it should be
# 'true' if the '-f' option is present
options[:flag] = false
  opts.on( '-f', '--flag', "Flag has been set" ) do
  options[:flag] = true
  end
end

optparse.parse

# if no input-file or output-file is given, spit out the help
if ARGV.empty?
   p "arg empty"
  puts optparse
  exit(-1)
end

# If the flag is true then tell me so, if not, tell me it isn't.
if options[:flag] = true
  pp "Flag is true"
else
  pp "Flag is false"
end