# R-plotter-for-neural-networks
A tool to visualise neural networks in R
[GitHub - FlorianEder/: R-plotter-for-neural-networks](https://github.com/FlorianEder/R-plotter-for-neural-networks)

## Introduction

This project was initially created for my course assistance systems ([see here](https://github.com/THDMoritzEnderle/netflix_prediction)), in which we used ANN2 neural networks.
But there is no plot function of the neural network itself in the ANN2 library. That's why i decided to write one myself using the plot function integrated in R.

## Installation

Install devtools

```r
install.packages("devtools")
```

Activate the devtools library

```r
library(devtools)
```

Download and run this GitHub repository

```r
install_github("FlorianEder/R-plotter-for-neural-networks")
```

## Usage

### Command
```r
create_plot(output, parameters, weights, nodes = NULL, png.title=NULL, pos.col = "#858585", neg.col = "#e23128", node.col = "#999999", node.otl = "#4F4F4F", text.col = "white", line.diff = 4)
```

### Arguments

**argument**|**type**|**description**|**example**
:-----:|:-----:|:-----:|:-----:
output|String|title of goal node.|"goal value"
parameters|list|titles of input nodes.|list("input\_1","input\_2","input\_3","input\_4")
weights|list[list[list[weight],...],...]|weights: [Layers[Node[Weight, ...], ...], …] |list(list(list(0.1, 0.2),list(0.4, 0.5),list(0.6, 0.7)),list(list(0.8),list(0.9)))
weights|list|weights: [Weight, ...], requires nodes.|list(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)
nodes|list|list with amount of nodes per layer, default: NULL|list(3,2,1)
png.title|String|title of .png file, enables creation of png, default: NULL|"plot.png"
pos.col|String|color of weight line if weight >= 0, default: "#858585"|"#50eaa5"
neg.col|String|color of weight line if weight < 0, default: "#858585"|"#c86660"
node.col|String|color of node, default: "#999999"|"grey"
node.otl|String|color of node outlines, default: "#4F4F4F"|"black"
text.col|String|color of text color (parameters, output), default: "white"|"#d4c63e"
line.diff|float|difference between thinnest and broadest weight line, default: 4|8

### Example

#### Example 1
```r
create_plot("Goal Movie", list("input_1","input_2","input_3"), list(list(list(0.1634, -0.9503),list(0.024, -0.0363642),list(0.0217167, 0.358346)),list(list(0.2),list(-0.1641))), png.title = "example_1.png")
```
![Example 1](/examples/example_1.png#gh-dark-mode-only)

#### Example 2

```r
create_plot("output", list("input_1","input_2","input_3"), list(list(list(0.1634, -0.9503),list(0.024, -0.0363642),list(0.0217167, 0.358346)),list(list(0.2),list(-0.1641))), png.title = "example_2.png", pos.col = "#50eaa5", neg.col = "#c86660", node.col = "blue", node.otl = "black", text.col = "#d4c63e", line.diff = 8)
```
![Example 2](/examples/example_2.png#gh-dark-mode-only)

#### Example 3.1 (counterexample)
In this example the weights are stored as a list without indicating the structure of the layers.
```r
create_plot("Goal Movie", list("Movie 1","Movie 2","Movie 3"), list(0.1634, -0.9503, 0.024, -0.0363642, 0.0217167, 0.358346, 0.2, -0.1641), png.title = "example_3_1.png")
```
![Example 3.1](/examples/example_3_1.png#gh-dark-mode-only)

#### Example 3.2
In this example the weights are the same but the structure of the layers are indicated. 
```r
create_plot("Goal Movie", list("Movie 1","Movie 2","Movie 3"), list(0.749845, 0.855669, -0.807458, 0.290171, -0.439222, 0.844263, -0.237222, -0.622491), nodes = list(3,2,1), png.title = "example_3_2.png")
```
![Example 3.2](/examples/example_3_2.png#gh-dark-mode-only)


## Rights

All rights belong to Florian Eder. I do not allow any publications without letting me know. 
