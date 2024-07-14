@tool
class_name SpriteMesh3D extends ArrayMesh

@export var texture : AtlasTexture : set = set_texture
@export_range(0.0, 5.0, 0.01) var pixel_size : float = 1.0 : set = set_size

func set_texture(new_image : AtlasTexture) -> void:
	texture = new_image
	gen_mesh()

func set_size(size : float) -> void:
	pixel_size = size
	gen_mesh()

func gen_mesh():
	clear_surfaces()
	var data : Array
	data.resize(ARRAY_MAX)
	
	var image = texture.get_image() as Image
	var all_positions : Array
	var all_colors : Array
	var surface : SurfaceTool = SurfaceTool.new()
	
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var index_count = 0
	var offset : Vector3
	
	offset = (pixel_size * (Vector3(-image.get_size().x, image.get_size().y, 1.0) / 2))
	
	for x in range(texture.get_size().x):
		for y in range(texture.get_size().y):
			var vertex_color = image.get_pixel(x, y)
			
			if image.get_pixel(x, y).a > 0.0:
				#FRONT and BACK
				
				var front = [
					Vector3(0, 0, 0),
					Vector3(1, 0, 0),
					Vector3(1, 1, 0),
					Vector3(0, 1, 0)
				]
				for i in range(front.size()):
					surface.set_normal(Vector3.FORWARD)
					surface.set_color(vertex_color)
					surface.add_vertex(pixel_size * front[i] + Vector3(x, -y, 0.0) * pixel_size + offset)
				
				surface.add_index(0 + index_count)
				surface.add_index(1 + index_count)
				surface.add_index(2 + index_count)
				surface.add_index(0 + index_count)
				surface.add_index(2 + index_count)
				surface.add_index(3 + index_count)
				
				index_count += 4
				
				var back = [
					Vector3(0, 0, 1.00),
					Vector3(0, 1, 1.00),
					Vector3(1, 1, 1.00),
					Vector3(1, 0, 1.00)
				]
				for i in range(back.size()):
					surface.set_normal(Vector3.BACK)
					surface.set_color(vertex_color)
					surface.add_vertex((pixel_size * back[i] + Vector3(x, -y, 0.0) * pixel_size) + offset)
				
				surface.add_index(0 + index_count)
				surface.add_index(1 + index_count)
				surface.add_index(2 + index_count)
				surface.add_index(0 + index_count)
				surface.add_index(2 + index_count)
				surface.add_index(3 + index_count)
				
				index_count += 4
				
				if x == 0 or (x - 1 >= 0 and image.get_pixel(x - 1, y).a == 0.0):
					var left = [
						Vector3(0, 0, 0),
						Vector3(0, 1, 0),
						Vector3(0, 1, 1),
						Vector3(0, 0, 1)
					]
					for i in range(left.size()):
						surface.set_normal(Vector3.LEFT)
						surface.set_color(vertex_color)
						surface.add_vertex((pixel_size * left[i] + Vector3(x, -y, 0) * pixel_size) + offset)
					
					surface.add_index(0 + index_count)
					surface.add_index(1 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(0 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(3 + index_count)
					
					index_count += 4
				
				if x == image.get_size().x - 1 or (x + 1 < image.get_size().x and image.get_pixel(x + 1, y).a == 0.0):
					var right = [
						Vector3(1, 0, 0),
						Vector3(1, 0, 1),
						Vector3(1, 1, 1),
						Vector3(1, 1, 0)
					]
					for i in range(right.size()):
						surface.set_normal(Vector3.RIGHT)
						surface.set_color(vertex_color)
						surface.add_vertex((pixel_size * right[i] + Vector3(x, -y, 0) * pixel_size) + offset)
					
					surface.add_index(0 + index_count)
					surface.add_index(1 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(0 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(3 + index_count)
					
					index_count += 4
				
				if y == 0 or (y - 1 >= 0 and image.get_pixel(x, y - 1).a == 0.0):
					var up = [
						Vector3(0, 1, 0),
						Vector3(1, 1, 0),
						Vector3(1, 1, 1),
						Vector3(0, 1, 1)
					]
					for i in range(up.size()):
						surface.set_normal(Vector3.UP)
						surface.set_color(vertex_color)
						surface.add_vertex((pixel_size * up[i] + Vector3(x, -y, 0) * pixel_size) + offset)
					
					surface.add_index(0 + index_count)
					surface.add_index(1 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(0 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(3 + index_count)
					
					index_count += 4
				
				if y == image.get_size().y - 1 or (y + 1 < image.get_size().y and image.get_pixel(x, y + 1).a == 0.0):
					var down = [
						Vector3(0, 0, 0),
						Vector3(0, 0, 1),
						Vector3(1, 0, 1),
						Vector3(1, 0, 0)
					]
					for i in range(down.size()):
						surface.set_normal(Vector3.DOWN)
						surface.set_color(vertex_color)
						surface.add_vertex((pixel_size * down[i] + Vector3(x, -y, 0) * pixel_size) + offset)
					
					surface.add_index(0 + index_count)
					surface.add_index(1 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(0 + index_count)
					surface.add_index(2 + index_count)
					surface.add_index(3 + index_count)
					
					index_count += 4
			else:
				pass
	
	add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface.commit_to_arrays())

func _init():
	return
