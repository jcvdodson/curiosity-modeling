#lang forge/bsl

abstract sig State {
    // The top of the max heap (may be empty)
    top: lone HeapElement
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

// check that the heap is a max heap
// that means: 
// 1. the value of the root is greater than or equal to the value of its children
// 2. the left and right subtrees are also max heaps
// 3. each node has at most 2 children
// 4. linearity/reachability: each element in the max heap should be reachable from the root
pred init {

}

pred InitialToMidPop {
    
}

pred InitialToMidPush {
   
}

pred MidToEndPop {
    
}

pred MidToEndPush {
    
}