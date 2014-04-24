//
//  SPStockPlotterView.m
//  StockPlotter
//
//  Created by Paul Duncanson on 9/22/13.
//  Change History:
//

#import "SPStockValue.h"
#import "SPYahooGetStock.h"
#import "SPStockPlotterView.h"
#import "SPAppDelegate.h"
   
@interface SPStockPlotterViewController()

@property (nonatomic, retain) SPYahooGetStock *tradingValuePuller;

@end

@implementation SPStockPlotterViewController

@synthesize tradingValuePuller;

dispatch_source_t _timer;
const CGFloat kXScale = 5.0;
const CGFloat kYScale = 100.0;

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                    CGFloat dx, CGFloat dy) {
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
} 

-(void)reloadData
{
    NSDate *start         = [NSDate dateWithTimeIntervalSinceNow:-60.0 * 60.0 * 24.0 * 7.0 * 4.0]; // 4 weeks ago
    NSDate *end           = [NSDate date];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *selectedETF = [userDefault objectForKey:@"selectedETF"];
    
    NSLog(@"DetailItem is %@", selectedETF);
    
    if (selectedETF.length > 0) {
        SPYahooGetStock *stockPuller = [[SPYahooGetStock alloc] initWithTargetSymbol:selectedETF targetStartDate:start targetEndDate:end];
        [self setTradingValuePuller:stockPuller];
    }
}

-(void)viewDidLoad
{
    [self reloadData];
}

// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
    //    NSLog(@"willRotateToInterfaceOrientation");
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    //    NSLog(@"didRotateFromInterfaceOrientation");
}

-(void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    NSLog(@"Out of memory received");
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecords
{
    return self.tradingValuePuller.tradingValue.count;
}

-(void)tradingValuePullerStockDidChange:(SPYahooGetStock *)dp;
{
    [self reloadData];
}

#pragma mark accessors

-(SPYahooGetStock *)tradingValuePuller
{
    NSLog(@"in -tradingValuePuller, returned tradingValuePuller = %@", tradingValuePuller);
    
    return tradingValuePuller;
}

- (void)drawRect:(CGRect)rect
{
    if ([tradingValuePuller.tradingValue count] > 0) {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        
        CGFloat components[] = {165.0f/255.0f, 215.0f/255.0f, 1.0f};
        
        CGColorRef acornGreen = CGColorCreate(colorspace, components);
        
        CGContextSetStrokeColorWithColor(ctx, acornGreen);
        
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineWidth(ctx, 5);
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat yOffset = self.scrollView.bounds.size.height / 2;
        CGAffineTransform transform = CGAffineTransformMakeScaleTranslate(kXScale, kYScale, 0, yOffset);
        
        //TODO:Plotted values probably need to make use of a smarter algorithm.  For example,
        //TODO:the TDR technique which is primarily used to measure volatility of commodities rather then ETF's
        //TODO:will take into account previous days' close value versus current days' open value, etc.
        
        CGFloat high = [[[tradingValuePuller.tradingValue objectAtIndex:0] objectForKey:@"high"] doubleValue];
        CGFloat low = [[[tradingValuePuller.tradingValue objectAtIndex:0] objectForKey:@"low"] doubleValue];
        CGFloat y = high - low;
        
        CGPathMoveToPoint(path, &transform, 0, y);
        
        for (NSUInteger x = 1; x < [tradingValuePuller.tradingValue count]; ++x) {
            
            CGFloat high = [[[tradingValuePuller.tradingValue objectAtIndex:x] objectForKey:@"high"] doubleValue];
            CGFloat low = [[[tradingValuePuller.tradingValue objectAtIndex:x] objectForKey:@"low"] doubleValue];
            CGFloat y = high - low;
            
            CGPathAddLineToPoint(path, &transform, x, y);
        }
        
        CGContextAddPath(ctx, path);
        CGPathRelease(path);
        CGContextStrokePath(ctx);
    }
}

-(void)tradingValuePullerDidFinishFetch:(SPYahooGetStock *)dp
{
    // Plot retrieved points on graph
    
    NSDecimalNumber *high   = [tradingValuePuller overallHigh];
    NSDecimalNumber *low    = [tradingValuePuller overallLow];
    
    if (high != 0 && low != 0) {
        NSDecimalNumber *length = [high decimalNumberBySubtracting:low];
        
        NSLog(@"high = %@, low = %@, length = %@", high, low, length);
    } else {
        NSLog(@"high and low values could not be retrieved.");
    }
    
    //if ([tradingValuePuller.tradingValue count] > 0) {
      //  [self plotStockValueOnGraph];
    //}
    
    // queue up invocation of scrollViews' drawRect
    [self.scrollView setNeedsDisplay];
}

-(void)setTradingValuePuller:(SPYahooGetStock *)aTradingValuePuller
{
    NSLog(@"in -setTradingValuePuller:, old value of tradingValuePuller: %@, changed to: %@", tradingValuePuller, aTradingValuePuller);
    
    if ( tradingValuePuller != aTradingValuePuller ) {
        tradingValuePuller = aTradingValuePuller;
    }
}

@end
