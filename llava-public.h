#ifdef LLAMA_SHARED
#    if defined(_WIN32) && !defined(__MINGW32__)
#        ifdef LLAMA_BUILD
#            define LLAVA_API __declspec(dllexport)
#        else
#            define LLAVA_API __declspec(dllimport)
#        endif
#    else
#        define LLAVA_API __attribute__ ((visibility ("default")))
#    endif
#else
#    define LLAVA_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

struct llava_cli_context;

LLAVA_API struct llava_cli_context * llava_init(
    const char * mmproj_path,
    const char * model_path,
    const char * prompt,
    int32_t n_ctx);

LLAVA_API void load_image(const char * mmproj_path, struct llava_cli_context * ctx_cli, const char * base64_img);

LLAVA_API void completion_init(struct llava_cli_context * ctx_cli, const char * prompt_in);
LLAVA_API const char * completion_loop(struct llava_cli_context * ctx_cli);

LLAVA_API void llava_free(struct llava_cli_context * ctx_cli, bool free_all);

#ifdef __cplusplus
}
#endif
