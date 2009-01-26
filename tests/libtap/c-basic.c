/*
 * Calls libtap basic functions for testing.
 *
 * Written by Russ Allbery <rra@stanford.edu>
 * Copyright 2008 Board of Trustees, Leland Stanford Jr. University
 *
 * See LICENSE for licensing terms.
 */

#include <stdlib.h>

#include <tap/basic.h>

int
main(void)
{
    plan(29);
    ok(1, 1);
    ok(2, 0);
    is_int(3, 0, 0);
    is_int(4, 1, 1);
    is_int(5, -1, -1);
    is_int(6, -1, 1);
    is_double(7, 0, 0);
    is_double(8, 0.1, 0.1);
    is_double(9, 0.1, -0.1);
    is_double(10, 0, -0);
    is_double(11, 1.7e45, 1.7e45);
    is_string(12, "", "");
    is_string(13, "yes", "yes");
    is_string(14, "yes", "yes no");
    is_string(15, NULL, NULL);
    is_string(16, "yes", NULL);
    is_string(17, NULL, "yes");
    skip(18, "testing skip");
    ok_block(19, 2, 1);
    ok_block(21, 4, 0);
    skip_block(25, 4, "testing skip block");

    return 0;
}
