#lang forge/bsl

/*
  Connect 4 Model
*/

-- Two players: Red and Yellow 
abstract sig Player {}
one sig Red, Yellow extends Player {}

-- Six rows: R1 to R6 (R1 is the bottom row)
abstract sig Row {}
one sig R1, R2, R3, R4, R5, R6 extends Row {}

-- Seven columns: C1 to C7
abstract sig Column {}
one sig C1, C2, C3, C4, C5, C6, C7 extends Column {}

sig Board {
    -- A partial function from rows and columns to players, representing the placement of discs
    places: pfunc Row -> Column -> Player
}

-- Count the number of pieces a player has on the board
fun countPiece[brd: Board, p: Player]: one Int {
  #{r: Row, c: Column | brd.places[r][c] = p}
}

-- Predicate to determine whose turn it is based on the count of pieces
pred redTurn[b: Board] {
  countPiece[b, Red] = countPiece[b, Yellow]
}
pred yellowTurn[b: Board] {
  subtract[countPiece[b, Red], 1] = countPiece[b, Yellow]
}

-- A board is valid if it's either Red's turn or Yellow's turn
pred valid[b: Board] {
  yellowTurn[b] or redTurn[b]
}

-- Winning conditions (Horizontal, Vertical, and Diagonal wins)
pred winH[b: Board, p: Player] {
  some r: Row | some c: Column, c2: Column, c3: Column, c4: Column |
    b.places[r][c] = p and b.places[r][c2] = p and b.places[r][c3] = p and b.places[r][c4] = p
}

pred winV[b: Board, p: Player] {
  some c: Column | some r: Row, r2: Row, r3: Row, r4: Row |
    b.places[r][c] = p and b.places[r2][c] = p and b.places[r3][c] = p and b.places[r4][c] = p
}

pred winD[b: Board, p: Player] {
    //have not done this yet
}

-- A win predicate 
pred winning[b: Board, p: Player] {
  winH[b, p] or winV[b, p] or winD[b, p]
}

-- Initial state predicate, where no discs are placed on the board
pred init[brd: Board] {
    all r: Row, c: Column | no brd.places[r][c]
}

-- Move predicate 
pred move[pre: Board, post: Board, p: Player, c: Column] {
    //turn have to alternate and discs have to fall to lowest row.. have not done yet
}

-- Run statement to find a winning configuration for Red
run {
    some b: Board | winning[b, Red]
} for 4 Board, 6 Row, 7 Column, 2 Player 