//+------------------------------------------------------------------+
//|                  MovingAverageCrossover.mq4                      |
//|  Alerts when a short-term MA crosses above/below a long-term MA  |
//+------------------------------------------------------------------+
#property strict

// Input parameters
input string TradeSymbol = "EURUSD";    // Symbol for analysis
input ENUM_TIMEFRAMES Timeframe = PERIOD_H1; // Timeframe for analysis
input int ShortMAPeriod = 50;          // Period for the short-term moving average
input int LongMAPeriod = 200;          // Period for the long-term moving average
input ENUM_MA_METHOD MAMethod = MODE_EMA; // Moving average calculation method
input ENUM_APPLIED_PRICE AppliedPrice = PRICE_CLOSE; // Price applied for MA calculation

// Alert options
input bool EnableAlerts = true;        // Enable sound alerts
input bool EnableEmail = false;        // Enable email notifications
input bool EnablePush = false;         // Enable push notifications

// Global variables
double PrevShortMA, PrevLongMA;

//+------------------------------------------------------------------+
//| Main function                                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("Moving Average Crossover Script Started.");

   while (!IsStopped()) {
      // Calculate the moving averages
      double shortMA = iMA(TradeSymbol, Timeframe, ShortMAPeriod, 0, MAMethod, AppliedPrice, 1);
      double longMA = iMA(TradeSymbol, Timeframe, LongMAPeriod, 0, MAMethod, AppliedPrice, 1);

      // Previous bar values
      PrevShortMA = iMA(TradeSymbol, Timeframe, ShortMAPeriod, 0, MAMethod, AppliedPrice, 2);
      PrevLongMA = iMA(TradeSymbol, Timeframe, LongMAPeriod, 0, MAMethod, AppliedPrice, 2);

      // Check for crossovers
      if (PrevShortMA <= PrevLongMA && shortMA > longMA) {
         // Golden Cross (short-term MA crosses above long-term MA)
         AlertCross("Golden Cross", TradeSymbol, Timeframe);
      } else if (PrevShortMA >= PrevLongMA && shortMA < longMA) {
         // Death Cross (short-term MA crosses below long-term MA)
         AlertCross("Death Cross", TradeSymbol, Timeframe);
      }

      Sleep(60000); // Wait for 1 minute before the next check
   }
}

//+------------------------------------------------------------------+
//| Send alert notifications                                         |
//+------------------------------------------------------------------+
void AlertCross(string crossType, string symbol, ENUM_TIMEFRAMES timeframe)
{
   string message = StringFormat(
      "%s detected on %s (Timeframe: %s)\nShort MA: %.5f, Long MA: %.5f",
      crossType, symbol, EnumToString(timeframe), PrevShortMA, PrevLongMA
   );

   if (EnableAlerts) Alert(message);
   if (EnableEmail) SendMail("MA Crossover Alert", message);
   if (EnablePush) SendNotification(message);

   Print(message);
}
