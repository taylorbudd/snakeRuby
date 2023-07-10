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
            @positions.push(new_coords(head[0], head[1] + 1))
        when 'up'
            @positions.push(new_coords(head[0], head[1] - 1))
        when 'left'
            @positions.push(new_coords(head[0] - 1, head[1]))
        when 'right'
            @positions.push(new_coords(head[0] + 1, head[1]))
        end
    end

    def can_change_direction_to?(new_direction)
        case @direction
        when 'up' then new_direction != 'down'
        when 'down' then new_direction != 'up'
        when 'left' then new_direction != 'right'
        when 'right' then new_direction != 'left'
        end
    end

    def new_coords(x,y)
        [x % GRID_WIDTH, y % GRID_HEIGHT]
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
        if snake.can_change_direction_to?(event.key)
            snake.direction = event.key
        end
    end
end


show