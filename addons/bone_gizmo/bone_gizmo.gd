tool
extends Spatial

signal path_changed(what)

# All paths are must be relative to the node (BoneGizmo)
export(NodePath) var skeleton_path = @"../Skeleton" setget set_skeleton_path
func set_skeleton_path(new_val):
	if new_val == skeleton_path:
		return
	skeleton_path = new_val
	emit_signal("path_changed", "skeleton")

export(NodePath) var animation_path = @"../AnimationPlayer" setget set_animation_path
func set_animation_path(new_val):
	if new_val == animation_path:
		return
	animation_path = new_val
	emit_signal("path_changed", "animation")

var running: bool setget set_running,get_running
func get_running() -> bool: return running
func set_running(new_val: bool) -> void:
	if new_val and not running:
		global_transform = get_skeleton().get_bone_global_pose(get_edit_bone_index())
		set_process(true)
	elif not new_val:
		set_process(false)
	running = new_val

var edit_bone_filter setget set_edit_bone_filter,get_edit_bone_filter
func get_edit_bone_filter():
	return get_meta("edit_bone_filter") if has_meta("edit_bone_filter") else ""
func set_edit_bone_filter(new_val):
	set_meta("edit_bone_filter", new_val)

var edit_bone = ""
var allowed_to_run = false

func _ready():
	set_running(false)

func _process(delta):
	var skeleton = get_skeleton()
	var bone_index = get_edit_bone_index()
	skeleton.set_bone_global_pose(bone_index, global_transform)

func reset() -> void:
	transform = Transform()

func can_run() -> bool:
	return allowed_to_run and (get_skeleton() != null) and (get_edit_bone_index() != -1)

func get_animation_player() -> AnimationPlayer:
	return get_node(animation_path) as AnimationPlayer

func get_skeleton() -> Skeleton:
	return get_node(skeleton_path) as Skeleton

func get_edit_bone_index() -> int:
	return get_skeleton().find_bone(edit_bone)

func create_tracks():
	var skel = get_skeleton()
	var anim_player = get_animation_player()
	var anim = anim_player.get_animation(anim_player.assigned_animation)
	for i in skel.get_bone_count():
		anim.add_track(Animation.TYPE_TRANSFORM,i)
		anim.track_set_path(i,skeleton_path + ":" + skel.get_bone_name(i))

# This will override all the bone poses in the track with the current ones
func insert_key():
	var skel = get_skeleton()
	var anim_player = get_animation_player()
	var anim = anim_player.get_animation(anim_player.assigned_animation)
	for i in skel.get_bone_count():
		var bone_name = skel.get_bone_name(i)
		var bone_pose = skel.get_bone_pose(i)
		var bone_track = anim.find_track(NodePath(skel.name + ':' + bone_name))
		anim.transform_track_insert_key(
			bone_track,
			anim_player.current_animation_position,
			bone_pose.origin,
			Quat(bone_pose.basis),
			bone_pose.basis.get_scale()
		)