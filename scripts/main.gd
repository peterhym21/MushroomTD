extends Node2D

# TODO:
#	Done?

var level

enum {STATE_BUILD, STATE_WAVE, STATE_WIN, STATE_LOSE}
var state = STATE_BUILD setget set_state

const PLAYER_MAX_HEALTH = 100
var player_health = PLAYER_MAX_HEALTH

var coins = 200
var score = 0

func _ready():
	# load level
	level = loader.current_level.instance()
	add_child(level)

func set_state(_state):
	state = _state
	if state == STATE_BUILD:
		get_node("HUD").unlock()
		get_node("HUD").update_wave()
	elif state == STATE_WAVE:
		get_node("HUD").lock()
	elif state == STATE_WIN:
		get_node("HUD").update_wave()
		get_node("HUD").pause_menu.set_win()
		get_node("HUD").pause_menu.popup()
	elif state == STATE_LOSE:
		level.set_lose()
		get_node("HUD").update_wave()
		get_node("HUD").pause_menu.set_lose()
		get_node("HUD").pause_menu.popup()
		

func add_score(amnt):
	score += amnt
	get_node("HUD").update_score()

func add_coins(amnt):
	coins += amnt
	get_node("HUD").update_coins()

func take_damage(amnt):
	player_health -= amnt
	get_node("HUD").update_health()
	
	if player_health <= 0:
		set_state(STATE_LOSE)
