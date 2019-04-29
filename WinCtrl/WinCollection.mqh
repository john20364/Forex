//+------------------------------------------------------------------+
//|                                                WinCollection.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "BaseWindow.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class WinNode
  {
public:
   BaseWindow       *node;
   WinNode          *next;
   WinNode          *prev;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class WinCollection
  {
private:
   WinNode          *collection;
   WinNode          *current;
public:
   void              Add(BaseWindow *node);
   void              Remove(BaseWindow *node,bool del=false);
   void              Empty(bool del=false);
   void              PrintCollection(void);
                     WinCollection();
                    ~WinCollection();
   BaseWindow       *GetFirst(void);
   BaseWindow       *GetNext(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WinCollection::WinCollection()
  {
   collection=NULL;
   current=NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
WinCollection::~WinCollection()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WinCollection::Add(BaseWindow *node)
  {
   WinNode *p=collection;
   if(!collection)
     {
      collection=new WinNode();
      collection.node=node;
      collection.next=NULL;
      collection.prev=NULL;
     }
   else
     {
      while(p.next) p=p.next;
      p.next=new WinNode();
      p.next.prev= p;
      p.next.next=NULL;
      p.next.node=node;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WinCollection::PrintCollection(void)
  {
   WinNode *q,*p=collection;
   while(p)
     {
      q=p;
      PrintFormat("NEXT -> PrintCollection: [%s]",p.node.GetName());
      p=p.next;
     }

   while(q)
     {
      PrintFormat("PREV <- PrintCollection: [%s]",q.node.GetName());
      q=q.prev;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WinCollection::Remove(BaseWindow *node,bool del=false)
  {
   WinNode *p=collection;
   while(p)
     {

      if(p.node==node)
        {
         if(p==collection)
           {
            collection=p.next;
            if(p.next) p.next.prev=collection;
            //PrintFormat("REMOVE PrintCollection: [%s]",p.node.GetName());
            if(del) delete(p.node);
            delete(p);
            p=NULL;
           }
         else
           {
            if(p.prev) p.prev.next=p.next;
            if(p.next) p.next.prev=p.prev;
            //PrintFormat("REMOVE PrintCollection: [%s]",p.node.GetName());
            if(del) delete(p.node);
            delete(p);
            p=NULL;
           }
        }
      else
        {
         p=p.next;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WinCollection::Empty(bool del=false)
  {
   WinNode *q,*p=collection;
   while(p)
     {
      q=p;
      p=p.next;
      //PrintFormat("EMPTY PrintCollection: [%s]",q.node.GetName());
      if(del) delete(q.node);
      delete(q);
     }
   collection=NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseWindow *WinCollection::GetFirst(void)
  {
   current=collection;
   if(current) return(current.node);
   return(NULL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseWindow *WinCollection::GetNext(void)
  {
   if(current)
     {
      current=current.next;
      if(current) return(current.node);
      return(NULL);
     }
   return(NULL);
  }
//+------------------------------------------------------------------+
