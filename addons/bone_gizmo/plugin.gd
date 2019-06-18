tool
extends EditorPlugin

var dock

func _enter_tree():
	add_custom_type("BoneGizmo", "Spatial", preload("bone_gizmo_node.gd"), preload("icon.png"))
	dock = preload("res://addons/bone_gizmo/dock.tscn").instance()
	add_control_to_dock( DOCK_SLOT_LEFT_UL, dock)

func _exit_tree():
	remove_custom_type("BoneGizmo")
	remove_control_from_docks( dock ) # Remove the dock
	dock.free() # Erase the control from the memory