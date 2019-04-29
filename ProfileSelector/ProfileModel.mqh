//+------------------------------------------------------------------+
//|                                                 ProfileModel.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ProfileModel
  {
private:
   //long              search_handle;

public:
                     ProfileModel();
                    ~ProfileModel();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ProfileModel::ProfileModel()
  {
//   string profiles_dir=TerminalInfoString(TERMINAL_DATA_PATH)+"\\.";
//   string filename;
//   search_handle=FileFindFirst(profiles_dir,filename, FILE_COMMON);
//
//   if(search_handle!=INVALID_HANDLE)
//     {
//      Print(filename);
//     }
//   else 
//     {
//      Print("OOPS " + profiles_dir);
//     }
//   search_handle=FileFindFirst(profiles_dir,filename);
//   if(search_handle!=INVALID_HANDLE)
//     {
//      Print(filename);
//     }
//   else 
//     {
//      Print("OOPS2 " + profiles_dir);
//     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ProfileModel::~ProfileModel()
  {
  }
//+------------------------------------------------------------------+
