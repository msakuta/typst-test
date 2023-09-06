#set page(
  numbering: "1",
)
#set math.equation(numbering: "(1)")
#set heading(numbering: "1.")
#show link: underline

#align(center, text(17pt)[
  *Higher-order automatic differentiation*
])

#outline()

= Overview

Sometimes we want to have more than 1 order differentiation. An example is quadratic programming. However, it is very hard to find literature that can handle more than 1 order differentiation.

= Manual calculation of higher order chain rules

It is possible to calculate higher order chain rules by hand, if the order is finite, but it is notoriously error prone. For example, we already use the chain rule of product for first order derivatives:

$
d / (d x) f g = f (d g) / (d x) + (d f) / (d x) g
$

We can apply the differential and apply chain rule again to obtain:

$
(d^2) / (d x^2) f g &= (d) / (d x) (f (d g) / (d x) + (d f) / (d x) g ) \
 &= (d^2 f) / (d x^2) g + 2 (d f) / (d x) (d g) / (d x) + f (d^2 g) / (d x^2)
$<eq:manual-diff2>

and so on.

You could encode this rule in a Rust code like below #footnote[https://github.com/msakuta/rustograd/blob/c902c7066c19f6df336a2cc1af85e4f430bce99a/src/tape.rs#L364].
Note that we use generics for the value type, and it may not be `Copy`, so they are cloned when they are used more than once.

```rust
Mul(lhs, rhs) => {
    let dlhs = derive(nodes, lhs, wrt)?;
    let drhs = derive(nodes, rhs, wrt)?;
    let d2lhs = derive2(nodes, lhs, wrt)?;
    let d2rhs = derive2(nodes, rhs, wrt)?;
    let vrhs = value(nodes, rhs)?;
    let vlhs = value(nodes, lhs)?;
    let cross = dlhs * drhs;
    d2lhs * vrhs + vlhs * d2rhs + cross.clone() + cross
}
```

We could go as far as @fig:manual-diff2 with this approach.
Here we differentiate a Gaussian function up to the second order differentiation.

$
f(x) &= exp(-x^2) \
(d f) / (d x) &= -2 x exp(-x^2) \
(d^2 f) / (d x^2) &= (-2 + 4 x) exp(-x^2)
$

#figure(
    image("second-derive.svg", width: 70%),
    caption: [A Gaussian distribution and its up to the second order differentiations]
) <fig:manual-diff2>

But it has many obvious problems. It is not scalable, it only works for forward mode differentiation, it can't work for multivariate functions and it feels like not automatic at all.

= Higher Order Automatic Differentiation with Dual Numbers

Another approach that I found in a paper is to use dual numbers, but more than just 2.

To recap, a dual number is something similar to a complex number, having 2 components like $x + y epsilon$.
This $epsilon$ is kind of an imaginary number that represents infinitesimal amount of change.
Being an infinitesimal number, the dual number will be zero if squared: $epsilon^2 = 0$.
Using dual numbers, you can derive product rule, for example:

$
(f + f' epsilon) (g + g' epsilon) = f g + (f g' + g f') epsilon + epsilon^2
$

and you can bring $epsilon^2$ to zero to obtain

$
f g' + g f'
$

which corresponds to

$
d (f g) = f d g + g d f
$

The dual number is just a mathematical symbol to describe the definition of derivatives, that is,

$
f'(x) = lim_(epsilon -> 0) (f(x + epsilon) - f(x)) / epsilon
$

You could use extended dual to compute higher order differentials by having another dual number $x + a epsilon + b eta$.
The calculation should yield the same result as the manually calculated chain rules.

It corresponds to applying the definition of derivatives twice.

$
f''(x) = lim_(eta -> 0) (lim_(epsilon -> 0) (f(x + epsilon + eta) - f(x + eta)) / epsilon - f(x)) / eta
$<eq:diff2>

For example, you can derive the product rule by 3-dual numbers:

$
(x + a epsilon + m eta) (y + b epsilon + n eta) = \
x y + (y a + x b) epsilon + (y m + x n) eta + (y a m + x b n) epsilon eta + a b epsilon^2 + m n eta^2
$

Now, $epsilon$ and $eta$ represent different infinitesimal value (see @eq:diff2).
So they have asymmetric rules of products.

- $epsilon^2 = 2 eta$ (corresponds to $d/(d x) d/(d x)$)
- $epsilon eta = 0$ (corresponds to the third order differentiation, which is ignored)
- $eta^2 = 0$ (corresponds to even higher order differentiations)

So the final expression will be:

$
x y + (y a + x b) epsilon + (y m + x n + 2 a b) eta
$

Here, the coefficients of the $eta$ will be the second order differentiation, because the first and the second term will be subtracted by the definition of differentiation @eq:diff2.

$
y m + x n + 2 a b
$

Now, if you look at it carefully, it corresponds to @eq:manual-diff2.

Another way to look at it that was presented by the paper is to use matrices like below, although they are rarely used in production, because they are too redundant to represent on memory.

$
1 = mat(1, 0, 0; 0, 1, 0; 0, 0, 1), epsilon = mat(0, 2, 0; 0, 0, 2; 0, 0, 0), eta = mat(0, 0, 2; 0, 0, 0; 0, 0, 0)
$

