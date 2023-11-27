#if !defined(SPECS_H)
#define SPECS_H

#if defined(INSIDE_ANALISER_SOURCE)
#define CLASS_SPEC __declspec(dllexport)
#define FUNCTION_SPEC __declspec(dllexport)
#else 
#define CLASS_SPEC __declspec(dllimport)
#define FUNCTION_SPEC __declspec(dllimport)
#endif

#endif
