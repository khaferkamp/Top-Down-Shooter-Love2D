(local d (require "draw"))

(local highscore-font (love.graphics.newFont 50))

(var highscore -1000)

(fn draw []
  (d.draw-background)
  (love.graphics.setColor 0 (/ 102 255) (/ 204 255))
  (let [msg (string.format "Highscore: %d" highscore)]
    (love.graphics.print msg highscore-font (/ (- (love.graphics.getWidth) (highscore-font:getWidth msg)) 2) (/ (- (love.graphics.getHeight) (highscore-font:getHeight)) 2))))

(fn mousepressed [x y button istouch presses set-mode]
  (when (> button 0)
    (set-mode "mode-play" (d.spawn-player) 30 0)))

(fn keypressed [key set-mode])

(fn update [dt set-mode])

{:activate (fn activate [score]
             (set highscore score))
 :draw draw
 :keypressed keypressed
 :mousepressed mousepressed
 :update update}

