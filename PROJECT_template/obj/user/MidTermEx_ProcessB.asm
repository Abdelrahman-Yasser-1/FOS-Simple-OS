
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 ee 16 00 00       	call   801731 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 c0 21 80 00       	push   $0x8021c0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 73 15 00 00       	call   8015c9 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c2 21 80 00       	push   $0x8021c2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 5d 15 00 00       	call   8015c9 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c9 21 80 00       	push   $0x8021c9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 47 15 00 00       	call   8015c9 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 d7 21 80 00       	push   $0x8021d7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 be 18 00 00       	call   801960 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 dd 19 00 00       	call   801a8e <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 fb 1b 00 00       	call   801cd4 <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 9d 19 00 00       	call   801a8e <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 bb 1b 00 00       	call   801cd4 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 5e 19 00 00       	call   801a8e <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 7c 1b 00 00       	call   801cd4 <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 a2 15 00 00       	call   801718 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018a:	01 c8                	add    %ecx,%eax
  80018c:	01 c0                	add    %eax,%eax
  80018e:	01 d0                	add    %edx,%eax
  800190:	01 c0                	add    %eax,%eax
  800192:	01 d0                	add    %edx,%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	c1 e2 05             	shl    $0x5,%edx
  800199:	29 c2                	sub    %eax,%edx
  80019b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001a2:	89 c2                	mov    %eax,%edx
  8001a4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001aa:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001af:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b4:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001ba:	84 c0                	test   %al,%al
  8001bc:	74 0f                	je     8001cd <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001be:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c3:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001c8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d1:	7e 0a                	jle    8001dd <libmain+0x72>
		binaryname = argv[0];
  8001d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d6:	8b 00                	mov    (%eax),%eax
  8001d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	ff 75 0c             	pushl  0xc(%ebp)
  8001e3:	ff 75 08             	pushl  0x8(%ebp)
  8001e6:	e8 4d fe ff ff       	call   800038 <_main>
  8001eb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ee:	e8 c0 16 00 00       	call   8018b3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	68 f4 21 80 00       	push   $0x8021f4
  8001fb:	e8 84 01 00 00       	call   800384 <cprintf>
  800200:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	52                   	push   %edx
  80021d:	50                   	push   %eax
  80021e:	68 1c 22 80 00       	push   $0x80221c
  800223:	e8 5c 01 00 00       	call   800384 <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80022b:	a1 20 30 80 00       	mov    0x803020,%eax
  800230:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800236:	a1 20 30 80 00       	mov    0x803020,%eax
  80023b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	52                   	push   %edx
  800245:	50                   	push   %eax
  800246:	68 44 22 80 00       	push   $0x802244
  80024b:	e8 34 01 00 00       	call   800384 <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800253:	a1 20 30 80 00       	mov    0x803020,%eax
  800258:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	50                   	push   %eax
  800262:	68 85 22 80 00       	push   $0x802285
  800267:	e8 18 01 00 00       	call   800384 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 f4 21 80 00       	push   $0x8021f4
  800277:	e8 08 01 00 00       	call   800384 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80027f:	e8 49 16 00 00       	call   8018cd <sys_enable_interrupt>

	// exit gracefully
	exit();
  800284:	e8 19 00 00 00       	call   8002a2 <exit>
}
  800289:	90                   	nop
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 00                	push   $0x0
  800297:	e8 48 14 00 00       	call   8016e4 <sys_env_destroy>
  80029c:	83 c4 10             	add    $0x10,%esp
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <exit>:

