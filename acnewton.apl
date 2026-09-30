#!
# GNU APL (not Dyalog) package name acnewton.
# Given an arc length of a circle and its corresponding chord length, compute
# the diameter of the circle via Newton-Raphson root finding numerical method.
# Function acnewton∆init -- initialize package; enter parameters for subsequent computation
# Function acnewton∆validate -- assure the inputs satisify constraints
# Function acnewton∆solve -- solve for diameter
# Function acnewton∆newton -- internal utility function implementing Newton's method to find root
# Variable acnewton∆param -- data used internally by the package
# Yes, the package name reflects the internal algorithm used.

)sic

acnewton∆param.tolerance ← 1e¯12
acnewton∆param.tolerance ← 1e¯11	⍝ Seems that a )clear ⎕ct (comparison tolerance) is 1e¯13
acnewton∆param.maxiter   ← 22
acnewton∆param.count     ← 0
acnewton∆param.arc     ← 'uninitialized'
acnewton∆param.chord   ← 'uninitialized'

∇acnewton∆init args  ;tol  ;mi
    (tol mi) ← 2⍴ args
    acnewton∆param.tolerance ← tol	⍝ relative delta between iterations eg. 1e¯11..1e¯6
    acnewton∆param.maxiter   ← mi	⍝ non-pathological cases converge before 22 iterations
    acnewton∆param.count ← 0		⍝ Possible reporting of the # of iterations it took
∇

#⎕io←0
# iter ← ⍳30  # debugging

#)erase acnewton∆newton
∇z ← acnewton∆newton d  ;prod  ; numerator  ;quo
    quo ← acnewton∆param.arc ÷ d
    prod ← d × 1○ quo
    numerator ← d × prod - acnewton∆param.chord
    z ← d - numerator ÷ acnewton∆param.chord - acnewton∆param.arc × 2○ quo
∇

⍝     Validate the input before attempting a "solve" function.
⍝     Return 0 if all is OK.  Else an error number indicating the problem.
⍝     1. both arc and chord must be >0 since these are length measurements.
⍝     2. arc÷chord ratio must be in the interval (1, pi/2] to have a circle solution.
⍝     The central angle described by the arc measurement is presumed to be acute
⍝     or obtuse; it cannot be a reflex angle.
∇res ← acnewton∆validate argpair  ;arc ;chord ;pi
    (arc chord) ← 2⍴ argpair
    pi ← ○1

    res ← ¯1
    →(chord ≤ 0.0) ⍴0
    res ← 0
    res ← res ∨  arc ≤ 0.0
    res ← res ∨ (arc÷chord) ≤ 1.0
    res ← res ∨ (arc÷chord) > pi÷2.0
∇

#)erase acnewton∆solve
∇diam ← arc acnewton∆solve chord  ;relativeDelta  ;count  ;naught

    count ← 0
    #iter[count] ← chord	⍝ BUG: global vector iter must be defined outside this function
    naught ← chord		⍝ initial d-naught estimate of the diameter

    acnewton∆param.count ← ¯1	⍝ negative one indicates iteration count information not stored
    acnewton∆param.arc    ← arc
    acnewton∆param.chord  ← chord
Refine:
    #diam ← iter[1+count] ← acnewton∆newton iter[count]	⍝ remember all intermediate approximations
    diam ← acnewton∆newton naught
    #→(iter[1+count] = iter[count])⍴0  # Alden's way of terminating the iteration.  Presume ⎕CT?

    #relativeDelta ← (iter[1+count] - iter[count]) ÷ iter[1+count]  # debugging
    relativeDelta ← (diam - naught) ÷ diam

    count ← count+1
    #acnewton∆param.count ← count  # debugging -- to disclose to outside how many iterations it took

    ⍝ GNU APL dyadic branch
    ⍝    N→COND        ⍝ same as →(COND)/(⎕LC+N)
    ⍝    LABEL→COND    ⍝ same as →(COND)/LABEL

    ⍝ [classic] →(acnewton∆param.tolerance > |relativeDelta) ⍴0
    ⍝ GNU APL dyadic branch is read: goto <label> if expression
    RETURN → acnewton∆param.tolerance > |relativeDelta

    ⍝ [classic] →(count > acnewton∆param.maxiter) ⍴NoConverge  ⍝ usually 30
    #NoConverge → count > acnewton∆param.maxiter

    naught ← diam

    ⍝ GNU APL dyadic branch is read: goto <label> if expression
    Refine → count ≤ acnewton∆param.maxiter

NoConverge:
    ⍞←'Warning: The (arc chord ratio) input does not converge quickly enough: ' arc chord (arc÷chord)
    ⎕←''  ⍝ newline
    acnewton∆param.count ← count
RETURN:
∇
