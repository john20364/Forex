//+------------------------------------------------------------------+
//|                                                        Label.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Global.mqh"
#include "BaseWindow.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Label : public BaseWindow
  {
private:

public:
                     Label(const string name="Label",// label name 
                                             const int x=0,                                  // X coordinate 
                                             const int y=0,                                  // Y coordinate 
                                             const int width=100,                            // width 
                                             const int height=25);                           // height );
                    ~Label();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Label::Label(const string name,
             const int x,
             const int y,
             const int width,
             const int height):BaseWindow(name,x,y,width,height)
  {
   SetReadOnly(true);
   SetBackColor(DEFAULT_LABEL_BACKGROUND_COLOR);
   SetColor(DEFAULT_LABEL_COLOR);
   SetBorderColor(DEFAULT_LABEL_BACKGROUND_COLOR);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Label::~Label()
  {
  }
//+------------------------------------------------------------------+
