//
//  ChannelAccessClient.m
//  myChannelAccessProbe
//
//  Created by ctrl user on 15/09/2017.
//  Copyright © 2017 scwook. All rights reserved.
//

#import "ChannelAccessClient.h"
#import <iEPICS-Swift.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

static ChannelAccessNotification *notification;

@implementation ChannelAccessClient

- (instancetype)init {
    @throw [NSException exceptionWithName:@"ChannelAccess is a Singleton" reason:@"" userInfo:nil];
}

+ (instancetype)sharedObject {
    static ChannelAccessClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{   // dispatch_once를 통해 객체를 획득하는 부분의 상호배제
        if (!instance) {
            instance = [[ChannelAccessClient alloc] initPrivate];
        }
    });
    return instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        pvDictionary = [[NSMutableDictionary alloc] init];
        pvDictionaryIndex = [[NSMutableDictionary alloc] init];
        
        pvGetArray = [[NSMutableArray alloc] initWithCapacity: 2];
        pvArrayData = [[NSMutableArray alloc] init];
        
        notification = [[ChannelAccessNotification alloc] init];
//        NSLog(@"Create ChannelAccess");
//
//        NSString *ipaddr = [self ChannelAccessGetIPAddress];
//
//        NSLog(@"%@", ipaddr);
    }
    return self;
}

- (NSMutableDictionary *)ChannelAccessGetDictionary {
    
    return pvDictionary;
}

- (NSMutableDictionary *)ChannelAccessGetIndexDictionary {
    return pvDictionaryIndex;
}

- (void)ChannelAccessSetDictionary:(NSMutableDictionary *)refDictionary {
    pvDictionary = refDictionary;
}

- (void)ChannelAccessSetDictionaryIndex:(NSMutableDictionary *)refDictionaryIndex {
    pvDictionaryIndex = refDictionaryIndex;
}

- (void)ChannelAccessSetGetArray:(NSMutableArray *)pvValueArray {
    pvGetArray = pvValueArray;
    [pvGetArray addObject: [NSNumber numberWithDouble: 0.0]];
    [pvGetArray addObject: [NSNumber numberWithInt: 0]];
}

- (NSMutableArray *)ChannelAccessGetArray {
    
    struct dbr_time_double *pTD;
    unsigned nBytes;
    unsigned long elementCount = ca_element_count(instantCAnode->chid);
    
    nBytes = dbr_size_n(DBR_TIME_DOUBLE, elementCount);
    pTD = ( struct dbr_time_double *)malloc(nBytes);
    
    int status = ca_array_get(DBR_TIME_DOUBLE, elementCount, instantCAnode->chid, pTD);
    
    [self ChannelAccessStatusCheck:status];
    
    ca_pend_io(5.0);
    
    const dbr_double_t * pValue;
    pValue = & pTD->value;
    
    NSMutableArray *arrayData = [[NSMutableArray alloc] initWithCapacity: elementCount];

    for(int i = 0; i < elementCount; i++) {
        [arrayData addObject: [NSNumber numberWithDouble: pValue[i]]];
    }
    
    free(pTD);
    
    return arrayData;
}

- (void)ChannelAccessContextCreate {
    int status = ECA_NORMAL;
    
//    [self ChannelAccessContexDestroy];

    if( ca_current_context() == NULL ) {
        status = ca_context_create(ca_enable_preemptive_callback);
    }

    [self ChannelAccessStatusCheck:status];
}

- (void)ChannelAccessContexDestroy {
    if( ca_current_context() ) {
        ca_context_destroy();
    }
}

- (void)ChannelAccessPendEvent:(double)timeOut {
    ca_pend_io(timeOut);
}

- (unsigned long)ChannelAccessGetAvailableIndex {
    NSUInteger keyIndex = 0;
    //unsigned long repeatIndex = 0;
    unsigned long index = 0;
    NSArray *pvDataIndexLists = [pvDictionaryIndex allValues];

    for( keyIndex = 0; keyIndex <= pvDataIndexLists.count; keyIndex++) {
        if( [pvDataIndexLists containsObject:[NSNumber numberWithInteger:keyIndex]] ) {
            continue;
        }
        else {
            index = keyIndex;
        }
    }
    return index;
}

