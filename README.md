# curiosity-modeling
cs1710 modeling

# Project Objective: What are you trying to model? Include a brief description that would give someone unfamiliar with the topic a basic understanding of your goal.
We model the game Connect4. Connect 4 is a two-player game, where players choose a color (red or yellow) and then take turns dropping their colored discs from the top into a seven-column, six-row vertically suspended grid. The pieces fall straight down, occupying the lowest available space within the column. The objective of the game is to be the first to form a horizontal, vertical, or diagonal line of four of one's own discs.

# Model Design and Visualization: Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by the Sterling visualizer. How should we look at and interpret an instance created by your spec? Did you create a custom visualization, or did you use the default?
Model Design Choices:
- Player Representation: Two abstract signatures, `Red` and `Yellow`, represent the players to simplify player differentiation and turn management. 
- Board Structure: The board is modeled as a partial function from integer pairs (rows and columns) to players. We initially represented rows and columns as Row and Column objects, but then decided to represent them as ints. Representing rows and columns as integers simplified the move and winD predicates.
- Turn Logic: Predicates `redTurn` and `yellowTurn` determine whose turn it is based on the count of pieces, ensuring turn alternation.
- Win Conditions: Separate predicates for horizontal, vertical , and diagonal wins allow checking all possible winning configurations.
- Move Logic: The `move` predicate specifies the conditions under which a move is valid, including turn logic and the physical constraint that discs must occupy the lowest available space in a column.

Checks and Run Statements:
- Run Statement for Winning Configuration: A run statement searches for instances where Red wins through a horizontal line. 

Visualization and Interpretation:
- Visualization**: We created a custom visualization. The visualization script dynamically generates a table that serves as the game board, with individual cells representing slots for the discs. Discs are represented as colored circles within these cells, with red for one player and yellow for the other, matching the conventional Connect 4 colors. Empty slots are represented by white circles. It is an intuitive display of the game that looks like the real Connect4 game. Interpret the visualization as you would the real Connect4 board, where whoever gets 4 in a line wins.

# Signatures and Predicates: At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together.
Signatures:
- Player: Abstract signature representing the players in the game, with two extensions Red and Yellow. 
- Board: Signature represnting the grid-like board of the game. This is modeled as a partial function to capture game state at any point.

Predicates:
- countPiece: A function that calculates the number of pieces each player has on the board. This is used in predicates that determine which player's turn it is. 
- redTurn and yellowTurn: Determine whose turn it is to make a move based on number of discs of each color are already on the board.
- valid: Checks if a given board state is valid based on the turn-taking rules. 
- winH, winV, and winD: These predicates define the conditions under which a player wins the game, corresponding to horizontal, vertical, and diagonal alignments of four consecutive discs of the same color. 
- winning: Single check to simplify determining if a player has won the game. 
- init: Defines the initial state of the board, where no discs have been placed. 
- move: Specifies the conditions under which a move is considered valid.
- nextRowForColumn: function that alculates the lowest available row for a disc to be placed in a given column to represent gravity of real game.

How They Fit Together:
The signatures define the essential components of the Connect4 game. The predicates and the function describe the logic governing the game: how turns are taken, how the game progresses, and under what conditions the game ends. All together, they model the Connect4 game.

# Testing: What tests did you write to test your model itself? What tests did you write to verify properties about your domain area? Feel free to give a high-level overview of this.
We wrote a test suite for each predicate and included assert statements inside to ensure that all conditions are met. 

# Documentation: Make sure your model and test files are well-documented. This will help in understanding the structure and logic of your project.
We added comments above each predicate to explain each component of our model.