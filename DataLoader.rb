class DataLoader

	@prams_draw_hash
	@params_struct
	
	SectionsStruct = Struct.new(
					:Project,
					:Socket,
					:PinCav,
					:PCB,
					:Package,
					:Array,
					:Analysis,
					:Material,
					:PinCavLib)

	
	sections_dict = [
		'Project',
		'Socket',
		'PinCav',
		'PCB',
		'Package',
		'Array',
		'Analysis',
		'Material',
		'PinCavLib'
	]
	
	items_dict = [
		'x_pitch',
		'y_pitch',
		'total_height',
		'pin1',
		'pin2',
		'pin3',
		'cav1',
		'cav2',
		'cav3',
		'dpad', # pcb
		'tpad', # pcb
		'nvoffx', # pcb
		'nvoffy', # pcb
		'td1', # pcb
		'tcu2', # pcb
		'dpad', # pkg
		'tpad', # pkg
		'nvoffx', # pkg
		'nvoffy', # pkg
		'td1', # pkg
		'tcu2', # pkg
		'bga_diameter',
		'bga_height',
		'nx',
		'ny',
		'pin_array',
		'PCB_terminals',
		'Pin1',
		'Pin2',
		'Pin3'
	]


	# ************** parse each line in the datafile *******************
	def initialize(filename)
	
        @prams_draw_hash = {}
		@params_struct = SectionsStruct.new
		@params_struct.Project = {}
		@params_struct.Socket = {}
		@params_struct.PinCav = {}
		@params_struct.PCB = {}
		@params_struct.Package = {}
		@params_struct.Array = {}
		@params_struct.Analysis = {}
		@params_struct.Material = {}
		@params_struct.PinCavLib = {}
		
		@prams_draw_hash["pcb"] = []
		@prams_draw_hash["pkg"] = []
		@prams_draw_hash["socket"] = []
		@prams_draw_hash["pad_b"] = []
		@prams_draw_hash["pad_t"] = []
		@prams_draw_hash["cav"] = []
		@prams_draw_hash["pin"] = []
		@prams_draw_hash["ball"] = []
		@prams_draw_hash["list_pad_b"] = []
		@prams_draw_hash["list_pad_t"] = []
		@prams_draw_hash["list_cav"] = []
		@prams_draw_hash["list_pin"] = []
		@prams_draw_hash["list_ball"] = []
		@prams_draw_hash["num_x"] = 0
		@prams_draw_hash["num_y"] = 0
		@prams_draw_hash["xs"] = 0
		@prams_draw_hash["ys"] = 0
		@prams_draw_hash["dx"] = 0
		@prams_draw_hash["dy"] = 0
		


		# parse recoder variables
        still_comments = 0
		current_section = '';
		current_item = '';
		current_str = '';
		
		
		# parse file starts
		file = File.open(filename,"r")
		file.each do |line|
			data = line.lstrip.rstrip
			
			# ********************** invalid line **********************
			# empty line
			if data.length == 0
				next
			
			# one line comment
			elsif data[0] == "#"
				next
			
			# multiple lines comment starts
			elsif data[0..5] == "=begin"
				still_comments = 1
				next
			
			# multiple lines comment ends
			elsif data[0..3] == "=end"
				still_comments = 0
				next
			
			# during multiple lines comment
			elsif still_comments == 1
				next
			

			elsif data.include?('</')
					if current_str.length != 0
						if(current_str[0] == ',')
							current_str[0] = ''
						end
						eval("@params_struct." + current_section + "['" + current_item + "'] = '" + current_str + "'")
					end
				next
			
			# ********************** valid line **********************
			elsif (data.include?('[') and data.include?(']'))
			
				if current_str.length != 0
					if(current_str[0] == ',')
						current_str[0] = ''
					end
					eval("@params_struct." + current_section + "['" + current_item + "'] =  '" + current_str + "'")
				end
				array = line.split("]")
				current_item = array[0].delete('[').lstrip.rstrip
				current_str = array[1].lstrip.rstrip.chop().lstrip.rstrip
				
				
			elsif (data.include?('<') and data.include?('>'))
				current_section = data.delete('<').delete('>').lstrip.rstrip
				
				
			else
				current_str = current_str + ',' + data.chop().lstrip.rstrip
				
			end # if data
		end # each
		file.close
		
		

		
		# ************** generate prams_draw_hash *******************
