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
   void              SetButtonState(Button *button,bool selected);
protected:
   Label            *m_risk_paragraph;
   Button           *m_percentage_button;
   Button           *m_lot_size_button;
   Label            *m_risk_percentage_label;
   Edit             *m_risk_percentage_edit;
   Label            *m_lot_size_label;
   Edit             *m_lot_size_edit;
   Label            *m_reward_to_risk_label;
   Edit             *m_reward_to_risk_edit;

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
   dim=m.Rect(row,0);
   m_risk_paragraph=CreateParagraph(m_name+"m_risk_label",dim);
   m_risk_paragraph.SetText("Risk");
   AddChild(m_risk_paragraph);

   m.Columns(2);
   row++;
   dim=m.Rect(row,0);
   m_percentage_button=CreateButton(m_name+"m_percentage_button",dim);
   m_percentage_button.SetText("Percentage");
   AddChild(m_percentage_button);

   dim=m.Rect(row,1);
   m_lot_size_button=CreateButton(m_name+"m_lot_size_button",dim);
   m_lot_size_button.SetText("Lot Size");
   AddChild(m_lot_size_button);

   m.Columns(4);
   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,2).right;
   m_risk_percentage_label=CreateLabel(m_name+"m_risk_percentage_label",dim);
   m_risk_percentage_label.SetText("Risk Percentage");
   AddChild(m_risk_percentage_label);

   dim=m.Rect(row,3);
   m_risk_percentage_edit=CreateEdit(m_name+"m_risk_percentage_edit",dim);
   AddChild(m_risk_percentage_edit);

   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,2).right;
   m_lot_size_label=CreateLabel(m_name+"m_lot_size_label",dim);
   m_lot_size_label.SetText("Lot Size");
   AddChild(m_lot_size_label);

   dim=m.Rect(row,3);
   m_lot_size_edit=CreateEdit(m_name+"m_lot_size_edit",dim);
   AddChild(m_lot_size_edit);

   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,2).right;
   m_reward_to_risk_label=CreateLabel(m_name+"m_reward_to_risk_label",dim);
   m_reward_to_risk_label.SetText("Reward to Risk");
   AddChild(m_reward_to_risk_label);

   dim=m.Rect(row,3);
   m_reward_to_risk_edit=CreateEdit(m_name+"m_reward_to_risk_edit",dim);
   AddChild(m_reward_to_risk_edit);

   SetClientHeight(dim.bottom-GetClientY()+5);
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
void TradeWindow::SetButtonState(Button *button,bool selected)
  {
   if(selected)
     {
      button.SetBackColor(clrLime);
      button.SetColor(clrBlack);
     }
   else
     {
      button.SetBackColor(clrRed);
      button.SetColor(clrWhite);
     }
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

   SetButtonState(m_percentage_button,setting.values.percentage_button);
   SetButtonState(m_lot_size_button,setting.values.lot_size_button);

   m_risk_percentage_edit.SetText(DoubleToString(setting.values.risk_percentage,2));
   m_lot_size_edit.SetText(DoubleToString(setting.values.lot_size,2));
   m_reward_to_risk_edit.SetText(DoubleToString(setting.values.reward_to_risk,2));
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
