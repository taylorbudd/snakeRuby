require 'ruby2d'

set background: 'olive'
set fps_cap: 20

GRID_SIZE = 20

class Snake

    attr_writer :direction

    def initialize
        @positions = [[2,0],[2,1],[2,2],[2,3]]
        @direction = 'down'
    end

    def draw
        @positions.each do |pos|
            Square.new(x: pos[0] * GRID_SIZE, y: pos[1] * GRID_SIZE - 1, size: GRID_SIZE - 1, color: 'white')
        end

    end

    def move
        @positions.shift

        case @direction
        when 'down'
            @positions.push([head[0], head[1] + 1])
        when 'up'
            @positions.push([head[0], head[1] - 1])
        when 'left'
            @positions.push([head[0] - 1, head[1]])
        when 'right'
            @positions.push([head[0] + 1, head[1]])
        end
    end

    def head
        @positions.last
    end
end

snake = Snake.new
snake.draw

update do
    clear
    snake.move
    snake.draw
end

on :key_down do |event|
    if['up', 'down', 'right', 'left'].include?(event.key)
        snake.direction = event.key
    end
end


show