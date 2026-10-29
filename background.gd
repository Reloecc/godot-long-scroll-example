extends TextureRect


@onready var button :TextureButton = $Button;

var bgTexture :Texture2D = preload("res://color_fg.png");
var tile_size :Vector2 = bgTexture.get_size();
var grid_xnum :int = floor(size.x / tile_size.x);
var xnum :int = 10;
var ynum :int = 3000;
var colors :Dictionary[int, Color] = {};



func _process(_delta :float) -> void:
	var tile_pos :Vector2 = getTilePos(get_local_mouse_position());
	var tile_color :Color = getGeneratedColor(int(tile_pos.x), int(tile_pos.y));
	
	if tile_color != Color(0, 0, 0):
		button.position = tile_pos * tile_size;
		button.modulate = (tile_color.srgb_to_linear() * 2.5).linear_to_srgb();



func getTilePos(from :Vector2) -> Vector2:
	return (from / tile_size).floor() \
		.clamp(Vector2i(0, 0), Vector2i(xnum - 1, ynum - 1));



func _draw() -> void:
	var rect :Rect2 = Rect2(Vector2(0, 0), tile_size);

	for x in range(xnum):
		for y in range(ynum):
			rect.position = Vector2(x, y) * tile_size;
			var color := getGeneratedColor(x, y);
			if color != Color(0, 0, 0):
				draw_texture_rect(bgTexture, rect, false, color);
			
			

func getGeneratedColor(x :int, y :int) -> Color:
	var colorid :int = x + y * ynum;

	if !colors.has(colorid):
		colors[colorid] = Color(randf(), randf(), randf()) if randf() < 0.5 else Color(0, 0, 0);

	return colors[colorid];



func _on_button_pressed() -> void:
	var button_pos :Vector2 = getTilePos(button.position);
	var tile_color :Color = getGeneratedColor(int(button_pos.x), int(button_pos.y));
	
	print("Clicked color: %s" % tile_color);
