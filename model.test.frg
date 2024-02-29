#lang forge/bsl

open "model.frg"

/*
  Test Suite for Connect 4 Model
*/


------------------------------------------------------------------------

// Test for checking initial board state is empty
pred initialStateIsEmpty[b: Board] {
    all r, c: Int |{ 
        (b.places[r][c]=none)}
}

test suite for init {
    assert all b:Board | initialStateIsEmpty[b] is necessary for init[b]
}

// Test for validating a move is made correctly
pred moveIsValidAndAlternatesTurn[pre: Board, post: Board, p: Player, c: Int] { 
    (let validRow = min[{r: Int | r >= 0 and r <= 5 and no pre.places[r][c]}] |
      post.places[validRow][c] = p and
      (p = Red implies yellowTurn[post]) and
      (p = Yellow implies redTurn[post]))
}


test suite for move {
  assert all pre, post:Board, p:Player, c:Int| moveIsValidAndAlternatesTurn[pre, post, p, c] is necessary for move[pre, post, p, c]
}

// Test for horizontal win condition
// pred fourOnBoardH[b: Board, p: Player] {
//     some r, c, c2, c3, c4: Int, c: Int |{
//       b.places[r][c] = p and b.places[r][c2] = p and b.places[r][c3] = p and b.places[r][c4] = p}
// }


pred consecCols[b:Board, p:Player]{
    some r, c: Int|{
    (b.places[r][c] = p and b.places[r][add[c,1]] = p and b.places[r][add[c,2]] = p and b.places[r][add[c,3]] = p)}

}

pred validRowCol[b:Board, p:Player]{
    some r, c: Int|{
        ((b.places[r][c] = p and b.places[r][add[c,1]] = p and b.places[r][add[c,2]] = p and b.places[r][add[c,3]] = p) or 
        (b.places[r][c] = p and b.places[add[r,1]][c] = p and b.places[add[r,2]][c] = p and b.places[add[r,3]][c] = p) or 
        b.places[r][c] = p and b.places[add[r,1]][add[c,1]] = p and b.places[add[r,2]][add[c,2]] = p and b.places[add[r,3]][add[c,3]] = p) and
        r >= 0 and r <= 5 and c >= 0 and c <= 6 }
}

test suite for winH {
  //assert all b:Board, p:Player| fourOnBoardH[b,p] is necessary for winH[b,p] for exactly 1 Board
  assert all b:Board, p:Player| consecCols[b,p] is necessary for winH[b,p] 
  assert all b:Board, p:Player| validRowCol[b,p] is necessary for winH[b,p]
}

// Test for vertical win condition
// pred fourOnBoardV[b: Board, p: Player] {
//     some r, r2, r3, r4, c: Int, c: Int |{
//       b.places[r][c] = p and b.places[r2][c] = p and b.places[r3][c] = p and b.places[r4][c] = p}
// }

pred consecRows[b:Board, p:Player]{
    some c, r: Int|{
    (b.places[r][c] = p and b.places[add[r,1]][c] = p and b.places[add[r,2]][c] = p and b.places[add[r,3]][c] = p)}
    //absDifference[r, r2] = 1 and absDifference[r2, r3] = 1 and absDifference[r3, r4] = 1}

}

test suite for winV {
  //assert all b:Board, p:Player| fourOnBoardV[b,p] is necessary for winV[b,p]
  assert all b:Board, p:Player| consecRows[b,p] is necessary for winV[b,p]
  assert all b:Board, p:Player| validRowCol[b,p] is necessary for winV[b,p]
}

// Test for diagonal win condition
pred consecRowsCols[b:Board, p:Player]{
    some c, r: Int|{
    (b.places[r][c] = p and b.places[add[r,1]][add[c,1]] = p and b.places[add[r,2]][add[c,2]] = p and b.places[add[r,3]][add[c,3]] = p)}
    //absDifference[r, r2] = 1 and absDifference[r2, r3] = 1 and absDifference[r3, r4] = 1}

}
test suite for winD {
  //assert all b:Board, p:Player| fourOnBoardV[b,p] is necessary for winV[b,p]
  assert all b:Board, p:Player| consecRowsCols[b,p] is necessary for winD[b,p]
  assert all b:Board, p:Player| validRowCol[b,p] is necessary for winD[b,p]
}
fun countPiece[brd: Board, p: Player]: one Int {
  #{r: Int, c: Int | brd.places[r][c] = p}
}
pred turn[b: Board] {
  countPiece[b, Red] = countPiece[b, Yellow] or
  subtract[countPiece[b, Red], 1] = countPiece[b, Yellow]
}

test suite for valid{
  assert all b:Board| turn[b] is necessary for valid[b]

}




