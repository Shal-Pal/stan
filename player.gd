extends CharacterBody2D

# Movement settings
@export var base_speed: float = 200.0

# Perspective scaling settings
@export var min_y: float = 100.0  # Top of the screen (farthest from camera)
@export var max_y: float = 500.0  # Bottom of the screen (closest to camera)
@export var min_scale: float = 0.3  # Scale when far away
@export var max_scale: float = 1.5  # Scale when close

func _ready():
	# Initial positioning
	update_scale()

func _physics_process(delta):
	# Get input direction
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):  # W
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):  # S
		input_direction.y += 1
	if Input.is_action_pressed("ui_left"):  # A
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):  # D
		input_direction.x += 1
	
	# Normalize diagonal movement
	input_direction = input_direction.normalized()
	
	# Apply movement
	velocity = input_direction * base_speed
	move_and_slide()
	
	# Update scale based on Y position
	update_scale()
	
	# Keep player within screen bounds
	clamp_position()

func update_scale():
	# Calculate scale based on Y position
	# Higher Y = closer to camera = bigger
	var t = clamp((position.y - min_y) / (max_y - min_y), 0.0, 1.0)
	var new_scale = lerp(min_scale, max_scale, t)
	scale = Vector2(new_scale, new_scale)

func clamp_position():
	# Get viewport size
	var viewport_size = get_viewport_rect().size
	
	# Clamp position to screen bounds
	position.x = clamp(position.x, 0, viewport_size.x)
	position.y = clamp(position.y, min_y, max_y)
