#import "template.typ": *

#set math.equation(numbering: "(1)")

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Neural Networks",
  authors: (
    "James",
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

$ sigma(x) = 1 / (1 + e^x) $ <eq_sigmoiod>

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


= Feed Forward Neural Network

Feedforward simply means transmitting a signal in the forward direction.

For example, consider a simple neural network like @feedforward.

#figure(
  image("feedforward.png", width: 50%),
  caption: [Feedforward neural network]
) <feedforward>

The input is represented as $s_i ( i = 1 , 2 , … ,n( 1 ))$, the weights of the first layer as $w^((1))_(i j) ( j = 1 , 2 , … ,n( 2 ))$, then the signal from the input layer to the hidden layer $s^((1))_j$ is transmitted as @eq_feedforward1.

$ s^((1))_j = f( sum_(i = 1)^n w^((1))_(i j) s_i) $ <eq_feedforward1>

here $f(dot)$ is the activation function described in the previous section.

Furthermore, the weights of the second layer are $w^((2))_(j k)$, the signal in the output layer $s^((2))_k$ becomes

$ s^((2))_k = f( sum_(j = 1)^n w^((2))_(j k) s^((1))_j). $ <eq_feedforward2>

From the discussion so far, it is obvious that the number of hidden layers can be increased arbitrarily.

You could also use matrix multiplication to represent @eq_feedforward1 or @eq_feedforward2.

$ s^((1)) &= f( bold(w)^((1)) dot bold(s) ) \
s^((2)) &= f( bold(w)^((2)) dot bold(s)^((1)) ) $

Parallel computing utilizing GPU is really good at this kind of computation.
There are many Python math libraries that can do this, such as MATLAB, SciPy, NumPy, and Pandas.

= Bias term

In practice, we often put a constant input in each layer, unaffected by previous layers. These inputs are called biases.

#figure(
  image("bias.png", width: 50%),
  caption: [A neural network with a bias term]
) <bias>


The usefulness of this is to have constant degrees of freedom in the arguments of the activation function.
For example, Let the last signal in the input layer $s_n$ be a constant value $1$.
Then we can transformed @eq_feedforward1 into

$ s^((1))_j = f(w_(n j) + sum_(i = 1)^n w^((1))_(i j) s_i) $

This is effectively the same as shifting the origin of the activation function by $−w_(n j)$.
In this way, the offset of the origin can be included in the weight matrix and the offset need not be considered as a separate optimization target.
In Rosenblatt's perceptron, the activation threshold is a separate parameter from the weight, which increases the complexity of multi-layering.

= Backpropagation

When training a neural network, a technique called backpropagation is used.

First, let's define the cost function $L$, which is a indication of the magnitude of the deviation from ground truth answer.
This is defined in terms of the ground truth $A_k$ and the predicted answer $s^((2))_k$ as @eq_l.
Here, the reason why the deviation from the ground truth is squared isn't entirely clear, but it will become clear in a later section.

$ L = 1 / 2 sum_k(A_k − s^((2))_k)^2 $ <eq_l>

First, let's think about how we can modify the output layer weights $w^((2))_(j k)$ so that the prediction get closer to the correct answer.
It means finding the direction of motion in $bold(w)$ space that decreases $L$, so we can take gradient of $L$ with respect to each element of $bold(w)$.
In other words, compute $(diff L)/(diff w^((2))_(j k))$.
We can use this gradient and the learning rate parameter $delta$ to define the update rule for the $bold(w)$ as @eq_w.
The weight of the next step can be obtained by subtracting the gradient multiplied by $delta$.

$ lr( w^((2))_(j k) |)_(t+1) = lr(w^((2))_(j k)|)_t - delta lr((diff L)/(diff w^((2))_(j k))|)_t $ <eq_w>

This corresponds to the gradient descent method in the optimization problem, and we will discuss later in dropout whether it falls into a local solution in a multifaceted solution space.

