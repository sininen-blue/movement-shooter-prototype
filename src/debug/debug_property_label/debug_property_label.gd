class_name DebugPropertyLabel
extends Label

@export var target: Node
@export var property: String
@export var is_function: bool

func _process(_delta: float) -> void:
	if target == null:
		return
	
	
	var prompt: String = property.to_pascal_case() + ": "
	
	if is_function:
		if target.has_method(property):
			prompt += str(target.call(property))
		else:
			prompt += "Can't find function"
	else:
		if property in target:
			prompt += property.to_pascal_case() + ": " + str(target.get(property))
		else:
			prompt += "Can't find property"
	
	self.text = prompt
