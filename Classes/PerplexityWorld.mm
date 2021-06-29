//
//  PerplexityWorld.mm
//
//  Created by Spenser Flugum on 9/13/13.
//  Copyright Blindspot LLC 2013. All rights reserved.
//


// Import the interfaces
#import "PerplexityWorld.h"
#import "CCTouchDispatcher.h"

#define PTM_RATIO 32
#define RADIANS_TO_DEGREES(__ANGLE__)((__ANGLE__) / M_PI * 180.0)
#define DEGREES_TO_RADIANS(__ANGLE__)(M_PI * 180.0 / (__ANGLE__))

@implementation PerplexityWorld

+ (id)scene {

    CCScene *scene = [CCScene node];
    PerplexityWorld *layer = [PerplexityWorld node];
    [scene addChild:layer];
    return scene;
}

- (id)init {

    self=[super init];

    if (self) {

        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;

        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        bool doSleep = true;
        _world = new b2World(gravity, doSleep);

        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        _groundBody = _world->CreateBody(&groundBodyDef);
        b2PolygonShape groundBox;
        b2FixtureDef groundBoxDef;
        groundBoxDef.shape = &groundBox;
        groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
        _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
        groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&groundBoxDef);
        groundBox.SetAsEdge(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
        _groundBody->CreateFixture(&groundBoxDef);
        groundBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
        _groundBody->CreateFixture(&groundBoxDef);

        unitSquare = .75;
        coreRad = 1;

        CGPoint PolToRect(float32, float32);

        center = ccp(winSize.width/(2*PTM_RATIO), (winSize.height/(2*PTM_RATIO)));
        center2 = b2Vec2(winSize.width/(2*PTM_RATIO), (winSize.height/(2*PTM_RATIO)));
        upRight = b2Vec2((winSize.width/(2*PTM_RATIO)) + (1.55+.75+6.4)/(2 * sqrt(2)), (winSize.height/(2*PTM_RATIO)) + (1.55+.75+6.4)/(2 * sqrt(2)));
        upLeft = b2Vec2((winSize.width/(2*PTM_RATIO)) - (1.55+.75+6.4)/(2 * sqrt(2)), (winSize.height/(2*PTM_RATIO)) + (1.55+.75+6.4)/(2 * sqrt(2)));
        downRight = b2Vec2((winSize.width/(2*PTM_RATIO)) + (1.55+.75+6.4)/(2 * sqrt(2)), (winSize.height/(2*PTM_RATIO)) - (1.55+.75+6.4)/(2 * sqrt(2)));
        downRight2 = b2Vec2(center.x + ((unitSquare)/2 + coreRad)*cosf(7*M_PI/4),center.y + ((unitSquare)/2 + coreRad)*sinf(7*M_PI/4));
        downLeft = b2Vec2((winSize.width/(2*PTM_RATIO)) - (1.55+.75+6.4)/(2 * sqrt(2)), (winSize.height/(2*PTM_RATIO)) - (1.55+.75+6.4)/(2 * sqrt(2)));

        [self addCoreBody: center];
        [self addBlueBody: PolToRect(3, 4)];

        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);

        _debugDraw = new GLESDebugDraw( PTM_RATIO );
        _world->SetDebugDraw(_debugDraw);

        uint32 flags = 0;
        flags += b2DebugDraw::e_shapeBit;
        _debugDraw->SetFlags(flags);

        [self schedule: @selector(tick:) interval:(1.0/1000000000.0)];  

    }
    return self;
}

