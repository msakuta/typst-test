#import "template.typ": *

#set math.equation(numbering: "(1)")
#set heading(numbering: "1.")

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Neural Networks",
  authors: (
    "Masahiro Sakuta",
  ),
)

#outline()

= A little bit of history

The history of neural networks is like a series of emerging waves.
It oscillates between periods of hyped and lost interest from the society like @fig:timeline.

#figure(
  image("neuralnetwork-timeline.png"),
  caption: [A brief timeline of neural networks]
) <fig:timeline>

Its origins can be traced back to the 1940s.
It is based on the formal neuron model proposed by Warren McCulloch and Walter Pitts, but the most important in history is the perceptron published in 1958 by Frank Rosenblatt.
However, the perceptron was difficult to scale up with the hardware of the time, and efficient learning methods had not been established, so the learning speed did not reach a practical level.

After that, neural networks entered a dark age for a while, but a brief revival occurred in the 1980s when backpropagation using the sigmoid function was invented.
However, it still entered another dark age again because it did not produce a practical level of performance.

The tide has changed at the 2009 NIPS Workshop, where the Deep Belief Net implemented by Geoff Hinton produced a better score than any other state-of-the-art algorithms at that time.
Around that time, convolutional neural networks were getting popular.
They are good at image recognition in particular.
Since then, artificial intelligence is dominated by deep learning to the point that just the word AI implies deep learning.

#figure(
  image("tahc_rosenblatt-sepia.jpg", width: 50%),
  caption: [Probably the most famous historical photo of AI history, a portrait of Frank Rosenblatt]
)

= The model of the Perceptron

The activation function of the first model of perceptron proposed by Rosenblatt was a step function like @eq_step

$ S(x) = cases(1 & 0 < x , 0 & "otherwise") $ <eq_step>

This was because the model of a neuron was thought to have active and inactive states like @step.

#figure(
  image("step.png", width: 60%),
  caption: [A step function]
) <step>

However, sigmoid function became popular for an activation function since it became clear that derivative is necessary for backpropagation.
This function is advantageous for activation function since it has derivatives over the whole range of input variable, but it doesn't have a basis on real neurons.

A sigmoid function is defined like @eq_sigmoiod and it looks like @sigmoid.

$ sigma(x) = 1 / (1 + e^(-x)) $ <eq_sigmoiod>

#figure(
  image("sigmoid.png", width: 60%),
  caption: [A sigmoid function]
) <sigmoid>

The sigmoid function is good and smooth, but the output range is fixed between 0 and 1, so it cannot represent an arbitrary function and has an issue called vanishing gradient.
Therefore, the sigmoid function is not without its shortcomings.

As a result, ReLU (Regularized Linear Unit) which is defined as @eq_relu is often used these days.
It looks like @relu.
This function does not require a relatively expensive exponential function, since it is simple combination of identity and constant functions.
Another advantage of it is that it has a value range from $0$ to $infinity$, and the derivative can be defined over the entire range of the variable.
At this point, the analogy of biological neuron is like thrown out of the window.

$ R(x) = cases(x & 0 < x, 0 &  "otherwise") $ <eq_relu>

#figure(
  image("relu.png", width: 60%),
  caption: [A ReLU function]
) <relu>

Note that you could think of the simplest activation function as the identity transformation $f( x ) = x$.
If you use it, however, no matter how deep the neural network architecture you are using, it can be collapsed into a single linear transformation, so it would be incapable of representing nonlinearity.
Also, since the entire network can be collapsed into one linear transformation, there would be no point having intermediate layers.

There are a lot of variants of ReLU, in attempt to overcome the limitation of flat derivative part.
One of them is SiLU (Sigmoid Linear Unit), a sigmoid multiplied by a proportional function.
It looks like ReLU as a whole, but the derivative is not zero over the whole value range.

$ sigma(x) = x / (1 + e^(-x)) $ <eq:silu>

#figure(
  image("silu.svg", width: 60%),
  caption: [A SiLU function]
) <silu>

= Feed Forward Neural Network

Feedforward simply means transmitting a signal in the forward direction.

For example, consider a simple neural network like @feedforward.

#figure(
  image("feedforward.png", width: 50%),
  caption: [Feedforward neural network]
) <feedforward>

