#ifndef COSMOPOLITAN_LIBC_NEXGEN32E_NEXGEN32E_H_
#define COSMOPOLITAN_LIBC_NEXGEN32E_NEXGEN32E_H_
#if !(__ASSEMBLER__ + __LINKER__ + 0)
COSMOPOLITAN_C_START_

extern long kHalfCache3;
extern const uint64_t kTens[20];
extern const unsigned char kTensIndex[64];

void imapxlatab(void *);
void insertionsort(int32_t *, size_t);
void CheckStackIsAligned(void);

COSMOPOLITAN_C_END_
#endif /* !(__ASSEMBLER__ + __LINKER__ + 0) */
#endif /* COSMOPOLITAN_LIBC_NEXGEN32E_NEXGEN32E_H_ */