-(void) tick: (ccTime) dt
{
    _world->Step(dt, 20, 20);
    for(b2Body *b = _world->GetBodyList(); b; b = b->GetNext()) { 
        if (b->GetUserData() != NULL){
            b2Body *bodyB = b->GetNext();
            bodyUserData* bud = (bodyUserData*)b->GetUserData();
            bodyUserData* budB = (bodyUserData*)bodyB->GetUserData();

            //Set the Ring and Column coordinates for each tile
            if (bud->box == true){
                b2Vec2 bodRad = b->GetWorldCenter() - _coreBody->GetWorldCenter();
                float32 bodAngle = b->GetAngle();
                float32 radLength = bodRad.Length();

                while (bodAngle <= 0){
                    bodAngle += 2*M_PI;
                }
                while (bodAngle > 2*M_PI){
                    bodAngle -= 2*M_PI;
                }

                bud->ringNum = abs((radLength - coreRad + (unitSquare/2))/unitSquare) ;

                if ((((15*M_PI/8) < bodAngle) && (bodAngle < 2*M_PI)) || ((0 < bodAngle) && (bodAngle < (M_PI/8)))){
                    bud->colNum = 0;
                }
                if (((M_PI/8) < bodAngle) && (bodAngle < (3*M_PI/8))){
                    bud->colNum = 1;
                }
                if ((3*M_PI/8) < bodAngle && bodAngle < (5*M_PI/8)){
                    bud->colNum = 2;
                }
                if (5*M_PI/8 < bodAngle && bodAngle < 7*M_PI/8){
                    bud->colNum = 3.0f;  
                }
                if ((7*M_PI/8) < bodAngle && bodAngle < (9*M_PI/8)){
                    bud->colNum = 4;
                }
                if (((9*M_PI/8) < bodAngle) && (bodAngle < (11*M_PI/8))){
                    bud->colNum = 5;
                }
                if ((11*M_PI/8) < bodAngle && bodAngle < (13*M_PI/8)){
                    bud->colNum = 6;
                }
                if ((13*M_PI/8) < bodAngle && bodAngle < (15*M_PI/8)){
                    bud->colNum = 7;
                }
                colTest = bud->colNum;        

                //End Ring&Column        

                //somehow box2d is interpreting both bodies in the same column, so this helps mitigate that        
                if (budB->box == true) {    
                    if ((bud->colNum == budB->colNum) && ((bud->ringNum == budB->ringNum + 1) || (bud->ringNum == budB->ringNum - 1))&& _mouseJoint == NULL) {
                        _world->DestroyBody(b);
                        _world->DestroyBody(bodyB);
                    }
                }
            }

            if (b->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
                if (_mouseJoint == NULL){
                    b->SetLinearVelocity(b2Vec2(0,0));
                }
            }
        }
    }
}

CGPoint PolToRect(float32 r, float32 t){
    CGSize winSize = [CCDirector sharedDirector].winSize;

    float32 unitSquare = .75;
    float32 coreRad = 1;
    CGPoint center = ccp(winSize.width/(2*PTM_RATIO), (winSize.height/(2*PTM_RATIO)));
    float32 theta = t * (M_PI/4);
    float32 radius = coreRad - (unitSquare)/2 + r*(unitSquare);
    float32 x = (radius*cos(theta)) + center.x;
    float32 y = (radius*sin(theta)) + center.y;

    return CGPoint(ccp(x,y));
}

-(void) addCoreBody:(CGPoint)p {
    b2BodyDef coreBodyDef;
    coreBodyDef.type = b2_staticBody;
    coreBodyDef.position.Set(p.x, p.y);
    bodyUserData* budCore = new bodyUserData();
    coreBodyDef.userData = budCore;
    coreBodyDef.bullet = true;
    _coreBody = _world->CreateBody(&coreBodyDef);
    
    // Create circle shape
    b2CircleShape coreCircle;
    coreCircle.m_radius = coreRad;
    
    // Create shape definition and add to body
    b2FixtureDef coreShapeDef;
    coreShapeDef.shape = &coreCircle;
    coreShapeDef.isSensor = true;

    _coreFixture = _coreBody->CreateFixture(&coreShapeDef);
}

