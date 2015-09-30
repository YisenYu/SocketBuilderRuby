
class Pin
  @@num_pin = 0
  @x
  @y
  @z
  @params
  @ball # R, H (x, y, z) is already known
  
  def initialize(x, y, z, params, ball)
    @x = x
    @y = y
    @z = z
    @params = params
    @ball = ball
    @@num_pin += 1
    
    create()
  end
  
  def create()
    # in fact, gp_pin is already existed
    if (defined? $gp_pin).nil? or $gp_pin.deleted?
      $gp_pin = Sketchup.active_model.entities.add_group
    end
    ents = $gp_pin.entities
    
    # add surface
    # we assume that the params data are correct
    for i in 1..@params.length / 3
      i_start = (i - 1)*3
      d1 = @params[i_start]
      d2 = @params[i_start + 1]
      h = @params[i_start + 2]
      p_array = [ [@x, @y, @z],
                  [@x, @y + d1, @z],
                  [@x, @y + d2, @z + h],
                  [@x, @y, @z + h]
                ]

      fill_face = ents.add_face p_array
      fill_path = ents.add_circle [@x,@y,@z], [0,0,1], d1 + 100
      fill_face.followme fill_path
	  ents.erase_entities fill_path
      
      # at last
      # renew the @z coordinate 
      @z = @z + h; 
    end # end of forloop
    
    # add ball if it has one
    if @ball.length == 2
	  
      radius = @ball[0]
      h = @ball[1]
	  
      cut_radius = Math.sqrt(2*h*radius - h**2)
      p1 = [@x, @y, @z]
      p2 = [@x, @y, @z + h]
      p3 = [@x, @y + cut_radius, @z + h]
      curv_line = ents.add_curve p1, p2, p3

	  
	  
	  
      require "./AdvGeom.rb"
      # p4 = [@x, @y + radius, @z + radius]
	  p4 = [@x, @y + Math.sqrt(h*radius - h**2/4), @z + h/2]
      arc = create_arc(p3, p4, p1, ents)
      arc_all = arc + curv_line
      face_slice = ents.add_face arc_all
      path_circle = ents.add_circle p2, [0, 0, 1], cut_radius
      face_slice.followme path_circle

      
    end
    
  end #end of create
  
end







