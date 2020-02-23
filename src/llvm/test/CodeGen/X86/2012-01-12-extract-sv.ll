; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mattr=+avx -mtriple=i686-pc-win32 | FileCheck %s

define void @endless_loop() {
; CHECK-LABEL: endless_loop:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovaps (%eax), %xmm0
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; CHECK-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm2[0,1,2,3,4,5,6],ymm0[7]
; CHECK-NEXT:    vmovaps %ymm0, (%eax)
; CHECK-NEXT:    vmovaps %ymm1, (%eax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
entry:
  %0 = load <8 x i32>, <8 x i32> addrspace(1)* undef, align 32
  %1 = shufflevector <8 x i32> %0, <8 x i32> undef, <16 x i32> <i32 4, i32 4, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %2 = shufflevector <16 x i32> <i32 undef, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 undef>, <16 x i32> %1, <16 x i32> <i32 16, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 17>
  store <16 x i32> %2, <16 x i32> addrspace(1)* undef, align 64
  ret void
}
