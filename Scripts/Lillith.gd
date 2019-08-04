extends KinematicBody2D

var WALK_SPEED: int = -50
var temp_speed: int = 0

var attacking: bool = false;

var velocity: Vector2 = Vector2.ZERO;

onready var anim_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta):
	if !$RayCast2D.is_colliding() or is_on_wall():
		WALK_SPEED *= -1
		if sign(WALK_SPEED) == 1:
			anim_player.play("WalkRight")
			#anim_player.current_animation_position = 2.2
			anim_player.set_speed_scale(-2.5)
		elif sign(WALK_SPEED) == -1:
			anim_player.play("WalkLeft")
			#anim_player.current_animation_position = 2.2
			anim_player.set_speed_scale(-2.5)
	velocity.x = WALK_SPEED
	
	velocity = move_and_slide(velocity, Vector2(0, 1))
	
	if sign(WALK_SPEED) == 1:
		anim_player.play("WalkRight")
	elif sign(WALK_SPEED) == -1:
		anim_player.play("WalkLeft")
		
	if !$RayCast2D.is_colliding():
		if sign(WALK_SPEED) == 1:
			anim_player.play("IdleRight");
		elif sign(WALK_SPEED) == -1:
			anim_player.play("IdleLeft");
		yield(get_tree().create_timer(1.0), "timeout")
		WALK_SPEED *= -1;
		
	velocity.x = WALK_SPEED;
	
	velocity = move_and_slide(velocity, Vector2(0, 1))


func _on_FrontVicinityArea_area_entered(area):
	if area.name == "HitArea":
		WALK_SPEED = 50
		velocity = move_and_slide(velocity, area.position)
		
	if area.name == "PlayerDetectArea":
		temp_speed = WALK_SPEED
		WALK_SPEED = 0
		# get_node("FrontWeapon").show()
		# get_node("FrontWeapon")._on_AnimationPlayer_animation_started("_setup")
		attacking = true;
		anim_player.play("HitRight")
		yield(get_tree().create_timer(1.0), "timeout")
		# get_node("FrontWeapon").hide()
		
		# $Weapon/AnimationPlayer.Play("_setup");
		# $ColorRect3/AnimationPlayer.Play("_setup");


func _on_BackVicinityArea_area_entered(area):
	if area.name == "HitArea":
		WALK_SPEED = -50
		velocity = move_and_slide(velocity, area.position)
		
	if area.name == "PlayerDetectArea":
		temp_speed = WALK_SPEED
		WALK_SPEED = 0
		# get_node("BackWeapon").show()
		# get_node("BackWeapon")._on_AnimationPlayer_animation_started("_setup")
		attacking = true;
		anim_player.play("HitLeft")
		# anim_player.play("IdleLeft")
		yield(get_tree().create_timer(1.0), "timeout")
		WALK_SPEED = temp_speed


func _on_TopVicinityArea_area_entered(area):
	if area.name == "HitArea":
		WALK_SPEED = -50
		velocity = move_and_slide(velocity, area.position)
		
	if area.name == "PlayerDetectArea":
		temp_speed = WALK_SPEED
		WALK_SPEED = 0
		attacking = true;
		anim_player.play("HitUp")
		yield(get_tree().create_timer(1.0), "timeout")


func _on_BottomVicinityArea_area_entered(area):
	if area.name == "HitArea":
		WALK_SPEED = -50
		velocity = move_and_slide(velocity, area.position)
		
	if area.name == "PlayerDetectArea":
		temp_speed = WALK_SPEED
		WALK_SPEED = 0
		anim_player.play("HitDown")
		yield(get_tree().create_timer(3.0), "timeout")


func _check_walking_state() :
	if sign(WALK_SPEED) == 1:
		anim_player.play("WalkRight");
	elif sign(WALK_SPEED) == -1:
		anim_player.play("WalkLeft");
		
func _check_idle_state():
	if sign(WALK_SPEED) == 1:
		anim_player.play("IdleRight");
	elif sign(WALK_SPEED) == -1:
		anim_player.play("IdleLeft");