
(allowed () "!canvasTest" "@lib.css" )

(load "@lib/http.l" "@lib/xhtml.l" "@lib/form.l" "@lib/canvas.l")

(setq 
   *Delay -1
   *Last NIL)

(load "c-curve.l")

(de *DX . 800.0)
(de *DY . 600.0)


(de drawCanvas (Id Dly)
   # Scale, shift the set of input points to fit entirely in view
   
   (let (
      Range-X (abs (- *Max-X *Min-X))
      Range-Y (abs (- *Max-Y *Min-Y))
      Aspect-XY (*/ 1.0 Range-X Range-Y)
      Scl-X (*/ (*/ 1.0 *DX Range-X) 1.0 1.0)
      Scl-Y (*/ (*/ 1.0 *DY Range-Y) 1.0 1.0)
      Org-X (- 0 (*/ *Min-X Scl-X 1.0)) 
      Org-Y (- 0 (*/ *Min-Y Scl-Y 1.0))
      Plot NIL
      Step 0
      First (not *CurrentPlot)
      CL NIL
   )

   (when (and *Plot (car *Plot))
      (cond 
         ((and *Step (gt0 *StepSize))
            (setq Step *StepSize)
            (while (and (car *Plot) (ge0 (dec 'Step)))
               (setq *CurrentPlot 
                  (cons 
                     (pop '*Plot) 
                     *CurrentPlot))))
         (T
            (while (car *Plot)
               (setq *CurrentPlot 
                  (cons 
                     (pop '*Plot) 
                     *CurrentPlot))))))

   (if (and *Step (gt0 *StepSize) (ge0 *Delay) (not *Resume))
      (setq Plot (reverse (head (+ *StepSize 1) *CurrentPlot)))
      (setq Plot (reverse *CurrentPlot) *Resume NIL))

   #(msg (text "drawCanvas| Range-XY: @1 @2 Scl-XY: @3 @4"
   #   (round Range-X)
   #   (round Range-Y)
   #   (round Scl-X)
   #   (round Scl-Y)))  
   #(msg (text "drawCanvas| First: @1 *Step: @2 *Last: @3 *Plot: @4 *CurrentPlot: @5 Plot: @6 *StepSize: @7 *Delay: @8"  
   #   First 
   #   *Step
   #   *Last
   #   (length *Plot)
   #   (length *CurrentPlot)
   #   (length Plot)
   #   *StepSize
   #   *Delay))
 

   (unless *Last 
      (setq CL  
         (make
            #(csClearRect 0 0 *DX *DY)
            (csStrokeStyle "black")
            (csBeginPath)
            (let (XY NIL)
               (when First
                  (setq XY (pop 'Plot))
                  (when XY 
                     (setq X (round (+ (*/ Scl-X (car XY) 1.0) Org-X) 7)
                           Y (round (+ (*/ Scl-Y (cadr XY) 1.0) Org-Y) 7))
                     (csMoveTo X Y))) 
               (do T (NIL (setq XY (pop 'Plot)))
                  (setq X (round (+ (*/ Scl-X (car XY) 1.0) Org-X) 7)
                        Y (round (+ (*/ Scl-Y (cadr XY) 1.0) Org-Y) 7))
                  (csLineTo X Y)
                  (csMoveTo X Y)))
            (csStroke))))

   (setq *Last (not *Plot))

   CL))

(de canvasTest ()
   (msg (text ">canvasTest"))
   (app)
   (action
         (html 0 "Picolisp numbers" '("@lib.css" . "canvas {border: 1px solid}") NIL 
            (form NIL
                  (<h2> NIL "Curves")
                  (<canvas> "$testID" (round *DX 0) (round *DY 0))
                  (javascript NIL "onload=drawCanvas('$testID', " *Delay ")")       
                  (----)
                  (gui '(+Button)
                     "C!"
                     '(Draw-C-Curve))
                  (gui '(+Button)
                     "Dragon!" 
                     '(Draw-Dragon-Curve))
                  (gui '(+Button)
                     "Gosper!" 
                     '(Draw-Gosper-Curve))
                  (----)
                   (gui '(+Able +Button)
                     '(lt0 *Delay)
                     "Step" 
                     '(Draw-Step)) 
                   (gui '(+Button)
                     "All" 
                     '(Draw-All)) 
                   (gui '(+Able +Button)
                     '(gt0 *Delay)
                     "Stop" 
                     '(Stop-Draw))
                  (----)
                   (gui '(+Button)
                     "Reload" 
                     '(prog
                        (msg "!Reload")
                        (setq *Delay -1)
                        (load "c-curve.l")))
                ) ) ) )

(de main ()
)

(de go ()
   (server 8080 "!canvasTest")
)


