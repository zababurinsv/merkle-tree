ARCH			= native

DEPFILE			= merkle-$(ARCH).depend

CC_native		= gcc
CC_html			= emcc
CC_module		= emcc
CC				= $(CC_$(ARCH))

SRCS			= merkle_tree.c md5.c
OBJS			= $(SRCS:.c=.o)

CFLAGS_native	= -std=c99 -pipe -Ofast -ffast-math -fno-common -falign-functions=16 -falign-loops=16 -Wall)
CFLAGS_html		=
CFLAGS_module	= -std=c99 -pipe -Ofast -ffast-math -fno-common -falign-functions=16 -falign-loops=16 -Wall -I. $(shell $(SDL_CFG_win32) --cflags)
CFLAGS			= $(CFLAGS_$(ARCH))

LDFLAGS_native	= $(shell $(SDL_CFG_native) --libs) -lm
LDFLAGS_win64	= $(shell $(SDL_CFG_win64) --libs)
LDFLAGS_win32	= $(shell $(SDL_CFG_win32) --libs)
LDFLAGS			= $(LDFLAGS_$(ARCH))

EXE_native	= merkle
EXE_html	= merkle.html
EXE_module	= merkle.html
EXE			= $(EXE_$(ARCH))

ALLDEPS		= Makefile

all:
	$(MAKE) dep ARCH=$(ARCH)
	$(MAKE) $(EXE) ARCH=$(ARCH)

.c.o: $(ALLDEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

$(DLL):
	test -s $(DLL_SOURCE) && cp $(DLL_SOURCE) $(DLL) || true

$(EXE): $(OBJS) $(ALLDEPS)
	$(MAKE) $(DLL) ARCH=$(ARCH)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

dep:	datafilebank.c
	$(MAKE) $(DEPFILE) ARCH=$(ARCH)

$(DEPFILE): $(ALLDEPS) *.c *.h datafilebank.c
	$(CC) -MM $(CFLAGS) $(SRCS) > $(DEPFILE)

clean:
	rm -f $(OBJS) $(EXE) $(DLL)

.PHONY: dep all clean distclean