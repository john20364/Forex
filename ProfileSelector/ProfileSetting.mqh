//+------------------------------------------------------------------+
//|                                               ProfileSetting.mqh |
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
class ProfileSetting
  {
private:
   string            m_filename;
   void              DefaultSetting(void);

public:
                     ProfileSetting();
                    ~ProfileSetting();
   TProfileSetting   values;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ProfileSetting::DefaultSetting(void)
  {
//    StringToCharArray("FX_EURUSD",values.currencyLabel);
    StringToCharArray("",values.currencyLabel);
    StringToCharArray("",values.tags);
    values.profile_type = PT_FAILED_BREAKOUT;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ProfileSetting::ProfileSetting()
  {
   DefaultSetting();

   //m_filename="ToolWindow"+Symbol()+EnumToString(ENUM_TIMEFRAMES(_Period));
   m_filename="ProfileSetting";

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
ProfileSetting::~ProfileSetting()
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
