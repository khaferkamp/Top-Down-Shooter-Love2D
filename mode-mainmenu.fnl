(local d (require "draw"))

(local menu-font (love.graphics.newFont 50))

(fn activate [])

(fn draw []
  "Draws the menu font in the middle of the screen"
  (d.draw-background)
  (love.graphics.setColor 1 1 0)
  (let [msg "Click anywhere to start..."]
    (love.graphics.print msg menu-font (/ (- (love.graphics.getWidth) (menu-font:getWidth msg)) 2) (/ (- (love.graphics.getHeight) (menu-font:getHeight)) 2))))

(love.graphics.setColor 1 1 1)

(fn update [dt set-mode])

(fn mousepressed [x y button istouch presses set-mode]
  (when (> button 0)
    (set-mode "mode-play" (d.spawn-player) 30 0)))

(fn keypressed [key set-mode])

{:activate activate
 :draw draw
 :keypressed keypressed
 :mousepressed mousepressed
 :update update}

