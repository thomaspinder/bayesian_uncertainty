# Using Bayesian Deep Learning Approximations to Detect Adversaries in Computer Vision and Reinforcement Learning Tasks

## Contents
 
  * [What Is This All About?](#what-is-this-all-about-)
    + [Documentaion](#documentaion)
  * [Tasks](#tasks)
    + [MNIST Digit Classification](#mnist-digit-classification)
    + [Pneumonia Detection](#pneumonia-detection)
    + [FlappyBird DQN](#flappybird-dqn)
  * [Installing](#installing)
  * [Setup](#setup)
    + [Train Vision Networks](#train-vision-networks)
    + [Train FlappyBird Agent](#train-flappybird-agent)
  * [Running Experiments](#running-experiments)
    + [Computer Vision Tasks](#computer-vision-tasks)
    + [Reinforcement Learning Tasks](#reinforcement-learning-tasks)


## What Is This All About?
This code repository corresponds to my masters thesis which attempts to detect the presence of adversaries in common AI/ML taks using Bayesian CNNs. Bayesian CNNs are produced based upon the work of [Gal and Ghahramani](https://arxiv.org/pdf/1506.02142.pdf) who prove that by incorporating dropout layers, the neural network converges to a deep Gaussian process. Adversaries are created using the Fast Gradient Sign Method [(FGSM)](https://arxiv.org/pdf/1412.6572.pdf), with varying values of ![equation](http://latex.codecogs.com/gif.latex?%5Cepsilon) being tested. 

Results are collected by establishing baselines and then crafting adversarial examples and observing the performance decrease. Using a BCNN, we then utilise the ability to extract uncertainty measures and test whether an increase in uncertainty can be used to detect the presence of an adversary.

### Documentaion
Full Documentation can be found [here](https://goo.gl/WTkpdK).

## Tasks
### MNIST Digit Classification
A baseline in any vision experiment, we test the classifiers performance and resilience to adversaries when classifying digits from the MNIST database.

<img src="other/imgs/mnist.jpeg" alt="Pneumonia X-Ray" width="400px"/>

### Pneumonia Detection
A more _real world_ challenge would be to test for the presence of pneumonia in an individual based upon a chest x-ray image - [data here](https://www.kaggle.com/paultimothymooney/chest-xray-pneumonia). 

<img src="other/imgs/pneumonia.jpeg" alt="Pneumonia X-Ray" width="400px"/>

### FlappyBird DQN
We also train an agent using the DQN of [Mnih et. al.](https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf) to play flappybird, replacing the original CNN with a BCNN. Once trained, we inflict adversarial attacks on the agent while playing flappybird.

<img src="other/imgs/flappy_bird.png" alt="Flappy Bird" width="400px"/>


## Installing

__Note__: _This work has only been tested on a Linux (Ubuntu 16.04 LTS) machine, code may not work as required on other operating systems._

1. Clone repository 
```
git clone https://github.com/thomaspinder/bayesian_uncertainty
cd bayesian_uncertainty
```

2. Create virtual environment 
```
pip install virtualenv
virtualenv env -p python3
source env/bin/activate
```

3. Install requirements
```
pip install -r requirements.txt
```

## Setup 
### Train Vision Networks
Takes approximately 15minutes on an Nvidia 1050ti GPU.
```
python src.experiments 'vision' -m 0
```

### Train FlappyBird Agent
Note, on an Nvidia 1050ti GPU this process took 2.5 days to complete.
```
python -m src.experiments 'rl'
```


## Running Experiments
### Computer Vision Tasks


1. Comparing CNNs against Bayesian CNNs in the absence of adversaries
```
python -m src.experiments 'vision' -m 1
```

2. Calculating uncertainty values as MNIST digits are rotated through 180 degrees
```
python -m src.experiments 'vision' -m 0
```

3. Test the accuracy of a CNN or BCNN on adversarially perturbed images
```
python -m src.experiments 'vision' -m 3 -f <EPSILON-VALUE> --model <CNN-OR-BCNN>
```

replacing `<EPSILON-VALUE>` with the value of ![equation](http://latex.codecogs.com/gif.latex?%5Cepsilon) to be used in FGSM.

Alternatively, you may find it convenient to use the shell command `sh fgsm_loop.sh` to test all values of epsilon between 0.01 and 2 for both a CNN and BCNN with one simple command.

4. To test the performance of a BCNN on the real world x-ray dataset for unperturbed images and images perturbed by FGSM for values of epsilon between 0.01 and 0.9 run

```
sh fgsm_xray.sh
```

Alternatively, to test specific configuration of epsilon run

```
python -m src.vision.mc_dropout_keras -m 0 -a True -e 0.1
```
where `-m` denotes if monte carlo dropout should be used, 0 indicates no test, 1 for standard cnn and 2 for bcnn based monte carlo dropout.
`-a` is a bool operator for if adversaries should be induces
`-e` is the value of epsilon to be used in FGSM 
`-t` is a bool operator denoting if the network should be trained from scratch. Default is false, indicating that weights will be loaded.

### Reinforcement Learning Tasks


### Other

Experiments will typically generate one `.csv` file per run. When testing multiple parameter configurations this can be cumbersome so the following command will collect results together and merge into a single `.csv`.

```
python -m src.utils.plotting_helpers -f True -d <FOLDER-CONTAINING-RESULTS> -o <FOLDER-TO-SAVE-TO/FILENAME.csv>
```

An example for the FGSM experiments with varying values of ![equation](http://latex.codecogs.com/gif.latex?%5Cepsilon) is: 

```
python -m src.utils.plotting_helpers -f True -d 'results/experiment3/cnn' -o 'results/cnn_exp3_all.csv'
```

