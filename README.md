# DFT-visualizer-processing

A little program I wrote to help illustrate how the DFT works, using Processing 3 along with the Sound (by the Processing Foundation) and Ani (by Benedikt Groß) libraries. Each stage of the animation is triggered with a mouse click.

If you're here for the actual DFT algorithm and its inverse, check out UsefulFunctions.pde.

If you would like to futz around with the actual program, click on this magically delicious <a href="https://drive.google.com/file/d/19wzqWW5_m2CbDi08SlxS5tlI6swzSZ2L/view?usp=sharing">download link</a>. (note: Windows only)

## How the DFT works

The discrete Fourier transform works by "transforming" a function of time into a function of frequency, and its inverse does the opposite. Basically, when it's given a waveform signal, it separates the signal into its frequency components. The components, once retrieved, can be manipulated to suit the needs of the user/programmer, and then run through the inverse DFT function to get a new signal. Be warned, this might get complex.

Bad puns aside, the equation for this is:<br>
<a href="https://www.codecogs.com/eqnedit.php?latex=X(k)=\sum_{n=1}^{N}f(n)e^{\frac{-i&space;2&space;\pi&space;k&space;n}{N}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X(k)=\sum_{n=1}^{N}f(n)e^{\frac{-i&space;2&space;\pi&space;k&space;n}{N}}" title="X(k)=\sum_{n=1}^{N}f(n)e^{\frac{-i 2 \pi k n}{N}}" /></a>
<br>where X(k) is the size of the frequency component k, and f(n) is the magnitude of the waveform at time n, which is swept from 1 to N where all values of the waveform are tested to get the result stored in X(k). In terms of programming, it's more practical to think about it the following way:

Each frequency stored in X is actually a complex number, so each frequency component has two sub-components, Re(X(k)) (real) and Im(X(k)) (imaginary). In order to get each, we do this:<br>
<a href="https://www.codecogs.com/eqnedit.php?latex=Re(X(k))=\sum_{n=1}^{N}f(n)\cdot&space;cos(\frac{2&space;\pi&space;k&space;n}{N}),&space;Im(X(k))=\sum_{n=1}^{N}f(n)\cdot&space;-sin(\frac{2&space;\pi&space;k&space;n}{N})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Re(X(k))=\sum_{n=1}^{N}f(n)\cdot&space;cos(\frac{2&space;\pi&space;k&space;n}{N}),&space;Im(X(k))=\sum_{n=1}^{N}f(n)\cdot&space;-sin(\frac{2&space;\pi&space;k&space;n}{N})" title="Re(X(k))=\sum_{n=1}^{N}f(n)\cdot cos(\frac{2 \pi k n}{N}), Im(X(k))=\sum_{n=1}^{N}f(n)\cdot -sin(\frac{2 \pi k n}{N})" /></a>
<br>Then we can change any values of X we want, and once we're done, just send it back through the inverse DFT:<br>
<a href="https://www.codecogs.com/eqnedit.php?latex=f(n)=2&space;\cdot&space;\frac{[\sum_{n=1}^{N}Re(X(k))&space;\cdot&space;cos(\frac{2&space;\pi&space;k&space;n}{N})&space;-&space;Im(X(k))&space;\cdot&space;sin(\frac{2&space;\pi&space;k&space;n}{N})]}{N}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?f(n)=2&space;\cdot&space;\frac{[\sum_{n=1}^{N}Re(X(k))&space;\cdot&space;cos(\frac{2&space;\pi&space;k&space;n}{N})&space;-&space;Im(X(k))&space;\cdot&space;sin(\frac{2&space;\pi&space;k&space;n}{N})]}{N}" title="f(n)=2 \cdot \frac{[\sum_{n=1}^{N}Re(X(k)) \cdot cos(\frac{2 \pi k n}{N}) - Im(X(k)) \cdot sin(\frac{2 \pi k n}{N})]}{N}" /></a>
<br>and we'll get a new waveform back.

These equations are useful for digital signal processing, especially in noise removal, because it allows us to cut unwanted frequencies from the signal. The complexity of the full algorithm is O(n<sup>2</sup>). Sounds slow, right? That's because it is. There's a much faster version called the fast Fourier transform, or FFT, which has a complexity of O(n log n), but the code for it is apparently so complicated that I couldn't find many implementation details, if any at all. Oh well. :|
