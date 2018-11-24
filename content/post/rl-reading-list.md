+++
title = "Reinforcement Learning Reading List"
date = 2018-11-24T11:11:35-06:00
draft = false

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ['Mauricio Tec', 'Stephen Walker']

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


Here's a list to Reinforcement Learning ideas and papers. It is mostly for personal research, as part of my work as PhD student at the University of Texas at Austin.

- Course: Research Elective Fall 2019
- Advisor: Prof. Stephen G. Walker

*Note*: This is not an extensive literature review, but a broad overview to guide our research, with the specific goal of exploring and extracting the statistical and probabilistic ideas and areas of opportunity in reinforcement learning literature.

---

## Key concepts

**Multi-armed Bandits**: It is the most elementary problem of Reinforcement Learning, and the building block of many algorithms for more complex problems. 

We start with random variables $X_1, ..., X_K$ representing the rewards of $K$ possible actions, and we have to decide a sampling strategy so that we maximize the *total reward* over time. Basically, we are interested in $\max(X_1, ..., X_K)$. We start with no data--no smart decision available--and at each turn, we must select one of the $X_i$ from which to sample (or one bandit arm, as in casino machines). 

The reward up to time $T$ is $R_T = \sum\_{t=1}^T X_t$. Naively, we could sample each arm several times and then select the arm whose sample has the highest mean; however, the idea is to learn quickly and reach high values as soon as possible. 

The simplest version of the problem assumes that the $X_i$ are independent, and it is already an interesting problem.

The first idea developed in this direction was [Thompson Sampling][thompson] (1933), which boils down to Bayesian inference. We begin by putting a prior belief over the distribution of each $X_i$ (usually uniform), and at each step we update our posterior belief of the selected arm with the observed value obtained after selecting it. The selection rule is to choose arm $i$ proportionally to our belief of how much its reward is higher than those of the other arms. The usual approach is to simulate a sample from each posterior distribution, and choose the arm whose simulation had the highest sampled value. The simplest version of the algorithm uses a Beta-Bernoulli conjugate model. Gaussian Processes are also used for more complicated tasks. 

Although the idea of Thompson sampling is very old, it remains an active area of research. For example, [Chappelle & Li][chappelle-li] (2011) compare multiple strategies and improvements over Thompson Sampling, it also discusses its optimality. 

Another considerable part of the literature centers around the idea of minimizing the expected *regret* of a strategy $\pi$ up to time $T$, defined as

$$ T\mu_*  - \sum\_{t=1}^T \mu\_{\pi(t)} $$

where $\mu\_* = \max\_i E(X\_i)$, and $\mu\_{\pi(t)}$ is the mean of the random variable chosen at time $t$ by the sampling strategy $\pi$. The idea of regret was introduced by [Lai and Robbins][lai-robbins] (1985). A recent highly-cited survey is [(Bubeck & Bianchi, 2012)][bubbeck-bianchi]. Not suprisingly, the analysis techniques rely on probability concentration inequalities. For example, an application of Hoeffding's inequality leads to the so-called *upper confidence bound* (UCB) rule, namely,
$$
\pi(t) = \mathrm{argmax}_i \; \hat{\mu}_i + \sqrt{\frac{2\log t}{n_i}}
$$

where $\hat{\mu}_i$ is the empirical mean of the samples from arm $i$, and $n_i$ is the number of times arm $i$ has been sampled. The second term appearing in this rule takes into account uncertainty and encourages exploration of less frequently selected actions. The contrast is evident: while the Bayesian approach (Thompson sampling) deals with uncertainty via the probability laws of posterior Bayesian inference, the UCB approach uses concentration inequalities. This contraposition is also a common theme in Theoretical Statistics. A common variation to the second term is to multiply it by a by a constant, in an attempt to increase or decrease the effects of uncertainty. 

Both Thompson Sampling and UCB provide a solution to the dilemma of *exploitation* *vs* *exploration*. A simplest approach is to only choose the arm with the highest $\hat{\mu}$, except with a probability $\epsilon$, in which case we choose completely at random. Most of the time, this $\epsilon$-greedy strategy is usually an underperformer. Also $\epsilon$ should ogo to zero eventually, but it is hard to know at which speed it is convenient.


A recent must-read reference is [Riquelme et al][riquelme] (2018), which discusses Deep Bayesian Bandits. Here, the $X_i$ are not independent and $K$ is very large. In fact, the input space can be treated as a continuous space. Essentially, what deep neural networks do is find common patterns in the input space and effectively reduce $K$. Multi-armed bandit problems are building blocks for more complicated tasks, where often it is necessary to learn from images or other complex data.

