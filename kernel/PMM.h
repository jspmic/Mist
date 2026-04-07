#pragma once
#include "types.h"

void pmm_init(void);
u64 alloc(void);
void pmm_free(u64 addr);
