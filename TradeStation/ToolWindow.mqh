//+------------------------------------------------------------------+
//|                                                   ToolWindow.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Charts/Chart.mqh>
#include "Global.mqh"
#include "PositionManager.mqh"
#include "Window.mqh"
#include "Label.mqh"
#include "Button.mqh"
#include "WinUtil.mqh"
#include "ToolSetting.mqh"
#include "ToolModel.mqh"

string PeriodText[9]={"M1","M5","M15","M30","H1","H4","D1","W1","MN"};

class ToolWindow;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ToolWindow : public Window
  {
private:
   ToolModel        *m_model;
   ToolSetting       setting;
   void              ReadSettings(void);
   void              WriteSettings(void);
protected:
   Label            *m_broadcast_label;
   Button           *m_sync_button;
   Button           *m_scale_fix_button;
   Button           *m_chart_scroll_button;
   Button           *m_chart_shift_button;

   Label            *m_period_paragraph;
   Button           *m_period_buttons[9];
public:
                     ToolWindow(const string name="Window",
                                                  const int x=10,
                                                  const int y=20,
                                                  const int width=200,
                                                  const int height=100);
                    ~ToolWindow();
   void              OnChartEvent(const int id,
                                  const long &lparam,
                                  const double &dparam,
                                  const string &sparam);

   void              Attach(ToolModel *model);
   void              UpdateState(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolWindow::ToolWindow(const string name,
                       const int x,
                       const int y,
                       const int width,
                       const int height):Window(name,x,y,width,height)
  {
   CRect dim;
   CPositionManager m;
   m.LayoutWidth(GetClientWidth());
   m.Offset(GetClientX(),GetClientY());

   m.Spacing(5, 5);
   m.ControlHeight(25);
   int row=0;

   m.Columns(4);

   dim=m.Rect(row,0);
   dim.right=m.Rect(row,2).right;

   m_broadcast_label=CreateLabel(m_name+"m_broadcast_label",dim);
   m_broadcast_label.SetText("Synchronize charts");
   AddChild(m_broadcast_label);

   dim=m.Rect(row,3);
   m_sync_button=CreateButton(m_name+"m_sync_button",dim);
   m_sync_button.SetText("Sync");
   SetButtonState(m_sync_button,clrBlue,clrWhite,false);
   AddChild(m_sync_button);

   row++;
   m.Columns(3);
   dim=m.Rect(row,0);
   m_scale_fix_button=CreateButton(m_name+"m_scale_fix_button",dim);
   m_scale_fix_button.SetText("Scale fix");
   AddChild(m_scale_fix_button);

   dim=m.Rect(row,1);
   m_chart_scroll_button=CreateButton(m_name+"m_chart_scroll_button",dim);
   m_chart_scroll_button.SetText("Chart scroll");
   AddChild(m_chart_scroll_button);

   dim=m.Rect(row,2);
   m_chart_shift_button=CreateButton(m_name+"m_chart_shift_button",dim);
   m_chart_shift_button.SetText("Chart shift");
   AddChild(m_chart_shift_button);

   row++;
   m.Columns(1);
   dim=m.Rect(row,0);
   m_period_paragraph=CreateParagraph(m_name+"m_period_paragraph",dim);
   m_period_paragraph.SetText("Period");
   AddChild(m_period_paragraph);

// Create 9 Period Buttons
   row++;
   m.Columns(9);
   for(int i=0;i<9;i++)
     {
      dim=m.Rect(row,i);
      m_period_buttons[i]=CreateButton(m_name+"m_period_buttons"+IntegerToString(i),dim);
      AddChild(m_period_buttons[i]);
      m_period_buttons[i].SetFontSize(8);
      m_period_buttons[i].SetText(PeriodText[i]);
     }

   SetClientHeight(dim.bottom-GetClientY()+5);
   ReadSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ToolWindow::~ToolWindow()
  {
   WriteSettings();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::Attach(ToolModel *model)
  {
   m_model=model;
   m_model.Init(setting.values);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::ReadSettings(void)
  {
   if(setting.values.maximized)
     {
      Maximize();
     }
   else
     {
      Minimize();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::WriteSettings(void)
  {
   setting.values.maximized=IsMaximized();
   setting.values.scale_fix=m_model.ScaleFix();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::UpdateState(void)
  {
   SetButtonState(m_scale_fix_button,m_model.ScaleFix());
   SetButtonState(m_chart_scroll_button,m_model.ChartScroll());
   SetButtonState(m_chart_shift_button,m_model.ChartShift());

   for(int i=0;i<ArraySize(m_period_buttons);i++)
     {
      SetButtonState(m_period_buttons[i],(m_model.PeriodIndex()==i) ? true : false);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolWindow::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_CUSTOM+VISUAL_TOOL_ACTIVATED:
         Redraw();
         break;
      case CHARTEVENT_CUSTOM+WINDOW_ENTER:
         if(!StringCompare(m_name+"m_sync_button",sparam))
           {
            m_sync_button.SetFont("Trebuchet MS bold");
           }
         break;
      case CHARTEVENT_CUSTOM+WINDOW_LEAVE:
         if(!StringCompare(m_name+"m_sync_button",sparam))
           {
            m_sync_button.SetFont(DEFAULT_FONT_NAME);
           }
         break;
      case CHARTEVENT_CUSTOM+WINDOW_BUTTON_PRESSED:
         if(!StringCompare(m_name+"m_sync_button",sparam))
           {
            SetButtonState(m_sync_button,clrBlue,clrWhite,true);
           }
         break;
      case CHARTEVENT_CUSTOM+WINDOW_BUTTON_RELEASED:
         if(!StringCompare(m_name+"m_sync_button",sparam))
           {
            SetButtonState(m_sync_button,clrBlue,clrWhite,false);
           }
      case CHARTEVENT_CUSTOM+WINDOW_CLICK:
         if(!StringCompare(m_name+"m_sync_button",sparam))
           {
            m_model.SynchronizeCharts();
           }
         break;
      case CHARTEVENT_MOUSE_MOVE:
         m_sync_button.MouseMove((int)lparam,(int)dparam,(((uint)sparam) &1)==1);
         break;
      case CHARTEVENT_CHART_CHANGE:
         m_model.DoNotifyChange();
         break;
      case CHARTEVENT_CUSTOM+TOOL_MODEL_CHANGED:
         UpdateState();
         break;
      case CHARTEVENT_OBJECT_CLICK :
         if(!StringCompare(m_name+"m_sync_button",sparam))
           {
            //m_model.SynchronizeCharts();
           }
         else if(!StringCompare(m_name+"m_scale_fix_button",sparam))
           {
            m_model.ScaleFix(!m_model.ScaleFix());
           }
         else if(!StringCompare(m_name+"m_chart_scroll_button",sparam))
           {
            m_model.ChartScroll(!m_model.ChartScroll());
           }
         else if(!StringCompare(m_name+"m_chart_shift_button",sparam))
           {
            m_model.ChartShift(!m_model.ChartShift());
           }
         else
           {
            for(int i=0; i<ArraySize(m_period_buttons);i++)
              {
               if(!StringCompare(m_name+"m_period_buttons"+IntegerToString(i),sparam))
                 {
                  m_model.PeriodIndex(i);
                 }
              }
           }
         break;
     }
   Window::OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
