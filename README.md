# picolisp-gosper
## Fractal Curves

Working with Picolisp numbers; fixed point precision, scaling.

Generate and render fractal curves -- based on code from the book "Lisp" (1st Ed) by Winston and Horn.

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
http://localhost:8080 (or use httpGate)
~~~~

To try different curve parameters, in file **c-curve.l** look for something like
~~~~
(Run-C-Curve 300.0 0.0 1000000)
~~~~
or
~~~~
(Run-Dragon-Curve 4096.0 0.0 2000000)
~~~~

edit to taste (don't forget your decimal place!) and either click the 'reload' button on the ui or restart the service.

## Source Files:
~~~~ 
c-curl.l  -- Generate curve points
gosper.l  -- Render curve points on canvas, based on code from http://picolisp.com/wiki/?canvasDrawing
~~~~ 

## L-system

The Gosper generator code is based on the L-system rules defined at https://en.wikipedia.org/wiki/L-system

## TODO...

Add more L-system functions, in particular, ones that push and pop state.

## Sample Output

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/g-1.png" 
     alt="(Run-Gosper-Curve 64.0 0.0 2 1000000)" 
     width="400" height="300">

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/g-2.png" 
     alt="(Run-Gosper-Curve 64.0 0.0 3 1000000)" 
     width="400" height="300">

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/g-3.png" 
     alt="(Run-Gosper-Curve 64.0 0.0 4 1000000)" 
     width="400" height="300">


<hr>


<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/c-1.png" 
     alt="(Run-C-Curve 64.0 0.0 1000000)" 
     width="400" height="300">

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/c-2.png" 
     alt="(Run-C-Curve 128.0 0.0 1000000)" 
     width="400" height="300">

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/c-3.png" 
     alt="(Run-C-Curve 256.0 0.0 1000000)" 
     width="400" height="300">


<hr>


<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/d-1.png" 
     alt="(Run-Dragon-Curve 128.0 0.0 1.0 1000000)" 
     width="400" height="300">

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/example/d-2.png" 
     alt="(Run-Dragon-Curve 256.0 0.0 1.0 1000000)" 
     width="400" height="300">

<img src="https://github.com/thinknlive/picolisp-gosper/blob/master/d-3.png" 
     alt="(Run-Dragon-Curve 512.0 0.0 1.0 1000000)" 
     width="400" height="300">

:w



<hr>
### License
<small>
Copyright (c) Lindsay Lawrence

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</small>
