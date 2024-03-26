// Various helper functions and utilities

#pragma once

#define COMMON_SAMPLE_RATE 16000

#ifdef __cplusplus
extern "C" {
#endif

void high_pass_filter_c(float * data, int length, float cutoff, float sample_rate);

int vad_simple_c(float * data, int length, int sample_rate, int last_ms, float vad_thold, float freq_thold, int verbose);

#ifdef __cplusplus
}
#endif