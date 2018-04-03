//+------------------------------------------------------------------+
//|                                                       Global.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "Base.mqh"

#define DEFAULT_FONT_NAME                  "Trebuchet MS"
#define DEFAULT_FONT_SIZE                  (10)
#define DEFAULT_CAPTION_HEIGHT             (25)
#define DEFAULT_CAPTION_BACKGROUND_COLOR   (C'0x00,0x00,0x30')
#define DEFAULT_CAPTION_COLOR              (C'0xFF,0xFF,0xFF')
#define DEFAULT_LABEL_BACKGROUND_COLOR     (C'0x20,0x20,0x20')
#define DEFAULT_LABEL_COLOR                (C'0x60,0xA0,0xFF')
#define DEFAULT_BUTTON_BACKGROUND_COLOR    (C'0xFF,0x00,0x00')
#define DEFAULT_BUTTON_COLOR               (C'0xFF,0xFF,0xFF')
#define DEFAULT_EDIT_BACKGROUND_COLOR      (C'0x00,0x00,0x00')
#define DEFAULT_EDIT_COLOR                 (C'0x00,0xFF,0x00')

#define TRADE_STATION_MODEL_CHANGED 1
#define TRADE_STATION_MODEL_TRADE_CHANGED 2
#define WINDOW_MINIMIZED 3
#define WINDOW_MAXIMIZED 4
#define TOOL_MODEL_CHANGED 5


//+------------------------------------------------------------------+
//| Custom Events                                                                  |
//+------------------------------------------------------------------+
//#define BASE_WINDOW_CLICK (0x01)
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//long ObjectToLong(Base *obj)
//  {
//   return(StringToInteger(StringFormat("%0d",GetPointer(obj))));
//  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//string GetUniqueName(string name=NULL)
//  {
//   return (name+Symbol()+IntegerToString(Period()));
//  }
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
