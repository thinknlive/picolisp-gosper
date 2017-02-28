
(allowed () "!canvasTest" "@lib.css" )

(load "@lib/http.l" "@lib/xhtml.l" "@lib/form.l" "@lib/canvas.l")

(load "c-curve.l")

(de *DX . 800.0)
(de *DY . 600.0)

(setq
   *Delay 256
   *Org-X (*/ *DX 0.5 1.0)
   *Org-Y (*/ *DY 0.5 1.0)
   *Colors '("black" "white" "grey" "red" "yellow" "green")
)

(de drawCanvas (Id Dly)
   (setq 
      Range-X (abs (- *Max-X *Min-X))
      Range-Y (abs (- *Max-Y *Min-Y))
      Aspect-XY (*/ 1.0 Range-X Range-Y)
      Scl-X (*/ (*/ 1.0 *DX Range-X) 1.0 1.0)
      Scl-Y (*/ (*/ 1.0 *DY Range-Y) 1.0 1.0)
      Org-X (- 0 (*/ *Min-X Scl-X 1.0)) 
      Org-Y (- 0 (*/ *Min-Y Scl-Y 1.0))
   )
   (msg (text "drawCanvas| Range-XY: @1 @2 Scl-XY: @3 @4"
      (round Range-X)
      (round Range-Y)
      (round Scl-X)
      (round Scl-Y)))  
   (msg (text "drawCanvas| *Org-XY: @1 @2 Org-XY: @3 @4"  
      (round *Org-X)
      (round *Org-Y)
      (round Org-X)
      (round Org-Y)))
   (make
      (csStrokeStyle "black")
      (csBeginPath)
      (let (CL (reverse *Plot)
           XY (pop 'CL))
         (when XY 
            (setq X (round (+ (*/ Scl-X (car XY) 1.0) Org-X) 6)
                  Y (round (+ (*/ Scl-Y (cadr XY) 1.0) Org-Y) 6))
            (csMoveTo X Y)) 
         (while (setq XY (pop 'CL))
             (setq X (round (+ (*/ Scl-X (car XY) 1.0) Org-X) 6)
                   Y (round (+ (*/ Scl-Y (cadr XY) 1.0) Org-Y) 6))
             (csLineTo X Y)
             (csMoveTo X Y)
         )
      (csStroke))))

(de canvasTest ()
   (msg (text "canvasTest|"))
   (app)
   (action
         (html 0 "Fixed Point Precision" '("@lib.css" . "canvas {border: 1px solid}") NIL 
            (form NIL
                  (<h2> NIL "Gosper Curves (press Draw! No httpGate? Press twice)")
                  (<canvas> "$testID" (round *DX 0) (round *DY 0))
                  (----)
                  (gui '(+OnClick +Button)
                     "return drawCanvas('$testID', -1)"
                     "Draw C!"
                     '(Run-C-Curve 300.0 0.0 500000))
                  (gui '(+OnClick +Button)
                     "return drawCanvas('$testID', -1)"
                     "Draw Dragon!" 
                     '(Run-Dragon-Curve 128.0 0.0 1.0 1000000))
                  (----)
                ) ) ) )

(de main ()
)

(de go ()
   (server 8080 "!canvasTest")
)


