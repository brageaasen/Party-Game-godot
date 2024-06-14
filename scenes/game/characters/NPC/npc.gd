extends Character

const WANDER_CIRCLE_RADIUS : int = 8
const WANDER_RANDOMNESS : float = 0.2

var wander_angle : float = 0

@export var wandering : bool = true

func wander_steering() -> Vector2:
	wander_angle = randf_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	
	var vector_to_circle : Vector2 = velocity.normalized() * MAX_WALK_SPEED
	var desired_velocity : Vector2 = vector_to_circle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	
	return desired_velocity - velocity


@export var enclosure_zone : Rect2 = Rect2(16, 16, 100, 100)

func enclosure_steering() -> Vector2:
	var desired_velocity : Vector2 = Vector2.ZERO
	if position.x < enclosure_zone.position.x:
		desired_velocity.x += 1
	elif position.x > enclosure_zone.position.x + enclosure_zone.size.x:
		desired_velocity.x -= 1
	if position.y < enclosure_zone.position.y:
		desired_velocity.y += 1
	elif position.y > enclosure_zone.position.y + enclosure_zone.size.y:
		desired_velocity.y -= 1
	
	desired_velocity = desired_velocity.normalized() * MAX_WALK_SPEED
	if desired_velocity != Vector2.ZERO:
		wander_angle = desired_velocity.angle()
		return desired_velocity - velocity
	else :
		return Vector2.ZERO

@onready var raycasts = $Raycasts
var avoid_force : int = 1000

func avoid_obstacles_steering() -> Vector2:
	raycasts.rotation = velocity.angle()
	
	for raycast in raycasts.get_children():
		raycast.target_position.x = velocity.length()
		if raycast.is_colliding():
			var obstacle : PhysicsBody2D = raycast.get_collider()
			return (position + velocity - obstacle.position.normalized() * avoid_force)
	
	return Vector2.ZERO


func _physics_process(delta):
	var steering : Vector2 = Vector2.ZERO
	
	if wandering:
		steering += enclosure_steering()
		steering += wander_steering()
	else:
		steering += avoid_obstacles_steering()
	velocity += steering
	move_and_slide()
