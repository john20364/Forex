//+------------------------------------------------------------------+
//|                                                      TSModel.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Charts/Chart.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TSModel
  {
private:
   CChart            *m_chart;

public:
                     TSModel();
                    ~TSModel();
   CChart            *Chart(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TSModel::TSModel()
  {
   m_chart = new CChart();
   m_chart.Attach(0);
   m_chart.EventMouseMove();
   m_chart.Foreground(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TSModel::~TSModel()
  {
   m_chart.Detach();
   delete(m_chart);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChart *TSModel::Chart(void) 
  {
   return m_chart;
  }
//+------------------------------------------------------------------+
