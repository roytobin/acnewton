#!
# GNU APL

# A testsuite for the acnewton package.  Construct valid ordered pairs (arclen, chordlen)
# that can be used to exercise the package which computes the diameter of circle.

# These are the desired ratios (arclen ÷ chordlen) to create.

ratio ← <<<
 1.00005
 1.00004
 1.00003
 1.00002
 1.00001
 1.0009
 1.0008
 1.0007
 1.0006
 1.0005
 1.0004
 1.0003
 1.0002
 1.0001
 1.009
 1.008
 1.007
 1.006
 1.005
 1.004
 1.003
 1.002
 1.001
 1.1
 1.2
 1.3
 1.4
 1.5
 1.57
>>>
ratio ←,ratio

# These are the various chord lengths, as measurements ranging from small to large
#
chord01 ← 3e¯6 3e¯5 3e¯4 3e¯3 3e¯2 3e¯1  1 2 3 4 5 8 7 11 16 31 32 64 113 128 256 512 599 1024 2000

outer ← ratio ∘.{(⍵×⍺) ⍵} chord01

testsuite01 ← ,outer

⍝ Call the solver mirroring its native LH/RH api and print, but do not return, the result
∇arc driver chord  ; d
    d ← arc acnewton∆solve chord
    ⎕ ← 'Results as arc, chord, iterations, diameter'
    ⎕ ← arc chord acnewton∆param.count d
∇

⍝ Call the solver with a ordered pair as the RH and print, but do not return, the result
∇driver2 argpair ;arc  ;chord  ;d
    (arc chord) ← argpair
    d ← arc acnewton∆solve chord
    ⎕ ← 'Results as arc, chord, iterations, diameter'
    ⎕ ← arc chord acnewton∆param.count d
∇

⍝ Call the solver with a ordered pair as the RH and print the result.
∇d ← driver3 argpair ;arc ;chord
    (arc chord) ← argpair
    d ← arc acnewton∆solve chord
∇

∇z ← timeit suite  ;tnaught  ;t
    tnaught←24 60 60 1e3⊥3↓⎕ts
	z ← driver3¨ suite
    t←24 60 60 1e3⊥3↓⎕ts
    ⎕← 'elapsed ' (t - tnaught)
∇
