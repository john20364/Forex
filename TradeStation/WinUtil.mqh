//+------------------------------------------------------------------+
//|                                                      WinUtil.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Controls\Rect.mqh>
#include "Label.mqh"
#include "Button.mqh"
#include "Edit.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Label *CreateLabel(string name,CRect &rect)
  {
   return(new Label(name, rect.left, rect.top, rect.Width(), rect.Height()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Label *CreateParagraph(string name,CRect &rect) 
  {
   Label *label = CreateLabel(name,rect);
   label.SetTextAlignment(ALIGN_CENTER);
   label.SetColor(clrYellow);
   label.SetBackColor(clrBlack);
   label.SetBorderColor(clrBlack);

   return(label);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Button *CreateButton(string name,CRect &rect)
  {
   return(new Button(name, rect.left, rect.top, rect.Width(), rect.Height()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Edit *CreateEdit(string name,CRect &rect)
  {
   return(new Edit(name, rect.left, rect.top, rect.Width(), rect.Height()));
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetButtonState(Button *button,color bgcolor,color fgcolor,bool state)
  {
   switch(state)
     {
      case true:
         button.SetBackColor(fgcolor);
         button.SetColor(bgcolor);
         break;
      case false :
         button.SetBackColor(bgcolor);
         button.SetColor(fgcolor);
         break;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetButtonState(Button *button,bool state)
  {
   switch(state)
     {
      case true:
         button.SetBackColor(clrLime);
         button.SetColor(clrBlack);
         break;
      case false :
         button.SetBackColor(clrRed);
         button.SetColor(clrWhite);
         break;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetEditState(Edit *edit,bool state)
  {
   switch(state)
     {
      case true:
         edit.SetColor(clrLime);
         edit.SetBorderColor(clrLime);
         edit.SetReadOnly(false);
         break;
      case false:
         edit.SetColor(clrOrange);
         edit.SetBorderColor(clrOrange);
         edit.SetReadOnly(true);
         break;
     }
  }
  
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
