tool
extends Spatial


export(bool) var reset = false
export(bool) var run = false
export(String) var skeleton_path = "../Armature"
export(String) var edit_bone = ""
export(String) var animation_path = ""
export(int) var idx = 0
export(float) var time = 1

var skeleton
var bone

func _process(delta):
	if reset:
		set_translation(Vector3(0,0,0))
		set_rotation(Vector3(0,0,0))
		set_scale(Vector3(1,1,1))
		reset = false

	if run:
		if not edit_bone == "" and not skeleton_path == "":
			skeleton = get_node(skeleton_path)
			bone = skeleton.find_bone(edit_bone)
			skeleton.set_bone_pose(bone,get_transform())
	if Input.is_key_pressed(KEY_SPACE):
		insert_key()

func insert_key():
	print("=== BONE GIZMO: INSERT KEY ===")
	var rot = Quat(skeleton.get_bone_pose(bone).basis)
	var animation = get_node(animation_path).get_animation(get_node(animation_path).get_current_animation())
	animation.transform_track_insert_key(idx,time,skeleton.get_bone_pose(bone).origin,rot,skeleton.get_bone_pose(bone).basis.z)

func _ready():
	set_process(true)