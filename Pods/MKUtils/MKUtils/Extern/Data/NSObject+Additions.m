//
//  NSObject+Additions.m
//  Basic
//
//  Created by zhengmiaokai on 16/5/12.
//  Copyright © 2016年 zhengmiaokai. All rights reserved.
//

#import "NSObject+Additions.h"
#import "NSString+Addition.h"
#import <objc/runtime.h>

@implementation NSObject (Additions)

+ (void)swizzMethodOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);

    BOOL didAddMethod = class_addMethod([self class], originalSelector,
                                        method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod([self class], swizzledSelector,
                            method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)swizzMethodOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);

    BOOL didAddMethod = class_addMethod([self class], originalSelector,
                                        method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod([self class], swizzledSelector,
                            method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)asyncMain:(void(^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)delay:(NSTimeInterval)time block:(void(^)(void))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

- (NSArray*)generatePropertyKeys
{
    unsigned int self_count = 0;
    
    objc_property_t* self_properties  = nil;
    
    if (([NSBundle bundleForClass:[self class]] == [NSBundle mainBundle])) {
        self_properties  = class_copyPropertyList([self class], &self_count);
    }
    
    unsigned int super_count = 0;
    
    objc_property_t* super_properties  = nil;
    
    if (([NSBundle bundleForClass:[self superclass]] == [NSBundle mainBundle]) && self_properties) {
        super_properties  = class_copyPropertyList([self superclass], &super_count);
    }
    
    NSMutableArray* mPropertyArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < self_count + super_count; i++) {
            
            objc_property_t property = nil;
            if (i>=self_count) {
                property = super_properties[i-self_count];
            }
            else {
                property = self_properties[i];
            }
            
            const char* name = property_getName(property);
            
            NSString *propertyName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
            
            [mPropertyArray addObject:propertyName];
        }
    }
    
    if (self_properties) {
        free(self_properties);
    }
    if (super_properties) {
        free(super_properties);
    }
    
    return mPropertyArray ;
}

- (NSArray*)generatePropertyTypes
{
    unsigned int self_count = 0;
    
    objc_property_t* self_properties  = nil;
    
    if (([NSBundle bundleForClass:[self class]] == [NSBundle mainBundle])) {
        self_properties  = class_copyPropertyList([self class], &self_count);
    }
    
    unsigned int super_count = 0;
    
    objc_property_t* super_properties  = nil;
    
    if (([NSBundle bundleForClass:[self superclass]] == [NSBundle mainBundle]) && self_properties) {
        super_properties  = class_copyPropertyList([self superclass], &super_count);
    }
    
    NSMutableArray* mPropertyTypesArray = [NSMutableArray array];
    @autoreleasepool {
        for (int i = 0; i < self_count + super_count; i++) {
            
            objc_property_t property = nil;
            if (i>=self_count) {
                property = super_properties[i-self_count];
            }
            else {
                property = self_properties[i];
            }
            
            const char* typeName = getPropertyType(property);
            
            NSString *propertyTypeName = [[NSString alloc] initWithCString:typeName encoding:NSUTF8StringEncoding];
            
            [mPropertyTypesArray addObject:propertyTypeName];
        }
    }
    
    if (self_properties) {
        free(self_properties);
    }
    if (super_properties) {
        free(super_properties);
    }
    
    return mPropertyTypesArray ;
}

