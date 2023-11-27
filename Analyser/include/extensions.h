#ifndef EXTENSIONS_H
#define EXTENSIONS_H

#define DECLARE_INTERFACE_ID_INL(iface,id)       \
inline unsigned iface##_GetId() {return id;}

#define QUERY_INTERFACE_PROTO                    \
void *__fastcall QueryInterface(unsigned)

#define QUERY_INTERFACE(obj, iface)              \
obj->DoQueryInterface<iface>(iface##_GetId());

#define QUERY_INTERFACE_DEF(cl)                  \
void *__fastcall                                 \
cl::QueryInterface(unsigned id) {                \

#define SUPPORT_INTERFACE(iface)                 \
if (id==iface##_GetId())                         \
return dynamic_cast<iface*>(this);

#define QUERY_INTERFACE_PARENT(parent)           \
{                                                \
void *ptr = parent::QueryInterface(id);          \
if (ptr) return ptr;                             \
}

#define QUERY_INTERFACE_END                      \
return NULL;                                     \
}

DECLARE_INTERFACE_ID_INL(IBaseObject, 0)
DECLARE_INTERFACE_ID_INL(TElement, 1);
DECLARE_INTERFACE_ID_INL(TCustomElement, 2);
DECLARE_INTERFACE_ID_INL(IOutputCapabilityCheck, 3);
DECLARE_INTERFACE_ID_INL(IPreStartCheck, 4);
DECLARE_INTERFACE_ID_INL(IConditionInfoProvider, 5);
DECLARE_INTERFACE_ID_INL(IConditionFormProvider, 6);
DECLARE_INTERFACE_ID_INL(IElementHelpHandler, 7);
DECLARE_INTERFACE_ID_INL(IElementTextUpdateListener, 8);
DECLARE_INTERFACE_ID_INL(IGlobalEventListener, 9);

class IBaseObject {
public:
 virtual void *__fastcall QueryInterface(unsigned iface_id);

 template <class Iface>
 Iface *DoQueryInterface(unsigned id);
};

class IOutputCapabilityCheck: virtual public IBaseObject {
public:
 virtual int __fastcall GetOutputCapability(int pin) {return 10;}
};

class IPreStartCheck: virtual public IBaseObject {
public:
 virtual bool __fastcall PreStartCheck() = 0;
};

class IConditionInfoProvider: virtual public IBaseObject {
public:
 virtual unsigned __fastcall GetFieldCount() = 0;
 virtual bool __fastcall GetField(unsigned index, UnicodeString &name,
                                  UnicodeString &value) = 0;
};

class IConditionFormProvider: virtual public IBaseObject {
public:
 virtual TControl *__fastcall GetConditionForm() = 0;
};

class IElementHelpHandler: virtual public IBaseObject {
public:
 virtual bool __fastcall DisplayHelp() = 0;
};

class IElementTextUpdateListener: virtual public IBaseObject {
public:
 virtual bool __fastcall CanChangeElementText() = 0;
 virtual bool __fastcall ElementTextChanged(const UnicodeString &old_text) = 0;
};

class IGlobalEventListener: virtual public IBaseObject {
public:

 enum EventType {
  EventPause,
  EventResume
 };

 virtual void __fastcall OnGlobalEvent(EventType event) = 0;
};

template <class Iface>
inline Iface *IBaseObject::DoQueryInterface(unsigned id)
{
 void *ptr = QueryInterface(id);
 return ptr ? (Iface *)ptr : NULL;
}

inline void *__fastcall IBaseObject::QueryInterface(unsigned id)
{
 SUPPORT_INTERFACE(IBaseObject);
 return NULL;
}

#endif

