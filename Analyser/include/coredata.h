#ifndef COREDATA_H
#define COREDATA_H

#include <vcl.h>
#include "extensions.h"

struct TAnalogInfo {
 float low_level;
 float high_level;
 float thresold;
};

struct TElementCoreData {
 TForm          *stats;
 unsigned long   lastupdate;
 bool            updating_stats;
 bool            at_execute;
 bool            outcap_warned;

 TAnalogInfo     analog;

 IOutputCapabilityCheck *outcap;

 TElementCoreData(): stats(NULL), lastupdate(0), updating_stats(false), at_execute(false),
                     outcap(NULL) {;}
};

struct TLibraryInfo {
 int index;
};

#endif
