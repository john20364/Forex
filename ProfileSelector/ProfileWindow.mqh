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
#include "../Include/Util.mqh"
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
   Button           *m_Tag_Button;
   Button           *m_Clear_Button;
   void              Init(void);
   void              GenerateButtons(void);
   void              SetState(void);
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
   string currencylabel=CharArrayToString(settings.values.currencyLabel);
   int len=StringLen(currencylabel);
   if(len == 0) return;

   string tagstr=CharArrayToString(settings.values.tags);

   for(int i=0; i<ArraySize(m_Buttons); i++)
     {
      if(m_Buttons[i].Text()==currencylabel)
        {
         if(StringFind(tagstr,m_Buttons[i].Text())!=-1)
           {
            SetButtonState(m_Buttons[i],clrBlack,clrAquamarine,true);
           }
         else
           {
            SetButtonState(m_Buttons[i],clrBlack,clrLime,true);
           }
        }
      else
        {
         if(StringFind(tagstr,m_Buttons[i].Text())!=-1)
           {
            SetButtonState(m_Buttons[i],clrBlue,clrWhite,false);
           }
         else
           {
            SetButtonState(m_Buttons[i],clrRed,clrWhite,false);
           }
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

      //m_Buttons[i].SetFont("Trebuchet MS bold");
      //m_Buttons[i].SetFont(DEFAULT_FONT_NAME);

      AddChild(m_Buttons[i]);

      col_count++;
      if(col_count==5)
        {
         col_count=0;
         row++;
        }
     }

   row++;
   m.Columns(4);
   dim=m.Rect(row,0);
   dim.right=m.Rect(row,1).right;
   m_Trade_System_Button=CreateButton(m_name+"m_Trade_System_Button",dim);

   m_Trade_System_Button.SetText((settings.values.profile_type==PT_FAILED_BREAKOUT) ? "Failed Breakout System" : "4 Hour Intraday System");
   SetButtonState(m_Trade_System_Button,clrWhite,clrBlack,false);
   AddChild(m_Trade_System_Button);

   dim=m.Rect(row,2);
   m_Tag_Button=CreateButton(m_name+"m_Tag_Button",dim);
   m_Tag_Button.SetText("Tag Toggle");
   SetButtonState(m_Tag_Button,clrWhite,clrBlack,false);
   AddChild(m_Tag_Button);

   dim=m.Rect(row,3);
   m_Clear_Button=CreateButton(m_name+"m_Clear_Button",dim);
   m_Clear_Button.SetText("Clear Tags");
   SetButtonState(m_Clear_Button,clrWhite,clrBlack,false);
   AddChild(m_Clear_Button);

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
         else if(!StringCompare(m_name+"m_Tag_Button",sparam))
           {
            string tagstr=CharArrayToString(settings.values.tags);
            string currency=CharArrayToString(settings.values.currencyLabel);
            string tagarray[];
            int len=SeparatedTextToStringArray(tagstr,",",tagarray);
            bool found=false;

            // Try to find if currency is already in the tagarray
            for(int i=0; i<len; i++)
              {
               if(tagarray[i]==currency)
                 {
                  found=true;
                 }
              }

            // Remove if found else add
            if(found)
              {
               string tmp;
               for(int i=0; i<len; i++)
                 {
                  if(tagarray[i]!=currency)
                    {
                     StringAdd(tmp,tagarray[i]);
                     StringAdd(tmp,",");
                    }
                 }
               if(StringLen(tmp)>0)
                 {
                  StringSetLength(tmp,StringLen(tmp)-1);
                 }
               tagstr=tmp;
              }
            else
              {
               if(StringLen(tagstr)==0)
                 {
                  StringAdd(tagstr,currency);
                 }
               else
                 {
                  StringAdd(tagstr,",");
                  StringAdd(tagstr,currency);
                 }
              }

            ArrayFill(settings.values.tags,0,512,0);
            if(StringLen(tagstr)!=0)
              {
               StringToCharArray(tagstr,settings.values.tags);
              }
            SetState();
            Redraw();
            //PrintFormat("tagstr [%s]", tagstr);

           }
         else if(!StringCompare(m_name+"m_Clear_Button",sparam))
           {
            ArrayFill(settings.values.tags,0,512,0);
            SetState();
            Redraw();
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
