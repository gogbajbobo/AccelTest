/* Copyright (c) 2009 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if !GDATA_REQUIRE_SERVICE_INCLUDES || GDATA_INCLUDE_MAPS_SERVICE

//
//  GDataEntryMap.h
//

#import "GDataEntryBase.h"
#import "GDataCustomProperty.h"


@interface GDataEntryMap : GDataEntryBase

+ (id)mapEntryWithTitle:(NSString *)str;

- (NSArray *)customProperties;
- (void)setCustomProperties:(NSArray *)array;
- (void)addCustomProperty:(GDataCustomProperty *)obj;

// convenience accessor
- (NSURL *)featuresFeedURL;

- (GDataCustomProperty *)customPropertyWithName:(NSString *)name;

@end

#endif // !GDATA_REQUIRE_SERVICE_INCLUDES || GDATA_INCLUDE_MAPS_SERVICE
