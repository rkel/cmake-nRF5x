# MIT License

# Copyright (c) 2019 Polidea

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

include("nrf5_utils")

set(NRF5_SDK_PATH "" CACHE PATH "Path to the nRF5 SDK")
if(NOT NRF5_SDK_PATH)
  message(FATAL_ERROR "NRF5_SDK_PATH not specified")
endif()

set(NRF5_TARGET "" CACHE STRING "nRF5 target name e.g. nrf52810, nrf52832, nrf52840")
if(NRF5_TARGET)
  nrf5_validate_target(${NRF5_TARGET})
else()
  message(FATAL_ERROR "NRF5_TARGET not specified")
endif()

set(NRF5_LINKER_SCRIPT "" CACHE FILEPATH "Linker script file. If not specified, a generic script for a selected target will be used.")
if(NRF5_LINKER_SCRIPT)
  if(NOT EXISTS ${NRF5_LINKER_SCRIPT})
    message(FATAL_ERROR "Linker script file (NRF5_LINKER_SCRIPT) doesn't exist: ${NRF5_LINKER_SCRIPT}")
  endif()
else()
  find_file(ld_file "generic_gcc_nrf52.ld"
    PATHS "${NRF5_SDK_PATH}/config/${NRF5_TARGET}/armgcc"
    NO_DEFAULT_PATH
    CMAKE_FIND_ROOT_PATH_BOTH
  )

  if(NOT ld_file)
    message(FATAL_ERROR "Unable to find default linker script for ${NRF5_TARGET} target using specified nRF5 SDK path.")
  endif()

  set(NRF5_LINKER_SCRIPT ${ld_file} CACHE FILEPATH "" FORCE)

endif()

message(STATUS "Using linker script: ${NRF5_LINKER_SCRIPT}")