static const char *getPropertyType(objc_property_t property) {
    
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    
    strcpy(buffer, attributes);
    
    char *state = buffer, *attribute;
    
    while ((attribute = strsep(&state, ",")) != NULL) {
        // 非对象类型
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // 利用NSData复制一份字符串
            return (const char *) [[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
            // 纯id类型
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return "id";
            // 对象类型
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            return (const char *) [[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

- (NSDictionary *)objectRecordPropertyDictionary {
    
    unsigned int self_count = 0;
    
    objc_property_t* self_properties  = nil;
    
    if (([NSBundle bundleForClass:[self class]] == [NSBundle mainBundle])) {
        self_properties  = class_copyPropertyList([self class], &self_count);
    }
    
    unsigned int super_count = 0;
    
    objc_property_t* super_properties  = nil;
    
    if (([NSBundle bundleForClass:[self superclass]] == [NSBundle mainBundle]) && self_properties) {
        super_properties  = class_copyPropertyList([self superclass], &super_count);
    }
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self_count + super_count; i++) {
        
        objc_property_t property = nil;
        if (i>=self_count) {
            property = super_properties[i-self_count];
        }
        else {
            property = self_properties[i];
        }
        
        const char* name = property_getName(property);
        
        NSString* propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        NSObject* value = [self valueForKey:propertyName];
        
        Class objectClass = object_getClass(value);
        
        if  (objectClass != nil) {
            NSString* className = NSStringFromClass(objectClass);
            
            if ([className rangeOfString:@"NS"].length != 0) {
                if ([className rangeOfString:@"String"].length != 0) {
                    parameters[propertyName] = value;
                }
                else if ([className rangeOfString:@"Number"].length != 0) {
                    parameters[propertyName] = value;
                }
                else if ([className rangeOfString:@"Data"].length != 0) {
                    parameters[propertyName] = value;
                }
                else if ([className rangeOfString:@"Array"].length != 0) {
                    NSArray* arr = [(NSArray *)value arrayRecordPropertyArray];
                    parameters[propertyName] = arr;
                }
                else if ([className rangeOfString:@"Dictionary"].length != 0)  {
                    NSDictionary* dic = [(NSDictionary *)value dictionaryRecordPropertyDictionary];
                    parameters[propertyName] = dic;
                }
                else {
                    continue;
                }
            }
            else if ([className rangeOfString:@"Block"].length != 0) {
                continue;
            }
            else {
                NSDictionary* dic = [(NSObject *)value objectRecordPropertyDictionary];
                parameters[propertyName] = dic;
            }
        }
    }
    if (self_properties) {
        free(self_properties);
    }
    if (super_properties) {
        free(super_properties);
    }
    
    return parameters;
}

@end

@implementation NSArray (KeyValue)

- (NSArray *)arrayRecordPropertyArray{
    
    NSInteger count = self.count;
    
    NSMutableArray* parameters = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        
        NSObject* value = self[i];
        
        Class objectClass = object_getClass(value);
        
        if  (objectClass != nil) {
            NSString* className = NSStringFromClass(objectClass);
            
            if ([className rangeOfString:@"NS"].length != 0)  {
                if ([className rangeOfString:@"String"].length != 0) {
                    [parameters addObject:value];
                }
                else if ([className rangeOfString:@"Number"].length != 0) {
                    [parameters addObject:value];
                }
                else if ([className rangeOfString:@"Data"].length != 0) {
                    [parameters addObject:value];
                }
                else if ([className rangeOfString:@"Array"].length != 0) {
                    NSArray* arr = [(NSArray *)value arrayRecordPropertyArray];
                    [parameters addObject: arr];
                }
                else if ([className rangeOfString:@"Dictionary"].length != 0)  {
                    NSDictionary* dic = [(NSDictionary *)value dictionaryRecordPropertyDictionary];
                    [parameters addObject: dic];
                }
                else {
                    continue;
                }
            }
            else if ([className rangeOfString:@"Block"].length != 0) {
                continue;
            }
            else {
                NSDictionary* dic = [(NSObject *)value objectRecordPropertyDictionary];
                [parameters addObject: dic];
            }
        }
    }
    return parameters;
}

@end


@implementation NSDictionary (KeyValue)

- (NSDictionary *)dictionaryRecordPropertyDictionary {
    NSInteger count = self.allKeys.count;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        
        NSString* key = self.allKeys[i];
        NSObject* value = self[key];
        
        Class objectClass = object_getClass(value);
        
        if  (objectClass != nil) {
            NSString* className = NSStringFromClass(objectClass);
            
            if ([className rangeOfString:@"NS"].length != 0)  {
                if ([className rangeOfString:@"String"].length != 0) {
                    [parameters setObject:value forKey:key];
                }
                else if ([className rangeOfString:@"Number"].length != 0) {
                    [parameters setObject:value forKey:key];
                }
                else if ([className rangeOfString:@"Data"].length != 0) {
                    [parameters setObject:value forKey:key];
                }
                else if ([className rangeOfString:@"Array"].length != 0) {
                    NSArray* arr = [(NSArray *)value arrayRecordPropertyArray];
                    [parameters setObject:arr forKey:key];
                }
                else if ([className rangeOfString:@"Dictionary"].length != 0)  {
                    NSDictionary* dic = [(NSDictionary *)value dictionaryRecordPropertyDictionary];
                    [parameters setObject:dic forKey:key];
                }
                else {
                    continue;
                }
            }
            else if ([className rangeOfString:@"Block"].length != 0) {
                continue;
            }
            else {
                NSDictionary* dic = [(NSObject *)value objectRecordPropertyDictionary];
                [parameters setObject:dic forKey:key];
            }
        }
    }
    return parameters;
}

#pragma mark -- 检测数据集是否可用
BOOL checkSetAvailable(id components) {
    if (components && [components isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    else if (components && [components isKindOfClass:[NSArray class]] && [components count] > 0) {
        return YES;
    }
    else if (components && [components isKindOfClass:[NSString class]] && ![[components trim] isEqualToString:@""]) {
        return YES;
    }
    else if (components && [components isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
