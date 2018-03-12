//+------------------------------------------------------------------+
//|                                                  TradeWindow.mqh |
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
#include "Button.mqh"
#include "Edit.mqh"
#include "WinUtil.mqh"
#include "TSModel.mqh"
#include "TradeWindowSetting.mqh"

class TradeWindow;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeWindow : public Window
  {
private:
   TSModel          *m_model;
   TradeWindowSetting setting;
   void              ReadSettings(void);
   void              WriteSettings(void);
protected:
   Label            *m_test_label;
   Label            *m_test_label2;
   Button           *m_test_button;
   Button           *m_test_button2;
   Label            *m_edit_label;
   Edit             *m_edit;
public:
                     TradeWindow(const string name="Window",
                                                   const int x=10,
                                                   const int y=20,
                                                   const int width=200,
                                                   const int height=100);
                    ~TradeWindow();
   void              OnChartEvent(const int id,
                                  const long &lparam,
                                  const double &dparam,
                                  const string &sparam);
   void              Attach(TSModel *model);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeWindow::TradeWindow(const string name,
                         const int x,
                         const int y,
                         const int width,
                         const int height):Window(name,x,y,width,height)
  {

   m_model=NULL;
   CRect dim;
   CPositionManager m;
   m.LayoutWidth(GetClientWidth());
   m.Offset(GetClientX(),GetClientY());

   m.Spacing(5, 5);
   m.ControlHeight(25);
   int row=0;

   m.Columns(1);

   m_test_label=CreatLabel(m_name+"TestLabel",m.Rect(row++,0));
   m_test_label2=CreatLabel(m_name+"TestLabel2",m.Rect(row++,0));

   m_test_label.SetText("Hello");
   m_test_label2.SetText("Forex");

   m.Columns(2);
   dim=m.Rect(row,0);
   m_test_button=CreateButton(m_name+"TestButton",dim);
   m_test_button.SetText("Hit me!");

   dim=m.Rect(row++,1);
   m_test_button2=CreateButton(m_name+"TestButton2",dim);
   m_test_button2.SetText("Trade");

   dim=m.Rect(row,0);
   m_edit_label=CreatLabel(m_name+"m_edit_label",dim);
   m_edit_label.SetText("edit1");

   dim=m.Rect(row,1);
   m_edit=CreateEdit(m_name+"m_edit",dim);
   m_edit.SetText(DoubleToString(0.0,2));

   SetClientHeight(dim.bottom-GetClientY()+5);

   AddChild(m_test_label);
   AddChild(m_test_label2);
   AddChild(m_test_button);
   AddChild(m_test_button2);
   AddChild(m_edit_label);
   AddChild(m_edit);

   ReadSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeWindow::~TradeWindow()
  {
   WriteSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::ReadSettings(void)
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
void TradeWindow::WriteSettings(void)
  {
   setting.values.maximized=IsMaximized();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::Attach(TSModel *model)
  {
   m_model=model;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_OBJECT_CLICK :
         if(!StringCompare(m_name+"TestLabel",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         else if(!StringCompare(m_name+"TestLabel2",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         else if(!StringCompare(m_name+"TestButton",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         else if(!StringCompare(m_name+"TestButton2",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         else if(!StringCompare(m_name+"m_edit_label",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         else if(!StringCompare(m_name+"m_edit",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_CLICK: [%s]",sparam);
           }
         break;
      case CHARTEVENT_OBJECT_ENDEDIT:
         if(!StringCompare(m_name+"m_edit",sparam))
           {
            PrintFormat("TradeWindow CHARTEVENT_OBJECT_ENDEDIT: [%s]",sparam);
           }
         break;
     }
   Window::OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