-(void) addRing1Body:(CGPoint)p {
    b2BodyDef ring1BodyDef;
    ring1BodyDef.type = b2_dynamicBody;
    ring1BodyDef.position.Set(p.x, p.y);
    bodyUserData* budRing1 = new bodyUserData();
    budRing1->ring = true;
    ring1BodyDef.userData = budRing1;
    ring1BodyDef.bullet = true;
    _ring1Body = _world->CreateBody(&ring1BodyDef);

    // Create circle shape
    b2CircleShape ring1Circle;
    ring1Circle.m_radius = 1.25;

    // Create shape definition and add to body
    b2FixtureDef ring1ShapeDef;
    ring1ShapeDef.shape = &ring1Circle;
    ring1ShapeDef.density = 25.0f;
    ring1ShapeDef.isSensor = true;
    ring1ShapeDef.friction = 0.0f; // We don't want the tile to have friction!
    ring1ShapeDef.restitution = 1.0f;

    _ring1Fixture = _ring1Body->CreateFixture(&ring1ShapeDef);

    b2RevoluteJointDef spin1JointDef;
    spin1JointDef.bodyA = _coreBody;
    spin1JointDef.bodyB = _ring1Body;
    spin1JointDef.collideConnected = false;
    _spinJoint = (b2RevoluteJoint*)_world->CreateJoint( &spin1JointDef );
}

-(void) addRing2Body:(CGPoint)p {
    b2BodyDef ring2BodyDef;
    ring2BodyDef.type = b2_dynamicBody;
    ring2BodyDef.position.Set(p.x, p.y);
    bodyUserData* budRing2 = new bodyUserData();
    budRing2->ring = true;
    ring2BodyDef.userData = budRing2;
    ring2BodyDef.bullet = true;

    _ring2Body = _world->CreateBody(&ring2BodyDef);

    // Create circle shape
    b2CircleShape ring2Circle;
    ring2Circle.m_radius = 1.75;

    // Create shape definition and add to body
    b2FixtureDef ring2ShapeDef;
    ring2ShapeDef.shape = &ring2Circle;
    ring2ShapeDef.density = 25.0f;
    ring2ShapeDef.isSensor = true;
    ring2ShapeDef.friction = 0.0f; // We don't want the ball to have friction!
    ring2ShapeDef.restitution = 1.0f;

    _ring2Fixture = _ring2Body->CreateFixture(&ring2ShapeDef);

    b2RevoluteJointDef spin2JointDef;
    spin2JointDef.bodyA = _coreBody;
    spin2JointDef.bodyB = _ring2Body;
    spin2JointDef.collideConnected = false;
    _spin2Joint = (b2RevoluteJoint*)_world->CreateJoint( &spin2JointDef );
}

-(void) addRing3Body:(CGPoint)p {
    b2BodyDef ring3BodyDef;
    ring3BodyDef.type = b2_dynamicBody;
    ring3BodyDef.position.Set(p.x, p.y);
    bodyUserData* budRing3 = new bodyUserData();
    budRing3->ring = true;
    ring3BodyDef.userData = budRing3;
    ring3BodyDef.bullet = true;

    _ring3Body = _world->CreateBody(&ring3BodyDef);

    // Create circle shape
    b2CircleShape ring3Circle;
    ring3Circle.m_radius = 2.25;

    // Create shape definition and add to body
    b2FixtureDef ring3ShapeDef;
    ring3ShapeDef.shape = &ring3Circle;
    ring3ShapeDef.density = 25.0f;
    ring3ShapeDef.isSensor = true;
    ring3ShapeDef.friction = 0.0f; // We don't want the ball to have friction!
    ring3ShapeDef.restitution = 1.0f;

    _ring3Fixture = _ring3Body->CreateFixture(&ring3ShapeDef);

    b2RevoluteJointDef spin3JointDef;
    spin3JointDef.bodyA = _coreBody;
    spin3JointDef.bodyB = _ring3Body;
    spin3JointDef.collideConnected = false;
    _spin3Joint = (b2RevoluteJoint*)_world->CreateJoint( &spin3JointDef );
}

