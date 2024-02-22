#lang forge/bsl

abstract sig State {
    // The top of the max heap (may be empty)
    top: lone StackElement
}
// There are only 3 states in the model: Initial -> Mid -> End
// we only need to check these three states to ensure that the heap is a max heap
one sig Initial, Mid, End extends State {} 

sig HeapElement {
    // each heap element has a value, and may have a left and right child
    value: one Int,
    left: lone HeapElement,
    right: lone HeapElement
}