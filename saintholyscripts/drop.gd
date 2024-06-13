extends StaticBody2D

var first_time = false

func _ready():
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	#if self.is_in_group("bench"):
		#first_time = true
		#self.add_to_group("occupied")
		#self.remove_from_group("free")
		#print("To no bench:"+ self.name,self.is_in_group("bench"))
		#print("To ocupado:",self.is_in_group("occupied"))

func _process(delta):
	if Global.is_dragging:
		visible = true
	else:
		visible = false
		

