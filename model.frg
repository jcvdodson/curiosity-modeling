#lang forge/bsl

/*
  Connect 4 Model
*/

-- Two players: Red and Yellow 
abstract sig Player {}
one sig Red, Yellow extends Player {}

sig Board {
    -- A partial function from rows (int) and columns (int) to players, representing the placement of discs
    places: pfunc Int -> Int -> Player
}

-- Count the number of pieces a player has on the board
fun countPiece[brd: Board, p: Player]: one Int {
  #{r: Int, c: Int | brd.places[r][c] = p}
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

fun absDifference[m: Int, n: Int]: Int {
  let difference = subtract[m, n] {
    difference > 0 => difference else subtract[0, difference]
  }
}

-- Winning conditions (Horizontal, Vertical, and Diagonal wins)
pred winH[b: Board, p: Player] {
  some r: Int | some disj c: Int, c2: Int, c3: Int, c4: Int |
    b.places[r][c] = p and b.places[r][c2] = p and b.places[r][c3] = p and b.places[r][c4] = p
    // check that r is within 0 to 5, and c within 0 to 6
    and r >= 0 and r <= 5 and c >= 0 and c <= 6 and c2 >= 0 and c2 <= 6 and c3 >= 0 and c3 <= 6 and c4 >= 0 and c4 <= 6
    // check sequential columns
    and absDifference[c, c2] = 1 and absDifference[c2, c3] = 1 and absDifference[c3, c4] = 1
}

pred winV[b: Board, p: Player] {
  some c: Int | some disj r: Int, r2: Int, r3: Int, r4: Int |
    b.places[r][c] = p and b.places[r2][c] = p and b.places[r3][c] = p and b.places[r4][c] = p
    // check that c is within 0 to 6, and r within 0 to 5
    and c >= 0 and c <= 6 and r >= 0 and r <= 5 and r2 >= 0 and r2 <= 5 and r3 >= 0 and r3 <= 5 and r4 >= 0 and r4 <= 5
    // check sequential rows
    and absDifference[r, r2] = 1 and absDifference[r2, r3] = 1 and absDifference[r3, r4] = 1
}

pred winD[b: Board, p: Player] {
  some disj r1, r2, r3, r4: Int |
    (absDifference[r1, r2] = 1 and absDifference[r2, r3] = 1 and absDifference[r3, r4] = 1)
    and {some disj c1, c2, c3, c4: Int |
          absDifference[c1, c2] = 1 and absDifference[c2, c3] = 1 and absDifference[c3, c4] = 1
          and b.places[r1][c1] = p and b.places[r2][c2] = p and b.places[r3][c3] = p and b.places[r4][c4] = p}
}

-- A win predicate 
pred winning[b: Board, p: Player] {
  winH[b, p] or winV[b, p] or winD[b, p]
}

-- Initial state predicate, where no discs are placed on the board
pred init[brd: Board] {
    all r: Int, c: Int | no brd.places[r][c]
}

fun nextRowForColumn[pre: Board, c: Int]: lone Int {
  let r = min[{r: Int | r >= 0 and r <= 5 and no pre.places[r][c]}] {
      (r >= 0 and r <= 5 and no pre.places[r][c]
      and {all r2: Int | r2 < r and r2 >= 0 implies some pre.places[r2][c]}) implies r else none
    }
}

-- Move predicate 
pred move[pre: Board, post: Board, p: Player, c: Int] {
  // guard:
  p = Red implies redTurn[pre] and // it is the player's turn
  p = Yellow implies yellowTurn[pre] and
  c >= 0 and c <= 6 and // the column is within 0 to 6
  valid[pre] // the pre board is valid
  // let r = min[{r: Int | r >= 0 and r <= 5 and no pre.places[r][c]}] |
  //   {r >= 0 and r <= 5 and no pre.places[r][c]
  //     and {all r2: Int | r2 < r and r2 >= 0 implies some pre.places[r2][c]} // 
  //     and post.places[r][c] = p and // Place the player's disc in that position
  //     {all r2: Int, c2: Int | (r2 != r or c2 != c) implies post.places[r2][c2] = pre.places[r2][c2]}
  // }
  and (p = Red implies yellowTurn[post]) and (p = Yellow implies redTurn[post])
  let r = nextRowForColumn[pre, c] {
    not r = none and
    r >= 0 and r <= 5 and no pre.places[r][c]
    and post.places[r][c] = p and // Place the player's disc in that position
    {all r2: Int, c2: Int | (r2 != r or c2 != c) implies post.places[r2][c2] = pre.places[r2][c2]}
    and (p = Red implies yellowTurn[post]) and (p = Yellow implies redTurn[post]) // it is the other player's turn
  }
}

one sig Game {
  initialState: one Board,
  next: pfunc Board -> Board
}

pred traces {
    -- The trace starts with an initial state
    init[Game.initialState]
    no sprev: Board | Game.next[sprev] = Game.initialState
    -- Every transition is a valid move
    all s: Board | some Game.next[s] implies {
      some col: Int, p: Player |
        move[s, Game.next[s], p, col]
    }
}

-- Run statement to find a winning configuration for Red
run {
  traces
  some b: Board | winH[b, Red]
} for 8 Board for {next is linear}