+++
title = "Reinforcement Learning Reading List"
date = 2018-11-24T11:11:35-06:00
draft = false

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ['Mauricio Tec']

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = ['reinforcement learning']
categories = []

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
# Use `caption` to display an image caption.
#   Markdown linking is allowed, e.g. `caption = "[Image credit](http://example.org)"`.
# Set `preview` to `false` to disable the thumbnail in listings.
[header]
image = ""
caption = ""
preview = true

+++

*Current Draft: 2018-11-26*

Here's a list to Reinforcement Learning ideas and papers. It is mostly for personal research, as part of my work as PhD student at the University of Texas at Austin.

- Course: Research Elective Fall 2019
- Advisor: Prof. Stephen G. Walker

*Note*: This is not an extensive literature review, but a broad overview to guide our research, with the specific goal of exploring and extracting the statistical and probabilistic ideas and areas of opportunity in reinforcement learning literature.

---

## Key concepts

### Multi-armed Bandits

It is the most elementary problem of Reinforcement Learning, and the building block of many algorithms for more complex problems. 

We start with random variables $X\_1, ..., X\_K$ representing the rewards of $K$ possible actions, and we have to decide a sampling strategy so that we maximize the *total reward* over time. Basically, we are interested in $\max(X\_1, ..., X\_K)$. We start with no data--no smart decision available--and at each turn, we must select one of the $X\_i$ from which to sample (or one bandit arm, as in casino machines). 

The reward up to time $T$ is $R\_T = \sum\_{t=1}^T X\_t$. Naively, we could sample each arm several times and then select the arm whose sample has the highest mean; however, the idea is to learn quickly and reach high values as soon as possible. 

The simplest version of the problem assumes that the $X\_i$ are independent, and it is already an interesting problem.

The first idea developed in this direction was [Thompson Sampling][thompson] (1933), which boils down to Bayesian inference. We begin by putting a prior belief over the distribution of each $X\_i$ (usually uniform), and at each step we update our posterior belief of the selected arm with the observed value obtained after selecting it. The selection rule is to choose arm $i$ proportionally to our belief of how much its reward is higher than those of the other arms. The usual approach is to simulate a sample from each posterior distribution, and choose the arm whose simulation had the highest sampled value. The simplest version of the algorithm uses a Beta-Bernoulli conjugate model. Gaussian Processes are also used for more complicated tasks. 

Although the idea of Thompson sampling is very old, it remains an active area of research. For example, [Chappelle & Li][chappelle-li] (2011) compare multiple strategies and improvements over Thompson Sampling, it also discusses its optimality. 

Another considerable part of the literature centers around the idea of minimizing the expected *regret* of a strategy $\pi$ up to time $T$, defined as

$$ T\mu\_*  - \sum\_{t=1}^T \mu\_{\pi(t)} $$

where $\mu\_* = \max\_i E(X\_i)$, and $\mu\_{\pi(t)}$ is the mean of the random variable chosen at time $t$ by the sampling strategy $\pi$. The idea of regret was introduced by [Lai and Robbins][lai-robbins] (1985). A recent highly-cited survey is [(Bubeck & Bianchi, 2012)][bubeck-bianchi]. Not surprisingly, the analysis techniques rely on probability concentration inequalities. For example, an application of Hoeffding's inequality leads to the so-called *upper confidence bound* (UCB) rule, namely,
$$
\pi(t) = \mathrm{argmax}_i \; \hat{\mu}_i + \sqrt{\frac{2\log t}{n\_i}}
$$

where $\hat{\mu}_i$ is the empirical mean of the samples from arm $i$, and $n\_i$ is the number of times arm $i$ has been sampled. The second term appearing in this rule takes into account uncertainty and encourages exploration of less frequently selected actions. The contrast is evident: while the Bayesian approach (Thompson sampling) deals with uncertainty via the probability laws of posterior Bayesian inference, the UCB approach uses concentration inequalities. This contraposition is also a common theme in Theoretical Statistics. A common variation to the second term is to multiply it by a by a constant, in an attempt to increase or decrease the effects of uncertainty. 