The input is represented as $s_i ( i = 1 , 2 , ... ,n( 1 ))$, the weights of the first layer as $w^((1))_(i j) ( j = 1 , 2 , ... ,n( 2 ))$, then the signal from the input layer to the hidden layer $s^((1))_j$ is transmitted as @eq_feedforward1.

$ s^((1))_j = f( sum_(i = 1)^n w^((1))_(i j) s_i) $ <eq_feedforward1>

here $f(dot)$ is the activation function described in the previous section.

Furthermore, the weights of the second layer are $w^((2))_(j k)$, the signal in the output layer $s^((2))_k$ becomes

$ s^((2))_k = f( sum_(j = 1)^n w^((2))_(j k) s^((1))_j). $ <eq_feedforward2>

From the discussion so far, it is obvious that the number of hidden layers can be increased arbitrarily.

You could also use matrix multiplication to represent @eq_feedforward1 or @eq_feedforward2.

$ bold(s)^((1)) &= f( W^((1)) bold(s) ) \
  bold(s)^((2)) &= f( W^((2)) bold(s)^((1)) ) $

Here, $W$ is a matrix and $bold(s)$ is a column vector.

Parallel computing utilizing GPU is really good at this kind of computation.
There are many math libraries that can do this, such as MATLAB, SciPy, NumPy, and Pandas.

= Bias term

In practice, we often put a constant input in each layer, unaffected by previous layers. These inputs are called biases.

#figure(
  image("bias.png", width: 50%),
  caption: [A neural network with a bias term]
) <bias>


The usefulness of this is to have constant degrees of freedom in the arguments of the activation function.
For example, Let the last signal in the input layer $s_n$ be a constant value $1$.
Then we can transform @eq_feedforward1 into

$ s^((1))_j = f(w_(0 j) + sum_(i = 1)^n w^((1))_(i j) s_i) $

This is effectively the same as shifting the origin of the activation function by $-w_(0 j)$.
In this way, the offset of the origin can be included in the weight matrix and the offset need not be considered as a separate optimization target.
In Rosenblatt's perceptron, the activation threshold is a separate parameter from the weight, which increases the complexity of multi-layering.

We can also add a bias term to the intermediate layer.

$ s^((2))_k = f(w^((2))_(0 k) + sum_(j = 1)^n w^((2))_(j k) s^((1))_j) $

A more concise way to put it is to include a constant term in the input signal.
So $bold(s)$ will be $(s_1, s_2, ... s_n, 1)$ an we can simply write

$ bold(s)^((1))_j &= f(W^((1)) bold(s)) \
  bold(s)^((2))_j &= f(W^((2)) bold(s^((1)))) = f(W^((2)) f(W^((1)) s)) $

= Backpropagation

When training a neural network, a technique called backpropagation is used.

First, let's define the cost function $L$, which is a indication of the magnitude of the deviation from ground truth answer.
This is defined in terms of the ground truth $A_k$ and the predicted answer $s^((2))_k$ as @eq_l.
Here, the reason why the deviation from the ground truth is squared isn't entirely clear, but it will become clear in a later section.

$ L = 1 / 2 sum_k(A_k - s^((2))_k)^2 $ <eq_l>

== Gradient of the Weights on the First Layer

First, let's think about how we can modify the output layer weights $w^((2))_(j k)$ so that the prediction get closer to the correct answer.
It means finding the direction of motion in $bold(w)$ space that decreases $L$, so we can take gradient of $L$ with respect to each element of $bold(w)$.
In other words, compute $(diff L)/(diff w^((2))_(j k))$.
We can use this gradient and the learning rate parameter $delta$ to define the update rule for the $bold(w)$ as @eq_w.
The weight of the next step can be obtained by subtracting the gradient multiplied by $delta$.

$ lr( w^((2))_(j k) |)_(t+1) = lr(w^((2))_(j k)|)_t - delta lr((diff L)/(diff w^((2))_(j k))|)_t $ <eq_w>

This corresponds to the gradient descent method in the optimization problem, and we will discuss later in dropout whether it falls into a local solution in a multifaceted solution space.

Calculating the second term on the right-hand side of @eq_w, from the chain rule of composite functions,

