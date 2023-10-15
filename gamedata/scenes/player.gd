extends KinematicBody2D

const speed_multiplier = 300
const damage_multiplier = 7.5

var direction
var velocity = Vector2(0, 0)

var air = 100
var hp = 100

func _process(delta):
	# Obtain 2-axis direction of movement from input keys
	direction = Vector2(0, 0)
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	
	# Normalize it to get the direction of movement without vector length
	direction.normalized()
	
	# Apply drag/inertia to the player body's velocity
	velocity += direction * 0.01
	if direction.y == 0:
		velocity.y *= 0.95
	if direction.x == 0:
		velocity.x *= 0.95
	
	# Test for player-environment collisions
	var collision = move_and_collide(velocity * speed_multiplier * delta)
	# If collision returns different from null, decrease health accordingly, then bounce player away from environment
	if collision:
		hp -= (abs(velocity.x) + abs(velocity.y)) * damage_multiplier
		velocity *= -0.5

	# Update the air bar according to player position (above/below water)
	if self.position.y < 1020:
		if air < 100:
			air += 10 * delta
	else:
		if air > 0:
			air -= 2.5 * delta
		else:
			hp -= damage_multiplier * delta
	
	# Create an artificial ceiling so that the player object cannot go above waterline on the map
	if self.position.y < 950:
		if velocity.y < 0:
			velocity.y += 0.5
			velocity.y *= 0.4