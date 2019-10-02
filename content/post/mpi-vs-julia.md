+++
title = "Distributed Computing: Julia vs MPI (Julia is super easy)"
date = 2018-11-16T17:23:07-06:00
draft = false

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ["Mauricio Tec"]

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = ["julia", "mpi"]
categories = ["Julia"]

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

In this tiny post, I show with a minimal example the main difference between the distributed computing approaches of Julia and MPI. For this we will use Stampede 2, the University of Texas' supercomputer (the faster at any university as of now). This is an Intel Skylake cluster that uses SLURM as it's job queue system. We will show step-by-step how to run a distributed hello-world program in both languages.

In this post, I don't want to suggest that a specific approach is better. The benefits of MPI are well-known; what I do want to do, however, is to demonstrate how easy it is to set-up Julia--which is less known. The objective of the creators of Julia was to create a high-level language that can perform with similar performance to compiled C code, but with a high-level feel to it. Personally, I've found this extremely useful for my research. 

Julia is not frustration free. While Julia 1.0 is a major step, bringing several performance stability improvements and language coherence; there is still a long way to go, especially since libraries aren't as mature as in Python or R, or other languages that I commonly need for my research. That being said, there is a great feeling to it, and the more I use the more I like it. Library loading times still bug me, but if you are use to compile C code all the time, it's a reasonable price to pay for easier debugging and faster development.

This post is neither a tutorial on distributed computing, Julia or C. I will only focus on the minimal requirements of running a distributed job on a SLURM cluster. This post is an attempt to explain these differences to myself, so if you find any of my statements inaccurate, you are probably right--please let me know if this is the case.

## Key concepts

- **Node**: A computer. It can be make of several cores. For example, the supercomputer Stampede2 has Skylake nodes, which are made of 48 cores each.
- **Processes**: Each node can run multiple processes: i.e., instances doing computations. Typically, when multiple processes are run in one node, they are assigned to different processors. Processors handle multiple processes via multi-threading and queues.  
- **Cluster**: Many nodes wired together. 
- **Distributed computing**: It's a form of parallel computing that runs on clusters. Nodes don't share memory: variables of the program only exist locally. Any form of data communication between nodes will have to be programmed explicitly. It is usually harder to implement than multi-threading, which is shared-memory parallelism. The latter is limited, since it is much more expensive to build larger computers than wire them together.
- **MPI** (Message Passing Interface): A library for C that is used for distributed computing. It defines communication protocols between nodes at a relatively high level.

## Hello world with MPI

MPI's basic approach to distributed computing is to take a C program that is executed in parallel by every node such that every node executes *EXACTLY* the same program. When nodes should perform different tasks, the code must contain conditional statements with specific tasks in them. MPI gives an API to query which node is running the program.

The following example is minimally modified from [this tutorial](http://mpitutorial.com/tutorials/mpi-hello-world/). Please review it for a more detailed explanation of the code. They key part is that we are importing `<mpi.h>` from the beginning, which provides the functions to request the process.

```c
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    // Initialize the MPI environment (every program starts like this)
    MPI_Init(&argc, &argv);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process; rank is id
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    printf("Hello world from processor %s, rank %d out of %d processors\n",
    processor_name, world_rank, world_size);

    // Finalize the MPI environment.
    MPI_Finalize();
}
```

## Julia


## Summary comparison

