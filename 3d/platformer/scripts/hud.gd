extends CanvasLayer
## HUD handler for a 3D platformer.
##
## Updates coin text as needed.


func _on_coin_collected(coins):
	$Coins.text = str(coins)
