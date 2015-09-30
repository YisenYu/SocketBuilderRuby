
class Pad
  @x
  @y
  @z
  @params # radius, h, color
  def initialize(x,y,z,params)
    @x = x
    @y = y
    @z = z
    @params = params
    create()
  end # initialize
  
  def create()
    
    radius = @params[0]
	h = @params[1]
	color = @params[2]
	
	case @params[2]
		when "r"
		    if (defined? $gp_pad_r).nil? or $gp_pad_r.deleted?
				$gp_pad_r = Sketchup.active_model.entities.add_group
			end
			ents = $gp_pad_r.entities
		when "g"
			if (defined? $gp_pad_g).nil? or $gp_pad_g.deleted?
				$gp_pad_g = Sketchup.active_model.entities.add_group
			end
			ents = $gp_pad_g.entities
		when "b"
		    if (defined? $gp_pad_b).nil? or $gp_pad_b.deleted?
				$gp_pad_b = Sketchup.active_model.entities.add_group
			end
			ents = $gp_pad_b.entities		
	end
	
	circle = ents.add_circle [@x,@y,@z], [0,0,1], radius
	face = ents.add_face circle
    path = ents.add_line [@x,@y,@z], [@x,@y, @z + h]
    face.followme path
    
  end # create
end
