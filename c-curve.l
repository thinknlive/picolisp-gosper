(scl 8)
(load "@lib/math.l")

(setq SQRT-2  (sqrt 2.0 1.0)
      PI/4 (*/ 1.0 3.14159265 4.0)
      PI/8 (*/ 1.0 3.14159265 8.0)
      PI/2 (*/ 1.0 3.14159265 2.0)
      PI/3 (*/ 1.0 3.14159265 3.0)
      *Min-Length (sqrt 2.0 1.0)
      *Cnt 10000
      *Prv-X 0.0 
      *Prv-Y 0.0
      *Plot NIL
      *Min-X NIL *Max-X NIL 
      *Min-Y NIL *Max-Y NIL)


# ----------------------------
(de Connect-Line (Nxt-X Nxt-Y)
   
   # (msg (text "---> Cnt: @1 Prv-XY: @2 @3 Nxt-XY: @4 @5"
   #       *Cnt 
   #       (round *Prv-X 2) (round *Prv-Y 2) 
   #       (round Nxt-X 2) (round Nxt-Y 2)))
   
  
   (setq *Plot (cons (list Nxt-X Nxt-Y) *Plot)
      *Min-X   (min Nxt-X (or *Min-X Nxt-X))
      *Max-X   (max Nxt-X (or *Max-X Nxt-X))
      *Min-Y   (min Nxt-Y (or *Min-Y Nxt-Y))
      *Max-Y   (max Nxt-Y (or *Max-Y Nxt-Y))
      *Prv-X Nxt-X 
      *Prv-Y Nxt-Y)
)

# -----------------
(de Plot-Line (L A)
   
   #(msg (text "#### Length: @1 Angle: @2 Cnt: @3" (format L *Scl) (format A *Scl) *Cnt))
   
   (Connect-Line
      (+ *Prv-X (*/ L (cos A) 1.0))
      (+ *Prv-Y (*/ L (sin A) 1.0)))   
)

# ###################
# Generator functions

# ------------------------   
(de C-Curve (Length Angle) 
   (cond 
      ((< Length *Min-Length) (Plot-Line Length Angle)) 
      (T (when (gt0 (dec '*Cnt))
            (C-Curve (*/ 1.0 Length SQRT-2)
                     (+ Angle PI/4))
            (C-Curve (*/ 1.0 Length SQRT-2)
                     (- Angle PI/4))))))        

# ---------------------------------- 
(de Dragon-Curve (Length Angle Sign)
   (cond 
      ((< Length *Min-Length) (Plot-Line Length Angle))
      (T (when (gt0 (dec '*Cnt))
            (Dragon-Curve (*/ 1.0 Length SQRT-2)
                        (+ Angle (*/ Sign PI/4 1.0))
                        +1.0)
            (Dragon-Curve (*/ 1.0 Length SQRT-2)
                        (- Angle (*/ Sign PI/4 1.0))
                        -1.0)))))

# -------------------------------
(de Gosper-Curve (Length Angle N) 
   # https://en.wikipedia.org/wiki/Gosper_curve
   # Angle 60 degrees = PI/3
   # Axiom A
   # Replacement Rules
   #   A :--> A - B - - B + A + + A A + B -
   #   B :--> + A - B B - - B - A + + A + B 

   (let 
      (A (chop "A-B--B+A++AA+B-")  
         B (chop "+A-BB--B-A++A+B") 
         C A
         F '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) ) 

      # Note: C grows...very very quickly
      #: n=0 (length C) -> 15
      #: n=1 (length (setq C (F C))) -> 113
      #: n=2 -> 799, n=3 -> 5601, n=4 -> 39215, n=5 -> 274513, n=6 -> 1921599, n=7 .
      
      # Generate points
      (do N (setq C (F C)))

      # Plot points
      (map '((R) 
         (case (car R)
            (("A" "B") (Plot-Line Length Angle))
            ("+" (setq Angle (+ Angle PI/3)))
            ("-" (setq Angle (- Angle PI/3))) 
            (T (msg (text "?Gosper-Curve: No-match: @1" @))) )) C )

   )
)

# ################################
# Wrapper functions for generators


# --------------------------------
(de Run-C-Curve (Length Angle Cnt)
   
   (setq *Plot NIL
      *Cnt (ifn Cnt 1000 Cnt)
      *Prv-X 0
      *Prv-Y 0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   
   (C-Curve Length Angle)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "---> C-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
       (length *Plot) 
       (round *Min-X 2) (round *Min-Y 2) 
       (round *Max-X 2) (round *Max-Y 2)))

)

# ------------------------------------------
(de Run-Dragon-Curve (Length Angle Sign Cnt)
   
   (setq *Plot NIL
      *Cnt (ifn Cnt 1000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default Sign +1.0)
   
   (Dragon-Curve Length Angle Sign)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "---> Dragon-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)


# ---------------------------------------
(de Run-Gosper-Curve (Length Angle N Cnt)
   
   (setq *Plot NIL
      *Cnt (ifn Cnt 10000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default N 3)
   
   (Gosper-Curve Length Angle N)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "---> Gosper-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)


# ######################################
# GUI Hooks

(setq *CurrentPlot NIL    
      *StepSize 11       
      *Step T           
      *RefreshDelay 100
      *Resume NIL)

(de Draw-Dragon-Curve ()
   (msg ">> Draw Dragon Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T)
   (Run-Dragon-Curve 32.0 0.0 1.0 1000000))

(de Draw-C-Curve ()
   (msg ">> Draw C-Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-C-Curve 16.0 0.0 1000000))

(de Draw-Gosper-Curve ()
   (msg ">> Draw Gosper-Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-Gosper-Curve 64.0 0.0 4 2000000))

(de Stop-Draw ()
   (msg ">> Stop") 
   (setq *Delay -1))

(de Draw-Step ()
   (msg "> Start")
   (setq *Resume T *Delay *RefreshDelay *Step T))

(de Draw-All ()
   (msg "> Draw rest") 
   (setq *Delay -1 *Step NIL))


