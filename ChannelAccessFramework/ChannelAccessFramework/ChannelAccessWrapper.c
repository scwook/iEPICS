//
//  ChannelAccessWrapper.c
//  ChannelAccessFramework
//
//  Created by ctrl user on 05/03/2018.
//  Copyright © 2018 scwook. All rights reserved.
//

#include "ChannelAccessWrapper.h"

int ca_context_create_w(enum ca_preemptive_callback_select select) {
    return ca_context_create(select);
}

void ca_context_destroy_w(void) {
    ca_context_destroy();
}

struct ca_client_context * ca_current_context_w(void) {
    return ca_current_context();
}

int ca_create_channel_w(const char *pChanName, caCh *pConnStateCallback, void *pUserPrivate, capri priority, chid *pChanID) {
    return ca_create_channel(pChanName, pConnStateCallback, pUserPrivate, priority, pChanID);
}

int ca_clear_channel_w(chid chanID) {
    return ca_clear_channel(chanID);
}

unsigned long ca_element_count_w(chid chanID) {
    return ca_element_count(chanID);
}

int ca_array_get_w(chtype type, unsigned long count, chid chanID, void *pValue) {
    return ca_array_get(type, count, chanID, pValue);
}

int ca_pend_io_w(ca_real timeOut) {
    return ca_pend_io(timeOut);
}

int ca_get_w(chtype type, chid chanID, void *pValue) {
    return ca_get(type, chanID, pValue);
}

const char * ca_host_name_w(chid chanID) {
    return ca_host_name(chanID);
}

long ca_field_type_w(chid chanID) {
    return ca_field_type(chanID);
}

int  ca_create_subscription_w(chtype type, unsigned long count, chid chanID, long mask, caEventCallBackFunc *pFunc, void *pArg, evid *pEventID) {
    return ca_create_subscription(type, count, chanID, mask, pFunc, pArg, pEventID);
}

const char * ca_name_w(chid chanID) {
    return ca_name(chanID);
}

void * ca_puser_w(chid chanID) {
    return ca_puser(chanID);
}

size_t epicsTimeToStrftime_w(char *pBuff, size_t bufLength, const char *pFormat, const epicsTimeStamp *pTS) {
    return epicsTimeToStrftime(pBuff, bufLength, pFormat, pTS);
}

unsigned dbr_size_n_w(int type, unsigned int count) {
    return (unsigned)((count)<=0?dbr_size[type]:dbr_size[type]+((count)-1)*dbr_value_size[type]);

}

long dbf_type_to_DBR_TIME_w(long type) {
    return ((type) >= 0 && (type) <= dbf_text_dim-3) ? (type) + 2*(dbf_text_dim-2) : -1;
}


