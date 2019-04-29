//+------------------------------------------------------------------+
//|                                                  TradeWindow.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "../WinCtrl/Global.mqh"
#include "../WinCtrl/PositionManager.mqh"
#include "../WinCtrl/Window.mqh"
#include "../WinCtrl/Label.mqh"
#include "../WinCtrl/Button.mqh"
#include "../WinCtrl/Edit.mqh"
#include "../WinCtrl/WinUtil.mqh"
#include "TradeModel.mqh"
#include "TradeWindowSetting.mqh"
#include "TSVisualTool.mqh"

class TradeWindow;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeWindow : public Window
  {
private:
   TradeModel       *m_model;
   TradeWindowSetting setting;
   TSVisualTool      visualtool;

   void              ReadSettings(void);
   void              WriteSettings(void);
   void              UpdateRiskType(void);
   void              UpdateOrderType(void);
   void              UpdateState(bool all=true);
   void              UpdateTradeState(void);
   void              UpdateVisualToolState(bool state);
   void              UpdateOrderButtonState(bool state);
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

   Label            *m_order_type_paragraph;
   Button           *m_buy_button;
   Button           *m_buy_stop_button;
   Button           *m_buy_limit_button;
   Button           *m_sell_button;
   Button           *m_sell_stop_button;
   Button           *m_sell_limit_button;

   Label            *m_trade_data_paragraph;
   Label            *m_spread_label;
   Edit             *m_spread_edit;
   Label            *m_price_label;
   Edit             *m_price_edit;
   Label            *m_stop_loss_label;
   Edit             *m_stop_loss_edit;
   Label            *m_take_profit_label;
   Edit             *m_take_profit_edit;
   Label            *m_visual_tool_label;
   Button           *m_visual_tool_button;

   Label            *m_order_paragraph;
   Button           *m_order_button;

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
   void              Attach(TradeModel *model);

  };
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

   m.Columns(1);
   row++;
   dim=m.Rect(row,0);
   m_order_type_paragraph=CreateParagraph(m_name+"m_order_type_paragraph",dim);
   m_order_type_paragraph.SetText("Order Type");
   AddChild(m_order_type_paragraph);

   m.Columns(3);
   row++;
   dim=m.Rect(row,0);
   m_buy_button=CreateButton(m_name+"m_buy_button",dim);
   m_buy_button.SetText("Buy");
   AddChild(m_buy_button);

   dim=m.Rect(row,1);
   m_buy_stop_button=CreateButton(m_name+"m_buy_stop_button",dim);
   m_buy_stop_button.SetText("Buy Stop");
   AddChild(m_buy_stop_button);

   dim=m.Rect(row,2);
   m_buy_limit_button=CreateButton(m_name+"m_buy_limit_button",dim);
   m_buy_limit_button.SetText("Buy Limit");
   AddChild(m_buy_limit_button);

   row++;
   dim=m.Rect(row,0);
   m_sell_button=CreateButton(m_name+"m_sell_button",dim);
   m_sell_button.SetText("Sell");
   AddChild(m_sell_button);

   dim=m.Rect(row,1);
   m_sell_stop_button=CreateButton(m_name+"m_sell_stop_button",dim);
   m_sell_stop_button.SetText("Sell Stop");
   AddChild(m_sell_stop_button);

   dim=m.Rect(row,2);
   m_sell_limit_button=CreateButton(m_name+"m_sell_limit_button",dim);
   m_sell_limit_button.SetText("Sell Limit");
   AddChild(m_sell_limit_button);

   m.Columns(1);
   row++;
   dim=m.Rect(row,0);
   m_trade_data_paragraph=CreateParagraph(m_name+"m_trade_data_paragraph",dim);
   m_trade_data_paragraph.SetText("Trade Data");
   AddChild(m_trade_data_paragraph);

   m.Columns(3);
   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,1).right;
   m_spread_label=CreateLabel(m_name+"m_spread_label",dim);
   m_spread_label.SetText("Spread in pips");
   AddChild(m_spread_label);

   dim=m.Rect(row,2);
   m_spread_edit=CreateEdit(m_name+"m_spread_edit",dim);
   SetEditState(m_spread_edit,false);
   AddChild(m_spread_edit);

   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,1).right;
   m_price_label=CreateLabel(m_name+"m_price_label",dim);
   m_price_label.SetText("Price");
   AddChild(m_price_label);

   dim=m.Rect(row,2);
   m_price_edit=CreateEdit(m_name+"m_price_edit",dim);
   AddChild(m_price_edit);

   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,1).right;
   m_stop_loss_label=CreateLabel(m_name+"m_stop_loss_label",dim);
   m_stop_loss_label.SetText("Stop Loss");
   AddChild(m_stop_loss_label);

   dim=m.Rect(row,2);
   m_stop_loss_edit=CreateEdit(m_name+"m_stop_loss_edit",dim);
   AddChild(m_stop_loss_edit);

   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,1).right;
   m_take_profit_label=CreateLabel(m_name+"m_take_profit_label",dim);
   m_take_profit_label.SetText("Take Profit");
   AddChild(m_take_profit_label);

   dim=m.Rect(row,2);
   m_take_profit_edit=CreateEdit(m_name+"m_take_profit_edit",dim);
   AddChild(m_take_profit_edit);

   row++;
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,1).right;
   m_visual_tool_label=CreateLabel(m_name+"m_visual_tool_label",dim);
   m_visual_tool_label.SetText("Visual Tool");
   AddChild(m_visual_tool_label);

   dim=m.Rect(row,2);
   m_visual_tool_button=CreateButton(m_name+"m_visual_tool_button",dim);
   m_visual_tool_button.SetText("Off");
   AddChild(m_visual_tool_button);

   m.Columns(1);
   row++;
   dim=m.Rect(row,0);
   m_order_paragraph=CreateParagraph(m_name+"m_order_paragraph",dim);
   m_order_paragraph.SetText("Order");
   AddChild(m_order_paragraph);

   row++;
   dim=m.Rect(row,0);
   m_order_button=CreateButton(m_name+"m_order_button",dim);
   AddChild(m_order_button);

   SetClientHeight(dim.bottom-GetClientY()+5);
   ReadSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeWindow::~TradeWindow()
  {
   WriteSettings();
   visualtool.Detach();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::UpdateRiskType(void)
  {
   switch(m_model.RiskType())
     {
      case RT_PERCENTAGE:
         SetButtonState(m_percentage_button,true);
         SetButtonState(m_lot_size_button,false);

         SetEditState(m_risk_percentage_edit,true);
         SetEditState(m_lot_size_edit,false);
         break;
      case RT_LOT_SIZE:
         SetButtonState(m_percentage_button,false);
         SetButtonState(m_lot_size_button,true);

         SetEditState(m_risk_percentage_edit,false);
         SetEditState(m_lot_size_edit,true);
         break;
     }
   m_risk_percentage_edit.SetText(DoubleToString(m_model.RiskPercentage(),2));
   m_lot_size_edit.SetText(DoubleToString(m_model.LotSize(),2));
   m_reward_to_risk_edit.SetText(DoubleToString(m_model.RewardToRisk(),2));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::UpdateOrderType()
  {
   SetButtonState(m_buy_button,false);
   SetButtonState(m_buy_stop_button,false);
   SetButtonState(m_buy_limit_button,false);
   SetButtonState(m_sell_button,false);
   SetButtonState(m_sell_stop_button,false);
   SetButtonState(m_sell_limit_button,false);

   switch(m_model._OrderType())
     {
      case OP_BUY:
         SetButtonState(m_buy_button,true);
         break;
      case OP_BUYSTOP:
         SetButtonState(m_buy_stop_button,true);
         break;
      case OP_BUYLIMIT:
         SetButtonState(m_buy_limit_button,true);
         break;
      case OP_SELL:
         SetButtonState(m_sell_button,true);
         break;
      case OP_SELLSTOP:
         SetButtonState(m_sell_stop_button,true);
         break;
      case OP_SELLLIMIT:
         SetButtonState(m_sell_limit_button,true);
         break;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::UpdateTradeState(void)
  {
   m_spread_edit.SetText(DoubleToString(m_model.Spread(),1));

   int ndigits=m_model.NumberOfDigits();
   m_price_edit.SetText(DoubleToString(m_model.Price(),ndigits));
   m_stop_loss_edit.SetText(DoubleToString(m_model.StopLoss(),ndigits));
   m_take_profit_edit.SetText(DoubleToString(m_model.TakeProfit(),ndigits));

   switch(m_model._OrderType())
     {
      case OP_BUY:
      case OP_SELL:
         SetEditState(m_price_edit,false);
         break;
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         SetEditState(m_price_edit,true);
         break;
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::WriteSettings(void)
  {
   setting.values.maximized=IsMaximized();
   setting.values.risk_type=m_model.RiskType();
   setting.values.risk_percentage=m_model.RiskPercentage();
   setting.values.lot_size=m_model.LotSize();
   setting.values.reward_to_risk=m_model.RewardToRisk();
   setting.values.order_type=m_model._OrderType();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::Attach(TradeModel *model)
  {
   m_model=model;
   m_model.Init(setting.values);
   visualtool.Attach(m_model);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::UpdateOrderButtonState(bool state)
  {
   SetButtonState(m_order_button,state);
   if(state)
     {
      switch(m_model._OrderType())
        {
         case OP_BUY:
            m_order_button.SetText("Place "+m_buy_button.Text()+" Order");
            break;
         case OP_BUYLIMIT:
            m_order_button.SetText("Place "+m_buy_limit_button.Text()+" Order");
            break;
         case OP_BUYSTOP:
            m_order_button.SetText("Place "+m_buy_stop_button.Text()+" Order");
            break;
         case OP_SELL:
            m_order_button.SetText("Place "+m_sell_button.Text()+" Order");
            break;
         case OP_SELLLIMIT:
            m_order_button.SetText("Place "+m_sell_limit_button.Text()+" Order");
            break;
         case OP_SELLSTOP:
            m_order_button.SetText("Place "+m_sell_stop_button.Text()+" Order");
            break;
        }
     }
   else
     {
      m_order_button.SetText("No Order");
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::UpdateState(bool all)
  {
   if(all)
     {
      UpdateRiskType();
      UpdateOrderType();
     }

   UpdateTradeState();
   visualtool.Update();
   UpdateOrderButtonState(m_model.CanPlaceOrder());
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::UpdateVisualToolState(bool state)
  {
   SetButtonState(m_visual_tool_button,state);
   m_visual_tool_button.SetText((state ? "On" : "Off"));
   if(visualtool.Enabled(state))
     {
      UpdateState();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindow::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_CUSTOM+VISUAL_TOOL_ACTIVATED:
         Redraw();
         break;
      case CHARTEVENT_CUSTOM+WINDOW_MAXIMIZED:
         if(m_name==sparam)
           {
            m_model.OnTickActive(true);
            UpdateState();
           }
         break;
      case CHARTEVENT_CUSTOM+WINDOW_MINIMIZED:
         if(m_name==sparam)
           {
            m_model.OnTickActive(false);
           }
         break;
      case CHARTEVENT_CUSTOM+TRADE_STATION_MODEL_CHANGED:
         UpdateState();
         break;
      case CHARTEVENT_CUSTOM+TRADE_STATION_MODEL_TRADE_CHANGED:
         UpdateState(false);
         break;
      case CHARTEVENT_OBJECT_CLICK :
         if(!StringCompare(m_name+"m_percentage_button",sparam))
           {
            m_model.RiskType(RT_PERCENTAGE);
           }
         else if(!StringCompare(m_name+"m_lot_size_button",sparam))
           {
            m_model.RiskType(RT_LOT_SIZE);
           }
         else if(!StringCompare(m_name+"m_buy_button",sparam))
           {
            m_model._OrderType(OP_BUY);
            UpdateVisualToolState(false);
           }
         else if(!StringCompare(m_name+"m_buy_stop_button",sparam))
           {
            m_model._OrderType(OP_BUYSTOP);
            UpdateVisualToolState(false);
           }
         else if(!StringCompare(m_name+"m_buy_limit_button",sparam))
           {
            m_model._OrderType(OP_BUYLIMIT);
            UpdateVisualToolState(false);
           }
         else if(!StringCompare(m_name+"m_sell_button",sparam))
           {
            m_model._OrderType(OP_SELL);
            UpdateVisualToolState(false);
           }
         else if(!StringCompare(m_name+"m_sell_stop_button",sparam))
           {
            m_model._OrderType(OP_SELLSTOP);
            UpdateVisualToolState(false);
           }
         else if(!StringCompare(m_name+"m_sell_limit_button",sparam))
           {
            m_model._OrderType(OP_SELLLIMIT);
            UpdateVisualToolState(false);
           }
         else if(!StringCompare(m_name+"m_visual_tool_button",sparam))
           {
            UpdateVisualToolState(!visualtool.Enabled());
           }
         else if(!StringCompare(m_name+"m_order_button",sparam))
           {
            if(m_model.CanPlaceOrder())
              {
               UpdateVisualToolState(false);
               if(!m_model.PlaceOrder())
                 {
                  MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
                 }
              }
           }
         break;
      case CHARTEVENT_OBJECT_ENDEDIT:
         if(!StringCompare(m_name+"m_risk_percentage_edit",sparam))
           {
            if(!m_model.RiskPercentage(StringToDouble(m_risk_percentage_edit.Text())))
              {
               MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
               UpdateState();
              }
           }
         else if(!StringCompare(m_name+"m_lot_size_edit",sparam))
           {
            if(!m_model.LotSize(StringToDouble(m_lot_size_edit.Text())))
              {
               MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
               UpdateState();
              }
           }
         else if(!StringCompare(m_name+"m_reward_to_risk_edit",sparam))
           {
            if(!m_model.RewardToRisk(StringToDouble(m_reward_to_risk_edit.Text())))
              {
               MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
               UpdateState();
              }
           }
         else if(!StringCompare(m_name+"m_price_edit",sparam))
           {
            if(!m_model.Price(StringToDouble(m_price_edit.Text())))
              {
               MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
               UpdateState();
              }
           }
         else if(!StringCompare(m_name+"m_stop_loss_edit",sparam))
           {
            if(!m_model.StopLoss(StringToDouble(m_stop_loss_edit.Text())))
              {
               MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
               UpdateState();
              }
           }
         else if(!StringCompare(m_name+"m_take_profit_edit",sparam))
           {
            if(!m_model.TakeProfit(StringToDouble(m_take_profit_edit.Text())))
              {
               MessageBox(m_model.LastError(),"Error",MB_ICONERROR);
               UpdateState();
              }
           }
         break;
     }
   visualtool.OnChartEvent(id,lparam,dparam,sparam);
   Window::OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
