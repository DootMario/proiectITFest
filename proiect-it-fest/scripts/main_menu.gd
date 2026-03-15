extends Control

# Referințe către noduri
@onready var buton = $Button
@onready var curent = $Electricalcompleted2
@onready var sunet_click = $SunetClick

# Textul manetei (vertical)
var text_activ = "T\nR\nA\nT\nS"
var este_activat = false

func _ready():
	# 1. Starea inițială
	curent.visible = false
	curent.modulate.a = 0
	
	# 2. Pivotul la centru pentru rotație corectă
	buton.pivot_offset = buton.size / 2
	
	# 3. Conectăm semnalul de click (asigură-te că nu e conectat și din interfață!)
	if not buton.pressed.is_connected(_pe_click_buton):
		buton.pressed.connect(_pe_click_buton)

func _pe_click_buton():
	if este_activat: return 
	este_activat = true
	
	# 4. Redăm sunetul
	if sunet_click:
		sunet_click.play()
	
	# 5. Schimbăm textul
	buton.text = text_activ
	
	# 6. Animațiile (Tween)
	var tween = create_tween().set_parallel(true)
	
	# Rotire manetă
	tween.tween_property(buton, "rotation_degrees", 90, 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	
	# Apariție curent
	curent.visible = true
	tween.tween_property(curent, "modulate:a", 1.0, 0.2)
	
	# 7. METODA SIGURĂ: Folosim Tween-ul ca să așteptăm, nu un timer separat
	# Creăm un al doilea tween care rulează după primul pentru a schimba scena
	var final_tween = create_tween()
	final_tween.tween_interval(0.7) # Așteaptă 0.7 secunde
	final_tween.tween_callback(_schimba_scena_finala)

func _schimba_scena_finala():
	# Verificăm dacă suntem încă în ierarhia jocului
	if is_inside_tree():
		var cale = "res://scenes/SelectorNivele.tscn"
		var eroare = get_tree().change_scene_to_file(cale)
		
		if eroare != OK:
			print("Eroare: Nu pot încărca scena de la calea: ", cale)

# Ștergem funcția de jos care era duplicat și putea cauza erori
