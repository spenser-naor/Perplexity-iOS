# Perplexity - iOS



## About 

When I started work on Perplexity in 2013, I knew it would be the largest scale development project I'd worked on up to that point. I had growing familiarity with OOP and was ready to tackle something full scale. The "match 3" app genre was in full swing, so I decided to give it a little twist - opting for a staggared circular playfield in contrast tot he typical rectangular grid. I learned an enormous amont on this project, and developement my skills a several new areas.

**Skills and Tools utilized in this project:**

- Procedural puzzle generator
- Time complexity optimization
- Depth first search
- Physics engine implementation (box2d)
- Collision detection
- Persistent user data
- A/B testing with live users
- In-app purchases
- Flurry Analytics
- Game Center implementation


## Overview

Like in a typical match 3 game, players match 3 or more tiles with adjacent tiles of the same color. Once matched, tiles disappear and new tiles fall into the playfield. The game sports power-ups, special tiles and a couple different modes. 


## Gameplay

Player manipulate the playfield in a way completely unique to match 3 style games. Instead of tiles moving from top to bottom, they move from the **outer** rings toward the **inner rings**. This theme is carried through to the gameplay. Players can swap a tile with another tile further from (or closer to) the center of the playboard.


One of the cool side-effects of playing this game, is that you get more comfortable thiking in a polar grid - a space in which most people aren't particularly familiar.

I tried to lean into the circular format - so instead of just swaping adjacent tiles on the same ring, the player can also **spin and entire ring** in order to find matches. 


You'll notice in the above image that tiles will fall toward the center of the game board if there are no supporting tiles stopping them. This leads to an entire world of potential puzzle options.



## Modes



Perplexity has a simple menu system. Sound effects and music controls, settings stored as persistant user data, game center integration, and two primary modes - Voyage and Arcade:


#### Voyage



The voyage mode was my game's "campaign," where players could explore themed puzzle packs, trying to clear the board in the face of a growing number of obstacles. These obstacles may be unusable rings, or locked tiles as in the image below:



#### Arcade



In the Arcade mode, players battle the clock to score as many points as they can. Perplexity uses recursive search functions to identify tile adjacency across the board, and then trigger the appropriate response. There are a variety of triggered events throughout the game - matches disappearing from the board, generating special tiles, awarding more points to the player, etc.





## Under the hood

Each square represents a polar coordinate, and each tile an instance of a NSObject gamepiece class. That gamepiece object has properties which allowed me to define each distinct gamepiece as a collection of properties. 

I used a physics engine called Box2d to manage the gamepiece class and have natural falling animations built-in.


#### Iteration vs Recursion

One interesting problem arose while programming the logic for finding collections of matching game pieces. I followed a recursive method initially bcause this came the most naturally, but I found that there were times when this method couldn't evaluate every piece on the board within a single time step, resulting in missed collisions within the physics engine. I had to find a faster way.

Below is a sample code block of my final iterative approach with most of the app-specific logic cleaned out:

```
for (int *row; row < sizeOf(currentBoardState); ++row)
{
	for (int *column = 0; column<sizeOf([currentBoardState objectAtIndex:row]); column = column + 1 ){
		//this records the total matches for this entire iteration. 
		//At the end, I'll check if this is greater than two, and then trigger the destruction of its contents.
		NSMutableArray *totalMatches;

		//Identify and store the active matches to iterate through. the origin gamepiece is its own first match
		NSMutableArray *activeMatches;
		[activeMatches addObject:[[currentBoardState objectAtIndex:row] objectAtIndex:column];];

		while (sizeOf(adjacentMatches)>0){
			b2Body *gamePiece = [adjacentMatches objectAtIndex:0];
			bodyUserData *gamePieceUserData = (bodyUserData *)gamePiece->GetUserData();

			//check if the current gamepiece is already tagged to be destroyed due to a match
			if (gamePieceUserData->destroy != true){
				//Check for adjacent matches
				NSMutableArray *adjacentPieces;

				[adjacentPieces addObject: (b2Body *)[self findGamePieceLeft:gamePiece]];
				[adjacentPieces addObject: (b2Body *)[self findGamePieceRight:gamePiece]];
				[adjacentPieces addObject: (b2Body *)[self findGamePieceAbove:gamePiece]];
				[adjacentPieces addObject: (b2Body *)[self findGamePieceBelow:gamePiece]];

				for (int *adjacentPieceIndex = 0; adjacentPieceIndex < sizeOf(adjacentPieces); ++adjacentPieceIndex){
					b2Body *gamePieceAdjacent = [adjacentPieces objectAtIndex:adjacentPieceIndex];
					bodyUserData *gamePieceAdjacentUserData = (bodyUserData*)gamePieceAdjacent->GetUserData();
					if (gamePieceUserData->color == gamePieceAdjacentUserData -> color && gamePieceAdjacentUserData->destroy != true && ![totalMatches containsObject:gamePieceAdjacent]){
						[activeMatches addObject:gamePieceAdjacent];
						[totalMatches addObject:gamePieceAdjacent];
					}
				}
				[activeMatches removeObject:gamePiece];
			}		
		}
		if (sizeOf(totalMatches)>2){
			for (int destroyIndex = 0; destroyIndex < sizeOf(totalMatches); ++destroyIndex)
			{
				b2Body *pieceToDestroy = [totalMatches objectAtIndex:destroyIndex];
				pieceToDestroy->destroy = true;
			}
		}
	}
}
```

It's bulky, but it gets the job done. I didn't know anything about depth-first search algorithms before diving into this project so this was a fun case study.

#### Coordinates

This app uses a lot of math! In order to determine force vectors, I stored each gamepiece's angle once it locks into a given space.

Concurrently, I managed the board state as a 2d array. You'll see in the comments that since number of columns decreases as you get closer to the center of the grid, special care needs to be taken to translate between the rows.

```
//This is only an illustration. 
//The actual array contans objects, not integers.
NSMutableArray* currentBoardState = (NSMutableArray*)
[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], //multiply by 2 to find column
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], //multiply by 2 to find column
[1,1,1,1,1,1,1,1] //multiply by 4 to find column
]

```