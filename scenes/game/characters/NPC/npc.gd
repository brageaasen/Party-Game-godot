extends Character

@onready var raycasts = $Raycasts
@onready var state_timer : Timer = $StateTimer

func _ready():
	state_timer.start()

func _physics_process(delta):
	raycasts.rotation = velocity.angle()
	look_direction = raycasts.rotation
