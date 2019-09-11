# User Manual

## Contents
```@contents
Depth = 3
```

## Introduction
I like to master the Julia programming language. To get more experience, I created the project 'rbontekoe/RbO.jl.'

Also, I decided to use Documenter.jl to create the documentation for the project, after looking at a [video] (https://www.youtube.com/watch?v=m3c8Z6HBn48) that explains its features. I was impressed when Morton Phiibleht told about the possibility to test the code example automatically during the creation of the manual. The result is this manual.

For the creation of the Julia notebook, I used Literate.jl, after watching this [video](https://www.youtube.com/watch?v=Tfp1WEdYfqk&t=333s).

## Journal 8/10/2019
Last week I was busy implementing the database methods. I realized that the domain objects I wanted to keep must have an identification code. So Subscriber, Publisher, and Message got an id. To create the id, I used the hash function with a name and time as a parameter. It had consequences for the documentation. In the example code, I used the tag 'jldoctest,' so Documenter could test the example code during the generation of the manual. Because the ids keep changing, I had to give up. Too bad, because I found that a strong point of Documenter.jl. I replaced the test tag 'jldoctest' with the language tag 'julia.' Maybe there is something to do against continually changing values.

Infected by the CQRS thought, I decided to add changed domain objects to the database instead of modifying an existing record.
