extends Character

@onready var raycasts = $Raycasts
@onready var state_timer : Timer = $StateTimer

var last_state : State

func _ready():
	super._ready()

func _physics_process(delta):
	raycasts.rotation = velocity.angle()
	look_direction = raycasts.rotation
