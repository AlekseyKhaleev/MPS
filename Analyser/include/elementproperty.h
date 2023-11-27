//---------------------------------------------------------------------------

#ifndef ELEMENTPROPERTYH
#define ELEMENTPROPERTYH
//---------------------------------------------------------------------------
#include <Graphics.hpp>
#include <SysUtils.hpp>
#include <Classes.hpp>
#include <XMLDoc.hpp>
#include "time.h"
#include "coredata.h"
//------------------------------------------------------------------------------
// config.h должен быть в текущем каталоге или каталоге заголовков компилятора
#include "config.h"
#include "specs.h"

#define HighSignal 1
#define LowSignal  0
#define ZSignal    2

enum TPinKind {pkIn, pkOut};
enum TChangeKind {ckLowToHigh, ckHighToLow, ckNone };

class TElement;
class TBusLineConect;
class TConection;
class TPin;
//class TSchema;
class TElement;
class TPin;
class TBus;
class TBusLine;
class TElement;
struct TSignal;

typedef void __fastcall (__closure *TUpdate)(TElement*);
typedef __int64 __fastcall (__closure *TGetTime)(void);
typedef void __fastcall (__closure *TPause)(bool);
typedef void __fastcall (__closure *TSignalToSysGen)(TSignal*);
typedef void __fastcall (__closure *TAddForExecute)(TElement*);

class TPinProp
{
  public:
    TPinProp() {};
    TPinProp(TPinProp *APinProp)
      { FPos=APinProp->FPos; FKind=APinProp->FKind; FName=APinProp->FName; }
    TPoint FPos;
    TPinKind FKind;
    UnicodeString FName;
};
//------------------------------------------------------------------------------


class PACKAGE TPinList: public TPersistent
{
  public:
    TList *List;
    Graphics::TBitmap *Bmp;
    __fastcall TPinList(void);
    __fastcall ~TPinList();
    void __fastcall Assign(TPersistent* Source);
    void __fastcall DefineProperties(TFiler* Filer);
    void __fastcall ReadData(TStream *Stream);
    void __fastcall WriteData(TStream *Stream);
};

//------------------------------------------------------------------------------

class PACKAGE TElementProperty : public TComponent
{
private:
        Graphics::TBitmap *FBmp;
        TPinList *FPinList;
        UnicodeString FMemuItemName;
        void __fastcall SetElementPicture(Graphics::TBitmap *FElementPicture);
        void __fastcall SetPinList(TPinList *Sourse);

protected:

public:
        __fastcall TElementProperty(TComponent* Owner);
        __fastcall ~TElementProperty();

__published:
       __property Graphics::TBitmap *ElementPicture={read=FBmp, write=SetElementPicture, stored=true};
       __property TPinList *PinList={read=FPinList, write=SetPinList, stored=true};
       __property UnicodeString MenuItemName={read=FMemuItemName, write=FMemuItemName, stored=true};
};

//---------------------------------------------------------------------------



class TPin: private TPinProp
{
  friend class TConection;
  private:
    TElement *FOwner;
    bool Busy;
	int FSignal;
	float FVoltage;
	TPoint __fastcall GetRealPos(void);
	TRect __fastcall GetNearRect();
	bool __fastcall GetSignal(void);
	void __fastcall SetKind(TPinKind AKind);
	float __fastcall GetVoltage (void);
	void __fastcall SetVoltage (float AVoltage);

  public:
	TConection *Conection;
	TBusLineConect *BusLineConect;
	__fastcall TPin(TElement *AOwner, TPoint APos, TPinKind AKind, UnicodeString AName);
	__property TElement *Owner = {read=FOwner};
	__property TPoint Pos = {read=FPos};
	__property TPoint RealPos = {read=GetRealPos};
	__property TRect NearRect = {read=GetNearRect};
	__property UnicodeString Name = {read=FName};
	__property TPinKind Kind = {read=FKind, write=SetKind};
	__property int FullSignal = {read=FSignal};
	__property bool Signal = {read = GetSignal};
	__property float Voltage = {read = GetVoltage, write = SetVoltage};
	void __fastcall SetSignal(int ASignal, int Delay=0);
	void __fastcall ForceSignal(int ASignal, int Delay);
	__int64 __fastcall GetTime();
    TChangeKind ChangeKind;
    int InitSignal;
    bool NeedGetEvent;

};


//------------------------------------------------------------------------------


class TElementID
{
  public:
    UnicodeString Library,
               Name;
};

struct TElementCoreData;

void FUNCTION_SPEC __fastcall UpdateTimeNotify(TElement *element, __int64 oldtime, __int64 newtime);

class __declspec(dllexport) TElement: virtual public IBaseObject
{
  friend class TPin;
  public:
	int Left, Top, Width, Height;
	Graphics::TBitmap *Bmp;
	TList *Pins;
	TRect GetRect(void);
	TElementID ID;
	__fastcall TElement(TElementProperty *Props);
	virtual __fastcall ~TElement();