Calculating the second term on the right-hand side of @eq_w, from the chain rule of composite functions,

$ − delta (diff L)/(diff w^((2))_(j k)) &= − delta (diff L)/(diff s^((2))_k ) (diff s^((2))_k)/(diff w^((2))_(j k)) \
&= − delta (A_k − s^((2))_k) (diff s^((2))_k)/(diff w^((2))_(j k)) $

and can be easily calculated from only the difference between the teacher signal answer and the predicted answer.

Let's focus on the second half $(diff s^((2))_k)/(diff w^((2))_(j k))$.
Since the variables are related with the activation function $f$ through @eq_feedforward2,
we can simplify the calculation by placing an intermediate variable $p_k$, which is the argument given to $f$.

$ p_k ident sum_(j=1)^n w^((2))_(j k) s^((1))_j $

Here we can use the chain rule again to yield

$ (diff s^((2))_k) / (diff w^((2))_(j k)) = (diff s^((2))_k) / (diff p_k) (diff p_k)/(diff w^((2))_(j k)). $

$(diff s^((2))_k)/(diff p_k)$ is the derivative of the activation function $f'$.

Also we can use

$ (diff p_k) / (diff w^((2))_(j k)) &= diff / (diff w^((2))_(j k)) sum_(j=1)^n w^((2))_(j k ) s^((1))_j \
&=s^((1))_j $

to represent

$ (diff s^((2))_k) / (diff w^((2))_(j k)) = s^((1))_j f′(p_k) $

Once again we write the entire @eq_w as

$ lr(w^((2))_(j k)|)_(t+1) = lr(w^((2))_(j k)|)_t − delta (A_k − s^((2))_k) s^((1))_j f′(p_k) $

From here, it is obvious that backpropagation requires that the activation function can be derived.

Here we can use a little trick when the activation function is a sigmoid function.

$
(diff σ) / (diff x) &= diff / (diff x) 1 / (1 + e^(−x)) \
&= e^(−x) 1 / (1 + e^(−x))^2 \
&= (1 + e^(−x) - 1) / (1 + e^(−x)) 1/(1 + e^(−x)) \
&= (1 − 1 / (1 + e^(−x))) 1 / (1 + e^(−x)) \
&= (1 − sigma) sigma
$

Using this, @eq_w can be further rewritten as follows:

$ lr(w^((2))_(j k)|)_(t + 1) = lr(w^((2))_(j k)|)_t − delta (A_k − s^((2))_k) s^((1))_j (1 − s^((2))_k) s^((2))_k $

In addition, let's think about what the hidden layer weights $w^((1))_(i j)$ will be.
We can replace the weight of $w^((1))_(i j)$ in @eq_w, but the method of applying the chain rule will change.
Since there is a index variable $k$ which is neither the final indices $i, j$,
the whole derivative becomes total derivative, not the partial derivative.

$ (diff L) / (diff w^((1))_(i j)) &= sum_k (diff L) / (diff s^((2))_k) (diff s^((2))_k) / (diff w^((1))_(i j)) \
&= sum_k (diff L) / (diff s^((2))_k) (diff s^((2))_k) / (diff s^((1))_j) (diff s^((1))_j) / (diff w^((1))_(i j)) $

here, $(diff L) / (diff s^((2))_k)$ is nothing but the term calculated in the previous step $A_k − s^((2))_k$.
This can be used to reuse parts of the computation.
With a neural network of only few layers, we cannot really feel the benefits, but in fact, as the depth of the hidden layer increases, the number of intermediate variables increases, so the number of parts that can be reused in calculations increases steadily.
In other words, if the calculation is performed from the output side first, there is a calculation result that can be reused in the next stage.
In particular, reuse of computation is important in deep neural networks because the amount of computation increases in the order of the depth of the layer to the power of the number of weighting factors per layer.
The idea of ​​this algorithm is a bit like his FFT butterfly operation.

In this way, calculation is performed in order from the output side to the input side, so it is called back propagation.
