//
//  LevelParser.m
//
#import "LevelParser.h"
#import "Levels.h"
#import "Level.h"
#import "GDataXMLNode.h"

@implementation LevelParser

+ (NSString *)dataFilePath:(BOOL)forSave forChapter:(int)chapter {

	NSString *xmlFileName = [NSString stringWithFormat:@"Levels-Chapter%i",chapter];

	//***
	//set up the xml for reading and writing.

	NSString *xmlFileNameWithExtension = [NSString stringWithFormat:@"%@.xml",xmlFileName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:xmlFileNameWithExtension];
	if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
		return documentsPath;
	//NSLog(@"%@ opened for read/write",documentsPath);
	} else {
	//NSLog(@"Created/copied in default %@",xmlFileNameWithExtension);
		return [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
	}
}

+ (Levels *)loadLevelsForChapter:(int)chapter {

	//***
	//Load data from the xml file

	NSString *name;
	int number;
	BOOL unlocked;
	int stars;
	int respawn;
	int randPop;
	int gameType;
	int glow;
	int oneStar;
	int twoStar;
	int threeStar;
	NSString *data;
	NSString *solution;
	int hintsActive;
	int moves;
	int rings;
	int lockRing;
	int locks;
	Levels *levels = [[[Levels alloc] init] autorelease];

	// Create NSData instance from xml in filePath
	NSString *filePath = [self dataFilePath:FALSE forChapter:chapter];
	NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
	NSError *error;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
	//NSLog(@"Loading %@", filePath);

	NSArray *dataArray = [doc nodesForXPath:@"//Levels/Level" error:nil];
	//NSLog(@"Array Contents = %@", dataArray);

	for (GDataXMLElement *element in dataArray) {

		NSArray *nameArray = [element elementsForName:@"Name"];
		NSArray *numberArray = [element elementsForName:@"Number"];
		NSArray *unlockedArray = [element elementsForName:@"Unlocked"];
		NSArray *starsArray = [element elementsForName:@"Stars"];
		NSArray *respawnArray = [element elementsForName:@"Respawn"];
		NSArray *randPopArray = [element elementsForName:@"RandPop"];
		NSArray *gameTypeArray = [element elementsForName:@"GameType"];
		NSArray *glowArray = [element elementsForName:@"Glow"];
		NSArray *oneStarArray = [element elementsForName:@"OneStar"];
		NSArray *twoStarArray = [element elementsForName:@"TwoStar"];
		NSArray *threeStarArray = [element elementsForName:@"ThreeStar"];
		NSArray *dataArray= [element elementsForName:@"Data"];
		NSArray *solutionArray= [element elementsForName:@"Solution"];
		NSArray *hintsActiveArray= [element elementsForName:@"HintsActive"];
		NSArray *movesArray= [element elementsForName:@"Moves"];
		NSArray *ringsArray= [element elementsForName:@"Rings"];
		NSArray *lockRingArray= [element elementsForName:@"LockRing"];
		NSArray *locksArray= [element elementsForName:@"Locks"];

		// name
		if (nameArray.count > 0) {
			GDataXMLElement *nameElement = (GDataXMLElement *) [nameArray objectAtIndex:0];
			name = [nameElement stringValue];
		}

		// number
		if (numberArray.count > 0) {
			GDataXMLElement *numberElement = (GDataXMLElement *) [numberArray objectAtIndex:0];
			number = [[numberElement stringValue] intValue];
		}

		// unlocked
		if (unlockedArray.count > 0) {
			GDataXMLElement *unlockedElement = (GDataXMLElement *) [unlockedArray objectAtIndex:0];
			unlocked = [[unlockedElement stringValue] boolValue];
		}

		// stars
		if (starsArray.count > 0) {
			GDataXMLElement *starsElement = (GDataXMLElement *) [starsArray objectAtIndex:0];
			stars = [[starsElement stringValue] intValue];
		}

		// respawn
		if (respawnArray.count > 0) {
			GDataXMLElement *respawnElement = (GDataXMLElement *) [respawnArray objectAtIndex:0];
			respawn = [[respawnElement stringValue] intValue];
		}

		// randPop
		if (randPopArray.count > 0) {
			GDataXMLElement *randPopElement = (GDataXMLElement *) [randPopArray objectAtIndex:0];
			randPop = [[randPopElement stringValue] intValue];
		}

		// gameType
		if (gameTypeArray.count > 0) {
			GDataXMLElement *gameTypeElement = (GDataXMLElement *) [gameTypeArray objectAtIndex:0];
			gameType = [[gameTypeElement stringValue] intValue];
		}

		// gameType
		if (glowArray.count > 0) {
			GDataXMLElement *glowElement = (GDataXMLElement *) [glowArray objectAtIndex:0];
			glow = [[glowElement stringValue] intValue];
		}

		// oneStar
		if (oneStarArray.count > 0) {
			GDataXMLElement *oneStarElement = (GDataXMLElement *) [oneStarArray objectAtIndex:0];
			oneStar = [[oneStarElement stringValue] intValue];
		}

		// twoStar
		if (twoStarArray.count > 0) {
			GDataXMLElement *twoStarElement = (GDataXMLElement *) [twoStarArray objectAtIndex:0];
			twoStar = [[twoStarElement stringValue] intValue];
		}

		// threeStar
		if (threeStarArray.count > 0) {
			GDataXMLElement *threeStarElement = (GDataXMLElement *) [threeStarArray objectAtIndex:0];
			threeStar = [[threeStarElement stringValue] intValue];
		}

		// data
		if (dataArray.count > 0) {
			GDataXMLElement *dataElement = (GDataXMLElement *) [dataArray objectAtIndex:0];
			data = [dataElement stringValue];
		}

		// solution
		if (solutionArray.count > 0) {
			GDataXMLElement *solutionElement = (GDataXMLElement *) [solutionArray objectAtIndex:0];
			solution = [solutionElement stringValue];
		}

		// hintsActive
		if (hintsActiveArray.count > 0) {
			GDataXMLElement *hintsActiveElement = (GDataXMLElement *) [hintsActiveArray objectAtIndex:0];
			hintsActive = [[hintsActiveElement stringValue] intValue];
		}

		// moves
		if (movesArray.count > 0) {
			GDataXMLElement *movesElement = (GDataXMLElement *) [movesArray objectAtIndex:0];
			moves = [[movesElement stringValue] intValue];
		}

		// rings
		if (ringsArray.count > 0) {
			GDataXMLElement *ringsElement = (GDataXMLElement *) [ringsArray objectAtIndex:0];
			rings = [[ringsElement stringValue] intValue];
		}

		// lockRing
		if (lockRingArray.count > 0) {
			GDataXMLElement *lockRingElement = (GDataXMLElement *) [lockRingArray objectAtIndex:0];
			lockRing = [[lockRingElement stringValue] intValue];
		}

		// locks
		if (locksArray.count > 0) {
			GDataXMLElement *locksElement = (GDataXMLElement *) [locksArray objectAtIndex:0];
			locks = [[locksElement stringValue] intValue];
		}

		Level *level = [[Level alloc] initWithName:name
			number:number
			unlocked:unlocked
			stars:stars
			respawn:respawn
			randPop:randPop
			gameType:gameType
			glow:glow
			oneStar:oneStar
			twoStar:twoStar
			threeStar:threeStar
			data:data
			solution:solution
			hintsActive:hintsActive
			moves:moves
			rings:rings
			lockRing:lockRing
			locks:locks];
		[levels.levels addObject:level];
	}

	[doc release];
	[xmlData release];
	return levels;
}

