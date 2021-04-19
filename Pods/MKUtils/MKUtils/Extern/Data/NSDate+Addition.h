/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Addition)

#pragma mark -
#pragma mark - NSDate Format

/*
 * NSString转NSDate
 * dataFormat yyyy-MM-dd HH:mm:ss
 */
+ (NSDate *)stringToDate:(NSString *)dateStr withDateFormat:(NSString*)dateFormat;

/*
 * NSDate转NSString
 * dataFormat yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString*)dateFormat;

/*
 * 当前时间戳
 */
+ (NSString *)currentTime;


/* 时间戳转换 "几分钟前"
 * posttime 时间戳
 */
+ (NSString *)getTimeString:(NSInteger)posttime;//动态时间

/* 时间戳转换
 * yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)stringFromTimestamp:(NSInteger)timestamp;

/* 时间戳转换
 * yyyy-MM-dd
 */
+ (NSString *)simpleStringFromTimestamp:(NSInteger)timestamp;

/* 时间戳转换
 * MM-dd
 */
+ (NSString *)shortStringFromTimestamp:(NSInteger)timestamp;

/* 时间转换
 * MM-dd
 */
+ (NSString *)shortStringFromDate:(NSDate *)date;

// Relative dates from the current date
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow: (NSUInteger)days;
+ (NSDate *)dateWithDaysBeforeNow: (NSUInteger)days;
+ (NSDate *)dateWithHoursFromNow: (NSUInteger)dHours;
+ (NSDate *)dateWithHoursBeforeNow: (NSUInteger)dHours;
+ (NSDate *)dateWithMinutesFromNow: (NSUInteger)dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow: (NSUInteger)dMinutes;

// Comparing dates
- (BOOL)isEqualToDateIgnoringTime: (NSDate *)aDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isSameWeekAsDate: (NSDate *)aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameYearAsDate: (NSDate *)aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate: (NSDate *)aDate;
- (BOOL)isLaterThanDate: (NSDate *)aDate;

// Adjusting dates
- (NSDate *)dateByAddingDays: (NSUInteger)dDays;
- (NSDate *)dateBySubtractingDays: (NSUInteger)dDays;
- (NSDate *)dateByAddingHours: (NSUInteger)dHours;
- (NSDate *)dateBySubtractingHours: (NSUInteger)dHours;
- (NSDate *)dateByAddingMinutes: (NSUInteger) dMinutes;
- (NSDate *)dateBySubtractingMinutes: (NSUInteger)dMinutes;
- (NSDate *)dateAtStartOfDay;

// Retrieving intervals
- (NSInteger)minutesAfterDate: (NSDate *)aDate;
- (NSInteger)minutesBeforeDate: (NSDate *)aDate;
- (NSInteger)hoursAfterDate: (NSDate *)aDate;
- (NSInteger)hoursBeforeDate: (NSDate *)aDate;
- (NSInteger)daysAfterDate: (NSDate *)aDate;
- (NSInteger)daysBeforeDate: (NSDate *)aDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;


@end
