extends Control

# 1. Referințe către nodurile din scenă
@onready var line_mobila = $CurrentLine
@onready var puncte_stanga = $PuncteStanga
@onready var puncte_dreapta = $PuncteDreapta
@onready var sunet_eroare = $SunetEroare

# 2. Dicționarul de texturi
var texturi_cablu = {
	"red": preload("res://assets/textures/cablu_rosu.png"),
	"green": preload("res://assets/textures/cablu_verde.png"),
	"yellow": preload("res://assets/textures/cablu_galben.png"),
	"grey": preload("res://assets/textures/cablu_gri.png"),
	"cyan": preload("res://assets/textures/cablu_cyan.png"),
	"pink": preload("res://assets/textures/cablu_roz.png"),
	"blue": preload("res://assets/textures/cablu_albastru.png")
}

# 3. Variabile de stare
var fir_selectat = null
var culoare_selectata = ""
var punct_pornire = Vector2.ZERO

# 4. Ordinea Nivelelor
var ordine_nivele = {
	"red": 1,
	"green": 2,
	"yellow": 3,
	"grey": 4,
	"cyan": 5,
	"pink": 6,
	"blue": 7
}

# 5. Căile către scenele nivelelor
var nivele = {
	"red":"res://scenes/level1.tscn" ,
	"green": "res://scenes/level2.tscn",
	"yellow": "res://scenes/level3.tscn",
	"grey": "res://scenes/level4.tscn",
	"cyan": "res://scenes/level5.tscn",
	"pink": "res://scenes/level6.tscn",
	"blue": "res://scenes/level7.tscn"
}

func _ready():
	line_mobila.visible = false
	line_mobila.z_index = 10
	line_mobila.width = 80
	line_mobila.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line_mobila.end_cap_mode = Line2D.LINE_CAP_ROUND
	line_mobila.texture_mode = Line2D.LINE_TEXTURE_TILE

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_incepe_tragere(event.position)
		else:
			_finalizeaza_tragere(event.position)
	
	if event is InputEventMouseMotion and fir_selectat != null:
		# Mișcăm punctul final al liniei mobile
		line_mobila.set_point_position(1, event.position - global_position)

func _incepe_tragere(pos):
	for punct in puncte_stanga.get_children():
		if punct.get_global_rect().has_point(pos):
			var cul = punct.name.get_slice("_", 0)
			
			if ordine_nivele.has(cul):
				if ordine_nivele[cul] > Global.nivel_maxim_deblocat:
					if sunet_eroare: sunet_eroare.play()
					return 
			
			fir_selectat = punct
			culoare_selectata = cul
			
			if texturi_cablu.has(cul):
				line_mobila.texture = texturi_cablu[cul]
				line_mobila.default_color = Color.WHITE
			else:
				line_mobila.texture = null
				line_mobila.default_color = punct.color
				
			line_mobila.visible = true
			
			# Calculăm centrul global al punctului și îl convertim local pentru line_mobila
			var centru_global = punct.global_position + (punct.size / 2)
			punct_pornire = centru_global - global_position
			
			line_mobila.clear_points()
			line_mobila.add_point(punct_pornire)
			line_mobila.add_point(pos - global_position)
			break

func _finalizeaza_tragere(pos):
	if fir_selectat == null: return
	
	for tinta in puncte_dreapta.get_children():
		if tinta.get_global_rect().has_point(pos):
			var culoare_tinta = tinta.name.get_slice("_", 0)
			
			if culoare_tinta == culoare_selectata:
				_creeaza_fir_fix(culoare_selectata)
				
				line_mobila.visible = false
				line_mobila.clear_points()
				
				_schimba_scena(culoare_selectata)
				fir_selectat = null
				return
			else:
				if sunet_eroare: sunet_eroare.play()
	
	fir_selectat = null
	line_mobila.visible = false
	line_mobila.clear_points()

func _creeaza_fir_fix(nume_cul):
	var line = Line2D.new()
	add_child(line)
	line.width = 80
	line.z_index = 5
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	if texturi_cablu.has(nume_cul):
		line.texture = texturi_cablu[nume_cul]
		line.default_color = Color.WHITE
		line.texture_mode = Line2D.LINE_TEXTURE_TILE

	# --- SOLUȚIA PENTRU CENTRARE PERFECTĂ ---
	var nod_S = puncte_stanga.get_node(nume_cul + "_S")
	var nod_D = puncte_dreapta.get_node(nume_cul + "_D")
	
	if nod_S and nod_D:
		# Calculăm centrele folosind coordonate globale, apoi convertim local la WiringTask
		var centru_S = (nod_S.global_position + nod_S.size / 2) - global_position
		var centru_D = (nod_D.global_position + nod_D.size / 2) - global_position
		
		line.add_point(centru_S)
		line.add_point(centru_D)

func _schimba_scena(cul):
	if ordine_nivele.has(cul):
		if ordine_nivele[cul] == Global.nivel_maxim_deblocat:
			Global.nivel_maxim_deblocat += 1
	
	await get_tree().create_timer(0.5).timeout
	
	if nivele.has(cul):
		get_tree().change_scene_to_file(nivele[cul])
