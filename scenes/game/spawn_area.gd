extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var rectangle_shape = collision_shape_2d.shape

func get_random_point_in_rect():
	var aabb = get_rect_aabb()
	var random_point = Vector2(
		randf_range(aabb.position.x, aabb.position.x + aabb.size.x),
		randf_range(aabb.position.y, aabb.position.y + aabb.size.y)
	)
	return random_point

func get_rect_aabb():
	var transform = collision_shape_2d.get_global_transform()
	var rect_size = rectangle_shape.extents * 2.0
	return Rect2(transform.origin - rectangle_shape.extents, rect_size)

func get_random_valid_spawn_position():
	var max_attempts = 100
	var attempt = 0
	var position

	while attempt < max_attempts:
		position = get_random_point_in_rect()
		if not is_position_occupied(position):
			return position
		attempt += 1

	print("Failed to find a valid spawn position after", max_attempts, "attempts.")
	return null

func is_position_occupied(position):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	var result = space_state.intersect_point(query)
	return result.size() > 0
