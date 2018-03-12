//+------------------------------------------------------------------+
//|                                                         Edit.mqh |
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
class Edit : public BaseWindow
  {
private:

public:
                     Edit(const string name="Edit",// edit name 
                                            const int x=0,                                  // X coordinate 
                                            const int y=0,                                  // Y coordinate 
                                            const int width=100,                            // width 
                                            const int height=25);                           // height ););
                    ~Edit();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Edit::Edit(const string name="Edit",
           const int x=0,
           const int y=0,
           const int width=100,
           const int height=25):BaseWindow(name,x,y,width,height)
  {
   SetBackColor(DEFAULT_EDIT_BACKGROUND_COLOR);
   SetColor(DEFAULT_EDIT_COLOR);
   SetBorderColor(DEFAULT_EDIT_COLOR);
   SetTextAlignment(ALIGN_RIGHT);
   SetReadOnly(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Edit::~Edit()
  {
  }
//+------------------------------------------------------------------+