void
exit(void)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002a8:	e8 9d 14 00 00       	call   80174a <sys_env_exit>
}
  8002ad:	90                   	nop
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b9:	8b 00                	mov    (%eax),%eax
  8002bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8002be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c1:	89 0a                	mov    %ecx,(%edx)
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c6:	88 d1                	mov    %dl,%cl
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	8b 00                	mov    (%eax),%eax
  8002d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d9:	75 2c                	jne    800307 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002db:	a0 24 30 80 00       	mov    0x803024,%al
  8002e0:	0f b6 c0             	movzbl %al,%eax
  8002e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e6:	8b 12                	mov    (%edx),%edx
  8002e8:	89 d1                	mov    %edx,%ecx
  8002ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ed:	83 c2 08             	add    $0x8,%edx
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	50                   	push   %eax
  8002f4:	51                   	push   %ecx
  8002f5:	52                   	push   %edx
  8002f6:	e8 a7 13 00 00       	call   8016a2 <sys_cputs>
  8002fb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	8b 40 04             	mov    0x4(%eax),%eax
  80030d:	8d 50 01             	lea    0x1(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	89 50 04             	mov    %edx,0x4(%eax)
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800322:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800329:	00 00 00 
	b.cnt = 0;
  80032c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800333:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800336:	ff 75 0c             	pushl  0xc(%ebp)
  800339:	ff 75 08             	pushl  0x8(%ebp)
  80033c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800342:	50                   	push   %eax
  800343:	68 b0 02 80 00       	push   $0x8002b0
  800348:	e8 11 02 00 00       	call   80055e <vprintfmt>
  80034d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800350:	a0 24 30 80 00       	mov    0x803024,%al
  800355:	0f b6 c0             	movzbl %al,%eax
  800358:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	50                   	push   %eax
  800362:	52                   	push   %edx
  800363:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800369:	83 c0 08             	add    $0x8,%eax
  80036c:	50                   	push   %eax
  80036d:	e8 30 13 00 00       	call   8016a2 <sys_cputs>
  800372:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800375:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80037c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <cprintf>:

int cprintf(const char *fmt, ...) {
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80038a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800391:	8d 45 0c             	lea    0xc(%ebp),%eax
  800394:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a0:	50                   	push   %eax
  8003a1:	e8 73 ff ff ff       	call   800319 <vcprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    

008003b1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003b7:	e8 f7 14 00 00       	call   8018b3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cb:	50                   	push   %eax
  8003cc:	e8 48 ff ff ff       	call   800319 <vcprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003d7:	e8 f1 14 00 00       	call   8018cd <sys_enable_interrupt>
	return cnt;
  8003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	53                   	push   %ebx
  8003e5:	83 ec 14             	sub    $0x14,%esp
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003ff:	77 55                	ja     800456 <printnum+0x75>
  800401:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800404:	72 05                	jb     80040b <printnum+0x2a>
  800406:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800409:	77 4b                	ja     800456 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80040b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80040e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800411:	8b 45 18             	mov    0x18(%ebp),%eax
  800414:	ba 00 00 00 00       	mov    $0x0,%edx
  800419:	52                   	push   %edx
  80041a:	50                   	push   %eax
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	ff 75 f0             	pushl  -0x10(%ebp)
  800421:	e8 32 1b 00 00       	call   801f58 <__udivdi3>
  800426:	83 c4 10             	add    $0x10,%esp
  800429:	83 ec 04             	sub    $0x4,%esp
  80042c:	ff 75 20             	pushl  0x20(%ebp)
  80042f:	53                   	push   %ebx
  800430:	ff 75 18             	pushl  0x18(%ebp)
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	ff 75 0c             	pushl  0xc(%ebp)
  800438:	ff 75 08             	pushl  0x8(%ebp)
  80043b:	e8 a1 ff ff ff       	call   8003e1 <printnum>
  800440:	83 c4 20             	add    $0x20,%esp
  800443:	eb 1a                	jmp    80045f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	ff 75 0c             	pushl  0xc(%ebp)
  80044b:	ff 75 20             	pushl  0x20(%ebp)
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800456:	ff 4d 1c             	decl   0x1c(%ebp)
  800459:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80045d:	7f e6                	jg     800445 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800462:	bb 00 00 00 00       	mov    $0x0,%ebx
  800467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80046d:	53                   	push   %ebx
  80046e:	51                   	push   %ecx
  80046f:	52                   	push   %edx
  800470:	50                   	push   %eax
  800471:	e8 f2 1b 00 00       	call   802068 <__umoddi3>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	05 b4 24 80 00       	add    $0x8024b4,%eax
  80047e:	8a 00                	mov    (%eax),%al
  800480:	0f be c0             	movsbl %al,%eax
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	50                   	push   %eax
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	ff d0                	call   *%eax
  80048f:	83 c4 10             	add    $0x10,%esp
}
  800492:	90                   	nop
  800493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800496:	c9                   	leave  
  800497:	c3                   	ret    

00800498 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80049b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80049f:	7e 1c                	jle    8004bd <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	8d 50 08             	lea    0x8(%eax),%edx
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	89 10                	mov    %edx,(%eax)
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	83 e8 08             	sub    $0x8,%eax
  8004b6:	8b 50 04             	mov    0x4(%eax),%edx
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	eb 40                	jmp    8004fd <getuint+0x65>
	else if (lflag)
  8004bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c1:	74 1e                	je     8004e1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	8d 50 04             	lea    0x4(%eax),%edx
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 10                	mov    %edx,(%eax)
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	83 e8 04             	sub    $0x4,%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	ba 00 00 00 00       	mov    $0x0,%edx
  8004df:	eb 1c                	jmp    8004fd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 50 04             	lea    0x4(%eax),%edx
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	89 10                	mov    %edx,(%eax)
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	83 e8 04             	sub    $0x4,%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800502:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800506:	7e 1c                	jle    800524 <getint+0x25>
		return va_arg(*ap, long long);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 08             	lea    0x8(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 08             	sub    $0x8,%eax
  80051d:	8b 50 04             	mov    0x4(%eax),%edx
  800520:	8b 00                	mov    (%eax),%eax
  800522:	eb 38                	jmp    80055c <getint+0x5d>
	else if (lflag)
  800524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800528:	74 1a                	je     800544 <getint+0x45>
		return va_arg(*ap, long);
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	8d 50 04             	lea    0x4(%eax),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	89 10                	mov    %edx,(%eax)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	83 e8 04             	sub    $0x4,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	99                   	cltd   
  800542:	eb 18                	jmp    80055c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	8d 50 04             	lea    0x4(%eax),%edx
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	89 10                	mov    %edx,(%eax)
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	83 e8 04             	sub    $0x4,%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	99                   	cltd   
}
  80055c:	5d                   	pop    %ebp
  80055d:	c3                   	ret    

0080055e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	56                   	push   %esi
  800562:	53                   	push   %ebx
  800563:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800566:	eb 17                	jmp    80057f <vprintfmt+0x21>
			if (ch == '\0')
  800568:	85 db                	test   %ebx,%ebx
  80056a:	0f 84 af 03 00 00    	je     80091f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 0c             	pushl  0xc(%ebp)
  800576:	53                   	push   %ebx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	ff d0                	call   *%eax
  80057c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f b6 d8             	movzbl %al,%ebx
  80058d:	83 fb 25             	cmp    $0x25,%ebx
  800590:	75 d6                	jne    800568 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800592:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800596:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80059d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b5:	8d 50 01             	lea    0x1(%eax),%edx
  8005b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bb:	8a 00                	mov    (%eax),%al
  8005bd:	0f b6 d8             	movzbl %al,%ebx
  8005c0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c3:	83 f8 55             	cmp    $0x55,%eax
  8005c6:	0f 87 2b 03 00 00    	ja     8008f7 <vprintfmt+0x399>
  8005cc:	8b 04 85 d8 24 80 00 	mov    0x8024d8(,%eax,4),%eax
  8005d3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d9:	eb d7                	jmp    8005b2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005db:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005df:	eb d1                	jmp    8005b2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005eb:	89 d0                	mov    %edx,%eax
  8005ed:	c1 e0 02             	shl    $0x2,%eax
  8005f0:	01 d0                	add    %edx,%eax
  8005f2:	01 c0                	add    %eax,%eax
  8005f4:	01 d8                	add    %ebx,%eax
  8005f6:	83 e8 30             	sub    $0x30,%eax
  8005f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ff:	8a 00                	mov    (%eax),%al
  800601:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800604:	83 fb 2f             	cmp    $0x2f,%ebx
  800607:	7e 3e                	jle    800647 <vprintfmt+0xe9>
  800609:	83 fb 39             	cmp    $0x39,%ebx
  80060c:	7f 39                	jg     800647 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80060e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800611:	eb d5                	jmp    8005e8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 c0 04             	add    $0x4,%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	83 e8 04             	sub    $0x4,%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800627:	eb 1f                	jmp    800648 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062d:	79 83                	jns    8005b2 <vprintfmt+0x54>
				width = 0;
  80062f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800636:	e9 77 ff ff ff       	jmp    8005b2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80063b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800642:	e9 6b ff ff ff       	jmp    8005b2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800647:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	0f 89 60 ff ff ff    	jns    8005b2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800658:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80065f:	e9 4e ff ff ff       	jmp    8005b2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800664:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800667:	e9 46 ff ff ff       	jmp    8005b2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 c0 04             	add    $0x4,%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	83 e8 04             	sub    $0x4,%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	50                   	push   %eax
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
			break;
  80068c:	e9 89 02 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 c0 04             	add    $0x4,%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	83 e8 04             	sub    $0x4,%eax
  8006a0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a2:	85 db                	test   %ebx,%ebx
  8006a4:	79 02                	jns    8006a8 <vprintfmt+0x14a>
				err = -err;
  8006a6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a8:	83 fb 64             	cmp    $0x64,%ebx
  8006ab:	7f 0b                	jg     8006b8 <vprintfmt+0x15a>
  8006ad:	8b 34 9d 20 23 80 00 	mov    0x802320(,%ebx,4),%esi
  8006b4:	85 f6                	test   %esi,%esi
  8006b6:	75 19                	jne    8006d1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b8:	53                   	push   %ebx
  8006b9:	68 c5 24 80 00       	push   $0x8024c5
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	ff 75 08             	pushl  0x8(%ebp)
  8006c4:	e8 5e 02 00 00       	call   800927 <printfmt>
  8006c9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006cc:	e9 49 02 00 00       	jmp    80091a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006d1:	56                   	push   %esi
  8006d2:	68 ce 24 80 00       	push   $0x8024ce
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	ff 75 08             	pushl  0x8(%ebp)
  8006dd:	e8 45 02 00 00       	call   800927 <printfmt>
  8006e2:	83 c4 10             	add    $0x10,%esp
			break;
  8006e5:	e9 30 02 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 c0 04             	add    $0x4,%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	83 e8 04             	sub    $0x4,%eax
  8006f9:	8b 30                	mov    (%eax),%esi
  8006fb:	85 f6                	test   %esi,%esi
  8006fd:	75 05                	jne    800704 <vprintfmt+0x1a6>
				p = "(null)";
  8006ff:	be d1 24 80 00       	mov    $0x8024d1,%esi
			if (width > 0 && padc != '-')
  800704:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800708:	7e 6d                	jle    800777 <vprintfmt+0x219>
  80070a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80070e:	74 67                	je     800777 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800710:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	50                   	push   %eax
  800717:	56                   	push   %esi
  800718:	e8 0c 03 00 00       	call   800a29 <strnlen>
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800723:	eb 16                	jmp    80073b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800725:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	50                   	push   %eax
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073f:	7f e4                	jg     800725 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800741:	eb 34                	jmp    800777 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800743:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800747:	74 1c                	je     800765 <vprintfmt+0x207>
  800749:	83 fb 1f             	cmp    $0x1f,%ebx
  80074c:	7e 05                	jle    800753 <vprintfmt+0x1f5>
  80074e:	83 fb 7e             	cmp    $0x7e,%ebx
  800751:	7e 12                	jle    800765 <vprintfmt+0x207>
					putch('?', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	6a 3f                	push   $0x3f
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	eb 0f                	jmp    800774 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	53                   	push   %ebx
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800774:	ff 4d e4             	decl   -0x1c(%ebp)
  800777:	89 f0                	mov    %esi,%eax
  800779:	8d 70 01             	lea    0x1(%eax),%esi
  80077c:	8a 00                	mov    (%eax),%al
  80077e:	0f be d8             	movsbl %al,%ebx
  800781:	85 db                	test   %ebx,%ebx
  800783:	74 24                	je     8007a9 <vprintfmt+0x24b>
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	78 b8                	js     800743 <vprintfmt+0x1e5>
  80078b:	ff 4d e0             	decl   -0x20(%ebp)
  80078e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800792:	79 af                	jns    800743 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800794:	eb 13                	jmp    8007a9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	6a 20                	push   $0x20
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	ff d0                	call   *%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ad:	7f e7                	jg     800796 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007af:	e9 66 01 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bd:	50                   	push   %eax
  8007be:	e8 3c fd ff ff       	call   8004ff <getint>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d2:	85 d2                	test   %edx,%edx
  8007d4:	79 23                	jns    8007f9 <vprintfmt+0x29b>
				putch('-', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	6a 2d                	push   $0x2d
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ec:	f7 d8                	neg    %eax
  8007ee:	83 d2 00             	adc    $0x0,%edx
  8007f1:	f7 da                	neg    %edx
  8007f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800800:	e9 bc 00 00 00       	jmp    8008c1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 e8             	pushl  -0x18(%ebp)
  80080b:	8d 45 14             	lea    0x14(%ebp),%eax
  80080e:	50                   	push   %eax
  80080f:	e8 84 fc ff ff       	call   800498 <getuint>
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80081d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800824:	e9 98 00 00 00       	jmp    8008c1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 58                	push   $0x58
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	6a 58                	push   $0x58
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	ff d0                	call   *%eax
  800846:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	6a 58                	push   $0x58
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	ff d0                	call   *%eax
  800856:	83 c4 10             	add    $0x10,%esp
			break;
  800859:	e9 bc 00 00 00       	jmp    80091a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 30                	push   $0x30
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 78                	push   $0x78
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80088f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800892:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800899:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008a0:	eb 1f                	jmp    8008c1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ab:	50                   	push   %eax
  8008ac:	e8 e7 fb ff ff       	call   800498 <getuint>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c8:	83 ec 04             	sub    $0x4,%esp
  8008cb:	52                   	push   %edx
  8008cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 00 fb ff ff       	call   8003e1 <printnum>
  8008e1:	83 c4 20             	add    $0x20,%esp
			break;
  8008e4:	eb 34                	jmp    80091a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	ff d0                	call   *%eax
  8008f2:	83 c4 10             	add    $0x10,%esp
			break;
  8008f5:	eb 23                	jmp    80091a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 25                	push   $0x25
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800907:	ff 4d 10             	decl   0x10(%ebp)
  80090a:	eb 03                	jmp    80090f <vprintfmt+0x3b1>
  80090c:	ff 4d 10             	decl   0x10(%ebp)
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
  800912:	48                   	dec    %eax
  800913:	8a 00                	mov    (%eax),%al
  800915:	3c 25                	cmp    $0x25,%al
  800917:	75 f3                	jne    80090c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800919:	90                   	nop
		}
	}
  80091a:	e9 47 fc ff ff       	jmp    800566 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80091f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800920:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800923:	5b                   	pop    %ebx
  800924:	5e                   	pop    %esi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80092d:	8d 45 10             	lea    0x10(%ebp),%eax
  800930:	83 c0 04             	add    $0x4,%eax
  800933:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800936:	8b 45 10             	mov    0x10(%ebp),%eax
  800939:	ff 75 f4             	pushl  -0xc(%ebp)
  80093c:	50                   	push   %eax
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	ff 75 08             	pushl  0x8(%ebp)
  800943:	e8 16 fc ff ff       	call   80055e <vprintfmt>
  800948:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80094b:	90                   	nop
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	8b 40 08             	mov    0x8(%eax),%eax
  800957:	8d 50 01             	lea    0x1(%eax),%edx
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800960:	8b 45 0c             	mov    0xc(%ebp),%eax
  800963:	8b 10                	mov    (%eax),%edx
  800965:	8b 45 0c             	mov    0xc(%ebp),%eax
  800968:	8b 40 04             	mov    0x4(%eax),%eax
  80096b:	39 c2                	cmp    %eax,%edx
  80096d:	73 12                	jae    800981 <sprintputch+0x33>
		*b->buf++ = ch;
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	8d 48 01             	lea    0x1(%eax),%ecx
  800977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097a:	89 0a                	mov    %ecx,(%edx)
  80097c:	8b 55 08             	mov    0x8(%ebp),%edx
  80097f:	88 10                	mov    %dl,(%eax)
}
  800981:	90                   	nop
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8d 50 ff             	lea    -0x1(%eax),%edx
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	01 d0                	add    %edx,%eax
  80099b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a9:	74 06                	je     8009b1 <vsnprintf+0x2d>
  8009ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009af:	7f 07                	jg     8009b8 <vsnprintf+0x34>
		return -E_INVAL;
  8009b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8009b6:	eb 20                	jmp    8009d8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b8:	ff 75 14             	pushl  0x14(%ebp)
  8009bb:	ff 75 10             	pushl  0x10(%ebp)
  8009be:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c1:	50                   	push   %eax
  8009c2:	68 4e 09 80 00       	push   $0x80094e
  8009c7:	e8 92 fb ff ff       	call   80055e <vprintfmt>
  8009cc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 10             	lea    0x10(%ebp),%eax
  8009e3:	83 c0 04             	add    $0x4,%eax
  8009e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	ff 75 08             	pushl  0x8(%ebp)
  8009f6:	e8 89 ff ff ff       	call   800984 <vsnprintf>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a13:	eb 06                	jmp    800a1b <strlen+0x15>
		n++;
  800a15:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a18:	ff 45 08             	incl   0x8(%ebp)
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	84 c0                	test   %al,%al
  800a22:	75 f1                	jne    800a15 <strlen+0xf>
		n++;
	return n;
  800a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a36:	eb 09                	jmp    800a41 <strnlen+0x18>
		n++;
  800a38:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	ff 45 08             	incl   0x8(%ebp)
  800a3e:	ff 4d 0c             	decl   0xc(%ebp)
  800a41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a45:	74 09                	je     800a50 <strnlen+0x27>
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	84 c0                	test   %al,%al
  800a4e:	75 e8                	jne    800a38 <strnlen+0xf>
		n++;
	return n;
  800a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a61:	90                   	nop
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8d 50 01             	lea    0x1(%eax),%edx
  800a68:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a74:	8a 12                	mov    (%edx),%dl
  800a76:	88 10                	mov    %dl,(%eax)
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	84 c0                	test   %al,%al
  800a7c:	75 e4                	jne    800a62 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a96:	eb 1f                	jmp    800ab7 <strncpy+0x34>
		*dst++ = *src;
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8d 50 01             	lea    0x1(%eax),%edx
  800a9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa4:	8a 12                	mov    (%edx),%dl
  800aa6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	84 c0                	test   %al,%al
  800aaf:	74 03                	je     800ab4 <strncpy+0x31>
			src++;
  800ab1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab4:	ff 45 fc             	incl   -0x4(%ebp)
  800ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aba:	3b 45 10             	cmp    0x10(%ebp),%eax
  800abd:	72 d9                	jb     800a98 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800abf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad4:	74 30                	je     800b06 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ad6:	eb 16                	jmp    800aee <strlcpy+0x2a>
			*dst++ = *src++;
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8d 50 01             	lea    0x1(%eax),%edx
  800ade:	89 55 08             	mov    %edx,0x8(%ebp)
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ae7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aea:	8a 12                	mov    (%edx),%dl
  800aec:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af5:	74 09                	je     800b00 <strlcpy+0x3c>
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	75 d8                	jne    800ad8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b06:	8b 55 08             	mov    0x8(%ebp),%edx
  800b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b0c:	29 c2                	sub    %eax,%edx
  800b0e:	89 d0                	mov    %edx,%eax
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b15:	eb 06                	jmp    800b1d <strcmp+0xb>
		p++, q++;
  800b17:	ff 45 08             	incl   0x8(%ebp)
  800b1a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	74 0e                	je     800b34 <strcmp+0x22>
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 10                	mov    (%eax),%dl
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	38 c2                	cmp    %al,%dl
  800b32:	74 e3                	je     800b17 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 d0             	movzbl %al,%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f b6 c0             	movzbl %al,%eax
  800b44:	29 c2                	sub    %eax,%edx
  800b46:	89 d0                	mov    %edx,%eax
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b4d:	eb 09                	jmp    800b58 <strncmp+0xe>
		n--, p++, q++;
  800b4f:	ff 4d 10             	decl   0x10(%ebp)
  800b52:	ff 45 08             	incl   0x8(%ebp)
  800b55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5c:	74 17                	je     800b75 <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 00                	mov    (%eax),%al
  800b63:	84 c0                	test   %al,%al
  800b65:	74 0e                	je     800b75 <strncmp+0x2b>
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8a 10                	mov    (%eax),%dl
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	38 c2                	cmp    %al,%dl
  800b73:	74 da                	je     800b4f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b79:	75 07                	jne    800b82 <strncmp+0x38>
		return 0;
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b80:	eb 14                	jmp    800b96 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 d0             	movzbl %al,%edx
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	0f b6 c0             	movzbl %al,%eax
  800b92:	29 c2                	sub    %eax,%edx
  800b94:	89 d0                	mov    %edx,%eax
}
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba4:	eb 12                	jmp    800bb8 <strchr+0x20>
		if (*s == c)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bae:	75 05                	jne    800bb5 <strchr+0x1d>
			return (char *) s;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	eb 11                	jmp    800bc6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bb5:	ff 45 08             	incl   0x8(%ebp)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	75 e5                	jne    800ba6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 04             	sub    $0x4,%esp
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd4:	eb 0d                	jmp    800be3 <strfind+0x1b>
		if (*s == c)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bde:	74 0e                	je     800bee <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800be0:	ff 45 08             	incl   0x8(%ebp)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 ea                	jne    800bd6 <strfind+0xe>
  800bec:	eb 01                	jmp    800bef <strfind+0x27>
		if (*s == c)
			break;
  800bee:	90                   	nop
	return (char *) s;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c06:	eb 0e                	jmp    800c16 <memset+0x22>
		*p++ = c;
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c16:	ff 4d f8             	decl   -0x8(%ebp)
  800c19:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c1d:	79 e9                	jns    800c08 <memset+0x14>
		*p++ = c;

	return v;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c36:	eb 16                	jmp    800c4e <memcpy+0x2a>
		*d++ = *s++;
  800c38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3b:	8d 50 01             	lea    0x1(%eax),%edx
  800c3e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c47:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c4a:	8a 12                	mov    (%edx),%dl
  800c4c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c54:	89 55 10             	mov    %edx,0x10(%ebp)
  800c57:	85 c0                	test   %eax,%eax
  800c59:	75 dd                	jne    800c38 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c78:	73 50                	jae    800cca <memmove+0x6a>
  800c7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c85:	76 43                	jbe    800cca <memmove+0x6a>
		s += n;
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c90:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c93:	eb 10                	jmp    800ca5 <memmove+0x45>
			*--d = *--s;
  800c95:	ff 4d f8             	decl   -0x8(%ebp)
  800c98:	ff 4d fc             	decl   -0x4(%ebp)
  800c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9e:	8a 10                	mov    (%eax),%dl
  800ca0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cab:	89 55 10             	mov    %edx,0x10(%ebp)
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	75 e3                	jne    800c95 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cb2:	eb 23                	jmp    800cd7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb7:	8d 50 01             	lea    0x1(%eax),%edx
  800cba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cc6:	8a 12                	mov    (%edx),%dl
  800cc8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	75 dd                	jne    800cb4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cee:	eb 2a                	jmp    800d1a <memcmp+0x3e>
		if (*s1 != *s2)
  800cf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf3:	8a 10                	mov    (%eax),%dl
  800cf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	38 c2                	cmp    %al,%dl
  800cfc:	74 16                	je     800d14 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d0             	movzbl %al,%edx
  800d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	29 c2                	sub    %eax,%edx
  800d10:	89 d0                	mov    %edx,%eax
  800d12:	eb 18                	jmp    800d2c <memcmp+0x50>
		s1++, s2++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
  800d17:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d20:	89 55 10             	mov    %edx,0x10(%ebp)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	75 c9                	jne    800cf0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2c:	c9                   	leave  
  800d2d:	c3                   	ret    

