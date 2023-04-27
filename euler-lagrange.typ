#set page(
  numbering: "1",
)
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")
#show link: underline


#align(center, text(17pt)[
  *Euler-Lagrange Equation*
])

#outline()

= Euler-lagrange equation

Euler-Lagrange equation is defined as below.

$ (diff cal(L)) / (diff q_i) - d / (d t) (diff cal(L)) / (diff dot(q_i)) = 0  $ <euler>

where $L$ is Lagrangean, $q_i$ generalized coordinate,
$dot(q)_i$ generalized velocity (generalized coordinate derived w.r.t time).

Lagrangean is defined as
$ L = T − V $
where $T$ is kinetic energy, $V$ potential energy.

When you are thrown at this equations you would understand nothing
and will have hard time to remember, but this is really powerful tool
to analyze mechanics and derive Newtonian equation of motion especially
when it's not in inertial frame of reference.
You would get use to it as you examine useful examples and picture the intuition.

== Derivation

Consider an particle's coordinate $x$ changes over time.
This coordinate can be expressed as a function of time $x(t)$.
Suppose this particle have coordinate $x_0$ at $t = t_0$ and $x_1$ at $t = t_1$.

Let's consider a function of the coordinate and velocity $f(x, dot(x))$.
The integral of this function between $x(t_0) = x_0$ and $x(t_1)=x_1$
is called the action. If we write it down, it will be

$ A = integral_(t_0)^(t_1) f(x(t), dot(x)(t)) dif t $

