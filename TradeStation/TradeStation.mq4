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
#include "TSModel.mqh"
#include "TradeWindow.mqh"
#include "ToolWindow.mqh"

TSModel *tsmodel;
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
   tsmodel=new TSModel();
   
   trade_win= new TradeWindow("Trade Station",10,20,300,100);
   trade_win.Attach(tsmodel);
   
   tool_win = new ToolWindow("Toolbox",320,20,330,100);
//--- create timer
//EventSetTimer(60);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   delete(tool_win);
   delete(trade_win);
   delete(tsmodel);
//--- destroy timer
//EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

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
