tool
extends Control

var gizmo_node = null


func _on_FindGizmo_pressed():
	if not get_tree().get_edited_scene_root().find_node("BoneGizmo",true,false):
		$"Output".set_text("BoneGizmo node not found!")
		gizmo_node = null
	else:
		$"Output".set_text("BoneGizmo node found!")
		gizmo_node = get_tree().get_edited_scene_root().find_node("BoneGizmo",true,false)

func _on_ResetGizmo_pressed():
	if not gizmo_node == null:
		gizmo_node.translation = Vector3(0,0,0)
		gizmo_node.rotation = Vector3(0,0,0)
		gizmo_node.scale = Vector3(1,1,1)
		$"Output".set_text("BoneGizmo reset transform")


func _on_RunGizmo_toggled(button_pressed):
	if not gizmo_node == null:
		gizmo_node.run = button_pressed

func _on_SkeletonPath_text_entered(new_text):
	if not gizmo_node == null:
		gizmo_node.skeleton_path = new_text
		if not gizmo_node.has_node(gizmo_node.skeleton_path):
			$"Output".set_text("Invalid skeleton path")
			return
		$"Output".set_text("Set skeleton path")

func _on_Bone_text_entered(new_text):
	if not gizmo_node == null:
		gizmo_node.edit_bone = new_text
		if gizmo_node.has_node(gizmo_node.skeleton_path):
			if gizmo_node.get_node(gizmo_node.skeleton_path).find_bone(new_text) == -1:
				$"Output".set_text("Invalid bone")
				return
		$"Output".set_text("Set bone")



func _on_AnimationPath_text_entered(new_text):
	if not gizmo_node == null:
		gizmo_node.animation_path = new_text
		if not gizmo_node.has_node(gizmo_node.animation_path):
			$"Output".set_text("Invalid animation path")
			return
		$"Output".set_text("Set animation player path")


func _on_CreateTracks_pressed():
	if not gizmo_node == null:
		if not gizmo_node.has_node(gizmo_node.skeleton_path):
			$"Output".set_text("Invalid skeleton path")
			return
		if not gizmo_node.has_node(gizmo_node.animation_path):
			$"Output".set_text("Invalid animation path")
			return
		gizmo_node.create_tracks()


func _on_InsertKey_pressed():
	if not gizmo_node == null:
		if not gizmo_node.has_node(gizmo_node.skeleton_path):
			$"Output".set_text("Invalid skeleton path")
			return
		if not gizmo_node.has_node(gizmo_node.animation_path):
			$"Output".set_text("Invalid animation path")
			return
		gizmo_node.insert_key()
