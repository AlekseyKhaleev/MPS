#ifndef BASECONFIG_H
#define BASECONFIG_H

#define DEBUG_VERSION

// Определите этот макрос, если переменные обязательно должны быть
// выравнены. Это влияет на реализацию BufferedStream, заставляя
// использовать вместо присваиваний memcpy()
#define BASEOBJECTS_ALIGNMENT_AWARE

#ifdef INF_COMPILER_MINGW

// Модификатор, используемый при объявлении классов
#ifndef EXP_CLASS
#define EXP_CLASS __attribute__ (( dllexport ))
#endif

// Модификатор, используемый при объявлении функций
#ifndef EXP_FUNC
#define EXP_FUNC __attribute__ (( dllexport ))
#endif

#ifndef HIDDEN_FUNC
#define HIDDEN_FUNC __attribute__ (( dllexport ))
#endif

#ifndef HIDDEN_CLASS
#define HIDDEN_CLASS __attribute__ (( dllexport ))
#endif

#else

// Модификатор, используемый при объявлении классов
#ifndef EXP_CLASS
#define EXP_CLASS __declspec(dllexport)
#endif

// Модификатор, используемый при объявлении функций
#ifndef EXP_FUNC
#define EXP_FUNC __declspec(dllexport)
#endif

#ifndef HIDDEN_FUNC
#define HIDDEN_FUNC
#endif

#ifndef HIDDEN_CLASS
#define HIDDEN_CLASS 
#endif

#endif

#define DEPRECATED

// Размер буфера для преобразования чисел и указателей к строкам
#define BASEOBJECTS_INT_TO_STR_BUFFER_SIZE  256

// Использовать intrinsic-примитивы SSE
// Если компилятор некорректно выравнивает 16-байтовые векторы SSE,
// лучше эту опцию не включать (иначе eternity работать не будет)
// (например, для GCC 3)
// Эта опция включает ряд оптимизаций, основанных на векторных
// командах SSE, SSE2 и SSE3 (если доступны)
// Сборка пакета с опциями -msse и т.п. вполне допустима
//# define ENABLE_XMM_INS

// Выравнивание выделяемых на куче блоков (должно быть степенью 2)
#define BASEOBJECTS_ALLOC_ALIGNMENT 16

#define BASEOBJECTS_ATTR_ALIGNED __attribute__ (( align(16) ))

// Этот макрос получает из указателя ptr указатель с адресом, кратным align
// Выравнивание должно быть степенью 2
#define MAKE_ALIGNED(type,ptr,align)                                        \
(type*)(((unsigned long)ptr & (align-1)) ?                                  \
        ((char*)ptr + align - ((unsigned long)ptr & (align-1))) : ptr)
        
// Этот макрос можно использовать для создания переменной, выравненной
// по align байтам.
#define DEFINE_ALIGNED(type,name,align)                                        \
char __stg_##name[sizeof(type)+align];                                         \
type &__restrict__ name = *(type*)(__stg_##name + align -                      \
                   ((unsigned long)__stg_##name & (align-1)))

#define DECLARE_ALIGNED_FIELD(type,name,align)                                 \
char __stg_##name[sizeof(type)+align];                                         \
type *__restrict__ name;                                                                    

// Обходные пути для борьбы с GCC...
#define CREATE_ALIGNED_FIELD(type,name,align,params)                           \
char *__restrict__ __aligned_##name = (__stg_##name +                          \
                         align - ((unsigned long)__stg_##name & (align-1)));   \
name = new(__aligned_##name) type params

#define DESTROY_ALIGNED_FIELD(type,name)                                       \
name->~type()

#define DESTROY_MM_FIELD(type,name)                                            \
DESTROY_ALIGNED_FIELD(type,name)

// Выравнивание нужно только при использовании SSE
#if defined(__SSE__)
#define DECLARE_MM_FIELD(type,name)                                            \
DECLARE_ALIGNED_FIELD(type,name,BASEOBJECTS_ALLOC_ALIGNMENT)
#define CREATE_MM_FIELD(type,name,params)                                      \
CREATE_ALIGNED_FIELD(type,name,BASEOBJECTS_ALLOC_ALIGNMENT,params)
#else
#define DECLARE_MM_FIELD(type,name)                                            \
char __stg_##name[sizeof(type)];                                               \
type *__restrict__ name 
#define CREATE_MM_FIELD(type,name,params)                                      \
name = new(__stg_##name) type params
#endif

namespace Base {

typedef long long LongLong;
typedef unsigned long long ULongLong;

typedef unsigned char UInt8;
typedef signed char Int8;
typedef unsigned short UInt16;
typedef short Int16;
typedef unsigned int UInt32;
typedef int Int32;
typedef unsigned long long UInt64;
typedef long long Int64;

typedef unsigned long InterfaceId;

}

#endif
