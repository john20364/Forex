//+------------------------------------------------------------------+
//|                                                         Util.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|                                                       JBUtil.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "../Include/Util.mqh"
//+------------------------------------------------------------------+ 
//| Calculate the 3 resistance, support levels and the pivotpoint.   | 
//+------------------------------------------------------------------+ 
void CalcFiboPivot(FIBO_PIVOT &fibo_pivot,// Fibonacci and Pivot numbers 
                   string symbol,          // Currency
                   int timefame,           // Time period
                   int shift) export
  {     // Candle number (0 = current)
   double Hi = iHigh(symbol, timefame, shift);
   double Lo = iLow(symbol, timefame, shift);
   double Cl = iClose(symbol, timefame, shift);
   fibo_pivot.PP = (Hi + Lo + Cl) / 3;
   fibo_pivot.R3 = fibo_pivot.PP + (Hi - Lo);
   fibo_pivot.R2 = fibo_pivot.PP + 0.618 * (Hi - Lo);
   fibo_pivot.R1 = fibo_pivot.PP + 0.382 * (Hi - Lo);
   fibo_pivot.S1 = fibo_pivot.PP - 0.382 * (Hi - Lo);
   fibo_pivot.S2 = fibo_pivot.PP - 0.618 * (Hi - Lo);
   fibo_pivot.S3 = fibo_pivot.PP - (Hi - Lo);
  }
//+------------------------------------------------------------------+ 
//| Return if trading instrument is Forex.                           | 
//+------------------------------------------------------------------+ 
bool IsForex(string Currency) export
  {
   return(BaseCurrency(Currency) != QuotedCurrency(Currency));
  }
//+------------------------------------------------------------------+ 
//| Return the correct Pippoint value for fractional point brokers.  | 
//+------------------------------------------------------------------+ 
double PipPoint(string Currency) export
  {
   double result=0;
   if(IsForex(Currency))
     {
      int CalcDigits=(int)MarketInfo(Currency,MODE_DIGITS);
      if(CalcDigits == 2 || CalcDigits == 3) result = 0.01;
      if(CalcDigits == 4 || CalcDigits == 5) result = 0.0001;
     }
   else
     {
      result=MarketInfo(Currency,MODE_POINT);
     }
   return result;
  }
//+------------------------------------------------------------------+
//| Return the correct Slippage for fractional point brokers         |                                                        |
//+------------------------------------------------------------------+
int GetSlippage(string Currency,int SlippagePips) export
  {
   int result=0;
   if(IsForex(Currency))
     {
      int CalcDigits=(int)MarketInfo(Currency,MODE_DIGITS);
      if(CalcDigits == 2 || CalcDigits == 4) result=SlippagePips;
      if(CalcDigits == 3 || CalcDigits == 5) result=SlippagePips * 10;
     }
   else
     {
      result=SlippagePips;
     }
   return(result);
  }
//+------------------------------------------------------------------+ 
//| Return the spread in pips for the currency.                      |     | 
//+------------------------------------------------------------------+ 
double Spread(string Currency) export
  {
   double result=0;
   if(IsForex(Currency))
     {
      int denominator= 1;
      int CalcDigits =(int)MarketInfo(Currency,MODE_DIGITS);
      if(CalcDigits == 2 || CalcDigits == 4) denominator = 1;
      if(CalcDigits == 3 || CalcDigits == 5) denominator = 10;
      result=MarketInfo(Currency,MODE_SPREAD)/denominator;
     }
   else
     {
      result=MarketInfo(Currency,MODE_SPREAD);
     }
   return result;
  }
//+------------------------------------------------------------------+ 
//| Return the pip value in account currency.                        | 
//+------------------------------------------------------------------+ 
double Pipvalue(string Currency) export
  {
   double result=0;
   if(IsForex(Currency))
     {
      int factor=1;
      int CalcDigits=(int)MarketInfo(Currency,MODE_DIGITS);
      if(CalcDigits == 2 || CalcDigits == 4) factor = 1;
      if(CalcDigits == 3 || CalcDigits == 5) factor = 10;
      result=MarketInfo(Currency,MODE_TICKVALUE)*factor;
     }
   else
     {
      result=MarketInfo(Currency,MODE_TICKVALUE);
     }
   return result;
  }
//+------------------------------------------------------------------+ 
//| Return the Base currency of a currency pair.                     | 
//+------------------------------------------------------------------+ 
string BaseCurrency(string Currency) export
  {
   return SymbolInfoString(Currency,SYMBOL_CURRENCY_BASE);
  }
//+------------------------------------------------------------------+ 
//| Return the Quoted currency of a currency pair.                   | 
//+------------------------------------------------------------------+ 
string QuotedCurrency(string Currency) export
  {
   return SymbolInfoString(Symbol(),SYMBOL_CURRENCY_PROFIT);
  }
//+------------------------------------------------------------------+ 
//| Calculate lotsize for a given currency, risk and stoploss.       | 
//+------------------------------------------------------------------+ 
double LotCalculator(string Currency,double PercentRisk,int Stoploss) export
  {
   if(Stoploss==0) return(0);
   
   double effective_pips=0;
   double risk = PercentRisk * 0.01;
   double lots = 0;
   double amount=AccountBalance()*risk;

   effective_pips=Stoploss*Pipvalue(Currency);
   lots=(amount/effective_pips);
   return lots;
  }
//+------------------------------------------------------------------+ 
//| Calculate risk for a given currency, lotsize and stoploss.       | 
//+------------------------------------------------------------------+ 
double RiskCalculator(string Currency,double LotSize,int Stoploss) export
  {
   double effective_pips=Stoploss*Pipvalue(Currency);
   double risk=((effective_pips*LotSize)/AccountBalance())*100;
   return risk;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2) export
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+
