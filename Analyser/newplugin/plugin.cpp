//---------------------------------------------------------------------------

#include <vcl.h>
#include <windows.h>
#pragma hdrstop
#include <memory>
#include "Element.h"
#include "ElementProperty.h"
#include "common.h"

#pragma argsused

TLibrary *Lib;
TDataModule1 *Instr;

int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void* lpReserved)
{
   switch(reason) {
      case DLL_PROCESS_ATTACH:
      break;

      case DLL_PROCESS_DETACH:
        delete Lib;
        delete Instr;
      break;
    }
    return 1;
}
//---------------------------------------------------------------------------

void InitInstr(void)
{
  Lib->MenuItemName = "Новый плагин";
  Lib->GetElement = Instr->GetElement;
}

extern "C" TLibrary __declspec(dllexport) *GetLibrary(void)
{
  InitInstr();
  return Lib;
}

// Эта функция вызывается после загрузки плагина для его инициализации,
// причем до функции GetLibrary()
extern "C" void __declspec(dllexport) PluginInit()
{
        Instr = new TDataModule1(NULL);
        Lib   = new TLibrary(Instr);
}

// Эта функция вызывается перед выгрузкой плагина
extern "C" void __declspec(dllexport) PluginDeinitialize()
{
}




