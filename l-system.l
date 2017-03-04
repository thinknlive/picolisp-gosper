# 20170303 Lindsay Lawrence
# Generate L-Systems

# --------------------------------------------------
# Recursive implementation that emits state changes.

(de Plot (L)
  (map '((X) (prin (car X))) L) )

(de Fn (L)
  (let R
    (fish atom 
      (mapcar '((X) 
        (cond 
          ((= X "A") A) 
          ((= X "B") B) 
          (T X))) L) )
    R))

(de L-Run (L D)
  (cond
    ((>= D MaxDepth)
      (Plot L) )
    (T (map '((X) 
      (L-Run 
        (Fn (list (car X))) 
        (inc D))) L)) ) )
    

# ----------------------------------------------------
# Generate Gosper curves with recursive implementation
# This is very scalable. i
#     : (bench (nil (GosperR 12)) (msg (text "EmitCount: @1" EmitCount)))
#     "EmitCount: 32,296,336,801"
#     2519.859 sec
# That is 32GB... for n=12.

(de GosperR (MaxDepth)    
  (let
    (A (chop "A-B--B+A++AA+B-")
     B (chop "+A-BB--B-A++A+B"))
      
    (default MaxDepth 2)
    
    (L-Run A 1)))

# ----------------------------------------------------------------------
# Generate L-sytem Gosper curve states with iterative implementation.
# Iteration, in this case, is not nearly as scalable as recursion
# as it generates the entire list at once in memory.
 
(de Gosper (N)
  (let
      (A (chop "A-B--B+A++AA+B-")
         B (chop "+A-BB--B-A++A+B")
         C A
         F '((L) (fish atom (mapcar '((X) (cond ((= X "A") A) ((= X "B") B) (T X))) L))) )

      (do N (setq C (F C)))
      (length (prin C))))
    
# ----------------------------------
# Generate Cantor set on real line R
# variables : A B
# constants : none
# start  : A {starting character string}
# rules  : (A → ABA), (B → BBB)
# Let A mean "draw forward" and B mean "move forward".
    

(de CantorR (MaxDepth)
  (let
    (A (chop "ABA")
     B (chop "BBB"))

    (default MaxDepth 2)

    (L-Run A 1)))
 
# ---------------------
# Pythagoras tree[edit]
# variables : 0, 1
# constants: [, ]
# axiom  : 0
# rules  : (1 → 11), (0 → 1[0]0)
 
(de PythagorasR (MaxDepth)
  (let
    (A (chop "B[A]A")
     B (chop "BB"))

    (default MaxDepth 2)

    (L-Run A 1)))

# ---------------------------------------------------------
# A variant of the Koch curve which uses only right angles.
# variables : F
# constants : + −
# start  : F
# rules  : (F → F+F−F−F+F)
# Here, F means "draw forward", + means "turn left 90°", and − means "turn right 90°"

(de KochR (MaxDepth)
   (let
      (A (chop "A+A-A-A+A"))

      (default MaxDepth 2)

      (L-Run A 1)))



