//
//  PerplexityWorld.h
//
//  Created by Spenser Flugum on 9/13/13.
//  Copyright Blindspot LLC 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import "GLES-Render.h"
#import "BodyUserData.h"
#import "Constants.h"
#import "RootViewController.h"
#import "SceneManager.h"
#import "Tutorial.h"

#define PTM_RATIO 32


@protocol PerplexityWorldDelegate <NSObject>
-(void)addBlueBody;   //method from ClassA
@end

// HelloWorldLayer
@interface PerplexityWorld : CCLayer
{
    b2World* _world;
    MyContactListener *_contactListener; 
    GLESDebugDraw *_debugDraw;
    b2Body* _groundBody;
    b2Fixture* _bottomFixture;
    b2Body* _extraTBody;
    b2Fixture* _extraTFixture;
    b2Body* _coreBody;
    b2Fixture* _coreFixture;
    b2Body* _core2Body;
    b2Fixture* _core2Fixture;
    b2Body* _ring1Body;
    b2Fixture* _ring1Fixture;
    b2Body* _ring2Body;
    b2Fixture* _ring2Fixture;
    b2Body* _ring3Body;
    b2Fixture* _ring3Fixture;
    b2Body* _ring4Body;
    b2Fixture* _ring4Fixture;
    b2Body* _blueBody;
    b2Fixture* _blueFixture;
    b2Body* _outlineBody;
    b2Fixture* _outlineFixture;
    b2Body* _blueVertBody;
    b2Fixture* _blueVertFixture;
    b2Body* _blueGearBody;
    b2Fixture* _blueGearFixture;
    b2Body* _blueCageBody;
    b2Fixture* _blueCageFixture;
    b2Body* _redBody;
    b2Fixture* _redFixture;
    b2Body* _redVertBody;
    b2Fixture* _redVertFixture;
    b2Body* _redGearBody;
    b2Fixture* _redGearFixture;
    b2Body* _redCageBody;
    b2Fixture* _redCageFixture;
    b2Body* _greenBody;
    b2Fixture* _greenFixture;
    b2Body* _greenVertBody;
    b2Fixture* _greenVertFixture;
    b2Body* _greenGearBody;
    b2Fixture* _greenGearFixture;
    b2Body* _greenCageBody;
    b2Fixture* _greenCageFixture;
    b2Body* _yellowBody;
    b2Fixture* _yellowFixture;
    b2Body* _yellowVertBody;
    b2Fixture* _yellowVertFixture;
    b2Body* _yellowGearBody;
    b2Fixture* _yellowGearFixture;
    b2Body* _yellowCageBody;
    b2Fixture* _yellowCageFixture;
    b2Body* _turquoiseBody;
    b2Fixture* _turquoiseFixture;
    b2Body* _sensorBody;
    b2Fixture* _sensorFixture;
    b2Fixture* _sensor2Fixture;
    b2Body* _cageBody;
    b2Fixture* _cageFixture;
    b2Body* _guideKey;

    float32 unitSquare;    
    float32 coreRad;

    CGFloat colTest;

    b2Joint *_fuseJoint;

    b2Vec2 upRight;
    b2Vec2 upLeft;
    b2Vec2 downRight;
    b2Vec2 downRight2;
    b2Vec2 downLeft;

    b2Vec2 touchSpot;
    int velCount;

    CGPoint center;
    b2Vec2 center2;

    int spawnConst;
    int destroyCount;
    int stayCount;
    int bodyCount;
    int boxCount;
    int asleepCount;
    bool bodiesAwake;
    bool destroyBodies;
    bool justReleased;
    bool justBombed;
    bool justHammered;
    bool justTimed;
    bool snapped;
    bool justSwapped;
    bool checkDone;
    bool timeOut;

    bool topScored;
    bool topScoreIndicated;
    CCSprite* scoreLab;
    CCSprite* topScoreLab;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *topScoreLabel;

    CCSprite* scoreFill;
    CCSprite* bronze;
    CCSprite* silver;
    CCSprite* gold;


    b2WeldJoint *_ringJoint;
    b2DistanceJointDef *_snapJoint;
    b2MouseJoint *_mouseJoint;
    b2MouseJoint *_mouseJoint2;
    b2RevoluteJoint *_spinJoint;
    b2RevoluteJoint *_spin2Joint;
    b2RevoluteJoint *_spin3Joint;
    b2RevoluteJoint *_spin4Joint;
    b2RevoluteJointDef r1j;

    int fuses;
    int storedCol;
    int storedRing;
    int gameType;
    int glowNum;
    int firstArcade;



    int time;
    int hiddenTime;
    CCLabelTTF *timerLabel;
    CCSprite* timeIcon;
    CGPoint timeP1;
    CGPoint timeP2;
    CGPoint movesP1;
    CGPoint movesP2;
    CGPoint scoreP1;
    CGPoint scoreP2;
    CGPoint topscoreP1;
    CGPoint topscoreP2;
    CGPoint goalP1;
    CGPoint goalP2;
    float32 maxMoves;
    int moves;
    CCLabelTTF *movesLabel;
    CCSprite* movesIcon;
    CCSprite* goalLab;
    CCLabelTTF *goalLabel;


    int randColor;
    NSString *prandStack;
    int prandFromStack;
    int randR;
    int randT;
    int outerBoxes[32];

    int hintFromRing;
    int hintFromCol;
    int hintToRing;
    int hintToCol;

    int hintStage;

    bool hintsActive;
    bool hintsDone;
    bool swapped;
    bool hintCalled;
    //NSMutableArray *outerBoxes;


