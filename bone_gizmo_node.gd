tool
extends Spatial


export(bool) var run = false
export(String) var skeleton_path = "../Armature"
export(String) var edit_bone = ""
export(String) var animation_path = ""
export(float) var time = 1

var idx = 0
var skeleton
var bone

func _process(delta):
	if run:
		if not edit_bone == "" and not skeleton_path == "":
			skeleton = get_node(skeleton_path)
			bone = skeleton.find_bone(edit_bone)
			idx = bone
			skeleton.set_bone_pose(bone,get_transform())
	if Input.is_key_pressed(KEY_1):
		insert_key()
	if Input.is_key_pressed(KEY_2):
		create_tracks()

func create_tracks():
	print("=== BONE GIZMO: CREATING TRACKS ===")
	var animation = get_node(animation_path).get_animation(get_node(animation_path).get_current_animation())
	for i in range(skeleton.get_bone_count()):
		animation.add_track(Animation.TYPE_TRANSFORM,i)
		animation.track_set_path(i,"Armature:" + skeleton.get_bone_name(i)) #Change armature to your actual skeleton path in animation player

func insert_key():
	print("=== BONE GIZMO: INSERT KEY ===")
	var rot = Quat(skeleton.get_bone_pose(bone).basis)
	var animation = get_node(animation_path).get_animation(get_node(animation_path).get_current_animation())
	animation.transform_track_insert_key(idx,time,skeleton.get_bone_pose(bone).origin,rot,skeleton.get_bone_pose(bone).basis.z)

func _ready():
	set_process(true)