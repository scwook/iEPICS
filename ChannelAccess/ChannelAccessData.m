//
//  ChannelAccessData.m
//  myChannelAccessProbe
//
//  Created by ctrl user on 26/10/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelAccessData.h"

@implementation ChannelAccessData
@synthesize name;
@synthesize value;
@synthesize host;
@synthesize access;
@synthesize dataType;
@synthesize elementCount;
@synthesize timeStampSince1990;
@synthesize timeStamp;
@synthesize alarmSeverity;
@synthesize alarmStatus;
@synthesize connected;

- (id)init {
    self = [super init];
    if (self) {
        name = @"Undefined";
        value = [[NSMutableArray alloc] init];
        host = @"Undefined";
        access = @"Undefined";
        dataType = @"Undefined";
        elementCount = 0;
        timeStampSince1990 = 0;
        timeStamp = @"Undefined";
        alarmSeverity = @"Undefined";
        alarmStatus = @"Undefined";
        connected = false;
    }

    return self;
}
@end