+ (void)saveData:(Levels *)saveData
forChapter:(int)chapter {

	//
	//Write data to the xml

	// create the  element
	GDataXMLElement *levelsElement = [GDataXMLNode elementWithName:@"Levels"];

	// Loop through levels found in the levels array
	for (Level *level in saveData.levels) {

		
		GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level"];

		
		GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name"
			stringValue:level.name];
		
		GDataXMLElement *numberElement = [GDataXMLNode elementWithName:@"Number"
			stringValue:[[NSNumber numberWithInt:level.number] stringValue]];
		
		GDataXMLElement *unlockedElement = [GDataXMLNode elementWithName:@"Unlocked"
			stringValue:[[NSNumber numberWithBool:level.unlocked] stringValue]];
		
		GDataXMLElement *starsElement = [GDataXMLNode elementWithName:@"Stars"
			stringValue:[[NSNumber numberWithInt:level.stars] stringValue]];
		
		GDataXMLElement *respawnElement = [GDataXMLNode elementWithName:@"Respawn"
			stringValue:[[NSNumber numberWithInt:level.respawn] stringValue]];
		
		GDataXMLElement *randPopElement = [GDataXMLNode elementWithName:@"RandPop"
			stringValue:[[NSNumber numberWithInt:level.randPop] stringValue]];
		
		GDataXMLElement *gameTypeElement = [GDataXMLNode elementWithName:@"GameType"
			stringValue:[[NSNumber numberWithInt:level.gameType] stringValue]];
		
		GDataXMLElement *glowElement = [GDataXMLNode elementWithName:@"Glow"
			stringValue:[[NSNumber numberWithInt:level.glow] stringValue]];
		
		GDataXMLElement *oneStarElement = [GDataXMLNode elementWithName:@"OneStar"
			stringValue:[[NSNumber numberWithInt:level.oneStar] stringValue]];
		
		GDataXMLElement *twoStarElement = [GDataXMLNode elementWithName:@"TwoStar"
			stringValue:[[NSNumber numberWithInt:level.twoStar] stringValue]];
		
		GDataXMLElement *threeStarElement = [GDataXMLNode elementWithName:@"ThreeStar"
			stringValue:[[NSNumber numberWithInt:level.threeStar] stringValue]];

		
		GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"Data"
			stringValue:level.data];

		
		GDataXMLElement *solutionElement = [GDataXMLNode elementWithName:@"Solution"
			stringValue:level.solution];

		
		GDataXMLElement *hintsActiveElement = [GDataXMLNode elementWithName:@"HintsActive"
			stringValue:[[NSNumber numberWithInt:level.hintsActive] stringValue]];

		
		GDataXMLElement *movesElement = [GDataXMLNode elementWithName:@"Moves"
			stringValue:[[NSNumber numberWithInt:level.moves] stringValue]];

		
		GDataXMLElement *ringsElement = [GDataXMLNode elementWithName:@"Rings"
			stringValue:[[NSNumber numberWithInt:level.rings] stringValue]];

		
		GDataXMLElement *lockRingElement = [GDataXMLNode elementWithName:@"LockRing"
			stringValue:[[NSNumber numberWithInt:level.lockRing] stringValue]];

		
		GDataXMLElement *locksElement = [GDataXMLNode elementWithName:@"Locks"
			stringValue:[[NSNumber numberWithInt:level.locks] stringValue]];

		// enclose variable elements into a  element
		[levelElement addChild:nameElement];
		[levelElement addChild:numberElement];
		[levelElement addChild:unlockedElement];
		[levelElement addChild:starsElement];
		[levelElement addChild:respawnElement];
		[levelElement addChild:randPopElement];
		[levelElement addChild:gameTypeElement];
		[levelElement addChild:glowElement];
		[levelElement addChild:oneStarElement];
		[levelElement addChild:twoStarElement];
		[levelElement addChild:threeStarElement];
		[levelElement addChild:dataElement];
		[levelElement addChild:solutionElement];
		[levelElement addChild:hintsActiveElement];
		[levelElement addChild:movesElement];
		[levelElement addChild:ringsElement];
		[levelElement addChild:lockRingElement];
		[levelElement addChild:locksElement];

		// enclose each  into the  element
		[levelsElement addChild:levelElement];
	}

	// add element to the XML doc
	GDataXMLDocument *document = [[[GDataXMLDocument alloc]
		initWithRootElement:levelsElement] autorelease];

	NSData *xmlData = document.XMLData;

	// overwrite the existing file, being sure to overwrite the proper chapter
	NSString *filePath = [self dataFilePath:TRUE forChapter:chapter];
	//NSLog(@"Saving data to %@...", filePath);
	[xmlData writeToFile:filePath atomically:YES];
}

@end