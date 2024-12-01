@tool
extends Control
class_name BaseReticle
## This is the base version of the reticle this can be / 
## should be overridden if attempting to make a unique reticle for a weapon

func _draw():
	draw_circle(Vector2.ZERO, 4, Color.DIM_GRAY)
	draw_circle(Vector2.ZERO, 3, Color.WHITE)
	
	#right
	draw_line(Vector2(16,0), Vector2(16+8,0), Color.WHITE, 2 )
	#left
	draw_line(Vector2(-16,0), Vector2(-16-8,0), Color.WHITE, 2 )
	#up
	draw_line(Vector2(0,-16), Vector2(0,-16-8), Color.WHITE, 2 )
	#down
	draw_line(Vector2(0,16), Vector2(0,16+8), Color.WHITE, 2 )
