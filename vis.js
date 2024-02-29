if (document.getElementById('connectFourBoard')) {
    document.getElementById('connectFourBoard').remove();
}
var chessboard = document.createElement('div');
chessboard.setAttribute('id','connectFourBoard');
div.appendChild(chessboard);
chessboard.style.borderRadius = '10px';

function createConnectFourBoard() {
    if (document.getElementById('connectFourTable')) {
        document.getElementById('connectFourTable').remove();
    }
    var table = document.createElement('table');
    table.setAttribute('id', 'connectFourTable');
    table.style.border = '1px solid black';
    table.style.margin = 'auto';
    table.style.borderCollapse = 'collapse';
    table.style.backgroundColor = 'blue';
    table.style.padding = '10px';
    table.style.width = '600px';
    table.style.height = '500px';
    table.style.position = 'relative';
    table.style.borderRadius = '10px';
    
    boardData = createBoardData(Board);
    for (var r = 5; r >= 0; r--) {
        var row = document.createElement('tr');
        for (var c = 0; c <= 6; c++) {
            var cell = document.createElement('td');
            cell.style.border = '10px solid blue';
            cell.style.width = '50px';
            cell.style.height = '50px';
            cell.style.backgroundColor = 'blue';
            var playerDisc = document.createElement('div');
            playerDisc.style.width = '60px';
            playerDisc.style.height = '60px';
            playerDisc.style.borderRadius = '100%';
            playerDisc.style.position = 'relative';
            playerDisc.style.left = '8px'
            // the background color of the cell will be determined by the value of the boardData
            if (boardData[r][c] === "0") {
                playerDisc.style.backgroundColor = 'red';
            }
            else if (boardData[r][c] === "1") {
                playerDisc.style.backgroundColor = 'yellow';
            }
            else {
                playerDisc.style.backgroundColor = 'white';
            }
            cell.appendChild(playerDisc);
            cell.style.padding = '0px';
            cell.style.textAlign = 'center';
            cell.style.verticalAlign = 'middle';
            cell.style.fontSize = '30px';
            cell.style.fontWeight = 'bold';
            cell.style.color = 'black';
            cell.style.cursor = 'pointer';
            cell.style.borderRadius = '100%';
            cell.setAttribute('data-row', r);
            cell.setAttribute('data-col', c);
            // cell.textContent = boardData[r][c];
            row.appendChild(cell);
        }
        table.appendChild(row);
    }
    chessboard.appendChild(table);
}

function createBoardData(board) {
    var boardData = [];
    for (r = 0; r <= 6; r++) {
        var row = [];
        for (c = 0; c <= 7; c++) {
            row.push("-1");
        }
        boardData.push(row);
    }

    const pieces = board.join(places).tuples();
    for (idx = 0; idx < pieces.length; idx++) {
        const atms = pieces[idx]._atoms;
        const pieceRow = atms[0].toString();
        const pieceCol = atms[1].toString();
        const piece = atms[2].toString();
        if (piece.includes("Red")) {
            boardData[pieceRow][pieceCol] = "0";
        }
        else if (piece.includes("Yellow")) {
            boardData[pieceRow][pieceCol] = "1";
        }
    }
    return boardData;
}
  
createConnectFourBoard();