#include "common_whisper.h"

// // third-party utilities
// // use your favorite implementations
// #define DR_WAV_IMPLEMENTATION
// #include "dr_wav.h"

#include <cmath>
#include <cstring>
// #include <fstream>
// #include <regex>
// #include <locale>
// #include <codecvt>
// #include <sstream>

// from common.h in whisper
#include <string>
#include <map>
#include <vector>
#include <random>
#include <thread>
#include <ctime>
#include <fstream>


void high_pass_filter(std::vector<float> & data, float cutoff, float sample_rate) {
    const float rc = 1.0f / (2.0f * M_PI * cutoff);
    const float dt = 1.0f / sample_rate;
    const float alpha = dt / (rc + dt);

    float y = data[0];

    for (size_t i = 1; i < data.size(); i++) {
        y = alpha * (y + data[i] - data[i - 1]);
        data[i] = y;
    }
}

bool vad_simple(std::vector<float> & pcmf32, int sample_rate, int last_ms, float vad_thold, float freq_thold, bool verbose) {
    const int n_samples      = pcmf32.size();
    const int n_samples_last = (sample_rate * last_ms) / 1000;

    if (n_samples_last >= n_samples) {
        // not enough samples - assume no speech
        return false;
    }

    if (freq_thold > 0.0f) {
        high_pass_filter(pcmf32, freq_thold, sample_rate);
    }

    float energy_all  = 0.0f;
    float energy_last = 0.0f;

    for (int i = 0; i < n_samples; i++) {
        energy_all += fabsf(pcmf32[i]);

        if (i >= n_samples - n_samples_last) {
            energy_last += fabsf(pcmf32[i]);
        }
    }

    energy_all  /= n_samples;
    energy_last /= n_samples_last;

    if (verbose) {
        fprintf(stderr, "%s: energy_all: %f, energy_last: %f, vad_thold: %f, freq_thold: %f\n", __func__, energy_all, energy_last, vad_thold, freq_thold);
    }

    if (energy_last > vad_thold*energy_all) {
        return false;
    }

    return true;
}


// C wrapper for C++ functions
extern "C" {
    void high_pass_filter_c(float * data, int length, float cutoff, float sample_rate) {
        std::vector<float> pcmf32(data, data + length);
        high_pass_filter(pcmf32, cutoff, sample_rate);
        std::memcpy(data, pcmf32.data(), length * sizeof(float));
    }

    int vad_simple_c(float * data, int length, int sample_rate, int last_ms, float vad_thold, float freq_thold, int verbose) {
        std::vector<float> pcmf32(data, data + length);
        return vad_simple(pcmf32, sample_rate, last_ms, vad_thold, freq_thold, verbose);
    }
}