=begin
	# params details
	# -- only one vector --
	# pcb: length, width, height
	# pkg: length, width, height
	# socket: length, width, height
	
	# -- many row, each row represents one type --
	# -- each line contains one vector --
	# pad_b: radius, height, color
	# pad_t: radius, height, color
	# cav: d_b, d_t, height,...
	# pin: d_b, d_t, height,...
	# ball: radius, height or none
	
	# -- one vector, which represents the layout of the pin matrix --
	# cav:   1,2,1,1,1,   1,1,2,1,1,  1,2,1,2,1
    # pin:   1,2,1,1,1,   1,1,2,1,1,  1,2,1,2,1
    # ball:  1,2,1,1,1,   1,1,2,1,1,  1,2,1,2,1
	# pad_b:
	# pad_t:
	
	# ****************************************
	# @params_dict["pcb"] = [[12, 20, 1]]
	# @params_dict["pkg"] = [[12, 20, 1]]
	# @params_dict["socket"] = [[12,20,10]]
	
	# @params_dict["pad_b"] = [[1,0.2,'r'], [1,0.2,'g'], 1,0.2,'b']
	# @params_dict["pad_t"] = [[1,0.2,'r'], [1,0.2,'g'], 1,0.2,'b']
	# @params_dict["cav"] = [[1,1.2,0.5, 1.2,1.2,2, 1.2,1.4,5, 1.4,1.2,2.5], [1,1.2,2, 1.3,1.4,2, 1.4,1.4,6]]
	# @params_dict["pin"] = [[0.3,0.5,0.5, 0.5,0.7,2, 0.7,0.7,5, 0.7,0.4,2.5], [0.4,0.7,2, 0.7,0.9,2, 0.9,0.9,4]]
	# @params_dict["ball"] = [[0], [1.2,2]]
	
	# @params_dict["list_pad_b"] = [[3,1,3,3,3,   3,2,1,1,2,   2,3,3,1,3]]
	# @params_dict["list_pad_t"] = [[3,1,3,3,3,   3,2,1,1,2,   2,3,3,1,3]]
	# @params_dict["list_cav"] = [[1,2,1,1,1,   1,1,2,1,1,  1,2,1,2,1]]
	# @params_dict["list_pin"] = [[1,2,1,1,1,   1,1,2,1,1,  1,2,1,2,1]]
	# @params_dict["list_ball"] = [[1,2,1,1,1,   1,1,2,1,1,  1,2,1,2,1]]
	
	# @params_dict["num_x"] = [[4]]
	# @params_dict["num_y"] = [[4]]
	# @params_dict["xs"] = [[1]]
	# @params_dict["ys"] = [[1]]
	# @params_dict["dx"] = [[1]]
	# @params_dict["dy"] = [[1]]
=end
	

# =begin
	eval('@prams_draw_hash["num_x"] = ' + @params_struct.Array['nx'])
	eval('@prams_draw_hash["num_y"] = ' + @params_struct.Array['ny'])
	eval('@prams_draw_hash["dx"] = ' + @params_struct.Project['x_pitch'])
	eval('@prams_draw_hash["dy"] = ' + @params_struct.Project['y_pitch'])
	
	# x:length
	# y:width
	length_pcb = 0
	width_pcb = 0
	eval('length_pcb = ' + 
		@params_struct.Project['x_pitch'] + '*(2*' +
		@params_struct.PCB['nvoffx'] + '+' +
		@params_struct.Array['nx'] + '-1)'
		)
	eval('width_pcb = ' + 
		@params_struct.Project['y_pitch'] + '*(2*' +
		@params_struct.PCB['nvoffy'] + '+' +
		@params_struct.Array['ny'] + '-1)'
		)
	length_pkg = length_pcb
	width_pkg = width_pcb
	length_socket = length_pcb
	width_socket = width_pcb
	
	height_pcb = 0
	eval('height_pcb = '+
		@params_struct.PCB['td1'] + 
		'+' + 
		@params_struct.PCB['tcu2'])
		
	height_pkg = 0
	eval('height_pkg = '+
		@params_struct.Package['td1'] + 
		'+' + 
		@params_struct.Package['tcu2'])
	
	height_socket = 0
	eval('height_socket = ' + @params_struct.Socket['total_height'])
	
	eval('@prams_draw_hash["xs"] = ' +
		@params_struct.PCB['nvoffx'] + '*' +
		@params_struct.Project['x_pitch'])
		
	eval('@prams_draw_hash["ys"] = ' +
		@params_struct.PCB['nvoffy'] + '*' +
		@params_struct.Project['y_pitch'])
	
	@prams_draw_hash["pcb"] = [length_pcb, width_pcb, height_pcb]
	@prams_draw_hash["pkg"] = [length_pkg, width_pkg, height_pkg]
	@prams_draw_hash["socket"] = [length_socket, width_socket, height_socket]
	
	# pcb side
	pad_b_r = []
	pad_b_g = []
	pad_b_b = []
	eval('pad_b_r = [' +
		@params_struct.PCB['dpad'] + '/2, ' + 
		@params_struct.PCB['tpad'] + ', "r"' +
		']')
	eval('pad_b_g= [' +
		@params_struct.PCB['dpad'] + '/2, ' + 
		@params_struct.PCB['tpad'] + ', "g"' +
		']')
	eval('pad_b_b = [' +
		@params_struct.PCB['dpad'] + '/2, ' + 
		@params_struct.PCB['tpad'] + ', "b"' +
		']')
	
	# pkg side
	pad_t_r = []
	pad_t_g = []
	pad_t_b = []
	eval('pad_t_r = [' +
		@params_struct.Package['dpad'] + '/2, ' + 
		@params_struct.Package['tpad'] + ', "r"' +
		']')
	eval('pad_t_g= [' +
		@params_struct.Package['dpad'] + '/2, ' + 
		@params_struct.Package['tpad'] + ', "g"' +
		']')
	eval('pad_t_b = [' +
		@params_struct.Package['dpad'] + '/2, ' + 
		@params_struct.Package['tpad'] + ', "b"' +
		']')
	
	@prams_draw_hash["list_pad_b"] = [pad_b_r, pad_b_g, pad_b_b]
	@prams_draw_hash["list_pad_t"] = [pad_t_r, pad_t_g, pad_t_b]