$ - delta (diff L)/(diff w^((2))_(j k)) &= - delta (diff L)/(diff s^((2))_k ) (diff s^((2))_k)/(diff w^((2))_(j k)) \
&= delta (A_k - s^((2))_k) (diff s^((2))_k)/(diff w^((2))_(j k)) $

and can be easily calculated from only the difference between the teacher signal answer and the predicted answer.

Let's focus on the second half $(diff s^((2))_k)/(diff w^((2))_(j k))$.
Since the variables are related with the activation function $f$ through @eq_feedforward2 like below.
we can simplify the calculation by placing an intermediate variable $p^((2))_k$, which is the argument given to $f$.

$ p^((2))_k equiv sum_(j=1)^n w^((2))_(j k) s^((1))_j $ <eq:p>

Here we can use the chain rule again to yield

$ (diff s^((2))_k) / (diff w^((2))_(j k)) = (diff s^((2))_k) / (diff p^((2))_k) (diff p^((2))_k)/(diff w^((2))_(j k)). $

$(diff s^((2))_k)/(diff p^((2))_k)$ is the derivative of the activation function $f'$.

Also we can use

$ (diff p^((2))_k) / (diff w^((2))_(j k)) &= diff / (diff w^((2))_(j k)) sum_(j=1)^n w^((2))_(j k ) s^((1))_j \
&=s^((1))_j $

to represent

$ (diff s^((2))_k) / (diff w^((2))_(j k)) = s^((1))_j f'(p^((2))_k) $

Once again we write the entire @eq_w as

$ lr(w^((2))_(j k)|)_(t+1) = lr(w^((2))_(j k)|)_t + delta (A_k - s^((2))_k) s^((1))_j f'(p^((2))_k) $

From here, it is obvious that backpropagation requires that the activation function can be derived.

Here we can use a little trick when the activation function is a sigmoid function.

$
(diff sigma) / (diff x) &= diff / (diff x) 1 / (1 + e^(-x)) \
&= e^(-x) 1 / (1 + e^(-x))^2 \
&= (1 + e^(-x) - 1) / (1 + e^(-x)) 1/(1 + e^(-x)) \
&= (1 - 1 / (1 + e^(-x))) 1 / (1 + e^(-x)) \
&= (1 - sigma) sigma
$

Using this, @eq_w can be further rewritten as follows:

$ lr(w^((2))_(j k)|)_(t + 1) = lr(w^((2))_(j k)|)_t + delta (A_k - s^((2))_k) s^((1))_j (1 - s^((2))_k) s^((2))_k $

== Backpropagating to the first layer

Now, let's focus on the hidden layer weights $w^((1))_(i j)$.
We can replace the weight of $w^((1))_(i j)$ in @eq_w like below.

$ lr( w^((1))_(i j) |)_(t+1) = lr(w^((1))_(i j)|)_t - delta lr((diff L)/(diff w^((1))_(i j))|)_t $ <eq_w1>

However, the method of applying the chain rule will change.
Since there is an index variable $k$ which is neither the final indices $i, j$,
the whole derivative becomes total derivative, not the partial derivative.

$ (diff L) / (diff w^((1))_(i j)) &= sum_k (diff L) / (diff s^((2))_k) (diff s^((2))_k) / (diff w^((1))_(i j)) \
&= sum_k (diff L) / (diff s^((2))_k) (diff s^((2))_k) / (diff s^((1))_j) (diff s^((1))_j) / (diff w^((1))_(i j)) \
&= sum_k underbracket((diff L) / (diff s^((2))_k), (1))
         underbracket((diff s^((2))_k) / (diff p^((2))_k), (2))
         underbracket((diff p^((2))_k) / (diff s^((1))_j), (3))
         underbracket((diff s^((1))_j) / (diff w^((1))_(i j)), (4)) $

Wow, there are a lot of factors!
Let's disect them into pieces.

(1) we already calculated $(diff L) / (diff s^((2))_k) = A_k - s^((2))_k$.

(2) we already calculated $(diff s^((2))_k) / (diff p^((2))_k) = f'(p^((2))_k)$.

(3) can be calculated using @eq:p.

