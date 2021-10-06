# Dockerfile for Exim Mail Transfer Agent

## Task description

![img.png](images/img.png)

### Task specifications

![img_1.png](images/img_1.png)

![img_2.png](images/img_2.png)

### Required structure of Dockerfile

![img_3.png](images/img_3.png)

## Implementation

My purpose is to create lightweight final docker image using multistage 
Dockerfile

I used `ubuntu:20.04` images that weights `~73mb`. 
![img.png](images/img_4.png)

### First image
The first image installs all dependencies and prepares artifacts for second image

### Second image
The final image copies artifacts from first image

It weights `~120mb`
![img_1.png](images/img_5.png)

The image runs with user `exim` who does not have superuser access 
to decrease the attack surface


