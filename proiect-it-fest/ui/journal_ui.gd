extends CanvasLayer

@onready var journal_panel = $JournalPanel
@onready var toggle_button = $Toggle
@onready var guide_text = $JournalPanel/GuideText

func _ready() -> void:
	# 1. Start with the journal closed
	journal_panel.hide()
	
	# 2. Connect the button press to our toggle function
	toggle_button.pressed.connect(_on_toggle_button_pressed)

func _on_toggle_button_pressed() -> void:
	# Toggle the visibility of the panel
	journal_panel.visible = !journal_panel.visible
	
	# Update the button text depending on the state
	if journal_panel.visible:
		toggle_button.text = "Close Journal"
	else:
		toggle_button.text = "Open Journal"

# The level can call this to update the puzzle instructions
func set_guide_text(new_text: String) -> void:
	if guide_text != null:
		guide_text.text = new_text
		
# Optional: Auto-open the journal when new text is received
func update_and_open(new_text: String) -> void:
	set_guide_text(new_text)
	if not journal_panel.visible:
		_on_toggle_button_pressed()
