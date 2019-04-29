//+------------------------------------------------------------------+
//|                                              PositionManager.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Controls\Rect.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionManager
  {
private:
   int               m_width;
   int               m_spacing_x;
   int               m_spacing_y;
   int               m_number_of_columns;
   int               m_control_height;
   int               m_offset_x;
   int               m_offset_y;

public:
                     CPositionManager(void);
                    ~CPositionManager(void);
   bool              LayoutWidth(int width=-1);
   bool              Spacing(int spacing_x=0, int spacing_y=0);
   bool              ControlHeight(int control_height=25);
   bool              Columns(int number_of_columns);
   bool              Offset(int offset_x=0, int offset_y=0);
   CRect             Rect(int row,int col);
protected:
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPositionManager::CPositionManager(void)
  {
   m_offset_x = 0;
   m_offset_y = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPositionManager::~CPositionManager(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionManager::LayoutWidth(int width=-1)
  {
   m_width=width;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionManager::Spacing(int spacing_x=0,int spacing_y=0)
  {
   m_spacing_x=spacing_x;
   m_spacing_y=spacing_y;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionManager::ControlHeight(int control_height=25)
  {
   m_control_height=control_height;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionManager::Columns(int number_of_columns)
  {
   m_number_of_columns=number_of_columns;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionManager::Offset(int offset_x=0, int offset_y=0) 
  {
   m_offset_x = offset_x;
   m_offset_y = offset_y;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRect CPositionManager::Rect(int row,int col)
  {
   CRect rect;
   int control_width=(int)MathRound((m_width -((m_number_of_columns+1)*m_spacing_x))/m_number_of_columns);

   rect.left=m_spacing_x+(m_spacing_x+control_width)*col;

// Line out to the right if it is the last column
   if(col==m_number_of_columns-1)
     {
      rect.right=m_width-m_spacing_x;
     }
   else
     {
      rect.right=rect.left+control_width;
     }

   rect.top=m_spacing_y+(m_control_height+m_spacing_y)*row;
   rect.bottom=rect.top+m_control_height;
   
   rect.left += m_offset_x;
   rect.right += m_offset_x;
   rect.top += m_offset_y;
   rect.bottom += m_offset_y;
   return rect;
  }
//+------------------------------------------------------------------+
