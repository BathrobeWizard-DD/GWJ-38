extends TileMap

export(int) var top = -50
export(int) var left = -50
export(int) var width = 100
export(int) var height = 100
export(int) var noise_offset = 0

var noise := OpenSimplexNoise.new() as OpenSimplexNoise

func _ready() -> void:
    randomize()
    noise.period = 5
    for i in height:
        for j in width:
            if noise.get_noise_2d(j +left + noise_offset, i + top + noise_offset) >= 0.0:
                set_cell(j + left, i + top, 0)
    
    update_bitmask_region(Vector2(top, left), Vector2(top + height, left + width))