$ (diff p^((2))_k) / (diff s^((1))_j) &= diff / (diff s^((1))_j) sum_(j = 1)^n w^((2))_(j k) s^((1))_j \
 &= w^((2))_(j k) $

In summary, this whole summation can be reused to reduce the computation in the next layer.
Let's call it $L^((1))_j$ for it being the "loss function" for the next layer.
#footnote[Technically, it is a _derivative_ of the loss function, but we don't want to put any more fancy notations.]
Note that it is a vector of $j$ elements.

$ L^((1))_j &equiv sum_(k = 1)^(n_k) (diff L) / (diff s^((2))_k) (diff s^((2))_k) / (diff p^((2))_k) (diff p^((2))_k) / (diff s^((1))_j) \
 &= sum_(k = 1)^(n_k) (A_k - s^((2))_k) f'(p^((2))_k) w^((2))_(j k) $

This is the crucial part of the backpropagation.
We are considering a neural network with 2 layers, but you can imagine extending this logic to many layers indefinitely.

Now, we want to calculate (4), but to make them simplier, let's define an intermediate variable like before:

$ p^((1))_j = sum_(i = 1)^n w^((1))_(i j) s_i $

Using this, we can write (4) as

$ (diff s^((1))_j) / (diff w^((1))_(i j)) &= (diff s^((1))_j) / (diff p^((1))_j) (diff p^((1))_j) / (w^((1))_(i j)) \
 &= f'(p^((1))_j) diff / (diff w^((1))_(i j)) sum_(i = 1)^n w^((1))_(i j) s_i \
 &= s_i f'(p^((1))_j) $

The whole expression becomes

$ (diff L) / (diff w^((1))_(i j)) = L^((1))_j s_i f'(p^((1))_j) $

With a neural network of only few layers, we cannot really feel the benefits of reusing the previous layer's computation.
However, the number of repeated computations grow exponentially as the layers get deeper, so this technique is essential to the large scale deep learning.
The idea of this algorithm is a bit like FFT butterfly operation.

Calculation is performed in order from the output side to the input side, so it is called backpropagation.

= Batch training

Loss function given in @eq_l was the result for only one sample.
If we calculate all $N$ samples together, we get the following (we are running out of space for subscripts,
but the superscript $[l]$ indicates the $l$th sample):

$ L = 1/2 sum_(l = 1)^N ∑_k (A_k^[ l ] - s_k^((2) [ l ]))^2 $

Since the partial derivatives are independent for each sample, the second term of the right side of @eq_w is as follows.

$ -delta (diff L) / (diff w^((2))_(j k)) &= -delta sum_(l = 1)^N (diff L) / (diff s^((2) [l])_k) (diff s^((2) [l])_k) / (diff w^((2))_(j k)) \
 &= -delta sum_(l = 1)^N (A_k - s^((2) [l])_k) (diff s^((2) [l])_k) / (diff w^((2))_(j k)) \
 &= -delta sum_(l = 1)^N (A_k - s^((2) [l])_k) s^((1) [l])_j f'(sum_(j = 1)^N w^((2))_(j k) s^((1) [l])_j) $

It is obvious that the gradient of the hidden layer can be calculated in the same way.

Batch training is a method of determining the gradient direction from the loss functions of multiple samples at once.
On the other hand, as we saw in the previous section, calculating the gradient direction from each sample one by one is called online training or stochastic gradient descent.
There is also a method called mini-batch, where you train repeatedly with a sample size in bite-sized chunks.
Each has advantages and disadvantages as described below.

- Batch training has high stability and fast convergence because it descends a gradient that smoothes the data with variability.
- Online training is swayed by noise in individual data, so convergence is poor, but it can be applied to very large training data that cannot be stored in memory.

= Appendix

== All You Need to Know about Derivatives

You should know a little calculus to understand how neural networks work (or any machine learning algorithms in that regard).
Your high school should have taught you about it, but the world is a diverse place now and I don't know if you had that opportunity.
#footnote[Surprisingly many people don't have a clear idea of basic calculus, even in the field of AI research.
I hope the reader is not one of them, or quit being an imposter like them.]

I have tried to teach how the machine learning works to several people, and found out that some people have really hard time understanding it.
Right now my theory why is that these people didn't understand basic math including calculus.

=== Ordinary derivatives

