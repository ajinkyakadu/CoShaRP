# CoShaRP
Convex Shape Recovery Program for Single-shot tomography

<p align="right">
<img align="right" width="500" height="300" src="/extras/ex3d.png" >
</p>

This MATLAB toolbox computes an image composed of **K** copies of shapes from its single-shot X-ray tomographic projections. It assumes that the shapes are known, and creates a dictionary consisting of extensive roto-translations copies of the shapes. The algorithmic framework, called CoShaRP, converts the estimation of roto-translation parameters of shapes to computing the dictionary coefficients with imposed constraints (here, K-simplex constraints).

## Problem description  
We solve the optimization problem
![equation](/extras/equation.png)
to compute the shape coefficients. Here, **A** is a tomography matrix (which is either fan-beam or cone-beam) of size *m* times *n*, **y** consists of *m* tomographic measurements, **Ψ** is a shape dictionary of size *n* times *p*, and **z** is a shape coefficient vector of length *p*. K are the number of shapes present in the target image. Once we obtain an optimal estimate of shape coefficient vector, we get an image using
![equation](/extras/image_form_eq.png)


## Authors
* Ajinkya Kadu ([ajinkyakadu125@gmail.nl](mailto:ajinkyakadu125@gmail.com))  

## License
You can distribute the software as you wish.

## Dependencies
This framework has been tested on Matlab 2020b.


## Usage  
The examples scripts are  
1. **test2D** : single-shot fan-beam tomography on 2D image with circular disks as shape
2. **test2D_4shapes** : single-shot fan-beam tomography on 2D image with 4 different shapes  
3. **test3d** : single-shot cone-beam tomography on 3D image with spheres

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