=== Principle of least Action
We will apply something called the principle of least action here.
The principle of least action tells us that physical phenomena follow the laws that minimize the thing called the action.
As it is the principle, no one can answer why it is true, but it's derived law from experience and observation over thousands of years worth.
For example, if you toss up a ball, it will follow parabolic trajectory, and the light will track the path with shortest travel time (Fermat's principle).
These are examples of laws derived from the principle of least action.
There are other countless examples in electromagnetism, quantum mechanics and relativity.

Also, we assume the action to be continuous function.
The objective from now on is to derive differential equations from fiddling with the action, which yields equation of motion. For this purpose, we don't like the action to be discontinuous function of x
 or non differentiable. In reality, most of physical phenomena can be approximated as continuous functions, so we rarely put the assumption explicitly.

From these assumptions, we can say that searching the minimum is the same as searching the stationary point.
To be precise, the maxima, the saddle points or the extrema can be stationary points, but it seems that the action associated with Lagrange function has only one stationary point at the minimum.
I can't prove that, if you ask me.

A little special thing about the stationary point is that what we want to “station” against is not variables but the function.
We want to fiddle the function shape of $f(x, dot(x))$ to make the $A$ minimum.
The variational principle expresses this by putting $delta$ in front of the function.
That is, the condition of stationary point is

$ delta A = integral_(t_0)^(t_1) delta f(x, dot(x)) dif t = 0 $

Then, what is $delta f(x, dot(x))$ exactly?
In order to think about this, let's discretize $f$ first.
That is, consider $x$ to be discrete values $x_i$ rather than continuous variable.
If we write the interval of $t$ in this discretization as $epsilon$,
we can express $f$ as

$ f(x_i, (x_i - x_(i - 1)) / epsilon). $

Now, what happens to $f$ when we change the value of $i$th value $x_i$?
First, let's write down $f$'s partial derivative at $i$th sample $f_i$ w.r.t. $x_i$,

$ diff / (diff x_i) &= diff / (diff x_i) f (x_i, (x_i - x_(i - 1)) / epsilon) \
&= (diff f_i) / (diff x_i) + (diff v_i) / (diff x_i) (diff f_i) / (diff v_i) \
&= (diff f_i) / (diff x_i) + 1 / epsilon (diff f_i) / (diff v_i)
$
where I defined $v_i ident (x_i - x_(i-1)) / epsilon$ for brevity.

We also need to consider the contribution from $f_i + 1$ to calculate total effect on $(diff f) / (diff x_i)$.

$ diff / (diff x_i) f_(i+1) &= diff / (diff x_i) f(x_(i+1), (x_(i+1) - x_i) / epsilon) \
&= (diff v_(i + 1)) / (diff x_i) (diff f_(i + 1)) / (diff v_(i + 1)) \
&= - 1 / epsilon (diff f_(i + 1)) / (diff v_(i + 1))
$

Therefore, the net change is

$ (diff f_i) / (diff x_i) + 1 / epsilon (diff f_i) / (diff v_i) - 1 / epsilon (diff f_(i + 1)) / (diff v_(i + 1)). $

Now, $(f_(i + 1) - f_i) / epsilon$ is nothing but derivative in the limit of $epsilon -> 0$.
Also, $v_i$ becomes the derivative of position w.r.t. time, that is, velocity.

Taking the limit yields

$ (diff f_i) / (diff x_i) - d / (d t) (diff f_i) / (diff dot(x)_i) = 0. $

At the limit of continuous function, the subscript $i$ disappears and the variable t
 becomes continuous variable instead, which yields the Euler-Lagrange @euler.

== Rotating coordinates

Suppose $x,y$ plane is in inertial frame of reference.
Let's consider a frame of reference, $X,Y$, that has common origin and rotates with angular velocity of $omega$.
The conversion of coordinates can be written down as

$
x &= X cos(omega t) + Y sin(omega t) \
y &= X sin(omega t) − Y cos(omega t).
$ <rotating>

Let's examine how a free particle moves in this frame of reference.
The particle will, of course, move in linear motion, but rotating frame of reference does not satisfy Newton's law of motion.
You could transform the coordinate systems from Cartesian coordinates, but it's going be really tedious.
Euler-Lagrange equation is said to be able to derive the law of motion far more easily, but if you actually try it, it's not so easy.

Anyway, a free particle's Lagrangean is, if we assign zero to the potential term,

$ cal(L) = m / 2 (dot(x)^2 + dot(y)^2). $

Now, if we assign @rotating and do grindy calculation,

$ cal(L) = m / 2 (dot(X)^2 + dot(Y)^2) + (omega^2 m) / 2 (X^2 + Y^2)
  + (omega m) / 2 (X dot(Y) - Y dot(X)). $

The first term on the right hand side can be interpreted as kinetic energy from linear motion.
The second term can be interpreted as centrifugal force.
If you assign $r = X^2 + Y^2$ and derive with $r$,
it should be clear that it becomes force towards radially outward.
The last term depends on both position and velocity.
The force exerted from this term is called Coriolis force.

Let's derive Euler-Lagrange equation along $X$ component.

$ (diff cal(L)) / (diff X) - d / (d t) (diff cal(L)) / (diff dot(X)) =
omega^2 m X + (omega m) / 2 dot(Y) - m dot.double(X) + (omega m) / 2 dot(Y) = 0 \
therefore m dot.double(X) = omega^2 m X + omega m dot(Y)
$

If we compare it with $m a = F$, the first term on the right hand side is centrifugal force,
but the second term is proportional to the velocity perpendicular to the $X$ axis.
If you derive the equation similarly for $Y$, you will also get a term proportional to $dot(X)$.
This means Coriolis force is a force perpendicular to velocity vector.
It will not affect the absolute value of velocity vector, which means the kinetic energy will not change due to this force, but the direction will.
It is worth noting that analogous to Lorentz force in electromagnetism where a charged particle moves in a magnetic field.

== Polar coordinates

What happens in polar coordinates?
Polar coordinates frame of reference itself won't change over time, but the coordinates of a moving particle can.
The coordinates are designated by $r, theta$.
The conversion rule is simply

$ x &= r cos(theta) \
  y &= r sin(theta). $

Let's derive free particle's Lagrangean by assigning zero to potential similar to the previous section.

$ cal(L) &= m / 2 (dot(x)^2 + dot(y)^2) \
&= m / 2 (dot(r)^2 + r^2 dot(theta)^2)
$

Now, from the Euler-Lagrangean equation along $r$ axis,

$ (diff cal(L)) / (diff r) - d / (d t) (diff cal(L)) / (diff dot(r)) &= m r dot(theta)^2 - d / (d t) m dot(r) \
&= m r dot(theta)^2 - m dot.double(r) = 0 \
therefore m r dot(theta)^2 &= m dot.double(r).
$

If we compare this equation to $F = m a$, we can say that the left hand side is a force proportional to $θ^2$,
which is centrifugal force.

Also, from Euler-Lagrange equation along $theta$,

$ (diff cal(L)) / (diff theta) - d / (d t) (diff cal(L)) / (diff dot(theta)) = - m r^2 dot(theta) = 0. $

This is law of angular momentum conservation.

= Symmetry and conservation laws

The law of angular momentum conservation that we derived above is an ad-hoc solution and we would be lost if we introduce more general coordinates. So we consider making the argument general by a set of generalized coordinates.

First, from the variational principle, we can write that

$ delta f(arrow(q)) = sum_i (diff f) / (diff q_i) delta q_i $

where $f(arrow(q))$ is a function depending all of $q_i (i=1,2,…,n)$.
This is the same expression as the total differentiation.

Now, we will define a thing called symmetry.
The symmetry is to add a small derivation to the coordinates (either shifting frame of reference or moving all particles) in a way that won't change Lagrangean.
For example, translation of origin and rotation of coordinates are classified as symmetry.
We can write a variation on a generalized coordinate $delta q_i$ with a set of functions $f_i(arrow(q))$ as

$ delta q_i = f_i (arrow(q)) delta $ <variation>

where $delta$ that is not in front of a variable indicates small value itself.
The equation means the variation can be approximated within $delta$.

Lagrangean is a function of generalized coordinates $q_i$ and generalized velocities $dot(q)_i$,
so it variation can be written as

$ delta cal(L)(arrow(q), arrow(dot(q))) = sum_i ((diff cal(L)) / (diff q_i) delta q_i + (diff cal(L)) / (diff dot(q)_i) delta dot(q)_i). $ <general>

Now, we have derived that if Lagrangean satisfies Euler-Lagrange equation, i.e. satisfies laws of motion, we can say @euler.
For brevity, we introduce a symbol

$ (diff cal(L)) / (diff dot(q)_i) ident p_i. $ <Lqdotp>

which is synonymous to momentum in classical mechanics, but it can represent more abstract quantity in quantum mechanics.

With this we can rewrite Euler-Lagrange equation as

$ (diff cal(L)) / (diff q_i) = dot(p)_i. $ <Lqpdot>

We can use this to rewrite @general as

$ delta cal(L)(arrow(q), arrow(dot(q))) = sum_i (dot(p)_i delta q_i + p_i delta dot(q)_i) $

With the law of derivative of product, we can also write

$ delta cal(L)(arrow(q), arrow(dot(q))) = d / (d t) sum_i p_i delta q_i. $ 

Now, let's say $delta q_i$ is a variation that is generated from symmetry.
Then, Lagrangean should not change, so we can write with @variation

$ d / (d t) sum_i p_i delta q_i &= d / (d t) sum_i p_i f_i (arrow(q)) delta \
&= 0.
$

By factoring out $delta$, we can write

$ d / (d t) sum_i p_i f_i (arrow(q)) = 0 $

Then, the quantity inside derivative w.r.t. time,

$ Q ident sum_i p_i f_i (arrow(q)) $

is the value to be conserved.

If you compute this in actual coordinates, it becomes the law of momentum conservation or angular momentum conservation.

This is an application of #link("https://en.wikipedia.org/wiki/Noether%27s_theorem")[Noether's theorem].

= Time translational symmetry and energy conservation

In the previous section, we have derived momentum conservation law from the symmetry of translation and rotation.
Now we will derive energy conservation law from time translational symmetry.

Time translational symmetry means there is no explicit dependence of Lagrangean to time variable.
In other words, Lagrangean is a function of only $q_i, dot(q)_i$.
We can also express this as $cal(L)(arrow(q), arrow(dot(q)))$.

Now, let's write derivative of Lagrangean w.r.t. time.

$ (d cal(L)(arrow(q), arrow(dot(q)))) / (d t) = sum_i { (diff cal(L)) / (diff q_i) dot(q)_i + (diff cal(L)) / (diff dot(q)_i) dot.double(q)_i }. $

Here we can use @Lqdotp and @Lqpdot to reduce it to

$ (d cal(L)) / (d t) = sum_i (p_i dot(q) + dot(p)_i dot.double(q)_i). $

Now we use the law of differentiation on product again. This kind of tricks occur over and over again. We don't have much variety on that.

$ (d cal(L)) / (d t) = sum_i d / (d t) p_i dot(q)_i $

Now, we got a equation with both side is derivative w.r.t. time. So we can rewrite as

$ d / (d t) { cal(L) - sum_i p_i dot(q)_i } = 0. $

Here, the contents being derived by time

$ cal(H) ident sum_i p_i dot(q)_i - cal(L) $

is called Hamiltonian.
It seems that the sign of the Hamiltonian is defined in this way by historical reasons.
It means Hamiltonian is conserved when there is time translational symmetry.

Let's write down Hamiltonian in Cartesian coordinates.
The momentum becomes $p_i = m_i dot(x)_i$, so we can write

$ cal(H) &= sum_i p_i dot(q)_i - cal(L) \
&= sum_i [m_i dot(x)_i^2 - { m / 2 dot(x)_i - V(x_i)}] \
&= sum_i { (m dot(x)_i^2) / 2 + V(x_i) }.
$

This is sum of kinetic energy and potential energy, which is total energy.
In general, in a classical system, Hamiltonian becomes total energy.
In quantum mechanics, we cannot write down Hamiltonian this easily as the sum of kinetic and potential energy, nevertheless conserved quantity.

Now what will happen if there is no time translational symmetry.
We can repeat the argument from (8) through (9) with the condition that $cal(L)$ has explicit time dependence $cal(L)(arrow(q), arrow(dot(q)), t)$, which yields

$ (d cal(L)) / (d t) &= sum_i d / (d t) p_i dot(q)_i + (diff cal(L)) / (diff t) \
(d cal(H)) / (d t) &= - (diff cal(L)) / (diff t).
$

Why we get a negative sign in this equation is the matter of definition. No matter how its sign is defined, the fact that Hamiltonian is conserved won't change.

== Hamilton's equations

Let's obtain total differentiation of Hamiltonian.

$ d cal(H) = sum_i [ dot(q)_i d p_i + p_i d dot(q) - (diff cal(L)) / (diff dot(q)_i) d dot(q)_i - (diff cal(L)) / (diff q_i) d q_i] $

We can apply partial derivative to each of $p_i$ and $q_i$ to the Hamiltonian to obtain

$ (diff cal(H)) / (diff p_i) &= dot(q)_i \
 (diff cal(H)) / (diff q_i) &= - dot(p)_i $

These are Hamilton's equations.

= References
+ #link("https://www.youtube.com/watch?v=3apIZCpmdls")[Leonard Susskind, Classical Mechanics | Lecture 3]
+ #link("https://www.youtube.com/watch?v=ojEwHlyty4Q")[Leonard Susskind, Classical Mechanics | Lecture 4]
+ #link("https://www.youtube.com/watch?v=lW9GJ0aiaNc")[Leonard Susskind, Classical Mechanics | Lecture 5]
+ #link("https://en.wikipedia.org/wiki/Noether%27s_theorem")[Wikipedia's Noether's theorem article]