# =end	
	
	

	if @params_struct.PinCavLib.has_key?('Pin1')
		str_pin1, str_cav1 = getPinCavStr(@params_struct.PinCavLib['Pin1'])
	else
		str_pin1 = ''
		str_cav1 = ''
	end
	
	if @params_struct.PinCavLib.has_key?('Pin2')
		str_pin2, str_cav2 = getPinCavStr(@params_struct.PinCavLib['Pin2'])
	else
		str_pin2 = ''
		str_cav2 = ''
	end
	
	if @params_struct.PinCavLib.has_key?('Pin3')
		str_pin3, str_cav3 = getPinCavStr(@params_struct.PinCavLib['Pin3'])
	else
		str_pin3 = ''
		str_cav3 = ''
	end
	

	eval('@prams_draw_hash["list_pin"] = [' +
		'[' + str_pin1 + '],' +
		'[' + str_pin2 + '],' +
		'[' + str_pin3 + ']' +
		']')
	eval('@prams_draw_hash["list_cav"] = [' +
		'[' + str_cav1 + '],' +
		'[' + str_cav2 + '],' +
		'[' + str_cav3 + ']' +
		']')

	# ball has only one type
	ball_r = 0
	ball_h = 0
	eval('ball_r = ' +
		@params_struct.Package["bga_diameter"] + '/2')
	eval('ball_h = ' +
		@params_struct.Package["bga_height"])	
	@prams_draw_hash["list_ball"] = [[0], [ball_r, ball_h]]


	
	
	# array
	pad_array = []
	eval('pad_array = ' +
		@params_struct.Array["PCB_terminals"])
	for i in 0...pad_array.length
		if pad_array[i] == 0
			pad_array[i] = 2
		elsif pad_array[i] == -1
			pad_array[i] = 3
		else
			pad_array[i] = 1
		end
	end
	@prams_draw_hash["pad_b"] = pad_array
	@prams_draw_hash["pad_t"] = pad_array
	
	
	
	
	pin_array = []
	eval('pin_array = ' + @params_struct.Array["pin_array"])

	@prams_draw_hash["pin"] = pin_array.clone
	@prams_draw_hash["cav"] = pin_array.clone
	

	ball_array = pin_array.clone
	for i in 0...ball_array.length
		ball_array[i] = getBallNo(pin_array[i])
	end
	@prams_draw_hash["ball"] = ball_array
	
	
	#puts @prams_draw_hash["pin"]
	#puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
	# puts pad_array
	#puts @prams_draw_hash["cav"]
	#puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
	#puts @prams_draw_hash["ball"]
	#puts ball_array
	end # initialize
	
	
	
	
	
	
	
	

	
	def hasBGA(str_pin)
		return (str_pin.include?("BGA"))
	end
	
	def getBallNo(index)
		str = ''
		eval('str = @params_struct.PinCav["pin' + index.to_s + '"]')
		if hasBGA(str)
			return 2
		else
			return 1
		end
	end
	
	
	
	def getPinCavStr(str_pincav)
		index = str_pincav.rindex(',{')
		str_pin = str_pincav[0...index]
		indexl = str_pin.index('(')
		indexr = str_pin.rindex(')')
		str_pin = str_pin[indexl+1 ... indexr].delete('(').delete(')').lstrip.rstrip
		
		
		array = str_pin.split()
		str_pin = ''
		for str in array
			str = (str[-1] == ',')? (str.delete(',')):(str)
			str_pin = str_pin + str + ','
		end
		#str_pin[0] = ''
		str_pin = str_pin.chop()
		
		str_cav = str_pincav[index...str_pincav.length]
		indexl = str_cav.index('(')
		indexr = str_cav.rindex(')')
		str_cav = str_cav[indexl+1 ... indexr].delete('(').delete(')').lstrip.rstrip
		array = str_cav.split()
		str_cav = ''
		for str in array
			str = (str[-1] == ',')? (str.delete(',')):(str)
			str_cav = str_cav + str + ','
		end
		#str_cav[0] = ''
		str_cav = str_cav.chop()
		
		return str_pin,str_cav
	end
	
	
	
	
	# ******************* outer ******************
	def getParamsStruct()
		return @params_struct
	end
	
	
	
    def getdata() # this function will be kept consistent with the old version
      return @prams_draw_hash
    end
	
end


#=begin
test = DataLoader.new('data.txt')
hash = test.getdata()
puts hash['list_ball']
#puts test.getdata()


#info = test.getParamsStruct()
#puts info.Array["pin_array"]
#=end

