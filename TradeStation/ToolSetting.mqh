//+------------------------------------------------------------------+
//|                                                  ToolSetting.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Type.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ToolSetting
  {
private:
   string            m_filename;
   void              DefaultSetting(void);

public:
                     ToolSetting();
                    ~ToolSetting();
   TToolWindow       values;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolSetting::DefaultSetting(void) 
  {
   values.maximized=true;
   values.broadcast=false;
   values.scale_fix=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolSetting::ToolSetting()
  {
   DefaultSetting();

   //m_filename="ToolWindow"+Symbol()+EnumToString(ENUM_TIMEFRAMES(_Period));
   m_filename="ToolWindow"+Symbol();

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
ToolSetting::~ToolSetting()
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
