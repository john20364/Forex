//+------------------------------------------------------------------+
//|                                                 TSVisualTool.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "TradeModel.mqh";
#include  <ChartObjects\ChartObjectsLines.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TSVisualTool
  {
private:
   bool              m_enabled;
   TradeModel       *m_model;
   int               m_candle_count;

   void              DrawLines(void);
   void              RemoveLines(void);

   CChartObjectHLine m_price_line;
   CChartObjectHLine m_stop_loss_line;
   CChartObjectHLine m_take_profit_line;

   void              CreatePriceLine(double price);
   void              CreateStopLossLine(double stopploss);
   void              CreateTakeProfitLine(double takeprofit);
   bool              LeftButtonDown(uint state);

public:
   bool              Enabled(bool enabled);
   bool              Enabled(void);
   void              Attach(TradeModel *model);
   void              Detach(void);
   void              Update(void);
   void              OnChartEvent(const int id,
                                  const long &lparam,
                                  const double &dparam,
                                  const string &sparam);

                     TSVisualTool();
                    ~TSVisualTool();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TSVisualTool::TSVisualTool()
  {
   m_model=NULL;
   m_enabled=false;
   m_candle_count=5;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TSVisualTool::~TSVisualTool()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSVisualTool::Enabled(bool enabled)
  {
   m_enabled=enabled;
   if(m_enabled)
     {
      DrawLines();
      EventChartCustom(0,VISUAL_TOOL_ACTIVATED,0,0,"VISUAL_TOOL_ACTIVATED");
     }
   else
     {
      RemoveLines();
     }
   return(m_enabled);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSVisualTool::Enabled(void)
  {
   return(m_enabled);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::Attach(TradeModel *model)
  {
   m_model=model;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::Detach(void)
  {
   m_model=NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::Update(void)
  {
   if(m_enabled)
     {
      m_price_line.Price(0,m_model.Price());
      m_stop_loss_line.Price(0,m_model.StopLoss());
      m_take_profit_line.Price(0,m_model.TakeProfit());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::DrawLines(void)
  {
   double price=m_model.Price();
   double stoploss=m_model.StopLoss();
   double takeprofit=m_model.TakeProfit();
   double value;
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);

   int idxLowest=iLowest(NULL,0,MODE_LOW,m_candle_count);
   int idxHighest=iHighest(NULL,0,MODE_HIGH,m_candle_count);
   if(idxLowest==-1 || idxHighest==-1) return;

   double val1 = MathAbs(Low[idxLowest] - tick.bid);
   double val2 = MathAbs(High[idxHighest] - tick.bid);
   value=(val1>val2) ? val1 : val2;

   switch(m_model._OrderType())
     {
      case OP_BUY:
         price=0;
         if(stoploss==0) m_model.StopLoss(tick.bid-2*value);
         if(takeprofit==0) m_model.TakeProfit(tick.bid+2*value);
         break;
      case OP_BUYLIMIT:
         if(price==0)m_model.Price(tick.bid-value);
         if(stoploss==0) m_model.StopLoss(tick.bid-3*value);
         if(takeprofit==0) m_model.TakeProfit(tick.bid+value);
         break;
      case OP_BUYSTOP:
         if(price==0)m_model.Price(tick.bid+value);
         if(stoploss==0) m_model.StopLoss(tick.bid-value);
         if(takeprofit==0) m_model.TakeProfit(tick.bid+3*value);
         break;
      case OP_SELL:
         price=0;
         if(stoploss==0) m_model.StopLoss(tick.bid+2*value);
         if(takeprofit==0) m_model.TakeProfit(tick.bid-2*value);
         break;
      case OP_SELLLIMIT:
         if(price==0)m_model.Price(tick.bid+value);
         if(stoploss==0) m_model.StopLoss(tick.bid+3*value);
         if(takeprofit==0) m_model.TakeProfit(tick.bid-value);
         break;
      case OP_SELLSTOP:
         if(price==0)m_model.Price(tick.bid-value);
         if(stoploss==0) m_model.StopLoss(tick.bid+value);
         if(takeprofit==0) m_model.TakeProfit(tick.bid-3*value);
         break;
     }

   CreatePriceLine(m_model.Price());
   CreateStopLossLine(m_model.StopLoss());
   CreateTakeProfitLine(m_model.TakeProfit());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::RemoveLines(void)
  {
   m_price_line.Delete();
   m_stop_loss_line.Delete();
   m_take_profit_line.Delete();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::CreatePriceLine(double price)
  {
   m_price_line.Create(m_model.Chart().ChartId(),"m_price_line",0,price);
//m_price_line.Background(true);
   m_price_line.Color(clrBlue);
   m_price_line.Selected(true);
   m_price_line.Selectable(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::CreateStopLossLine(double stopploss)
  {
   m_stop_loss_line.Create(m_model.Chart().ChartId(),"m_stop_loss_line",0,stopploss);
//m_stop_loss_line.Background(true);
   m_stop_loss_line.Color(clrRed);
   m_stop_loss_line.Selected(true);
   m_stop_loss_line.Selectable(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::CreateTakeProfitLine(double takeprofit)
  {
   m_take_profit_line.Create(m_model.Chart().ChartId(),"m_take_profit_line",0,takeprofit);
//m_take_profit_line.Background(true);
   m_take_profit_line.Color(clrGreen);
   m_take_profit_line.Selected(true);
   m_take_profit_line.Selectable(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSVisualTool::LeftButtonDown(uint state)
  {
   return((state & 1)==1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSVisualTool::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_MOUSE_MOVE:
         m_model.OnTickActive(!LeftButtonDown((uint)sparam));
         break;
      case CHARTEVENT_OBJECT_DRAG:
        {
         MqlTick tick;
         SymbolInfoTick(Symbol(),tick);

         // PRICE
         if(sparam=="m_price_line")
           {
            switch(m_model._OrderType())
              {
               case OP_BUY:
                  m_price_line.Price(0,m_model.Price());
                  break;
               case OP_BUYLIMIT:
                  if(m_price_line.Price(0)>=tick.bid || m_price_line.Price(0)<=m_model.StopLoss() || m_price_line.Price(0)>=m_model.TakeProfit())
                    {
                     m_price_line.Price(0,m_model.Price());
                    }
                  else
                    {
                     m_model.Price(m_price_line.Price(0));
                    }
                  break;
               case OP_BUYSTOP:
                  if(m_price_line.Price(0)<=tick.bid || m_price_line.Price(0)>=m_model.TakeProfit() || m_price_line.Price(0)<=m_model.StopLoss())
                    {
                     m_price_line.Price(0,m_model.Price());
                    }
                  else
                    {
                     m_model.Price(m_price_line.Price(0));
                    }
                  break;
               case OP_SELL:
                  m_price_line.Price(0,m_model.Price());
                  break;
               case OP_SELLLIMIT:
                  if(m_price_line.Price(0)<=tick.bid || m_price_line.Price(0)>=m_model.StopLoss() || m_price_line.Price(0)<=m_model.TakeProfit())
                    {
                     m_price_line.Price(0,m_model.Price());
                    }
                  else
                    {
                     m_model.Price(m_price_line.Price(0));
                    }
                  break;
               case OP_SELLSTOP:
                  if(m_price_line.Price(0)>=tick.bid || m_price_line.Price(0)<=m_model.TakeProfit() || m_price_line.Price(0)>=m_model.StopLoss())
                    {
                     m_price_line.Price(0,m_model.Price());
                    }
                  else
                    {
                     m_model.Price(m_price_line.Price(0));
                    }
                  break;
              }
           }
         // STOPLOSS
         else if(sparam=="m_stop_loss_line")
           {
            switch(m_model._OrderType())
              {
               case OP_BUY:
                  if(m_stop_loss_line.Price(0)>=tick.bid)
                    {
                     m_stop_loss_line.Price(0,m_model.StopLoss());
                    }
                  else
                    {
                     m_model.StopLoss(m_stop_loss_line.Price(0));
                    }
                  break;
               case OP_BUYLIMIT:
               case OP_BUYSTOP:
                  if(m_stop_loss_line.Price(0)>=m_model.Price())
                    {
                     m_stop_loss_line.Price(0,m_model.StopLoss());
                    }
                  else
                    {
                     m_model.StopLoss(m_stop_loss_line.Price(0));
                    }
                  break;
               case OP_SELL:
                  if(m_stop_loss_line.Price(0)<=tick.bid)
                    {
                     m_stop_loss_line.Price(0,m_model.StopLoss());
                    }
                  else
                    {
                     m_model.StopLoss(m_stop_loss_line.Price(0));
                    }
                  break;
               case OP_SELLLIMIT:
               case OP_SELLSTOP:
                  if(m_stop_loss_line.Price(0)<=m_model.Price())
                    {
                     m_stop_loss_line.Price(0,m_model.StopLoss());
                    }
                  else
                    {
                     m_model.StopLoss(m_stop_loss_line.Price(0));
                    }
                  break;
              }
           }
         // TAKEPROFIT
         else if(sparam=="m_take_profit_line")
           {
            switch(m_model._OrderType())
              {
               case OP_BUY:
                  if(m_take_profit_line.Price(0)<=tick.bid)
                    {
                     m_take_profit_line.Price(0,m_model.TakeProfit());
                    }
                  else
                    {
                     m_model.TakeProfit(m_take_profit_line.Price(0));
                    }
                  break;
               case OP_BUYLIMIT:
               case OP_BUYSTOP:
                  if(m_take_profit_line.Price(0)<=m_model.Price())
                    {
                     m_take_profit_line.Price(0,m_model.TakeProfit());
                    }
                  else
                    {
                     m_model.TakeProfit(m_take_profit_line.Price(0));
                    }
                  break;
               case OP_SELL:
                  if(m_take_profit_line.Price(0)>=tick.bid)
                    {
                     m_take_profit_line.Price(0,m_model.TakeProfit());
                    }
                  else
                    {
                     m_model.TakeProfit(m_take_profit_line.Price(0));
                    }
                  break;
               case OP_SELLLIMIT:
               case OP_SELLSTOP:
                  if(m_take_profit_line.Price(0)>=m_model.Price())
                    {
                     m_take_profit_line.Price(0,m_model.TakeProfit());
                    }
                  else
                    {
                     m_model.TakeProfit(m_take_profit_line.Price(0));
                    }
                  break;
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
