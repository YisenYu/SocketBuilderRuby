
file=File.open(File.join("F:\\_Projects\\Sketchup\\code_dev\\test.txt"),"r")
#file.each { |line| print "#{file.lineno}.", line }
hash = {}
hash["default"] = 1
file.each do |line|
  if (line.index(":")).nil?
  else
    array = line.split(":")
    key = array[0]
    value = array[1]
    print key + " " + value
    if hash.has_key?(key)
      eval( "hash['" + key + "']<<[" + value + "]" )
    else
      eval( "hash['" + key + "']=[[" + value + "]]" )
    end
  end

end
file.close