Several variants of the multi-armed bandit problem exist. One direction is to add additional structure; for a recent survey and state-of-the-art approach we have [Combes et al][combes] (2017). Another direction is to assume that the $X_i$ change over time, the so-called non-stationary bandits. This is a hard problem, and current approaches can be improved, both theoretically and pragmatically (*c.f.* [Besbes et al][besbes] (2014) and [Wu et al][wu] (2018)).

A natural question is to ask if the principles of multi-armed bandit can be applied to model selection and hyper-parameter tuning in statistics. This technique is known as *Bayesian Optimization* and is also an active area of research. For a recent survey, we can consult [Shahriari et al][shahriari] (2016).

**Reinforcement Learning**. The name reinforcement learning simply refers to the general learning or inference problem where the goal is to maximize a reward signal, but no data is available a priori. Instead, data is generated by trial and error. The difference with multi-armed bandit approach, is that the latter applies to problems where the set of possible choices remains constant. In many situations, actions change the state of the world, and the set or the effect of available of actions.

If we were in Heraclitus world where "no man ever steps in the same river twice", then it would be impossible to learn. To do inference we need repetition, or at least some structure. For this reasons, reinforcement learning has been centered around Markov Decision Processes. For a complete review, a highly-expected recent textbook is [Sutton & Barto][sutton-barto] (2018). Reinforcement Learning van be regarding as building upon the literature of *dynamic programming* and *control theory*. Some people suggest the name of *approximate dynamic programming*, but reinforcement learning is ubiquitous in the Computer Science community.

A Markov Decisions Process (MDP) is composed of the following ingredients: 

1. A state space $S$
2. A set of action sets for each state $\{A_s \mid s\in S\}$
3. A family of random variables representing rewards for choosing an action $a$ given state $s$ $\{R_{s,a} \mid s\in S, a\in A_s\}$
4. A Markov transition function governing the rules of the universe $p(s'\mid a, s)$. 

The possible reward, as well as the transition rules of the universe depend only on the current state $s$ and the decision $a$. For an MDP, the current state $s$ is assumed to be observed. When there is only one state, we are in the multi-armed bandit case. 

The goal of reinforcement learning is to find an optimal *policy* $\pi$, which is a family of rules that assign a probability $\pi(a\mid s)$ to selecting an action $a \in A_s$, given a current state $S$. Denoting the observed state and selected action at time $t$ as $s(t)$ and $\pi(t)$ respectively, the goal is to maximize $\sum_{t=1}^T R_{s(t), \pi(t)}$, the total reward up-to-time $t$.

Under perfect information, that is knowing the transition function $p(s'\mid s, a)$, and assuming the state-space and action sets are small enough, it is possible to solve the problem 

There is a variant of an MDP where the state can be unobserved; we call these partially observed MDPs or POMDPs, and they pose several additional challenges.

There are several possible approaches to reinforcement learning. One variant is to use continuous input and action spaces. These approach, more common in the *control theory* literature, often needs the use of differential equations. Some algorithms exploit domain-specific properties of a problem. For example, if trying to learn to play a board game, it can take symmetries into account. When an algorithms seeks learn $p$, it is known as *model-based$; otherwise, it's said to be model free. The tendency in computer science to appraise model-free general purpose algorithms: best exemplified by the efforts of Google's company DeepMind and their algorithm [Alpha Zero][alpha-zero] (2017), the current champion programme of Go, Chess and Backgammon. Engineering literature seems to be more heavily focused on solving POMDPs

**MonteCarlo Tree Search** (MCTS).  MCTS is used for repeated playouts, where tasks yield a reward only when they are completed. This is a common situation in games. MCTS has been a key tool in developing computer programs capable of defeating master players of Backgammon, Chess or Go.

The idea is simple: 



**Deep reinforcement learning**


---

## Web

- [https://spinningup.openai.com]() : It contains

---

## Reading list

**1_** 

**2_** 

**3_** 

**4_**

**5_** 

**6_** 

**7_** 

**8_** 

**9_** 

**10_**

**11_**

**12_**

**13_**

**14_** 

## References

- Chapelle & Li An Empirical Evaluation of Thompson Sampling
- Shahriari 
- Thompson, William R. "On the likelihood that one unknown probability exceeds another in view of the evidence of two samples". Biometrika, 25(3–4):285–294, 1933.

[**Download this as bibtex**][bibtex-link]



[thompson]: https://en.wikipedia.org/wiki/Thompson_sampling
[chappelle-li]: https://papers.nips.cc/paper/4321-an-empirical-evaluation-of-thompson-sampling.pdf
[bubbeck-bianchi]: sdfsdf
[lai-robbins]: sdfsd
[riquelme]: blabla
[combes]: combes
[besbes]: besbes
[wu]: wu
[shahriari]: https://ieeexplore.ieee.org/document/7352306
[sutton-barto]: sutton-barto
 [alpha-zero]: alpha-zero

[bibtex-link]: oneday