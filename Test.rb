class Test
	@list
	@var
	Constv = 1
	
	Info = Struct.new(:id, :name)
	
	def initialize()
		@list = [1,2,3,'4']
		@var = Info.new
		#Constv = 1
	end
	
	def getList()
		return @list
	end
	
	def getVar()
		@var.id = '007'
		@var.name = 'yys'
		return @var
	end

	
	def test()
		a = 999
		b = 888
		return a,b
	end
end


test1 = Test.new()
a,b = test1.test()
puts a
puts b


#a = [
# 1,2,3,4,5,
# 6,7,8,9,10]
# puts a

=begin
Customer = Struct.new(:name, :address)  
Customer.new("Dave", "123 Main")  

info = Struct.new(:prj, :pcb, :pkg)
info1 = info.new
info1.prj = {}

info1.prj['company'] = 'bat'
info1.prj['id'] = '007'

info1.pcb = {}
info1.pcb['length'] = 100

info1.pkg = {}
info1.pkg['length'] = 100

puts info1
puts '===================='
puts info1.pcb['length']
=end

=begin
file = File.open('newtest.txt',"r")
file.each do |line|
	data = line.lstrip.rstrip
	puts data
	puts (data.include?('</') and data.include?('>'))
end
file.close
=end