00800d2e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	01 d0                	add    %edx,%eax
  800d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d3f:	eb 15                	jmp    800d56 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 d0             	movzbl %al,%edx
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	0f b6 c0             	movzbl %al,%eax
  800d4f:	39 c2                	cmp    %eax,%edx
  800d51:	74 0d                	je     800d60 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d5c:	72 e3                	jb     800d41 <memfind+0x13>
  800d5e:	eb 01                	jmp    800d61 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d60:	90                   	nop
	return (void *) s;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7a:	eb 03                	jmp    800d7f <strtol+0x19>
		s++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 20                	cmp    $0x20,%al
  800d86:	74 f4                	je     800d7c <strtol+0x16>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 09                	cmp    $0x9,%al
  800d8f:	74 eb                	je     800d7c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	3c 2b                	cmp    $0x2b,%al
  800d98:	75 05                	jne    800d9f <strtol+0x39>
		s++;
  800d9a:	ff 45 08             	incl   0x8(%ebp)
  800d9d:	eb 13                	jmp    800db2 <strtol+0x4c>
	else if (*s == '-')
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	3c 2d                	cmp    $0x2d,%al
  800da6:	75 0a                	jne    800db2 <strtol+0x4c>
		s++, neg = 1;
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db6:	74 06                	je     800dbe <strtol+0x58>
  800db8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dbc:	75 20                	jne    800dde <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3c 30                	cmp    $0x30,%al
  800dc5:	75 17                	jne    800dde <strtol+0x78>
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	40                   	inc    %eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	3c 78                	cmp    $0x78,%al
  800dcf:	75 0d                	jne    800dde <strtol+0x78>
		s += 2, base = 16;
  800dd1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dd5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ddc:	eb 28                	jmp    800e06 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de2:	75 15                	jne    800df9 <strtol+0x93>
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	3c 30                	cmp    $0x30,%al
  800deb:	75 0c                	jne    800df9 <strtol+0x93>
		s++, base = 8;
  800ded:	ff 45 08             	incl   0x8(%ebp)
  800df0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800df7:	eb 0d                	jmp    800e06 <strtol+0xa0>
	else if (base == 0)
  800df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfd:	75 07                	jne    800e06 <strtol+0xa0>
		base = 10;
  800dff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 2f                	cmp    $0x2f,%al
  800e0d:	7e 19                	jle    800e28 <strtol+0xc2>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	3c 39                	cmp    $0x39,%al
  800e16:	7f 10                	jg     800e28 <strtol+0xc2>
			dig = *s - '0';
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	0f be c0             	movsbl %al,%eax
  800e20:	83 e8 30             	sub    $0x30,%eax
  800e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e26:	eb 42                	jmp    800e6a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 60                	cmp    $0x60,%al
  800e2f:	7e 19                	jle    800e4a <strtol+0xe4>
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	3c 7a                	cmp    $0x7a,%al
  800e38:	7f 10                	jg     800e4a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be c0             	movsbl %al,%eax
  800e42:	83 e8 57             	sub    $0x57,%eax
  800e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e48:	eb 20                	jmp    800e6a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 40                	cmp    $0x40,%al
  800e51:	7e 39                	jle    800e8c <strtol+0x126>
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	3c 5a                	cmp    $0x5a,%al
  800e5a:	7f 30                	jg     800e8c <strtol+0x126>
			dig = *s - 'A' + 10;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f be c0             	movsbl %al,%eax
  800e64:	83 e8 37             	sub    $0x37,%eax
  800e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e70:	7d 19                	jge    800e8b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e86:	e9 7b ff ff ff       	jmp    800e06 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e8b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e90:	74 08                	je     800e9a <strtol+0x134>
		*endptr = (char *) s;
  800e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9e:	74 07                	je     800ea7 <strtol+0x141>
  800ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea3:	f7 d8                	neg    %eax
  800ea5:	eb 03                	jmp    800eaa <strtol+0x144>
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <ltostr>:

