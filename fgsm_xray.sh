#!/bin/bash
for i in 0.01 0.03 0.05 0.07 0.09 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.99 
do
    python -m src.vision.mc_dropout_keras -a True -s True -e $i
done
