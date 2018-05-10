//+------------------------------------------------------------------+
//|                                                 TradeStation.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "GLobal.mqh"
#include "TradeModel.mqh"
#include "ToolModel.mqh"
#include "TradeWindow.mqh"
#include "ToolWindow.mqh"

TradeModel *trade_model;
ToolModel *tool_model;
TradeWindow *trade_win;
ToolWindow *tool_win;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,0,false);
   ChartSetInteger(0,CHART_SHOW_OHLC,0,false);

//   PrintFormat("TerminalInfoString(TERMINAL_DATA_PATH)=%s",TerminalInfoString(TERMINAL_DATA_PATH));
//PrintFormat("EnumToString(ENUM_TIMEFRAMES(_Period))=%s",EnumToString(ENUM_TIMEFRAMES(_Period)));
   trade_model=new TradeModel();
   tool_model=new ToolModel();

   trade_win=new TradeWindow(trade_model.PeriodName()+" "+Symbol(),0,0,300,100);
   trade_win.Attach(trade_model);

   tool_win=new ToolWindow("Toolbox",310,0,360,100);
   tool_win.Attach(tool_model);
   
   EventSetMillisecondTimer(100);   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete(tool_win);
   delete(trade_win);
   delete(tool_model);
   delete(trade_model);
//--- destroy timer
//EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   trade_model.OnTick();
  }
  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   MqlDateTime dt;

   TimeLocal(dt);
   string local_str=StringFormat("LT: %02d:%02d:%02d",dt.hour,dt.min,dt.sec);

   TimeGMT(dt);
   string gmt_str=StringFormat("GMT: %02d:%02d:%02d",dt.hour,dt.min,dt.sec);

   TimeCurrent(dt);
   string server_str=StringFormat("ST: %02d:%02d:%02d",dt.hour,dt.min,dt.sec);
   
   tool_win.SetCaption(gmt_str + "     " + local_str + "     " + server_str);   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   trade_win.OnChartEvent(id,lparam,dparam,sparam);
   tool_win.OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
