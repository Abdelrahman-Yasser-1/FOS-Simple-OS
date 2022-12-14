
obj/user/test_trim1_c:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 e3 00 00 00       	call   800119 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 requiredMemFrames;
uint32 extraFramesNeeded ;
uint32 memFramesToAllocate;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	remainingfreeframes = sys_calculate_free_frames();
  80003e:	e8 4e 17 00 00       	call   801791 <sys_calculate_free_frames>
  800043:	a3 00 31 80 00       	mov    %eax,0x803100
	memFramesToAllocate = (remainingfreeframes+0);
  800048:	a1 00 31 80 00       	mov    0x803100,%eax
  80004d:	a3 20 31 80 00       	mov    %eax,0x803120

	requiredMemFrames = sys_calculate_required_frames(USER_HEAP_START, memFramesToAllocate*PAGE_SIZE);
  800052:	a1 20 31 80 00       	mov    0x803120,%eax
  800057:	c1 e0 0c             	shl    $0xc,%eax
  80005a:	83 ec 08             	sub    $0x8,%esp
  80005d:	50                   	push   %eax
  80005e:	68 00 00 00 80       	push   $0x80000000
  800063:	e8 0e 17 00 00       	call   801776 <sys_calculate_required_frames>
  800068:	83 c4 10             	add    $0x10,%esp
  80006b:	a3 04 31 80 00       	mov    %eax,0x803104
	extraFramesNeeded = requiredMemFrames - remainingfreeframes;
  800070:	8b 15 04 31 80 00    	mov    0x803104,%edx
  800076:	a1 00 31 80 00       	mov    0x803100,%eax
  80007b:	29 c2                	sub    %eax,%edx
  80007d:	89 d0                	mov    %edx,%eax
  80007f:	a3 1c 31 80 00       	mov    %eax,0x80311c
	
	//cprintf("remaining frames = %d\n",remainingfreeframes);
	//cprintf("frames desired to be allocated = %d\n",memFramesToAllocate);
	//cprintf("req frames = %d\n",requiredMemFrames);
	
	uint32 size = (memFramesToAllocate)*PAGE_SIZE;
  800084:	a1 20 31 80 00       	mov    0x803120,%eax
  800089:	c1 e0 0c             	shl    $0xc,%eax
  80008c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char* x = malloc(sizeof(char)*size);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 f0             	pushl  -0x10(%ebp)
  800095:	e8 22 10 00 00       	call   8010bc <malloc>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint32 i=0;
  8000a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0; i<size;i++ )
  8000a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ae:	eb 0e                	jmp    8000be <_main+0x86>
	{
		x[i]=-1;
  8000b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	01 d0                	add    %edx,%eax
  8000b8:	c6 00 ff             	movb   $0xff,(%eax)
	
	uint32 size = (memFramesToAllocate)*PAGE_SIZE;
	char* x = malloc(sizeof(char)*size);

	uint32 i=0;
	for(i=0; i<size;i++ )
  8000bb:	ff 45 f4             	incl   -0xc(%ebp)
  8000be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000c4:	72 ea                	jb     8000b0 <_main+0x78>
	{
		x[i]=-1;
	}

	uint32 all_frames_to_be_trimmed = ROUNDUP(extraFramesNeeded*2, 3);
  8000c6:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
  8000cd:	a1 1c 31 80 00       	mov    0x80311c,%eax
  8000d2:	01 c0                	add    %eax,%eax
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d9:	01 d0                	add    %edx,%eax
  8000db:	48                   	dec    %eax
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e7:	f7 75 e8             	divl   -0x18(%ebp)
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	29 d0                	sub    %edx,%eax
  8000ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 frames_to_trimmed_every_env = all_frames_to_be_trimmed/3;
  8000f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f5:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  8000fa:	f7 e2                	mul    %edx
  8000fc:	89 d0                	mov    %edx,%eax
  8000fe:	d1 e8                	shr    %eax
  800100:	89 45 dc             	mov    %eax,-0x24(%ebp)

	cprintf("Frames to be trimmed from A or B = %d\n", frames_to_trimmed_every_env);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	ff 75 dc             	pushl  -0x24(%ebp)
  800109:	68 c0 20 80 00       	push   $0x8020c0
  80010e:	e8 1f 02 00 00       	call   800332 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp

	return;	
  800116:	90                   	nop
}
  800117:	c9                   	leave  
  800118:	c3                   	ret    

00800119 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80011f:	e8 a2 15 00 00       	call   8016c6 <sys_getenvindex>
  800124:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80012a:	89 d0                	mov    %edx,%eax
  80012c:	c1 e0 03             	shl    $0x3,%eax
  80012f:	01 d0                	add    %edx,%eax
  800131:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800138:	01 c8                	add    %ecx,%eax
  80013a:	01 c0                	add    %eax,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	01 c0                	add    %eax,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	89 c2                	mov    %eax,%edx
  800144:	c1 e2 05             	shl    $0x5,%edx
  800147:	29 c2                	sub    %eax,%edx
  800149:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800150:	89 c2                	mov    %eax,%edx
  800152:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800158:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80015d:	a1 20 30 80 00       	mov    0x803020,%eax
  800162:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800168:	84 c0                	test   %al,%al
  80016a:	74 0f                	je     80017b <libmain+0x62>
		binaryname = myEnv->prog_name;
  80016c:	a1 20 30 80 00       	mov    0x803020,%eax
  800171:	05 40 3c 01 00       	add    $0x13c40,%eax
  800176:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017f:	7e 0a                	jle    80018b <libmain+0x72>
		binaryname = argv[0];
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	8b 00                	mov    (%eax),%eax
  800186:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9f fe ff ff       	call   800038 <_main>
  800199:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80019c:	e8 c0 16 00 00       	call   801861 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 00 21 80 00       	push   $0x802100
  8001a9:	e8 84 01 00 00       	call   800332 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b6:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c1:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	52                   	push   %edx
  8001cb:	50                   	push   %eax
  8001cc:	68 28 21 80 00       	push   $0x802128
  8001d1:	e8 5c 01 00 00       	call   800332 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001de:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8001e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e9:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	52                   	push   %edx
  8001f3:	50                   	push   %eax
  8001f4:	68 50 21 80 00       	push   $0x802150
  8001f9:	e8 34 01 00 00       	call   800332 <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800201:	a1 20 30 80 00       	mov    0x803020,%eax
  800206:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	68 91 21 80 00       	push   $0x802191
  800215:	e8 18 01 00 00       	call   800332 <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	68 00 21 80 00       	push   $0x802100
  800225:	e8 08 01 00 00       	call   800332 <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022d:	e8 49 16 00 00       	call   80187b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800232:	e8 19 00 00 00       	call   800250 <exit>
}
  800237:	90                   	nop
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	6a 00                	push   $0x0
  800245:	e8 48 14 00 00       	call   801692 <sys_env_destroy>
  80024a:	83 c4 10             	add    $0x10,%esp
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <exit>:

