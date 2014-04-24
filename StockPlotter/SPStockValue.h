//
//  SPStockValue.h
//  StockPlotter
//
//  Created by Paul Duncanson on 9/22/13.
//  Change History:
//

#import <Foundation/Foundation.h>

@interface NSDictionary(SPStockValue)

+(id)dictionaryWithCSVLine:(NSString *)csvLine;

@end

