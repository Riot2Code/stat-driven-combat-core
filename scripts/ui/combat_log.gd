extends RichTextLabel
class_name CombatLog

@export var max_lines := 80

func log_line(text: String) -> void:
	# Add line
	append_text(text + "\n")
	
	# Trim old lines (simple + effective)
	var lines := get_parsed_text().split("\n")
	if lines.size() > max_lines:
		var trimmed := "\n".join(lines.slice(lines.size()- max_lines, lines.size()))
		clear()
		append_text(trimmed)
		
	scroll_to_line(get_line_count())
