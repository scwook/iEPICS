//
//  ChannelAccessData.h
//  myChannelAccessProbe
//
//  Created by ctrl user on 26/10/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

#ifndef ChannelAccessData_h
#define ChannelAccessData_h


#endif /* ChannelAccessData_h */

@interface ChannelAccessData : NSObject {
    
}
@property NSString *name;
@property NSMutableArray *value;
@property NSString *host;
@property NSString *access;
@property NSString *dataType;
@property unsigned long elementCount;
@property int timeStampSince1990;
@property NSString *timeStamp;
@property NSString *alarmSeverity;
@property NSString *alarmStatus;

@end
