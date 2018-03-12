//+------------------------------------------------------------------+
//|                                                       Window.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Global.mqh"
#include  "Type.mqh"
#include "BaseWindow.mqh"
#include "Label.mqh"
#include "WinCollection.mqh"
#include "TSModel.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Window:public Base
  {
private:
   WinCollection     children;
protected:
   int               m_x;
   int               m_y;
   int               m_width;
   int               m_height;
   BaseWindow       *m_win_title;
   BaseWindow       *m_win_client;
   bool              m_client_visible;
   Label            *m_caption_label;

public:
                     Window(const string name="Window",
                                              const int x=10,
                                              const int y=20,
                                              const int width=200,
                                              const int height=100);
                    ~Window();
   void              OnChartEvent(const int id,
                                  const long &lparam,
                                  const double &dparam,
                                  const string &sparam);
   void              OnCaptionClick(void);
   void              OnClientClick(void);

   int               GetClientX(void);
   int               GetClientY(void);
   int               GetClientWidth(void);
   int               GetClientHeight(void);
   void              SetClientHeight(int height);

   void              OnClick(void *ptr);
   void              AddChild(BaseWindow *child);
   void              Minimize(void);
   void              Maximize(void);
   bool              IsMaximized(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Window::Window(const string name,
               const int x,
               const int y,
               const int width,
               const int height)
  {
   m_client_visible=true;
   m_name=name;
   m_x=x;
   m_y=y;
   m_width=width;
   m_height=height;

   m_win_title=new BaseWindow(m_name+"Title",m_x,m_y,m_width,m_height);

   m_win_title.SetHeight(DEFAULT_CAPTION_HEIGHT);
   m_win_title.SetBackColor(DEFAULT_CAPTION_BACKGROUND_COLOR);
   m_win_title.SetColor(DEFAULT_CAPTION_BACKGROUND_COLOR);
   m_win_title.SetBorderColor(clrNONE);

   m_caption_label=new Label(m_name+"Caption",m_x,m_y,m_width,DEFAULT_CAPTION_HEIGHT);
   m_caption_label.SetBackColor(DEFAULT_CAPTION_BACKGROUND_COLOR);
   m_caption_label.SetBorderColor(DEFAULT_CAPTION_BACKGROUND_COLOR);
   m_caption_label.SetColor(DEFAULT_CAPTION_COLOR);
   m_caption_label.SetText(m_name);

   m_win_client=new BaseWindow(m_name+"Client",m_x,m_y,m_width,m_height);
   m_win_client.SetY(m_y+DEFAULT_CAPTION_HEIGHT);

   m_win_client.SetBackColor(clrBlack);
   m_win_client.SetColor(clrBlack);
   m_win_client.SetBorderColor(clrNONE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Window::~Window()
  {
   children.Empty(true);
   delete(m_win_client);
   delete(m_caption_label);
   delete(m_win_title);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Window::Minimize(void)
  {
   PrintFormat("void Window::Minimize(void)");
   m_client_visible=false;
   BaseWindow *w=children.GetFirst();
   while(w)
     {
      w.HideWindow();
      w=children.GetNext();
     }
   m_win_client.HideWindow();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Window::Maximize(void)
  {
   m_client_visible=true;
   m_win_client.ShowWindow();
   BaseWindow *w=children.GetFirst();
   while(w)
     {
      w.ShowWindow();
      w=children.GetNext();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Window::IsMaximized(void)
  {
   return(m_client_visible);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Window::AddChild(BaseWindow *child)
  {
   children.Add(child);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Window::OnClick(void *ptr)
  {
   PrintFormat("void Window::OnClick(void *ptr) ");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Window::GetClientX(void)
  {
   return(m_win_client.GetX());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Window::GetClientY(void)
  {
   return(m_win_client.GetY());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Window::GetClientWidth(void)
  {
   return(m_win_client.GetWidth());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Window::SetClientHeight(int height)
  {
   m_win_client.SetHeight(height);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Window::GetClientHeight(void)
  {
   return(m_win_client.GetHeight());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Window::OnCaptionClick(void)
  {
//Toggle Visibility Client Area
   m_client_visible=!m_client_visible;
   if(!m_client_visible)
     {
      Minimize();
     }
   else
     {
      Maximize();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Window::OnClientClick(void)
  {
//Print("void Window::OnClientClick(void)");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Window::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   switch(id)
     {
      case CHARTEVENT_OBJECT_CLICK:
         if(!StringCompare(m_name+"Caption",sparam))
           {
            //PrintFormat("CAPTION: [%s]",sparam);
            OnCaptionClick();
           }
         else if(!StringCompare(m_name+"Client",sparam))
           {
            //PrintFormat("CLIENT: [%s]",sparam);
            OnClientClick();
           }
         break;
     }
  }
//+------------------------------------------------------------------+
