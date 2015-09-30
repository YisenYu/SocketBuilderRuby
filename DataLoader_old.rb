class DataLoader

	def initialize(filename)
        @hash = {}
        still_comments = 0
		
		file = File.open(filename,"r")
		file.each do |line|
		

			
			data = line.lstrip.rstrip
			if data.length == 0
				next
			elsif data[0] == "#"
				next
			elsif data[0..5] == "=begin"
				still_comments = 1
				next
			elsif data[0..3] == "=end"
				still_comments = 0
				next
				
			elsif still_comments == 1
				next
				
				
				
			elsif data.include? ":"
				array = line.split(":")
				key = array[0].lstrip.rstrip
				value = array[1].lstrip.rstrip
				#print key + " " + value
				if @hash.has_key?(key)
					eval( "@hash['" + key + "']<<[" + value + "]" )# add to existed item
				else
					eval( "@hash['" + key + "']=[[" + value + "]]" )# create a new item
				end
			end # if data
		end # each
		file.close

	end # initialize
	
    def getdata()
      return @hash
    end
	
end
