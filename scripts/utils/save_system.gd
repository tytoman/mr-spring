class_name SaveSystem extends RefCounted

## Easily save and load data.

# Previous data format for compatibility.
const OBSOLETED_FILE_PATH: String = "user://save_file.save"
# Encrypted Data Files.
const SAVE_FILE_PATH: String = "user://data_file.save"


static func save_dict(dict: Dictionary) -> void:
	var save_file := FileAccess.open_encrypted_with_pass(SAVE_FILE_PATH, FileAccess.WRITE, Env.PASSWORD)
	var json_string := JSON.stringify(dict)
	save_file.store_line(json_string)
	save_file.close()


static func load_dict() -> Dictionary:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return {}
	
	var load_file := FileAccess.open_encrypted_with_pass(SAVE_FILE_PATH, FileAccess.READ, Env.PASSWORD)
	var json := JSON.new()
	var parse_result := json.parse(load_file.get_as_text())
	if parse_result != OK:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", load_file.get_as_text(), " at line ", json.get_error_line())
		return {}
	
	load_file.close()
	
	if not json.data is Dictionary:
		return {}
	
	return json.data


static func save_with_key(key: Variant, value: Variant) -> void:
	var dict := SaveSystem.load_dict()
	dict[key] = value
	save_dict(dict)


static func load_with_key(key: Variant, default_value: Variant = null) -> Variant:
	var dict := SaveSystem.load_dict()
	if not dict.has(key):
		return default_value
	return dict[key]


static func delete_with_key(key: Variant) -> void:
	var dict := SaveSystem.load_dict()
	dict.erase(key)
	save_dict(dict)


static func string_to_vector2(v_string: String) -> Vector2:
	var s := v_string.replace("(", "").replace(")", "")
	var x := float(s.get_slice(",", 0))
	var y := float(s.get_slice(",", 1))
	return Vector2(x, y)


## For compatibility.

static func load_dict_obsoleted() -> Dictionary:
	if not FileAccess.file_exists(OBSOLETED_FILE_PATH):
		return {}
	
	var load_file := FileAccess.open(OBSOLETED_FILE_PATH, FileAccess.READ)
	var json := JSON.new()
	var parse_result := json.parse(load_file.get_as_text())
	if parse_result != OK:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", load_file.get_as_text(), " at line ", json.get_error_line())
		return {}
	
	load_file.close()
	
	if not json.data is Dictionary:
		return {}
	
	return json.data


static func load_with_key_obsoleted(key: Variant, default_value: Variant = null) -> Variant:
	var dict := SaveSystem.load_dict_obsoleted()
	if not dict.has(key):
		return default_value
	return dict[key]
