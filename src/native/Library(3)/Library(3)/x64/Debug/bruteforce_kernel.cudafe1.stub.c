#define __NV_CUBIN_HANDLE_STORAGE__ static
#if !defined(__CUDA_INCLUDE_COMPILER_INTERNAL_HEADERS__)
#define __CUDA_INCLUDE_COMPILER_INTERNAL_HEADERS__
#endif
#include "crt/host_runtime.h"
#include "bruteforce_kernel.fatbin.c"
extern void __device_stub__Z18kernel_brute_forcePKcS0_iS0_iPcPby(const char *, const char *, int, const char *, int, char *, bool *, unsigned __int64);
static void __nv_cudaEntityRegisterCallback(void **);
static void __sti____cudaRegisterAll(void);
#pragma section(".CRT$XCT",read)
__declspec(allocate(".CRT$XCT"))static void (*__dummy_static_init__sti____cudaRegisterAll[])(void) = {__sti____cudaRegisterAll};
void __device_stub__Z18kernel_brute_forcePKcS0_iS0_iPcPby(
const char *__par0, 
const char *__par1, 
int __par2, 
const char *__par3, 
int __par4, 
char *__par5, 
bool *__par6, 
unsigned __int64 __par7)
{
__cudaLaunchPrologue(8);
__cudaSetupArgSimple(__par0, 0Ui64);
__cudaSetupArgSimple(__par1, 8Ui64);
__cudaSetupArgSimple(__par2, 16Ui64);
__cudaSetupArgSimple(__par3, 24Ui64);
__cudaSetupArgSimple(__par4, 32Ui64);
__cudaSetupArgSimple(__par5, 40Ui64);
__cudaSetupArgSimple(__par6, 48Ui64);
__cudaSetupArgSimple(__par7, 56Ui64);
__cudaLaunch(((char *)((void ( *)(const char *, const char *, int, const char *, int, char *, bool *, unsigned __int64))kernel_brute_force)));
}
void kernel_brute_force( const char *__cuda_0,const char *__cuda_1,int __cuda_2,const char *__cuda_3,int __cuda_4,char *__cuda_5,bool *__cuda_6,unsigned __int64 __cuda_7)
{__device_stub__Z18kernel_brute_forcePKcS0_iS0_iPcPby( __cuda_0,__cuda_1,__cuda_2,__cuda_3,__cuda_4,__cuda_5,__cuda_6,__cuda_7);
}
#line 1 "x64/Debug/bruteforce_kernel.cudafe1.stub.c"
static void __nv_cudaEntityRegisterCallback(
void **__T0)
{
__nv_dummy_param_ref(__T0);
__nv_save_fatbinhandle_for_managed_rt(__T0);
__cudaRegisterEntry(__T0, ((void ( *)(const char *, const char *, int, const char *, int, char *, bool *, unsigned __int64))kernel_brute_force), _Z18kernel_brute_forcePKcS0_iS0_iPcPby, (-1));
}
static void __sti____cudaRegisterAll(void)
{
__cudaRegisterBinary(__nv_cudaEntityRegisterCallback);
}
