(local d (require "draw"))

(var player [])

(var timer 0)

(var score 0)

(var zombies [])

(var spawn-timer 0)

(var spawn-threshold 0)

(var bullets [])

(fn activate [player-in timer-in score-in]
  (set zombies [])
  (set bullets [])
  (set player player-in)
  (set score score-in)
  (set timer timer-in)
  (set spawn-threshold 1.5)
  (set spawn-timer spawn-threshold))

(fn draw []
  (d.draw-background)
  (each [i z (ipairs zombies)]
    (d.draw-zombie z.x z.y (d.zombie-player-angle z.x z.y player.x player.y)))
  (each [i b (ipairs bullets)]
    (d.draw-bullet b.x b.y))
  (d.draw-player player.x player.y (d.player-mouse-angle player.x player.y (love.mouse.getX) (love.mouse.getY)))
  (d.draw-score-text score)
  (d.draw-timer-text timer))

(fn mousepressed [x y button istouch presses set-mode]
  (when (= button 1)
    (table.insert bullets (d.spawn-bullet 500 player.x player.y (d.player-mouse-angle player.x player.y (love.mouse.getX) (love.mouse.getY))))))

(fn update [dt set-mode]
  (when (<= timer 0)
    (set-mode "mode-gameover" score))
  (set timer (- timer dt))
  (when (< spawn-timer 0)
    (let [side (math.random 1 4)]
      (table.insert zombies (d.spawn-zombie 140 (d.get-rand-x-coord-dir side) (d.get-rand-y-coord-dir side))))
    (set spawn-threshold (* spawn-threshold 0.95))
    (set spawn-timer spawn-threshold))
  (set spawn-timer (- spawn-timer dt))
  (when (love.keyboard.isDown "d")
    (tset player "x" (+ player.x (* player.speed dt))))
  (when (love.keyboard.isDown "a")
    (tset player "x" (- player.x (* player.speed dt))))
  (when (love.keyboard.isDown "w")
    (tset player "y" (- player.y (* player.speed dt))))
  (when (love.keyboard.isDown "s")
    (tset player "y" (+ player.y (* player.speed dt))))
  (each [i z (ipairs zombies)]
    (let [angle (d.zombie-player-angle z.x z.y player.x player.y)]
      (tset z "x" (+ z.x (* (math.cos angle) z.speed dt)))
      (tset z "y" (+ z.y (* (math.sin angle) z.speed dt))))
    (when (< (d.distance-between player.x player.y z.x z.y) 30)
      (each [i2 z2 (ipairs zombies)]
        (table.remove zombies i2))
      (set-mode "mode-gameover" score)))
  (each [i b (ipairs bullets)]
    (tset b "x" (+ b.x (* (math.cos b.direction) b.speed dt)))
    (tset b "y" (+ b.y (* (math.sin b.direction) b.speed dt))))
  (for [i (length bullets) 1 -1]
    (let [b (. bullets i)
          max-x (love.graphics.getWidth)
          max-y (love.graphics.getHeight)]
      (when (or (< b.x 0) (> b.x max-x) (< b.y 0) (> b.y max-y) (= b.dead true))
        (table.remove bullets i))))
  (each [i z (ipairs zombies)]
    (each [j b (ipairs bullets)]
      (when (< (d.distance-between z.x z.y b.x b.y) 20)
        (set z.dead true)
        (set b.dead true))))
  (for [i (length zombies) 1 -1]
    (let [z (. zombies i)]
      (when (= z.dead true)
        (table.remove zombies i)
        (set score (+ score 1))))))

(fn keypressed [key set-mode])

{:activate activate
 :draw draw
 :keypressed keypressed
 :mousepressed mousepressed
 :update update}

