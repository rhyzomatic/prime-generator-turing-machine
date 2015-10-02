# prime-generator-turing-machine
A prime generator written for a Turing machine written in Racket. Requires `simply.scm`, a set of functions designed for use with the [Simply Scheme](https://www.cs.berkeley.edu/~bh/ss-toc2.html) book. You can install the package for DrRacket from [here](http://planet.racket-lang.org/display.ss?package=simply-scheme.plt&owner=dyoo).

## Usage

To run the turing machine, do:
```racket
> (prime-gen 71)
'("S101101110111110111111101111111111101111111111111p1111111111111111swq^00" n)
```

`prime-step` will continue to call itself until it runs out of zeroes, at which point it will return the current tape and state. Add more zeroes if you want more primes, but be warned, it will get very slow.

## The algorithm

My algorithm uses 14 states and 10 symbols. It assumes the tape is all zeroes at the start.

Operations: Right is notated by `R`, left by `L`, print symbol `x` by `Px`, and `a` at the end of the operation means put the machine in state `a`.

The general outline: 

1. First prints `S1011w`.
2. Prints out an new number one longer than the previous prime.
3. Places a `p` to the left of the last prime.
4. Checks if the new number is divisible by the prime to the right of the `p`.
5. If so, add one to the number. If not, check the next prime to the left.
6. If it reaches the `S` (start), begins the algorithm again at step 2.

State | Symbol | Operation
------|--------|---------------------------
a     | s      | Pt b
      | p      | c
      | else   | L a
b     | q      | Px a
      | 0      | L d
      | else   | R b
c     | t      | Ps
      | q      | a
      | 0      | Pq L e
      | else   | R c
d     | x      | Pq L d
      | t,s    | P1 L d
      | p      | Pw L d
      | 0      | Pp f
      | S      | h
      | w,l    | L d
e     | x      | Pq L e
      | t      | P1 L e
      | p      | P0 g
      | else   | L e
f     | w      | a
      | l      | Ps R f
      | else   | f
g     | q      | L Pw L j
      | else   | R g
h     | w      | P0 Rh
      | q      | P1 Rh
      | 0      | Pw L i
      | else   | R h
i     | 0      | Pp k
      | else   | L i
j     | 0      | Pp f
      | else   | L j
k     | 0      | Pq m
      | else   | R k
m     | l      | Ps n
      | p      | f
      | else   | L m
n     | 0      | Pq m
      | p      | R n
begin | else   | Ps R P1 R R P1 R P1 R Pw i