The paper generalizes the method to arbitrary order of differentiation as follows.
First, we represent the $i$-th dual number as $bold(i)_j$.
Then we can write arbitrary function with linear combination of $bold(i)_j$ like below.

$
cal(D) (f) = sum_(j=0)^N f^((j)) bold(i)_j
$

Now, addition and subtraction are easy:

$
cal(D)(f_1 plus.minus f_2) = sum_(j=0)^N (f_i^((j)) plus.minus f_2^((j))) bold(i)_j = cal(D)(f_1) plus.minus cal(D)(f_2)
$

The multiplication is more complicated, but you can obtain:

$
cal(D)(f_1 f_2) = sum_(j=0)^N sum_(k=0)^(N-j) f_1^((j)) f_2^((k)) binom(j + k, k) bold(i)_(j + k)
$

Encoding these rules in Rust code is a bit of hussle, but we can define a type `Dvec` that can handle arbitrary order of differentiations as you can find in the repository #footnote[https://github.com/msakuta/rustograd/blob/dnum/src/dvec.rs].
You can see that the result @fig:dvec-diff2 agrees with the manual differentiation @fig:manual-diff2.

#figure(
    image("second-derive-dvec.svg", width: 70%),
    caption: [A Gaussian distribution differentiations using Dvec]
) <fig:dvec-diff2>


= Generating subgraphs

We can generate subgraphs from existing nodes.
In this way, we can support higher order differentiation or even a function that includes derivatives.

$
f(x) = g(x) + (d h(x))/(d x)
$


= Differentiation of $arctan(y,x)$

To compute differentiation of $arctan(y,x)$,

$
f(x) &= arctan(x) \
(dif f(x))/(dif x) &= ( (dif f^(-1)(x))/(dif x) )^(-1) \
&= ( (dif)/(dif x) tan(x) )^(-1) = ( (dif)/(dif x) (sin(x))/(cos(x)) )^(-1) \
&= ( (cos(x))/(cos(x)) - (sin(x))/(cos^2(x)) )^(-1) = ( (cos^2(x) - sin(x))/(cos^2(x)) )^(-1) \
&= (cos^2(x)) / (cos^2(x) - sin(x))
$


= Differentiation of Matrix Products

Let's say we have matrices $A in bb(R)^(n times m)$ and $B in bb(R)^(m times l)$, both potentially a function of some variable. How do we calculate the derivative $d (A B)$?

First, let's write the total derivative.

$
d {A B_(i j)} = d sum_(k=1)^m a_(i k) space b_(k j)
= sum_(k=1)^m (d a_(i k) space b_(k j) + a_(i k) space d b_(k j))
space (i in [1,n], j in [1,l])
$

Let's consider the case of derivative with respect to $a_(p q)$.
Note that this is a 4th order tensor with indices $i, j, p$ and  $q$.
It's messy, but we will simplify quite a bit later.

$
(diff {A B_(i j)}) / (diff a_(p q)) = (sum_k b_(k j) space diff a_(i k)) / (diff a_(p q)) = b_(q j) delta_(i p)
$

Similarly, we can compute

$
(diff {A B_(i j)}) / (diff b_(p q)) = (sum_k a_(i k) space diff b_(k j)) / (diff b_(p q)) = a_(i p) delta_(j q)
$

The question is, how much contribution does each input variable has to the output variable.
We would have to accumulate the influence through every path that goes through the product.

$
sum_(i=1)^n sum_(j=1)^l (diff {A B_(i j)}) / (diff a_(p q)) &= sum_j b_(q j) \
sum_(i=1)^n sum_(j=1)^l (diff {A B_(i j)}) / (diff b_(p q)) &= sum_i a_(i p)
$ <eq:ab>

Actually, the story is a bit more complicated, because the matrix product is often an intermediate step in the chain of computations.
When we backpropagate, we have a term like below by the product rule.

$
f_(i j) (diff {A B_(i j)}) / (diff a_(p q))
$
where $f_(i j)$ is some arbitrary function.

Therefore, @eq:ab would be written like below, which is really dot products.

$
sum_(i=1)^n sum_(j=1)^l f_(i j) (diff {A B_(i j)}) / (diff a_(p q)) &= sum_j f_(i j) b_(q j) = bold(f)_([i,:]) bold(b)_([q,:])^T = F B^T \
sum_(i=1)^n sum_(j=1)^l f_(i j) (diff {A B_(i j)}) / (diff b_(p q)) &= sum_i f_(i j) a_(i p) = bold(f)_([:,j])^T bold(a)_([:,p]) = F^T A
$

Here, we use notation $bold(b)_([q,:])$ to indicate the $q$-th row vector of $B$ and $bold(a)_([:,p])$ to indicate the $p$-th column vector of $A$, similar to numpy or PyTorch notation,
because I don't know any better way of representing it...

Anyway, it ends up with simple enough matrix multiplications.


= Literature

There are many researches on this topic, but they are much less than the first order differentiation, and they tend to be mathematically abstract and hard to apply. These are the only few papers that I found useful (in the sense that is understandable and implementable by me)

https://kenndanielso.github.io/mlrefined/blog_posts/3_Automatic_differentiation/3_5_higher_order.html

https://pp.bme.hu/eecs/article/download/16341/8918/87511