void
exit(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800256:	e8 9d 14 00 00       	call   8016f8 <sys_env_exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800264:	8b 45 0c             	mov    0xc(%ebp),%eax
  800267:	8b 00                	mov    (%eax),%eax
  800269:	8d 48 01             	lea    0x1(%eax),%ecx
  80026c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026f:	89 0a                	mov    %ecx,(%edx)
  800271:	8b 55 08             	mov    0x8(%ebp),%edx
  800274:	88 d1                	mov    %dl,%cl
  800276:	8b 55 0c             	mov    0xc(%ebp),%edx
  800279:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80027d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	3d ff 00 00 00       	cmp    $0xff,%eax
  800287:	75 2c                	jne    8002b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800289:	a0 24 30 80 00       	mov    0x803024,%al
  80028e:	0f b6 c0             	movzbl %al,%eax
  800291:	8b 55 0c             	mov    0xc(%ebp),%edx
  800294:	8b 12                	mov    (%edx),%edx
  800296:	89 d1                	mov    %edx,%ecx
  800298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029b:	83 c2 08             	add    $0x8,%edx
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	50                   	push   %eax
  8002a2:	51                   	push   %ecx
  8002a3:	52                   	push   %edx
  8002a4:	e8 a7 13 00 00       	call   801650 <sys_cputs>
  8002a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b8:	8b 40 04             	mov    0x4(%eax),%eax
  8002bb:	8d 50 01             	lea    0x1(%eax),%edx
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002c4:	90                   	nop
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d7:	00 00 00 
	b.cnt = 0;
  8002da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002e4:	ff 75 0c             	pushl  0xc(%ebp)
  8002e7:	ff 75 08             	pushl  0x8(%ebp)
  8002ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f0:	50                   	push   %eax
  8002f1:	68 5e 02 80 00       	push   $0x80025e
  8002f6:	e8 11 02 00 00       	call   80050c <vprintfmt>
  8002fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002fe:	a0 24 30 80 00       	mov    0x803024,%al
  800303:	0f b6 c0             	movzbl %al,%eax
  800306:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	50                   	push   %eax
  800310:	52                   	push   %edx
  800311:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800317:	83 c0 08             	add    $0x8,%eax
  80031a:	50                   	push   %eax
  80031b:	e8 30 13 00 00       	call   801650 <sys_cputs>
  800320:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800323:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80032a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <cprintf>:

int cprintf(const char *fmt, ...) {
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800338:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80033f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800342:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	ff 75 f4             	pushl  -0xc(%ebp)
  80034e:	50                   	push   %eax
  80034f:	e8 73 ff ff ff       	call   8002c7 <vcprintf>
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80035a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035d:	c9                   	leave  
  80035e:	c3                   	ret    

0080035f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800365:	e8 f7 14 00 00       	call   801861 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80036a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80036d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	50                   	push   %eax
  80037a:	e8 48 ff ff ff       	call   8002c7 <vcprintf>
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800385:	e8 f1 14 00 00       	call   80187b <sys_enable_interrupt>
	return cnt;
  80038a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	53                   	push   %ebx
  800393:	83 ec 14             	sub    $0x14,%esp
  800396:	8b 45 10             	mov    0x10(%ebp),%eax
  800399:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ad:	77 55                	ja     800404 <printnum+0x75>
  8003af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b2:	72 05                	jb     8003b9 <printnum+0x2a>
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	77 4b                	ja     800404 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c7:	52                   	push   %edx
  8003c8:	50                   	push   %eax
  8003c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003cf:	e8 7c 1a 00 00       	call   801e50 <__udivdi3>
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	83 ec 04             	sub    $0x4,%esp
  8003da:	ff 75 20             	pushl  0x20(%ebp)
  8003dd:	53                   	push   %ebx
  8003de:	ff 75 18             	pushl  0x18(%ebp)
  8003e1:	52                   	push   %edx
  8003e2:	50                   	push   %eax
  8003e3:	ff 75 0c             	pushl  0xc(%ebp)
  8003e6:	ff 75 08             	pushl  0x8(%ebp)
  8003e9:	e8 a1 ff ff ff       	call   80038f <printnum>
  8003ee:	83 c4 20             	add    $0x20,%esp
  8003f1:	eb 1a                	jmp    80040d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	ff 75 20             	pushl  0x20(%ebp)
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	ff d0                	call   *%eax
  800401:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800404:	ff 4d 1c             	decl   0x1c(%ebp)
  800407:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80040b:	7f e6                	jg     8003f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800410:	bb 00 00 00 00       	mov    $0x0,%ebx
  800415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041b:	53                   	push   %ebx
  80041c:	51                   	push   %ecx
  80041d:	52                   	push   %edx
  80041e:	50                   	push   %eax
  80041f:	e8 3c 1b 00 00       	call   801f60 <__umoddi3>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	05 d4 23 80 00       	add    $0x8023d4,%eax
  80042c:	8a 00                	mov    (%eax),%al
  80042e:	0f be c0             	movsbl %al,%eax
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	50                   	push   %eax
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	ff d0                	call   *%eax
  80043d:	83 c4 10             	add    $0x10,%esp
}
  800440:	90                   	nop
  800441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800449:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044d:	7e 1c                	jle    80046b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	8d 50 08             	lea    0x8(%eax),%edx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 10                	mov    %edx,(%eax)
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	83 e8 08             	sub    $0x8,%eax
  800464:	8b 50 04             	mov    0x4(%eax),%edx
  800467:	8b 00                	mov    (%eax),%eax
  800469:	eb 40                	jmp    8004ab <getuint+0x65>
	else if (lflag)
  80046b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80046f:	74 1e                	je     80048f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	89 10                	mov    %edx,(%eax)
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	83 e8 04             	sub    $0x4,%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	ba 00 00 00 00       	mov    $0x0,%edx
  80048d:	eb 1c                	jmp    8004ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	8d 50 04             	lea    0x4(%eax),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	89 10                	mov    %edx,(%eax)
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	83 e8 04             	sub    $0x4,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ab:	5d                   	pop    %ebp
  8004ac:	c3                   	ret    

008004ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b4:	7e 1c                	jle    8004d2 <getint+0x25>
		return va_arg(*ap, long long);
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	8d 50 08             	lea    0x8(%eax),%edx
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 10                	mov    %edx,(%eax)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	83 e8 08             	sub    $0x8,%eax
  8004cb:	8b 50 04             	mov    0x4(%eax),%edx
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	eb 38                	jmp    80050a <getint+0x5d>
	else if (lflag)
  8004d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d6:	74 1a                	je     8004f2 <getint+0x45>
		return va_arg(*ap, long);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	99                   	cltd   
  8004f0:	eb 18                	jmp    80050a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	8d 50 04             	lea    0x4(%eax),%edx
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	89 10                	mov    %edx,(%eax)
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	83 e8 04             	sub    $0x4,%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	99                   	cltd   
}
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	56                   	push   %esi
  800510:	53                   	push   %ebx
  800511:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800514:	eb 17                	jmp    80052d <vprintfmt+0x21>
			if (ch == '\0')
  800516:	85 db                	test   %ebx,%ebx
  800518:	0f 84 af 03 00 00    	je     8008cd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	53                   	push   %ebx
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	ff d0                	call   *%eax
  80052a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052d:	8b 45 10             	mov    0x10(%ebp),%eax
  800530:	8d 50 01             	lea    0x1(%eax),%edx
  800533:	89 55 10             	mov    %edx,0x10(%ebp)
  800536:	8a 00                	mov    (%eax),%al
  800538:	0f b6 d8             	movzbl %al,%ebx
  80053b:	83 fb 25             	cmp    $0x25,%ebx
  80053e:	75 d6                	jne    800516 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800540:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800544:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80054b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800552:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800559:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8b 45 10             	mov    0x10(%ebp),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	89 55 10             	mov    %edx,0x10(%ebp)
  800569:	8a 00                	mov    (%eax),%al
  80056b:	0f b6 d8             	movzbl %al,%ebx
  80056e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800571:	83 f8 55             	cmp    $0x55,%eax
  800574:	0f 87 2b 03 00 00    	ja     8008a5 <vprintfmt+0x399>
  80057a:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  800581:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800583:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800587:	eb d7                	jmp    800560 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800589:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80058d:	eb d1                	jmp    800560 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800596:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800599:	89 d0                	mov    %edx,%eax
  80059b:	c1 e0 02             	shl    $0x2,%eax
  80059e:	01 d0                	add    %edx,%eax
  8005a0:	01 c0                	add    %eax,%eax
  8005a2:	01 d8                	add    %ebx,%eax
  8005a4:	83 e8 30             	sub    $0x30,%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8a 00                	mov    (%eax),%al
  8005af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8005b5:	7e 3e                	jle    8005f5 <vprintfmt+0xe9>
  8005b7:	83 fb 39             	cmp    $0x39,%ebx
  8005ba:	7f 39                	jg     8005f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005bf:	eb d5                	jmp    800596 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	83 c0 04             	add    $0x4,%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	83 e8 04             	sub    $0x4,%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005d5:	eb 1f                	jmp    8005f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005db:	79 83                	jns    800560 <vprintfmt+0x54>
				width = 0;
  8005dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005e4:	e9 77 ff ff ff       	jmp    800560 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005f0:	e9 6b ff ff ff       	jmp    800560 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fa:	0f 89 60 ff ff ff    	jns    800560 <vprintfmt+0x54>
				width = precision, precision = -1;
  800600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800603:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800606:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80060d:	e9 4e ff ff ff       	jmp    800560 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800612:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800615:	e9 46 ff ff ff       	jmp    800560 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 c0 04             	add    $0x4,%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	50                   	push   %eax
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
			break;
  80063a:	e9 89 02 00 00       	jmp    8008c8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	83 c0 04             	add    $0x4,%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	83 e8 04             	sub    $0x4,%eax
  80064e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800650:	85 db                	test   %ebx,%ebx
  800652:	79 02                	jns    800656 <vprintfmt+0x14a>
				err = -err;
  800654:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800656:	83 fb 64             	cmp    $0x64,%ebx
  800659:	7f 0b                	jg     800666 <vprintfmt+0x15a>
  80065b:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  800662:	85 f6                	test   %esi,%esi
  800664:	75 19                	jne    80067f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800666:	53                   	push   %ebx
  800667:	68 e5 23 80 00       	push   $0x8023e5
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	ff 75 08             	pushl  0x8(%ebp)
  800672:	e8 5e 02 00 00       	call   8008d5 <printfmt>
  800677:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80067a:	e9 49 02 00 00       	jmp    8008c8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80067f:	56                   	push   %esi
  800680:	68 ee 23 80 00       	push   $0x8023ee
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	e8 45 02 00 00       	call   8008d5 <printfmt>
  800690:	83 c4 10             	add    $0x10,%esp
			break;
  800693:	e9 30 02 00 00       	jmp    8008c8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 c0 04             	add    $0x4,%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 e8 04             	sub    $0x4,%eax
  8006a7:	8b 30                	mov    (%eax),%esi
  8006a9:	85 f6                	test   %esi,%esi
  8006ab:	75 05                	jne    8006b2 <vprintfmt+0x1a6>
				p = "(null)";
  8006ad:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  8006b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b6:	7e 6d                	jle    800725 <vprintfmt+0x219>
  8006b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006bc:	74 67                	je     800725 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	50                   	push   %eax
  8006c5:	56                   	push   %esi
  8006c6:	e8 0c 03 00 00       	call   8009d7 <strnlen>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006d1:	eb 16                	jmp    8006e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	ff 75 0c             	pushl  0xc(%ebp)
  8006dd:	50                   	push   %eax
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	ff d0                	call   *%eax
  8006e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ed:	7f e4                	jg     8006d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ef:	eb 34                	jmp    800725 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f5:	74 1c                	je     800713 <vprintfmt+0x207>
  8006f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8006fa:	7e 05                	jle    800701 <vprintfmt+0x1f5>
  8006fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8006ff:	7e 12                	jle    800713 <vprintfmt+0x207>
					putch('?', putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	6a 3f                	push   $0x3f
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	eb 0f                	jmp    800722 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	ff 75 0c             	pushl  0xc(%ebp)
  800719:	53                   	push   %ebx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800722:	ff 4d e4             	decl   -0x1c(%ebp)
  800725:	89 f0                	mov    %esi,%eax
  800727:	8d 70 01             	lea    0x1(%eax),%esi
  80072a:	8a 00                	mov    (%eax),%al
  80072c:	0f be d8             	movsbl %al,%ebx
  80072f:	85 db                	test   %ebx,%ebx
  800731:	74 24                	je     800757 <vprintfmt+0x24b>
  800733:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800737:	78 b8                	js     8006f1 <vprintfmt+0x1e5>
  800739:	ff 4d e0             	decl   -0x20(%ebp)
  80073c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800740:	79 af                	jns    8006f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800742:	eb 13                	jmp    800757 <vprintfmt+0x24b>
				putch(' ', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	6a 20                	push   $0x20
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800754:	ff 4d e4             	decl   -0x1c(%ebp)
  800757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075b:	7f e7                	jg     800744 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80075d:	e9 66 01 00 00       	jmp    8008c8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	ff 75 e8             	pushl  -0x18(%ebp)
  800768:	8d 45 14             	lea    0x14(%ebp),%eax
  80076b:	50                   	push   %eax
  80076c:	e8 3c fd ff ff       	call   8004ad <getint>
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800777:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80077a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800780:	85 d2                	test   %edx,%edx
  800782:	79 23                	jns    8007a7 <vprintfmt+0x29b>
				putch('-', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	6a 2d                	push   $0x2d
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	ff d0                	call   *%eax
  800791:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079a:	f7 d8                	neg    %eax
  80079c:	83 d2 00             	adc    $0x0,%edx
  80079f:	f7 da                	neg    %edx
  8007a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ae:	e9 bc 00 00 00       	jmp    80086f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	e8 84 fc ff ff       	call   800446 <getuint>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007d2:	e9 98 00 00 00       	jmp    80086f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	6a 58                	push   $0x58
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	ff d0                	call   *%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	6a 58                	push   $0x58
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	6a 58                	push   $0x58
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
			break;
  800807:	e9 bc 00 00 00       	jmp    8008c8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 0c             	pushl  0xc(%ebp)
  800812:	6a 30                	push   $0x30
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	6a 78                	push   $0x78
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	ff d0                	call   *%eax
  800829:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80083d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800847:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80084e:	eb 1f                	jmp    80086f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 e8             	pushl  -0x18(%ebp)
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
  800859:	50                   	push   %eax
  80085a:	e8 e7 fb ff ff       	call   800446 <getuint>
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800865:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800868:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	52                   	push   %edx
  80087a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80087d:	50                   	push   %eax
  80087e:	ff 75 f4             	pushl  -0xc(%ebp)
  800881:	ff 75 f0             	pushl  -0x10(%ebp)
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 00 fb ff ff       	call   80038f <printnum>
  80088f:	83 c4 20             	add    $0x20,%esp
			break;
  800892:	eb 34                	jmp    8008c8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			break;
  8008a3:	eb 23                	jmp    8008c8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	6a 25                	push   $0x25
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b5:	ff 4d 10             	decl   0x10(%ebp)
  8008b8:	eb 03                	jmp    8008bd <vprintfmt+0x3b1>
  8008ba:	ff 4d 10             	decl   0x10(%ebp)
  8008bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c0:	48                   	dec    %eax
  8008c1:	8a 00                	mov    (%eax),%al
  8008c3:	3c 25                	cmp    $0x25,%al
  8008c5:	75 f3                	jne    8008ba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008c7:	90                   	nop
		}
	}
  8008c8:	e9 47 fc ff ff       	jmp    800514 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008cd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008db:	8d 45 10             	lea    0x10(%ebp),%eax
  8008de:	83 c0 04             	add    $0x4,%eax
  8008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 16 fc ff ff       	call   80050c <vprintfmt>
  8008f6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800902:	8b 40 08             	mov    0x8(%eax),%eax
  800905:	8d 50 01             	lea    0x1(%eax),%edx
  800908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800911:	8b 10                	mov    (%eax),%edx
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	8b 40 04             	mov    0x4(%eax),%eax
  800919:	39 c2                	cmp    %eax,%edx
  80091b:	73 12                	jae    80092f <sprintputch+0x33>
		*b->buf++ = ch;
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	8d 48 01             	lea    0x1(%eax),%ecx
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
  800928:	89 0a                	mov    %ecx,(%edx)
  80092a:	8b 55 08             	mov    0x8(%ebp),%edx
  80092d:	88 10                	mov    %dl,(%eax)
}
  80092f:	90                   	nop
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80093e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800941:	8d 50 ff             	lea    -0x1(%eax),%edx
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	01 d0                	add    %edx,%eax
  800949:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800953:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800957:	74 06                	je     80095f <vsnprintf+0x2d>
  800959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095d:	7f 07                	jg     800966 <vsnprintf+0x34>
		return -E_INVAL;
  80095f:	b8 03 00 00 00       	mov    $0x3,%eax
  800964:	eb 20                	jmp    800986 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800966:	ff 75 14             	pushl  0x14(%ebp)
  800969:	ff 75 10             	pushl  0x10(%ebp)
  80096c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	68 fc 08 80 00       	push   $0x8008fc
  800975:	e8 92 fb ff ff       	call   80050c <vprintfmt>
  80097a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80097d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800980:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800983:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800986:	c9                   	leave  
  800987:	c3                   	ret    

