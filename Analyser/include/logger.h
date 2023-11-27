#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#include <fstream>
#include <windows.h>

__int64 __fastcall GetSysGenTime();

// Интерфейс для простого класса журнала
class ILogger {
public:
 virtual ~ILogger() {;}
 
 virtual ILogger &operator<<(char c)             = 0;
 virtual ILogger &operator<<(int i)              = 0;
 virtual ILogger &operator<<(unsigned u)         = 0;
 virtual ILogger &operator<<(__int64 i)          = 0;
 virtual ILogger &operator<<(unsigned __int64 u) = 0;
 virtual ILogger &operator<<(double d)           = 0;
 virtual ILogger &operator<<(const char *c)      = 0;
 virtual ILogger &operator<<(const wchar_t *c)   = 0;
 virtual ILogger &operator<<(const void *p)      = 0;
 virtual void Endl()                             = 0;
};

class TOrdinaryLogger: public ILogger {
public:
 TOrdinaryLogger() {;}
 TOrdinaryLogger(const char *file):
  ofs(file, std::ios::out | std::ios::trunc) {;}
~TOrdinaryLogger() {;}

 void Open(const char *file) {ofs.clear(); ofs.open(file, std::ios::out | std::ios::trunc);}

 TOrdinaryLogger &operator<<(char v)             {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(int v)              {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(unsigned v)         {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(__int64 v)          {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(unsigned __int64 v) {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(double v)           {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(const char *v)      {ofs << v; return *this;}
 TOrdinaryLogger &operator<<(const void *v)      {ofs << v; return *this;}

 TOrdinaryLogger &operator<<(const wchar_t *v)
 {
  char buf[16384];
  WideCharToMultiByte(CP_ACP, 0, v, -1, buf, sizeof(buf), NULL, NULL);
  ofs << buf;
  return *this;
 }

 void Endl() {ofs << std::endl;}

protected:
 std::ofstream ofs;
};

#endif

