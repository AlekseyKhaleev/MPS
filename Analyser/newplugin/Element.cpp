//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Element.h"
#include "ElementProperty.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ElementProperty"
#pragma resource "*.dfm"

#include "common.h"

//---------------------------------------------------------------------------
__fastcall TDataModule1::TDataModule1(TComponent* Owner)
: TDataModule(Owner)
{
}

 //---------------------------------------------------------------------------
TElement *__fastcall TDataModule1::GetElement(UnicodeString name)
{
 return NULL;
}

