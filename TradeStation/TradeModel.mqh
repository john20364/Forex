//+------------------------------------------------------------------+
//|                                                   TradeModel.mqh |
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
#include <stdlib.mqh>
#include <Charts/Chart.mqh>
#include "../include/Util.mqh"
#include "Global.mqh"
#include "Type.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeModel
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

   bool              m_on_tick_active;

   void              DoNotifyChange(void);
   void              DoNotifyTradeChange(void);

   double            FilterDouble(double value);
   string            PeriodName(void);

public:
                     TradeModel();
                    ~TradeModel();
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
   void              OnTickActive(bool active);

   bool              CanPlaceOrder(void);
   bool              PlaceOrder(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeModel::TradeModel()
  {
   m_chart=new CChart();
   m_chart.Attach(0);
   m_chart.EventMouseMove();
   m_chart.Foreground(false);
   m_on_tick_active=true;
   OnTick();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeModel::~TradeModel()
  {
   m_chart.Detach();
   delete(m_chart);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeModel::FilterDouble(double value)
  {
   return(StringToDouble(DoubleToString(value,NumberOfDigits())));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::TradeDataChanged(void)
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

//DoNotifyTradeChange();
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::RiskChanged(void)
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
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeModel::Spread(void)
  {
   return(Spread(Symbol()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeModel::Price(void)
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
bool TradeModel::CanPlaceOrder(void)
  {
   if(m_price<=0 || m_stop_loss<=0 || m_take_profit<=0)
     {
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TradeModel::PeriodName(void)
  {
   string name="";

   switch(Period())
     {
      case 1:     // 1 Minute
         name="1 Minute";
         break;
      case 5:     // 5 Minutes
         name="5 Minutes";
         break;
      case 15:    // 15 Minutes
         name="15 Minutes";
         break;
      case 30:    // 30 Minutes
         name="30 Minutes";
         break;
      case 60:    // 60 Minutes
         name="60 Minutes";
         break;
      case 240:   // 4 Hours
         name="4 Hours";
         break;
      case 1440:  // 1 Day
         name="Daily";
         break;
      case 10080: // 1 Week
         name="Weekly";
         break;
      case 43200: // 1 Month
         name="Montly";
         break;
      default:
         name="Unknown Periode";
     }
   return(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::PlaceOrder(void)
  {
//+------------------------------------------------------------------+
//| The Ask price is where we OPEN BUY ORDERS and CLOSE SELL ORDERS. |
//| The Bid price is where we OPEN SELL Orders and CLOSE BUY ORDERS. |                                                                 
//+------------------------------------------------------------------+

   m_last_error="";
   int order_id=-1;

   switch(m_order_type)
     {
      case OP_BUY:
         order_id=OrderSend(Symbol(),m_order_type,m_lot_size,Ask,0,m_stop_loss,m_take_profit,StringFormat("%s Buy order",PeriodName()));
         break;
      case OP_SELL:
         order_id=OrderSend(Symbol(),m_order_type,m_lot_size,Bid,0,m_stop_loss,m_take_profit,StringFormat("%s Sell order", PeriodName()));
         break;
      case OP_BUYLIMIT:
         order_id=OrderSend(Symbol(),m_order_type,m_lot_size,m_price,0,m_stop_loss,m_take_profit,StringFormat("%s Buy limit order", PeriodName()));
         break;
      case OP_BUYSTOP:
         order_id=OrderSend(Symbol(),m_order_type,m_lot_size,m_price,0,m_stop_loss,m_take_profit,StringFormat("%s Buy stop order", PeriodName()));
         break;
      case OP_SELLLIMIT:
         order_id=OrderSend(Symbol(),m_order_type,m_lot_size,m_price,0,m_stop_loss,m_take_profit,StringFormat("%s Sell limit order", PeriodName()));
         break;
      case OP_SELLSTOP:
         order_id=OrderSend(Symbol(),m_order_type,m_lot_size,m_price,0,m_stop_loss,m_take_profit,StringFormat("%s Sell stop order", PeriodName()));
         break;
     }

   if(order_id==-1)
     {
      int Errorcode=GetLastError();
      m_last_error=StringFormat("Errorcode [%d]: %s",Errorcode,ErrorDescription(Errorcode));
      return(false);
     }

   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::Price(double price)
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
   m_price=FilterDouble(price);
   TradeDataChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeModel::StopLoss(void)
  {
   return(m_stop_loss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::StopLoss(double stop_loss)
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

   m_stop_loss=FilterDouble(stop_loss);
   TradeDataChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeModel::TakeProfit(void)
  {
   return(m_take_profit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::TakeProfit(double take_profit)
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

   m_take_profit=FilterDouble(take_profit);
   TradeDataChanged();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::OnTickActive(bool active)
  {
   m_on_tick_active=active;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::OnTick(void)
  {
   if(m_on_tick_active)
     {
      DoNotifyTradeChange();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TradeModel::LastError(void)
  {
   return(m_last_error);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TradeModel::_OrderType(void)
  {
   return(m_order_type);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::_OrderType(int order_type)
  {
// Check if order type is changed
   if(m_order_type == order_type) return;

   m_order_type=order_type;
// Reset trade values when changing order type
   m_price=0;
   m_stop_loss=0;
   m_take_profit=0;
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TradeModel::RiskPercentage(void)
  {
   return(m_risk_percentage);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::RiskPercentage(double risk_percentage)
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
double TradeModel::LotSize(void)
  {
   return(m_lot_size);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::LotSize(double lot_size)
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
double TradeModel::RewardToRisk(void)
  {
   return(m_reward_to_risk);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeModel::RewardToRisk(double reward_to_risk)
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
void TradeModel::Init(TTradeWindow &settings)
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
void TradeModel::DoNotifyChange(void)
  {
   string sparam="TRADE_STATION_MODEL_CHANGED";
   EventChartCustom(0,TRADE_STATION_MODEL_CHANGED,0,0,sparam);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::DoNotifyTradeChange(void)
  {
   string sparam="TRADE_STATION_MODEL_TRADE_CHANGED";
   EventChartCustom(0,TRADE_STATION_MODEL_TRADE_CHANGED,0,0,sparam);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_RISK_TYPE TradeModel::RiskType(void)
  {
   return(m_risk_type);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModel::RiskType(ENUM_RISK_TYPE risk_type)
  {
   m_risk_type=risk_type;
   DoNotifyChange();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CChart *TradeModel::Chart(void)
  {
   return m_chart;
  }
//+------------------------------------------------------------------+
int TradeModel::NumberOfDigits(void)
  {
   return((int)MarketInfo(Symbol(),MODE_DIGITS));
  }
//+------------------------------------------------------------------+
