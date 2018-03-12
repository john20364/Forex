//+------------------------------------------------------------------+
//|                                                       Button.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "BaseWindow.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Button : public BaseWindow
  {
private:

public:
                     Button(const string name="Button",// button name 
                                              const int x=0,                                  // X coordinate 
                                              const int y=0,                                  // Y coordinate 
                                              const int width=100,                            // width 
                                              const int height=25);                           // height ););
                    ~Button();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Button::Button(const string name="Button",
               const int x=0,
               const int y=0,
               const int width=100,
               const int height=25):BaseWindow(name,x,y,width,height)
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  {
   SetReadOnly(true);
   SetBackColor(DEFAULT_BUTTON_BACKGROUND_COLOR);
   SetColor(DEFAULT_BUTTON_COLOR);
   SetBorderColor(DEFAULT_BUTTON_COLOR);
   SetTextAlignment(ALIGN_CENTER);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Button::~Button()
  {
  }
//+------------------------------------------------------------------+