Both Thompson Sampling and UCB provide a solution to the dilemma of *exploitation* *vs* *exploration*. A simplest approach is to only choose the arm with the highest $\hat{\mu}$, except with a probability $\epsilon$, in which case we choose completely at random. Most of the time, this $\epsilon$-greedy strategy is usually an underperformer. Also $\epsilon$ should ogo to zero eventually, but it is hard to know at which speed it is convenient.


A recent must-read reference is [Riquelme et al][riquelme] (2018), which discusses Deep Bayesian Bandits. Here, the $X\_i$ are not independent and $K$ is very large. In fact, the input space can be treated as a continuous space. Essentially, what deep neural networks do is find common patterns in the input space and effectively reduce $K$. Multi-armed bandit problems are building blocks for more complicated tasks, where often it is necessary to learn from images or other complex data.

Several variants of the multi-armed bandit problem exist. One direction is to add additional structure; for a recent survey and state-of-the-art approach we have [Combes et al][combes] (2017). Another direction is to allow the distribution of the $X\_i$ to change over time: the so-called non-stationary bandits. This is a hard problem, and current approaches can be improved, both theoretically and pragmatically (*c.f.* [Besbes et al][besbes] (2014) and [Wu et al][wu] (2018)).

A natural question is to ask if the principles of multi-armed bandit can be applied to model selection and hyper-parameter tuning in statistics. This technique is known as *Bayesian Optimization* and is also an active area of research. For a recent survey, we can consult [Shahriari et al][shahriari] (2016).

### Reinforcement Learning

 The name reinforcement learning simply refers to the general learning or inference problem where the goal is to maximize a reward signal, but no data is available a priori. Instead, data is generated by trial and error. The difference with multi-armed bandit approach, is that the latter applies to problems where the set of possible choices remains constant. In many situations, actions change the state of the world, and the set or the effect of available of actions.

If we were in Heraclitus world where "no man ever steps in the same river twice", then it would be impossible to learn. To do inference we need repetition, or at least some structure. For this reasons, reinforcement learning has been centered around Markov Decision Processes. For a complete review, a highly-expected recent textbook is [Sutton & Barto][sutton-barto] (2018). Reinforcement Learning van be regarding as building upon the literature of *dynamic programming* and *control theory*. Some people suggest the name of *approximate dynamic programming*, but reinforcement learning is ubiquitous in the Computer Science community.

A Markov Decisions Process (MDP) is composed of the following ingredients: 

