//
//  ExplodeView.m
//  CircleMatch
//
//  Created by Spenser Flugum on 9/22/13.
//  Copyright (c) 2013 Blindspot Interactive. All rights reserved.
//

#import "ExplodeView.h"
#import "QuartzCore/QuartzCore.h"


@implementation ExplodeView
{
	CAEmitterLayer* _emitter;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		//initialize the emitter
		_emitter = (CAEmitterLayer*)self.layer;
		_emitter.emitterPosition = CGPointMake(self.bounds.size.width /2, self.bounds.size.height/2);
		_emitter.emitterSize = self.bounds.size;
		_emitter.emitterMode = kCAEmitterLayerAdditive;
		_emitter.emitterShape = kCAEmitterLayerRectangle;
	}
	return self;
}

+ (Class) layerClass
{
	//configure the UIView to have emitter layer
	return [CAEmitterLayer class];
}

-(void)didMoveToSuperview
{
	[super didMoveToSuperview];
	if (self.superview==nil) return;

	UIImage* texture = [UIImage imageNamed:@"starsPart.png"];

	CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];

	emitterCell.contents = (id)[texture CGImage];

	emitterCell.name = @"cell";

	NSString *version = [[UIDevice currentDevice] systemVersion];
	NSLog(@"%@", version);

	if([version rangeOfString:@"7"].length == false){
		emitterCell.birthRate = 1200;
	}
	else{
		emitterCell.birthRate = 300;
	}

	emitterCell.lifetime = 4;
	emitterCell.alphaRange = 1;
	emitterCell.alphaSpeed = -.5;
	emitterCell.redRange = .05;
	emitterCell.blueRange = 3;
	emitterCell.greenRange = .5;
	emitterCell.velocity = 300;
	emitterCell.velocityRange = 100;
	emitterCell.scaleRange = 1;
	emitterCell.scaleSpeed = -.5;
	emitterCell.emissionRange = M_PI*2;
	emitterCell.emissionLongitude = -M_PI/2;

	emitterCell.yAcceleration = 300;

	_emitter.emitterCells = @[emitterCell];

	[self performSelector:@selector(disableEmitterCell) withObject:nil afterDelay:0.1];
	[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:10.0];
}

-(void)disableEmitterCell
{
	[_emitter setValue:@0 forKeyPath:@"emitterCells.cell.birthRate"];
}

@end

