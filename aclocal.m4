# aclocal.m4 -- Some useful autoconf macros.
# $Id$
#
# Copyright 2000 Russ Allbery <rra@stanford.edu>
# This work is hereby placed in the public domain by its author.
#
# This is a collection of miscellaneous autoconf macros that I've written
# and found generally useful.

# _RRA_FUNC_INET_NTOA_SOURCE
# --------------------------
define([_RRA_FUNC_INET_NTOA_SOURCE],
[#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#if STDC_HEADERS || HAVE_STRING_H
# include <string.h>
#endif

int
main ()
{
  struct in_addr in;
  in.s_addr = 0x7f000000;
  exit (!strcmp (inet_ntoa (in), "127.0.0.0") ? 0 : 1);
}])# _RRA_FUNC_INET_NTOA_SOURCE

# RRA_FUNC_INET_NTOA
# ------------------
# Check whether inet_ntoa is present and working.  Since calling inet_ntoa
# involves passing small structs on the stack, present and working versions
# may still not function with gcc on some platforms (such as IRIX).
AC_DEFUN([RRA_FUNC_INET_NTOA],
[AC_CACHE_CHECK(for working inet_ntoa, rra_cv_func_inet_ntoa_works,
[AC_TRY_RUN(_RRA_FUNC_INET_NTOA_SOURCE(),
            [rra_cv_func_inet_ntoa_works=yes],
            [rra_cv_func_inet_ntoa_works=no],
            [rra_cv_func_inet_ntoa_works=no])
if test "$rra_cv_func_inet_ntoa_works" = yes ; then
  AC_DEFINE_UNQUOTED([HAVE_INET_NTOA], 1,
                     [Define if your system has a working `inet_ntoa'
                      function.])
fi[]dnl
])])# RRA_FUNC_INET_NTOA

# RRA_NETWORK_LIBS
# ----------------
# Searches for the headers necessary for networking functions and adds them
# to LIBS.  Mostly for picking up -lsocket -lnsl on Solaris.
AC_DEFUN([RRA_NETWORK_LIBS],
[AC_SEARCH_LIBS(gethostbyname, nsl)
AC_SEARCH_LIBS(socket, socket, ,
    [AC_CHECK_LIB(nsl, socket, LIBS="$LIBS -lsocket -lnsl", , -lsocket)])])

# _RRA_FUNC_SNPRINTF_SOURCE
# -------------------------
define([_RRA_FUNC_SNPRINTF_SOURCE],
[[#include <stdio.h>
#include <stdarg.h>

char buf[2];

int
test (char *format, ...)
{
  va_list args;
  int count;

  va_start (args, format);
  count = vsnprintf (buf, sizeof buf, format, args);
  va_end (args);
  return count;
}

int
main ()
{
  return ((test ("%s", "abcd") == 4 && buf[0] == 'a' && buf[1] == '\0'
           && snprintf(NULL, 0, "%s", "abcd") == 4) ? 0 : 1);
}]])

# RRA_FUNC_SNPRINTF
# -----------------
# Check for a working snprintf.  Some systems have snprintf, but it doesn't
# null-terminate if the buffer isn't large enough or it returns -1 if the
# string doesn't fit instead of returning the number of characters that
# would have been formatted.
AC_DEFUN([RRA_FUNC_SNPRINTF],
[AC_CACHE_CHECK(for working snprintf, rra_cv_func_snprintf_works,
[AC_TRY_RUN(_RRA_FUNC_SNPRINTF_SOURCE(),
            [rra_cv_func_snprintf_works=yes],
            [rra_cv_func_snprintf_works=no],
            [rra_cv_func_snprintf_works=no])])
if test "$rra_cv_func_snprintf_works" = yes ; then
    AC_DEFINE([HAVE_SNPRINTF], 1,
        [Define if your system has a working snprintf function.])
else
    LIBOBJS="$LIBOBJS snprintf.${ac_objext}"
fi])
