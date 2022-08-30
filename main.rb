require 'ruby2d'
require_relative 'board'
require_relative 'game'
require_relative 'start_screen'
require_relative 'game_screen'

set title: 'Minesweeper'
set background: 'navy'
set fps_cap: 30
# set resizable: true
set width: 840
set height: 680

# constants
WINDOW_WIDTH = get :width
WINDOW_HEIGHT = get :height
HALF_WINDOW_WIDTH = WINDOW_WIDTH / 2
HALF_WINDOW_HEIGHT = WINDOW_HEIGHT / 2
CELL_SIZE = 32

# well, this works...but RuboCop is screaming at me
$current_screen = StartScreen.new

update do
  clear
  $current_screen.draw
  Text.new("fps: #{Window.fps.truncate(1)}", x: 0, y: WINDOW_HEIGHT - 15, size: 12)
end

on :key_down do |event|
  case $current_screen
  when StartScreen
    $current_screen.key_down(event)
  end
end

on :mouse_down do |event|
  case $current_screen
  when GameScreen
    $current_screen.mouse_down(event) # let the game screen handle its inputs
  end
end

show