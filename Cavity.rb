
class Cavity
  @@num_cav = 0
  @x
  @y
  @z
  @params # D_b, D_t, H
  
  def initialize(x, y, z, params)
    @x = x
    @y = y
    @z = z
    @params = params
    @@num_cav += 1
    
    create()
  end
 
  def create()
  # in fact, gp_socket is already existed
    if (defined? $gp_socket).nil? or $gp_socket.deleted?
      $gp_socket = Sketchup.active_model.entities.add_group
    end
    ents = $gp_socket.entities
    
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

      cut_face = ents.add_face p_array
      cut_path = ents.add_circle [@x,@y,@z], [0,0,1], d1+100
      cut_face.followme cut_path
	  ents.erase_entities cut_path
      
      # at last
      # renew the @z coordinate 
      @z = @z + h; 
    end
    
    
  end
  
end # end of class






