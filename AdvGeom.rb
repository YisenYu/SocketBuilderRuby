def create_arc(pt_a, pt_b, pt_c, ents)
# Define the points and vectors
a = Geom::Point3d.new pt_a
b = Geom::Point3d.new pt_b
c = Geom::Point3d.new pt_c
ab = b - a
bc = c - b
ca = a - c
# Find the vector lengths
ab_length = ab.length
bc_length = bc.length
ca_length = ca.length

# Find the cross product of AB and BC
cross = ab * bc
cross_length = cross.length
denom = 2 * cross_length**2

# Find the radius
radius = (ab_length*bc_length*ca_length) / (2*cross_length)

# Find the center
alpha = -1 * bc_length**2 * (ab.dot ca) / denom
beta = -1 * ca_length**2 * (ab.dot bc) / denom
gamma = -1 * ab_length**2 * (ca.dot bc) / denom
o = a.transform alpha
o.transform! (b.transform beta)
o.transform! (c.transform gamma)

# Compute the normal vector
normal = ab * bc; normal.normalize!

# Determine the angles between the points
oa = a - o
ob = b - o
oc = c - o
aob = oa.angle_between ob
aoc = oa.angle_between oc
boc = ob.angle_between oc

# Check for correct angles
if aoc < boc
boc = 2 * Math::PI - boc
elsif aoc < aob
aob = 2 * Math::PI - aob
end

# Create the two arcs
# ents = Sketchup.active_model.entities
arc_1 = ents.add_arc o, oa, normal, radius, 0, aob
arc_2 = ents.add_arc o, ob, normal, radius, 0, boc
arc_1 += arc_2
end
