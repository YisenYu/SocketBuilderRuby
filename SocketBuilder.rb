
class SocketBuilder
  @x
  @y 
  @z
  
  @params_dict
  
  @h_pcb
  @h_pad_b
  @h_pad_t
  @h_socket
  @h_pkg
  
  @num_x
  @num_y
  @xs
  @ys
  @dx
  @dy
  
  def initialize(x, y, z, datafile)
    @x = x
    @y = y
    @z = z
    
    # read data from datefile
	# datafile = "F:\\_Projects\\Sketchup\\code_dev\\test.txt"
    load './DataLoader.rb'
	@params_dict = {}
	dataloader = DataLoader.new(datafile)
	@params_dict = dataloader.getdata()
	
	# params details
	# -- takes only one input param --
	# pcb: length, width, height
	# pkg: length, width, height
	# socket: length, width, height
	# pad_b: radius, height, color
	# pad_t: radius, height, color
	# cav: d_b, d_t, height,...
	# -- takes two input params --
	# pin: 	1.params: d_b, d_t, height,...
	#		2.ball: radius, height or none
	
	@h_pcb 		= @params_dict["pcb"][2]
	@h_socket	= @params_dict["socket"][2]
	@h_pkg		= @params_dict["pkg"][2]
	# we assume that the height of all the pads are the same
	@h_pad_b	= @params_dict["list_pad_b"][0][1]
	@h_pad_t	= @params_dict["list_pad_t"][0][1]
	
	@num_x = @params_dict["num_x"]
	@num_y = @params_dict["num_y"]
	@xs = @params_dict["xs"]
	@ys = @params_dict["ys"]
	@dx = @params_dict["dx"]
	@dy = @params_dict["dy"]
  
    create()
  end # end of initialize
  
  def create()
    
    # step1: create groups, materials****************************
    # gp_socket
    # gp_pin
    # gp_pcb
    # gp_pkg
    # gp_pad_r
    # gp_pad_g
    # gp_pad_b
    $gp_socket = Sketchup.active_model.entities.add_group
    $gp_pin = Sketchup.active_model.entities.add_group
    $gp_pcb = Sketchup.active_model.entities.add_group
    $gp_pkg = Sketchup.active_model.entities.add_group
    $gp_pad_r = Sketchup.active_model.entities.add_group    
    $gp_pad_g = Sketchup.active_model.entities.add_group 
    $gp_pad_b = Sketchup.active_model.entities.add_group 

    # material definition
    mats = Sketchup.active_model.materials
    
    mat_socket = mats.add "mat_socket"
    mat_socket.color = [96, 96, 96] # gray
    mat_socket.alpha = 0.3
    
    mat_pin = mats.add "mat_pin"
    # mat_pin.color = [0, 155, 155] # light green
	mat_pin.color = [255, 255, 0] # light green
    mat_pin.alpha = 1
    
    mat_pcb = mats.add "mat_pcb"
    mat_pcb.color = [80, 150, 100]
    mat_pcb.alpha = 0.4
    
    mat_pkg = mats.add "mat_pkg"
    mat_pkg.color = [80, 150, 150]
    mat_pkg.alpha = 0.4
    
	
	
	# fixed
    mat_pad_r = mats.add "mat_pad_r"
    mat_pad_r.color = [255, 0, 0]
    mat_pad_r.alpha = 0.6    

    mat_pad_g = mats.add "mat_pad_g"
    mat_pad_g.color = [0, 255, 0]
    mat_pad_g.alpha = 0.6  
    
    mat_pad_b = mats.add "mat_pad_b"
    mat_pad_b.color = [0, 0, 255]
    mat_pad_b.alpha = 0.6  
    
    
    # step 2: create each group***************************
    load './Pcb.rb'
    Pcb.new(@x, @y, @z, @params_dict["pcb"])  
    @z += @h_pcb
    # @z: the upper surface of pcb
    
	load './Socket.rb'
	Socket.new(@x, @y, @z + @h_pad_b, @params_dict["socket"])
    
    load './Pad.rb'
    load './Cavity.rb'
    load './Pin.rb'
    

    for i_x in 1 .. @num_x
      for i_y in 1 .. @num_y
	  
		i = (i_x - 1)*@num_y + i_y - 1
        x = @x + @xs + (i_x - 1)*@dx
        y = @y + @ys + (i_y - 1)*@dy
		
        # params = [2, @h_pad_b, "r"]
		index = @params_dict["pad_b"][i] - 1
		Pad.new(x,y,@z, @params_dict["list_pad_b"][index])
		
		# params = [1,2,2,  2,2,8]
		index = @params_dict["cav"][i] - 1
        Cavity.new(x,y,@z + @h_pad_b, @params_dict["list_cav"][index])
        
		
		
        # params = [0.7,1,2, 1.3,1.5,8]
        # params_ball = []
		index = @params_dict["pin"][i] - 1
		params = @params_dict["list_pin"][index]
		index = @params_dict["ball"][i] - 1
		params_ball = @params_dict["list_ball"][index]
        Pin.new(x,y,@z + @h_pad_b, params, params_ball)
        
		
		
		
        # params = [2, @h_pad_t, "r"]
		index = @params_dict["pad_t"][i] - 1
		Pad.new(x,y,@z + @h_pad_b + @h_socket, @params_dict["list_pad_t"][index])
      end
    end
	
    @z += (@h_pad_b + @h_socket + @h_pad_t)
    load './Pkg.rb'
	Pkg.new(@x, @y, @z, @params_dict["pkg"])
	

    
    
    # step 3: add materials to groups************************
    $gp_socket.material = mat_socket
    $gp_pin.material = mat_pin
    $gp_pcb.material = mat_pcb
    $gp_pkg.material = mat_pkg
    $gp_pad_r.material = mat_pad_r  
    $gp_pad_g.material = mat_pad_g 
    $gp_pad_b.material = mat_pad_b
  end # end of create
  
  # helping methods
  
end










