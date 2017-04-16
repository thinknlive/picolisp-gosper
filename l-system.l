# 20170303 Lindsay Lawrence
# Generate L-Systems

# --------------------------------------------------
# Recursive implementation that emits state changes.

(de plotLSys (L) (mapc prin L))

(de fnLSys (X)
   (cond
      ((= X "A") A)
      ((= X "B") B)
      (T (list X)) ) )

(de runLSys (L D)
   (if (>= D _MaxDepth)
      (plotLSys L)
      (mapc
         '((X) (runLsys (fnLSys X) (inc D)))
         L ) ) ) 

(de gosperR (MaxDepth)    
  (let
    (A (chop "A-B--B+A++AA+B-")
     B (chop "+A-BB--B-A++A+B"))
      
    (default MaxDepth 1)
    
    (runLSys A 1)))

# -----------------------------------------------------

(de plotLSys (L)
  (mapc prin L) )

(de fnLSys (L)
   (fish atom (mapcar  
      '((X) 
         (cond 
            ((= X "A") A) 
            ((= X "B") B) 
            (T X))) L) ) ) 


(de runLSys (L D)
  (if (>= D MaxDepth)
    (plotLSys L) 
    (map '((X) 
      (runLSys 
        (fnLSys (list (car X))) 
        (inc D))) L)) )
    
# ----------------------------------------------------
# Generate Hilbert curves with recursive implementation

(de hilbertR (MaxDepth)    
  (let
    (A (chop "−BF+AFA+FB−")
     B (chop "+AF−BFB−FA+"))
      
    (default MaxDepth 6)
    
    (runLSys A 1)))

# ----------------------------------------------------
# Generate Gosper curves with recursive implementation
# This is very scalable. i
#     : (bench (nil (GosperR 12)) (msg (text "EmitCount: @1" EmitCount)))
#     "EmitCount: 32,296,336,801"
#     2519.859 sec
# That is 32GB... for n=12.

(de gosperR (MaxDepth)    
  (let
    (A (chop "A-B--B+A++AA+B-")
     B (chop "+A-BB--B-A++A+B"))
      
    (default MaxDepth 1)
    
    (runLSys A 1)))

# ----------------------------------------------------------------------
# Generate L-sytem Gosper curve states with iterative implementation.
# Iteration, in this case, is not nearly as scalable as recursion
# as it generates the entire list at once in memory.
 
(de gosper (N)
  (let
      (A (chop "A-B--B+A++AA+B-")
         B (chop "+A-BB--B-A++A+B")
         C A
         _Fn '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) )

      (do N (setq C (_Fn C)))
      (length (prin C))))
    
# ----------------------------------
# Generate Cantor set on real line R
# variables : A B
# constants : none
# start  : A {starting character string}
# rules  : (A → ABA), (B → BBB)
# Let A mean "draw forward" and B mean "move forward".

(de cantorR (MaxDepth)
  (let
    (A (chop "ABA")
     B (chop "BBB"))

    (default MaxDepth 2)

    (l-Run A 1)))
 
# ---------------------
# Pythagoras tree[edit]
# variables : 0, 1
# constants: [, ]
# axiom  : 0
# rules  : (1 → 11), (0 → 1[0]0)
 
(de pythagorasR (MaxDepth)
  (let
    (A (chop "B[A]A")
     B (chop "BB"))

    (default MaxDepth 2)

    (l-Run A 1)))

# ---------------------------------------------------------
# A variant of the Koch curve which uses only right angles.
# variables : F
# constants : + −
# start  : F
# rules  : (F → F+F−F−F+F)
# Here, F means "draw forward", + means "turn left 90°", and − means "turn right 90°"

(de kochR (MaxDepth)
   (let
      (A (chop "A+A-A-A+A"))

      (default MaxDepth 2)

      (l-Run A 1)))

(de peanoR (MaxDepth)
   (let
      (A (chop "A+A-A-A-A+A+A+A-A"))

      (default MaxDepth 2)

      (l-Run A 1)))


# --------------------------------------------------
# Generate Gosper using a 'co routine
# (GosperGen T)   # STOP
# (out "test.dat" (do (* 1024 1024 10) (prin (GosperGen))))

(de gosperGen (D)
   (if (=T D)
      (co 'gospergen)
      (co 'gospergen
         (let
            (A (chop "A-B--B+A++AA+B-") 
               B (chop "+A-BB--B-A++A+B")
               _MaxDepth D 
               _Plot '((L) (mapc yield L))
               _Fn
               '((X)
                  (cond
                     ((= X "A") A)
                     ((= X "B") B)
                     (T (list X)) ) )
               _L-Run
               '((L D)
                  (if (>= D _MaxDepth)
                     (_Plot L)
                     (mapc
                        '((X) (_L-Run (_Fn X) (inc D)))
                        L ) ) ) ) 
            (default _MaxDepth 13)
            (_L-Run A 1) ) ) ) ) 

(de peanoGen (D)
   (if (=T D)
      (co 'peanogen)
      (co 'peanogen
         (let
            (A (chop "A+A-A-A-A+A+A+A-A") 
               _MaxDepth D 
               _Plot '((L) (mapc yield L))
               _Fn
               '((X)
                  (cond
                     ((= X "A") A)
                     (T (list X)) ) )
               _L-Run
               '((L D)
                  (if (>= D _MaxDepth)
                     (_Plot L)
                     (mapc
                        '((X) (_L-Run (_Fn X) (inc D)))
                        L ) ) ) ) 
            (default _MaxDepth 13)
            (_L-Run A 1) ) ) ) ) 

(de ThueMorseGen (D)
   (if (=T D)
      (co 'thuemorsegen)
      (co 'thuemorsegen
         (let
            (A (chop "AB") 
               B (chop "BA")
               _MaxDepth D 
               _Plot '((L) (mapc yield L))
               _Fn
               '((X)
                  (cond
                     ((= X "A") A)
                     ((= X "B") B)
                     (T (list X)) ) )
               _L-Run
               '((L D)
                  (if (>= D _MaxDepth)
                     (_Plot L)
                     (mapc
                        '((X) (_L-Run (_Fn X) (inc D)))
                        L ) ) ) ) 
            (default _MaxDepth 13)
            (_L-Run A 1) ) ) ) ) 

(de HilbertGen (D)
   (if (=T D)
      (co 'hilbertgen)
      (co 'hilbertgen
         (let
            (A (chop "+BF-AFA-FB+") 
               B (chop "-AF+BFB+FA-")
               _MaxDepth D 
               _Plot '((L) (mapc yield L))
               _Fn
               '((X)
                  (cond
                     ((= X "A") A)
                     ((= X "B") B)
                     (T (list X)) ) )
               _L-Run
               '((L D)
                  (if (>= D _MaxDepth)
                     (_Plot L)
                     (mapc
                        '((X) (_L-Run (_Fn X) (inc D)))
                        L ) ) ) ) 
            (default _MaxDepth 13)
            (_L-Run A 1) ) ) ) ) 



