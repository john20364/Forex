#ifndef __WINLIB_MQH__
#define __WINLIB_MQH__
//+------------------------------------------------------------------+
//|                                                       WinLib.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#import "Projects/WinLib/WinLib.ex4"

bool GetFileList(string path,string &strarr[]);

int PostMainWindowMessage(int Msg, int wParam, int lParam);

#import

#endif // __WINLIB_MQH__
