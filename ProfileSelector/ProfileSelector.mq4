//+------------------------------------------------------------------+
//|                                              ProfileSelector.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict

#include "ProfileModel.mqh"
#include "ProfileWindow.mqh"

ProfileModel *profile_model;
ProfileWindow *profile_window;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,0,false);
   ChartSetInteger(0,CHART_SHOW_OHLC,0,false);
   
   profile_model=new ProfileModel();
   profile_window=new ProfileWindow("Profile Selector",0,0,440,100);

  EventSetMillisecondTimer(100);   

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
//EventKillTimer();
   delete (profile_window);
   delete (profile_model);
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
   MqlDateTime dt;

   TimeLocal(dt);
   string local_str=StringFormat("LT: %02d:%02d:%02d",dt.hour,dt.min,dt.sec);

   TimeGMT(dt);
   string gmt_str=StringFormat("GMT: %02d:%02d:%02d",dt.hour,dt.min,dt.sec);

   TimeCurrent(dt);
   string server_str=StringFormat("ST: %02d:%02d:%02d",dt.hour,dt.min,dt.sec);
   
   profile_window.SetCaption("Profiles    " + gmt_str + "     " + local_str + "     " + server_str); 
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
//---
   profile_window.OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
