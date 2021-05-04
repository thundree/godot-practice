extends Node2D

# Built-in override
func _ready():
	$P1ScoreLabel.set_text(str($Player1.score))
	$P2ScoreLabel.set_text(str($Player2.score))
	
	$WarnLabel.set_text('Start!')
	$Ball.init()

func _process(delta):
	if $Ball.collision:
		var boundary = $Ball.collision.collider
		if not (boundary in [$Borders, $Player1, $Player2]):
			goal(boundary)

# Custom
func match_over(result):
	$Ball.init()
	$Ball.velocity = Vector2()
	$Ball.visible = false
	
	$WarnLabel.set_text(result)
	

func reset_ball():
	$Ball.init()

func goal(boundary):
	if boundary == $LeftBoundary:
		$Player1.score += 1
		$P1ScoreLabel.set_text(str($Player1.score))
	else:
		$Player2.score += 1
		$P2ScoreLabel.set_text(str($Player2.score))
	
	var p1_won = $Player1.has_won()
	var p2_won = $Player2.has_won()
	
	if p1_won and p2_won:
		match_over('Tie!')
	elif p1_won:
		match_over('Player 1 wins!')
	elif p2_won:
		match_over('Player 2 wins!')
	else:
		reset_ball()

