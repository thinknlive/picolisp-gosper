# picolisp-gosper
## Gosper Curves

An exercise in working with Picolisp Numbers; fixed point precision, scaling.

Generate and render 'Gosper Curves' -- based on code from the book "Lisp" (1st Ed) by Winston and Horn.

## Info

https://en.wikipedia.org/wiki/Bill_Gosper

https://en.wikipedia.org/wiki/Gosper_curve


## Try it out

From the shell cli:
~~~~
pil gosper.l -main -go
~~~~
then point your browser at:
~~~~
http://localhost:8080
~~~~

To try different curve parameters, in file **gosper.l** look for something like
~~~~
(Run-C-Curve 300.0 0.0 1000000)
~~~~
or
~~~~
(Run-Dragon-Curve 4096.0 0.0 2000000)
~~~~

edit to taste (don't forget your decimal place!) and restart gosper.l

## Source Files:
~~~~ 
c-curl.l  -- Generate Gosper curve points
gosper.l  -- Render curve points on canvas, based on code from http://picolisp.com/wiki/?canvasDrawing
~~~~ 

## Todo: Do more with the UI... 
* spigot the results to render the curves gradually
* allow changing curve parameters from the ui.

## Sample Output

![Image](https://github.com/thinknlive/picolisp-gosper/blob/master/c-1.png)


![Image](https://github.com/thinknlive/picolisp-gosper/blob/master/c-2.png)


![Image](https://github.com/thinknlive/picolisp-gosper/blob/master/d-1.png)

![Image](https://github.com/thinknlive/picolisp-gosper/blob/master/d-2.png)

![Image](https://github.com/thinknlive/picolisp-gosper/blob/master/d-3.png)

