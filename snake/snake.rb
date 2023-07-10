require 'ruby2d'

set background: 'olive'
set fps_cap: 20

GRID_SIZE = 20
GRID_HEIGHT = Window.height / GRID_SIZE
GRID_WIDTH = Window.width / GRID_SIZE

class Snake

    attr_writer :direction

    def initialize
        @positions = [[2,0],[2,1],[2,2],[2,3]]
        @direction = 'down'
        @growing = false
    end

    def draw
        @positions.each do |pos|
            Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE, size: GRID_SIZE - 1, color: 'white')
        end
    end

    def move
        if !@growing
            @positions.shift
        end

        @positions.push(next_position)
        @growing = false
    end

    def next_position
        if @direction == 'down'
            new_coords(head[0], head[1] + 1)
        elsif @direction == 'up'
            new_coords(head[0], head[1] - 1)
        elsif @direction == 'left'
            new_coords(head[0] - 1, head[1])
        elsif @direction == 'right'
            new_coords(head[0] + 1, head[1])
        end
    end

    def grow
        @growing = true
    end

    def can_change_direction_to?(new_direction)
        case @direction
        when 'up' then new_direction != 'down'
        when 'down' then new_direction != 'up'
        when 'left' then new_direction != 'right'
        when 'right' then new_direction != 'left'
        end
    end

    def x
        head[0]
    end

    def y
        head[1]
    end

    private

    def new_coords(x,y)
        [x % GRID_WIDTH, y % GRID_HEIGHT]
    end

    def head
        @positions.last
    end


end

class Game

    def initialize
        @score = 0
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
    end

    def draw
        Square.new(x: @food_x * GRID_SIZE, y: @food_y * GRID_SIZE, size: GRID_SIZE, color: 'navy')
        Text.new("Score: #{@score}", color: 'brown', x: 10, y: 10, size: 25)
    end

    def snake_hit_food?(x,y)
        puts "This is the food coords: #{@food_x}, #{@food_y}"
        @food_x == x && @food_y == y
    end

    def record_hit
        @score += 1
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
    end
end

snake = Snake.new
game = Game.new

update do
    clear

    snake.move
    snake.draw
    game.draw

    if game.snake_hit_food?(snake.x, snake.y)
        puts "This is the snake coords: #{snake.x}, #{snake.y}"
        game.record_hit
    end
end

on :key_down do |event|
    if['up', 'down', 'right', 'left'].include?(event.key)
        if snake.can_change_direction_to?(event.key)
            snake.direction = event.key
        end
    end
end


show