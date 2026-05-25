extends Node3D

@onready var door = $EndWall3
@onready var door2 = $EndWall4
@onready var door3 = $EndWall5
@onready var door4 = $EndWall6
@onready var door5 = $EndWall7
@onready var door6 = $EndWall8
@onready var Enter = $EnteranceWall
@onready var player = $CharacterBody3D
@onready var scare1 = $Scare1
@onready var Heartbeat = $Heartbeat
@onready var trigger1 = $Trigger1
@onready var lamp1 = $lamp1
@onready var lamp2 = $lamp2
@onready var lamp3 = $lamp3
@onready var lamp4 = $lamp4
@onready var lamp5 = $lamp5
@onready var lamp6 = $lamp6
@onready var overlay = $CharacterBody3D/Neck/Camera3D/CanvasLayer/DarkOverlay
@onready var wall_left = $WallL
@onready var wall_right = $WallR
@onready var ceiling = $Ceiling
@onready var classroom_door = $ClassroomDoor
@onready var text = $MeshInstance3D2
@onready var classroom_trigger = $ClassroomDoor/Area3D

var move_amount := 30
var all_lights = []
var all_endwalls = []

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	all_lights = [lamp1, lamp2, lamp3, lamp4, lamp5, lamp6]
	all_endwalls = [door, door2, door3, door4, door5, door6]
	overlay.color.a = 0.0
	classroom_door.visible = false
	text.visible=false
	trigger1.body_entered.connect(_on_trigger1_entered)
	classroom_trigger.body_entered.connect(_on_classroom_entered)

func _on_trigger1_entered(body):
	if body is CharacterBody3D:
		run_sequence()

func _on_classroom_entered(body):
	if body is CharacterBody3D:
		print("MOVED")
		get_tree().change_scene_to_file("res://scenes/lassroom.tscn")

func run_sequence():
	print("Moving endwalls: ", all_endwalls)
	turn_off_all_lights()
	scare1.play()
	Heartbeat.play()
	overlay.color.a = 1.0
	classroom_door.visible = true
	text.visible=true
	for wall in all_endwalls:
		wall.position.z += move_amount
	shrink_room()
	await get_tree().create_timer(2.5).timeout
	await fade_to_clear()
	await get_tree().create_timer(0.1).timeout
	flicker_all_lights_on()

func shrink_room():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(Enter, "position:z", Enter.position.z + 0.6, 2.0)
	tween.tween_property(wall_left, "position:x", wall_left.position.x + 0.6, 2.0)
	tween.tween_property(wall_right, "position:x", wall_right.position.x - 0.6, 2.0)
	tween.tween_property(ceiling, "position:y", ceiling.position.y - 0.4, 2.0)

func fade_to_clear():
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, 0.8)
	await tween.finished

func turn_off_all_lights():
	for lamp in all_lights:
		for child in lamp.get_children():
			if child is OmniLight3D:
				child.visible = false

func flicker_all_lights_on():
	for i in range(6):
		await get_tree().create_timer(0.07).timeout
		toggle_all_lights()
	turn_on_all_lights()

func toggle_all_lights():
	for lamp in all_lights:
		for child in lamp.get_children():
			if child is OmniLight3D:
				child.visible = !child.visible

func turn_on_all_lights():
	for lamp in all_lights:
		for child in lamp.get_children():
			if child is OmniLight3D:
				child.visible = true


func _on_door_trigger_body_entered(body):
	if body is CharacterBody3D:
		print("ACTIVATED!")
		get_tree().change_scene_to_file("res://scenes/Classroom.tscn")
