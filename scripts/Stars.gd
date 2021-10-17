extends TileMap

export(int) var top = -50
export(int) var left = -50
export(int) var width = 100
export(int) var height = 100
export(float) var chance = 0.1

func _ready() -> void:
    randomize()
    for i in height:
        for j in width:
            if randf() <= chance:
                set_cell(j + left, i + top, 0, false, false, false, Vector2(randi() % 7, 0))
                