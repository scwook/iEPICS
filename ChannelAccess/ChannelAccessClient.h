//
//  ChannelAccessClient.h
//  myChannelAccessProbe
//
//  Created by ctrl user on 15/09/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelAccessData.h"
#import "cadef.h"

static const unsigned short max_pv = 100;
//static void eventCallback( struct event_handler_args eha );
static void connectionCallback( struct connection_handler_args cha );
static void instantConnectionCallback( struct connection_handler_args cha);

static void eventCallbackString( evargs eha );
static void eventCallbackShort( evargs eha );
static void eventCallbackFloat( evargs eha );
static void eventCallbackEnum( evargs eha );
static void eventCallbackLong( evargs eha );
static void eventCallbackDouble( evargs eha );

const char *epicsAlarmSeverityStrings[] = {
    "NO_ALARM",
    "MINOR",
    "MAJOR",
    "INVALID"
};
const char *epicsAlarmConditionStrings[] = {
    "NO_ALARM",
    "READ",
    "WRITE",
    "HIHI",
    "HIGH",
    "LOLO",
    "LOW",
    "STATE",
    "COS",
    "COMM",
    "TIMEOUT",
    "HWLIMIT",
    "CALC",
    "SCAN",
    "LINK",
    "SOFT",
    "BAD_SUB",
    "UDF",
    "DISABLE",
    "SIMM",
    "READ_ACCESS",
    "WRITE_ACCESS"
};

typedef struct {
    //char    value[20];
    chid    chid;
    evid    evid;
    
} CANODE;

@interface ChannelAccessClient : NSObject {
    CANODE *myCAnode[max_pv];
    CANODE *instantCAnode;
    
    NSMutableDictionary *pvDictionary;
    NSMutableDictionary *pvDictionaryIndex;
    NSMutableArray *pvGetArray;
    NSMutableArray *pvArrayData;
}

+ (instancetype)sharedObject;
- (instancetype)initPrivate;
- (BOOL)ChannelAccessAddProcessVariable:(NSString *)pvName;
//- (BOOL)ChannelAccessAddProcessVariableForDatabrowser:(NSString *)pvName;

- (BOOL)ChannelAccessRemoveProcessVariable:(NSString *)pvName;
- (void)ChannelAccessRemoveProcessVariable;
- (void)ChannelAccessRemoveAll;
- (void)ChannelAccessContextCreate;
- (void)ChannelAccessContexDestroy;
- (void)ChannelAccessCreateChannel:(unsigned long)pvNameIndex key:(NSString *)pvName;
- (long)ChannelAccessCreateChannel:(NSString *)pvName;
- (void)ChannelAccessClearChannel;

//- (void)ChannelAccessCreateChannelForDatabrowser:(unsigned long)pvNameIndex key:(NSString *)pvName;

- (void)ChannelAccessPendEvent:(double)timeOut;
- (NSString *)ChannelAccessGetValue:(NSString *)pvName;

- (void)ChannelAccessPut:(NSString *)pvName;
- (void)ChannelAccessGet;
//- (void)ChannelAccessGet:(NSString *)pvName;

- (NSMutableDictionary *)ChannelAccessGetDictionary;
- (NSMutableDictionary *)ChannelAccessGetIndexDictionary;
- (void)ChannelAccessSetDictionary:(NSMutableDictionary *)refDictionary;
- (void)ChannelAccessSetDictionaryIndex:(NSMutableDictionary *)refDictionaryIndex;
- (void)ChannelAccessSetGetArray:(NSMutableArray *)pvValueArray;
- (NSMutableArray *)ChannelAccessGetArray;
- (unsigned long)ChannelAccessGetAvailableIndex;
- (NSString *)ChannelAccessGetHostName:(chid)chan;
//- (long)ChannelAccessGetType:(chid)chan;
- (NSMutableArray *)ChannelAccessGetArrayData;
- (void)ChannelAccessStatusCheck:(int)status;
- (ChannelAccessData *)ChannelAccessGetCAData:(NSString *)pvName;
- (void)ChannelAccessSetCAData:(ChannelAccessData *)CAData name:(NSString *)pvName;
- (void)ChannelAccessArrayDataRemoveAll;
- (void)ChannelAccessArrayDataAddObject:(double)value;
- (void)ChannelAccessAllClear;
- (NSString *)ChannelAccessGetIPAddress;
- (void)ChannelAccessSetEnvironment:(NSString *)envName key:(NSString *)value;

@end