void
ltostr(long value, char *str)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ec0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ec4:	79 13                	jns    800ed9 <ltostr+0x2d>
	{
		neg = 1;
  800ec6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ed3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ed6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ee1:	99                   	cltd   
  800ee2:	f7 f9                	idiv   %ecx
  800ee4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eea:	8d 50 01             	lea    0x1(%eax),%edx
  800eed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef0:	89 c2                	mov    %eax,%edx
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800efa:	83 c2 30             	add    $0x30,%edx
  800efd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f02:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f07:	f7 e9                	imul   %ecx
  800f09:	c1 fa 02             	sar    $0x2,%edx
  800f0c:	89 c8                	mov    %ecx,%eax
  800f0e:	c1 f8 1f             	sar    $0x1f,%eax
  800f11:	29 c2                	sub    %eax,%edx
  800f13:	89 d0                	mov    %edx,%eax
  800f15:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f1b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f20:	f7 e9                	imul   %ecx
  800f22:	c1 fa 02             	sar    $0x2,%edx
  800f25:	89 c8                	mov    %ecx,%eax
  800f27:	c1 f8 1f             	sar    $0x1f,%eax
  800f2a:	29 c2                	sub    %eax,%edx
  800f2c:	89 d0                	mov    %edx,%eax
  800f2e:	c1 e0 02             	shl    $0x2,%eax
  800f31:	01 d0                	add    %edx,%eax
  800f33:	01 c0                	add    %eax,%eax
  800f35:	29 c1                	sub    %eax,%ecx
  800f37:	89 ca                	mov    %ecx,%edx
  800f39:	85 d2                	test   %edx,%edx
  800f3b:	75 9c                	jne    800ed9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f47:	48                   	dec    %eax
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f4f:	74 3d                	je     800f8e <ltostr+0xe2>
		start = 1 ;
  800f51:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f58:	eb 34                	jmp    800f8e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c2                	add    %eax,%edx
  800f6f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	01 c8                	add    %ecx,%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	01 c2                	add    %eax,%edx
  800f83:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f86:	88 02                	mov    %al,(%edx)
		start++ ;
  800f88:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f8b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f94:	7c c4                	jl     800f5a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f96:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	01 d0                	add    %edx,%eax
  800f9e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 54 fa ff ff       	call   800a06 <strlen>
  800fb2:	83 c4 04             	add    $0x4,%esp
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	e8 46 fa ff ff       	call   800a06 <strlen>
  800fc0:	83 c4 04             	add    $0x4,%esp
  800fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd4:	eb 17                	jmp    800fed <strcconcat+0x49>
		final[s] = str1[s] ;
  800fd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	01 c2                	add    %eax,%edx
  800fde:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	01 c8                	add    %ecx,%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fea:	ff 45 fc             	incl   -0x4(%ebp)
  800fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff3:	7c e1                	jl     800fd6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ff5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ffc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801003:	eb 1f                	jmp    801024 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801008:	8d 50 01             	lea    0x1(%eax),%edx
  80100b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100e:	89 c2                	mov    %eax,%edx
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	01 c2                	add    %eax,%edx
  801015:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	01 c8                	add    %ecx,%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801021:	ff 45 f8             	incl   -0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80102a:	7c d9                	jl     801005 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	c6 00 00             	movb   $0x0,(%eax)
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	8b 00                	mov    (%eax),%eax
  80104b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80105d:	eb 0c                	jmp    80106b <strsplit+0x31>
			*string++ = 0;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8d 50 01             	lea    0x1(%eax),%edx
  801065:	89 55 08             	mov    %edx,0x8(%ebp)
  801068:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	84 c0                	test   %al,%al
  801072:	74 18                	je     80108c <strsplit+0x52>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f be c0             	movsbl %al,%eax
  80107c:	50                   	push   %eax
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	e8 13 fb ff ff       	call   800b98 <strchr>
  801085:	83 c4 08             	add    $0x8,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	75 d3                	jne    80105f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	74 5a                	je     8010ef <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801095:	8b 45 14             	mov    0x14(%ebp),%eax
  801098:	8b 00                	mov    (%eax),%eax
  80109a:	83 f8 0f             	cmp    $0xf,%eax
  80109d:	75 07                	jne    8010a6 <strsplit+0x6c>
		{
			return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a4:	eb 66                	jmp    80110c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	8b 00                	mov    (%eax),%eax
  8010ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8010ae:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b1:	89 0a                	mov    %ecx,(%edx)
  8010b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c4:	eb 03                	jmp    8010c9 <strsplit+0x8f>
			string++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	84 c0                	test   %al,%al
  8010d0:	74 8b                	je     80105d <strsplit+0x23>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f be c0             	movsbl %al,%eax
  8010da:	50                   	push   %eax
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	e8 b5 fa ff ff       	call   800b98 <strchr>
  8010e3:	83 c4 08             	add    $0x8,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	74 dc                	je     8010c6 <strsplit+0x8c>
			string++;
	}
  8010ea:	e9 6e ff ff ff       	jmp    80105d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010ef:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	8b 00                	mov    (%eax),%eax
  8010f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801107:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801114:	a1 28 30 80 00       	mov    0x803028,%eax
  801119:	85 c0                	test   %eax,%eax
  80111b:	75 33                	jne    801150 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  80111d:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  801124:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801127:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  80112e:	00 00 a0 
		spaces[0].pages = numPages;
  801131:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801138:	00 02 00 
		spaces[0].isFree = 1;
  80113b:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801142:	00 00 00 
		arraySize++;
  801145:	a1 28 30 80 00       	mov    0x803028,%eax
  80114a:	40                   	inc    %eax
  80114b:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801150:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801157:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  80115e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801165:	8b 55 08             	mov    0x8(%ebp),%edx
  801168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80116b:	01 d0                	add    %edx,%eax
  80116d:	48                   	dec    %eax
  80116e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801174:	ba 00 00 00 00       	mov    $0x0,%edx
  801179:	f7 75 e8             	divl   -0x18(%ebp)
  80117c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80117f:	29 d0                	sub    %edx,%eax
  801181:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	c1 e8 0c             	shr    $0xc,%eax
  80118a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  80118d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801194:	eb 57                	jmp    8011ed <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801199:	c1 e0 04             	shl    $0x4,%eax
  80119c:	05 2c 31 80 00       	add    $0x80312c,%eax
  8011a1:	8b 00                	mov    (%eax),%eax
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	74 42                	je     8011e9 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8011a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011aa:	c1 e0 04             	shl    $0x4,%eax
  8011ad:	05 28 31 80 00       	add    $0x803128,%eax
  8011b2:	8b 00                	mov    (%eax),%eax
  8011b4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8011b7:	7c 31                	jl     8011ea <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8011b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011bc:	c1 e0 04             	shl    $0x4,%eax
  8011bf:	05 28 31 80 00       	add    $0x803128,%eax
  8011c4:	8b 00                	mov    (%eax),%eax
  8011c6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8011c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011cc:	7d 1c                	jge    8011ea <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  8011ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d1:	c1 e0 04             	shl    $0x4,%eax
  8011d4:	05 28 31 80 00       	add    $0x803128,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8011de:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8011e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e7:	eb 01                	jmp    8011ea <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8011e9:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8011ea:	ff 45 ec             	incl   -0x14(%ebp)
  8011ed:	a1 28 30 80 00       	mov    0x803028,%eax
  8011f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8011f5:	7c 9f                	jl     801196 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8011f7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8011fb:	75 0a                	jne    801207 <malloc+0xf9>
	{
		return NULL;
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801202:	e9 34 01 00 00       	jmp    80133b <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120a:	c1 e0 04             	shl    $0x4,%eax
  80120d:	05 28 31 80 00       	add    $0x803128,%eax
  801212:	8b 00                	mov    (%eax),%eax
  801214:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801217:	75 38                	jne    801251 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121c:	c1 e0 04             	shl    $0x4,%eax
  80121f:	05 2c 31 80 00       	add    $0x80312c,%eax
  801224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  80122a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122d:	c1 e0 0c             	shl    $0xc,%eax
  801230:	89 c2                	mov    %eax,%edx
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801235:	c1 e0 04             	shl    $0x4,%eax
  801238:	05 20 31 80 00       	add    $0x803120,%eax
  80123d:	8b 00                	mov    (%eax),%eax
  80123f:	83 ec 08             	sub    $0x8,%esp
  801242:	52                   	push   %edx
  801243:	50                   	push   %eax
  801244:	e8 01 06 00 00       	call   80184a <sys_allocateMem>
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	e9 dd 00 00 00       	jmp    80132e <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801254:	c1 e0 04             	shl    $0x4,%eax
  801257:	05 20 31 80 00       	add    $0x803120,%eax
  80125c:	8b 00                	mov    (%eax),%eax
  80125e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801261:	c1 e2 0c             	shl    $0xc,%edx
  801264:	01 d0                	add    %edx,%eax
  801266:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801269:	a1 28 30 80 00       	mov    0x803028,%eax
  80126e:	c1 e0 04             	shl    $0x4,%eax
  801271:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  801277:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80127a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80127c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801285:	c1 e0 04             	shl    $0x4,%eax
  801288:	05 24 31 80 00       	add    $0x803124,%eax
  80128d:	8b 00                	mov    (%eax),%eax
  80128f:	c1 e2 04             	shl    $0x4,%edx
  801292:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801298:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80129a:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8012a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a3:	c1 e0 04             	shl    $0x4,%eax
  8012a6:	05 28 31 80 00       	add    $0x803128,%eax
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8012b0:	c1 e2 04             	shl    $0x4,%edx
  8012b3:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8012b9:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  8012bb:	a1 28 30 80 00       	mov    0x803028,%eax
  8012c0:	c1 e0 04             	shl    $0x4,%eax
  8012c3:	05 2c 31 80 00       	add    $0x80312c,%eax
  8012c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  8012ce:	a1 28 30 80 00       	mov    0x803028,%eax
  8012d3:	40                   	inc    %eax
  8012d4:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8012d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012dc:	c1 e0 04             	shl    $0x4,%eax
  8012df:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8012e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012e8:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8012ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ed:	c1 e0 04             	shl    $0x4,%eax
  8012f0:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  8012f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012f9:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  8012fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fe:	c1 e0 04             	shl    $0x4,%eax
  801301:	05 2c 31 80 00       	add    $0x80312c,%eax
  801306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  80130c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80130f:	c1 e0 0c             	shl    $0xc,%eax
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801317:	c1 e0 04             	shl    $0x4,%eax
  80131a:	05 20 31 80 00       	add    $0x803120,%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	52                   	push   %edx
  801325:	50                   	push   %eax
  801326:	e8 1f 05 00 00       	call   80184a <sys_allocateMem>
  80132b:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  80132e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801331:	c1 e0 04             	shl    $0x4,%eax
  801334:	05 20 31 80 00       	add    $0x803120,%eax
  801339:	8b 00                	mov    (%eax),%eax
	}


}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801343:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80134a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801351:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801358:	eb 3f                	jmp    801399 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80135a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135d:	c1 e0 04             	shl    $0x4,%eax
  801360:	05 20 31 80 00       	add    $0x803120,%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	3b 45 08             	cmp    0x8(%ebp),%eax
  80136a:	75 2a                	jne    801396 <free+0x59>
		{
			index=i;
  80136c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801375:	c1 e0 04             	shl    $0x4,%eax
  801378:	05 28 31 80 00       	add    $0x803128,%eax
  80137d:	8b 00                	mov    (%eax),%eax
  80137f:	c1 e0 0c             	shl    $0xc,%eax
  801382:	89 c2                	mov    %eax,%edx
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	52                   	push   %edx
  80138b:	50                   	push   %eax
  80138c:	e8 9d 04 00 00       	call   80182e <sys_freeMem>
  801391:	83 c4 10             	add    $0x10,%esp
			break;
  801394:	eb 0d                	jmp    8013a3 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801396:	ff 45 ec             	incl   -0x14(%ebp)
  801399:	a1 28 30 80 00       	mov    0x803028,%eax
  80139e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8013a1:	7c b7                	jl     80135a <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8013a7:	75 17                	jne    8013c0 <free+0x83>
	{
		panic("Error");
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	68 30 26 80 00       	push   $0x802630
  8013b1:	68 81 00 00 00       	push   $0x81
  8013b6:	68 36 26 80 00       	push   $0x802636
  8013bb:	e8 c8 09 00 00       	call   801d88 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  8013c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013c7:	e9 cc 00 00 00       	jmp    801498 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  8013cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013cf:	c1 e0 04             	shl    $0x4,%eax
  8013d2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	0f 84 b3 00 00 00    	je     801494 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8013e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e4:	c1 e0 04             	shl    $0x4,%eax
  8013e7:	05 20 31 80 00       	add    $0x803120,%eax
  8013ec:	8b 10                	mov    (%eax),%edx
  8013ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f1:	c1 e0 04             	shl    $0x4,%eax
  8013f4:	05 24 31 80 00       	add    $0x803124,%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	39 c2                	cmp    %eax,%edx
  8013fd:	0f 85 92 00 00 00    	jne    801495 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801406:	c1 e0 04             	shl    $0x4,%eax
  801409:	05 24 31 80 00       	add    $0x803124,%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801413:	c1 e2 04             	shl    $0x4,%edx
  801416:	81 c2 24 31 80 00    	add    $0x803124,%edx
  80141c:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  80141e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801421:	c1 e0 04             	shl    $0x4,%eax
  801424:	05 28 31 80 00       	add    $0x803128,%eax
  801429:	8b 10                	mov    (%eax),%edx
  80142b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142e:	c1 e0 04             	shl    $0x4,%eax
  801431:	05 28 31 80 00       	add    $0x803128,%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	01 c2                	add    %eax,%edx
  80143a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143d:	c1 e0 04             	shl    $0x4,%eax
  801440:	05 28 31 80 00       	add    $0x803128,%eax
  801445:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144a:	c1 e0 04             	shl    $0x4,%eax
  80144d:	05 20 31 80 00       	add    $0x803120,%eax
  801452:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145b:	c1 e0 04             	shl    $0x4,%eax
  80145e:	05 24 31 80 00       	add    $0x803124,%eax
  801463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	c1 e0 04             	shl    $0x4,%eax
  80146f:	05 28 31 80 00       	add    $0x803128,%eax
  801474:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80147a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147d:	c1 e0 04             	shl    $0x4,%eax
  801480:	05 2c 31 80 00       	add    $0x80312c,%eax
  801485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80148b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801492:	eb 12                	jmp    8014a6 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801494:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801495:	ff 45 e8             	incl   -0x18(%ebp)
  801498:	a1 28 30 80 00       	mov    0x803028,%eax
  80149d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8014a0:	0f 8c 26 ff ff ff    	jl     8013cc <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8014a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8014ad:	e9 cc 00 00 00       	jmp    80157e <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  8014b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b5:	c1 e0 04             	shl    $0x4,%eax
  8014b8:	05 2c 31 80 00       	add    $0x80312c,%eax
  8014bd:	8b 00                	mov    (%eax),%eax
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	0f 84 b3 00 00 00    	je     80157a <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  8014c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ca:	c1 e0 04             	shl    $0x4,%eax
  8014cd:	05 24 31 80 00       	add    $0x803124,%eax
  8014d2:	8b 10                	mov    (%eax),%edx
  8014d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d7:	c1 e0 04             	shl    $0x4,%eax
  8014da:	05 20 31 80 00       	add    $0x803120,%eax
  8014df:	8b 00                	mov    (%eax),%eax
  8014e1:	39 c2                	cmp    %eax,%edx
  8014e3:	0f 85 92 00 00 00    	jne    80157b <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8014e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ec:	c1 e0 04             	shl    $0x4,%eax
  8014ef:	05 20 31 80 00       	add    $0x803120,%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014f9:	c1 e2 04             	shl    $0x4,%edx
  8014fc:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801502:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801507:	c1 e0 04             	shl    $0x4,%eax
  80150a:	05 28 31 80 00       	add    $0x803128,%eax
  80150f:	8b 10                	mov    (%eax),%edx
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	c1 e0 04             	shl    $0x4,%eax
  801517:	05 28 31 80 00       	add    $0x803128,%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	01 c2                	add    %eax,%edx
  801520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801523:	c1 e0 04             	shl    $0x4,%eax
  801526:	05 28 31 80 00       	add    $0x803128,%eax
  80152b:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  80152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801530:	c1 e0 04             	shl    $0x4,%eax
  801533:	05 20 31 80 00       	add    $0x803120,%eax
  801538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  80153e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801541:	c1 e0 04             	shl    $0x4,%eax
  801544:	05 24 31 80 00       	add    $0x803124,%eax
  801549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  80154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801552:	c1 e0 04             	shl    $0x4,%eax
  801555:	05 28 31 80 00       	add    $0x803128,%eax
  80155a:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	c1 e0 04             	shl    $0x4,%eax
  801566:	05 2c 31 80 00       	add    $0x80312c,%eax
  80156b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801578:	eb 12                	jmp    80158c <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80157a:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  80157b:	ff 45 e4             	incl   -0x1c(%ebp)
  80157e:	a1 28 30 80 00       	mov    0x803028,%eax
  801583:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801586:	0f 8c 26 ff ff ff    	jl     8014b2 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80158c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801590:	75 11                	jne    8015a3 <free+0x266>
	{
		spaces[index].isFree = 1;
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	c1 e0 04             	shl    $0x4,%eax
  801598:	05 2c 31 80 00       	add    $0x80312c,%eax
  80159d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 18             	sub    $0x18,%esp
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 44 26 80 00       	push   $0x802644
  8015ba:	68 b9 00 00 00       	push   $0xb9
  8015bf:	68 36 26 80 00       	push   $0x802636
  8015c4:	e8 bf 07 00 00       	call   801d88 <_panic>

008015c9 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 44 26 80 00       	push   $0x802644
  8015d7:	68 bf 00 00 00       	push   $0xbf
  8015dc:	68 36 26 80 00       	push   $0x802636
  8015e1:	e8 a2 07 00 00       	call   801d88 <_panic>

008015e6 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	68 44 26 80 00       	push   $0x802644
  8015f4:	68 c5 00 00 00       	push   $0xc5
  8015f9:	68 36 26 80 00       	push   $0x802636
  8015fe:	e8 85 07 00 00       	call   801d88 <_panic>

00801603 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	68 44 26 80 00       	push   $0x802644
  801611:	68 ca 00 00 00       	push   $0xca
  801616:	68 36 26 80 00       	push   $0x802636
  80161b:	e8 68 07 00 00       	call   801d88 <_panic>

00801620 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	68 44 26 80 00       	push   $0x802644
  80162e:	68 d0 00 00 00       	push   $0xd0
  801633:	68 36 26 80 00       	push   $0x802636
  801638:	e8 4b 07 00 00       	call   801d88 <_panic>

0080163d <shrink>:
}
void shrink(uint32 newSize)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 44 26 80 00       	push   $0x802644
  80164b:	68 d4 00 00 00       	push   $0xd4
  801650:	68 36 26 80 00       	push   $0x802636
  801655:	e8 2e 07 00 00       	call   801d88 <_panic>

0080165a <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 44 26 80 00       	push   $0x802644
  801668:	68 d9 00 00 00       	push   $0xd9
  80166d:	68 36 26 80 00       	push   $0x802636
  801672:	e8 11 07 00 00       	call   801d88 <_panic>

00801677 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	57                   	push   %edi
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8b 55 0c             	mov    0xc(%ebp),%edx
  801686:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80168f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801692:	cd 30                	int    $0x30
  801694:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5e                   	pop    %esi
  80169f:	5f                   	pop    %edi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    

008016a2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	52                   	push   %edx
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	50                   	push   %eax
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 b2 ff ff ff       	call   801677 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	90                   	nop
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_cgetc>:

int
sys_cgetc(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 01                	push   $0x1
  8016da:	e8 98 ff ff ff       	call   801677 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	50                   	push   %eax
  8016f3:	6a 05                	push   $0x5
  8016f5:	e8 7d ff ff ff       	call   801677 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 02                	push   $0x2
  80170e:	e8 64 ff ff ff       	call   801677 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 03                	push   $0x3
  801727:	e8 4b ff ff ff       	call   801677 <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 04                	push   $0x4
  801740:	e8 32 ff ff ff       	call   801677 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_env_exit>:


void sys_env_exit(void)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 06                	push   $0x6
  801759:	e8 19 ff ff ff       	call   801677 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	90                   	nop
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	6a 07                	push   $0x7
  801777:	e8 fb fe ff ff       	call   801677 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801786:	8b 75 18             	mov    0x18(%ebp),%esi
  801789:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	56                   	push   %esi
  801796:	53                   	push   %ebx
  801797:	51                   	push   %ecx
  801798:	52                   	push   %edx
  801799:	50                   	push   %eax
  80179a:	6a 08                	push   $0x8
  80179c:	e8 d6 fe ff ff       	call   801677 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a7:	5b                   	pop    %ebx
  8017a8:	5e                   	pop    %esi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 09                	push   $0x9
  8017be:	e8 b4 fe ff ff       	call   801677 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 0a                	push   $0xa
  8017d9:	e8 99 fe ff ff       	call   801677 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 0b                	push   $0xb
  8017f2:	e8 80 fe ff ff       	call   801677 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 0c                	push   $0xc
  80180b:	e8 67 fe ff ff       	call   801677 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 0d                	push   $0xd
  801824:	e8 4e fe ff ff       	call   801677 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	6a 11                	push   $0x11
  80183f:	e8 33 fe ff ff       	call   801677 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
	return;
  801847:	90                   	nop
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 12                	push   $0x12
  80185b:	e8 17 fe ff ff       	call   801677 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return ;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 0e                	push   $0xe
  801875:	e8 fd fd ff ff       	call   801677 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	6a 0f                	push   $0xf
  80188f:	e8 e3 fd ff ff       	call   801677 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 10                	push   $0x10
  8018a8:	e8 ca fd ff ff       	call   801677 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 14                	push   $0x14
  8018c2:	e8 b0 fd ff ff       	call   801677 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 15                	push   $0x15
  8018dc:	e8 96 fd ff ff       	call   801677 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	50                   	push   %eax
  801900:	6a 16                	push   $0x16
  801902:	e8 70 fd ff ff       	call   801677 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	90                   	nop
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 17                	push   $0x17
  80191c:	e8 56 fd ff ff       	call   801677 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	50                   	push   %eax
  801937:	6a 18                	push   $0x18
  801939:	e8 39 fd ff ff       	call   801677 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 1b                	push   $0x1b
  801956:	e8 1c fd ff ff       	call   801677 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 19                	push   $0x19
  801973:	e8 ff fc ff ff       	call   801677 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	90                   	nop
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801981:	8b 55 0c             	mov    0xc(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 1a                	push   $0x1a
  801991:	e8 e1 fc ff ff       	call   801677 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	51                   	push   %ecx
  8019b5:	52                   	push   %edx
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	50                   	push   %eax
  8019ba:	6a 1c                	push   $0x1c
  8019bc:	e8 b6 fc ff ff       	call   801677 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	52                   	push   %edx
  8019d6:	50                   	push   %eax
  8019d7:	6a 1d                	push   $0x1d
  8019d9:	e8 99 fc ff ff       	call   801677 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	51                   	push   %ecx
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 1e                	push   $0x1e
  8019f8:	e8 7a fc ff ff       	call   801677 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 1f                	push   $0x1f
  801a15:	e8 5d fc ff ff       	call   801677 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 20                	push   $0x20
  801a2e:	e8 44 fc ff ff       	call   801677 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	ff 75 14             	pushl  0x14(%ebp)
  801a43:	ff 75 10             	pushl  0x10(%ebp)
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	6a 21                	push   $0x21
  801a4c:	e8 26 fc ff ff       	call   801677 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	50                   	push   %eax
  801a65:	6a 22                	push   $0x22
  801a67:	e8 0b fc ff ff       	call   801677 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	50                   	push   %eax
  801a81:	6a 23                	push   $0x23
  801a83:	e8 ef fb ff ff       	call   801677 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a94:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a97:	8d 50 04             	lea    0x4(%eax),%edx
  801a9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	6a 24                	push   $0x24
  801aa7:	e8 cb fb ff ff       	call   801677 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
	return result;
  801aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ab5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab8:	89 01                	mov    %eax,(%ecx)
  801aba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	c9                   	leave  
  801ac1:	c2 04 00             	ret    $0x4

00801ac4 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 10             	pushl  0x10(%ebp)
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	6a 13                	push   $0x13
  801ad6:	e8 9c fb ff ff       	call   801677 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ade:	90                   	nop
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 25                	push   $0x25
  801af0:	e8 82 fb ff ff       	call   801677 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b06:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	50                   	push   %eax
  801b13:	6a 26                	push   $0x26
  801b15:	e8 5d fb ff ff       	call   801677 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1d:	90                   	nop
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <rsttst>:
void rsttst()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 28                	push   $0x28
  801b2f:	e8 43 fb ff ff       	call   801677 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return ;
  801b37:	90                   	nop
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	8b 45 14             	mov    0x14(%ebp),%eax
  801b43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b46:	8b 55 18             	mov    0x18(%ebp),%edx
  801b49:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	ff 75 10             	pushl  0x10(%ebp)
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	ff 75 08             	pushl  0x8(%ebp)
  801b58:	6a 27                	push   $0x27
  801b5a:	e8 18 fb ff ff       	call   801677 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b62:	90                   	nop
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <chktst>:
void chktst(uint32 n)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	ff 75 08             	pushl  0x8(%ebp)
  801b73:	6a 29                	push   $0x29
  801b75:	e8 fd fa ff ff       	call   801677 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7d:	90                   	nop
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <inctst>:

void inctst()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 2a                	push   $0x2a
  801b8f:	e8 e3 fa ff ff       	call   801677 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
	return ;
  801b97:	90                   	nop
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <gettst>:
uint32 gettst()
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 2b                	push   $0x2b
  801ba9:	e8 c9 fa ff ff       	call   801677 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 2c                	push   $0x2c
  801bc5:	e8 ad fa ff ff       	call   801677 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
  801bcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bd0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bd4:	75 07                	jne    801bdd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	eb 05                	jmp    801be2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 2c                	push   $0x2c
  801bf6:	e8 7c fa ff ff       	call   801677 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
  801bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c01:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c05:	75 07                	jne    801c0e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c07:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0c:	eb 05                	jmp    801c13 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 2c                	push   $0x2c
  801c27:	e8 4b fa ff ff       	call   801677 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
  801c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c32:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c36:	75 07                	jne    801c3f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c38:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3d:	eb 05                	jmp    801c44 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 2c                	push   $0x2c
  801c58:	e8 1a fa ff ff       	call   801677 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
  801c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c63:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c67:	75 07                	jne    801c70 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c69:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6e:	eb 05                	jmp    801c75 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	ff 75 08             	pushl  0x8(%ebp)
  801c85:	6a 2d                	push   $0x2d
  801c87:	e8 eb f9 ff ff       	call   801677 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	53                   	push   %ebx
  801ca5:	51                   	push   %ecx
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	6a 2e                	push   $0x2e
  801caa:	e8 c8 f9 ff ff       	call   801677 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 2f                	push   $0x2f
  801cca:	e8 a8 f9 ff ff       	call   801677 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801cda:	8b 55 08             	mov    0x8(%ebp),%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	c1 e0 02             	shl    $0x2,%eax
  801ce2:	01 d0                	add    %edx,%eax
  801ce4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ceb:	01 d0                	add    %edx,%eax
  801ced:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cf4:	01 d0                	add    %edx,%eax
  801cf6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	c1 e0 04             	shl    $0x4,%eax
  801d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801d05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801d0c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	50                   	push   %eax
  801d13:	e8 76 fd ff ff       	call   801a8e <sys_get_virtual_time>
  801d18:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801d1b:	eb 41                	jmp    801d5e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801d1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	50                   	push   %eax
  801d24:	e8 65 fd ff ff       	call   801a8e <sys_get_virtual_time>
  801d29:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d32:	29 c2                	sub    %eax,%edx
  801d34:	89 d0                	mov    %edx,%eax
  801d36:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3f:	89 d1                	mov    %edx,%ecx
  801d41:	29 c1                	sub    %eax,%ecx
  801d43:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d49:	39 c2                	cmp    %eax,%edx
  801d4b:	0f 97 c0             	seta   %al
  801d4e:	0f b6 c0             	movzbl %al,%eax
  801d51:	29 c1                	sub    %eax,%ecx
  801d53:	89 c8                	mov    %ecx,%eax
  801d55:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d64:	72 b7                	jb     801d1d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d66:	90                   	nop
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d76:	eb 03                	jmp    801d7b <busy_wait+0x12>
  801d78:	ff 45 fc             	incl   -0x4(%ebp)
  801d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d81:	72 f5                	jb     801d78 <busy_wait+0xf>
	return i;
  801d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801d8e:	8d 45 10             	lea    0x10(%ebp),%eax
  801d91:	83 c0 04             	add    $0x4,%eax
  801d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801d97:	a1 20 31 a0 00       	mov    0xa03120,%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	74 16                	je     801db6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801da0:	a1 20 31 a0 00       	mov    0xa03120,%eax
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	50                   	push   %eax
  801da9:	68 68 26 80 00       	push   $0x802668
  801dae:	e8 d1 e5 ff ff       	call   800384 <cprintf>
  801db3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801db6:	a1 00 30 80 00       	mov    0x803000,%eax
  801dbb:	ff 75 0c             	pushl  0xc(%ebp)
  801dbe:	ff 75 08             	pushl  0x8(%ebp)
  801dc1:	50                   	push   %eax
  801dc2:	68 6d 26 80 00       	push   $0x80266d
  801dc7:	e8 b8 e5 ff ff       	call   800384 <cprintf>
  801dcc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd2:	83 ec 08             	sub    $0x8,%esp
  801dd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd8:	50                   	push   %eax
  801dd9:	e8 3b e5 ff ff       	call   800319 <vcprintf>
  801dde:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801de1:	83 ec 08             	sub    $0x8,%esp
  801de4:	6a 00                	push   $0x0
  801de6:	68 89 26 80 00       	push   $0x802689
  801deb:	e8 29 e5 ff ff       	call   800319 <vcprintf>
  801df0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801df3:	e8 aa e4 ff ff       	call   8002a2 <exit>

	// should not return here
	while (1) ;
  801df8:	eb fe                	jmp    801df8 <_panic+0x70>

00801dfa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801e00:	a1 20 30 80 00       	mov    0x803020,%eax
  801e05:	8b 50 74             	mov    0x74(%eax),%edx
  801e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0b:	39 c2                	cmp    %eax,%edx
  801e0d:	74 14                	je     801e23 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 8c 26 80 00       	push   $0x80268c
  801e17:	6a 26                	push   $0x26
  801e19:	68 d8 26 80 00       	push   $0x8026d8
  801e1e:	e8 65 ff ff ff       	call   801d88 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801e23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801e2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e31:	e9 b6 00 00 00       	jmp    801eec <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	01 d0                	add    %edx,%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	85 c0                	test   %eax,%eax
  801e49:	75 08                	jne    801e53 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801e4b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801e4e:	e9 96 00 00 00       	jmp    801ee9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  801e53:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801e5a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e61:	eb 5d                	jmp    801ec0 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801e63:	a1 20 30 80 00       	mov    0x803020,%eax
  801e68:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801e6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e71:	c1 e2 04             	shl    $0x4,%edx
  801e74:	01 d0                	add    %edx,%eax
  801e76:	8a 40 04             	mov    0x4(%eax),%al
  801e79:	84 c0                	test   %al,%al
  801e7b:	75 40                	jne    801ebd <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801e7d:	a1 20 30 80 00       	mov    0x803020,%eax
  801e82:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801e88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e8b:	c1 e2 04             	shl    $0x4,%edx
  801e8e:	01 d0                	add    %edx,%eax
  801e90:	8b 00                	mov    (%eax),%eax
  801e92:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e9d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	01 c8                	add    %ecx,%eax
  801eae:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801eb0:	39 c2                	cmp    %eax,%edx
  801eb2:	75 09                	jne    801ebd <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801eb4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ebb:	eb 12                	jmp    801ecf <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ebd:	ff 45 e8             	incl   -0x18(%ebp)
  801ec0:	a1 20 30 80 00       	mov    0x803020,%eax
  801ec5:	8b 50 74             	mov    0x74(%eax),%edx
  801ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ecb:	39 c2                	cmp    %eax,%edx
  801ecd:	77 94                	ja     801e63 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ecf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ed3:	75 14                	jne    801ee9 <CheckWSWithoutLastIndex+0xef>
			panic(
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	68 e4 26 80 00       	push   $0x8026e4
  801edd:	6a 3a                	push   $0x3a
  801edf:	68 d8 26 80 00       	push   $0x8026d8
  801ee4:	e8 9f fe ff ff       	call   801d88 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801ee9:	ff 45 f0             	incl   -0x10(%ebp)
  801eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ef2:	0f 8c 3e ff ff ff    	jl     801e36 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ef8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801eff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f06:	eb 20                	jmp    801f28 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801f08:	a1 20 30 80 00       	mov    0x803020,%eax
  801f0d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801f13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f16:	c1 e2 04             	shl    $0x4,%edx
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	8a 40 04             	mov    0x4(%eax),%al
  801f1e:	3c 01                	cmp    $0x1,%al
  801f20:	75 03                	jne    801f25 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  801f22:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f25:	ff 45 e0             	incl   -0x20(%ebp)
  801f28:	a1 20 30 80 00       	mov    0x803020,%eax
  801f2d:	8b 50 74             	mov    0x74(%eax),%edx
  801f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f33:	39 c2                	cmp    %eax,%edx
  801f35:	77 d1                	ja     801f08 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801f3d:	74 14                	je     801f53 <CheckWSWithoutLastIndex+0x159>
		panic(
  801f3f:	83 ec 04             	sub    $0x4,%esp
  801f42:	68 38 27 80 00       	push   $0x802738
  801f47:	6a 44                	push   $0x44
  801f49:	68 d8 26 80 00       	push   $0x8026d8
  801f4e:	e8 35 fe ff ff       	call   801d88 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    
  801f56:	66 90                	xchg   %ax,%ax

00801f58 <__udivdi3>:
  801f58:	55                   	push   %ebp
  801f59:	57                   	push   %edi
  801f5a:	56                   	push   %esi
  801f5b:	53                   	push   %ebx
  801f5c:	83 ec 1c             	sub    $0x1c,%esp
  801f5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f6f:	89 ca                	mov    %ecx,%edx
  801f71:	89 f8                	mov    %edi,%eax
  801f73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f77:	85 f6                	test   %esi,%esi
  801f79:	75 2d                	jne    801fa8 <__udivdi3+0x50>
  801f7b:	39 cf                	cmp    %ecx,%edi
  801f7d:	77 65                	ja     801fe4 <__udivdi3+0x8c>
  801f7f:	89 fd                	mov    %edi,%ebp
  801f81:	85 ff                	test   %edi,%edi
  801f83:	75 0b                	jne    801f90 <__udivdi3+0x38>
  801f85:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8a:	31 d2                	xor    %edx,%edx
  801f8c:	f7 f7                	div    %edi
  801f8e:	89 c5                	mov    %eax,%ebp
  801f90:	31 d2                	xor    %edx,%edx
  801f92:	89 c8                	mov    %ecx,%eax
  801f94:	f7 f5                	div    %ebp
  801f96:	89 c1                	mov    %eax,%ecx
  801f98:	89 d8                	mov    %ebx,%eax
  801f9a:	f7 f5                	div    %ebp
  801f9c:	89 cf                	mov    %ecx,%edi
  801f9e:	89 fa                	mov    %edi,%edx
  801fa0:	83 c4 1c             	add    $0x1c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    
  801fa8:	39 ce                	cmp    %ecx,%esi
  801faa:	77 28                	ja     801fd4 <__udivdi3+0x7c>
  801fac:	0f bd fe             	bsr    %esi,%edi
  801faf:	83 f7 1f             	xor    $0x1f,%edi
  801fb2:	75 40                	jne    801ff4 <__udivdi3+0x9c>
  801fb4:	39 ce                	cmp    %ecx,%esi
  801fb6:	72 0a                	jb     801fc2 <__udivdi3+0x6a>
  801fb8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fbc:	0f 87 9e 00 00 00    	ja     802060 <__udivdi3+0x108>
  801fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc7:	89 fa                	mov    %edi,%edx
  801fc9:	83 c4 1c             	add    $0x1c,%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
  801fd1:	8d 76 00             	lea    0x0(%esi),%esi
  801fd4:	31 ff                	xor    %edi,%edi
  801fd6:	31 c0                	xor    %eax,%eax
  801fd8:	89 fa                	mov    %edi,%edx
  801fda:	83 c4 1c             	add    $0x1c,%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5f                   	pop    %edi
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    
  801fe2:	66 90                	xchg   %ax,%ax
  801fe4:	89 d8                	mov    %ebx,%eax
  801fe6:	f7 f7                	div    %edi
  801fe8:	31 ff                	xor    %edi,%edi
  801fea:	89 fa                	mov    %edi,%edx
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ff9:	89 eb                	mov    %ebp,%ebx
  801ffb:	29 fb                	sub    %edi,%ebx
  801ffd:	89 f9                	mov    %edi,%ecx
  801fff:	d3 e6                	shl    %cl,%esi
  802001:	89 c5                	mov    %eax,%ebp
  802003:	88 d9                	mov    %bl,%cl
  802005:	d3 ed                	shr    %cl,%ebp
  802007:	89 e9                	mov    %ebp,%ecx
  802009:	09 f1                	or     %esi,%ecx
  80200b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80200f:	89 f9                	mov    %edi,%ecx
  802011:	d3 e0                	shl    %cl,%eax
  802013:	89 c5                	mov    %eax,%ebp
  802015:	89 d6                	mov    %edx,%esi
  802017:	88 d9                	mov    %bl,%cl
  802019:	d3 ee                	shr    %cl,%esi
  80201b:	89 f9                	mov    %edi,%ecx
  80201d:	d3 e2                	shl    %cl,%edx
  80201f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802023:	88 d9                	mov    %bl,%cl
  802025:	d3 e8                	shr    %cl,%eax
  802027:	09 c2                	or     %eax,%edx
  802029:	89 d0                	mov    %edx,%eax
  80202b:	89 f2                	mov    %esi,%edx
  80202d:	f7 74 24 0c          	divl   0xc(%esp)
  802031:	89 d6                	mov    %edx,%esi
  802033:	89 c3                	mov    %eax,%ebx
  802035:	f7 e5                	mul    %ebp
  802037:	39 d6                	cmp    %edx,%esi
  802039:	72 19                	jb     802054 <__udivdi3+0xfc>
  80203b:	74 0b                	je     802048 <__udivdi3+0xf0>
  80203d:	89 d8                	mov    %ebx,%eax
  80203f:	31 ff                	xor    %edi,%edi
  802041:	e9 58 ff ff ff       	jmp    801f9e <__udivdi3+0x46>
  802046:	66 90                	xchg   %ax,%ax
  802048:	8b 54 24 08          	mov    0x8(%esp),%edx
  80204c:	89 f9                	mov    %edi,%ecx
  80204e:	d3 e2                	shl    %cl,%edx
  802050:	39 c2                	cmp    %eax,%edx
  802052:	73 e9                	jae    80203d <__udivdi3+0xe5>
  802054:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802057:	31 ff                	xor    %edi,%edi
  802059:	e9 40 ff ff ff       	jmp    801f9e <__udivdi3+0x46>
  80205e:	66 90                	xchg   %ax,%ax
  802060:	31 c0                	xor    %eax,%eax
  802062:	e9 37 ff ff ff       	jmp    801f9e <__udivdi3+0x46>
  802067:	90                   	nop

00802068 <__umoddi3>:
  802068:	55                   	push   %ebp
  802069:	57                   	push   %edi
  80206a:	56                   	push   %esi
  80206b:	53                   	push   %ebx
  80206c:	83 ec 1c             	sub    $0x1c,%esp
  80206f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802073:	8b 74 24 34          	mov    0x34(%esp),%esi
  802077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80207b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80207f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802083:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802087:	89 f3                	mov    %esi,%ebx
  802089:	89 fa                	mov    %edi,%edx
  80208b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80208f:	89 34 24             	mov    %esi,(%esp)
  802092:	85 c0                	test   %eax,%eax
  802094:	75 1a                	jne    8020b0 <__umoddi3+0x48>
  802096:	39 f7                	cmp    %esi,%edi
  802098:	0f 86 a2 00 00 00    	jbe    802140 <__umoddi3+0xd8>
  80209e:	89 c8                	mov    %ecx,%eax
  8020a0:	89 f2                	mov    %esi,%edx
  8020a2:	f7 f7                	div    %edi
  8020a4:	89 d0                	mov    %edx,%eax
  8020a6:	31 d2                	xor    %edx,%edx
  8020a8:	83 c4 1c             	add    $0x1c,%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5e                   	pop    %esi
  8020ad:	5f                   	pop    %edi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    
  8020b0:	39 f0                	cmp    %esi,%eax
  8020b2:	0f 87 ac 00 00 00    	ja     802164 <__umoddi3+0xfc>
  8020b8:	0f bd e8             	bsr    %eax,%ebp
  8020bb:	83 f5 1f             	xor    $0x1f,%ebp
  8020be:	0f 84 ac 00 00 00    	je     802170 <__umoddi3+0x108>
  8020c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8020c9:	29 ef                	sub    %ebp,%edi
  8020cb:	89 fe                	mov    %edi,%esi
  8020cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020d1:	89 e9                	mov    %ebp,%ecx
  8020d3:	d3 e0                	shl    %cl,%eax
  8020d5:	89 d7                	mov    %edx,%edi
  8020d7:	89 f1                	mov    %esi,%ecx
  8020d9:	d3 ef                	shr    %cl,%edi
  8020db:	09 c7                	or     %eax,%edi
  8020dd:	89 e9                	mov    %ebp,%ecx
  8020df:	d3 e2                	shl    %cl,%edx
  8020e1:	89 14 24             	mov    %edx,(%esp)
  8020e4:	89 d8                	mov    %ebx,%eax
  8020e6:	d3 e0                	shl    %cl,%eax
  8020e8:	89 c2                	mov    %eax,%edx
  8020ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020ee:	d3 e0                	shl    %cl,%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f8:	89 f1                	mov    %esi,%ecx
  8020fa:	d3 e8                	shr    %cl,%eax
  8020fc:	09 d0                	or     %edx,%eax
  8020fe:	d3 eb                	shr    %cl,%ebx
  802100:	89 da                	mov    %ebx,%edx
  802102:	f7 f7                	div    %edi
  802104:	89 d3                	mov    %edx,%ebx
  802106:	f7 24 24             	mull   (%esp)
  802109:	89 c6                	mov    %eax,%esi
  80210b:	89 d1                	mov    %edx,%ecx
  80210d:	39 d3                	cmp    %edx,%ebx
  80210f:	0f 82 87 00 00 00    	jb     80219c <__umoddi3+0x134>
  802115:	0f 84 91 00 00 00    	je     8021ac <__umoddi3+0x144>
  80211b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80211f:	29 f2                	sub    %esi,%edx
  802121:	19 cb                	sbb    %ecx,%ebx
  802123:	89 d8                	mov    %ebx,%eax
  802125:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802129:	d3 e0                	shl    %cl,%eax
  80212b:	89 e9                	mov    %ebp,%ecx
  80212d:	d3 ea                	shr    %cl,%edx
  80212f:	09 d0                	or     %edx,%eax
  802131:	89 e9                	mov    %ebp,%ecx
  802133:	d3 eb                	shr    %cl,%ebx
  802135:	89 da                	mov    %ebx,%edx
  802137:	83 c4 1c             	add    $0x1c,%esp
  80213a:	5b                   	pop    %ebx
  80213b:	5e                   	pop    %esi
  80213c:	5f                   	pop    %edi
  80213d:	5d                   	pop    %ebp
  80213e:	c3                   	ret    
  80213f:	90                   	nop
  802140:	89 fd                	mov    %edi,%ebp
  802142:	85 ff                	test   %edi,%edi
  802144:	75 0b                	jne    802151 <__umoddi3+0xe9>
  802146:	b8 01 00 00 00       	mov    $0x1,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	f7 f7                	div    %edi
  80214f:	89 c5                	mov    %eax,%ebp
  802151:	89 f0                	mov    %esi,%eax
  802153:	31 d2                	xor    %edx,%edx
  802155:	f7 f5                	div    %ebp
  802157:	89 c8                	mov    %ecx,%eax
  802159:	f7 f5                	div    %ebp
  80215b:	89 d0                	mov    %edx,%eax
  80215d:	e9 44 ff ff ff       	jmp    8020a6 <__umoddi3+0x3e>
  802162:	66 90                	xchg   %ax,%ax
  802164:	89 c8                	mov    %ecx,%eax
  802166:	89 f2                	mov    %esi,%edx
  802168:	83 c4 1c             	add    $0x1c,%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5e                   	pop    %esi
  80216d:	5f                   	pop    %edi
  80216e:	5d                   	pop    %ebp
  80216f:	c3                   	ret    
  802170:	3b 04 24             	cmp    (%esp),%eax
  802173:	72 06                	jb     80217b <__umoddi3+0x113>
  802175:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802179:	77 0f                	ja     80218a <__umoddi3+0x122>
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	29 f9                	sub    %edi,%ecx
  80217f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802183:	89 14 24             	mov    %edx,(%esp)
  802186:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80218a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218e:	8b 14 24             	mov    (%esp),%edx
  802191:	83 c4 1c             	add    $0x1c,%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    
  802199:	8d 76 00             	lea    0x0(%esi),%esi
  80219c:	2b 04 24             	sub    (%esp),%eax
  80219f:	19 fa                	sbb    %edi,%edx
  8021a1:	89 d1                	mov    %edx,%ecx
  8021a3:	89 c6                	mov    %eax,%esi
  8021a5:	e9 71 ff ff ff       	jmp    80211b <__umoddi3+0xb3>
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021b0:	72 ea                	jb     80219c <__umoddi3+0x134>
  8021b2:	89 d9                	mov    %ebx,%ecx
  8021b4:	e9 62 ff ff ff       	jmp    80211b <__umoddi3+0xb3>
