//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include <Classes.hpp>
#include <Graphics.hpp>
#include "ElementProperty.h"
#pragma package(smart_init)

//---------------------------------------------------------------------------
// ValidCtrCheck is used to assure that the components created do not have
// any pure virtual functions.
//


//------------------------------------------------------------------------------
__fastcall TPinList::TPinList(void): TPersistent()
{
  List=new TList();
}

//------------------------------------------------------------------------------
__fastcall TPinList::~TPinList()
{
  TPinProp** PinProp = (TPinProp**)List->List;
  for(int i=0;i<List->Count;i++)
     delete PinProp[i];
  delete List;
}

//------------------------------------------------------------------------------
void __fastcall TPinList::Assign(TPersistent *Sourse)
{
  TPinList *SourseList;

  if((SourseList=dynamic_cast<TPinList*>(Sourse))!=0)
    {TPinProp** PinProp = (TPinProp**)List->List;
     for(int i=0;i<List->Count;i++)
       delete PinProp[i];
     List->Clear();
     TMemoryStream *Stream=new TMemoryStream();
     SourseList->WriteData(Stream);
     Stream->Position=0;
     ReadData(Stream);
     delete Stream;}
  else
    TPersistent::Assign(Sourse);   

}

//------------------------------------------------------------------------------
void __fastcall TPinList::ReadData(TStream *Stream)
{
  TPinProp *Prop;
  UnicodeString FName;
  char *tmp;

  TPinProp** PinProp = (TPinProp**)List->List;
  for(int i=0;i<List->Count;i++) delete PinProp[i];
  
  List->Clear();

  while(Stream->Position<Stream->Size)
     {Prop=new TPinProp();
      Stream->Read(&Prop->FPos,sizeof(Prop->FPos));
      Stream->Read(&Prop->FKind,sizeof(Prop->FKind));
      char c;
      FName="";
      for(int i=0;i<100;i++)
        {Stream->Read(&c,1);
         if(c=='\0')
           break;
         Prop->FName+=c;}
      List->Add(Prop);}

}

//------------------------------------------------------------------------------
void __fastcall TPinList::WriteData(TStream *Stream)
{
  TPinProp **Prop=(TPinProp **)List->List;
  char *tmp;

  for(int i=0;i<List->Count;i++)
    {Stream->Write(&Prop[i]->FPos,sizeof(Prop[i]->FPos));
     Stream->Write(&Prop[i]->FKind,sizeof(Prop[i]->FKind));
     tmp=Prop[i]->FName.c_str();
     Stream->Write(tmp,Prop[i]->FName.Length()+1);}
}
//------------------------------------------------------------------------------
void __fastcall TPinList::DefineProperties(TFiler* Filer)
{
  TPersistent::DefineProperties(Filer);
  Filer->DefineBinaryProperty("Data",ReadData,WriteData,List->Count);
}

//------------------------------------------------------------------------------

static inline void ValidCtrCheck(TElementProperty *)
{
        new TElementProperty(NULL);
}
//---------------------------------------------------------------------------
__fastcall TElementProperty::TElementProperty(TComponent* Owner)
        : TComponent(Owner)
{
   FBmp = new Graphics::TBitmap();
   FPinList = new TPinList();
   FPinList->Bmp=FBmp;
}

//------------------------------------------------------------------------------
__fastcall TElementProperty::~TElementProperty()
{
   delete FBmp;
   delete FPinList;
}

//------------------------------------------------------------------------------
void __fastcall TElementProperty::SetElementPicture(Graphics::TBitmap *FElementPicture)
{
   FBmp->Assign(FElementPicture);
}

//------------------------------------------------------------------------------
void __fastcall TElementProperty::SetPinList(TPinList *Sourse)
{
  FPinList->Assign(Sourse);
}

namespace Elementproperty
{
        void __fastcall PACKAGE Register()
        {
                 TComponentClass classes[1] = {__classid(TElementProperty)};
                 RegisterComponents("Analiser", classes, 0);
        }

}


__fastcall TLibrary::TLibrary(TDataModule *Container)
{
  MenuItems      = new TStringList();
  ElementNames   = new TStringList();

  TElementProperty *Props;
  UnicodeString ClName;
  for(int i=0;i<Container->ComponentCount;i++) {
   Props=dynamic_cast<TElementProperty*>(Container->Components[i]);
   if(Props) {
    ElementNames->Add(Props->Name);
    MenuItems->Add(Props->MenuItemName);
   }
  }
}

__fastcall TLibrary::~TLibrary()
{
  delete MenuItems;
  delete ElementNames;
}
