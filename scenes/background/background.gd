@tool
class_name Background extends TextureRect

func _ready() -> void:
    var noise := FastNoiseLite.new()
    noise.seed = randi()

    var noise_texture := NoiseTexture2D.new()
    noise_texture.width = 1024
    noise_texture.height = 1024
    noise_texture.generate_mipmaps = false
    noise_texture.seamless = true
    noise_texture.noise = noise

    var shader_material := material as ShaderMaterial
    shader_material.set_shader_parameter("noise_texture", noise_texture)
    shader_material.set_shader_parameter("size", size)