	__property TRect ElementRect = {read=GetRect};
	__property __int64 NextTime = {read=CurrentNextTime, write=SetNextTime};

	virtual void __fastcall Load(TElementProperty *Props);
	virtual void __fastcall Time(__int64 ATime) {;}
	virtual void __fastcall Execute(void) {;}
	virtual void __fastcall GetProperty(void) {;}
	virtual void __fastcall StartModel(void) {;}
	virtual void __fastcall StopModel(void) {;}
	virtual void __fastcall KeyPressed(int Key) {;}
	virtual void __fastcall SaveProperty(_di_IXMLNode Property) {;}
	virtual void __fastcall LoadProperty(_di_IXMLNode Property) {;}
	virtual bool __fastcall MouseDown(TMouseButton, const TPoint &) {return false;}
	virtual bool __fastcall MouseUp(TMouseButton, const TPoint &)   {return false;}
	virtual UnicodeString __fastcall GetTextualInfo();

	virtual void __fastcall GetAnalogInfo(TAnalogInfo &res);

	TUpdate Update;
	TGetTime GetTime;
	TPause Pause;

	bool NeedGetTime;

	UnicodeString Caption;
	bool SysCaption;

	TElementProperty *BaseProp;

	TElementCoreData *CoreData;

	void __fastcall ShowSignalLevels();
	void __fastcall ScheduleUpdate();
	void Redraw() {Update(this);}

	inline TPin *Pin(int index) {return ((TPin *)Pins->Items[index]);}
	int __fastcall GetPinIndex(TPin *pin);

	void __fastcall UpdateAnalogInfo();

	void __fastcall SetNextTime(__int64 t)
	{
	 UpdateTimeNotify(this, CurrentNextTime, t);
	 CurrentNextTime = t;
	}

	QUERY_INTERFACE_PROTO;

protected:
	 __int64 CurrentNextTime;

};

//------------------------------------------------------------------------------

class PACKAGE TLibrary
{
  public:
        __fastcall TLibrary(TDataModule *Container);

        __fastcall ~TLibrary();

        UnicodeString MenuItemName;
        TElement * __fastcall (__closure *GetElement)(UnicodeString ElementName);
        TStringList *ElementNames;
        TStringList *MenuItems;
        HANDLE DLL;
        UnicodeString DLLName;
};

//---------------------------------------------------------------------------
class __declspec(dllimport) TLine
{

public:
  TPoint Start,End;

  TLine() {}
  bool __fastcall IsVert(void);
  TRect NearRect(void);
  void __fastcall Normalize(void);
  bool __fastcall Cross(TLine *Line);
};

//---------------------------------------------------------------------------
class __declspec(dllimport) TBusLineConect
{
  public:
    TBusLine *Owner;
    TPin *Pin;
    UnicodeString ID;
    bool hidden;
    TRect __fastcall NearRect(void);
    __fastcall ~TBusLineConect();
};

//---------------------------------------------------------------------------
class __declspec(dllimport) TBusLine: public TLine
{
  public:
    __fastcall TBusLine();
    TList *Pins;   // список BusLineConect
    TBus *Owner;
    void __fastcall ConectPin(TPin *APin);
    __fastcall ~TBusLine();
    void __fastcall Assign(TBusLine *ALine);
};

//---------------------------------------------------------------------------
class __declspec(dllimport) TBus
{
private:

protected:

public:
  TColor Color;
  bool Mark;
  TList *Lines;
  __fastcall TBus();
  __fastcall ~TBus();
  bool __fastcall Cross(TLine *Line);
  void __fastcall Simpl(void);
};

//---------------------------------------------------------------------------
class __declspec(dllimport) TConection
{
    TList *Pins;
    int OutStart;
    int CurSignal;
    TConection *Link;
  public:
    __fastcall TConection(void);
    __fastcall ~TConection();
    void __fastcall Add(TPin *Pin);
    void __fastcall KindChange(TPin *Pin);
    void __fastcall SignalFromPin(TPin *Pin,int Signal,int Delay);
    void __fastcall SignalFromSysGen(TSignal *Signal);
    void __fastcall Ruls(void);
    void __fastcall Init(void);
    void __fastcall SetLink(TConection *Conection);
    void __fastcall Update(void);
    TSignalToSysGen SignalToSysGen;
    TAddForExecute AddForExecute;

    template <class OutputIterator>
    void GetInputs(OutputIterator out)
    {
     for (int i = 0; i < OutStart; i++) {
      TPin *pin = ITEM(Pins, i, TPin);
      if (pin) *out++ = pin;
     }
    }

    template <class OutputIterator>
    void GetOutputs(OutputIterator out)
    {
     for (int i = OutStart; i < Pins->Count; i++) {
      TPin *pin = ITEM(Pins, i, TPin);
      if (pin) *out++ = pin;
     }
    }

    int __fastcall GetSignalExcept(TPin *pin);

    bool HasOutputs() {return OutStart<Pins->Count;}

    int OutputCount() {return Pins->Count-OutStart;}

};

//---------------------------------------------------------------------------
#endif
 