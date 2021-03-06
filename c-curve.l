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
   
    #(msg (text "---> Cnt: @1 Prv-XY: @2 @3 Nxt-XY: @4 @5"
    #      *Cnt 
    #      (round *Prv-X 3) (round *Prv-Y 3) 
    #      (round Nxt-X 3) (round Nxt-Y 3)))
   
  
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

# -------------------------------
(de Sier-Curve (Length Angle N) 
   # Approximate the Sierpinski triangle 
   # variables : A B
   # constants : + −
   # start  : A
   # rules  : (A → +B−A−B+), (B → −A+B+A−)
   # angle  : 60°

   (let 
      (A (chop "+B-A-B+")  
       B (chop "-A+B+A-") 
       C A
       F '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) ) 

      # Generate points
      (do N (setq C (F C)))

      # Plot points
      (map '((R) 
         (case (car R)
            (("A" "B") (Plot-Line Length Angle))
            ("+" (setq Angle (+ Angle PI/3)))
            ("-" (setq Angle (- Angle PI/3))) 
            (T (msg (text "?Sier-Curve: No-match: @1" @))) )) C )

   )
)

# -------------------------------
(de Koch-Curve (Length Angle N) 
   # A variant of the Koch curve which uses only right angles.
   # variables : F
   # constants : + −
   # start  : F
   # rules  : (F → F+F−F−F+F)
   # Here, F means "draw forward", + means "turn left 90°", and − means "turn right 90°"

   (let 
      (A (chop "A+A-A-A+A")  
       C A
       F '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) ) 

      # Generate points
      (do N (setq C (F C)))

      # Plot points
      (map '((R) 
         (case (car R)
            (("A" "B") (Plot-Line Length Angle))
            ("+" (setq Angle (+ Angle PI/2)))
            ("-" (setq Angle (- Angle PI/2))) 
            (T (msg (text "?Koch-Curve: No-match: @1" @))) )) C )

   )
)


# -------------------------------
# Peano Curve
# F -> F+F-F-F-F+F+F+F-F
#(de Peano-Curve (Length Angle N)
#   (let 
#      (A (chop "A+A-A-A-A+A+A+A-A")
#      C A
#      _Fn '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) ) 
#
#      # Generate points
#      (do N (setq C (_Fn C)))
#
#      # Plot points
#      (map '((P)
#         (case (car P)
#            (("A") (Plot-Line Length Angle))
#            ("+" (setq Angle (+ Angle PI/2)))
#            ("-" (setq Angle (- Angle PI/2))) 
#            (("A" "B") NIL)
#            (T (msg (text "?Peano-Curve: No-match: @1" (car P)))) )) C )
#
#   )
#)

# -------------------------------
# rules: {
#      A: 'AFBFA-F-BFAFB+F+AFBFA',
#      B: 'BFAFB+F+AFBFA-F-BFAFB'

(de Peano-Curve (Length Angle N)
   (let
      (A (chop "AFBFA-F-BFAFB+F+AFBFA")
       B (chop "BFAFB+F+AFBFA-F-BFAFB")
      C A
      _Fn '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) )

      # Generate points
      (do N (setq C (_Fn C)))

      # Plot points
      (map '((P)
         (case (car P)
            (("F") (Plot-Line Length Angle))
            ("+" (setq Angle (+ Angle PI/2)))
            ("-" (setq Angle (- Angle PI/2)))
            (("A" "B") NIL)
            (T (msg (text "?Peano-Curve: No-match: @1" (car P)))) )) C )


  )
)
 

# -------------------------------
# Hilbert curve 
# (L -> +RF-LFL-FR+) 
# (R -> -LF+RFR+FL-)

(de Hilbert-Curve (Length Angle N) 
   (let 
      (A (chop "+BF-AFA-FB+") 
       B (chop "-AF+BFB+FA-") 
       C A
       _Fn '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) ) 

      # Generate points
      (do N (setq C (_Fn C)))

      # Plot points
      (map '((P)
         (case (car P)
            (("F") (Plot-Line Length Angle))
            ("+" (setq Angle (+ Angle PI/2)))
            ("-" (setq Angle (- Angle PI/2))) 
            (("A" "B") NIL)
            (T (msg (text "?Hilbert-Curve: No-match: @1" (car P)))) )) C )

   )
)

