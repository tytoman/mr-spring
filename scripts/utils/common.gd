class_name Common extends RefCounted

## Utility functions.

# Convert msec to formatted string like "mm:ss.ff".
static func msec_to_str(msec: int) -> String:
	var sec := msec / 1000.0
	var seconds := fmod(sec, 60)
	var minutes := int(sec / 60)
	return "%02d:%05.2f" % [minutes, seconds]
