tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BoneGizmo", "Spatial", preload("bone_gizmo_node.gd"), preload("bone_gizmo.png"))

func _exit_tree():
	remove_custom_type("BoneGizmo")
