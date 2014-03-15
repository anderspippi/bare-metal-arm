//
// freedom.h -- Definitions for Freescale Freedom development board
//
//  Copyright (c) 2012-2013 Andrew Payne <andy@payne.org>
//

#include "MKL25Z4.h"                    // CPU definitions

#define CORE_CLOCK          48000000    // Core clock speed

static inline void RGB_LED(uint8_t red, uint8_t green, uint8_t blue)
{
    TPM2_C0V  = red;
    TPM2_C1V  = green;
    TPM0_C1V  = blue;
}
