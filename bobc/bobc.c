/* bobc.c - the main routine */
/*
	Copyright (c) 2001, by David Michael Betz
	All rights reserved
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bob.h"
#include "bobcom.h"

#define HEAP_SIZE   (1024 * 1024)
#define EXPAND_SIZE (512 * 1024)
#define STACK_SIZE  (64 * 1025)

/* console stream structure */
typedef struct {
    BobStreamDispatch *d;
} ConsoleStream;

/* CloseConsoleStream - console stream close handler */
static int CloseConsoleStream(BobStream *s) {
    return 0;
}

/* ConsoleStreamGetC - console stream getc handler */
static int ConsoleStreamGetC(BobStream *s) {
    return getchar();
}

/* ConsoleStreamPutC - console stream putc handler */
static int ConsoleStreamPutC(int ch, BobStream *s) {
    return putchar(ch);
}

/* dispatch structure for null streams */
BobStreamDispatch consoleDispatch = {
        CloseConsoleStream, ConsoleStreamGetC, ConsoleStreamPutC
};

/* console stream */
ConsoleStream consoleStream = {&consoleDispatch};

/* prototypes */
static void CompileFile(BobInterpreter *c, char *iname, char *oname);

static void Usage(void);

/* ErrorHandler - error handler callback */
void ErrorHandler(BobInterpreter *c, int code, va_list ap) {
    switch (code) {
        case BobErrExit:
            exit(1);
        case BobErrRestart:
            /* just restart the restart the read/eval/print loop */
            break;
        default:
            BobShowError(c, code, ap);
            BobStackTrace(c);
            break;
    }
    exit(1);
}

/* main - the main routine */
int main(int argc, char **argv) {
    char *outputName = NULL;
    BobUnwindTarget target;
    BobInterpreter *c;
    int i;

    /* initialize the workspace */
    if ((c = BobMakeInterpreter(HEAP_SIZE, EXPAND_SIZE, STACK_SIZE)) == NULL) {
        exit(1);
    }
    BobUseStandardIO(c);

    /* setup the error handler target */
    BobPushUnwindTarget(c, &target);

    /* abort if any errors occur during initialization */
    if (BobUnwindCatch(c)) {
        exit(1);
    }

    /* setup the error handler */
    c->errorHandler = ErrorHandler;

    /* setup standard i/o */
    c->standardInput = (BobStream *) &consoleStream;
    c->standardOutput = (BobStream *) &consoleStream;
    c->standardError = (BobStream *) &consoleStream;

    /* use the eval package */
    BobUseEval(c);

    /* process arguments */
    for (i = 1; i < argc; ++i) {
        if (argv[i][0] == '-') {
            switch (argv[i][1]) {

                case 'o':
                    if (argv[i][2]) {
                        outputName = &argv[i][2];
                    } else if (++i < argc) {
                        outputName = argv[i];
                    } else {
                        Usage();
                    }
                    break;

                case 'g':
                    c->compiler->emitLineNumbersP = TRUE;
                    break;

                default:
                    Usage();
                    break;
            }
        } else {
            CompileFile(c, argv[i], outputName);
            outputName = NULL;
        }
    }

    /* catch errors and restart read/eval/print loop */
    BobUnwindCatch(c);

    /* pop the unwind target */
    BobPopUnwindTarget(c);

    /* return successfully */
    return 0;
}

/* CompileFile - compile a single file */
static void CompileFile(BobInterpreter *c, char *inputName, char *outputName) {
    char oname[1024], *p;

    /* determine the output filename */
    if (!outputName) {
        if ((p = strrchr(inputName, '.')) == NULL) {
            strcpy(oname, inputName);
        } else {
            int len = p - inputName;
            strncpy(oname, inputName, len);
            oname[len] = '\0';
        }
        strcat(oname, ".bbo");
        outputName = oname;
    }

    /* compile the file */
    printf("Compiling '%s' -> '%s'\n", inputName, outputName);
    BobCompileFile(BobCurrentScope(c), inputName, outputName);
}

/* Usage - display a usage message and exit */
static void Usage(void) {
    fprintf(stderr, "usage: bobc [-g] [-o outputFile] file\n");
    exit(1);
}

