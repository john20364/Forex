//+------------------------------------------------------------------+
//|                                           TradeWindowSetting.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "../WinCtrl/Type.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeWindowSetting
  {
private:
   string            m_filename;
   void              DefaultSetting(void);
public:
                     TradeWindowSetting();
                    ~TradeWindowSetting();
   TTradeWindow      values;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeWindowSetting::DefaultSetting(void)
  {
   values.maximized=true;
   values.risk_type=RT_PERCENTAGE;
   values.risk_percentage=0.5;
   values.lot_size=0.1;
   values.reward_to_risk=1.0;
   values.order_type=OP_BUY;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeWindowSetting::TradeWindowSetting()
  {
   DefaultSetting();

//m_filename="TradeWindow"+Symbol()+EnumToString(ENUM_TIMEFRAMES(_Period));
   m_filename="TradeWindow"+Symbol();

   int fh=FileOpen(m_filename,FILE_READ|FILE_BIN|FILE_COMMON);
   if(fh!=INVALID_HANDLE)
     {
      // Read Settings;
      uint size=FileReadStruct(fh,values);
      FileClose(fh);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeWindowSetting::~TradeWindowSetting()
  {
   int fh=FileOpen(m_filename,FILE_WRITE|FILE_BIN|FILE_COMMON);
   if(fh!=INVALID_HANDLE)
     {
      // Read Settings;
      uint size=FileWriteStruct(fh,values);
      FileClose(fh);
     }
  }
//+------------------------------------------------------------------+
