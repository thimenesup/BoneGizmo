# New Workflow Idea
# -----------------
# Only enable bone gizmo dock when
# - bone has been chosen
# - BoneGizmo node is selected
# - BoneGizmo AnimationPlayer is not playing/stop when selected
# Auto "Run Gizmo" when dock is enabled
# Use edit_bone associated with BoneGizmo node.
# - You can have multiple BoneGizmos
# - Selecting a BoneGizmo activates it.
tool
extends EditorPlugin

var dock
var bone_gizmo

func _enter_tree():

	# Load resources only when entering tree.
	# Has the additional effect of being reloadable after script changes.
	# You do not not need to restart editor.
	var base_dir = get_script().get_path().get_base_dir()
	var dock_scene = load(base_dir.plus_file("dock.tscn"))
	var icon = load(base_dir.plus_file("icon.png"))

	bone_gizmo = load(base_dir.plus_file("bone_gizmo.gd"))
	dock = dock_scene.instance()

	add_control_to_dock( DOCK_SLOT_LEFT_UL, dock)
	add_custom_type("BoneGizmo", "Spatial", bone_gizmo, icon)
	
	connect("scene_changed", self, "_on_scene_changed")

func _exit_tree():
	disconnect("scene_changed", self, "_on_scene_changed")
	remove_custom_type("BoneGizmo")
	remove_control_from_docks( dock ) # Remove the dock
	dock.free() # Erase the control from the memory
	bone_gizmo = null

func _on_scene_changed(scene):
	if scene == null:
		dock.gizmo = null

func handles(object: Object) -> bool:
	if object is bone_gizmo:
		dock.gizmo = object
		return true
	else:
		dock.gizmo = null
		return false