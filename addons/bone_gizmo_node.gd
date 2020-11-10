tool
extends Spatial

var run = false

#All paths are must be relative to the node (BoneGizmo)
export(NodePath) var skeleton_path
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


func insert_key(): #This will override all the bone poses in the track with the current ones
	var skeleton_node = get_node(skeleton_path)
	var animation_node = get_node(animation_path)
	var animation = animation_node.get_animation(animation_node.assigned_animation)
	for i in range(skeleton_node.get_bone_count()):
		var bone_tr = skeleton_node.get_bone_pose(i)
		var rot = Quat(bone_tr.basis)
		animation.transform_track_insert_key(i,animation_node.current_animation_position,bone_tr.origin,rot,bone_tr.basis.get_scale())
