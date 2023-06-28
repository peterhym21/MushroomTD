extends Area2D

export var MAX_HEALTH = 60
export var DAMAGE = 5
export var SPEED = 32
export var COINS = 10

var enemydeath_scene = preload("res://scenes/effects/enemydeath.tscn")

var path
var path_index = 1

var velocity = Vector2()
onready var ACCEL = SPEED / 4

onready var health = MAX_HEALTH
var is_dead = false

var effects = []
var speed_multiplier = 1

var anim = ""
var facing_right = true setget set_facing_right

var hurt_flash = 0
const HURT_DURATION = 0.2

signal death

func _ready():
	add_to_group(global.GROUP_ENEMY)
	
	get_node("Sprite").set_material(get_node("Sprite").get_material().duplicate())
	
	set_fixed_process(true)
	set_process(true)

func _process(delta):
	if hurt_flash > 0:
		hurt_flash = max(hurt_flash - delta, 0)
		get_node("Sprite").get_material().set_shader_param("HurtScale", hurt_flash / HURT_DURATION)

func _fixed_process(delta):
	if path.size() > 0:
		var target_pos = util.get_main().level.map_to_world(path[path_index])
		var movement = (target_pos - get_pos()).normalized() * SPEED * speed_multiplier
		
		velocity = velocity.linear_interpolate(movement, ACCEL * delta)
		set_pos(get_pos() + velocity * delta)
		
		if (target_pos - get_pos()).length_squared() < 1:
			if path_index < path.size() - 1:
				path_index += 1
			else:
				queue_free()
		
		if velocity.y < 0:
			set_anim("walkup")
		else:
			set_anim("walkdown")
		
		if velocity.x < 0:
			set_facing_right(false)
		else:
			set_facing_right(true)

func add_slow(id, amnt):
	effects.append([id, amnt])
	
	if amnt < speed_multiplier:
		speed_multiplier = amnt

func remove_slow(id):
	if is_queued_for_deletion():
		return
	
	var i = effects.size()
	while i > 0:
		i -= 1
		if effects[i][0] == id:
			effects.remove(i)
	
	speed_multiplier = 1
	for e in effects:
		speed_multiplier = min(speed_multiplier, e[1])

func set_anim(new_anim):
	if anim != new_anim:
		anim = new_anim
		get_node("Anim").play(anim)

func set_facing_right(new_facing):
	if facing_right != new_facing:
		facing_right = new_facing
		if facing_right:
			get_node("Sprite").set_scale(Vector2(1, 1))
		else:
			get_node("Sprite").set_scale(Vector2(-1, 1))

func take_damage(amnt):
	get_node("SFX").play("enemy_hurt")
	get_node("SFX").voice_set_pitch_scale(0, rand_range(0.6, 1.0))
	health -= amnt
	
	hurt_flash = HURT_DURATION
	
	if health <= 0 and not is_dead:
		is_dead = true
		emit_signal("death")
		var e = enemydeath_scene.instance()
		e.set_texture(get_node("Sprite").get_texture())
		e.set_pos(get_pos())
		get_parent().add_child(e)
		queue_free()
