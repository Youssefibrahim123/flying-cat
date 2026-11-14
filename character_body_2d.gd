extends CharacterBody2D


const SPEED = 300.0
var JUMP_VELOCITY = -500.0
@onready var win: AudioStreamPlayer2D = $win
@onready var lose: AudioStreamPlayer2D = $loose
@onready var bonus: AudioStreamPlayer2D = $bonus
@onready var jump: AudioStreamPlayer2D = $jump


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("jump_buff"):
		area.queue_free()
		JUMP_VELOCITY = -650
		bonus.play()
	elif area.is_in_group("win"):
		win.play()
	elif area.is_in_group("lose"):
		lose.play() 
		get_tree().reload_current_scene()
