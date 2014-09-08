/* Copyright (C) 2012  Olga Yakovleva <yakovleva.o.v@gmail.com> */

/* This program is free software: you can redistribute it and/or modify */
/* it under the terms of the GNU Lesser General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or */
/* (at your option) any later version. */

/* This program is distributed in the hope that it will be useful, */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/* GNU Lesser General Public License for more details. */

/* You should have received a copy of the GNU Lesser General Public License */
/* along with this program.  If not, see <http://www.gnu.org/licenses/>. */

#ifdef WIN32
#include <wchar.h>
#endif
#include "core/io.hpp"
#include "utf8.h"

namespace RHVoice
{
  namespace io
  {
    file_handle open_file(const std::string& path,const std::string& mode)
    {
      #ifdef WIN32
      std::wstring wpath,wmode;
      utf8::utf8to16(path.begin(),path.end(),std::back_inserter(wpath));
      utf8::utf8to16(mode.begin(),mode.end(),std::back_inserter(wmode));
      file_handle result(_wfopen(wpath.c_str(),wmode.c_str()),std::fclose);
      #else
      file_handle result(std::fopen(path.c_str(),mode.c_str()),std::fclose);
      #endif
      if(result.empty())
        throw open_error();
      return result;
    }

    void open_ifstream(std::ifstream& stream,const std::string& path,bool binary)
    {
      std::ifstream::openmode mode=std::ifstream::in;
      if(binary)
        mode|=std::ifstream::binary;
      #ifdef WIN32
      std::wstring wpath;
      utf8::utf8to16(path.begin(),path.end(),std::back_inserter(wpath));
      stream.open(wpath.c_str(),mode);
      #else
      stream.open(path.c_str(),mode);
      #endif
      if(!stream.is_open())
        throw open_error();
    }
  }
}