    CCSprite *outlineSprite;
    CCSprite *extraTime;
    CCSprite *blue;
    CCSprite *blueVert;
    CCSprite *blueGear;
    CCSprite *blueCage;
    CCSprite *blueLock;
    CCSprite *red;
    CCSprite *redVert;
    CCSprite *redGear;
    CCSprite *redCage;
    CCSprite *redLock;
    CCSprite *green;
    CCSprite *greenVert;
    CCSprite *greenGear;
    CCSprite *greenCage;
    CCSprite *greenLock;
    CCSprite *yellow;
    CCSprite *yellowVert;
    CCSprite *yellowGear;
    CCSprite *yellowCage;
    CCSprite *yellowLock;
    CCSprite *turquoise;
    CCSprite *cage;

    CCSprite *background;
    CCSprite *background2;
    CCSprite *shade;
    CCSprite *freeze;
    CCSprite *boxGlow;

    CCSprite *flash1;
    CCSprite *flash2;
    CCSprite *flash3;
    CCSprite *flash4;

    CCSprite *rotateGuide;
    bool rotateGuiding;
    CCSprite* great;
    CCSprite* fantastic;
    CCSprite* amazing;

    //MODES
    bool respawnMode;
    bool arcadeMode;
    bool newGem;

    bool spawned;
    bool freezeActive;
    bool bombActive;
    bool hammerActive;
    bool doubleActive;
    bool gameDone;
    bool bronzed;
    bool silvered;
    bool golded;
    bool bronzed1;
    bool silvered1;
    bool golded1;
    int scoreFactor;
    int cageCount;
    int lockCount;
    int clockCount;
    int vertCount;
    int gearCount;
    int rings;
    int score;
    int scoreInTouch;
    int timeInTouch;

    float32 bronzeHeight;
    float32 silverHeight;
    float32 goldHeight;

    float32 ringGuided;
    float32 rotateDiff;
    bool rotateNoTouch;

    int extraTimeGoal;
    bool spawnTime;
    bool spawnLock;
    bool greatIndicated;
    bool amazingIndicated;
    bool fantasticIndicated;
    bool greatThisTouch;
    bool amazingThisTouch;
    bool fantasticThisTouch;

    CGPoint scorePosition;
    bool paused;
    bool endCalled;
    bool locksSeen;
    bool lockInstructed;
    bool clocksSeen;
    bool clockInstructed;
    int loadReg;
    int snapCount;

    float32 threeStar;
    int oneStar;
    int stars;
    int gameLevel;
    int gameChapter;
    int instructStep;
    int instruct2Step;
    int instruct3Step;
    int instruct5Step;
    int instruct51Step;
    int instruct6Step;
    bool wasInstructed;
    int lockedRing;
    float32 topScore;
    float32 scoreIpad;
    float32 barSize;
    NSString *data;

    CCSprite* black;
    CCSprite* black2;
    CCSprite* glow;
    CCSprite* glow2;
    CCSprite* frame;
    CCSprite* backing;
    CCSprite* puGlow;
    CCLabelTTF *lockInstruction;
    CCLabelTTF *lockInstruction2;
    CCLabelTTF *lockInstruction3;
    CCLabelTTF *lockInstruction4;
    CCLabelTTF *lockInstruction5;

    CCLabelTTF* instruction1;
    CCLabelTTF* instruction2;
    CCLabelTTF* instruction3;
    CCLabelTTF* instruction4;
    CCLabelTTF* instruction5;
    CCLabelTTF* instruction6;
    CCLabelTTF* instruction7;
    CCLabelTTF* instruction8;
    CCLabelTTF* instruction9;
    CCLabelTTF* instruction10;
    CCLabelTTF* instruction11;
    CCLabelTTF* instruction12;
    CCLabelTTF* instruction13;
    CCLabelTTF* instruction14;
    CCLabelTTF* instruction15;

    CCLabelTTF* gemsLeftLabel;
    CCLabelTTF* tapLabel;

    float32 lastClickAngle;
    float32 firstClickAngle;
    bool fallOk;
    int fallCount;
    float popCount;
    bool locks;

    int orient;
    bool autoOrientation;
    bool lvl1Snapped;
    bool autoRetried;
    int returnCount;

    int testCount;

    bool timedMode;
    bool zenMode;
    bool isTutorial;
    int tutStage;
    int PUsInit;
    int PUsOver;
}


@property (assign) id <PerplexityWorldDelegate> delegate;
@property(nonatomic, readonly) UIDeviceOrientation orientation;

+ (id) scene;

extern NSString * const ARCADE;
extern NSString * const PUZZLE;
extern NSString * const TIME;
extern NSString * const FREEZE;
extern NSString * const DOUBLE;
extern NSString * const BOMB;
extern NSString * const HAMMER;
extern NSString * const PAUSE;
extern NSString * const UNPAUSE;
extern NSString * const MOVESBOUGHT;
extern NSString * const GEM;
extern NSString * const OUTGREEN;
extern NSString * const OUTRED;
extern NSString * const OUTWHITE;
extern NSString * const ZEN;
extern NSString * const TIMED;
extern NSString * const OVERCALL;
extern NSString * const TUTO;
extern NSString * const POWER;


-(void) addRing1Body:(CGPoint)p;
-(void) addRing2Body:(CGPoint)p;
-(void) addRing3Body:(CGPoint)p;
-(void) addRing4Body:(CGPoint)p;
-(void) addCoreBody:(CGPoint)p;

@end
