#ifndef COMMON_H
#define COMMON_H

// Расширение "API" Analiser'а для плагинов
#include "specs.h"

#if defined(INSIDE_ANALISER_SOURCE)
#include "element.h"
#include "pin.h"
#else 
#include "elementproperty.h"
#endif

#include <vcl.h>
#include <syncobjs.hpp>
#include <dstring.h>
#include <stdlib.h>
#include "config.h"
#include "extensions.h"

#define ITEMINIT(basetype,prop,propname,proptype)  \
TPropertyInfo(UnicodeString(propname), (TPropertyPtr)&(basetype::prop), proptype, #prop)
#define ITEMINIT_DEF(basetype,prop,propname,proptype,def)  \
TPropertyInfo(UnicodeString(propname), (TPropertyPtr)&(basetype::prop), proptype, #prop, def)
#define ITEMINIT_END                               \
TPropertyInfo(UnicodeString(), NULL, ptEnd, NULL)

typedef void (*TPluginInitFunction)();
typedef void (*TPluginRegisterElementsFunction)(const TLibraryInfo *info);

class IGeneratorObject;

class IGeneratorPlugin {
public:
 virtual IGeneratorObject *__fastcall CreateObject() = 0;
 virtual void __fastcall DestroyObject(IGeneratorObject *obj) = NULL;
 virtual const char *__fastcall GetName() = 0;
 virtual ~IGeneratorPlugin() {;}
};

class IGeneratorObject {
public:
 virtual bool __fastcall Generate(void *buffer, size_t bufsize) = 0;
 virtual IGeneratorPlugin *__fastcall GetBuilder() = 0;
 virtual void __fastcall SetFileName(const char *name) = 0;
 virtual void __fastcall GetFileName(UnicodeString &res) = 0;
 virtual ~IGeneratorObject() {;}
};

// Расширение базового TElement'а с возможностью
// удобной настройки, сохранения и восстановления
// Порожденный класс определяет статический массив с информацией
// о всех настраиваемых переменных
class CLASS_SPEC TCustomElement: public TElement {
public:

 typedef int TCustomElement::*TPropertyPtr;

// Возможные типы свойств. Названия говорят сами за себя ;)
// ptEnd подразумевает конец массива свойств
 enum TPropertyType {ptInt, ptUint, ptInt64, ptUint64, ptDouble, ptUnicodeString,
                     ptEnd, ptUintHex, ptBool, ptFloat, ptFileNameString};

// Элемент массива свойств. Последний элемент должен иметь type==ptEnd
 struct TPropertyInfo {
  UnicodeString    name;           // Имя
  TPropertyPtr  ptr;            // Смещение относительно начала объекта
  TPropertyType type;           // Тип свойства
  const char   *internal;       // Внутреннее имя для сохранения в XML

  const char   *def_value;

  TPropertyInfo(UnicodeString n, TPropertyPtr p, TPropertyType t, const char *i):
   name(n), ptr(p), type(t), internal(i) {;}
  TPropertyInfo(UnicodeString n, TPropertyPtr p, TPropertyType t, const char *i, const char *def):
   name(n), ptr(p), type(t), internal(i), def_value(def) {;}
  void GetString(UnicodeString &s, TCustomElement *t) const;
  void SetString(const UnicodeString &s, TCustomElement *t) const;
 };

// Этот метод должен быть переопределен
 virtual const TPropertyInfo *__fastcall GetTable() = 0;

 TCustomElement(TElementProperty *prop): TElement(prop), auto_execute(true) {;}

 void __fastcall GetProperty() {DoPropertySetup();}
 void __fastcall SaveProperty(_di_IXMLNode xmlnode);
 void __fastcall LoadProperty(_di_IXMLNode xmlnode);

 void __fastcall SaveBinaryAttr(_di_IXMLNode &node, const char *name,
                                const void *buffer, size_t bufsize);
 bool __fastcall LoadBinaryAttr(_di_IXMLNode &node, const char *name,
                                void *buffer, size_t bufsize);

// Эта функция собственно проводит настройку
 bool __fastcall DoPropertySetup();

// Если порожденный класс переопределяет StartModel(), он должен
// вызвать эту версию метода, если хочет вызвать Execute()
// после StartModel()
 void __fastcall StartModel();

// Функции получения группы сигналов с шины
// lsb - номер контакта (TPin) с наименьним значащим разрядом
// count - число разрядов
 unsigned __fastcall GetBusValue(unsigned lsb, unsigned count);
 void __fastcall SetBusValue(unsigned lsb, unsigned count,
                             unsigned val, int delay);
 void __fastcall SetBusValue(unsigned lsb, unsigned count,
                             unsigned val, int delaylh, int delayhl);

// Эти функции получают данные, начиная со старшего разряда
 unsigned __fastcall GetBusValueMSB(unsigned msb, unsigned count);
 void __fastcall SetBusValueMSB(unsigned msb, unsigned count,
                                unsigned val, int delay);
 void __fastcall SetBusValueMSB(unsigned msb, unsigned count,
                                unsigned val, int delaylh, int delayhl);

// Эти две функции, соответственно, запрещают и разрешают
// вызов Execute() при смене уровня на контактах [start, start+count)
 void __fastcall DisableExecute(unsigned start, unsigned count);
 void __fastcall EnableExecute(unsigned start, unsigned count);

// Эта функция должна возвращать задержку
// перехода из состояния s1 в состояние s2
 virtual int __fastcall GetDelay(int s1, int s2) = 0;

// Эти функции используют задержки, возвращаемые GetDelay()
 inline int GetSignal(unsigned pin) {return ITEM(Pins, pin, TPin)->Signal;}
 void __fastcall SetSignal(unsigned pin, int signal, int add_delay=0);

 void __fastcall SetBusValueEx(unsigned lsb, unsigned count, unsigned val, int ad=0);
 void __fastcall SetBusValueExMSB(unsigned msb, unsigned count, unsigned val, int ad=0);

// Устанавливает уровни на контактах [start, start+count) на sig
 void __fastcall FillLevels(unsigned start, unsigned count, int sig);

// То же, но для InitSignal
 void __fastcall FillInitSignal(unsigned start, unsigned count, int sig);

// Устанавливает направление (вход/выход) на контактах [start, start+count)
 void __fastcall SetDirection(unsigned start, unsigned count, TPinKind kind);

 bool __fastcall KindChanged(unsigned start, unsigned count);
 void __fastcall ClearChangeKind(unsigned start, unsigned count);

 void *__fastcall QueryInterface(unsigned id);

protected:
 bool auto_execute;   // Если true, метод Execute() будет вызван после StartModel()
};

// Этот класс определяет два настраиваемых свойства:
// задержка перехода L->H и H->L
class CLASS_SPEC TBasicDigitalElement: public TCustomElement {
public:
 TBasicDigitalElement(TElementProperty *prop):
  TCustomElement(prop), 
  delay_hl(10), delay_lh(10) {;}

 const TPropertyInfo *__fastcall GetTable() {return array;}

 int __fastcall GetDelay(int s1, int s2);

protected:
 unsigned delay_hl, delay_lh;
 static TPropertyInfo array[];
};

// Этот класс определяет шесть настраиваемых задержек:
// L->H, H->L, L->Z, Z->L, H->Z, Z->H
class CLASS_SPEC TTriStateDigitalElement: public TCustomElement {
public:
 TTriStateDigitalElement(TElementProperty *prop):
  TCustomElement(prop),
  delay_hl(10), delay_lh(10),
  delay_lz(10), delay_zl(10),
  delay_hz(10), delay_zh(10) {;}

 const TPropertyInfo *__fastcall GetTable() {return array;}
 int __fastcall GetDelay(int s1, int s2);

protected:
 unsigned delay_hl, delay_lh, delay_lz, delay_zl, delay_hz, delay_zh;
 static TPropertyInfo array[];
};

// Класс элементов с одной регулируемой задержкой
class CLASS_SPEC TOneDelayElement: public TCustomElement {
public:
 TOneDelayElement(TElementProperty *prop):
  TCustomElement(prop), delay(10) {;}

 const TPropertyInfo *__fastcall GetTable() {return array;}
 int __fastcall GetDelay(int, int) {return delay;}

protected:
 unsigned delay;
 static TPropertyInfo array[];
};

class CLASS_SPEC TBasicCustomElement: public TCustomElement {
public:
 TBasicCustomElement(TElementProperty *prop): TCustomElement(prop) {;}

 const TPropertyInfo *__fastcall GetTable() {return array;}
 int __fastcall GetDelay(int, int) {return 0;}
 void __fastcall GetProperty() {;}

protected:
 static TPropertyInfo array[];
};

// Для удобного входа/выхода в критические секции можно
// использовать TMutexLock. Он захватывает мутекс в конструкторе,
// освобождает в деструкторе
// Согласно Win32 Programmer's Reference, поток может повторно
// захватывать мутекс (глобальный или локальный) без всяких проблем,
// так что код типа
// TMutexLock lock1(mutex);
// {
//   TMutexLock lock2(mutex);
// }
// не вызовет мертвую блокировку
class TMutexLock {
  TCriticalSection *mutex;
public:
 inline  TMutexLock(TCriticalSection *m);
 inline ~TMutexLock();
};

template <class X> class TGuardVariable {
 X &target;
public:
 TGuardVariable(X &t): target(t) {t++;}
~TGuardVariable() {target--;}
};

// Функция строит полное описание простого элемента по
// задающему INI-файлу. Больше нет нужды рисовать УГО
// каждого типа элемента!

// Для данной функции inifile задает путь относительно каталога
// с ядром программы
bool FUNCTION_SPEC __fastcall
BuildElementStructure(TElementProperty *prop, const char *inifile);

// В данной версии inifile задает полный путь
bool FUNCTION_SPEC __fastcall
BuildElementStructureFullPath(TElementProperty *prop, const char *inifile);

bool FUNCTION_SPEC __fastcall IsSimulationActive();

__int64 FUNCTION_SPEC __fastcall GetSysGenTime();

TElement *FUNCTION_SPEC __fastcall GetActiveElement();
TElement *FUNCTION_SPEC __fastcall GetElementByText(const wchar_t *name);

bool FUNCTION_SPEC __fastcall CanChangeElementText(TElement *element);
bool FUNCTION_SPEC __fastcall SetElementText(TElement *element, const wchar_t *text);

void FUNCTION_SPEC __fastcall RepaintMainWindow();

int FUNCTION_SPEC __fastcall GetNextLevel(TPin *pin);

// Эта функция кодирует массив src размером c байт
// методом, схожим с Base64. Получается массив символов
// размером 4*c/3. Число байтов c должно делиться на 3...
bool FUNCTION_SPEC __fastcall EncodeB64(const BYTE *src, BYTE *dest, size_t c);

// Это декодирование данных, полученных от предыдущей функции
// c - число получаемых байтов. Должно делиться на 3
bool FUNCTION_SPEC __fastcall DecodeB64(const BYTE *src, BYTE *dest, size_t c);

// Эта функция возвращает указатель на мутекс, используемый Analiser'ом
// Для предотвращения мертвых блокировок в элементах лучше использовать не свои
// мутексы, а этот (хотя это и может уменьшить производительность)
TCriticalSection *FUNCTION_SPEC __fastcall GetSimulationMutex();

typedef void (__fastcall *TSynchronizeTarget)(void *ptr);

// Эта функция позволяет вызвать заданную функцию target с аргументом arg
// в главном потоке VCL (для работы с компонентами VCL). Должна вызываться
// из потока системного генератора (т.е. методов класса TElement Execute() и Time())
// Возвращает false при отсутствии потока системного генератора
// В отличие от метода Synchronize() VCL эта функция не ждет выполнения вызова
void FUNCTION_SPEC __fastcall AddSynchronizedCall(TSynchronizeTarget target, void *arg);

// Вызвать все функции из очереди в данный момент
// Должна вызываться из главного потока, иначе может вызвать мертвую блокировку
void FUNCTION_SPEC __fastcall FlushSynchronizedCalls();

void FUNCTION_SPEC __fastcall AddWindowToMenu(TForm *wnd, TElement *item);
void FUNCTION_SPEC __fastcall UpdateWindowMenu();
bool FUNCTION_SPEC __fastcall RemoveWindowFromMenu(TForm *wnd);

void FUNCTION_SPEC __fastcall SetPauseGui(bool pause);
void FUNCTION_SPEC __fastcall SchedulePause();
void FUNCTION_SPEC __fastcall WaitForScheduledCalls();

void FUNCTION_SPEC __fastcall BeginLocalEventHandling();
void FUNCTION_SPEC __fastcall EndLocalEventHandling();

unsigned FUNCTION_SPEC __fastcall RegisterGeneratorPlugin(IGeneratorPlugin *pl);
void FUNCTION_SPEC __fastcall UnregisterGeneratorPlugin(IGeneratorPlugin *pl);

IGeneratorPlugin *FUNCTION_SPEC __fastcall GetGeneratorPlugin(unsigned index);
unsigned FUNCTION_SPEC __fastcall GetGeneratorPluginCount();

UnicodeString FUNCTION_SPEC __fastcall IntToBinStr(unsigned val, unsigned ndigits);

void FUNCTION_SPEC __fastcall RegisterHelpForElement(TElementProperty *prop, const char *file,
													 const char *anchor, const char *descr=NULL);

void FUNCTION_SPEC __fastcall UnregisterHelpForElement(TElementProperty *prop);

void FUNCTION_SPEC __fastcall AddMessage(TElement *e, const wchar_t *msg);

enum MessageTypeBuiltin {
 MessageTypeInfo     = 0,
 MessageTypeWarning  = 1,
 MessageTypeError    = 2
};

void FUNCTION_SPEC AddMessageEx(int type, TElement *e, const wchar_t *fs, ...);

int FUNCTION_SPEC __fastcall AddMessageType(const wchar_t *name, Graphics::TBitmap *img, Graphics::TBitmap *mask=NULL);

bool FUNCTION_SPEC __fastcall SetMessageFilterOptions(int type, bool enabled, bool showwindow);
bool FUNCTION_SPEC __fastcall GetMessageFilterOptions(int type, bool &enabled, bool &showwindow);

TList *FUNCTION_SPEC __fastcall SchemaGetElementList();

void FUNCTION_SPEC __fastcall ForceRepaintElement(TElement *e);

UnicodeString FUNCTION_SPEC __fastcall GetSimulatorDebugFileName();
UnicodeString FUNCTION_SPEC __fastcall GetConfigFileName();

TForm *FUNCTION_SPEC __fastcall GetMainForm();

enum TSimulatorMenuSection {
 MenuSectionFile,
 MenuSectionSettings,
 MenuSectionHelp,
 MenuSectionDocuments
};

struct TPluginMenuItem;

class IPluginMenuCommand {
public:
 virtual UnicodeString __fastcall Caption() = 0;
 virtual void __fastcall Run() = 0;
};

TPluginMenuItem *FUNCTION_SPEC __fastcall
AddPluginMenuItem(TSimulatorMenuSection section, IPluginMenuCommand *cmd);

bool FUNCTION_SPEC __fastcall RemovePluginMenuItem(TPluginMenuItem *item);

int FUNCTION_SPEC __fastcall RegisterElementGroup(const UnicodeString &group_name);
int FUNCTION_SPEC __fastcall RegisterElementSubGroup(const TLibraryInfo *info, int group_index, const UnicodeString &name);
int FUNCTION_SPEC __fastcall RegisterElement(const TLibraryInfo *info, int group_index, TElementProperty *prop);

// inline-реализация
inline TMutexLock::TMutexLock(TCriticalSection *m):
 mutex(m)
{
 //TRACE("Waiting for mutex " << mutex << " in thread " << (int)GetCurrentThreadId());
 if (mutex) mutex->Acquire();
 //TRACE("Mutex " << mutex << " acquired by thread " << (int)GetCurrentThreadId());
}

inline TMutexLock::~TMutexLock()
{
 //TRACE("Mutex " << mutex << " released by thread " << (int)GetCurrentThreadId());
 if (mutex) mutex->Release();
}


#endif