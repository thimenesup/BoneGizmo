tool
extends Control

class BoneGizmoProxy:
	static func make_proxy(node: Node) -> BoneGizmoProxy:
		if node == null:
			return NullBoneGizmoProxy.new()
		return BoneGizmoProxy.new(node)
	
	var _node: Node
	
	func _init(node: Node) -> void:
		_node = node
	
	var edit_bone: String setget set_eb,get_eb
	var running: bool setget set_running,get_running
	func set_eb(eb): _node.edit_bone = eb
	func get_eb(): return _node.edit_bone
	func set_running(new_val: bool) -> void: _node.set_running(new_val)
	func get_running() -> bool: return _node.running
	func can_run() -> bool: return _node.can_run()
	func get_animation_player() -> AnimationPlayer: return _node.get_animation_player()
	func get_skeleton() -> Skeleton: return _node.get_skeleton()
	func get_edit_bone_index() -> int: return _node.get_edit_bone_index()
	func create_tracks(): _node.create_tracks()
	func insert_key(): _node.insert_key()
	func reset(): _node.reset()
	func on_tree_exit_sig(target, callback):
		if not _node.is_connected("tree_exited", target, callback):
			_node.connect("tree_exited", target, callback)
	func off_tree_exit_sig(target, callback): _node.disconnect("tree_exited", target, callback)

class NullBoneGizmoProxy extends BoneGizmoProxy:
	func _init().(null): pass
	func set_eb(eb): pass
	func get_eb(): return ''
	func set_running(new_val: bool) -> void: pass
	func get_running() -> bool: return false
	func can_run() -> bool: return false
	func get_animation_player() -> AnimationPlayer: return null
	func get_skeleton() -> Skeleton: return null
	func get_edit_bone_index() -> int: return -1
	func create_tracks(): pass
	func insert_key(): pass
	func reset(): pass
	func on_tree_exit_sig(target, callback): pass
	func off_tree_exit_sig(target, callback): pass

var proxy: BoneGizmoProxy = NullBoneGizmoProxy.new()
onready var bone_finder = find_node('bone_finder')

func find_gizmo():
	proxy = NullBoneGizmoProxy.new()
	
	var scene_root = get_tree().get_edited_scene_root()
	if scene_root != null:
		proxy = BoneGizmoProxy.make_proxy(scene_root.find_node("BoneGizmo", true, false))
	
	if proxy is NullBoneGizmoProxy:
		print("BoneGizmo node not found!")
	else:
		print("BoneGizmo node found!")
	
	proxy.on_tree_exit_sig(self, '_on_bone_gizmo_exited_tree')
	bone_finder.set_skeleton(proxy.get_skeleton())

func _on_bone_gizmo_exited_tree():
	proxy.off_tree_exit_sig(self, '_on_bone_gizmo_exited_tree')
	find_gizmo()

func _on_ResetGizmo_pressed():
	proxy.reset()
	print("BoneGizmo reset transform")

func _on_RunGizmo_toggled(button_pressed):
	proxy.running = button_pressed
	print("BoneGizmo running: ", proxy.running)

func _on_CreateTracks_pressed():
	if check_anim_track_operation():
		proxy.create_tracks()

func _on_InsertKey_pressed():
	if check_anim_track_operation():
		proxy.insert_key()

func check_anim_track_operation() -> bool:
	var passed = true
	if proxy.get_skeleton() == null:
		print("BoneGizmo Invalid skeleton path")
		passed = false
	if proxy.get_animation_player() == null:
		print("BoneGizmo Invalid animation path")
		passed = false
	return passed

func _on_bone_finder_bone_selected(this, name, id) -> void:
	proxy.edit_bone = name
