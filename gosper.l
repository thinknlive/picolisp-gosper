
(allowed () "!canvasTest" "@lib.css" )

(load "@lib/http.l" "@lib/xhtml.l" "@lib/form.l" "@lib/canvas.l")

(load "c-curve.l")

(de *DX . 800.0)
(de *DY . 600.0)

(setq
   *Delay 10 
   *Org-X (*/ *DX 0.5 1.0)
   *Org-Y (*/ *DY 0.5 1.0)
   *Step 1
   *Colors '("black" "white" "grey" "red" "yellow" "green")
   *CurrentPlot NIL
   *Step T
)

(de drawCanvas (Id Dly)
   (let (
      Range-X (abs (- *Max-X *Min-X))
      Range-Y (abs (- *Max-Y *Min-Y))
      Aspect-XY (*/ 1.0 Range-X Range-Y)
      Scl-X (*/ (*/ 1.0 *DX Range-X) 1.0 1.0)
      Scl-Y (*/ (*/ 1.0 *DY Range-Y) 1.0 1.0)
      Org-X (- 0 (*/ *Min-X Scl-X 1.0)) 
      Org-Y (- 0 (*/ *Min-Y Scl-Y 1.0))
      Plot NIL
      Step 5
   )

   (when (and *Plot (car *Plot))
      (if *Step
         (while (and (car *Plot) (gt0 (dec 'Step)))
            (setq *CurrentPlot 
               (cons 
                  (pop '*Plot) 
                  *CurrentPlot)))
         (while (car *Plot)
            (setq *CurrentPlot 
               (cons 
                  (pop '*Plot) 
                  *CurrentPlot)))))

   (setq Plot (reverse *CurrentPlot))

   #(msg (text "drawCanvas| Range-XY: @1 @2 Scl-XY: @3 @4"
   #   (round Range-X)
   #   (round Range-Y)
   #   (round Scl-X)
   #   (round Scl-Y)))  
   #(msg (text "drawCanvas| *Org-XY: @1 @2 Org-XY: @3 @4"  
   #   (round *Org-X)
   #   (round *Org-Y)
   #   (round Org-X)
   #   (round Org-Y)))
   
   (make
      #(csClearRect 0 0 *DX *DY)
      (csStrokeStyle "black")
      (csBeginPath)
      (let (XY (pop 'Plot))
         (when XY 
            (setq X (round (+ (*/ Scl-X (car XY) 1.0) Org-X) 6)
                  Y (round (+ (*/ Scl-Y (cadr XY) 1.0) Org-Y) 6))
            (csMoveTo X Y)) 
         (while (setq XY (pop 'Plot))
             (setq X (round (+ (*/ Scl-X (car XY) 1.0) Org-X) 6)
                   Y (round (+ (*/ Scl-Y (cadr XY) 1.0) Org-Y) 6))
             (csLineTo X Y)
             (csMoveTo X Y)
         )
      (csStroke)))))

(de canvasTest ()
   (msg (text "canvasTest|"))
   (app)
   (action
         (html 0 "Picolisp numbers" '("@lib.css" . "canvas {border: 1px solid}") NIL 
            (form NIL
                  (<h2> NIL "Curves")
                  (<canvas> "$testID" (round *DX 0) (round *DY 0))
                  (javascript NIL "onload=drawCanvas('$testID', " *Delay ")")       
                  (----)
                  (gui "btn1" '(+OnClick +Button)
                     NIL
                     "C!"
                     '(prog 
                        (msg ">> Draw C-Curve") 
                        (setq *Delay 250 *CurrentPlot NIL *Step T) 
                        (Run-C-Curve 96.0 0.0 1000000)))
                  (gui "btn2"  '(+OnClick +Button)
                     NIL 
                     "Dragon!" 
                     '(prog 
                        (msg ">> Draw Dragon Curve") 
                        (setq *Delay 250 *CurrentPlot NIL *Step T)
                        (Run-Dragon-Curve 128.0 0.0 1.0 1000000)))
                   (gui "btn3"  '(+OnClick +Button)
                     NIL 
                     "Draw rest.." 
                     '(prog 
                        (msg ">> Draw rest") 
                        (setq *Delay -1 *Step NIL))) 
                   (gui "btn4"  '(+OnClick +Button)
                     NIL 
                     "Stop" 
                     '(prog 
                        (msg ">> Stop") 
                        (setq *Plot NIL *Delay -1))) 
                  (----)
                ) ) ) )

(de main ()
)

(de go ()
   (server 8080 "!canvasTest")
)


