#ifndef __UTIL_MQH__
#define __UTIL_MQH__

//+------------------------------------------------------------------+
//|                                                       JBUtil.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

struct FIBO_PIVOT {
   double R3;
   double R2;
   double R1;
   double PP;
   double S1;
   double S2;
   double S3;
};

#import "Projects/Lib/Util.ex4"

//+------------------------------------------------------------------+ 
//| Calculate the 3 resistance, support levels and the pivotpoint.   | 
//+------------------------------------------------------------------+ 
void CalcFiboPivot(  FIBO_PIVOT &fibo_pivot, // Fibonacci and Pivot numbers 
                     string symbol,          // Currency
                     int timefame,           // Time period
                     int shift);             // Candle number (0 = current)

//+------------------------------------------------------------------+ 
//| Return if trading instrument is Forex.                           | 
//+------------------------------------------------------------------+ 
bool IsForex(string Currency);

//+------------------------------------------------------------------+ 
//| Return the correct Pippoint value for fractional point brokers.  | 
//+------------------------------------------------------------------+ 
double PipPoint(string Currency);

//+------------------------------------------------------------------+
//| Return the correct Slippage for fractional point brokers         |                                                        |
//+------------------------------------------------------------------+
int GetSlippage(string Currency,int SlippagePips);

//+------------------------------------------------------------------+ 
//| Return the spread in pips for the currency.                      |     | 
//+------------------------------------------------------------------+ 
double Spread(string Currency);

//+------------------------------------------------------------------+ 
//| Return the pip value in account currency.                        | 
//+------------------------------------------------------------------+ 
double Pipvalue(string Currency);

//+------------------------------------------------------------------+ 
//| Return the Base currency of a currency pair.                     | 
//+------------------------------------------------------------------+ 
string BaseCurrency(string Currency);

//+------------------------------------------------------------------+ 
//| Return the Quoted currency of a currency pair.                   | 
//+------------------------------------------------------------------+ 
string QuotedCurrency(string Currency);

//+------------------------------------------------------------------+ 
//| Calculate lotsize for a given currency, risk and stoploss.       | 
//+------------------------------------------------------------------+ 
double LotCalculator(string Currency, double PercentRisk, int Stoploss);

//+------------------------------------------------------------------+ 
//| Calculate risk for a given currency, lotsize and stoploss.       | 
//+------------------------------------------------------------------+ 
double RiskCalculator(string Currency, double LotSize, int Stoploss);

#import

#endif // __UTIL_MQH__
