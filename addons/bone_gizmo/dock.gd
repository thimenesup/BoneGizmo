tool
extends Control

var gizmo_node = null
onready var bone_finder = find_node('bone_finder')


func _on_FindGizmo_pressed():
	if not get_tree().get_edited_scene_root().find_node("BoneGizmo",true,false):
		print("BoneGizmo node not found!")
		gizmo_node = null
	else:
		print("BoneGizmo node found!")
		gizmo_node = get_tree().get_edited_scene_root().find_node("BoneGizmo",true,false)
		bone_finder.set_skeleton(gizmo_node.get_node(gizmo_node.skeleton_path))

func _on_ResetGizmo_pressed():
	if not gizmo_node == null:
		gizmo_node.translation = Vector3(0,0,0)
		gizmo_node.rotation = Vector3(0,0,0)
		gizmo_node.scale = Vector3(1,1,1)
		print("BoneGizmo reset transform")

func _on_RunGizmo_toggled(button_pressed):
	if not gizmo_node == null:
		gizmo_node.run = button_pressed

#func _on_SkeletonPath_text_entered(new_text):
#	if not gizmo_node == null:
#		gizmo_node.skeleton_path = new_text
#		if not gizmo_node.has_node(gizmo_node.skeleton_path):
#			print("BoneGizmo Invalid skeleton path")
#			return
#		print("BoneGizmo Set skeleton path")

func _on_Bone_text_entered(new_text):
	if not gizmo_node == null:
		gizmo_node.edit_bone = new_text
		if gizmo_node.has_node(gizmo_node.skeleton_path):
			if gizmo_node.get_node(gizmo_node.skeleton_path).find_bone(new_text) == -1:
				print("BoneGizmo Invalid bone")
				return
		print("BoneGizmo Set bone")

#func _on_AnimationPath_text_entered(new_text):
#	if not gizmo_node == null:
#		gizmo_node.animation_path = new_text
#		if not gizmo_node.has_node(gizmo_node.animation_path):
#			print("BoneGizmo Invalid animation path")
#			return
#		print("BoneGizmo Set animation player path")


func _on_CreateTracks_pressed():
	if not gizmo_node == null:
		if not gizmo_node.has_node(gizmo_node.skeleton_path):
			print("BoneGizmo Invalid skeleton path")
			return
		if not gizmo_node.has_node(gizmo_node.animation_path):
			print("BoneGizmo Invalid animation path")
			return
		gizmo_node.create_tracks()


func _on_InsertKey_pressed():
	if not gizmo_node == null:
		if not gizmo_node.has_node(gizmo_node.skeleton_path):
			print("BoneGizmo Invalid skeleton path")
			return
		if not gizmo_node.has_node(gizmo_node.animation_path):
			print("BoneGizmo Invalid animation path")
			return
		gizmo_node.insert_key()

func _on_bone_finder_bone_selected(this, name, id) -> void:
	_on_Bone_text_entered(name)