-(void) addRing4Body:(CGPoint)p {
    b2BodyDef ring4BodyDef;
    ring4BodyDef.type = b2_dynamicBody;
    ring4BodyDef.position.Set(p.x, p.y);
    bodyUserData* budRing4 = new bodyUserData();
    budRing4->ring = true;
    ring4BodyDef.userData = budRing4;
    ring4BodyDef.bullet = true;

    _ring4Body = _world->CreateBody(&ring4BodyDef);

    // Create circle shape
    b2CircleShape ring4Circle;
    ring4Circle.m_radius = 2.75;

    // Create shape definition and add to body
    b2FixtureDef ring4ShapeDef;
    ring4ShapeDef.shape = &ring4Circle;
    ring4ShapeDef.density = 1000.0f;
    ring4ShapeDef.isSensor = true;
    ring4ShapeDef.friction = 0.0f; // We don't want the ball to have friction!

    _ring4Fixture = _ring4Body->CreateFixture(&ring4ShapeDef);

    b2RevoluteJointDef spin4JointDef;
    spin4JointDef.bodyA = _coreBody;
    spin4JointDef.bodyB = _ring4Body;
    spin4JointDef.collideConnected = false;
    _spin4Joint = (b2RevoluteJoint*)_world->CreateJoint( &spin4JointDef );
}

