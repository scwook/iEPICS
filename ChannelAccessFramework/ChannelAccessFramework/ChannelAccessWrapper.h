//
//  ChannelAccessWrapper.h
//  ChannelAccessFramework
//
//  Created by ctrl user on 05/03/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

#ifndef ChannelAccessWrapper_h
#define ChannelAccessWrapper_h

#include <stdio.h>
#include "cadef.h"

#endif /* ChannelAccessWrapper_h */

int ca_context_create_w(enum ca_preemptive_callback_select select);
void ca_context_destroy_w(void);
struct ca_client_context * ca_current_context_w(void);
int ca_create_channel_w(const char *pChanName, caCh *pConnStateCallback, void *pUserPrivate, capri priority, chid *pChanID);
int ca_clear_channel_w(chid chanID);
unsigned long ca_element_count_w(chid chanID);
int ca_array_get_w(chtype type, unsigned long count, chid chanID, void *pValue);
int ca_pend_io_w(ca_real timeOut);
int ca_get_w(chtype type, chid chanID, void *pValue);
const char * ca_host_name_w(chid chanID);
long ca_field_type_w(chid chanID);
int ca_create_subscription_w(chtype type, unsigned long count, chid chanID, long mask, caEventCallBackFunc *pFunc, void *pArg, evid *pEventID);
const char * ca_name_w(chid chanID);
void * ca_puser_w(chid chanID);
size_t epicsTimeToStrftime_w(char *pBuff, size_t bufLength, const char *pFormat, const epicsTimeStamp *pTS);
unsigned dbr_size_n_w(int type, unsigned int count);
long dbf_type_to_DBR_TIME_w(long type);