- (void)ChannelAccessCreateChannel:(unsigned long)pvNameIndex key:(NSString *)pvName {
    const char *pname = [pvName UTF8String];
    unsigned long index = pvNameIndex;

    myCAnode[index] = calloc(1, sizeof(CANODE));
    int status = ca_create_channel(pname, connectionCallback, myCAnode[index], 20, &myCAnode[index]->chid);

    [self ChannelAccessStatusCheck:status];
}

- (void)ChannelAccessCreateChannelForDatabrowser:(unsigned long)pvNameIndex key:(NSString *)pvName {
    const char *pname = [pvName UTF8String];
    unsigned long index = pvNameIndex;

    myCAnode[index] = calloc(1, sizeof(CANODE));
    int status = ca_create_channel(pname, instantConnectionCallback, myCAnode[index], 20, &myCAnode[index]->chid);

    [self ChannelAccessStatusCheck:status];
}

- (long)ChannelAccessCreateChannel:(NSString *)pvName {
    const char *pname = [pvName UTF8String];
    
    if( instantCAnode != NULL) {
        ca_clear_channel(instantCAnode->chid);
        free(instantCAnode);
    }
    
    instantCAnode = calloc(1, sizeof(CANODE));
//    ca_create_channel(pname, instantConnectionCallback, instantCAnode, 20, &instantCAnode->chid);
    ca_create_channel(pname, NULL, NULL, 20, &instantCAnode->chid);

    ca_pend_io(1.0);
    
    long elementCount = ca_element_count(instantCAnode->chid);

    return elementCount;
}

- (void)ChannelAccessGet {

    struct dbr_time_double *pTD;
    unsigned nBytes;
    
    nBytes = dbr_size_n(DBR_TIME_DOUBLE, 1);
//    NSLog(@"%d, %d", nBytes, sizeof(DBR_TIME_DOUBLE));
    pTD = ( struct dbr_time_double * )malloc(nBytes);

    ca_get(DBR_TIME_DOUBLE, instantCAnode->chid, pTD);

    id preValue = [pvGetArray objectAtIndex: 0];
    epicsUInt32 preTimestamp = [[pvGetArray objectAtIndex: 1] unsignedIntValue];
    
    if( ca_pend_io(0.01) == ECA_NORMAL ) {
        double value = pTD->value;
        epicsUInt32 timestamp = pTD->stamp.secPastEpoch;
        
        [pvGetArray removeAllObjects];

        [pvGetArray addObject: [NSNumber numberWithDouble: value]];
        [pvGetArray addObject: [NSNumber numberWithInt: timestamp]];
    }
    else {
        [pvGetArray removeAllObjects];

        [pvGetArray addObject: preValue];
        [pvGetArray addObject: [NSNumber numberWithInt: preTimestamp + 1]];
    }
    
    free(pTD);
}

- (void)ChannelAccessGet:(NSString *)pvName {

}

- (void)ChannelAccessClearChannel:(unsigned long)index {

    //ca_clear_subscription(myCAnode[index]->evid);
    ca_clear_channel(myCAnode[index]->chid);
}

