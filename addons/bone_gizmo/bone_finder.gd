tool
extends VBoxContainer

signal bone_selected(this, name, id)

onready var _bone_list: ItemList = $bone_list as ItemList

var _skel: Skeleton
var _filter := ''

func set_skeleton(skeleton: Skeleton):
	if skeleton == null:
		_bone_list.clear()
		_skel = null
		return
	if _skel != skeleton:
		_skel = skeleton
		refresh_bone_list()

func refresh_bone_list():
	if _skel == null:
		return
	_bone_list.clear()
	for id in _skel.get_bone_count():
		var name = _skel.get_bone_name(id)
		if name.findn(_filter) > -1:
			_bone_list.add_item(name)
			_bone_list.set_item_metadata(_bone_list.get_item_count() - 1, {name = name, id = id})

func _on_filter_text_changed(new_text: String) -> void:
	_filter = new_text
	refresh_bone_list()

func _on_bone_list_item_activated(index: int) -> void:
	var meta = _bone_list.get_item_metadata(index)
	emit_signal("bone_selected", self, meta.name, meta.id)