The definition of derivative is as follows:

$ (d f) / (d x) = lim_(epsilon -> 0) (f(x + epsilon) - f(x)) / epsilon $ <eq:derive>

The notion like $(d f)/(d x)$ was invented by Leibniz, who is also credited as one of the inventors of the calculus.
The other person in credit that invented calculus at the same time (how that could happen was an interesting story for another time) is Newton.
He also invented his version of notation, like $dot(f)$.
It is sometimes written as $f'$ too, although I don't know who invented it.

The Leibniz notation has an advantage that it indicates a variable that derive $f$ with respect to.
It is especially handy with partial derivatives.
The Newton notation implies that the function is derived with respect to time variable, so it has limits when you want to apply it to other variables.

Let's do some exercies with basic functions.
Consider a function @eq:square.

$ f(x) = x^2 $ <eq:square>

Let's put it into @eq:derive.

$ (d f) / (d x) = lim_(epsilon -> 0) ((x + epsilon)^2 - x^2) / epsilon $

You can calculate the denominator inside the limit as follows:

$ (x + epsilon)^2 - x^2 &= x^2 + 2 epsilon x + epsilon^2 - x^2 \
&= epsilon (2 x + epsilon)
$

Now, we can reduce the $epsilon$ to 0, since nothing is in the factor of $epsilon$.

$ (d f) / (d x) = lim_(epsilon -> 0) (2 x + epsilon) = 2 x $

You won't calculate the derivatives like this every time, but you can find tables of derivatives of common functions on the web.
Basic ones like polynomials are worth memorizing since they are not too complex.

$ (d x^n) / (d x) = n x^(n-1) $

Another important technique to calculate derivatives is the chain rule.
Suppose we had a function $f(x)$ which is in turn a variable of another function $g(f(x))$.
Then we can calculate the derivative of $g$ with respect to $x$ using this "chain of derivatives".

$ (d g) / (d x) = (d g) / (d f) (d f) / (d x) $

It is not very clear with this abstract notation, so let's use an example functions like below.

$ g(f) &= f^2 \
  f(x) &= x + a $

Here, $a$ is a constant.

We can calculate the derivative of each function like below.

$ (d g) / (d f) &= 2f \
  (d f) / (d x) &= x $

So the result of the whole derivative is:

$ (d g) / (d x) = 2x (x + a) $

Remember that you can define the intermediate function however you like.
So if your function is given like this:

$ g(x) = (x + a)^2 $

you can see that you can define an intermediate function $f(x) = x + a$.
This is one of the most basic technique to derive a complicated function.

There are few other techniques like derivative of products, but I won't go into details.

=== Partial derivatives

Partial derivatives are derivatives on a function with multiple independent variables.
For example, suppose we have a function with 2 variables, $f(x, y)$.
The notion of each partial derivative with respect to each variable is like below.

$ (diff f) / (diff x), (diff f) / (diff y) $

When you compute a partial derivative, you fix the other variables as if they were constants.
For example, let's take a function like below.

$ f(x, y) = x^2 + y^2 $

Partial derivatives are calculated like below.

$ (diff f) / (diff x) = 2 x, (diff f) / (diff y) = 2 y $


=== Total derivatives

A less known variant of derivatives is called total derivatives.
It is a derivative of a function with multiple variables, like partial derivatives, but it incorporates both variables.

$ d f = (diff f) / (diff x) d x + (diff f) / (diff y) d y $

The notable thing about total derivatives is that it doesn't specify a derived variable.
In a sense, it is a template of derivatives that can adapt to any variable.

It is useful when the variables $x, y$ are not independent.
For example, if they are both dependent on the third variable, $z$, we can write like $x(z), y(z)$.
Then, we can calculate like below:

$ (d f) / (d z) = (diff f) / (diff x) (d x) / (d z) + (diff f) / (diff y) (d y) / (d z) $

Another way to put it is that it is kind of a version of chain rule with multiple variables.

=== Conclusion

As you can see, the value of derivative is that it reduces the idea of taking limits (which drives minds crazy) into mere manipulation of symbols.
It is one of the most successful mathematical tools and still a valuable tool in the age of computers to analyze complicated models in the world, as you are witnessing with deep learning.
