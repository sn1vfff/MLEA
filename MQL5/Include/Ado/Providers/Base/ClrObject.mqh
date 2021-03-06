//+------------------------------------------------------------------+
//|                                                    ClrObject.mqh |
//|                                             Copyright GF1D, 2010 |
//|                                             garf1eldhome@mail.ru |
//+------------------------------------------------------------------+
#property copyright "GF1D, 2010"
#property link      "garf1eldhome@mail.ru"

#include "..\..\AdoErrors.mqh"

//--------------------------------------------------------------------
#import "AdoSuite.dll"
long CreateManagedObject(const string,const string,string&,string&);
void DestroyManagedObject(const long,string&,string&);
#import
//--------------------------------------------------------------------
/// \brief  \~russian 吾牝 桉镱腠彘 耩邃?.NET.
///         \~english Represents CLR Object.
///
/// \~russian 杨溴疰栩 礤钺躅滂禧?戾蝾潲 潆 耦玟囗? ?箜梓蝾驽龛 箫疣怆屐 钺牝钼, 钺疣犷蜿?桉觌屙栝 镳?恹珙忮. 哜?弪? 徉珙恹?觌囫铎
/// \~english Includes neccessary methods for creating and disposing managed objects, exception handling. Abstract class
class CClrObject
  {
private:
   // variables
   bool              _IsCreated,_IsAssigned;
   long              _ClrHandle;
   string            _MqlTypeName;

protected:

   // properties

   /// \brief  \~russian 骂玮疣弪 桁 蜩镟, 觐蝾瘥?镳邃耱噔?弪 镳铊玮钿睇?觌囫?
   ///         \~english Gets type string of inherited class
   const string MqlTypeName() { return _MqlTypeName; }
   /// \brief  \~russian 玉蜞磬怆桠噱?桁 蜩镟, 觐蝾瘥?镳邃耱噔?弪 镳铊玮钿睇?觌囫?
   ///         \~english Sets type string of inherited class
   void MqlTypeName(const string value) { _MqlTypeName=value; }

   // methods

   /// \brief  \~russian 杨玟噱?钺牝 CLR 
   ///         \~english Creates CLR object
   /// \~russian \param  asmName   桁 襻铕觇. 锐镱朦珞弪? 觐痤蜿铄 桁 襻铕觇: System, System.Data ???
   /// \~english \param  asmName   short assembly name: System, System.Data etc
   /// \~russian \param  typeName  镱腠铄 桁 蜩镟: System.String, System.Data.DataTable ???
   /// \~english \param  typeName  full type name eg System.String, System.Data.DataTable etc
   void              CreateClrObject(const string asmName,const string typeName);
   /// \brief  \~russian 禹梓蝾驵弪 钺牝 CLR. 棱蝾爨蜩麇耜?恹琨忄弪? ?溴耱痼牝铕? 镱铎?忭?恹琨忄螯 礤 眢骓?
   ///         \~english Destroys CLR object. Called automatically in desctructor, so dont call it explictly!
   void              DestroyClrObject();

   // events

   /// \brief  \~russian 蔓琨忄弪? 镥疱?蝈?赅?钺牝 狍溴?耦玟囗. 妈痱筻朦睇?戾蝾?
   ///         \~english Called before object is being created. Virtual
   /// \~russian \param isCanceling  镥疱戾眄? bool, 镥疱溧?? 镱 c覃腙? 篷腓 篑蜞眍忤螯 珥圜屙桢 false, 蝾 耦玟囗桢 钺牝?狍溴?镱溧怆屙?
   /// \~english \param isCanceling  bool variable, passed by a reference. If set value to false, then object creation will be suppressed
   /// \~russian \param creating    true - 羼腓 钺牝 耦玟噱蝰, false - 羼腓 钺牝 镳桉忄桠噱蝰 麇疱?趔黻鲨?CClrObject::Assign
   /// \~english \param creating    when true indicates that object is creating, otherwise object is assigning using CClrObject::Assign
   virtual void OnObjectCreating(bool &isCanceling,bool creating=true) {}
   /// \brief  \~russian 蔓琨忄弪? 镱耠?蝾泐, 赅?Clr 钺牝 耦玟囗. 妈痱筻朦睇?戾蝾?
   ///         \~english Called after CLR object was created
   virtual void OnObjectCreated() {}
   /// \brief  \~russian 蔓琨忄弪? 镥疱?蝈? 赅?Clr 钺牝 狍溴?箜梓蝾驽? 妈痱筻朦睇?戾蝾?
   ///         \~english Called before object is being destroyed. Virtual
   virtual void OnObjectDestroying() {}
   /// \brief  \~russian 蔓琨忄弪? 镱耠?蝾泐, 赅?Clr 钺牝 箜梓蝾驽? 妈痱筻朦睇?戾蝾?
   ///         \~english Called after CLR object was destroyed
   virtual void OnObjectDestroyed() {}

   /// \brief  \~russian 蔓琨忄弪? ?耠篦噱 桉觌屙?(铠栳觇). 妈痱筻朦睇?戾蝾?
   ///         \~english Called when an exception occurs. Virtual
   /// \~russian \param method    桁 戾蝾溧, ?觐蝾痤?镳铊珙?桉觌屙桢
   /// \~english \param method    method name where the exception was thrown
   /// \~russian \param type      蜩?桉觌屙?. 吾眍 钿桧 桤 .NET 蜩镱?
   /// \~english \param type      exception type. Usually one of .NET types
   /// \~russian \param message   镱漯钺磬 桧纛痨圉? 钺 铠栳赍 
   /// \~english \param message   exception message. Describes error details
   /// \~russian \param mqlErr    铠栳赅 mql, 耦铗忮蝰蜮簋 溧眄铎?桉觌屙棹. 项 箪铍鬣龛?ADOERR_FIRST  
   /// \~english \param mqlErr    appropriate mql error equivalent. ADOERR_FIRST by default
   virtual void      OnClrException(const string method,const string type,const string message,const ushort mqlErr);

public:
   /// \brief  \~russian 觐眈蝠箨蝾?觌囫襦
   ///         \~english constructor
                     CClrObject() { _MqlTypeName="CClrObject"; }
   /// \brief  \~russian 溴耱痼牝铕 觌囫襦
   ///         \~english destructor
                    ~CClrObject() { DestroyClrObject(); }

   // properties

   /// \brief  \~russian 骂玮疣弪 箨噻囹咫?磬 GCHandle, 耦溴疰帙栝 钺牝
   ///         \~english Returns pointer for GCHandle, catching the object
   const long ClrHandle() { return _ClrHandle; }
   /// \brief  \~russian 骂玮疣弪 true 羼腓 钺牝 猁?镳桉忸屙, ?镳铗桠眍?耠篦噱 false
   ///         \~english Indicates whether object was assigned
   const bool IsAssigned() { return _IsAssigned; }
   /// \brief  \~russian 骂玮疣弪 true 羼腓 钺牝 猁?耦玟囗 桤 mql 觐溧, ?镳铗桠眍?耠篦噱 false
   ///         \~english Indicates whether object was created
   const bool IsCreated() { return _IsCreated; }

   // methods

   /// \brief  \~russian 橡桉?琨忄弪 钺牝 ?箧?耦玟囗眍祗 钺牝?CLR 
   ///         \~english Assigns this object to an existing CLR object
   /// \~russian \param handle       箨噻囹咫?磬 GCHanlde, 耦溴疰帙栝 钺牝 
   /// \~english \param handle       pointer to GCHanlde with object
   /// \~russian \param autoDestroy  true - 羼腓 CLR 钺牝 礤钺躅滂祛 箜梓蝾骅螯 ?箜梓蝾驽龛屐 耦铗忮蝰蜮簋泐 蜒lrObject, false - 羼腓 钺牝 眢骓?铖蜮噼螯 ?镟?蜩. 项 箪铍鬣龛?false.
   /// \~english \param autoDestroy  Indicates whether CLR object has to be destroyed with appropriate 蜒lrObject
   void              Assign(const long handle,const bool autoDestroy);
  };