-(void) addBlueBody:(CGPoint)p {
    b2Vec2 distance = b2Vec2(p.x, p.y) - _coreBody->GetWorldCenter();
    distance.Normalize();
    float32 distanceLength = distance.Length();

    b2BodyDef blueBodyDef;
    blueBodyDef.type = b2_dynamicBody;
    blueBodyDef.position.Set(p.x, p.y);
    blueBodyDef.angle = acosf(distance.x/distanceLength);
    bodyUserData* budBlue = new bodyUserData();
    budBlue->box = true;
    budBlue->blue = true;
    blueBodyDef.userData = budBlue;
    blueBodyDef.bullet = true;

    _blueBody = _world->CreateBody(&blueBodyDef);

    // Create circle shape
    b2PolygonShape blueBox;
    blueBox.SetAsBox(unitSquare/2, unitSquare/2);

    // Create shape definition and add to body
    b2FixtureDef blueShapeDef;
    blueShapeDef.shape = &blueBox;
    blueShapeDef.density = 1.0f;
    blueShapeDef.isSensor = true;
    blueShapeDef.friction = 0.0f; // We don't want the ball to have friction!
    blueShapeDef.restitution = 10.0f;

    _blueFixture = _blueBody->CreateFixture(&blueShapeDef);

    b2RevoluteJointDef rj;
    rj.Initialize(_blueBody, _coreBody, _coreBody->GetPosition());

    rj.collideConnected = false;

    _world->CreateJoint(&rj);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);

    CGPoint p1;
    CGPoint p2 = [myTouch locationInView:[myTouch view]];
    p2 = [[CCDirector sharedDirector] convertToGL:p2];

    if ([touches count] != 2) {
        for (UITouch * t in touches) {
            p1 = [t locationInView:[t view]];
            p1 = [[CCDirector sharedDirector] convertToGL:p1];
        }
    }

    int step = 0;

    for (UITouch * t in touches) {
        // get coordinates
        if (step == 0){
            p1 = [t locationInView:[t view]];
            p1 = [[CCDirector sharedDirector] convertToGL:p1];
        }
        if (step != 0) {
            p2 = [t locationInView:[t view]];
            p2 = [[CCDirector sharedDirector] convertToGL:p2];
        }
        step = 1;
    }

    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) { 

        if (_mouseJoint != NULL) return;

        bodyUserData* bud = (bodyUserData*)b->GetUserData();
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        b2Fixture *f = b->GetFixtureList();

        if (f->TestPoint(locationWorld)) {
            b2MouseJointDef md;
            md.bodyA = _groundBody;
            md.bodyB = b;
            md.target = locationWorld;
            md.collideConnected = true;
            md.maxForce = 1000.0f * b->GetMass();

            _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
            b->SetAwake(true);
        }
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);

    CGPoint p1;
    CGPoint p2 = [myTouch locationInView:[myTouch view]];
    p2 = [[CCDirector sharedDirector] convertToGL:p2];

    if (_mouseJoint != NULL) {
        _mouseJoint->SetTarget(locationWorld);
    }

    if ([touches count] != 2) {
        for (UITouch * t in touches) {
            p1 = [t locationInView:[t view]];
            p1 = [[CCDirector sharedDirector] convertToGL:p1];
        }
    }

    int step = 0;

    for (UITouch * t in touches) {
        // get coordinates
        if (step == 0){
            p1 = [t locationInView:[t view]];
            p1 = [[CCDirector sharedDirector] convertToGL:p1];
        }
        if (step != 0) {
            p2 = [t locationInView:[t view]];
            p2 = [[CCDirector sharedDirector] convertToGL:p2];
        }
        step = 1;
    }

    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) { 
        if (_mouseJoint != NULL) return;

        bodyUserData* bud = (bodyUserData*)b->GetUserData();

        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        b2Fixture *f = b->GetFixtureList();

        if (f->TestPoint(locationWorld)) {
            return;
        }
    }
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {  
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);

    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }  

    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) { 
        if (b->GetUserData() != NULL){
            bodyUserData* bud = (bodyUserData*)b->GetUserData();

            b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
            b2Fixture *f = b->GetFixtureList();

            if (bud->box == true) {

                b2Vec2 bodRad = b->GetWorldCenter() - _coreBody->GetWorldCenter();
                float32 bodAngle = b->GetAngle();
                float32 radLength = bodRad.Length();
                float32 angleSnap = (bud->colNum * (M_PI/4));
                b2Vec2 posSnap = b2Vec2(center.x + radLength*cosf(angleSnap),center.y + radLength*sinf(angleSnap));

                b->SetTransform(posSnap, angleSnap);
                b->SetLinearVelocity(b2Vec2(0,0));
            }
        }
    }

    if ([touches count] != 2) {
        return;
    }

    CGPoint p1;
    CGPoint p2 = [myTouch locationInView:[myTouch view]];
    p2 = [[CCDirector sharedDirector] convertToGL:p2];
    int step = 0;

    for (UITouch * t in touches) {
    // get coordinates
        if (step == 0) p1 = [t locationInView:[t view]];
        else {
            p2 = [t locationInView:[t view]];
        }
        step = 1;
    }
}

-(void) draw
{

    bodyUserData* bud = (bodyUserData*)_blueBody->GetUserData();

    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states:  GL_VERTEX_ARRAY, 
    // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);

    _world->DrawDebugData();

    // restore default GL states
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);


    ccDrawCircle( ccp(240, 160), (1 + unitSquare) * PTM_RATIO, 0, 64, NO);
    ccDrawCircle( ccp(240, 160), (1 + 2*unitSquare) * PTM_RATIO, 0, 64, NO);
    ccDrawCircle( ccp(240, 160), (1 + 3*unitSquare) * PTM_RATIO, 0, 64, NO);
    ccDrawCircle( ccp(240, 160), (1 + 4*unitSquare) * PTM_RATIO, 0, 64, NO);
    ccDrawCircle( ccp(240, 160), (1 + 5*unitSquare) * PTM_RATIO, 0, 64, NO);

    ccDrawCircle( ccp(0, 20*(colTest)), (1) * PTM_RATIO, 0, 64, NO);
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {

    delete _world;
    _world = NULL;
    [super dealloc];
    delete _contactListener;
    delete _debugDraw;

    _coreBody = NULL;
    _ring1Body = NULL;
    _ring2Body = NULL;

    colTest = NULL;
}
@end
