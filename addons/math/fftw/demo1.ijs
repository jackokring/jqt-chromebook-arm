require 'numeric trig'


0 : 0
function s = f(x)

global n % Number of terms

s = 0;
for k = 1:(2*n-1)
  s = s - 1/(pi*k)*(2*cos(pi*k)-2)*sin(k*x);
end

)

N=: 10

f=: 3 : 0
p=. 1p1
s=. 0
for_k. }. i. 2 * N do.
  s=. s - (% p * k) * (_2 + 2 * cos(p * k)) * sin (k * y)
end.

)

plot | fftw f i.200