- (BOOL)ChannelAccessRemoveProcessVariable:(NSString *)pvName {
//    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];
//
//    NSMutableDictionary *pvNameDic = [myChannelAccess ChannelAccessGetDictionary];

    if( [pvDictionary objectForKey:pvName] ) {
        
        //[notification ErrorCallbackToSwiftWithMessage:pvName];

        unsigned long index = [[pvDictionaryIndex objectForKey:pvName] unsignedLongValue];
        
        [self ChannelAccessClearChannel:index];

        [pvDictionaryIndex removeObjectForKey:pvName];
        [pvDictionary removeObjectForKey:pvName];

        
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (void)ChannelAccessRemoveProcessVariable {

    if( instantCAnode != NULL) {
        ca_clear_channel(instantCAnode->chid);
        free(instantCAnode);
    }
    
    [pvGetArray removeAllObjects];
}

- (void)ChannelAccessRemoveAll {
    for(int i = 0; i < pvDictionary.count; i++) {
        [self ChannelAccessClearChannel: i];
    }
    
    [pvDictionary removeAllObjects];
    [pvDictionaryIndex removeAllObjects];
}

- (BOOL)ChannelAccessAddProcessVariable:(NSString *)pvName {
    
    if( [pvDictionary count] >= max_pv ) {
        [notification ErrorCallbackToSwiftWithMessage:@"The Number of Maximun PVs are 100"];
        return FALSE;
    }
    
    if( ![pvDictionary objectForKey:pvName] ) {
        
        ChannelAccessData *myData = [[ChannelAccessData alloc] init];

        [pvDictionary setObject:myData forKey:pvName];

        unsigned long index = 0;

        if ( pvDictionaryIndex.count != 0) {
            index = [self ChannelAccessGetAvailableIndex];
        }
        
        //[pvDictionaryIndex setObject:[@(index) stringValue] forKey:pvName];
        [pvDictionaryIndex setObject:[NSNumber numberWithUnsignedLong:index] forKey:pvName];
        [self ChannelAccessCreateChannel:index key:pvName];
        
        //[notification EventCallbackToSwiftWithPvName:pvName];
        
        return TRUE;
    }
    else {
        NSString *currentPVName = pvName;
        NSString *message = [currentPVName stringByAppendingString: @" is aleady existed"];
        [notification ErrorCallbackToSwiftWithMessage: message];
        
        return FALSE;
    }
}

//- (BOOL)ChannelAccessAddProcessVariableForDatabrowser:(NSString *)pvName {
//
//    if( [pvDictionary count] >= max_pv ) {
//        [notification ErrorCallbackToSwiftWithMessage:@"The Number of Maximun PVs are 100"];
//        return FALSE;
//    }
//
//    if( ![pvDictionary objectForKey:pvName] ) {
//
//        ChannelAccessData *myData = [[ChannelAccessData alloc] init];
//
//        [pvDictionary setObject:myData forKey:pvName];
//
//        unsigned long index = 0;
//
//        if ( pvDictionaryIndex.count != 0) {
//            index = [self ChannelAccessGetAvailableIndex];
//        }
//
//        //[pvDictionaryIndex setObject:[@(index) stringValue] forKey:pvName];
//        [pvDictionaryIndex setObject:[NSNumber numberWithUnsignedLong:index] forKey:pvName];
//        [self ChannelAccessCreateChannelForDatabrowser:index key:pvName];
//
//        return TRUE;
//    }
//    else {
//        return FALSE;
//    }
//}

- (NSString *)ChannelAccessGetValue:(NSString *)pvName {
    return [pvDictionary objectForKey:pvName];
}

- (NSString *)ChannelAccessGetHostName:(chid)chan {
    NSString *hostName = [NSString stringWithUTF8String:ca_host_name(chan)];
    return hostName;
}

//- (long)ChannelAccessGetType:(chid)chan {
//    long type = ca_field_type(chan);
//    long nativeType = dbf_type_to_DBR_TIME(type);
//    switch(nativeType) {
//        case DBF_DOUBLE:
//            nativeType = DBR_TIME_DOUBLE;
//        default:
//            nativeType = DBR_TIME_STRING;
//    }
//
//    return nativeType;
//}

- (NSMutableArray *)ChannelAccessGetArrayData {

    return pvArrayData;
}

- (void)ChannelAccessStatusCheck:(int)status {
    
    switch (status) {
        case ECA_NORMAL:
            break;
        case ECA_ALLOCMEM:
            [notification ErrorCallbackToSwiftWithMessage:@"Unable to allocate space for CA Context"];
            break;
        case ECA_NOTTHREADED:
            [notification ErrorCallbackToSwiftWithMessage:@"Current Thread is already a member of a non-preemptive callback CA Context"];
            break;
        case ECA_STRTOBIG:
            [notification ErrorCallbackToSwiftWithMessage:@"Unusually larg string"];
        case ECA_DISCONN:
            [notification ErrorCallbackToSwiftWithMessage:@"Channel is disconnected"];
        default:
            break;
    }
}

- (ChannelAccessData *)ChannelAccessGetCAData:(NSString *)pvName {
    return [pvDictionary objectForKey:pvName];
}

- (void)ChannelAccessSetCAData:(ChannelAccessData *)CAData name:(NSString *)pvName {
    [pvDictionary setObject:CAData forKey:pvName];
}

- (void)ChannelAccessArrayDataRemoveAll {
    [pvArrayData removeAllObjects];
}

- (void)ChannelAccessArrayDataAddObject:(double)value {
    [pvArrayData addObject: [NSNumber numberWithDouble: value]];
}

- (void)ChannelAccessAllClear {
    
    NSDictionary *indexDictionary = pvDictionaryIndex;
    
    for(NSString *key in indexDictionary) {
        unsigned long index = [[pvDictionaryIndex objectForKey:key] unsignedIntValue];
        
        [self ChannelAccessClearChannel:index];
        
        //[self ChannelAccessRemoveProcessVariable:key];
        //NSLog(@"%@", key);
    }
    
    [pvDictionary removeAllObjects];
    [pvDictionaryIndex removeAllObjects];
}

- (NSString *)ChannelAccessGetIPAddress {
    
    NSString *address = @"WIFI ERROR";

    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)ChannelAccessSetEnvironment:(NSString *)envName key:(NSString *)value {
    const char *environmentName = [envName UTF8String];
    const char *environmentValue = [value UTF8String];
    
    setenv(environmentName, environmentValue, 1);
//    setenv("EPICS_CA_ADDR_LIST", "10.1.4.63", 1);
    
//    NSLog(@"addrlist %s", getenv("EPICS_CA_ADDR_LIST"));
//    NSLog(@"auto %s", getenv("EPICS_CA_AUTO_ADDR_LIST"));
    
}

@end

void connectionCallback( struct connection_handler_args cha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];
    
    if( cha.op == CA_OP_CONN_UP ) {
        
        long elementCount = ca_element_count(cha.chid);
        long fieldType = ca_field_type(cha.chid);
        long nativeType = dbf_type_to_DBR_TIME(fieldType);
        
        void *eventCallback = NULL;
        
        switch (nativeType) {
            case DBR_TIME_STRING:
                eventCallback = eventCallbackString;
                break;
            case DBR_TIME_SHORT:
                eventCallback = eventCallbackShort;
                break;
            case DBR_TIME_FLOAT:
                eventCallback = eventCallbackFloat;
                break;
            case DBR_TIME_ENUM:
                eventCallback = eventCallbackEnum;
                break;
            case DBR_TIME_LONG:
                eventCallback = eventCallbackLong;
                break;
            case DBR_TIME_DOUBLE:
                eventCallback = eventCallbackDouble;
                break;
            default:
                eventCallback = NULL;
                break;
        }
        
//        if( elementCount > 1 ) {
//            nativeType = DBR_TIME_DOUBLE;
//        }
//        else {
//            nativeType = DBR_TIME_STRING;
//        }
        
        CANODE *myCAnode = ca_puser(cha.chid);
        
        ca_create_subscription(nativeType, elementCount, cha.chid, DBE_VALUE, eventCallback, myCAnode, &myCAnode->evid);
        
        [notification ConnectionCallbackToSwiftWithMessage: @"Connected"];
    }
    else if( cha.op == CA_OP_CONN_DOWN ) {
        NSString *pname = [NSString stringWithUTF8String:ca_name(cha.chid)];
        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        //ChannelAccessData *myData = [pvDictionary objectForKey:pname];
        
        [myData.value removeAllObjects];
        
        [myData.value  addObject:@"Disconnected"];
        //[pvDictionary setObject:myData forKey:pname];
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        //CANODE *myCAnode = ca_puser(cha.chid);
        //ca_clear_subscription(myCAnode->evid);
        
        [notification ConnectionCallbackToSwiftWithMessage: @"Disconnected"];

//        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

void instantConnectionCallback( struct connection_handler_args cha) {
//    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( cha.op == CA_OP_CONN_UP ) {
        [notification EventCallbackToSwiftWithPvName: @"Connected"];
    }
    else if( cha.op == CA_OP_CONN_DOWN ) {
        [notification EventCallbackToSwiftWithPvName: @"Disconnected"];
    }
}

void eventCallbackString( evargs eha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( eha.type == DBR_TIME_STRING) {
        struct dbr_time_string *pTD = (struct dbr_time_string *)eha.dbr;
        const dbr_string_t *pValue = &pTD->value;
        
        char timeStampData[32];
        epicsTimeStamp timeStampPosix = pTD->stamp;
        
        epicsTimeToStrftime(timeStampData, sizeof(timeStampData), "%Y-%m-%d %H:%M:%S", &timeStampPosix);
        NSString *ptimestamp = [NSString stringWithUTF8String:timeStampData];
        
        unsigned long nElement = eha.count;
        //NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];

        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
        
        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
        
        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        [myData.value removeAllObjects];
        
        for(int i = 0; i < nElement; i++) {
            [myData.value addObject:[NSString stringWithUTF8String:pValue[i]]];
        }
        
        myData.name = pname;
        myData.timeStamp = ptimestamp;
        myData.alarmSeverity = severity;
        myData.alarmStatus = status;
        myData.elementCount = nElement;
        myData.timeStampSince1990 = timeStampPosix.secPastEpoch;
        myData.host = host;
        
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

void eventCallbackShort( evargs eha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( eha.type == DBR_TIME_SHORT) {
        struct dbr_time_short *pTD = (struct dbr_time_short *)eha.dbr;
        const dbr_short_t *pValue = &pTD->value;
        
        char timeStampData[32];
        epicsTimeStamp timeStampPosix = pTD->stamp;
        
        epicsTimeToStrftime(timeStampData, sizeof(timeStampData), "%Y-%m-%d %H:%M:%S", &timeStampPosix);
        NSString *ptimestamp = [NSString stringWithUTF8String:timeStampData];
        
        unsigned long nElement = eha.count;
        //NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];

        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
        
        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
        
        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        [myData.value removeAllObjects];
        
        for(int i = 0; i < nElement; i++) {
            [myData.value addObject:[[NSNumber numberWithShort:pValue[i]] stringValue]];
        }
        
        myData.name = pname;
        myData.timeStamp = ptimestamp;
        myData.alarmSeverity = severity;
        myData.alarmStatus = status;
        myData.elementCount = nElement;
        myData.timeStampSince1990 = timeStampPosix.secPastEpoch;
        myData.host = host;
        
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

void eventCallbackFloat( evargs eha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( eha.type == DBR_TIME_FLOAT) {
        struct dbr_time_float *pTD = (struct dbr_time_float *)eha.dbr;
        const dbr_float_t *pValue = &pTD->value;
        
        char timeStampData[32];
        epicsTimeStamp timeStampPosix = pTD->stamp;
        
        epicsTimeToStrftime(timeStampData, sizeof(timeStampData), "%Y-%m-%d %H:%M:%S", &timeStampPosix);
        NSString *ptimestamp = [NSString stringWithUTF8String:timeStampData];
        
        unsigned long nElement = eha.count;
        //NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];

        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
        
        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
        
        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        [myData.value removeAllObjects];
        
        for(int i = 0; i < nElement; i++) {
//            [myData.value addObject:[[NSNumber numberWithFloat:pValue[i]] stringValue]];
            if(pValue[i] < 0.001) {
                [myData.value addObject:[NSString stringWithFormat:@"%.2e", pValue[i]]];
            }
            else {
                [myData.value addObject:[NSString stringWithFormat:@"%.2f", pValue[i]]];
            }
        }
        
        myData.name = pname;
        //myData.value = pvalue;
        myData.timeStamp = ptimestamp;
        myData.alarmSeverity = severity;
        myData.alarmStatus = status;
        myData.elementCount = nElement;
        myData.timeStampSince1990 = timeStampPosix.secPastEpoch;
        myData.host = host;
        
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

void eventCallbackEnum( evargs eha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( eha.type == DBR_TIME_ENUM) {
        struct dbr_time_enum *pTD = (struct dbr_time_enum *)eha.dbr;
        const dbr_enum_t *pValue = &pTD->value;
        
        char timeStampData[32];
        epicsTimeStamp timeStampPosix = pTD->stamp;
        
        epicsTimeToStrftime(timeStampData, sizeof(timeStampData), "%Y-%m-%d %H:%M:%S", &timeStampPosix);
        NSString *ptimestamp = [NSString stringWithUTF8String:timeStampData];
        
        unsigned long nElement = eha.count;
        //NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];

        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
        
        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
        
        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        [myData.value removeAllObjects];
        
        for(int i = 0; i < nElement; i++) {
            [myData.value addObject:[[NSNumber numberWithInt:pValue[i]] stringValue]];
        }
        
        myData.name = pname;
        myData.timeStamp = ptimestamp;
        myData.alarmSeverity = severity;
        myData.alarmStatus = status;
        myData.elementCount = nElement;
        myData.timeStampSince1990 = timeStampPosix.secPastEpoch;
        myData.host = host;
        
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

void eventCallbackLong( evargs eha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( eha.type == DBR_TIME_LONG) {
        struct dbr_time_long *pTD = (struct dbr_time_long *)eha.dbr;
        const dbr_long_t *pValue = &pTD->value;
        
        char timeStampData[32];
        epicsTimeStamp timeStampPosix = pTD->stamp;
        
        epicsTimeToStrftime(timeStampData, sizeof(timeStampData), "%Y-%m-%d %H:%M:%S", &timeStampPosix);
        NSString *ptimestamp = [NSString stringWithUTF8String:timeStampData];
        
        unsigned long nElement = eha.count;
        //NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];

        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
        
        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
        
        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        [myData.value removeAllObjects];
        
        for(int i = 0; i < nElement; i++) {
            [myData.value addObject:[[NSNumber numberWithLong:pValue[i]] stringValue]];
        }
        
        myData.name = pname;
        myData.timeStamp = ptimestamp;
        myData.alarmSeverity = severity;
        myData.alarmStatus = status;
        myData.elementCount = nElement;
        myData.timeStampSince1990 = timeStampPosix.secPastEpoch;
        myData.host = host;
        
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

void eventCallbackDouble( evargs eha) {
    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];

    if( eha.type == DBR_TIME_DOUBLE) {
        struct dbr_time_double *pTD = (struct dbr_time_double *)eha.dbr;
        const dbr_double_t *pValue = &pTD->value;
        
        char timeStampData[32];
        epicsTimeStamp timeStampPosix = pTD->stamp;
        
        epicsTimeToStrftime(timeStampData, sizeof(timeStampData), "%Y-%m-%d %H:%M:%S", &timeStampPosix);
        NSString *ptimestamp = [NSString stringWithUTF8String:timeStampData];
        
        unsigned long nElement = eha.count;
        //unsigned long elementCount = [[NSNumber numberWithLong:nElement] stringValue];

        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
        
        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];

        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
        
        [myData.value removeAllObjects];
        
        for(int i = 0; i < nElement; i++) {
//            [myData.value addObject:[[NSNumber numberWithDouble:pValue[i]] stringValue]];
            if(fabs(pValue[i]) < 0.001) {
                [myData.value addObject:[NSString stringWithFormat:@"%.2e", pValue[i]]];
            }
            else {
                [myData.value addObject:[NSString stringWithFormat:@"%.2f", pValue[i]]];
            }
        }
        
        myData.name = pname;
        myData.timeStamp = ptimestamp;
        myData.alarmSeverity = severity;
        myData.alarmStatus = status;
        myData.elementCount = nElement;
        myData.timeStampSince1990 = timeStampPosix.secPastEpoch;
        myData.host = host;
        
        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
        
        [notification EventCallbackToSwiftWithPvName:pname];
    }
}

//void eventCallback( struct event_handler_args eha) {
//
//    ChannelAccessClient *myChannelAccess = [ChannelAccessClient sharedObject];
//
//    if( eha.type == DBR_TIME_STRING) {
//        //const char  *pdata = (char *)eha.dbr;
//        struct dbr_time_string *pTD = eha.dbr;
//        const dbr_string_t *pValue = &pTD->value;
//
//        char timeStamp[32];
//
//        epicsTimeToStrftime(timeStamp, sizeof(timeStamp), "%Y-%m-%d %H:%M:%S", &pTD->stamp);
//        NSString *ptimestamp = [NSString stringWithUTF8String:timeStamp];
//
//        unsigned long nElement = eha.count;
//        NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];
//        //NSString *elementCount = [[NSNumber numberWithLong:ca_element_count(eha.chid)] stringValue];
//        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
//        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
//        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
//
//        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
//        //NSString *pvalue = [NSString stringWithUTF8String:pTD->value];
//
//        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
//
//        [myData.value removeAllObjects];
//
//        if( nElement > 1 ) {
//            for(int i = 0; i < nElement; i++) {
//                //[myChannelAccess ChannelAccessArrayDataAddObject:pValue[i]];
//                //[pvArrayData addObject: [NSNumber numberWithDouble:pValue[i]]];
//                [myData.value addObject:[NSString stringWithUTF8String:pValue[i]]];
//            }
//        }
//        else {
//            [myData.value addObject:[NSString stringWithUTF8String:pValue[0]]];
//        }
//
//        //myData.value = pvalue;
//        myData.timeStamp = ptimestamp;
//        myData.alarmSeverity = severity;
//        myData.alarmStatus = status;
//        myData.elementCount = elementCount;
//        myData.host = host;
//
//        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
//
//        [notification EventCallbackToSwiftWithPvName:pname];
//    }
//    else if( eha.type == DBR_TIME_DOUBLE) {
//        //const char  *pdata = (char *)eha.dbr;
//        struct dbr_time_double *pTD = eha.dbr;
//        const dbr_double_t *pValue = &pTD->value;
//
//        char timeStamp[32];
//
//        //const dbr_double_t * pValue;
//        //pValue = & pTD->value;
//
//        epicsTimeToStrftime(timeStamp, sizeof(timeStamp), "%Y-%m-%d %H:%M:%S", &pTD->stamp);
//        NSString *ptimestamp = [NSString stringWithUTF8String:timeStamp];
//
//        unsigned long nElement = eha.count;
//        NSString *elementCount = [[NSNumber numberWithLong:nElement] stringValue];
//        //NSString *elementCount = [[NSNumber numberWithLong:ca_element_count(eha.chid)] stringValue];
//        NSString *severity = [NSString stringWithUTF8String:epicsAlarmSeverityStrings[pTD->severity]];
//        NSString *status = [NSString stringWithUTF8String:epicsAlarmConditionStrings[pTD->status]];
//        NSString *host = [NSString stringWithUTF8String:ca_host_name(eha.chid)];
//
//        NSString *pname = [NSString stringWithUTF8String:ca_name(eha.chid)];
////        NSString *pvalue = [[NSNumber numberWithDouble:pValue[0]] stringValue];
//        //NSString *pvalue = @"Array Data";
//
//        ChannelAccessData *myData = [myChannelAccess ChannelAccessGetCAData:pname];
//
//        [myData.value removeAllObjects];
//
//        if( nElement > 1 ) {
//            for(int i = 0; i < nElement; i++) {
//                //[myChannelAccess ChannelAccessArrayDataAddObject:pValue[i]];
//                //[pvArrayData addObject: [NSNumber numberWithDouble:pValue[i]]];
//                [myData.value addObject:[[NSNumber numberWithDouble:pValue[i]] stringValue]];
//            }
//        }
//        else {
//            [myData.value addObject:[[NSNumber numberWithDouble:*pValue] stringValue]];
//        }
//
//        //myData.value = pvalue;
//        myData.timeStamp = ptimestamp;
//        myData.alarmSeverity = severity;
//        myData.alarmStatus = status;
//        myData.elementCount = elementCount;
//        myData.host = host;
//
//        [myChannelAccess ChannelAccessSetCAData:myData name:pname];
//
//        [notification EventCallbackToSwiftWithPvName:pname];
//    }
//}
