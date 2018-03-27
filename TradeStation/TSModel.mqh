//+------------------------------------------------------------------+
//|                                                      TSModel.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| The Ask price is where we OPEN BUY ORDERS and CLOSE SELL ORDERS. |
//| The Bid price is where we OPEN SELL Orders and CLOSE BUY ORDERS. |                                                                 
//+------------------------------------------------------------------+
#include <Charts/Chart.mqh>
#include "../include/Util.mqh"
#include "Global.mqh"
#include "Type.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TSModel
  {
private:
   CChart           *m_chart;
   ENUM_RISK_TYPE    m_risk_type;
   double            m_risk_percentage;
   double            m_lot_size;
   double            m_reward_to_risk;
   string            m_last_error;
   int               m_order_type;

   double            m_price;
   double            m_stop_loss;
   double            m_take_profit;

   void              DoNotifyChange(void);
   void              DoNotifyTradeChange(void);
public:
                     TSModel();
                    ~TSModel();
   CChart           *Chart(void);
   int               NumberOfDigits(void);

   ENUM_RISK_TYPE    RiskType(void);
   void              RiskType(ENUM_RISK_TYPE risk_type);
   double            RiskPercentage(void);
   bool              RiskPercentage(double risk_percentage);
   double            LotSize(void);
   bool              LotSize(double lot_size);
   double            RewardToRisk(void);
   bool              RewardToRisk(double reward_to_risk);
   void              _OrderType(int order_type);
   int               _OrderType(void);

   void              Init(TTradeWindow &settings);
   string            LastError(void);
   void              OnTick(void);

   double            Spread(void);
   double            Price(void);
   bool              Price(double price);
   double            StopLoss(void);
   bool              StopLoss(double stop_loss);
   double            TakeProfit(void);
   bool              TakeProfit(double take_profit);

   void              TradeDataChanged(void);
   void              RiskChanged(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TSModel::TSModel()
  {
   m_chart=new CChart();
   m_chart.Attach(0);
   m_chart.EventMouseMove();
   m_chart.Foreground(false);
   OnTick();
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
void TSModel::TradeDataChanged(void)
  {
// If price and stoploss is known the risk percentage and/of lotsize 
// can be calculated.
   if(m_price!=0 && m_stop_loss!=0)
     {
      double d_pips;
      int i_pips;

      //Caculate number of pips
      d_pips=m_price-m_stop_loss;
      if(d_pips<0) d_pips*=-1;
      i_pips=(int)MathFloor(d_pips/PipPoint(Symbol()));

      if(m_risk_type==RT_PERCENTAGE)
        {
         // Calculate LotSize
         m_lot_size=LotCalculator(Symbol(),m_risk_percentage,i_pips);
        }
      else if(m_risk_type==RT_LOT_SIZE)
        {
         // Calculate Risk Percentage
         m_risk_percentage=RiskCalculator(Symbol(),m_lot_size,i_pips);
        }

      // If m_take_profit is zero use reward to risk to calculate profit target
      if(m_take_profit==0)
        {
         switch(m_order_type)
           {
            case OP_BUY:
            case OP_BUYSTOP:
            case OP_BUYLIMIT:
               m_take_profit=m_price+d_pips*m_reward_to_risk;
               break;
            case OP_SELL:
            case OP_SELLSTOP:
            case OP_SELLLIMIT:
               m_take_profit=m_price-d_pips*m_reward_to_risk;
               break;
           }
        }
     }

// If price, stoploss and takeprofit is known the reward to risk
// can be calculated.
   if(m_price!=0 && m_stop_loss!=0 && m_take_profit!=0)
     {
      double numerator=m_take_profit-m_price;
      if(numerator<0) numerator*=-1;
      double denominator=m_stop_loss-m_price;
      if(denominator!=0) 
        {
         if(denominator<0) denominator*=-1;
         m_reward_to_risk=numerator/denominator;
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::RiskChanged(void)
  {
// If the price and stoploss is known the risk and/of lotsize can
// be calculated
   if(m_price!=0 && m_stop_loss!=0)
     {
      double d_pips;
      int i_pips;

      //Caculate number of pips
      d_pips=m_price-m_stop_loss;
      if(d_pips<0) d_pips*=-1;
      
      i_pips=(int)MathFloor(d_pips/PipPoint(Symbol()));

      if(m_risk_type==RT_PERCENTAGE)
        {
         // Calculate LotSize
         m_lot_size=LotCalculator(Symbol(),m_risk_percentage,i_pips);
        }
      else if(m_risk_type==RT_LOT_SIZE)
        {
         // Calculate Risk Percentage
         m_risk_percentage=RiskCalculator(Symbol(),m_lot_size,i_pips);
        }
      // If the price, stoploss and reward to risk is known 
      // the takeprofit can be calculated.
      if(m_reward_to_risk!=0)
        {
         switch(m_order_type)
           {
            case OP_BUY:
            case OP_BUYSTOP:
            case OP_BUYLIMIT:
               m_take_profit=m_price+d_pips*m_reward_to_risk;
               break;
            case OP_SELL:
            case OP_SELLSTOP:
            case OP_SELLLIMIT:
               m_take_profit=m_price-d_pips*m_reward_to_risk;
               break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::Spread(void)
  {
   return(Spread(Symbol()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::Price(void)
  {
   MqlTick tick;
   switch(m_order_type)
     {
      case OP_BUY:
      case OP_SELL:
         SymbolInfoTick(Symbol(),tick);
         // Get current price bid price
         m_price=tick.bid;
         break;
     }
   return(m_price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSModel::Price(double price)
  {
   m_last_error="";
   MqlTick tick;
   SymbolInfoTick(Symbol(),tick);
   switch(m_order_type)
     {
      case OP_BUY:
         // Check before order is placeed
         break;
      case OP_BUYSTOP:
         if(price<=tick.bid)
           {
            m_last_error="Price must be greater than Current price";
            return(false);
           }
         if(m_stop_loss!=0)
           {
            if(price<=m_stop_loss)
              {
               m_last_error="Price must be greater than Stop Loss";
               return(false);
              }
           }
         if(m_take_profit!=0)
           {
            if(price>=m_take_profit)
              {
               m_last_error="Price must be smaller than Take Profit";
               return(false);
              }
           }
         break;
      case OP_BUYLIMIT:
         if(price>=tick.bid)
           {
            m_last_error="Price must be smaller than Current price";
            return(false);
           }
         if(m_stop_loss!=0)
           {
            if(price<=m_stop_loss)
              {
               m_last_error="Price must be greater than Stop Loss";
               return(false);
              }
           }
         if(m_take_profit!=0)
           {
            if(price>=m_take_profit)
              {
               m_last_error="Price must be smaller than Take Profit";
               return(false);
              }
           }
         break;
      case OP_SELL:
         // Check before order is placeed
         break;
      case OP_SELLSTOP:
         if(price>=tick.bid)
           {
            m_last_error="Price must be smaller than Current price";
            return(false);
           }
         if(m_stop_loss!=0)
           {
            if(price>=m_stop_loss)
              {
               m_last_error="Price must be smaller than Stop Loss";
               return(false);
              }
           }
         if(m_take_profit!=0)
           {
            if(price<=m_take_profit)
              {
               m_last_error="Price must be greater than Take Profit";
               return(false);
              }
           }
         break;
      case OP_SELLLIMIT:
         if(price<=tick.bid)
           {
            m_last_error="Price must be greater than Current price";
            return(false);
           }
         if(m_stop_loss!=0)
           {
            if(price>=m_stop_loss)
              {
               m_last_error="Price must be smaller than Stop Loss";
               return(false);
              }
           }
         if(m_take_profit!=0)
           {
            if(price<=m_take_profit)
              {
               m_last_error="Price must be greater than Take Profit";
               return(false);
              }
           }
         break;
     }
   m_price=price;
   TradeDataChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::StopLoss(void)
  {
   return(m_stop_loss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSModel::StopLoss(double stop_loss)
  {
   m_last_error="";

   switch(m_order_type)
     {
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         if(m_take_profit!=0)
           {
            if(stop_loss>=m_take_profit)
              {
               m_last_error="Stop Loss must be smaller than Take Profit";
               return(false);
              }
           }
         if(m_price!=0)
           {
            if(stop_loss>=m_price)
              {
               m_last_error="Stop Loss must be smaller than Price";
               return(false);
              }
           }
         break;
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         if(m_take_profit!=0)
           {
            if(stop_loss<=m_take_profit)
              {
               m_last_error="Stop Loss must be greater than Take Profit";
               return(false);
              }
           }
         if(m_price!=0)
           {
            if(stop_loss<=m_price)
              {
               m_last_error="Stop Loss must be greater than Price";
               return(false);
              }
           }
         break;
     }

   m_stop_loss=stop_loss;
   TradeDataChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::TakeProfit(void)
  {
   return(m_take_profit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSModel::TakeProfit(double take_profit)
  {
   m_last_error="";

   switch(m_order_type)
     {
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
         if(m_stop_loss!=0)
           {
            if(take_profit<=m_stop_loss)
              {
               m_last_error="Take Profit must be greater than Stop Loss";
               return(false);
              }
           }
         if(m_price!=0)
           {
            if(take_profit<=m_price)
              {
               m_last_error="Take Profit must be greater than Price";
               return(false);
              }
           }
         break;
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
         if(m_stop_loss!=0)
           {
            if(take_profit>=m_stop_loss)
              {
               m_last_error="Take Profit must be smaller than Stop Loss";
               return(false);
              }
           }
         if(m_price!=0)
           {
            if(take_profit>=m_price)
              {
               m_last_error="Take Profit must be smaller than Price";
               return(false);
              }
           }
         break;
     }

   m_take_profit=take_profit;
   TradeDataChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::OnTick(void)
  {
   DoNotifyTradeChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TSModel::LastError(void)
  {
   return(m_last_error);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TSModel::_OrderType(void)
  {
   return(m_order_type);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::_OrderType(int order_type)
  {
// Check if order type is changed
   if(m_order_type == order_type) return;

   m_order_type=order_type;
// Reset trade values when changing order type
   m_price=0;
   m_stop_loss=0;
   m_take_profit=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::RiskPercentage(void)
  {
   return(m_risk_percentage);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSModel::RiskPercentage(double risk_percentage)
  {
   m_last_error="";
   if((risk_percentage<0.01) || (risk_percentage>100.00))
     {
      m_last_error="Make sure risk percentage is between 0.01% and 100%";
      return(false);
     }
   m_risk_percentage=risk_percentage;
   RiskChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::LotSize(void)
  {
   return(m_lot_size);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSModel::LotSize(double lot_size)
  {
   m_last_error="";
   if(lot_size<0.01)
     {
      m_last_error="Lot size must be greater or equal than 0.01";
      return(false);
     }
   m_lot_size=lot_size;
   RiskChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TSModel::RewardToRisk(void)
  {
   return(m_reward_to_risk);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TSModel::RewardToRisk(double reward_to_risk)
  {
   m_last_error="";
   if(reward_to_risk<1.00)
     {
      m_last_error="Reward to Risk must be greater or equal than 1";
      return(false);
     }
   m_reward_to_risk=reward_to_risk;
   RiskChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::Init(TTradeWindow &settings)
  {
   m_risk_type=settings.risk_type;
   m_risk_percentage=settings.risk_percentage;
   m_lot_size=settings.lot_size;
   m_reward_to_risk=settings.reward_to_risk;
   m_order_type=settings.order_type;

   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::DoNotifyChange(void)
  {
   string sparam="TRADE_STATION_MODEL_CHANGED";
   EventChartCustom(0,TRADE_STATION_MODEL_CHANGED,0,0,sparam);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::DoNotifyTradeChange(void)
  {
   string sparam="TRADE_STATION_MODEL_TRADE_CHANGED";
   EventChartCustom(0,TRADE_STATION_MODEL_TRADE_CHANGED,0,0,sparam);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_RISK_TYPE TSModel::RiskType(void)
  {
   return(m_risk_type);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TSModel::RiskType(ENUM_RISK_TYPE risk_type)
  {
   m_risk_type=risk_type;
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChart *TSModel::Chart(void)
  {
   return m_chart;
  }
//+------------------------------------------------------------------+
int TSModel::NumberOfDigits(void)
  {
   return((int)MarketInfo(Symbol(),MODE_DIGITS));
  }
//+------------------------------------------------------------------+
