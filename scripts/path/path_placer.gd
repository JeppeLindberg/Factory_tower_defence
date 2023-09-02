extends Node2D

var path


# Can this placer recieve a resource?
func can_recieve_resource():
	return path.check_can_recieve_at_pos(global_position)

# Recieve a resource
func receive_resource(resource):
	return path.receive_resource(resource, global_position)