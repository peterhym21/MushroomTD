extends CanvasLayer

var is_placing_tower = false
var carried_tower = null
var carried_tower_type = null

onready var node_healthbar = get_node("Base/HealthBar")
onready var node_coins = get_node("Base/BottomBar/Panel/Coins")
onready var node_wavebutton = get_node("Base/WaveButton")
onready var node_towerbuttons = get_node("Base/BottomBar/Panel/TowerContainer")
onready var node_score = get_node("Base/BottomBar2/Panel/Score")
onready var node_wave = get_node("Base/BottomBar2/Panel/Wave")
onready var node_tooltip = get_node("Base/Tooltip")
onready var pause_menu = get_node("Base/PauseMenu")

func _ready():
	set_process_unhandled_input(true)
	update_coins()
	update_health()
	
	for button in node_towerbuttons.get_children():
		if button extends Button:
			button.connect("pressed", self, "_on_tower_button_pressed", [button])

func lock():
	node_wavebutton.hide()
	for button in node_towerbuttons.get_children():
		if button extends Button:
			button.set_disabled(true)

func unlock():
	var wave = get_parent().level.current_wave
	var wave_total = get_parent().level.WAVE_TOTAL
	if wave + 1 <= wave_total:
		node_wavebutton.show()
	
	for button in node_towerbuttons.get_children():
		if button extends Button:
			button.set_disabled(false)

func _unhandled_input(event):
	#if event.is_action_pressed("ui_cancel"):
	if event.is_action_pressed("ui_right"):
		pause_menu.popup()
		get_tree().set_input_as_handled()
	
	if event.type == InputEvent.KEY and event.pressed and not event.echo:
		if event.scancode == KEY_1:
			start_carry_tower(node_towerbuttons.get_child(0).TOWER_SCENE)
		elif event.scancode == KEY_2:
			start_carry_tower(node_towerbuttons.get_child(1).TOWER_SCENE)
		elif event.scancode == KEY_3:
			start_carry_tower(node_towerbuttons.get_child(2).TOWER_SCENE)
		elif event.scancode == KEY_4:
			start_carry_tower(node_towerbuttons.get_child(3).TOWER_SCENE)
		elif event.scancode == KEY_5:
			start_carry_tower(node_towerbuttons.get_child(4).TOWER_SCENE)
	
	if is_placing_tower:
		if event.type == InputEvent.MOUSE_MOTION:
			var pos = get_parent().level.snap_to_map(get_parent().get_global_mouse_pos())
			carried_tower.set_pos(pos)
		
		if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
			if event.button_index == BUTTON_LEFT:
				if get_parent().coins - carried_tower.COST >= 0:
					get_parent().level.add_tower(carried_tower)
					get_tree().set_input_as_handled()
				
			elif event.button_index == BUTTON_RIGHT:
				stop_placing_tower()

func start_carry_tower(tower_scene):
	if is_placing_tower:
		stop_placing_tower()
	
	carried_tower = tower_scene.instance()
	carried_tower.being_carried = true
	if get_parent().coins - carried_tower.COST >= 0:
		is_placing_tower = true
		carried_tower.set_pos(get_parent().level.snap_to_map(get_parent().get_global_mouse_pos()))
		get_parent().level.objects.add_child(carried_tower)
		get_parent().level.tilemap.get_node("Draw").set_draw_outlines(true)
		
		update_coins()
	else:
		carried_tower.free()

func stop_placing_tower():
	is_placing_tower = false
	carried_tower.queue_free()
	get_tree().set_input_as_handled()
	
	get_parent().level.tilemap.get_node("Draw").set_draw_outlines(false)
	update_coins()

func _on_WaveButton_pressed():
	globalsamples.play("button")
	if is_placing_tower:
		stop_placing_tower()
	
	util.get_main().level.spawn_next_wave()

func check_can_wave_start():
	var can_start_wave = get_parent().get_node("Level").can_start_wave()
	node_wavebutton.set_disabled(not can_start_wave)

func show_tooltip(button):
	var pos = button.get_global_pos() - node_tooltip.get_size() + Vector2(button.get_size().x, 0)
	node_tooltip.set_pos(pos)
	node_tooltip.get_node("Label").set_text(button.tooltip_text)
	get_node("AnimTooltip").play("tooltip_show")

func hide_tooltip():
	get_node("AnimTooltip").play("tooltip_hide")

func update_score():
	node_score.set_text("Score: %03d" % get_parent().score)

func update_wave():
	var wave = get_parent().level.current_wave
	var wave_total = get_parent().level.WAVE_TOTAL
	if wave + 1 <= wave_total:
		node_wave.set_text("Wave: %d/%d" % [wave + 1, wave_total])
	else:
		node_wave.set_text("Finished!")

func update_coins():
	var coins = get_parent().coins
	if is_placing_tower:
		node_coins.set_text("Coins: %03d - %d" % [coins, carried_tower.COST])
	else:
		node_coins.set_text("Coins: %03d" % coins)

func update_health():
	var curhp = get_parent().player_health
	var maxhp = get_parent().PLAYER_MAX_HEALTH
	node_healthbar.set_value((float(curhp) / maxhp) * 100)

func _on_tower_button_pressed(button):
	globalsamples.play("button")
	start_carry_tower(button.TOWER_SCENE)
