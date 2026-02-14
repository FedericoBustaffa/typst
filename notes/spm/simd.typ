= SIMD
<simd>
Vectorized SIMD operations (Single Instruction Multiple Data) let us
execute a single instruction on multiple data at the same time. Of
course there are some limitations:

- The number of parallel operations depends on the hardware and on the
  number of vector register available.
- The data has to be stored in this special register, introducing some
  overhead.

There are many ways to achieve vectorized operations but the most
popular are:

- Let the compiler do some magic.
- Code with #emph[intrinsics] in a "high-level" assembly.

The first one is not always possible and sometimes we have to say to
code in a way that the compiler can apply all the optimizations it
knows. For the #emph[intrinsics] we a very low level API, if compared to
plain C++, but let us exploit more power.

== Optimized Compilation
<optimized-compilation>
The simpler method to obtain vectorized code in C/C++ is by enabling
compiler #strong[optimization flags];:

- `-O2`: some optimizations but depending on the compiler version the
  vectorization is not guaranteed.
- `-O3`: all the optimizations are enabled and try to vectorized when
  possible.
- `-ftree_vectorize`: explicit flag for vectorization.
- `-march=native`: tells the compiler to utilize every instruction
  available on the CPU to vectorize the code.

A special flag is `-ffast-math` that enables even more optimizations but
can worse the floatig point precision in many cases.

== Intrinsics
<intrinsics>
Low level constructs that map functions directly in assembly
instructions, letting the programmer to directly write vectorized code.

```cpp
void vadd(float* a, float* b, float* c, size_t n)
{
  for (size_t i = 0; i < n; ++i)
    c = a[i] + b[i];
}
```

With intrinsics we can calculate the same function 4 elements at a time:

```cpp
#include <immintrin.h>

void vadd128(float* a, float* b, float* c, size_t n)
{
  for (size_t i = 0; i < n; i += 4)
  {
    __m128 va = _mm_load_ps(&a[i]);
    __m128 vb = _mm_load_ps(&b[i]);
    __m128 vc = _mm_add_ps(va, vb);
    _mm_store_ps(&c[i], vs);
  }
}
```

=== Alignment
<alignment>
To get better performance with #emph[intrinsics] we should always align
data when possible. That is possible through the `_mm_malloc` function,
that works similarly to `malloc`, taking also a parameter for the
alignment size.

```cpp
float* v = static_cast<float*>(_mm_malloc(n * sizeof(float), 16));
```

This parameter depends on the size of the single element of the array
and on which kind of vectorized instruction we want to use. In the case
above we can see that we have an array of `float` (4 bytes) and we want
to use #emph[intrinsics] instructions from the #emph[SSE] family, that
provides operations for 4 elements at a time. In fact we use a alignment
dimension of $4 dot.op 4 = 16$.

Once an array is allocated with `_mm_malloc` must be freed with
`_mm_free`.

```cpp
_mm_free(v);
```

In C++ is also possible to use more high-level constructs to allocate
aligned memory; one of them is `std::align_alloc`, that let the memory
to be freed with the classic `delete[]`.

== References
<references>
- \[\[shared\_memory\_systems\]\]

- #link("https://www.intel.com/content/www/us/en/docs/intrinsics-guide/index.html#")[Intel Intrinsics Guide]
