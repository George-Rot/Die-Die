Godot Main Menu

Files created:
- MainMenu.tscn — Godot Control scene for the main menu with buttons for New Game, Hall of Fame, and Exit.
- MainMenu.gd — Script handling button presses and scene changes.
- HallOfFame.tscn — Simple scene listing top names and a Back button.
- HallOfFame.gd — Script for returning to the main menu.

How to use:
1. Open Godot 4 and create or open a project whose project folder is the workspace root (the folder that contains these files).
2. Open `MainMenu.tscn` in the editor. Assign it as the main scene in Project Settings -> Run -> Main Scene if desired.
3. Update `game_scene_path` inside `MainMenu.gd` to point to your actual game scene (e.g., `res://Game.tscn`).
4. Run the project; the buttons will change scenes or quit the game.

Assumptions:
- This is written for Godot 4.x using GDScript. If you're using Godot 3.x the scene format and some APIs differ.
- `Game.tscn` is not provided here; set its path in `MainMenu.gd` to your game scene.

Next steps you might want:
- Load Hall of Fame entries from a JSON or saved file.
- Add keyboard/gamepad navigation and visual styles.
