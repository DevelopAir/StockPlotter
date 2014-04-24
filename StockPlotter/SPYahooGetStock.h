//
//  SPYahooGetStock.h
//  StockPlotter
//
//  Created by Paul Duncanson on 9/22/13.
//  Change History:
//

#import <Foundation/Foundation.h>

@class SPYahooGetStock;

@protocol SPYahooGetStockDelegate

@optional

-(void)dataPullerDidFinishFetch:(SPYahooGetStock *)dp;
-(void)dataPullerTradingValueDidChange:(SPYahooGetStock *)dp;
-(void)dataPuller:(SPYahooGetStock *)dp downloadDidFailWithError:(NSError *)error;

@end

@interface SPYahooGetStock : NSObject {
    NSString *symbol;
    NSDate *startDate;
    NSDate *endDate;
    
    NSDate *targetStartDate;
    NSDate *targetEndDate;
    NSString *targetSymbol;
    
    id delegate;
    NSDecimalNumber *overallHigh;
    NSDecimalNumber *overallLow;
    NSDecimalNumber *overallVolumeHigh;
    NSDecimalNumber *overallVolumeLow;
    
@private
    NSString *csvString;
    NSArray *tradingValue; // consists of dictionaries
    
    BOOL loadingData;
    NSMutableData *receivedData;
    NSURLConnection *connection;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, copy) NSString *targetSymbol;
@property (nonatomic, retain) NSDate *targetStartDate;
@property (nonatomic, retain) NSDate *targetEndDate;
@property (nonatomic, readonly, retain) NSArray *tradingValue;
@property (nonatomic, readonly, retain) NSDecimalNumber *overallHigh;
@property (nonatomic, readonly, retain) NSDecimalNumber *overallLow;
@property (nonatomic, readonly, retain) NSDecimalNumber *overallVolumeHigh;
@property (nonatomic, readonly, retain) NSDecimalNumber *overallVolumeLow;

-(id)initWithTargetSymbol:(NSString *)aSymbol targetStartDate:(NSDate *)aStartDate targetEndDate:(NSDate *)anEndDate;

@end

