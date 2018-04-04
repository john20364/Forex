//+------------------------------------------------------------------+
//|                                                    ToolModel.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Charts/Chart.mqh>
#include "Global.mqh"
#include "Type.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ToolModel
  {
private:
   CChart           *m_chart;
public:
                     ToolModel();
                    ~ToolModel();
   void              Init(TToolWindow &settings);
   void              DoNotifyChange();
   void              ScaleFix(bool state);
   bool              ScaleFix(void);
   void              PeriodIndex(int index);
   int               PeriodIndex(void);
   void              ChartScroll(bool state);
   bool              ChartScroll(void);
   void              ChartShift(bool state);
   bool              ChartShift(void);

   void              SynchronizeCharts(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolModel::ToolModel()
  {
   m_chart=new CChart();
   m_chart.Attach(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolModel::~ToolModel()
  {
   m_chart.Detach();
   delete(m_chart);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::ScaleFix(bool state)
  {
   m_chart.ScaleFix(state);
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ToolModel::ScaleFix(void)
  {
   return(m_chart.ScaleFix());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::ChartScroll(bool state)
  {
   m_chart.AutoScroll(state);
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//||
//+------------------------------------------------------------------+
bool ToolModel::ChartScroll(void)
  {
   return(m_chart.AutoScroll());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::ChartShift(bool state)
  {
   m_chart.Shift(state);
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ToolModel::ChartShift(void)
  {
   return(m_chart.Shift());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::PeriodIndex(int index)
  {
   if(index == PeriodIndex()) return;

   switch(index)
     {
      case 0:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_M1);
         break;
      case 1:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_M5);
         break;
      case 2:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_M15);
         break;
      case 3:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_M30);
         break;
      case 4:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_H1);
         break;
      case 5:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_H4);
         break;
      case 6:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_D1);
         break;
      case 7:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_W1);
         break;
      case 8:
         m_chart.SetSymbolPeriod(Symbol(),PERIOD_MN1);
         break;
         DoNotifyChange();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ToolModel::PeriodIndex(void)
  {
   switch(m_chart.Period())
     {
      case PERIOD_M1:
         return(0);
      case PERIOD_M5:
         return(1);
      case PERIOD_M15:
         return(2);
      case PERIOD_M30:
         return(3);
      case PERIOD_H1:
         return(4);
      case PERIOD_H4:
         return(5);
      case PERIOD_D1:
         return(6);
      case PERIOD_W1:
         return(7);
      case PERIOD_MN1:
         return(8);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::DoNotifyChange()
  {
   string sparam="TOOL_MODEL_CHANGED";
   EventChartCustom(0,TOOL_MODEL_CHANGED,0,0,sparam);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::SynchronizeCharts(void)
  {
   long id=ChartFirst();
   while(id!=-1)
     {
      if(id!=m_chart.ChartId())
        {
         ChartSetInteger(id,CHART_SCALEFIX,m_chart.ScaleFix());
         ChartSetInteger(id,CHART_AUTOSCROLL,m_chart.AutoScroll());
         ChartSetInteger(id,CHART_SHIFT,m_chart.Shift());
         ChartSetSymbolPeriod(id,ChartSymbol(id),m_chart.Period());
        }
      id=ChartNext(id);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolModel::Init(TToolWindow &settings)
  {
   m_chart.ScaleFix(settings.scale_fix);
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
