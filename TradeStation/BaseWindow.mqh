//+------------------------------------------------------------------+
//|                                                   BaseWindow.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Base.mqh"
#include "Global.mqh"
#include "Type.mqh"
//#include "Window.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BaseWindow:public Base
  {
private:
protected:
   int               m_x;
   int               m_y;
   int               m_width;
   int               m_height;
   color             m_back_clr;
   color             m_clr;
   color             m_border_clr;
   ENUM_BASE_CORNER  m_corner;
   bool              m_back;
   bool              m_selection;
   bool              m_hidden;
   long              m_z_order;
   string            m_text;
   string            m_font;
   int               m_font_size;
   ENUM_ALIGN_MODE   m_align;
   bool              m_readonly;

public:
                     BaseWindow(const string name="BaseWindow",// label name 
                                                  const int x=10,                                  // X coordinate 
                                                  const int y=20,                                  // Y coordinate 
                                                  const int width=200,                             // width 
                                                  const int height=100);                           // height 
                    ~BaseWindow();
   void              SetColor(color clr);
   void              SetBackColor(color back_clr);
   void              SetBorderColor(color border_clr);
   void              SetX(int x);
   void              SetY(int y);
   void              SetWidth(int width);
   void              SetHeight(int height);
   void              SetCorner(ENUM_BASE_CORNER corner);
   void              SetBack(bool back);
   void              SetSelection(bool selection);
   void              SetHidden(bool hidden);
   void              SetZOrder(bool z_order);
   //string            GetName(void);
   void              ShowWindow(bool visible);
   void              ShowWindow(void);
   void              HideWindow(void);
   void              SetText(string text);
   void              SetFont(string font);
   void              SetFontSize(int font_size);

   void              SetTextAlignment(ENUM_ALIGN_MODE align);
   void              SetReadOnly(bool readonly);

   int               GetX(void);
   int               GetY(void);
   int               GetWidth(void);
   int               GetHeight(void);
   string            Text(void);
   virtual void OnClick(void){};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseWindow::BaseWindow(const string name,
                       const int x,
                       const int y,
                       const int width,
                       const int height)
  {
   m_text=NULL;
   m_name=name;
   m_x = x;
   m_y = y;
   m_width=width;
   m_height=height;
   m_back_clr=C'0xff,0xff,0xff';
   m_clr=clrBlack;
   m_border_clr=clrBlack;
   m_corner=CORNER_LEFT_UPPER;
   m_back=false;
   m_selection=false;
   m_hidden=true;
   m_z_order=0;
   m_font=DEFAULT_FONT_NAME;
   m_font_size=DEFAULT_FONT_SIZE;
   m_align=ALIGN_LEFT;
   m_readonly=true;

   ResetLastError();
   if(!ObjectCreate(0,m_name,OBJ_EDIT,0,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return;
     }

   SetX(m_x);
   SetY(m_y);
   SetWidth(m_width);
   SetHeight(m_height);
   SetBackColor(m_back_clr);
   SetColor(m_clr);
   SetBorderColor(m_border_clr);
   SetCorner(m_corner);
   SetBack(m_back);
   SetSelection(m_selection);
   SetHidden(m_hidden);
   SetZOrder(m_z_order);
   SetFont(m_font);
   SetFontSize(m_font_size);
   SetReadOnly(true);
   SetText(m_text);
   SetTextAlignment(m_align);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseWindow::~BaseWindow()
  {
//--- reset the error value 
   ResetLastError();
//--- delete the label 
   if(!ObjectDelete(0,m_name))
     {
      Print(__FUNCTION__,
            ": failed to delete a rectangle label! Error code = ",GetLastError());
      return;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseWindow::GetX(void)
  {
   return(m_x);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseWindow::GetY(void)
  {
   return(m_y);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseWindow::GetWidth(void)
  {
   return(m_width);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BaseWindow::GetHeight(void)
  {
   return(m_height);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetText(string text)
  {
   m_text=text;
//--- set the text    
   ObjectSetString(0,m_name,OBJPROP_TEXT,m_text);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string BaseWindow::Text(void) 
  {
   return(ObjectGetString(0,m_name,OBJPROP_TEXT));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetTextAlignment(ENUM_ALIGN_MODE align)
  {
   m_align=align;
//--- set the type of text alignment in the object 
   ObjectSetInteger(0,m_name,OBJPROP_ALIGN,m_align);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetReadOnly(bool readonly)
  {
   m_readonly=readonly;
//--- enable (true) or cancel (false) read-only mode 
   ObjectSetInteger(0,m_name,OBJPROP_READONLY,m_readonly);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetFont(string font)
  {
   m_font=font;
//--- set text font 
   ObjectSetString(0,m_name,OBJPROP_FONT,m_font);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetFontSize(int font_size)
  {
   m_font_size=font_size;
//--- set font size 
   ObjectSetInteger(0,m_name,OBJPROP_FONTSIZE,m_font_size);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::ShowWindow(bool visible)
  {
   if(visible)
     {
      ShowWindow();
     }
   else
     {
      HideWindow();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::ShowWindow(void)
  {
   ObjectSetInteger(0,m_name,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::HideWindow(void)
  {
   ObjectSetInteger(0,m_name,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetColor(color clr)
  {
   m_clr=clr;
//--- set flat border color (in Flat mode) 
   ObjectSetInteger(0,m_name,OBJPROP_COLOR,m_clr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetBackColor(color back_clr)
  {
   m_back_clr=back_clr;
//--- set background color 
   ObjectSetInteger(0,m_name,OBJPROP_BGCOLOR,m_back_clr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetBorderColor(color border_clr)
  {
   m_border_clr=border_clr;
//--- set border color 
   ObjectSetInteger(0,m_name,OBJPROP_BORDER_COLOR,m_border_clr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetX(int x)
  {
   m_x=x;
//--- set x coordinate 
   ObjectSetInteger(0,m_name,OBJPROP_XDISTANCE,m_x);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetY(int y)
  {
   m_y=y;
//--- set y coordinate 
   ObjectSetInteger(0,m_name,OBJPROP_YDISTANCE,m_y);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetWidth(int width)
  {
   m_width=width;
//--- set width 
   ObjectSetInteger(0,m_name,OBJPROP_XSIZE,m_width);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetHeight(int height)
  {
   m_height=height;
//--- set height
   ObjectSetInteger(0,m_name,OBJPROP_YSIZE,m_height);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetCorner(ENUM_BASE_CORNER corner)
  {
   m_corner=corner;
//--- set the chart's corner, relative to which point coordinates are defined 
   ObjectSetInteger(0,m_name,OBJPROP_CORNER,m_corner);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetBack(bool back)
  {
   m_back=back;
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(0,m_name,OBJPROP_BACK,m_back);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetSelection(bool selection)
  {
   m_selection=selection;
//--- enable (true) or disable (false) the mode of moving the label by mouse 
   ObjectSetInteger(0,m_name,OBJPROP_SELECTABLE,m_selection);
   ObjectSetInteger(0,m_name,OBJPROP_SELECTED,m_selection);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetHidden(bool hidden)
  {
   m_hidden=hidden;
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(0,m_name,OBJPROP_HIDDEN,m_hidden);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BaseWindow::SetZOrder(bool z_order)
  {
   m_z_order=z_order;
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(0,m_name,OBJPROP_ZORDER,m_z_order);
  }
//+------------------------------------------------------------------+
