(local lume (require "lib/lume"))

(local sprites {:background (love.graphics.newImage "assets/background.png")
                :bullet (love.graphics.newImage "assets/bullet.png")
                :player (love.graphics.newImage "assets/player.png")
                :zombie (love.graphics.newImage "assets/zombie.png")})

(local player {:speed 180
               :x (/ (love.graphics.getWidth) 2)
               :y (/ (love.graphics.getHeight) 2)})

(local game-font (love.graphics.newFont 30))

(fn player-mouse-angle [x1 y1 x2 y2]
  (+ (math.atan2 (- y1 y2) (- x1 x2)) math.pi))

(fn zombie-player-angle [x1 y1 x2 y2]
  (+ (math.atan2 (- y1 y2) (- x1 x2)) math.pi))

(fn spawn-zombie [speed x y direction]
  {:dead false
   :speed speed
   :x x
   :y y})

(fn spawn-bullet [speed x y direction]
  {:dead false
   :direction direction
   :speed speed
   :x x
   :y y})

(fn get-rand-x-coord-dir [direction]
  (let [max-x (love.graphics.getWidth)]
    (match direction
      1 (math.random 0 max-x)
      2 -30
      3 (math.random 0 max-x)
      4 (+ 30 max-x))))

(fn get-rand-y-coord-dir [direction]
  (let [max-y (love.graphics.getHeight)]
    (match direction
      1 -30
      2 (math.random 0 max-y)
      3 (+ 30 max-y)
      4 (math.random 0 max-y))))

(fn distance-between [x1 y1 x2 y2]
  (math.sqrt (+ (^ (- x2 x1) 2) (^ (- y2 y1) 2))))

(fn draw-background []
  (love.graphics.draw sprites.background))

(fn draw-player [x y rotation]
  (love.graphics.draw sprites.player x y rotation nil nil (/ (sprites.player:getWidth) 2) (/ (sprites.player:getHeight) 2)))

(fn draw-zombie [x y rotation]
  (love.graphics.draw sprites.zombie x y rotation nil nil (/ (sprites.zombie:getWidth) 2) (/ (sprites.zombie:getHeight) 2)))

(fn draw-bullet [x y]
  (love.graphics.draw sprites.bullet x y nil 0.5 0.5 (/ (sprites.bullet:getWidth) 2) (/ (sprites.bullet:getHeight) 2)))

(fn draw-score-text [score]
  (love.graphics.setColor 1 1 1)
  (love.graphics.print (: "Score: %d" "format" score) game-font 200 0)
  (love.graphics.setColor 1 1 1))

(fn draw-timer-text [timer-in]
(let [timer (lume.round timer-in)]
  (if (>= timer 20)
      (love.graphics.setColor 1 1 1)
      (if (>= timer 10)
          (love.graphics.setColor 1 1 0)
          (love.graphics.setColor 1 0 0)))
  (love.graphics.print (: "Time: %d" "format" timer) game-font 0 0))
  (love.graphics.setColor 1 1 1))

{:distance-between distance-between
 :draw-background draw-background
 :draw-bullet draw-bullet
 :draw-player draw-player
 :draw-score-text draw-score-text
 :draw-timer-text draw-timer-text
 :draw-zombie draw-zombie
 :get-rand-x-coord-dir get-rand-x-coord-dir
 :get-rand-y-coord-dir get-rand-y-coord-dir
 :player-mouse-angle player-mouse-angle
 :spawn-bullet spawn-bullet
 :spawn-player (fn spawn-player []
                 player)
 :spawn-zombie spawn-zombie
 :zombie-player-angle zombie-player-angle}

