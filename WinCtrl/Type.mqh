//+------------------------------------------------------------------+
//|                                                     EvenType.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//typedef void(*TOnEvent)(int eventid,string name,void *ptr);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_RISK_TYPE
  {
   RT_PERCENTAGE=0,
   RT_LOT_SIZE=1
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_PROFILE_TYPE
  {
   PT_FAILED_BREAKOUT=0,
   PT_4HOUR_INTRADAY=1
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TTradeWindow
  {
   bool              maximized;
   ENUM_RISK_TYPE    risk_type;
   double            risk_percentage;
   double            lot_size;
   double            reward_to_risk;
   int               order_type;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TProfile
  {
   string            name;
   int               index;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TProfileSetting
  {
   char              tags[512];
   char              currencyLabel[32];
   ENUM_PROFILE_TYPE profile_type;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TToolWindow
  {
   bool              maximized;
   bool              scale_fix;
  };

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