1. A state space $S$
2. A set of action sets for each state $\{A\_s \mid s\in S\}$
3. A family of random variables representing rewards for choosing an action $a$ given state $s$ $\{R\_{s,a} \mid s\in S, a\in A\_s\}$
4. A Markov transition function governing the rules of the universe $p(s'\mid a, s)$. 

The possible reward, as well as the transition rules of the universe depend only on the current state $s$ and the decision $a$. For an MDP, the current state $s$ is assumed to be observed. When there is only one state, we are in the multi-armed bandit case. 

The goal of reinforcement learning is to find an optimal *policy* $\pi$, which is a family of rules that assign a probability $\pi(a\mid s)$ to selecting an action $a \in A\_s$, given a current state $S$. Denoting the observed state and selected action at time $t$ as $s(t)$ and $\pi(t)$ respectively, the goal is to maximize $\sum\_{t=1}^T R\_{s(t),  \pi(t)}$, the total reward up-to-time $t$.

There is a variant of an MDP where the state can be unobserved; we call these partially observed MDPs or POMDPs, and they pose several additional challenges.

There are several possible approaches to reinforcement learning. One variant is to use continuous input and action spaces. These approach, more common in the *control theory* literature, often needs the use of differential equations. Some algorithms exploit domain-specific properties of a problem. For example, if trying to learn to play a board game, it can take symmetries into account. When an algorithms seeks learn the transition map $p(s'\mid s, a)$, we call it *model-based*; otherwise, *model-free*. The tendency in Computer Science is to appraise model-free general-purpose algorithms: best exemplified by the efforts of Google's company DeepMind and their algorithm [Alpha Zero][alpha-zero] (2017), the current champion programme of Go, Chess and Backgammon. Engineering literature seems to be more focused on solving POMDPs and model-based methods. Nonetheless, both communities care about both approaches.


Under knowledge of the distribution of the rewards and finite tasks, it is possible to find an optimal policy exactly using the techniques of *dynamic programming*, which use a one-step application of the Markov property. More specifically, given:

- some optimal policy $\pi\_\*$
- remaining total reward $G\_t := \sum\_{u=t}^\infty R\_{s(u), \pi\_\*(u)}$
- the action-value function $Q(s, a):= E[G\_t \mid s, a, \pi\_\*]$

the Markov-property yields
$$
Q(s, a) =  E[R\_{s(t + 1), \pi\_\*(t + 1)}] + \max\_{a'\in A\_s} Q(s(t+1), a')
$$
This equation is known as the [Bellman equation][bellman]. The Markov assumption is implicit here in that $Q$ does not depend on $t$. From knowledge of $Q$ only, we can recover the optimal policy with $\pi\_*(a\mid s) = \mathrm{argmax}_{a'}Q(s, a')$ (or at least an equivalent policy in expectation). If $s$ is a terminal state, then the second summand of the right-hand side of the equation is not included. Thus, under the aforementioned assumptions: we can solve the value of $Q$ for every state and actions leading to a terminal state in one step, and then continue using backward induction. [Sutton & Barto][sutton-barto] explain this in detail in their textbook.

 Often, a discount factor is added to the definition of $G\_t$, so that $G\_t := \sum\_{u=t}^\infty \gamma^{u-t}R\_{s(u), \pi\_*(u)}$. With $0<\gamma < 1$, this guarantees convergence for non finite tasks, and the Bellman equation can be adapted accordingly. However, this as a technical addition, rather than an essential part of the idea. 

### Q-Learning

The Bellman equation leads to several schemes for approximate solutions. One of the most celebrated approaches, with numerous variants and extensions, is $Q$-learning [(Watkins, 1989)][watkins]. We start by creating a table for each possible pair $(s, a)$. Then, at each step of the algorithm, given:

- a current approximation $q$ to $Q$
- a starting state $s$
- a selected action $a$
- a reward $r$ received from choosing $a$
- a new state $s'$ observed after choosing $a$, generated from the environment transition function,

we can perform the update
$$ q(s, a) \leftarrow (1 - \alpha) q(s, a) + \alpha(r + \max\_{a'} q(s', a')) \quad \text{for a learning rate } \quad 0<\alpha<1. $$
Finally, for the next iteration the current state will be $s \leftarrow s'$, the selected action will be $a \leftarrow \mathrm{argmax}_{a' \in A\_{s'}} q(s', a')$ and $r$ will be drawn from the distribution of $R\_{sa}$. We repeat the algorithm until convergence of $q$ or until the rewards reach a desired average level. 

Several remarks of statistical and probabilistic nature are available:
- We are only using a one-step application of the Markov property. Equivalently, the observed reward sample $r$ is only used for one update. Reusing data from the rewards to update more previously visited states is at the heart of temporal difference learning methods, which were behind the first computer programmes to play Backgammon at human-expert level [(Tesauro, 1995)][tesauro].
- The existing Q-learning theory was entirely based on expectations. Surprisingly recently, the term *distributional reinforcement learning* is used an effort to incorporate knowledge of the entire distribution [(Bellemare, 2017)][bellemare]. This open an entire area of opportunity for statisticians. Initial experiments, suggest a benefit from this approach. 
- The distributional approach takes us back to the ideas of Thompson sampling, where it was shown that taking into account exploration and exploitation via posterior sampling is a good idea. These ideas have not been explored in depth.
- The original approach to distributional reinforcement learning used a discrete approximation to an entire distribution, no structure whatsoever. A subsequent approach from the authors is more reasonable and attempts a quantile approximation approach [(Dabney et al., 2017)][dabney]. With this improvement, they outperform existing $Q$-learning approaches. 

Here is another computational remark: for more complicated tasks it is impossible to store the table $Q$ for each possible pair $(s,a)$. Not even using supercomputer! No existing machine is close to be able to store all the possible state-action pairs of chess, not even close. Moreover, even if it was possible, it wouldn't necessarily the smartest thing to do. Since we care about learning fast, we can add a functional form to $Q$. For example, the family of linear approximation methods uses feature maps $\phi(s, a) = (\phi\_1(s, a), ..., \phi\_k(s, a))$ and
$$ Q(s, a) \approx \sum\_k \beta\_k^\top\phi\_k(s, a). $$
The choice of feature maps is non-trivial, and it depends on the domain of application, it can be made of polynomials, sines, cosines, radial basis functions, convolutions, etc.

More generally, we can replace it with any function approximation scheme $f$ and take a loss-function approach. Here is an strategy: regard a transition $(s, a) \to (r, s', a')$ as pseudo data, and define a loss-function kernel
$$
l(\beta \mid s, a, r, s', a') = (r + f(\beta \mid s', a') - f(\beta \mid s, a))^2.
$$
Then we can optimize with respect to $\beta$, so that $f$ will approximate $Q$ by the Bellman equation. This is exactly what is done in Deep Q-Learning [(Mnih et al., 2013)][mnih]. Since deep learning is simply a highly flexible functional model for $f$. This has been useful when learning from image or text data, tasks in which neural networks provide the best known results. 

The above loss kernel is only define for *one* transition. So an usual approach is to use an online optimization algorithm, which can update $f$ with one data point: the usual choice is stochastic gradient descent. It also has been demonstrated that reusing older transitions--known as experience replay [(Lillicrap et al., 2015)][lillicrap]--improves the behaviour. Another alternative is to do batch updates or to have parallel actors learning simultaneously [(Mnih et al., 2016)][mnih-2016].


Another popular and different approach in reinforcement learning problems are Monte Carlo tree-search algorithms. We explain these in the following section.

### MonteCarlo Tree Search (MCTS).  

MCTS is used for tasks composed of repeated playouts, usually when a reward is received only when the playout is completed. This is a common situation in board games, in which the reward signal is imply win or loss at the end of the game.

MCTS was a key tool in developing computer programs capable of defeating master players of Backgammon, Chess and Go. In its heart, it is simply using the theory developed for multi-armed bandits with changing states. A highly-cited review is [(Browne et al., 2012)][browne].

The idea is way simple: 

- We'll solve an independent bandit problem for each state using Thompson sampling, UCB1 or other multiarmed-bandit algorithm.
- A game is played until the end, when a reward is observed, it is propagated back through all the trace that lead to that state.
- For win-loss games, we record at each state the number wins and losses associated when that node has appeared in the game. Wins count +1 and losses as -1.
- In practice, we can't store a table with each and every observed state; so MCTS also contains rules that determine how to grow a tree from a root state using these principles. The idea is to estimate at each state, its best possible future total reward.
- Several possibilities are available: for example, using early stopping for an already seen state, and used its current estimate for backpropagation. Another common strategy is to run several simultaneous monte carlo experiments starting from the fixed current state using the current tree policy, and then update the tree with the results. 
- The MCTS rules fall in 4 types in order of execution: selection, expansion, simulation, backpropagation.



---

## Interesting links

- https://spinningup.openai.com: OpenAI project with pedagogical deep reinforcement learning material, including an updated list of key papers an ideas, as well code exercises to get started.

---

## References

[**Download as bibtex**][bibtex-link]

<!-- To generate this section use pandoc on resources folder: pandoc --filter=pandoc-citeproc --standalone rl-reading-list.md -o rl-reading-list.html -->

<div id="refs" class="references">
<div id="ref-Bellman:1957">
<p>Bellman, Richard. 1957. <em>Dynamic Programming</em>. 1st ed. Princeton, NJ, USA: Princeton University Press.</p>
</div>
<div id="ref-NIPS2014_5378">
<p>Besbes, Omar, Yonatan Gur, and Assaf Zeevi. 2014. “Stochastic Multi-Armed-Bandit Problem with Non-Stationary Rewards.” In <em>Advances in Neural Information Processing Systems 27</em>, edited by Z. Ghahramani, M. Welling, C. Cortes, N. D. Lawrence, and K. Q. Weinberger, 199–207. Curran Associates, Inc. <a href="http://papers.nips.cc/paper/5378-stochastic-multi-armed-bandit-problem-with-non-stationary-rewards.pdf" class="uri">http://papers.nips.cc/paper/5378-stochastic-multi-armed-bandit-problem-with-non-stationary-rewards.pdf</a>.</p>
</div>
<div id="ref-Browne2012">
<p>Browne, Cb, and Edward Powley. 2012. “A survey of monte carlo tree search methods.” <em>Intelligence and AI</em> 4 (1): 1–49. doi:<a href="https://doi.org/10.1109/TCIAIG.2012.2186810">10.1109/TCIAIG.2012.2186810</a>.</p>
</div>
<div id="ref-DBLP:journals/ftml/BubeckC12">
<p>Bubeck, Sébastien, and Nicolò Cesa-Bianchi. 2012. “Regret Analysis of Stochastic and Nonstochastic Multi-Armed Bandit Problems.” <em>Foundations and Trends in Machine Learning</em> 5 (1): 1–122. doi:<a href="https://doi.org/10.1561/2200000024">10.1561/2200000024</a>.</p>
</div>
<div id="ref-NIPS2011_4321">
<p>Chapelle, Olivier, and Lihong Li. 2011. “An Empirical Evaluation of Thompson Sampling.” In <em>Advances in Neural Information Processing Systems 24</em>, edited by J. Shawe-Taylor, R. S. Zemel, P. L. Bartlett, F. Pereira, and K. Q. Weinberger, 2249–57. Curran Associates, Inc. <a href="http://papers.nips.cc/paper/4321-an-empirical-evaluation-of-thompson-sampling.pdf" class="uri">http://papers.nips.cc/paper/4321-an-empirical-evaluation-of-thompson-sampling.pdf</a>.</p>
</div>
<div id="ref-DBLP:conf/nips/CombesMP17">
<p>Combes, Richard, Stefan Magureanu, and Alexandre Proutière. 2017. “Minimal Exploration in Structured Stochastic Bandits.” In <em>Advances in Neural Information Processing Systems 30: Annual Conference on Neural Information Processing Systems 2017, 4-9 December 2017, Long Beach, ca, USA</em>, 1761–9. <a href="http://papers.nips.cc/paper/6773-minimal-exploration-in-structured-stochastic-bandits" class="uri">http://papers.nips.cc/paper/6773-minimal-exploration-in-structured-stochastic-bandits</a>.</p>
</div>
<div id="ref-DBLP:conf/aaai/DabneyRBM18">
<p>Dabney, Will, Mark Rowland, Marc G. Bellemare, and Rémi Munos. 2018. “Distributional Reinforcement Learning with Quantile Regression.” In <em>Proceedings of the Thirty-Second AAAI Conference on Artificial Intelligence, (Aaai-18), the 30th Innovative Applications of Artificial Intelligence (Iaai-18), and the 8th AAAI Symposium on Educational Advances in Artificial Intelligence (Eaai-18), New Orleans, Louisiana, Usa, February 2-7, 2018</em>, 2892–2901. <a href="https://www.aaai.org/ocs/index.php/AAAI/AAAI18/paper/view/17184" class="uri">https://www.aaai.org/ocs/index.php/AAAI/AAAI18/paper/view/17184</a>.</p>
</div>
<div id="ref-LAI19854">
<p>Lai, T.L, and Herbert Robbins. 1985. “Asymptotically Efficient Adaptive Allocation Rules.” <em>Advances in Applied Mathematics</em> 6 (1): 4–22. doi:<a href="https://doi.org/https://doi.org/10.1016/0196-8858(85)90002-8">https://doi.org/10.1016/0196-8858(85)90002-8</a>.</p>
</div>
<div id="ref-journals/corr/LillicrapHPHETS15">
<p>Lillicrap, Timothy P., Jonathan J. Hunt, Alexander Pritzel, Nicolas Heess, Tom Erez, Yuval Tassa, David Silver, and Daan Wierstra. 2015. “Continuous Control with Deep Reinforcement Learning.” <em>CoRR</em> abs/1509.02971. <a href="http://dblp.uni-trier.de/db/journals/corr/corr1509.html#LillicrapHPHETS15" class="uri">http://dblp.uni-trier.de/db/journals/corr/corr1509.html#LillicrapHPHETS15</a>.</p>
</div>
<div id="ref-pmlr-v48-mniha16">
<p>Mnih, Volodymyr, Adria Puigdomenech Badia, Mehdi Mirza, Alex Graves, Timothy Lillicrap, Tim Harley, David Silver, and Koray Kavukcuoglu. 2016. “Asynchronous Methods for Deep Reinforcement Learning.” In <em>Proceedings of the 33rd International Conference on Machine Learning</em>, edited by Maria Florina Balcan and Kilian Q. Weinberger, 48:1928–37. Proceedings of Machine Learning Research. New York, New York, USA: PMLR. <a href="http://proceedings.mlr.press/v48/mniha16.html" class="uri">http://proceedings.mlr.press/v48/mniha16.html</a>.</p>
</div>
<div id="ref-DBLP:journals/corr/MnihKSGAWR13">
<p>Mnih, Volodymyr, Koray Kavukcuoglu, David Silver, Alex Graves, Ioannis Antonoglou, Daan Wierstra, and Martin A. Riedmiller. 2013. “Playing Atari with Deep Reinforcement Learning.” <em>CoRR</em> abs/1312.5602. <a href="http://arxiv.org/abs/1312.5602" class="uri">http://arxiv.org/abs/1312.5602</a>.</p>
</div>
<div id="ref-46647">
<p>Riquelme, Carlos, George Tucker, and Jasper Roland Snoek. 2018. “Deep Bayesian Bandits Showdown.” In. <a href="https://openreview.net/pdf?id=SyYe6k-CW" class="uri">https://openreview.net/pdf?id=SyYe6k-CW</a>.</p>
</div>
<div id="ref-DBLP:journals/pieee/ShahriariSWAF16">
<p>Shahriari, Bobak, Kevin Swersky, Ziyu Wang, Ryan P. Adams, and Nando de Freitas. 2016. “Taking the Human Out of the Loop: A Review of Bayesian Optimization.” <em>Proceedings of the IEEE</em> 104 (1): 148–75. doi:<a href="https://doi.org/10.1109/JPROC.2015.2494218">10.1109/JPROC.2015.2494218</a>.</p>
</div>
<div id="ref-DBLP:journals/corr/abs-1712-01815">
<p>Silver, David, Thomas Hubert, Julian Schrittwieser, Ioannis Antonoglou, Matthew Lai, Arthur Guez, Marc Lanctot, et al. 2017. “Mastering Chess and Shogi by Self-Play with a General Reinforcement Learning Algorithm.” <em>CoRR</em> abs/1712.01815. <a href="http://arxiv.org/abs/1712.01815" class="uri">http://arxiv.org/abs/1712.01815</a>.</p>
</div>
<div id="ref-Sutton1998">
<p>Sutton, Richard S., and Andrew G. Barto. 2018. <em>Reinforcement Learning: An Introduction</em>. Second. The MIT Press. <a href="http://incompleteideas.net/book/the-book-2nd.html" class="uri">http://incompleteideas.net/book/the-book-2nd.html</a>.</p>
</div>
<div id="ref-Tesauro:1995:TDL:203330.203343">
<p>Tesauro, Gerald. 1995. “Temporal Difference Learning and Td-Gammon.” <em>Commun. ACM</em> 38 (3). New York, NY, USA: ACM: 58–68. doi:<a href="https://doi.org/10.1145/203330.203343">10.1145/203330.203343</a>.</p>
</div>
<div id="ref-10.2307/2332286">
<p>Thompson, William R. 1933. “On the Likelihood That One Unknown Probability Exceeds Another in View of the Evidence of Two Samples.” <em>Biometrika</em> 25 (3/4). [Oxford University Press, Biometrika Trust]: 285–94. <a href="http://www.jstor.org/stable/2332286" class="uri">http://www.jstor.org/stable/2332286</a>.</p>
</div>
<div id="ref-Watkins:1989">
<p>Watkins, Christopher John Cornish Hellaby. 1989. “Learning from Delayed Rewards.” PhD thesis, Cambridge, UK: King’s College. <a href="http://www.cs.rhul.ac.uk/~chrisw/new_thesis.pdf" class="uri">http://www.cs.rhul.ac.uk/~chrisw/new_thesis.pdf</a>.</p>
</div>
<div id="ref-Wu:2018:LCB:3209978.3210051">
<p>Wu, Qingyun, Naveen Iyer, and Hongning Wang. 2018. “Learning Contextual Bandits in a Non-Stationary Environment.” In <em>The 41st International Acm Sigir Conference on Research &amp;#38; Development in Information Retrieval</em>, 495–504. SIGIR ’18. New York, NY, USA: ACM. doi:<a href="https://doi.org/10.1145/3209978.3210051">10.1145/3209978.3210051</a>.</p>
</div>
</div>

----

## Reading list

**1\_** 

**2\_** 

**3\_** 

**4\_**

**5\_** 

**6\_** 

**7\_** 

**8\_** 

**9\_** 

**10\_**

**11\_**

**12\_**

**13\_**

**14\_** 

----



[thompson]: https://www.jstor.org/stable/2332286
[chappelle-li]: https://papers.nips.cc/paper/4321-an-empirical-evaluation-of-thompson-sampling
[bubeck-bianchi]: https://arxiv.org/abs/1204.5721
[lai-robbins]: http://www.sciencedirect.com/science/article/pii/0196885885900028
[riquelme]: https://openreview.net/pdf?id=SyYe6k-CW
[combes]: http://papers.nips.cc/paper/6773-minimal-exploration-in-structured-stochastic-bandits
[besbes]: http://papers.nips.cc/paper/5378-stochastic-multi-armed-bandit-problem-with-non-stationary-rewards.pdf
[wu]: https://arxiv.org/abs/1805.09365
[shahriari]: https://ieeexplore.ieee.org/document/7352306
[sutton-barto]: http://incompleteideas.net/book/the-book.html
[alpha-zero]: http://arxiv.org/abs/1712.01815
[bellman]: http://books.google.com/books?id=fyVtp3EMxasC&pg=PR5&dq=dynamic+programming+richard+e+bellman&client=firefox-a#v=onepage&q=dynamic%20programming%20richard%20e%20bellman&f=false
[watkins]: http://www.cs.rhul.ac.uk/~chrisw/new_thesis.pdf
[tesauro]: https://cling.csd.uwo.ca/cs346a/extra/tdgammon.pdf
[bellemare]: https://arxiv.org/abs/1707.06887
[dabney]: https://arxiv.org/abs/1710.10044
[mnih]: http://arxiv.org/abs/1312.5602
[lillicrap]: https://arxiv.org/abs/1509.02971 
[mnih-2016]: http://proceedings.mlr.press/v48/mniha16.pdf
[browne]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.297.3086

[bibtex-link]: https://github.com/mauriciogtec/blog/raw/master/resources/rl-reading-list/rl-reading-list.bib