# -------------------------------
# Moore curve 
# Alphabet: L, R
# Constants: F, +, −
# Axiom: AFA+F+AFA
# Production rules:
# A -> −BF+AFA+FB−
# B -> +AF−BFB−FA+

(de Moore-Curve (Length Angle N) 
   (let 
      (A (chop "-BF+AFA+FB-")
       B (chop "+AF-BFB-FA+")
       C (chop "AFA+F+AFA") 
       _Fn '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) ) 

      # Generate points
      (do N (setq C (_Fn C)))

      # Plot points
      (map '((P)
         (case (car P)
            (("F") (Plot-Line Length Angle))
            ("+" (setq Angle (+ Angle PI/2)))
            ("-" (setq Angle (- Angle PI/2))) 
            (("A" "B") NIL)
            (T (msg (text "?Moore-Curve: No-match: @1" (car P)))) )) C )

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

# ---------------------------------------
(de Run-Sier-Curve (Length Angle N Cnt)
   
   (setq *Plot NIL
      *Cnt (ifn Cnt 10000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default N 3)
   
   (Sier-Curve Length Angle N)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "---> Sier-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)

# ---------------------------------------
(de Run-Koch-Curve (Length Angle N Cnt)
   
   (setq *Plot NIL
      *Cnt (ifn Cnt 10000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default N 3)
   
   (Koch-Curve Length Angle N)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "---> Koch-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)

# ---------------------------------------
(de Run-Hilbert-Curve (Length Angle N Cnt)
   
   (setq *Plot '((0.0 0.0)) 
      *Cnt (ifn Cnt 10000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default N 3)
   
   (Hilbert-Curve Length Angle N)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "---> Hilbert-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)

# ---------------------------------------
(de Run-Peano-Curve (Length Angle N Cnt)
   
   (setq *Plot '((0.0 0.0)) 
      *Cnt (ifn Cnt 10000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default N 3)
   
   (Peano-Curve Length Angle N)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "--->Peano-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)

# ---------------------------------------
(de Run-Moore-Curve (Length Angle N Cnt)
   
   (setq *Plot '((0.0 0.0))
      *Cnt (ifn Cnt 10000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default N 3)
   
   (Moore-Curve Length Angle N)
   (setq *Plot (reverse *Plot))
   (ifn (car *Plot) (pop '*Plot))
   
   (msg (text "--->Moore-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      (length *Plot) 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))

)


# ######################################
# GUI Hooks

(setq *CurrentPlot NIL    
      *StepSize 3       
      *Step T           
      *RefreshDelay 500
      *Resume NIL)

(de Draw-Dragon-Curve ()
   (msg ">> Draw Dragon Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T)
   (Run-Dragon-Curve 1.0 0.0 1.0 1000000))

(de Draw-C-Curve ()
   (msg ">> Draw C-Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-C-Curve 16.0 0.0 1000000))

(de Draw-Gosper-Curve ()
   (msg ">> Draw Gosper-Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-Gosper-Curve 1.0 0.0 2 2000000))

(de Draw-Sier-Curve ()
   (msg ">> Draw Sier-Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-Sier-Curve 2.0 0.0 3 2000000))

(de Draw-Koch-Curve ()
   (msg ">> Draw Koch-Curve") 
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-Koch-Curve 2.0 0.0 2 2000000))

(de Draw-Hilbert-Curve (Depth)
   (msg ">> Draw Hilbert-Curve")
   (setq *StepSize 4)
   (default Depth 3)
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-Hilbert-Curve 1.0 0.0 Depth 2000000))

(de Draw-Peano-Curve (Depth)
   (msg ">> Draw Peano-Curve") 
   (setq *StepSize 3)
   (default Depth 2)
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T) 
   (Run-Peano-Curve 1.0 0.0 Depth 2000000))

(de Draw-Moore-Curve (Depth)
   (msg ">>Draw Moore-Curve")
   (setq *StepSize 2)
   (default Depth 3)
   (setq *Delay *RefreshDelay *CurrentPlot NIL *Step T)
   (Run-Moore-Curve 1.0 0.0 Depth 2000000))

(de Stop-Draw ()
   (msg ">> Stop") 
   (setq *Delay -1))

(de Draw-Step ()
   (msg "> Start")
   (setq *Step T *Resume T *Delay *RefreshDelay *Step T))

(de Draw-All ()
   (msg "> Draw rest") 
   (setq *Resume NIL *Step NIL *Delay -1 *Step NIL))