00800988 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098e:	8d 45 10             	lea    0x10(%ebp),%eax
  800991:	83 c0 04             	add    $0x4,%eax
  800994:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800997:	8b 45 10             	mov    0x10(%ebp),%eax
  80099a:	ff 75 f4             	pushl  -0xc(%ebp)
  80099d:	50                   	push   %eax
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 89 ff ff ff       	call   800932 <vsnprintf>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c1:	eb 06                	jmp    8009c9 <strlen+0x15>
		n++;
  8009c3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c6:	ff 45 08             	incl   0x8(%ebp)
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8a 00                	mov    (%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 f1                	jne    8009c3 <strlen+0xf>
		n++;
	return n;
  8009d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d5:	c9                   	leave  
  8009d6:	c3                   	ret    

008009d7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e4:	eb 09                	jmp    8009ef <strnlen+0x18>
		n++;
  8009e6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e9:	ff 45 08             	incl   0x8(%ebp)
  8009ec:	ff 4d 0c             	decl   0xc(%ebp)
  8009ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f3:	74 09                	je     8009fe <strnlen+0x27>
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	84 c0                	test   %al,%al
  8009fc:	75 e8                	jne    8009e6 <strnlen+0xf>
		n++;
	return n;
  8009fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a0f:	90                   	nop
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8d 50 01             	lea    0x1(%eax),%edx
  800a16:	89 55 08             	mov    %edx,0x8(%ebp)
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a22:	8a 12                	mov    (%edx),%dl
  800a24:	88 10                	mov    %dl,(%eax)
  800a26:	8a 00                	mov    (%eax),%al
  800a28:	84 c0                	test   %al,%al
  800a2a:	75 e4                	jne    800a10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a44:	eb 1f                	jmp    800a65 <strncpy+0x34>
		*dst++ = *src;
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8d 50 01             	lea    0x1(%eax),%edx
  800a4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a52:	8a 12                	mov    (%edx),%dl
  800a54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8a 00                	mov    (%eax),%al
  800a5b:	84 c0                	test   %al,%al
  800a5d:	74 03                	je     800a62 <strncpy+0x31>
			src++;
  800a5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a62:	ff 45 fc             	incl   -0x4(%ebp)
  800a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a6b:	72 d9                	jb     800a46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a82:	74 30                	je     800ab4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a84:	eb 16                	jmp    800a9c <strlcpy+0x2a>
			*dst++ = *src++;
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8d 50 01             	lea    0x1(%eax),%edx
  800a8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a98:	8a 12                	mov    (%edx),%dl
  800a9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a9c:	ff 4d 10             	decl   0x10(%ebp)
  800a9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa3:	74 09                	je     800aae <strlcpy+0x3c>
  800aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	84 c0                	test   %al,%al
  800aac:	75 d8                	jne    800a86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aba:	29 c2                	sub    %eax,%edx
  800abc:	89 d0                	mov    %edx,%eax
}
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ac3:	eb 06                	jmp    800acb <strcmp+0xb>
		p++, q++;
  800ac5:	ff 45 08             	incl   0x8(%ebp)
  800ac8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8a 00                	mov    (%eax),%al
  800ad0:	84 c0                	test   %al,%al
  800ad2:	74 0e                	je     800ae2 <strcmp+0x22>
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8a 10                	mov    (%eax),%dl
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8a 00                	mov    (%eax),%al
  800ade:	38 c2                	cmp    %al,%dl
  800ae0:	74 e3                	je     800ac5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	0f b6 d0             	movzbl %al,%edx
  800aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	0f b6 c0             	movzbl %al,%eax
  800af2:	29 c2                	sub    %eax,%edx
  800af4:	89 d0                	mov    %edx,%eax
}
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800afb:	eb 09                	jmp    800b06 <strncmp+0xe>
		n--, p++, q++;
  800afd:	ff 4d 10             	decl   0x10(%ebp)
  800b00:	ff 45 08             	incl   0x8(%ebp)
  800b03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b0a:	74 17                	je     800b23 <strncmp+0x2b>
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	84 c0                	test   %al,%al
  800b13:	74 0e                	je     800b23 <strncmp+0x2b>
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 10                	mov    (%eax),%dl
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	38 c2                	cmp    %al,%dl
  800b21:	74 da                	je     800afd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b27:	75 07                	jne    800b30 <strncmp+0x38>
		return 0;
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2e:	eb 14                	jmp    800b44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	0f b6 d0             	movzbl %al,%edx
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	0f b6 c0             	movzbl %al,%eax
  800b40:	29 c2                	sub    %eax,%edx
  800b42:	89 d0                	mov    %edx,%eax
}
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 04             	sub    $0x4,%esp
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b52:	eb 12                	jmp    800b66 <strchr+0x20>
		if (*s == c)
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b5c:	75 05                	jne    800b63 <strchr+0x1d>
			return (char *) s;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	eb 11                	jmp    800b74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b63:	ff 45 08             	incl   0x8(%ebp)
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	84 c0                	test   %al,%al
  800b6d:	75 e5                	jne    800b54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 04             	sub    $0x4,%esp
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b82:	eb 0d                	jmp    800b91 <strfind+0x1b>
		if (*s == c)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b8c:	74 0e                	je     800b9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b8e:	ff 45 08             	incl   0x8(%ebp)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	84 c0                	test   %al,%al
  800b98:	75 ea                	jne    800b84 <strfind+0xe>
  800b9a:	eb 01                	jmp    800b9d <strfind+0x27>
		if (*s == c)
			break;
  800b9c:	90                   	nop
	return (char *) s;
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bae:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bb4:	eb 0e                	jmp    800bc4 <memset+0x22>
		*p++ = c;
  800bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb9:	8d 50 01             	lea    0x1(%eax),%edx
  800bbc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bc4:	ff 4d f8             	decl   -0x8(%ebp)
  800bc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bcb:	79 e9                	jns    800bb6 <memset+0x14>
		*p++ = c;

	return v;
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800be4:	eb 16                	jmp    800bfc <memcpy+0x2a>
		*d++ = *s++;
  800be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be9:	8d 50 01             	lea    0x1(%eax),%edx
  800bec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bf2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bf8:	8a 12                	mov    (%edx),%dl
  800bfa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c02:	89 55 10             	mov    %edx,0x10(%ebp)
  800c05:	85 c0                	test   %eax,%eax
  800c07:	75 dd                	jne    800be6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c26:	73 50                	jae    800c78 <memmove+0x6a>
  800c28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2e:	01 d0                	add    %edx,%eax
  800c30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c33:	76 43                	jbe    800c78 <memmove+0x6a>
		s += n;
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c41:	eb 10                	jmp    800c53 <memmove+0x45>
			*--d = *--s;
  800c43:	ff 4d f8             	decl   -0x8(%ebp)
  800c46:	ff 4d fc             	decl   -0x4(%ebp)
  800c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4c:	8a 10                	mov    (%eax),%dl
  800c4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c53:	8b 45 10             	mov    0x10(%ebp),%eax
  800c56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c59:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	75 e3                	jne    800c43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c60:	eb 23                	jmp    800c85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c74:	8a 12                	mov    (%edx),%dl
  800c76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	75 dd                	jne    800c62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c9c:	eb 2a                	jmp    800cc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca1:	8a 10                	mov    (%eax),%dl
  800ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	38 c2                	cmp    %al,%dl
  800caa:	74 16                	je     800cc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f b6 d0             	movzbl %al,%edx
  800cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb7:	8a 00                	mov    (%eax),%al
  800cb9:	0f b6 c0             	movzbl %al,%eax
  800cbc:	29 c2                	sub    %eax,%edx
  800cbe:	89 d0                	mov    %edx,%eax
  800cc0:	eb 18                	jmp    800cda <memcmp+0x50>
		s1++, s2++;
  800cc2:	ff 45 fc             	incl   -0x4(%ebp)
  800cc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cce:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	75 c9                	jne    800c9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	01 d0                	add    %edx,%eax
  800cea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ced:	eb 15                	jmp    800d04 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	0f b6 d0             	movzbl %al,%edx
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	0f b6 c0             	movzbl %al,%eax
  800cfd:	39 c2                	cmp    %eax,%edx
  800cff:	74 0d                	je     800d0e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d0a:	72 e3                	jb     800cef <memfind+0x13>
  800d0c:	eb 01                	jmp    800d0f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d0e:	90                   	nop
	return (void *) s;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d28:	eb 03                	jmp    800d2d <strtol+0x19>
		s++;
  800d2a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	3c 20                	cmp    $0x20,%al
  800d34:	74 f4                	je     800d2a <strtol+0x16>
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	3c 09                	cmp    $0x9,%al
  800d3d:	74 eb                	je     800d2a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	3c 2b                	cmp    $0x2b,%al
  800d46:	75 05                	jne    800d4d <strtol+0x39>
		s++;
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	eb 13                	jmp    800d60 <strtol+0x4c>
	else if (*s == '-')
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3c 2d                	cmp    $0x2d,%al
  800d54:	75 0a                	jne    800d60 <strtol+0x4c>
		s++, neg = 1;
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d64:	74 06                	je     800d6c <strtol+0x58>
  800d66:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d6a:	75 20                	jne    800d8c <strtol+0x78>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3c 30                	cmp    $0x30,%al
  800d73:	75 17                	jne    800d8c <strtol+0x78>
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	40                   	inc    %eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 78                	cmp    $0x78,%al
  800d7d:	75 0d                	jne    800d8c <strtol+0x78>
		s += 2, base = 16;
  800d7f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d83:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d8a:	eb 28                	jmp    800db4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d90:	75 15                	jne    800da7 <strtol+0x93>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3c 30                	cmp    $0x30,%al
  800d99:	75 0c                	jne    800da7 <strtol+0x93>
		s++, base = 8;
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800da5:	eb 0d                	jmp    800db4 <strtol+0xa0>
	else if (base == 0)
  800da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dab:	75 07                	jne    800db4 <strtol+0xa0>
		base = 10;
  800dad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	3c 2f                	cmp    $0x2f,%al
  800dbb:	7e 19                	jle    800dd6 <strtol+0xc2>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3c 39                	cmp    $0x39,%al
  800dc4:	7f 10                	jg     800dd6 <strtol+0xc2>
			dig = *s - '0';
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f be c0             	movsbl %al,%eax
  800dce:	83 e8 30             	sub    $0x30,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dd4:	eb 42                	jmp    800e18 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	3c 60                	cmp    $0x60,%al
  800ddd:	7e 19                	jle    800df8 <strtol+0xe4>
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	3c 7a                	cmp    $0x7a,%al
  800de6:	7f 10                	jg     800df8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	0f be c0             	movsbl %al,%eax
  800df0:	83 e8 57             	sub    $0x57,%eax
  800df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df6:	eb 20                	jmp    800e18 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	3c 40                	cmp    $0x40,%al
  800dff:	7e 39                	jle    800e3a <strtol+0x126>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3c 5a                	cmp    $0x5a,%al
  800e08:	7f 30                	jg     800e3a <strtol+0x126>
			dig = *s - 'A' + 10;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	0f be c0             	movsbl %al,%eax
  800e12:	83 e8 37             	sub    $0x37,%eax
  800e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e1e:	7d 19                	jge    800e39 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e20:	ff 45 08             	incl   0x8(%ebp)
  800e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e26:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e2a:	89 c2                	mov    %eax,%edx
  800e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e34:	e9 7b ff ff ff       	jmp    800db4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e39:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3e:	74 08                	je     800e48 <strtol+0x134>
		*endptr = (char *) s;
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	8b 55 08             	mov    0x8(%ebp),%edx
  800e46:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e4c:	74 07                	je     800e55 <strtol+0x141>
  800e4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e51:	f7 d8                	neg    %eax
  800e53:	eb 03                	jmp    800e58 <strtol+0x144>
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <ltostr>:

