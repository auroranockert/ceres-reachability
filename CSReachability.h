//
//  CSReachability.h
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


#import <SystemConfiguration/SCNetworkReachability.h>

@interface NSObject (CSReachabilityDelegate)

- (void) onConnect;
- (void) onDisconnect;

@end

@interface CSReachability : NSObject {
  SCNetworkReachabilityRef ref;
  bool value;
  id delegate;
}

+ (CSReachability *) reachabilityWithHost: (NSString *) host delegate: (id) delegate;

@end
