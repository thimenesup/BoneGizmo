tool
extends Control

onready var bone_finder = find_node('bone_finder')
onready var run_gizmo_button = find_node('RunGizmo')

var gizmo setget set_gizmo,get_gizmo
func get_gizmo(): return gizmo
func set_gizmo(new_val):
	if is_instance_valid(gizmo):
		gizmo.running = false
		gizmo.disconnect("path_changed", self, "_on_gizmo_path_changed")
	
	gizmo = new_val
	if gizmo == null:
		$Disabled.visible = true
		run_gizmo_button.pressed = false
		bone_finder.set_skeleton(null)
		bone_finder.set_filter('')
	else:
		$Disabled.visible = false
		bone_finder.set_skeleton(gizmo.get_skeleton())
		bone_finder.set_filter(gizmo.edit_bone_filter)
		run_gizmo_button.pressed = gizmo.can_run()
		gizmo.running = gizmo.can_run()
		gizmo.connect("path_changed", self, "_on_gizmo_path_changed")

func _on_gizmo_path_changed(what):
	if what == "skeleton":
		bone_finder.set_skeleton(gizmo.get_skeleton())
		gizmo.running = gizmo.can_run()

func _on_ResetGizmo_pressed():
	gizmo.reset()
	print("BoneGizmo reset transform")

func _on_RunGizmo_toggled(button_pressed):
	gizmo.allowed_to_run = button_pressed
	gizmo.running = gizmo.can_run()
	print("BoneGizmo running: ", gizmo.running)

func _on_CreateTracks_pressed():
	if check_anim_track_operation():
		gizmo.create_tracks()

func _on_InsertKey_pressed():
	if check_anim_track_operation():
		gizmo.insert_key()

func check_anim_track_operation() -> bool:
	var passed = true
	if gizmo.get_skeleton() == null:
		print("BoneGizmo Invalid skeleton path")
		passed = false
	if gizmo.get_animation_player() == null:
		print("BoneGizmo Invalid animation path")
		passed = false
	return passed

func _on_bone_finder_bone_selected(this, name, id) -> void:
	gizmo.running = false
	gizmo.edit_bone = name
	gizmo.edit_bone_filter = this.filter
	gizmo.running = gizmo.can_run()
