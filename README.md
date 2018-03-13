# data

`data` is an experimental MATLAB class to make it easier to work with datasets.

# The problem

Existing tools in MATLAB are underwhelming (like `struct` or `table`). If you have a bunch of data that comes from a large number of conditions, you have the following options:

## Store things in a N-D array

* but what if you have missing data?
* thinking in N dimensions is hard
* 50% of your code is now the `squeeze` function
* Your data isn't probably a hyper-cube, so this is wasteful

## Store things in 2D arrays, and logically index

* This is the accepted best-practice in scientific computing 
* But it has its own problems: either you have a bunch of matrices that **should** be the same size, or you put everything in a structure
* It's easy to make mistakes and accidentally resize one matrix, but not the rest
* Its hard to filter the entire dataset, even though all the information you need is right there

# The solution

Enter `data`. 

It's a simple MATLAB class that creates a structure with the following rigid limitations:

1. Only 1D and 2D arrays allowed
2. All arrays must be the same size. This makes it much harder to screw up in indexing arrays 

In addition, `data`, comes with a number of helpful methods to make working with large datasets easier. 

# Usage

Create a new `data` object:

```matlab
A = randn(1e4,1e3);
B = randn(1e5,1e3);
idx = 1:1e3;

d = data(A,B,idx);
```

Add a new array to your dataset:

```matlab
C = randn(4,1e3);
d.add('C')
```

If you try to do something stupid, `data` will throw an error

```matlab
X = randn(1e2,2e3);
d.add(X) % this won't work because the dimensions of X are wrong
```

# License

GPL v3