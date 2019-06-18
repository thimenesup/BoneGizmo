tool
extends Spatial

var run = false

#All paths are must be relative to the node (BoneGizmo)
export(String) var skeleton_path = "../Armature"
export(String) var edit_bone = ""
export(String) var animation_path = "../AnimationPlayer"

var skeleton
var bone_index

func _process(delta):
	if run:
		if not edit_bone == "" and not skeleton_path == "":
			skeleton = get_node(skeleton_path)
			bone_index = skeleton.find_bone(edit_bone)
			skeleton.set_bone_pose(bone_index,transform)



func create_tracks():
	var skeleton_node = get_node(skeleton_path)
	var animation_node = get_node(animation_path)
	var animation = animation_node.get_animation(animation_node.assigned_animation)
	print(animation_node.current_animation)
	for i in range(skeleton_node.get_bone_count()):
		animation.add_track(Animation.TYPE_TRANSFORM,i)
		animation.track_set_path(i,skeleton_path + ":" + skeleton_node.get_bone_name(i))

# This will override all the bone poses in the track with the current ones
func insert_key():
	var skeleton_node = get_node(skeleton_path) as Skeleton
	var animation_node = get_node(animation_path) as AnimationPlayer
	var animation = animation_node.get_animation(animation_node.assigned_animation)
	for i in skeleton_node.get_bone_count():
		var bone_name = skeleton_node.get_bone_name(i)
		var bone_pose = skeleton_node.get_bone_pose(i)
		var bone_track = animation.find_track(NodePath(skeleton_node.name + ':' + bone_name))
		animation.transform_track_insert_key(
			bone_track,
			animation_node.current_animation_position,
			bone_pose.origin,
			Quat(bone_pose.basis),
			bone_pose.basis.get_scale()
		)
