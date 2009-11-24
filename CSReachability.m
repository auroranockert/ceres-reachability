//
//  CSReachability.m
//  This file is part of ceres-reachability.
//
//  ceres-reachability is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Ceres is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ceres-reachability.  If not, see <http://www.gnu.org/licenses/>.
//
//  Created by Jens Nockert on 11/24/09.
//

#import "CSReachability.h"

@implementation CSReachability

static void CSReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void * info)
{
  CSReachability * infoObject = (CSReachability *) info;
  
  if ((flags & kSCNetworkReachabilityFlagsReachable) && !(flags & kSCNetworkFlagsTransientConnection)) {
    if (!infoObject->value) {
      infoObject->value = true;
      [infoObject->delegate onConnect];
    }
  } else {
    if (infoObject->value) {
      infoObject->value = false;
      [infoObject->delegate onDisconnect];
    }
  }
}

+ (CSReachability *) reachabilityWithHost: (NSString *) host delegate: (id) del
{
  CSReachability * value = [[CSReachability alloc] init];
  SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(nil, [host UTF8String]);
  
  if (reachability && value && del) {
    value->ref = reachability;
    value->delegate = del;
    value->value = true;
    
    if (![del respondsToSelector: @selector(onConnect)] || ![del respondsToSelector: @selector(onDisconnect)]) {
      return nil;
    }
  
    SCNetworkReachabilityContext context = {0, value, nil, nil, nil};
    if (!SCNetworkReachabilitySetCallback(reachability, CSReachabilityCallback, &context)) {
      return nil;
    }
  
    if (!SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
      return nil;
    }
    
    return value;
  } else {
    return nil;
  }
  
}

- (void) finalize
{
  if (ref) {
    SCNetworkReachabilityUnscheduleFromRunLoop(ref, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    CFRelease(ref);
  }
  
  [super finalize];
}

@end