void
ltostr(long value, char *str)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e72:	79 13                	jns    800e87 <ltostr+0x2d>
	{
		neg = 1;
  800e74:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e81:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e84:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e8f:	99                   	cltd   
  800e90:	f7 f9                	idiv   %ecx
  800e92:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e98:	8d 50 01             	lea    0x1(%eax),%edx
  800e9b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9e:	89 c2                	mov    %eax,%edx
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	01 d0                	add    %edx,%eax
  800ea5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ea8:	83 c2 30             	add    $0x30,%edx
  800eab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ead:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eb5:	f7 e9                	imul   %ecx
  800eb7:	c1 fa 02             	sar    $0x2,%edx
  800eba:	89 c8                	mov    %ecx,%eax
  800ebc:	c1 f8 1f             	sar    $0x1f,%eax
  800ebf:	29 c2                	sub    %eax,%edx
  800ec1:	89 d0                	mov    %edx,%eax
  800ec3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800ec6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ece:	f7 e9                	imul   %ecx
  800ed0:	c1 fa 02             	sar    $0x2,%edx
  800ed3:	89 c8                	mov    %ecx,%eax
  800ed5:	c1 f8 1f             	sar    $0x1f,%eax
  800ed8:	29 c2                	sub    %eax,%edx
  800eda:	89 d0                	mov    %edx,%eax
  800edc:	c1 e0 02             	shl    $0x2,%eax
  800edf:	01 d0                	add    %edx,%eax
  800ee1:	01 c0                	add    %eax,%eax
  800ee3:	29 c1                	sub    %eax,%ecx
  800ee5:	89 ca                	mov    %ecx,%edx
  800ee7:	85 d2                	test   %edx,%edx
  800ee9:	75 9c                	jne    800e87 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ef9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800efd:	74 3d                	je     800f3c <ltostr+0xe2>
		start = 1 ;
  800eff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f06:	eb 34                	jmp    800f3c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	01 d0                	add    %edx,%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	01 c2                	add    %eax,%edx
  800f1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	01 c2                	add    %eax,%edx
  800f31:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f34:	88 02                	mov    %al,(%edx)
		start++ ;
  800f36:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f39:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f42:	7c c4                	jl     800f08 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f44:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	01 d0                	add    %edx,%eax
  800f4c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f4f:	90                   	nop
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f58:	ff 75 08             	pushl  0x8(%ebp)
  800f5b:	e8 54 fa ff ff       	call   8009b4 <strlen>
  800f60:	83 c4 04             	add    $0x4,%esp
  800f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	e8 46 fa ff ff       	call   8009b4 <strlen>
  800f6e:	83 c4 04             	add    $0x4,%esp
  800f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f82:	eb 17                	jmp    800f9b <strcconcat+0x49>
		final[s] = str1[s] ;
  800f84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	01 c2                	add    %eax,%edx
  800f8c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	01 c8                	add    %ecx,%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f98:	ff 45 fc             	incl   -0x4(%ebp)
  800f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fa1:	7c e1                	jl     800f84 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fa3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800faa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fb1:	eb 1f                	jmp    800fd2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fbc:	89 c2                	mov    %eax,%edx
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	01 c2                	add    %eax,%edx
  800fc3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	01 c8                	add    %ecx,%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fcf:	ff 45 f8             	incl   -0x8(%ebp)
  800fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fd8:	7c d9                	jl     800fb3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
}
  800fe5:	90                   	nop
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800feb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ff4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff7:	8b 00                	mov    (%eax),%eax
  800ff9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801000:	8b 45 10             	mov    0x10(%ebp),%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80100b:	eb 0c                	jmp    801019 <strsplit+0x31>
			*string++ = 0;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8d 50 01             	lea    0x1(%eax),%edx
  801013:	89 55 08             	mov    %edx,0x8(%ebp)
  801016:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	74 18                	je     80103a <strsplit+0x52>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	50                   	push   %eax
  80102b:	ff 75 0c             	pushl  0xc(%ebp)
  80102e:	e8 13 fb ff ff       	call   800b46 <strchr>
  801033:	83 c4 08             	add    $0x8,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	75 d3                	jne    80100d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	84 c0                	test   %al,%al
  801041:	74 5a                	je     80109d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801043:	8b 45 14             	mov    0x14(%ebp),%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	83 f8 0f             	cmp    $0xf,%eax
  80104b:	75 07                	jne    801054 <strsplit+0x6c>
		{
			return 0;
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	eb 66                	jmp    8010ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	8b 00                	mov    (%eax),%eax
  801059:	8d 48 01             	lea    0x1(%eax),%ecx
  80105c:	8b 55 14             	mov    0x14(%ebp),%edx
  80105f:	89 0a                	mov    %ecx,(%edx)
  801061:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 c2                	add    %eax,%edx
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801072:	eb 03                	jmp    801077 <strsplit+0x8f>
			string++;
  801074:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	8a 00                	mov    (%eax),%al
  80107c:	84 c0                	test   %al,%al
  80107e:	74 8b                	je     80100b <strsplit+0x23>
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	0f be c0             	movsbl %al,%eax
  801088:	50                   	push   %eax
  801089:	ff 75 0c             	pushl  0xc(%ebp)
  80108c:	e8 b5 fa ff ff       	call   800b46 <strchr>
  801091:	83 c4 08             	add    $0x8,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	74 dc                	je     801074 <strsplit+0x8c>
			string++;
	}
  801098:	e9 6e ff ff ff       	jmp    80100b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80109d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  8010c2:	a1 28 30 80 00       	mov    0x803028,%eax
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 33                	jne    8010fe <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  8010cb:	c7 05 40 31 80 00 00 	movl   $0x80000000,0x803140
  8010d2:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  8010d5:	c7 05 44 31 80 00 00 	movl   $0xa0000000,0x803144
  8010dc:	00 00 a0 
		spaces[0].pages = numPages;
  8010df:	c7 05 48 31 80 00 00 	movl   $0x20000,0x803148
  8010e6:	00 02 00 
		spaces[0].isFree = 1;
  8010e9:	c7 05 4c 31 80 00 01 	movl   $0x1,0x80314c
  8010f0:	00 00 00 
		arraySize++;
  8010f3:	a1 28 30 80 00       	mov    0x803028,%eax
  8010f8:	40                   	inc    %eax
  8010f9:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  8010fe:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801105:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  80110c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801113:	8b 55 08             	mov    0x8(%ebp),%edx
  801116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
  80111b:	48                   	dec    %eax
  80111c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80111f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801122:	ba 00 00 00 00       	mov    $0x0,%edx
  801127:	f7 75 e8             	divl   -0x18(%ebp)
  80112a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80112d:	29 d0                	sub    %edx,%eax
  80112f:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	c1 e8 0c             	shr    $0xc,%eax
  801138:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  80113b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801142:	eb 57                	jmp    80119b <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801147:	c1 e0 04             	shl    $0x4,%eax
  80114a:	05 4c 31 80 00       	add    $0x80314c,%eax
  80114f:	8b 00                	mov    (%eax),%eax
  801151:	85 c0                	test   %eax,%eax
  801153:	74 42                	je     801197 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801158:	c1 e0 04             	shl    $0x4,%eax
  80115b:	05 48 31 80 00       	add    $0x803148,%eax
  801160:	8b 00                	mov    (%eax),%eax
  801162:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801165:	7c 31                	jl     801198 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80116a:	c1 e0 04             	shl    $0x4,%eax
  80116d:	05 48 31 80 00       	add    $0x803148,%eax
  801172:	8b 00                	mov    (%eax),%eax
  801174:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801177:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117a:	7d 1c                	jge    801198 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  80117c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80117f:	c1 e0 04             	shl    $0x4,%eax
  801182:	05 48 31 80 00       	add    $0x803148,%eax
  801187:	8b 00                	mov    (%eax),%eax
  801189:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80118c:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  80118f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801195:	eb 01                	jmp    801198 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801197:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801198:	ff 45 ec             	incl   -0x14(%ebp)
  80119b:	a1 28 30 80 00       	mov    0x803028,%eax
  8011a0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8011a3:	7c 9f                	jl     801144 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8011a5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8011a9:	75 0a                	jne    8011b5 <malloc+0xf9>
	{
		return NULL;
  8011ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b0:	e9 34 01 00 00       	jmp    8012e9 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  8011b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b8:	c1 e0 04             	shl    $0x4,%eax
  8011bb:	05 48 31 80 00       	add    $0x803148,%eax
  8011c0:	8b 00                	mov    (%eax),%eax
  8011c2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8011c5:	75 38                	jne    8011ff <malloc+0x143>
		{
			spaces[index].isFree = 0;
  8011c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ca:	c1 e0 04             	shl    $0x4,%eax
  8011cd:	05 4c 31 80 00       	add    $0x80314c,%eax
  8011d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  8011d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011db:	c1 e0 0c             	shl    $0xc,%eax
  8011de:	89 c2                	mov    %eax,%edx
  8011e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e3:	c1 e0 04             	shl    $0x4,%eax
  8011e6:	05 40 31 80 00       	add    $0x803140,%eax
  8011eb:	8b 00                	mov    (%eax),%eax
  8011ed:	83 ec 08             	sub    $0x8,%esp
  8011f0:	52                   	push   %edx
  8011f1:	50                   	push   %eax
  8011f2:	e8 01 06 00 00       	call   8017f8 <sys_allocateMem>
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	e9 dd 00 00 00       	jmp    8012dc <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8011ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801202:	c1 e0 04             	shl    $0x4,%eax
  801205:	05 40 31 80 00       	add    $0x803140,%eax
  80120a:	8b 00                	mov    (%eax),%eax
  80120c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80120f:	c1 e2 0c             	shl    $0xc,%edx
  801212:	01 d0                	add    %edx,%eax
  801214:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801217:	a1 28 30 80 00       	mov    0x803028,%eax
  80121c:	c1 e0 04             	shl    $0x4,%eax
  80121f:	8d 90 40 31 80 00    	lea    0x803140(%eax),%edx
  801225:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801228:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80122a:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801233:	c1 e0 04             	shl    $0x4,%eax
  801236:	05 44 31 80 00       	add    $0x803144,%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	c1 e2 04             	shl    $0x4,%edx
  801240:	81 c2 44 31 80 00    	add    $0x803144,%edx
  801246:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801248:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80124e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801251:	c1 e0 04             	shl    $0x4,%eax
  801254:	05 48 31 80 00       	add    $0x803148,%eax
  801259:	8b 00                	mov    (%eax),%eax
  80125b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80125e:	c1 e2 04             	shl    $0x4,%edx
  801261:	81 c2 48 31 80 00    	add    $0x803148,%edx
  801267:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801269:	a1 28 30 80 00       	mov    0x803028,%eax
  80126e:	c1 e0 04             	shl    $0x4,%eax
  801271:	05 4c 31 80 00       	add    $0x80314c,%eax
  801276:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  80127c:	a1 28 30 80 00       	mov    0x803028,%eax
  801281:	40                   	inc    %eax
  801282:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128a:	c1 e0 04             	shl    $0x4,%eax
  80128d:	8d 90 44 31 80 00    	lea    0x803144(%eax),%edx
  801293:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801296:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129b:	c1 e0 04             	shl    $0x4,%eax
  80129e:	8d 90 48 31 80 00    	lea    0x803148(%eax),%edx
  8012a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a7:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  8012a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ac:	c1 e0 04             	shl    $0x4,%eax
  8012af:	05 4c 31 80 00       	add    $0x80314c,%eax
  8012b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  8012ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012bd:	c1 e0 0c             	shl    $0xc,%eax
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c5:	c1 e0 04             	shl    $0x4,%eax
  8012c8:	05 40 31 80 00       	add    $0x803140,%eax
  8012cd:	8b 00                	mov    (%eax),%eax
  8012cf:	83 ec 08             	sub    $0x8,%esp
  8012d2:	52                   	push   %edx
  8012d3:	50                   	push   %eax
  8012d4:	e8 1f 05 00 00       	call   8017f8 <sys_allocateMem>
  8012d9:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8012dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012df:	c1 e0 04             	shl    $0x4,%eax
  8012e2:	05 40 31 80 00       	add    $0x803140,%eax
  8012e7:	8b 00                	mov    (%eax),%eax
	}


}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  8012f1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  8012f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  8012ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801306:	eb 3f                	jmp    801347 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80130b:	c1 e0 04             	shl    $0x4,%eax
  80130e:	05 40 31 80 00       	add    $0x803140,%eax
  801313:	8b 00                	mov    (%eax),%eax
  801315:	3b 45 08             	cmp    0x8(%ebp),%eax
  801318:	75 2a                	jne    801344 <free+0x59>
		{
			index=i;
  80131a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80131d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801323:	c1 e0 04             	shl    $0x4,%eax
  801326:	05 48 31 80 00       	add    $0x803148,%eax
  80132b:	8b 00                	mov    (%eax),%eax
  80132d:	c1 e0 0c             	shl    $0xc,%eax
  801330:	89 c2                	mov    %eax,%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	52                   	push   %edx
  801339:	50                   	push   %eax
  80133a:	e8 9d 04 00 00       	call   8017dc <sys_freeMem>
  80133f:	83 c4 10             	add    $0x10,%esp
			break;
  801342:	eb 0d                	jmp    801351 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801344:	ff 45 ec             	incl   -0x14(%ebp)
  801347:	a1 28 30 80 00       	mov    0x803028,%eax
  80134c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80134f:	7c b7                	jl     801308 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801351:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801355:	75 17                	jne    80136e <free+0x83>
	{
		panic("Error");
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 50 25 80 00       	push   $0x802550
  80135f:	68 81 00 00 00       	push   $0x81
  801364:	68 56 25 80 00       	push   $0x802556
  801369:	e8 14 09 00 00       	call   801c82 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  80136e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801375:	e9 cc 00 00 00       	jmp    801446 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80137a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80137d:	c1 e0 04             	shl    $0x4,%eax
  801380:	05 4c 31 80 00       	add    $0x80314c,%eax
  801385:	8b 00                	mov    (%eax),%eax
  801387:	85 c0                	test   %eax,%eax
  801389:	0f 84 b3 00 00 00    	je     801442 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  80138f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801392:	c1 e0 04             	shl    $0x4,%eax
  801395:	05 40 31 80 00       	add    $0x803140,%eax
  80139a:	8b 10                	mov    (%eax),%edx
  80139c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139f:	c1 e0 04             	shl    $0x4,%eax
  8013a2:	05 44 31 80 00       	add    $0x803144,%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	39 c2                	cmp    %eax,%edx
  8013ab:	0f 85 92 00 00 00    	jne    801443 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  8013b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b4:	c1 e0 04             	shl    $0x4,%eax
  8013b7:	05 44 31 80 00       	add    $0x803144,%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013c1:	c1 e2 04             	shl    $0x4,%edx
  8013c4:	81 c2 44 31 80 00    	add    $0x803144,%edx
  8013ca:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8013cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013cf:	c1 e0 04             	shl    $0x4,%eax
  8013d2:	05 48 31 80 00       	add    $0x803148,%eax
  8013d7:	8b 10                	mov    (%eax),%edx
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	c1 e0 04             	shl    $0x4,%eax
  8013df:	05 48 31 80 00       	add    $0x803148,%eax
  8013e4:	8b 00                	mov    (%eax),%eax
  8013e6:	01 c2                	add    %eax,%edx
  8013e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013eb:	c1 e0 04             	shl    $0x4,%eax
  8013ee:	05 48 31 80 00       	add    $0x803148,%eax
  8013f3:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	c1 e0 04             	shl    $0x4,%eax
  8013fb:	05 40 31 80 00       	add    $0x803140,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	c1 e0 04             	shl    $0x4,%eax
  80140c:	05 44 31 80 00       	add    $0x803144,%eax
  801411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141a:	c1 e0 04             	shl    $0x4,%eax
  80141d:	05 48 31 80 00       	add    $0x803148,%eax
  801422:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	c1 e0 04             	shl    $0x4,%eax
  80142e:	05 4c 31 80 00       	add    $0x80314c,%eax
  801433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801439:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801440:	eb 12                	jmp    801454 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801442:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801443:	ff 45 e8             	incl   -0x18(%ebp)
  801446:	a1 28 30 80 00       	mov    0x803028,%eax
  80144b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80144e:	0f 8c 26 ff ff ff    	jl     80137a <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801454:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80145b:	e9 cc 00 00 00       	jmp    80152c <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801460:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801463:	c1 e0 04             	shl    $0x4,%eax
  801466:	05 4c 31 80 00       	add    $0x80314c,%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	85 c0                	test   %eax,%eax
  80146f:	0f 84 b3 00 00 00    	je     801528 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801478:	c1 e0 04             	shl    $0x4,%eax
  80147b:	05 44 31 80 00       	add    $0x803144,%eax
  801480:	8b 10                	mov    (%eax),%edx
  801482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801485:	c1 e0 04             	shl    $0x4,%eax
  801488:	05 40 31 80 00       	add    $0x803140,%eax
  80148d:	8b 00                	mov    (%eax),%eax
  80148f:	39 c2                	cmp    %eax,%edx
  801491:	0f 85 92 00 00 00    	jne    801529 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149a:	c1 e0 04             	shl    $0x4,%eax
  80149d:	05 40 31 80 00       	add    $0x803140,%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a7:	c1 e2 04             	shl    $0x4,%edx
  8014aa:	81 c2 40 31 80 00    	add    $0x803140,%edx
  8014b0:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8014b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b5:	c1 e0 04             	shl    $0x4,%eax
  8014b8:	05 48 31 80 00       	add    $0x803148,%eax
  8014bd:	8b 10                	mov    (%eax),%edx
  8014bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c2:	c1 e0 04             	shl    $0x4,%eax
  8014c5:	05 48 31 80 00       	add    $0x803148,%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	01 c2                	add    %eax,%edx
  8014ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d1:	c1 e0 04             	shl    $0x4,%eax
  8014d4:	05 48 31 80 00       	add    $0x803148,%eax
  8014d9:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8014db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014de:	c1 e0 04             	shl    $0x4,%eax
  8014e1:	05 40 31 80 00       	add    $0x803140,%eax
  8014e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ef:	c1 e0 04             	shl    $0x4,%eax
  8014f2:	05 44 31 80 00       	add    $0x803144,%eax
  8014f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801500:	c1 e0 04             	shl    $0x4,%eax
  801503:	05 48 31 80 00       	add    $0x803148,%eax
  801508:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80150e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801511:	c1 e0 04             	shl    $0x4,%eax
  801514:	05 4c 31 80 00       	add    $0x80314c,%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80151f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801526:	eb 12                	jmp    80153a <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801528:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801529:	ff 45 e4             	incl   -0x1c(%ebp)
  80152c:	a1 28 30 80 00       	mov    0x803028,%eax
  801531:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801534:	0f 8c 26 ff ff ff    	jl     801460 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80153a:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80153e:	75 11                	jne    801551 <free+0x266>
	{
		spaces[index].isFree = 1;
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	c1 e0 04             	shl    $0x4,%eax
  801546:	05 4c 31 80 00       	add    $0x80314c,%eax
  80154b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801551:	90                   	nop
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 18             	sub    $0x18,%esp
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	68 64 25 80 00       	push   $0x802564
  801568:	68 b9 00 00 00       	push   $0xb9
  80156d:	68 56 25 80 00       	push   $0x802556
  801572:	e8 0b 07 00 00       	call   801c82 <_panic>

00801577 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	68 64 25 80 00       	push   $0x802564
  801585:	68 bf 00 00 00       	push   $0xbf
  80158a:	68 56 25 80 00       	push   $0x802556
  80158f:	e8 ee 06 00 00       	call   801c82 <_panic>

00801594 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	68 64 25 80 00       	push   $0x802564
  8015a2:	68 c5 00 00 00       	push   $0xc5
  8015a7:	68 56 25 80 00       	push   $0x802556
  8015ac:	e8 d1 06 00 00       	call   801c82 <_panic>

008015b1 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015b7:	83 ec 04             	sub    $0x4,%esp
  8015ba:	68 64 25 80 00       	push   $0x802564
  8015bf:	68 ca 00 00 00       	push   $0xca
  8015c4:	68 56 25 80 00       	push   $0x802556
  8015c9:	e8 b4 06 00 00       	call   801c82 <_panic>

008015ce <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	68 64 25 80 00       	push   $0x802564
  8015dc:	68 d0 00 00 00       	push   $0xd0
  8015e1:	68 56 25 80 00       	push   $0x802556
  8015e6:	e8 97 06 00 00       	call   801c82 <_panic>

008015eb <shrink>:
}
void shrink(uint32 newSize)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	68 64 25 80 00       	push   $0x802564
  8015f9:	68 d4 00 00 00       	push   $0xd4
  8015fe:	68 56 25 80 00       	push   $0x802556
  801603:	e8 7a 06 00 00       	call   801c82 <_panic>

00801608 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	68 64 25 80 00       	push   $0x802564
  801616:	68 d9 00 00 00       	push   $0xd9
  80161b:	68 56 25 80 00       	push   $0x802556
  801620:	e8 5d 06 00 00       	call   801c82 <_panic>

00801625 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	57                   	push   %edi
  801629:	56                   	push   %esi
  80162a:	53                   	push   %ebx
  80162b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801637:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80163a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80163d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801640:	cd 30                	int    $0x30
  801642:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801645:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5f                   	pop    %edi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80165c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	52                   	push   %edx
  801668:	ff 75 0c             	pushl  0xc(%ebp)
  80166b:	50                   	push   %eax
  80166c:	6a 00                	push   $0x0
  80166e:	e8 b2 ff ff ff       	call   801625 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_cgetc>:

int
sys_cgetc(void)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 01                	push   $0x1
  801688:	e8 98 ff ff ff       	call   801625 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	50                   	push   %eax
  8016a1:	6a 05                	push   $0x5
  8016a3:	e8 7d ff ff ff       	call   801625 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 02                	push   $0x2
  8016bc:	e8 64 ff ff ff       	call   801625 <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 03                	push   $0x3
  8016d5:	e8 4b ff ff ff       	call   801625 <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 04                	push   $0x4
  8016ee:	e8 32 ff ff ff       	call   801625 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_env_exit>:


void sys_env_exit(void)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 06                	push   $0x6
  801707:	e8 19 ff ff ff       	call   801625 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 07                	push   $0x7
  801725:	e8 fb fe ff ff       	call   801625 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801734:	8b 75 18             	mov    0x18(%ebp),%esi
  801737:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	51                   	push   %ecx
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	6a 08                	push   $0x8
  80174a:	e8 d6 fe ff ff       	call   801625 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	52                   	push   %edx
  801769:	50                   	push   %eax
  80176a:	6a 09                	push   $0x9
  80176c:	e8 b4 fe ff ff       	call   801625 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	6a 0a                	push   $0xa
  801787:	e8 99 fe ff ff       	call   801625 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 0b                	push   $0xb
  8017a0:	e8 80 fe ff ff       	call   801625 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 0c                	push   $0xc
  8017b9:	e8 67 fe ff ff       	call   801625 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 0d                	push   $0xd
  8017d2:	e8 4e fe ff ff       	call   801625 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	6a 11                	push   $0x11
  8017ed:	e8 33 fe ff ff       	call   801625 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
	return;
  8017f5:	90                   	nop
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 12                	push   $0x12
  801809:	e8 17 fe ff ff       	call   801625 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return ;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 0e                	push   $0xe
  801823:	e8 fd fd ff ff       	call   801625 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	6a 0f                	push   $0xf
  80183d:	e8 e3 fd ff ff       	call   801625 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 10                	push   $0x10
  801856:	e8 ca fd ff ff       	call   801625 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 14                	push   $0x14
  801870:	e8 b0 fd ff ff       	call   801625 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 15                	push   $0x15
  80188a:	e8 96 fd ff ff       	call   801625 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	90                   	nop
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_cputc>:


void
sys_cputc(const char c)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	50                   	push   %eax
  8018ae:	6a 16                	push   $0x16
  8018b0:	e8 70 fd ff ff       	call   801625 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 17                	push   $0x17
  8018ca:	e8 56 fd ff ff       	call   801625 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	50                   	push   %eax
  8018e5:	6a 18                	push   $0x18
  8018e7:	e8 39 fd ff ff       	call   801625 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 1b                	push   $0x1b
  801904:	e8 1c fd ff ff       	call   801625 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801911:	8b 55 0c             	mov    0xc(%ebp),%edx
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 19                	push   $0x19
  801921:	e8 ff fc ff ff       	call   801625 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	90                   	nop
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	52                   	push   %edx
  80193c:	50                   	push   %eax
  80193d:	6a 1a                	push   $0x1a
  80193f:	e8 e1 fc ff ff       	call   801625 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 45 10             	mov    0x10(%ebp),%eax
  801953:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801956:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801959:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	51                   	push   %ecx
  801963:	52                   	push   %edx
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	50                   	push   %eax
  801968:	6a 1c                	push   $0x1c
  80196a:	e8 b6 fc ff ff       	call   801625 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	6a 1d                	push   $0x1d
  801987:	e8 99 fc ff ff       	call   801625 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801994:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	51                   	push   %ecx
  8019a2:	52                   	push   %edx
  8019a3:	50                   	push   %eax
  8019a4:	6a 1e                	push   $0x1e
  8019a6:	e8 7a fc ff ff       	call   801625 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 1f                	push   $0x1f
  8019c3:	e8 5d fc ff ff       	call   801625 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 20                	push   $0x20
  8019dc:	e8 44 fc ff ff       	call   801625 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 14             	pushl  0x14(%ebp)
  8019f1:	ff 75 10             	pushl  0x10(%ebp)
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	50                   	push   %eax
  8019f8:	6a 21                	push   $0x21
  8019fa:	e8 26 fc ff ff       	call   801625 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	50                   	push   %eax
  801a13:	6a 22                	push   $0x22
  801a15:	e8 0b fc ff ff       	call   801625 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	90                   	nop
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	50                   	push   %eax
  801a2f:	6a 23                	push   $0x23
  801a31:	e8 ef fb ff ff       	call   801625 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a42:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a45:	8d 50 04             	lea    0x4(%eax),%edx
  801a48:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	52                   	push   %edx
  801a52:	50                   	push   %eax
  801a53:	6a 24                	push   $0x24
  801a55:	e8 cb fb ff ff       	call   801625 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
	return result;
  801a5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	89 01                	mov    %eax,(%ecx)
  801a68:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	c9                   	leave  
  801a6f:	c2 04 00             	ret    $0x4

00801a72 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	ff 75 10             	pushl  0x10(%ebp)
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	6a 13                	push   $0x13
  801a84:	e8 9c fb ff ff       	call   801625 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8c:	90                   	nop
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_rcr2>:
uint32 sys_rcr2()
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 25                	push   $0x25
  801a9e:	e8 82 fb ff ff       	call   801625 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	50                   	push   %eax
  801ac1:	6a 26                	push   $0x26
  801ac3:	e8 5d fb ff ff       	call   801625 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
	return ;
  801acb:	90                   	nop
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <rsttst>:
void rsttst()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 28                	push   $0x28
  801add:	e8 43 fb ff ff       	call   801625 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae5:	90                   	nop
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	8b 45 14             	mov    0x14(%ebp),%eax
  801af1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af4:	8b 55 18             	mov    0x18(%ebp),%edx
  801af7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801afb:	52                   	push   %edx
  801afc:	50                   	push   %eax
  801afd:	ff 75 10             	pushl  0x10(%ebp)
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	6a 27                	push   $0x27
  801b08:	e8 18 fb ff ff       	call   801625 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <chktst>:
void chktst(uint32 n)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	6a 29                	push   $0x29
  801b23:	e8 fd fa ff ff       	call   801625 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2b:	90                   	nop
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <inctst>:

void inctst()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 2a                	push   $0x2a
  801b3d:	e8 e3 fa ff ff       	call   801625 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
	return ;
  801b45:	90                   	nop
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <gettst>:
uint32 gettst()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 2b                	push   $0x2b
  801b57:	e8 c9 fa ff ff       	call   801625 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 2c                	push   $0x2c
  801b73:	e8 ad fa ff ff       	call   801625 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
  801b7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b7e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b82:	75 07                	jne    801b8b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b84:	b8 01 00 00 00       	mov    $0x1,%eax
  801b89:	eb 05                	jmp    801b90 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 2c                	push   $0x2c
  801ba4:	e8 7c fa ff ff       	call   801625 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
  801bac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801baf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb3:	75 07                	jne    801bbc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bba:	eb 05                	jmp    801bc1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 2c                	push   $0x2c
  801bd5:	e8 4b fa ff ff       	call   801625 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
  801bdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be4:	75 07                	jne    801bed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801be6:	b8 01 00 00 00       	mov    $0x1,%eax
  801beb:	eb 05                	jmp    801bf2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 2c                	push   $0x2c
  801c06:	e8 1a fa ff ff       	call   801625 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
  801c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c11:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c15:	75 07                	jne    801c1e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c17:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1c:	eb 05                	jmp    801c23 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	6a 2d                	push   $0x2d
  801c35:	e8 eb f9 ff ff       	call   801625 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c44:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	53                   	push   %ebx
  801c53:	51                   	push   %ecx
  801c54:	52                   	push   %edx
  801c55:	50                   	push   %eax
  801c56:	6a 2e                	push   $0x2e
  801c58:	e8 c8 f9 ff ff       	call   801625 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	6a 2f                	push   $0x2f
  801c78:	e8 a8 f9 ff ff       	call   801625 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801c88:	8d 45 10             	lea    0x10(%ebp),%eax
  801c8b:	83 c0 04             	add    $0x4,%eax
  801c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801c91:	a1 40 31 a0 00       	mov    0xa03140,%eax
  801c96:	85 c0                	test   %eax,%eax
  801c98:	74 16                	je     801cb0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801c9a:	a1 40 31 a0 00       	mov    0xa03140,%eax
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	50                   	push   %eax
  801ca3:	68 88 25 80 00       	push   $0x802588
  801ca8:	e8 85 e6 ff ff       	call   800332 <cprintf>
  801cad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801cb0:	a1 00 30 80 00       	mov    0x803000,%eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	ff 75 08             	pushl  0x8(%ebp)
  801cbb:	50                   	push   %eax
  801cbc:	68 8d 25 80 00       	push   $0x80258d
  801cc1:	e8 6c e6 ff ff       	call   800332 <cprintf>
  801cc6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	83 ec 08             	sub    $0x8,%esp
  801ccf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd2:	50                   	push   %eax
  801cd3:	e8 ef e5 ff ff       	call   8002c7 <vcprintf>
  801cd8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801cdb:	83 ec 08             	sub    $0x8,%esp
  801cde:	6a 00                	push   $0x0
  801ce0:	68 a9 25 80 00       	push   $0x8025a9
  801ce5:	e8 dd e5 ff ff       	call   8002c7 <vcprintf>
  801cea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ced:	e8 5e e5 ff ff       	call   800250 <exit>

	// should not return here
	while (1) ;
  801cf2:	eb fe                	jmp    801cf2 <_panic+0x70>

00801cf4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801cfa:	a1 20 30 80 00       	mov    0x803020,%eax
  801cff:	8b 50 74             	mov    0x74(%eax),%edx
  801d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d05:	39 c2                	cmp    %eax,%edx
  801d07:	74 14                	je     801d1d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 ac 25 80 00       	push   $0x8025ac
  801d11:	6a 26                	push   $0x26
  801d13:	68 f8 25 80 00       	push   $0x8025f8
  801d18:	e8 65 ff ff ff       	call   801c82 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801d1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801d24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801d2b:	e9 b6 00 00 00       	jmp    801de6 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	01 d0                	add    %edx,%eax
  801d3f:	8b 00                	mov    (%eax),%eax
  801d41:	85 c0                	test   %eax,%eax
  801d43:	75 08                	jne    801d4d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801d45:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801d48:	e9 96 00 00 00       	jmp    801de3 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801d4d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d5b:	eb 5d                	jmp    801dba <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801d5d:	a1 20 30 80 00       	mov    0x803020,%eax
  801d62:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801d68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d6b:	c1 e2 04             	shl    $0x4,%edx
  801d6e:	01 d0                	add    %edx,%eax
  801d70:	8a 40 04             	mov    0x4(%eax),%al
  801d73:	84 c0                	test   %al,%al
  801d75:	75 40                	jne    801db7 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d77:	a1 20 30 80 00       	mov    0x803020,%eax
  801d7c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801d82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d85:	c1 e2 04             	shl    $0x4,%edx
  801d88:	01 d0                	add    %edx,%eax
  801d8a:	8b 00                	mov    (%eax),%eax
  801d8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d97:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	01 c8                	add    %ecx,%eax
  801da8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801daa:	39 c2                	cmp    %eax,%edx
  801dac:	75 09                	jne    801db7 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801dae:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801db5:	eb 12                	jmp    801dc9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801db7:	ff 45 e8             	incl   -0x18(%ebp)
  801dba:	a1 20 30 80 00       	mov    0x803020,%eax
  801dbf:	8b 50 74             	mov    0x74(%eax),%edx
  801dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc5:	39 c2                	cmp    %eax,%edx
  801dc7:	77 94                	ja     801d5d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801dc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dcd:	75 14                	jne    801de3 <CheckWSWithoutLastIndex+0xef>
			panic(
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	68 04 26 80 00       	push   $0x802604
  801dd7:	6a 3a                	push   $0x3a
  801dd9:	68 f8 25 80 00       	push   $0x8025f8
  801dde:	e8 9f fe ff ff       	call   801c82 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801de3:	ff 45 f0             	incl   -0x10(%ebp)
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dec:	0f 8c 3e ff ff ff    	jl     801d30 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801df2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801df9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e00:	eb 20                	jmp    801e22 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801e02:	a1 20 30 80 00       	mov    0x803020,%eax
  801e07:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801e0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e10:	c1 e2 04             	shl    $0x4,%edx
  801e13:	01 d0                	add    %edx,%eax
  801e15:	8a 40 04             	mov    0x4(%eax),%al
  801e18:	3c 01                	cmp    $0x1,%al
  801e1a:	75 03                	jne    801e1f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801e1c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801e1f:	ff 45 e0             	incl   -0x20(%ebp)
  801e22:	a1 20 30 80 00       	mov    0x803020,%eax
  801e27:	8b 50 74             	mov    0x74(%eax),%edx
  801e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2d:	39 c2                	cmp    %eax,%edx
  801e2f:	77 d1                	ja     801e02 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e37:	74 14                	je     801e4d <CheckWSWithoutLastIndex+0x159>
		panic(
  801e39:	83 ec 04             	sub    $0x4,%esp
  801e3c:	68 58 26 80 00       	push   $0x802658
  801e41:	6a 44                	push   $0x44
  801e43:	68 f8 25 80 00       	push   $0x8025f8
  801e48:	e8 35 fe ff ff       	call   801c82 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <__udivdi3>:
  801e50:	55                   	push   %ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 1c             	sub    $0x1c,%esp
  801e57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e67:	89 ca                	mov    %ecx,%edx
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e6f:	85 f6                	test   %esi,%esi
  801e71:	75 2d                	jne    801ea0 <__udivdi3+0x50>
  801e73:	39 cf                	cmp    %ecx,%edi
  801e75:	77 65                	ja     801edc <__udivdi3+0x8c>
  801e77:	89 fd                	mov    %edi,%ebp
  801e79:	85 ff                	test   %edi,%edi
  801e7b:	75 0b                	jne    801e88 <__udivdi3+0x38>
  801e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	f7 f7                	div    %edi
  801e86:	89 c5                	mov    %eax,%ebp
  801e88:	31 d2                	xor    %edx,%edx
  801e8a:	89 c8                	mov    %ecx,%eax
  801e8c:	f7 f5                	div    %ebp
  801e8e:	89 c1                	mov    %eax,%ecx
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	f7 f5                	div    %ebp
  801e94:	89 cf                	mov    %ecx,%edi
  801e96:	89 fa                	mov    %edi,%edx
  801e98:	83 c4 1c             	add    $0x1c,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5f                   	pop    %edi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
  801ea0:	39 ce                	cmp    %ecx,%esi
  801ea2:	77 28                	ja     801ecc <__udivdi3+0x7c>
  801ea4:	0f bd fe             	bsr    %esi,%edi
  801ea7:	83 f7 1f             	xor    $0x1f,%edi
  801eaa:	75 40                	jne    801eec <__udivdi3+0x9c>
  801eac:	39 ce                	cmp    %ecx,%esi
  801eae:	72 0a                	jb     801eba <__udivdi3+0x6a>
  801eb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801eb4:	0f 87 9e 00 00 00    	ja     801f58 <__udivdi3+0x108>
  801eba:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebf:	89 fa                	mov    %edi,%edx
  801ec1:	83 c4 1c             	add    $0x1c,%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5f                   	pop    %edi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    
  801ec9:	8d 76 00             	lea    0x0(%esi),%esi
  801ecc:	31 ff                	xor    %edi,%edi
  801ece:	31 c0                	xor    %eax,%eax
  801ed0:	89 fa                	mov    %edi,%edx
  801ed2:	83 c4 1c             	add    $0x1c,%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	f7 f7                	div    %edi
  801ee0:	31 ff                	xor    %edi,%edi
  801ee2:	89 fa                	mov    %edi,%edx
  801ee4:	83 c4 1c             	add    $0x1c,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
  801eec:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ef1:	89 eb                	mov    %ebp,%ebx
  801ef3:	29 fb                	sub    %edi,%ebx
  801ef5:	89 f9                	mov    %edi,%ecx
  801ef7:	d3 e6                	shl    %cl,%esi
  801ef9:	89 c5                	mov    %eax,%ebp
  801efb:	88 d9                	mov    %bl,%cl
  801efd:	d3 ed                	shr    %cl,%ebp
  801eff:	89 e9                	mov    %ebp,%ecx
  801f01:	09 f1                	or     %esi,%ecx
  801f03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f07:	89 f9                	mov    %edi,%ecx
  801f09:	d3 e0                	shl    %cl,%eax
  801f0b:	89 c5                	mov    %eax,%ebp
  801f0d:	89 d6                	mov    %edx,%esi
  801f0f:	88 d9                	mov    %bl,%cl
  801f11:	d3 ee                	shr    %cl,%esi
  801f13:	89 f9                	mov    %edi,%ecx
  801f15:	d3 e2                	shl    %cl,%edx
  801f17:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f1b:	88 d9                	mov    %bl,%cl
  801f1d:	d3 e8                	shr    %cl,%eax
  801f1f:	09 c2                	or     %eax,%edx
  801f21:	89 d0                	mov    %edx,%eax
  801f23:	89 f2                	mov    %esi,%edx
  801f25:	f7 74 24 0c          	divl   0xc(%esp)
  801f29:	89 d6                	mov    %edx,%esi
  801f2b:	89 c3                	mov    %eax,%ebx
  801f2d:	f7 e5                	mul    %ebp
  801f2f:	39 d6                	cmp    %edx,%esi
  801f31:	72 19                	jb     801f4c <__udivdi3+0xfc>
  801f33:	74 0b                	je     801f40 <__udivdi3+0xf0>
  801f35:	89 d8                	mov    %ebx,%eax
  801f37:	31 ff                	xor    %edi,%edi
  801f39:	e9 58 ff ff ff       	jmp    801e96 <__udivdi3+0x46>
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f44:	89 f9                	mov    %edi,%ecx
  801f46:	d3 e2                	shl    %cl,%edx
  801f48:	39 c2                	cmp    %eax,%edx
  801f4a:	73 e9                	jae    801f35 <__udivdi3+0xe5>
  801f4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f4f:	31 ff                	xor    %edi,%edi
  801f51:	e9 40 ff ff ff       	jmp    801e96 <__udivdi3+0x46>
  801f56:	66 90                	xchg   %ax,%ax
  801f58:	31 c0                	xor    %eax,%eax
  801f5a:	e9 37 ff ff ff       	jmp    801e96 <__udivdi3+0x46>
  801f5f:	90                   	nop

00801f60 <__umoddi3>:
  801f60:	55                   	push   %ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	83 ec 1c             	sub    $0x1c,%esp
  801f67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f7f:	89 f3                	mov    %esi,%ebx
  801f81:	89 fa                	mov    %edi,%edx
  801f83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f87:	89 34 24             	mov    %esi,(%esp)
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	75 1a                	jne    801fa8 <__umoddi3+0x48>
  801f8e:	39 f7                	cmp    %esi,%edi
  801f90:	0f 86 a2 00 00 00    	jbe    802038 <__umoddi3+0xd8>
  801f96:	89 c8                	mov    %ecx,%eax
  801f98:	89 f2                	mov    %esi,%edx
  801f9a:	f7 f7                	div    %edi
  801f9c:	89 d0                	mov    %edx,%eax
  801f9e:	31 d2                	xor    %edx,%edx
  801fa0:	83 c4 1c             	add    $0x1c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    
  801fa8:	39 f0                	cmp    %esi,%eax
  801faa:	0f 87 ac 00 00 00    	ja     80205c <__umoddi3+0xfc>
  801fb0:	0f bd e8             	bsr    %eax,%ebp
  801fb3:	83 f5 1f             	xor    $0x1f,%ebp
  801fb6:	0f 84 ac 00 00 00    	je     802068 <__umoddi3+0x108>
  801fbc:	bf 20 00 00 00       	mov    $0x20,%edi
  801fc1:	29 ef                	sub    %ebp,%edi
  801fc3:	89 fe                	mov    %edi,%esi
  801fc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fc9:	89 e9                	mov    %ebp,%ecx
  801fcb:	d3 e0                	shl    %cl,%eax
  801fcd:	89 d7                	mov    %edx,%edi
  801fcf:	89 f1                	mov    %esi,%ecx
  801fd1:	d3 ef                	shr    %cl,%edi
  801fd3:	09 c7                	or     %eax,%edi
  801fd5:	89 e9                	mov    %ebp,%ecx
  801fd7:	d3 e2                	shl    %cl,%edx
  801fd9:	89 14 24             	mov    %edx,(%esp)
  801fdc:	89 d8                	mov    %ebx,%eax
  801fde:	d3 e0                	shl    %cl,%eax
  801fe0:	89 c2                	mov    %eax,%edx
  801fe2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fe6:	d3 e0                	shl    %cl,%eax
  801fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fec:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ff0:	89 f1                	mov    %esi,%ecx
  801ff2:	d3 e8                	shr    %cl,%eax
  801ff4:	09 d0                	or     %edx,%eax
  801ff6:	d3 eb                	shr    %cl,%ebx
  801ff8:	89 da                	mov    %ebx,%edx
  801ffa:	f7 f7                	div    %edi
  801ffc:	89 d3                	mov    %edx,%ebx
  801ffe:	f7 24 24             	mull   (%esp)
  802001:	89 c6                	mov    %eax,%esi
  802003:	89 d1                	mov    %edx,%ecx
  802005:	39 d3                	cmp    %edx,%ebx
  802007:	0f 82 87 00 00 00    	jb     802094 <__umoddi3+0x134>
  80200d:	0f 84 91 00 00 00    	je     8020a4 <__umoddi3+0x144>
  802013:	8b 54 24 04          	mov    0x4(%esp),%edx
  802017:	29 f2                	sub    %esi,%edx
  802019:	19 cb                	sbb    %ecx,%ebx
  80201b:	89 d8                	mov    %ebx,%eax
  80201d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802021:	d3 e0                	shl    %cl,%eax
  802023:	89 e9                	mov    %ebp,%ecx
  802025:	d3 ea                	shr    %cl,%edx
  802027:	09 d0                	or     %edx,%eax
  802029:	89 e9                	mov    %ebp,%ecx
  80202b:	d3 eb                	shr    %cl,%ebx
  80202d:	89 da                	mov    %ebx,%edx
  80202f:	83 c4 1c             	add    $0x1c,%esp
  802032:	5b                   	pop    %ebx
  802033:	5e                   	pop    %esi
  802034:	5f                   	pop    %edi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    
  802037:	90                   	nop
  802038:	89 fd                	mov    %edi,%ebp
  80203a:	85 ff                	test   %edi,%edi
  80203c:	75 0b                	jne    802049 <__umoddi3+0xe9>
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	31 d2                	xor    %edx,%edx
  802045:	f7 f7                	div    %edi
  802047:	89 c5                	mov    %eax,%ebp
  802049:	89 f0                	mov    %esi,%eax
  80204b:	31 d2                	xor    %edx,%edx
  80204d:	f7 f5                	div    %ebp
  80204f:	89 c8                	mov    %ecx,%eax
  802051:	f7 f5                	div    %ebp
  802053:	89 d0                	mov    %edx,%eax
  802055:	e9 44 ff ff ff       	jmp    801f9e <__umoddi3+0x3e>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	89 c8                	mov    %ecx,%eax
  80205e:	89 f2                	mov    %esi,%edx
  802060:	83 c4 1c             	add    $0x1c,%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5f                   	pop    %edi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    
  802068:	3b 04 24             	cmp    (%esp),%eax
  80206b:	72 06                	jb     802073 <__umoddi3+0x113>
  80206d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802071:	77 0f                	ja     802082 <__umoddi3+0x122>
  802073:	89 f2                	mov    %esi,%edx
  802075:	29 f9                	sub    %edi,%ecx
  802077:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80207b:	89 14 24             	mov    %edx,(%esp)
  80207e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802082:	8b 44 24 04          	mov    0x4(%esp),%eax
  802086:	8b 14 24             	mov    (%esp),%edx
  802089:	83 c4 1c             	add    $0x1c,%esp
  80208c:	5b                   	pop    %ebx
  80208d:	5e                   	pop    %esi
  80208e:	5f                   	pop    %edi
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    
  802091:	8d 76 00             	lea    0x0(%esi),%esi
  802094:	2b 04 24             	sub    (%esp),%eax
  802097:	19 fa                	sbb    %edi,%edx
  802099:	89 d1                	mov    %edx,%ecx
  80209b:	89 c6                	mov    %eax,%esi
  80209d:	e9 71 ff ff ff       	jmp    802013 <__umoddi3+0xb3>
  8020a2:	66 90                	xchg   %ax,%ax
  8020a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020a8:	72 ea                	jb     802094 <__umoddi3+0x134>
  8020aa:	89 d9                	mov    %ebx,%ecx
  8020ac:	e9 62 ff ff ff       	jmp    802013 <__umoddi3+0xb3>
