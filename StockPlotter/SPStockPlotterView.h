//
//  SPStockPlotterView.h
//  StockPlotter
//
//  Created by Paul Duncanson on 9/22/13.
//  Change History:
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SPYahooGetStock.h"

@interface SPStockPlotterViewController : UIViewController <SPYahooGetStockDelegate>
{
    SPYahooGetStock *tradingValuePuller;
@private
    CGPoint startPoint, endPoint;
}

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareValue;
@property (weak, nonatomic) IBOutlet UILabel *shareChange;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

-(void)tradingValuePullerDidFinishFetch:(SPYahooGetStock *)dp;
//-(void)dataPullerStockDidChange:(SPYahooGetStock *)dp;
//-(void)dataPuller:(SPYahooGetStock *)dp downloadDidFailWithError:(NSError *)error;
-(SPYahooGetStock *)tradingValuePuller;
-(void)drawRect:(CGRect)rect;

@end
