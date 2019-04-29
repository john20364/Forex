//+------------------------------------------------------------------+
//|                                                       WinLib.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <WinUser32.mqh>

#import "kernel32.dll"
int  FindFirstFileW(string path,int &answer[]);
bool FindNextFileW(int handle,int &answer[]);
bool FindClose(int handle);
#import

#import "user32.dll" 
int GetForegroundWindow();
#import

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string _GetFilenameFromData(int &data[])
  {
   short p[260];
   for(int i=0; i<80; i++)
     {
      int idx= i*2;
      p[idx] = data[11+i] & 0x0000FFFF;
      p[idx+1]=(data[11+i]>>16) &0x0000FFFF;
     }
   return ShortArrayToString(p,0,260);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetFileList(string path,string &strarr[]) export
  {

   int data[876];
   short filename[260];

   int handle=FindFirstFileW(path,data);

   if(handle>0)
     {
      int size=ArraySize(strarr);
      ArrayResize(strarr,size+1);
      strarr[size]=_GetFilenameFromData(data);
      ArrayInitialize(data,0);

      while(FindNextFileW(handle,data))
        {
         int size=ArraySize(strarr);
         ArrayResize(strarr,size+1);
         strarr[size]=_GetFilenameFromData(data);
         ArrayInitialize(data,0);
        }

      if(handle>0) FindClose(handle);
     }
   else
     {
      return false;
     }

   return true;
  }

int PostMainWindowMessage(int Msg, int wParam, int lParam) export
{
   int hmain=GetForegroundWindow();
   return PostMessageA(hmain,Msg, wParam, lParam);
}
//+------------------------------------------------------------------+
