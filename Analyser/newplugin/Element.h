//---------------------------------------------------------------------------

#ifndef ElementH
#define ElementH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ElementProperty.h"
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TElement;

class TDataModule1 : public TDataModule
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
 __fastcall TDataModule1(TComponent* Owner);
 TElement *__fastcall GetElement(UnicodeString Name);

};
#endif
