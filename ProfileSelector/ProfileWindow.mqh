//+------------------------------------------------------------------+
//|                                                ProfileWindow.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include "../WinCtrl/Global.mqh"
#include "../WinCtrl/Type.mqh"
#include "../WinCtrl/PositionManager.mqh"
#include "../WinCtrl/Window.mqh"
#include "../WinCtrl/Label.mqh"
#include "../WinCtrl/Button.mqh"
#include "../WinCtrl/WinUtil.mqh"
#include "../Include/WinLib.mqh"
#include "ProfileSetting.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ProfileWindow : public Window
  {
private:
   TProfile          profiles[];
   ProfileSetting    settings;
protected:
   Button           *m_Buttons[];
   Button           *m_Trade_System_Button;
   void              Init(void);
   void              GenerateButtons(void);
   void              SetState(void);
   void              UpdateButtons(void);
   void              GetProfiles(string prefix);
   int               GetProfileIndex(string currency);
public:
                     ProfileWindow(const string name="Window",
                                                     const int x=10,
                                                     const int y=20,
                                                     const int width=200,
                                                     const int height=100);
                    ~ProfileWindow();

   void              OnChartEvent(const int id,
                                  const long &lparam,
                                  const double &dparam,
                                  const string &sparam);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProfileWindow::SetState(void)
  {
   for(int i=0; i<ArraySize(m_Buttons); i++)
     {
      string currencylabel=CharArrayToString(settings.values.currencyLabel);
      int len=StringLen(currencylabel);

      if(len == 0) return;
      string test=StringSubstr(m_Buttons[i].GetName(),StringLen(m_Buttons[i].GetName())-len);

      int position=StringFind(currencylabel,"_",0);

      if(test==CharArrayToString(settings.values.currencyLabel))
        {
         SetButtonState(m_Buttons[i],true);
        }
      else
        {
         SetButtonState(m_Buttons[i],false);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProfileWindow::GetProfiles(string prefix)
  {
   string arr[];
   ArrayFree(profiles);

   GetFileList(TerminalInfoString(TERMINAL_DATA_PATH)+"\\profiles\\*",arr);
   for(int i=0; i<ArraySize(arr); i++)
     {
      if(StringFind(arr[i],prefix)!=-1)
        {
         int size=ArraySize(profiles);
         ArrayResize(profiles,size+1);
         profiles[size].index=i;
         profiles[size].name=StringSubstr(arr[i],StringLen(prefix));
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ProfileWindow::GetProfileIndex(string currency)
  {
   for(int i=0; i<ArraySize(profiles); i++)
     {
      if(profiles[i].name==currency) return profiles[i].index;
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProfileWindow::Init(void)
  {
   switch(settings.values.profile_type)
     {
      case PT_FAILED_BREAKOUT:
         GetProfiles("FX_");
         break;
      case PT_4HOUR_INTRADAY:
         GetProfiles("FX4H_");
         break;
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProfileWindow::GenerateButtons(void)
  {
   Init();

   CRect dim;
   dim.left=dim.top=dim.right=dim.bottom=0;
   CPositionManager m;
   m.LayoutWidth(GetClientWidth());
   m.Offset(GetClientX(),GetClientY());

   m.Spacing(5, 5);
   m.ControlHeight(24);
   int row=0;

   m.Columns(5);

   int col_count=0;
   ArrayResize(m_Buttons,ArraySize(profiles));

   for(int i=0; i<ArraySize(profiles); i++)
     {
      dim=m.Rect(row,col_count);
      m_Buttons[i]=CreateButton(m_name+profiles[i].name,dim);
      m_Buttons[i].SetText(profiles[i].name);
      AddChild(m_Buttons[i]);

      col_count++;
      if(col_count==5)
        {
         col_count=0;
         row++;
        }
     }

   row++;
   m.Columns(1);
   dim=m.Rect(row,0);
   m_Trade_System_Button=CreateButton(m_name+"m_Trade_System_Button",dim);

   m_Trade_System_Button.SetText((settings.values.profile_type==PT_FAILED_BREAKOUT) ? "Failed Breakout System" : "4 Hour Intraday System");
   SetButtonState(m_Trade_System_Button,clrWhite,clrBlack,false);
   AddChild(m_Trade_System_Button);

   SetClientHeight(dim.bottom-GetClientY()+5);
   SetState();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ProfileWindow::ProfileWindow(const string name,
                             const int x,
                             const int y,
                             const int width,
                             const int height):Window(name,x,y,width,height)
  {
   GenerateButtons();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ProfileWindow::~ProfileWindow()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProfileWindow::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_OBJECT_CLICK :
         if(!StringCompare(m_name+"m_Trade_System_Button",sparam))
           {
            switch(settings.values.profile_type)
              {
               case PT_FAILED_BREAKOUT:
                  settings.values.profile_type=PT_4HOUR_INTRADAY;
                  GetProfiles("FX4H_");
                  break;
               case PT_4HOUR_INTRADAY:
                  settings.values.profile_type=PT_FAILED_BREAKOUT;
                  GetProfiles("FX_");
                  break;
              }

            PostMainWindowMessage(WM_COMMAND,34100+GetProfileIndex(CharArrayToString(settings.values.currencyLabel))-2,0);
           }
         else
           {
            for(int i=0; i<ArraySize(profiles); i++)
              {
               if(!StringCompare(m_name+profiles[i].name,sparam))
                 {
                  StringToCharArray(profiles[i].name,settings.values.currencyLabel);
                  //PrintFormat("[%s]  id[%d]",profiles[i].name,profiles[i].index);
                  // Index-2 is minus the \. and \.. files ???
                  PostMainWindowMessage(WM_COMMAND,34100+profiles[i].index-2,0);
                 }
              }
           }
         break;

     }
   Window::OnChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
