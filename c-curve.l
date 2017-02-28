(scl 8)
(load "@lib/math.l")

(setq PI/4 (*/ 1.0 3.14159265 4.0)
      SQRT-2  (sqrt 2.0 1.0)
      *Min-Length (sqrt 7.0 1.0)
      *Cnt 10000
      *Prv-X 0.0 
      *Prv-Y 0.0
      *Plot NIL
      *Min-X NIL *Max-X NIL 
      *Min-Y NIL *Max-Y NIL)

(de Connect-Line (Nxt-X Nxt-Y)
    #(msg (text "---> Cnt: @1 Prv-XY: @2 @3 Nxt-XY: @4 @5"
    #      *Cnt 
    #      (round *Prv-X 2) (round *Prv-Y 2) 
    #      (round Nxt-X 2) (round Nxt-Y 2)))
   (setq *Plot (cons (list Nxt-X Nxt-Y) *Plot)
      *Min-X   (min Nxt-X (or *Min-X Nxt-X))
      *Max-X   (max Nxt-X (or *Max-X Nxt-X))
      *Min-Y   (min Nxt-Y (or *Min-Y Nxt-Y))
      *Max-Y   (max Nxt-Y (or *Max-Y Nxt-Y))
      *Prv-X Nxt-X 
      *Prv-Y Nxt-Y)
)

(de Plot-Line (L A)
   # (msg (text "#### Length: @1 Angle: @2 Cnt: @3" (format L *Scl) (format A *Scl) *Cnt))
   (Connect-Line
      (+ *Prv-X (*/ L (cos A) 1.0))
      (+ *Prv-Y (*/ L (sin A) 1.0)))   
)

# ##########
# C Curve

(de Run-C-Curve (Length Angle Cnt)
   (setq *Plot NIL
      *Cnt (ifn Cnt 1000 Cnt)
      *Prv-X 0
      *Prv-Y 0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (C-Curve Length Angle)
   (msg (text "---> C-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
       *Cnt 
       (round *Min-X 2) (round *Min-Y 2) 
       (round *Max-X 2) (round *Max-Y 2)))
#   (msg (text "==== Plot: @1" *Plot))
)
   
(de C-Curve (Length Angle) 
   (cond 
      ((< Length *Min-Length) (Plot-Line Length Angle)) 
      (T (when (gt0 (dec '*Cnt))
            (C-Curve (*/ 1.0 Length SQRT-2)
                     (+ Angle PI/4))
            (C-Curve (*/ 1.0 Length SQRT-2)
                     (- Angle PI/4))))))        

# #############
# Dragon Curve

(de Run-Dragon-Curve (Length Angle Sign Cnt)
   (setq *Plot NIL
      *Cnt (ifn Cnt 1000 Cnt)
      *Prv-X 0.0
      *Prv-Y 0.0
      *Max-X NIL *Max-Y NIL
      *Min-X NIL *Min-Y NIL)
   (default Sign +1.0)
   (Dragon-Curve Length Angle Sign Cnt)
   (msg (text "---> Dragon-Curve Cnt: @1 Min-XY: @2 @3 Max-XY: @4 @5"
      *Cnt 
      (round *Min-X 2) (round *Min-Y 2) 
      (round *Max-X 2) (round *Max-Y 2)))
#   (msg (text "==== Plot: @1" *Plot))
)
 
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

