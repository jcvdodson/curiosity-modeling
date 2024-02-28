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
// pred winH[b: Board, p: Player] {
//   some r: Row | some c: Column, c2: Column, c3: Column, c4: Column |
//     b.places[r][c] = p and b.places[r][c2] = p and b.places[r][c3] = p and b.places[r][c4] = p
// }
pred winH[b: Board, p: Player] {
  some r: Row | some disj c: Column, c2: Column, c3: Column, c4: Column |
    b.places[r][c] = p and b.places[r][c2] = p and b.places[r][c3] = p and b.places[r][c4] = p
    and ((c=C1 and c2=C2 and c3=C3 and c4=C4) or (c=C2 and c2=C3 and c3=C4 and c4=C5) or (c=C3 and c2=C4 and c3=C5 and c4=C6))
    //and add[c, 1] = c2 and add[c2, 1] = c3 and add[c3, 1]=c4 
    // check that r is within 0 to 5, and c within 0 to 6
    and r >= 0 and r <= 5 and c >= 0 and c <= 6 and c2 >= 0 and c2 <= 6 and c3 >= 0 and c3 <= 6 and c4 >= 0 and c4 <= 6
}

// pred winV[b: Board, p: Player] {
//   some c: Column | some r: Row, r2: Row, r3: Row, r4: Row |
//     b.places[r][c] = p and b.places[r2][c] = p and b.places[r3][c] = p and b.places[r4][c] = p
// }
pred winV[b: Board, p: Player] {
  some c: Column | some disj r: Row, r2: Row, r3: Row, r4: Row |
    b.places[r][c] = p and b.places[r2][c] = p and b.places[r3][c] = p and b.places[r4][c] = p
    and ((r=R1 and r2=R2 and r3=R3 and r4=R4) or (r=R2 and r2=R3 and r3=R4 and r4=R5) or (r=R3 and r2=R4 and r3=R5 and r4=R6))
    //and add[r,1]=r2 and add[r2, 1]=r3 and add[r3, 1]=r4
    // check that c is within 0 to 6, and r within 0 to 5
    and c >= 0 and c <= 6 and r >= 0 and r <= 5 and r2 >= 0 and r2 <= 5 and r3 >= 0 and r3 <= 5 and r4 >= 0 and r4 <= 5
}

fun absDifference[m: Int, n: Int]: Int {
  let difference = subtract[m, n] {
    difference > 0 => difference else subtract[0, difference]
  }
}

pred winD[b: Board, p: Player] {
  some c1, c2, c3, c4: Column| some r1, r2, r3, r4: Row|{
    (b.places[r1][c1] = p and b.places[r2][c2] = p and b.places[r3][c3] = p and b.places[r4][c4] = p) and
    (absDifference[r1, r2] = 1 and absDifference[c1, c2] = 1) and
    (absDifference[r2, r3] = 1 and absDifference[c2, c3] = 1) and
    (absDifference[r3, r4] = 1 and absDifference[c3, c4] = 1) and
    (absDifference[r1, r4] = 3 and absDifference[c1, c4] = 3)}
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
  // guard:
  c >= 0 and c <= 6 and // the column is within 0 to 6
  {some r: Row | r >= 0 and r <= 5 and no pre.places[r][c]} and // the column is not full
  valid[pre] and // the pre board is valid
  p = Red implies redTurn[pre] and 
  p = Yellow implies yellowTurn[pre] // it is the player's turn

  // action:
  // find the minimum row in the column that is not occupied
  let r = min[{r: Row | r >= 0 and r <= 5 and no pre.places[r][c]}] |
  post.places[r][c] = p and // Place the player's disc in that position
  {all r2: Row, c2: Column | (r2 != r or c2 != c) implies post.places[r2][c2] = pre.places[r2][c2]} // All other positions are unchanged
}

-- Run statement to find a winning configuration for Red
run {
    some b: Board | winning[b, Red]
} for 4 Board, 6 Row, 7 Column, 2 Player 