//--------------------------------------------------------------------
void CClrObject::CreateClrObject(const string asmName,const string typeName)
  {
   bool isCanceling=false;

   OnObjectCreating(isCanceling,true);

   if(isCanceling) return;

   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   _ClrHandle=CreateManagedObject(asmName,typeName,exType,exMsg);

   if(exType!="")
     {
      _IsCreated=false;
      OnClrException("CreateClrObject",exType,exMsg);
     }
   else _IsCreated=true;
   _IsAssigned=false;

   OnObjectCreated();

  }
//--------------------------------------------------------------------
CClrObject::DestroyClrObject(void)
  {
   if(!_IsCreated) return;

   OnObjectDestroying();

   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   DestroyManagedObject(_ClrHandle,exType,exMsg);

   _IsCreated=false;

   if(exType!="")
      OnClrException("DestroyClrObject",exType,exMsg);

   OnObjectDestroyed();
  }
//--------------------------------------------------------------------
CClrObject::Assign(const long handle,const bool autoDestroy=false)
  {
   bool isCanceling=false;
   OnObjectCreating(isCanceling,false);

   if(isCanceling) return;

   _ClrHandle = handle;
   _IsCreated = autoDestroy;
   _IsAssigned= true;

   OnObjectCreated();
  }
//--------------------------------------------------------------------
CClrObject::OnClrException(const string method,const string type,const string message,const ushort mqlErr=ADOERR_FIRST)
  {
   Alert("体蝾?",_MqlTypeName,"::",method," 恹溧?桉觌屙桢 蜩镟 ",type,":\r\n",message);
   SetUserError(mqlErr);
  }
//+------------------------------------------------------------------+
