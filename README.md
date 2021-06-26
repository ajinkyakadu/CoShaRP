# CoShaRP
Convex Shape Recovery Program for Single-shot tomography

<p align="right">
<img align="right" width="200" height="200" src="/extras/cone-beam.png" >
</p>

This MATLAB toolbox computes an image composed of **K** copies of shapes from its single-shot X-ray tomographic projections. It assumes that the shapes are known, and creates a dictionary consisting of extensive roto-translations copies of the shapes. CoShaRP converts the estimation of roto-translation parameters of shapes to computing the dictionary coefficients with imposed constraints (here, K-simplex constraints). 

## Problem description  




## Authors
* Ajinkya Kadu ([ajinkyakadu125@gmail.nl](mailto:ajinkyakadu125@gmail.com))  

## License
You can distribute the software as you wish.

## Dependencies
This framework has been tested on Matlab 2020b.


## Usage  
The examples scripts are  
1. **test2D** : 2D image with circular disks as shape
2. **test2D_4shapes** : 2D image with 4 different shapes

![image](/results/test2D_4shapes/final.png)

## Citation  
If you use this code, please use the following citation
```
@article{kadu2020cosharp,
  title={CoShaRP: A Convex Program for Single-shot Tomographic Shape Sensing},
  author={Kadu, Ajinkya and van Leeuwen, Tristan and Batenburg, K Joost},
  journal={arXiv preprint arXiv:2012.04551},
  year={2020}
}
```
A preprint of the article can be found [here](https://arxiv.org/abs/2012.04551)

## Reporting Bugs
In case you experience any problems, please contact [Ajinkya Kadu](mailto:ajinkyakadu125@gmail.com)
