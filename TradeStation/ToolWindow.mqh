//+------------------------------------------------------------------+
//|                                                   ToolWindow.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Global.mqh"
#include "PositionManager.mqh"
#include "Window.mqh"
#include "Label.mqh"
#include "WinUtil.mqh"
#include "ToolSetting.mqh"

class ToolWindow;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ToolWindow : public Window
  {
private:
   ToolSetting       setting;
   void              ReadSettings(void);
   void              WriteSettings(void);
protected:
   Label            *m_test_label;

public:
                     ToolWindow(const string name="Window",
                                                  const int x=10,
                                                  const int y=20,
                                                  const int width=200,
                                                  const int height=100);
                    ~ToolWindow();
   void              OnChartEvent(const int id,
                                  const long &lparam,
                                  const double &dparam,
                                  const string &sparam);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolWindow::ToolWindow(const string name,
                       const int x,
                       const int y,
                       const int width,
                       const int height):Window(name,x,y,width,height)
  {
   CRect dim;
   CPositionManager m;
   m.LayoutWidth(GetClientWidth());
   m.Offset(GetClientX(),GetClientY());

   m.Spacing(5, 5);
   m.ControlHeight(25);
   int row=0;

   m.Columns(1);

   dim=m.Rect(row++,0);

   m_test_label=CreatLabel(m_name+"TestLabel",dim);

   m_test_label.SetText("Scale fix");

   SetClientHeight(dim.bottom-GetClientY()+5);

   AddChild(m_test_label);
   ReadSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolWindow::~ToolWindow()
  {
   WriteSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::ReadSettings(void)
  {
   if(setting.values.maximized) 
     {
      Maximize();
     }
   else 
     {
      Minimize();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::WriteSettings(void)
  {
   setting.values.maximized=IsMaximized();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_OBJECT_CLICK :
         if(!StringCompare(m_name+"TestLabel",sparam))
           {
            PrintFormat("ToolWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         break;
     }
   Window::OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
