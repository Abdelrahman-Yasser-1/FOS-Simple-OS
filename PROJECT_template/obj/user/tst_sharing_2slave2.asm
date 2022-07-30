
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 b0 01 00 00       	call   8001e6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 23                	jmp    80006f <_main+0x37>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	c1 e2 04             	shl    $0x4,%edx
  80005d:	01 d0                	add    %edx,%eax
  80005f:	8a 40 04             	mov    0x4(%eax),%al
  800062:	84 c0                	test   %al,%al
  800064:	74 06                	je     80006c <_main+0x34>
			{
				fullWS = 0;
  800066:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006a:	eb 12                	jmp    80007e <_main+0x46>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006c:	ff 45 f0             	incl   -0x10(%ebp)
  80006f:	a1 20 30 80 00       	mov    0x803020,%eax
  800074:	8b 50 74             	mov    0x74(%eax),%edx
  800077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	77 ce                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800082:	74 14                	je     800098 <_main+0x60>
  800084:	83 ec 04             	sub    $0x4,%esp
  800087:	68 a0 21 80 00       	push   $0x8021a0
  80008c:	6a 13                	push   $0x13
  80008e:	68 bc 21 80 00       	push   $0x8021bc
  800093:	e8 93 02 00 00       	call   80032b <_panic>
	}

	int32 parentenvID = sys_getparentenvid();
  800098:	e8 dd 18 00 00       	call   80197a <sys_getparentenvid>
  80009d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a0:	e8 57 1a 00 00       	call   801afc <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000a5:	e8 82 19 00 00       	call   801a2c <sys_calculate_free_frames>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 d7 21 80 00       	push   $0x8021d7
  8000b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b8:	e8 55 17 00 00       	call   801812 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c3:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 dc 21 80 00       	push   $0x8021dc
  8000d4:	6a 1e                	push   $0x1e
  8000d6:	68 bc 21 80 00       	push   $0x8021bc
  8000db:	e8 4b 02 00 00       	call   80032b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e3:	e8 44 19 00 00       	call   801a2c <sys_calculate_free_frames>
  8000e8:	29 c3                	sub    %eax,%ebx
  8000ea:	89 d8                	mov    %ebx,%eax
  8000ec:	83 f8 01             	cmp    $0x1,%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 3c 22 80 00       	push   $0x80223c
  8000f9:	6a 1f                	push   $0x1f
  8000fb:	68 bc 21 80 00       	push   $0x8021bc
  800100:	e8 26 02 00 00       	call   80032b <_panic>
	sys_enable_interrupt();
  800105:	e8 0c 1a 00 00       	call   801b16 <sys_enable_interrupt>

	sys_disable_interrupt();
  80010a:	e8 ed 19 00 00       	call   801afc <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80010f:	e8 18 19 00 00       	call   801a2c <sys_calculate_free_frames>
  800114:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	68 cd 22 80 00       	push   $0x8022cd
  80011f:	ff 75 ec             	pushl  -0x14(%ebp)
  800122:	e8 eb 16 00 00       	call   801812 <sget>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012d:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 dc 21 80 00       	push   $0x8021dc
  80013e:	6a 25                	push   $0x25
  800140:	68 bc 21 80 00       	push   $0x8021bc
  800145:	e8 e1 01 00 00       	call   80032b <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80014a:	e8 dd 18 00 00       	call   801a2c <sys_calculate_free_frames>
  80014f:	89 c2                	mov    %eax,%edx
  800151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800154:	39 c2                	cmp    %eax,%edx
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 3c 22 80 00       	push   $0x80223c
  800160:	6a 26                	push   $0x26
  800162:	68 bc 21 80 00       	push   $0x8021bc
  800167:	e8 bf 01 00 00       	call   80032b <_panic>
	sys_enable_interrupt();
  80016c:	e8 a5 19 00 00       	call   801b16 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800174:	8b 00                	mov    (%eax),%eax
  800176:	83 f8 0a             	cmp    $0xa,%eax
  800179:	74 14                	je     80018f <_main+0x157>
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	68 d0 22 80 00       	push   $0x8022d0
  800183:	6a 29                	push   $0x29
  800185:	68 bc 21 80 00       	push   $0x8021bc
  80018a:	e8 9c 01 00 00       	call   80032b <_panic>

	//Edit the writable object
	*z = 30;
  80018f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800192:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80019b:	8b 00                	mov    (%eax),%eax
  80019d:	83 f8 1e             	cmp    $0x1e,%eax
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 d0 22 80 00       	push   $0x8022d0
  8001aa:	6a 2d                	push   $0x2d
  8001ac:	68 bc 21 80 00       	push   $0x8021bc
  8001b1:	e8 75 01 00 00       	call   80032b <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001bc:	68 08 23 80 00       	push   $0x802308
  8001c1:	e8 07 04 00 00       	call   8005cd <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cc:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	68 38 23 80 00       	push   $0x802338
  8001da:	6a 33                	push   $0x33
  8001dc:	68 bc 21 80 00       	push   $0x8021bc
  8001e1:	e8 45 01 00 00       	call   80032b <_panic>

008001e6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ec:	e8 70 17 00 00       	call   801961 <sys_getenvindex>
  8001f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f7:	89 d0                	mov    %edx,%eax
  8001f9:	c1 e0 03             	shl    $0x3,%eax
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800205:	01 c8                	add    %ecx,%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	01 d0                	add    %edx,%eax
  80020b:	01 c0                	add    %eax,%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	89 c2                	mov    %eax,%edx
  800211:	c1 e2 05             	shl    $0x5,%edx
  800214:	29 c2                	sub    %eax,%edx
  800216:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80021d:	89 c2                	mov    %eax,%edx
  80021f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800225:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800235:	84 c0                	test   %al,%al
  800237:	74 0f                	je     800248 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	05 40 3c 01 00       	add    $0x13c40,%eax
  800243:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024c:	7e 0a                	jle    800258 <libmain+0x72>
		binaryname = argv[0];
  80024e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800251:	8b 00                	mov    (%eax),%eax
  800253:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	ff 75 0c             	pushl  0xc(%ebp)
  80025e:	ff 75 08             	pushl  0x8(%ebp)
  800261:	e8 d2 fd ff ff       	call   800038 <_main>
  800266:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800269:	e8 8e 18 00 00       	call   801afc <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	68 94 23 80 00       	push   $0x802394
  800276:	e8 52 03 00 00       	call   8005cd <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027e:	a1 20 30 80 00       	mov    0x803020,%eax
  800283:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800289:	a1 20 30 80 00       	mov    0x803020,%eax
  80028e:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	52                   	push   %edx
  800298:	50                   	push   %eax
  800299:	68 bc 23 80 00       	push   $0x8023bc
  80029e:	e8 2a 03 00 00       	call   8005cd <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8002a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ab:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8002b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b6:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8002bc:	83 ec 04             	sub    $0x4,%esp
  8002bf:	52                   	push   %edx
  8002c0:	50                   	push   %eax
  8002c1:	68 e4 23 80 00       	push   $0x8023e4
  8002c6:	e8 02 03 00 00       	call   8005cd <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d3:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	50                   	push   %eax
  8002dd:	68 25 24 80 00       	push   $0x802425
  8002e2:	e8 e6 02 00 00       	call   8005cd <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	68 94 23 80 00       	push   $0x802394
  8002f2:	e8 d6 02 00 00       	call   8005cd <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002fa:	e8 17 18 00 00       	call   801b16 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002ff:	e8 19 00 00 00       	call   80031d <exit>
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	6a 00                	push   $0x0
  800312:	e8 16 16 00 00       	call   80192d <sys_env_destroy>
  800317:	83 c4 10             	add    $0x10,%esp
}
  80031a:	90                   	nop
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <exit>:

void
exit(void)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800323:	e8 6b 16 00 00       	call   801993 <sys_env_exit>
}
  800328:	90                   	nop
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800331:	8d 45 10             	lea    0x10(%ebp),%eax
  800334:	83 c0 04             	add    $0x4,%eax
  800337:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033a:	a1 18 31 80 00       	mov    0x803118,%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	74 16                	je     800359 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800343:	a1 18 31 80 00       	mov    0x803118,%eax
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	50                   	push   %eax
  80034c:	68 3c 24 80 00       	push   $0x80243c
  800351:	e8 77 02 00 00       	call   8005cd <cprintf>
  800356:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800359:	a1 00 30 80 00       	mov    0x803000,%eax
  80035e:	ff 75 0c             	pushl  0xc(%ebp)
  800361:	ff 75 08             	pushl  0x8(%ebp)
  800364:	50                   	push   %eax
  800365:	68 41 24 80 00       	push   $0x802441
  80036a:	e8 5e 02 00 00       	call   8005cd <cprintf>
  80036f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800372:	8b 45 10             	mov    0x10(%ebp),%eax
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	ff 75 f4             	pushl  -0xc(%ebp)
  80037b:	50                   	push   %eax
  80037c:	e8 e1 01 00 00       	call   800562 <vcprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	6a 00                	push   $0x0
  800389:	68 5d 24 80 00       	push   $0x80245d
  80038e:	e8 cf 01 00 00       	call   800562 <vcprintf>
  800393:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800396:	e8 82 ff ff ff       	call   80031d <exit>

	// should not return here
	while (1) ;
  80039b:	eb fe                	jmp    80039b <_panic+0x70>

0080039d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 50 74             	mov    0x74(%eax),%edx
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	39 c2                	cmp    %eax,%edx
  8003b0:	74 14                	je     8003c6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	68 60 24 80 00       	push   $0x802460
  8003ba:	6a 26                	push   $0x26
  8003bc:	68 ac 24 80 00       	push   $0x8024ac
  8003c1:	e8 65 ff ff ff       	call   80032b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d4:	e9 b6 00 00 00       	jmp    80048f <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	75 08                	jne    8003f6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f1:	e9 96 00 00 00       	jmp    80048c <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800404:	eb 5d                	jmp    800463 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800406:	a1 20 30 80 00       	mov    0x803020,%eax
  80040b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800414:	c1 e2 04             	shl    $0x4,%edx
  800417:	01 d0                	add    %edx,%eax
  800419:	8a 40 04             	mov    0x4(%eax),%al
  80041c:	84 c0                	test   %al,%al
  80041e:	75 40                	jne    800460 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800420:	a1 20 30 80 00       	mov    0x803020,%eax
  800425:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80042b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042e:	c1 e2 04             	shl    $0x4,%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800438:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800440:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800453:	39 c2                	cmp    %eax,%edx
  800455:	75 09                	jne    800460 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800457:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80045e:	eb 12                	jmp    800472 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800460:	ff 45 e8             	incl   -0x18(%ebp)
  800463:	a1 20 30 80 00       	mov    0x803020,%eax
  800468:	8b 50 74             	mov    0x74(%eax),%edx
  80046b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	77 94                	ja     800406 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800472:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800476:	75 14                	jne    80048c <CheckWSWithoutLastIndex+0xef>
			panic(
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 b8 24 80 00       	push   $0x8024b8
  800480:	6a 3a                	push   $0x3a
  800482:	68 ac 24 80 00       	push   $0x8024ac
  800487:	e8 9f fe ff ff       	call   80032b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80048c:	ff 45 f0             	incl   -0x10(%ebp)
  80048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800492:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800495:	0f 8c 3e ff ff ff    	jl     8003d9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80049b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a9:	eb 20                	jmp    8004cb <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8004b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b9:	c1 e2 04             	shl    $0x4,%edx
  8004bc:	01 d0                	add    %edx,%eax
  8004be:	8a 40 04             	mov    0x4(%eax),%al
  8004c1:	3c 01                	cmp    $0x1,%al
  8004c3:	75 03                	jne    8004c8 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8004c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c8:	ff 45 e0             	incl   -0x20(%ebp)
  8004cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d0:	8b 50 74             	mov    0x74(%eax),%edx
  8004d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d6:	39 c2                	cmp    %eax,%edx
  8004d8:	77 d1                	ja     8004ab <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e0:	74 14                	je     8004f6 <CheckWSWithoutLastIndex+0x159>
		panic(
  8004e2:	83 ec 04             	sub    $0x4,%esp
  8004e5:	68 0c 25 80 00       	push   $0x80250c
  8004ea:	6a 44                	push   $0x44
  8004ec:	68 ac 24 80 00       	push   $0x8024ac
  8004f1:	e8 35 fe ff ff       	call   80032b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 48 01             	lea    0x1(%eax),%ecx
  800507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050a:	89 0a                	mov    %ecx,(%edx)
  80050c:	8b 55 08             	mov    0x8(%ebp),%edx
  80050f:	88 d1                	mov    %dl,%cl
  800511:	8b 55 0c             	mov    0xc(%ebp),%edx
  800514:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800522:	75 2c                	jne    800550 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800524:	a0 24 30 80 00       	mov    0x803024,%al
  800529:	0f b6 c0             	movzbl %al,%eax
  80052c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052f:	8b 12                	mov    (%edx),%edx
  800531:	89 d1                	mov    %edx,%ecx
  800533:	8b 55 0c             	mov    0xc(%ebp),%edx
  800536:	83 c2 08             	add    $0x8,%edx
  800539:	83 ec 04             	sub    $0x4,%esp
  80053c:	50                   	push   %eax
  80053d:	51                   	push   %ecx
  80053e:	52                   	push   %edx
  80053f:	e8 a7 13 00 00       	call   8018eb <sys_cputs>
  800544:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 40 04             	mov    0x4(%eax),%eax
  800556:	8d 50 01             	lea    0x1(%eax),%edx
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055f:	90                   	nop
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800572:	00 00 00 
	b.cnt = 0;
  800575:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80057c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058b:	50                   	push   %eax
  80058c:	68 f9 04 80 00       	push   $0x8004f9
  800591:	e8 11 02 00 00       	call   8007a7 <vprintfmt>
  800596:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800599:	a0 24 30 80 00       	mov    0x803024,%al
  80059e:	0f b6 c0             	movzbl %al,%eax
  8005a1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a7:	83 ec 04             	sub    $0x4,%esp
  8005aa:	50                   	push   %eax
  8005ab:	52                   	push   %edx
  8005ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b2:	83 c0 08             	add    $0x8,%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 30 13 00 00       	call   8018eb <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005be:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cb:	c9                   	leave  
  8005cc:	c3                   	ret    

008005cd <cprintf>:

int cprintf(const char *fmt, ...) {
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 73 ff ff ff       	call   800562 <vcprintf>
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800600:	e8 f7 14 00 00       	call   801afc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800605:	8d 45 0c             	lea    0xc(%ebp),%eax
  800608:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 f4             	pushl  -0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	e8 48 ff ff ff       	call   800562 <vcprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800620:	e8 f1 14 00 00       	call   801b16 <sys_enable_interrupt>
	return cnt;
  800625:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800628:	c9                   	leave  
  800629:	c3                   	ret    

0080062a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	53                   	push   %ebx
  80062e:	83 ec 14             	sub    $0x14,%esp
  800631:	8b 45 10             	mov    0x10(%ebp),%eax
  800634:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80063d:	8b 45 18             	mov    0x18(%ebp),%eax
  800640:	ba 00 00 00 00       	mov    $0x0,%edx
  800645:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800648:	77 55                	ja     80069f <printnum+0x75>
  80064a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064d:	72 05                	jb     800654 <printnum+0x2a>
  80064f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800652:	77 4b                	ja     80069f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800654:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800657:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065a:	8b 45 18             	mov    0x18(%ebp),%eax
  80065d:	ba 00 00 00 00       	mov    $0x0,%edx
  800662:	52                   	push   %edx
  800663:	50                   	push   %eax
  800664:	ff 75 f4             	pushl  -0xc(%ebp)
  800667:	ff 75 f0             	pushl  -0x10(%ebp)
  80066a:	e8 b1 18 00 00       	call   801f20 <__udivdi3>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	ff 75 20             	pushl  0x20(%ebp)
  800678:	53                   	push   %ebx
  800679:	ff 75 18             	pushl  0x18(%ebp)
  80067c:	52                   	push   %edx
  80067d:	50                   	push   %eax
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	ff 75 08             	pushl  0x8(%ebp)
  800684:	e8 a1 ff ff ff       	call   80062a <printnum>
  800689:	83 c4 20             	add    $0x20,%esp
  80068c:	eb 1a                	jmp    8006a8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	ff 75 0c             	pushl  0xc(%ebp)
  800694:	ff 75 20             	pushl  0x20(%ebp)
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	ff d0                	call   *%eax
  80069c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069f:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a6:	7f e6                	jg     80068e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b6:	53                   	push   %ebx
  8006b7:	51                   	push   %ecx
  8006b8:	52                   	push   %edx
  8006b9:	50                   	push   %eax
  8006ba:	e8 71 19 00 00       	call   802030 <__umoddi3>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	05 74 27 80 00       	add    $0x802774,%eax
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f be c0             	movsbl %al,%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
}
  8006db:	90                   	nop
  8006dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 40                	jmp    800746 <getuint+0x65>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1e                	je     80072a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	eb 1c                	jmp    800746 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800746:	5d                   	pop    %ebp
  800747:	c3                   	ret    

00800748 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074f:	7e 1c                	jle    80076d <getint+0x25>
		return va_arg(*ap, long long);
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	8d 50 08             	lea    0x8(%eax),%edx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	89 10                	mov    %edx,(%eax)
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	83 e8 08             	sub    $0x8,%eax
  800766:	8b 50 04             	mov    0x4(%eax),%edx
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	eb 38                	jmp    8007a5 <getint+0x5d>
	else if (lflag)
  80076d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800771:	74 1a                	je     80078d <getint+0x45>
		return va_arg(*ap, long);
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	8d 50 04             	lea    0x4(%eax),%edx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 10                	mov    %edx,(%eax)
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	83 e8 04             	sub    $0x4,%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	99                   	cltd   
  80078b:	eb 18                	jmp    8007a5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
}
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	56                   	push   %esi
  8007ab:	53                   	push   %ebx
  8007ac:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007af:	eb 17                	jmp    8007c8 <vprintfmt+0x21>
			if (ch == '\0')
  8007b1:	85 db                	test   %ebx,%ebx
  8007b3:	0f 84 af 03 00 00    	je     800b68 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	53                   	push   %ebx
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	ff d0                	call   *%eax
  8007c5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cb:	8d 50 01             	lea    0x1(%eax),%edx
  8007ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d1:	8a 00                	mov    (%eax),%al
  8007d3:	0f b6 d8             	movzbl %al,%ebx
  8007d6:	83 fb 25             	cmp    $0x25,%ebx
  8007d9:	75 d6                	jne    8007b1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007db:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fe:	8d 50 01             	lea    0x1(%eax),%edx
  800801:	89 55 10             	mov    %edx,0x10(%ebp)
  800804:	8a 00                	mov    (%eax),%al
  800806:	0f b6 d8             	movzbl %al,%ebx
  800809:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80080c:	83 f8 55             	cmp    $0x55,%eax
  80080f:	0f 87 2b 03 00 00    	ja     800b40 <vprintfmt+0x399>
  800815:	8b 04 85 98 27 80 00 	mov    0x802798(,%eax,4),%eax
  80081c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800822:	eb d7                	jmp    8007fb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800824:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800828:	eb d1                	jmp    8007fb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800831:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800834:	89 d0                	mov    %edx,%eax
  800836:	c1 e0 02             	shl    $0x2,%eax
  800839:	01 d0                	add    %edx,%eax
  80083b:	01 c0                	add    %eax,%eax
  80083d:	01 d8                	add    %ebx,%eax
  80083f:	83 e8 30             	sub    $0x30,%eax
  800842:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800845:	8b 45 10             	mov    0x10(%ebp),%eax
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80084d:	83 fb 2f             	cmp    $0x2f,%ebx
  800850:	7e 3e                	jle    800890 <vprintfmt+0xe9>
  800852:	83 fb 39             	cmp    $0x39,%ebx
  800855:	7f 39                	jg     800890 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800857:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085a:	eb d5                	jmp    800831 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	83 c0 04             	add    $0x4,%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800870:	eb 1f                	jmp    800891 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800872:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800876:	79 83                	jns    8007fb <vprintfmt+0x54>
				width = 0;
  800878:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087f:	e9 77 ff ff ff       	jmp    8007fb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800884:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80088b:	e9 6b ff ff ff       	jmp    8007fb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800890:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800891:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800895:	0f 89 60 ff ff ff    	jns    8007fb <vprintfmt+0x54>
				width = precision, precision = -1;
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a8:	e9 4e ff ff ff       	jmp    8007fb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ad:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b0:	e9 46 ff ff ff       	jmp    8007fb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	83 c0 04             	add    $0x4,%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	83 e8 04             	sub    $0x4,%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	50                   	push   %eax
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	ff d0                	call   *%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
			break;
  8008d5:	e9 89 02 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 c0 04             	add    $0x4,%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008eb:	85 db                	test   %ebx,%ebx
  8008ed:	79 02                	jns    8008f1 <vprintfmt+0x14a>
				err = -err;
  8008ef:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f1:	83 fb 64             	cmp    $0x64,%ebx
  8008f4:	7f 0b                	jg     800901 <vprintfmt+0x15a>
  8008f6:	8b 34 9d e0 25 80 00 	mov    0x8025e0(,%ebx,4),%esi
  8008fd:	85 f6                	test   %esi,%esi
  8008ff:	75 19                	jne    80091a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800901:	53                   	push   %ebx
  800902:	68 85 27 80 00       	push   $0x802785
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 5e 02 00 00       	call   800b70 <printfmt>
  800912:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800915:	e9 49 02 00 00       	jmp    800b63 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091a:	56                   	push   %esi
  80091b:	68 8e 27 80 00       	push   $0x80278e
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	ff 75 08             	pushl  0x8(%ebp)
  800926:	e8 45 02 00 00       	call   800b70 <printfmt>
  80092b:	83 c4 10             	add    $0x10,%esp
			break;
  80092e:	e9 30 02 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	83 c0 04             	add    $0x4,%eax
  800939:	89 45 14             	mov    %eax,0x14(%ebp)
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	83 e8 04             	sub    $0x4,%eax
  800942:	8b 30                	mov    (%eax),%esi
  800944:	85 f6                	test   %esi,%esi
  800946:	75 05                	jne    80094d <vprintfmt+0x1a6>
				p = "(null)";
  800948:	be 91 27 80 00       	mov    $0x802791,%esi
			if (width > 0 && padc != '-')
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	7e 6d                	jle    8009c0 <vprintfmt+0x219>
  800953:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800957:	74 67                	je     8009c0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	50                   	push   %eax
  800960:	56                   	push   %esi
  800961:	e8 0c 03 00 00       	call   800c72 <strnlen>
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80096c:	eb 16                	jmp    800984 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	50                   	push   %eax
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	ff d0                	call   *%eax
  80097e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800981:	ff 4d e4             	decl   -0x1c(%ebp)
  800984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800988:	7f e4                	jg     80096e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098a:	eb 34                	jmp    8009c0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80098c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800990:	74 1c                	je     8009ae <vprintfmt+0x207>
  800992:	83 fb 1f             	cmp    $0x1f,%ebx
  800995:	7e 05                	jle    80099c <vprintfmt+0x1f5>
  800997:	83 fb 7e             	cmp    $0x7e,%ebx
  80099a:	7e 12                	jle    8009ae <vprintfmt+0x207>
					putch('?', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	6a 3f                	push   $0x3f
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	ff d0                	call   *%eax
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	eb 0f                	jmp    8009bd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c0:	89 f0                	mov    %esi,%eax
  8009c2:	8d 70 01             	lea    0x1(%eax),%esi
  8009c5:	8a 00                	mov    (%eax),%al
  8009c7:	0f be d8             	movsbl %al,%ebx
  8009ca:	85 db                	test   %ebx,%ebx
  8009cc:	74 24                	je     8009f2 <vprintfmt+0x24b>
  8009ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d2:	78 b8                	js     80098c <vprintfmt+0x1e5>
  8009d4:	ff 4d e0             	decl   -0x20(%ebp)
  8009d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009db:	79 af                	jns    80098c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009dd:	eb 13                	jmp    8009f2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 20                	push   $0x20
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	7f e7                	jg     8009df <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f8:	e9 66 01 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 e8             	pushl  -0x18(%ebp)
  800a03:	8d 45 14             	lea    0x14(%ebp),%eax
  800a06:	50                   	push   %eax
  800a07:	e8 3c fd ff ff       	call   800748 <getint>
  800a0c:	83 c4 10             	add    $0x10,%esp
  800a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1b:	85 d2                	test   %edx,%edx
  800a1d:	79 23                	jns    800a42 <vprintfmt+0x29b>
				putch('-', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 2d                	push   $0x2d
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a35:	f7 d8                	neg    %eax
  800a37:	83 d2 00             	adc    $0x0,%edx
  800a3a:	f7 da                	neg    %edx
  800a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a42:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a49:	e9 bc 00 00 00       	jmp    800b0a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 84 fc ff ff       	call   8006e1 <getuint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a66:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6d:	e9 98 00 00 00       	jmp    800b0a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a72:	83 ec 08             	sub    $0x8,%esp
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	6a 58                	push   $0x58
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 58                	push   $0x58
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	6a 58                	push   $0x58
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			break;
  800aa2:	e9 bc 00 00 00       	jmp    800b63 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	6a 30                	push   $0x30
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 78                	push   $0x78
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 e8 04             	sub    $0x4,%eax
  800ad6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae9:	eb 1f                	jmp    800b0a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 e8             	pushl  -0x18(%ebp)
  800af1:	8d 45 14             	lea    0x14(%ebp),%eax
  800af4:	50                   	push   %eax
  800af5:	e8 e7 fb ff ff       	call   8006e1 <getuint>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b03:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b11:	83 ec 04             	sub    $0x4,%esp
  800b14:	52                   	push   %edx
  800b15:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b18:	50                   	push   %eax
  800b19:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 00 fb ff ff       	call   80062a <printnum>
  800b2a:	83 c4 20             	add    $0x20,%esp
			break;
  800b2d:	eb 34                	jmp    800b63 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	53                   	push   %ebx
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			break;
  800b3e:	eb 23                	jmp    800b63 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	6a 25                	push   $0x25
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b50:	ff 4d 10             	decl   0x10(%ebp)
  800b53:	eb 03                	jmp    800b58 <vprintfmt+0x3b1>
  800b55:	ff 4d 10             	decl   0x10(%ebp)
  800b58:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5b:	48                   	dec    %eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	3c 25                	cmp    $0x25,%al
  800b60:	75 f3                	jne    800b55 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b62:	90                   	nop
		}
	}
  800b63:	e9 47 fc ff ff       	jmp    8007af <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b68:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b76:	8d 45 10             	lea    0x10(%ebp),%eax
  800b79:	83 c0 04             	add    $0x4,%eax
  800b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	ff 75 f4             	pushl  -0xc(%ebp)
  800b85:	50                   	push   %eax
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	ff 75 08             	pushl  0x8(%ebp)
  800b8c:	e8 16 fc ff ff       	call   8007a7 <vprintfmt>
  800b91:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b94:	90                   	nop
  800b95:	c9                   	leave  
  800b96:	c3                   	ret    

00800b97 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 40 08             	mov    0x8(%eax),%eax
  800ba0:	8d 50 01             	lea    0x1(%eax),%edx
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8b 10                	mov    (%eax),%edx
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	8b 40 04             	mov    0x4(%eax),%eax
  800bb4:	39 c2                	cmp    %eax,%edx
  800bb6:	73 12                	jae    800bca <sprintputch+0x33>
		*b->buf++ = ch;
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 48 01             	lea    0x1(%eax),%ecx
  800bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc3:	89 0a                	mov    %ecx,(%edx)
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	88 10                	mov    %dl,(%eax)
}
  800bca:	90                   	nop
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	01 d0                	add    %edx,%eax
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf2:	74 06                	je     800bfa <vsnprintf+0x2d>
  800bf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf8:	7f 07                	jg     800c01 <vsnprintf+0x34>
		return -E_INVAL;
  800bfa:	b8 03 00 00 00       	mov    $0x3,%eax
  800bff:	eb 20                	jmp    800c21 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c01:	ff 75 14             	pushl  0x14(%ebp)
  800c04:	ff 75 10             	pushl  0x10(%ebp)
  800c07:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c0a:	50                   	push   %eax
  800c0b:	68 97 0b 80 00       	push   $0x800b97
  800c10:	e8 92 fb ff ff       	call   8007a7 <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c29:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2c:	83 c0 04             	add    $0x4,%eax
  800c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	ff 75 f4             	pushl  -0xc(%ebp)
  800c38:	50                   	push   %eax
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	ff 75 08             	pushl  0x8(%ebp)
  800c3f:	e8 89 ff ff ff       	call   800bcd <vsnprintf>
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5c:	eb 06                	jmp    800c64 <strlen+0x15>
		n++;
  800c5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c61:	ff 45 08             	incl   0x8(%ebp)
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	84 c0                	test   %al,%al
  800c6b:	75 f1                	jne    800c5e <strlen+0xf>
		n++;
	return n;
  800c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7f:	eb 09                	jmp    800c8a <strnlen+0x18>
		n++;
  800c81:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	ff 4d 0c             	decl   0xc(%ebp)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 09                	je     800c99 <strnlen+0x27>
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 e8                	jne    800c81 <strnlen+0xf>
		n++;
	return n;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800caa:	90                   	nop
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	75 e4                	jne    800cab <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    

00800ccc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdf:	eb 1f                	jmp    800d00 <strncpy+0x34>
		*dst++ = *src;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8d 50 01             	lea    0x1(%eax),%edx
  800ce7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ced:	8a 12                	mov    (%edx),%dl
  800cef:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	84 c0                	test   %al,%al
  800cf8:	74 03                	je     800cfd <strncpy+0x31>
			src++;
  800cfa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfd:	ff 45 fc             	incl   -0x4(%ebp)
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d06:	72 d9                	jb     800ce1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	74 30                	je     800d4f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1f:	eb 16                	jmp    800d37 <strlcpy+0x2a>
			*dst++ = *src++;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d33:	8a 12                	mov    (%edx),%dl
  800d35:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d37:	ff 4d 10             	decl   0x10(%ebp)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 09                	je     800d49 <strlcpy+0x3c>
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	75 d8                	jne    800d21 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d55:	29 c2                	sub    %eax,%edx
  800d57:	89 d0                	mov    %edx,%eax
}
  800d59:	c9                   	leave  
  800d5a:	c3                   	ret    

00800d5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5e:	eb 06                	jmp    800d66 <strcmp+0xb>
		p++, q++;
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	84 c0                	test   %al,%al
  800d6d:	74 0e                	je     800d7d <strcmp+0x22>
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 10                	mov    (%eax),%dl
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	38 c2                	cmp    %al,%dl
  800d7b:	74 e3                	je     800d60 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	0f b6 d0             	movzbl %al,%edx
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 c0             	movzbl %al,%eax
  800d8d:	29 c2                	sub    %eax,%edx
  800d8f:	89 d0                	mov    %edx,%eax
}
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d96:	eb 09                	jmp    800da1 <strncmp+0xe>
		n--, p++, q++;
  800d98:	ff 4d 10             	decl   0x10(%ebp)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800da1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da5:	74 17                	je     800dbe <strncmp+0x2b>
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 0e                	je     800dbe <strncmp+0x2b>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 10                	mov    (%eax),%dl
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	38 c2                	cmp    %al,%dl
  800dbc:	74 da                	je     800d98 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	75 07                	jne    800dcb <strncmp+0x38>
		return 0;
  800dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc9:	eb 14                	jmp    800ddf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	0f b6 d0             	movzbl %al,%edx
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	0f b6 c0             	movzbl %al,%eax
  800ddb:	29 c2                	sub    %eax,%edx
  800ddd:	89 d0                	mov    %edx,%eax
}
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 12                	jmp    800e01 <strchr+0x20>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	75 05                	jne    800dfe <strchr+0x1d>
			return (char *) s;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	eb 11                	jmp    800e0f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfe:	ff 45 08             	incl   0x8(%ebp)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	84 c0                	test   %al,%al
  800e08:	75 e5                	jne    800def <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 04             	sub    $0x4,%esp
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1d:	eb 0d                	jmp    800e2c <strfind+0x1b>
		if (*s == c)
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e27:	74 0e                	je     800e37 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	84 c0                	test   %al,%al
  800e33:	75 ea                	jne    800e1f <strfind+0xe>
  800e35:	eb 01                	jmp    800e38 <strfind+0x27>
		if (*s == c)
			break;
  800e37:	90                   	nop
	return (char *) s;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e49:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4f:	eb 0e                	jmp    800e5f <memset+0x22>
		*p++ = c;
  800e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5f:	ff 4d f8             	decl   -0x8(%ebp)
  800e62:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e66:	79 e9                	jns    800e51 <memset+0x14>
		*p++ = c;

	return v;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7f:	eb 16                	jmp    800e97 <memcpy+0x2a>
		*d++ = *s++;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e84:	8d 50 01             	lea    0x1(%eax),%edx
  800e87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e93:	8a 12                	mov    (%edx),%dl
  800e95:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	75 dd                	jne    800e81 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ec1:	73 50                	jae    800f13 <memmove+0x6a>
  800ec3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec9:	01 d0                	add    %edx,%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	76 43                	jbe    800f13 <memmove+0x6a>
		s += n;
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800edc:	eb 10                	jmp    800eee <memmove+0x45>
			*--d = *--s;
  800ede:	ff 4d f8             	decl   -0x8(%ebp)
  800ee1:	ff 4d fc             	decl   -0x4(%ebp)
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 10                	mov    (%eax),%dl
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	75 e3                	jne    800ede <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800efb:	eb 23                	jmp    800f20 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f00:	8d 50 01             	lea    0x1(%eax),%edx
  800f03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0f:	8a 12                	mov    (%edx),%dl
  800f11:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f13:	8b 45 10             	mov    0x10(%ebp),%eax
  800f16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f19:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	75 dd                	jne    800efd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f37:	eb 2a                	jmp    800f63 <memcmp+0x3e>
		if (*s1 != *s2)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	38 c2                	cmp    %al,%dl
  800f45:	74 16                	je     800f5d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	0f b6 d0             	movzbl %al,%edx
  800f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	0f b6 c0             	movzbl %al,%eax
  800f57:	29 c2                	sub    %eax,%edx
  800f59:	89 d0                	mov    %edx,%eax
  800f5b:	eb 18                	jmp    800f75 <memcmp+0x50>
		s1++, s2++;
  800f5d:	ff 45 fc             	incl   -0x4(%ebp)
  800f60:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f63:	8b 45 10             	mov    0x10(%ebp),%eax
  800f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f69:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	75 c9                	jne    800f39 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 45 10             	mov    0x10(%ebp),%eax
  800f83:	01 d0                	add    %edx,%eax
  800f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f88:	eb 15                	jmp    800f9f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	0f b6 d0             	movzbl %al,%edx
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	39 c2                	cmp    %eax,%edx
  800f9a:	74 0d                	je     800fa9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa5:	72 e3                	jb     800f8a <memfind+0x13>
  800fa7:	eb 01                	jmp    800faa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa9:	90                   	nop
	return (void *) s;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc3:	eb 03                	jmp    800fc8 <strtol+0x19>
		s++;
  800fc5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 20                	cmp    $0x20,%al
  800fcf:	74 f4                	je     800fc5 <strtol+0x16>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 09                	cmp    $0x9,%al
  800fd8:	74 eb                	je     800fc5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 2b                	cmp    $0x2b,%al
  800fe1:	75 05                	jne    800fe8 <strtol+0x39>
		s++;
  800fe3:	ff 45 08             	incl   0x8(%ebp)
  800fe6:	eb 13                	jmp    800ffb <strtol+0x4c>
	else if (*s == '-')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2d                	cmp    $0x2d,%al
  800fef:	75 0a                	jne    800ffb <strtol+0x4c>
		s++, neg = 1;
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	74 06                	je     801007 <strtol+0x58>
  801001:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801005:	75 20                	jne    801027 <strtol+0x78>
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 30                	cmp    $0x30,%al
  80100e:	75 17                	jne    801027 <strtol+0x78>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	40                   	inc    %eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 78                	cmp    $0x78,%al
  801018:	75 0d                	jne    801027 <strtol+0x78>
		s += 2, base = 16;
  80101a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801025:	eb 28                	jmp    80104f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801027:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102b:	75 15                	jne    801042 <strtol+0x93>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 30                	cmp    $0x30,%al
  801034:	75 0c                	jne    801042 <strtol+0x93>
		s++, base = 8;
  801036:	ff 45 08             	incl   0x8(%ebp)
  801039:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801040:	eb 0d                	jmp    80104f <strtol+0xa0>
	else if (base == 0)
  801042:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801046:	75 07                	jne    80104f <strtol+0xa0>
		base = 10;
  801048:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	3c 2f                	cmp    $0x2f,%al
  801056:	7e 19                	jle    801071 <strtol+0xc2>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 39                	cmp    $0x39,%al
  80105f:	7f 10                	jg     801071 <strtol+0xc2>
			dig = *s - '0';
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f be c0             	movsbl %al,%eax
  801069:	83 e8 30             	sub    $0x30,%eax
  80106c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106f:	eb 42                	jmp    8010b3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 60                	cmp    $0x60,%al
  801078:	7e 19                	jle    801093 <strtol+0xe4>
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 7a                	cmp    $0x7a,%al
  801081:	7f 10                	jg     801093 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f be c0             	movsbl %al,%eax
  80108b:	83 e8 57             	sub    $0x57,%eax
  80108e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801091:	eb 20                	jmp    8010b3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	3c 40                	cmp    $0x40,%al
  80109a:	7e 39                	jle    8010d5 <strtol+0x126>
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 5a                	cmp    $0x5a,%al
  8010a3:	7f 30                	jg     8010d5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	0f be c0             	movsbl %al,%eax
  8010ad:	83 e8 37             	sub    $0x37,%eax
  8010b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b9:	7d 19                	jge    8010d4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010bb:	ff 45 08             	incl   0x8(%ebp)
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c5:	89 c2                	mov    %eax,%edx
  8010c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ca:	01 d0                	add    %edx,%eax
  8010cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cf:	e9 7b ff ff ff       	jmp    80104f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d9:	74 08                	je     8010e3 <strtol+0x134>
		*endptr = (char *) s;
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e7:	74 07                	je     8010f0 <strtol+0x141>
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	f7 d8                	neg    %eax
  8010ee:	eb 03                	jmp    8010f3 <strtol+0x144>
  8010f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801102:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110d:	79 13                	jns    801122 <ltostr+0x2d>
	{
		neg = 1;
  80110f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80111c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80112a:	99                   	cltd   
  80112b:	f7 f9                	idiv   %ecx
  80112d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801139:	89 c2                	mov    %eax,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801143:	83 c2 30             	add    $0x30,%edx
  801146:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801148:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80114b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801150:	f7 e9                	imul   %ecx
  801152:	c1 fa 02             	sar    $0x2,%edx
  801155:	89 c8                	mov    %ecx,%eax
  801157:	c1 f8 1f             	sar    $0x1f,%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
  80115e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801161:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801164:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801169:	f7 e9                	imul   %ecx
  80116b:	c1 fa 02             	sar    $0x2,%edx
  80116e:	89 c8                	mov    %ecx,%eax
  801170:	c1 f8 1f             	sar    $0x1f,%eax
  801173:	29 c2                	sub    %eax,%edx
  801175:	89 d0                	mov    %edx,%eax
  801177:	c1 e0 02             	shl    $0x2,%eax
  80117a:	01 d0                	add    %edx,%eax
  80117c:	01 c0                	add    %eax,%eax
  80117e:	29 c1                	sub    %eax,%ecx
  801180:	89 ca                	mov    %ecx,%edx
  801182:	85 d2                	test   %edx,%edx
  801184:	75 9c                	jne    801122 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	48                   	dec    %eax
  801191:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801194:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801198:	74 3d                	je     8011d7 <ltostr+0xe2>
		start = 1 ;
  80119a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a1:	eb 34                	jmp    8011d7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	01 d0                	add    %edx,%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 c2                	add    %eax,%edx
  8011b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011be:	01 c8                	add    %ecx,%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c2                	add    %eax,%edx
  8011cc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cf:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dd:	7c c4                	jl     8011a3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011df:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	01 d0                	add    %edx,%eax
  8011e7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ea:	90                   	nop
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f3:	ff 75 08             	pushl  0x8(%ebp)
  8011f6:	e8 54 fa ff ff       	call   800c4f <strlen>
  8011fb:	83 c4 04             	add    $0x4,%esp
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801201:	ff 75 0c             	pushl  0xc(%ebp)
  801204:	e8 46 fa ff ff       	call   800c4f <strlen>
  801209:	83 c4 04             	add    $0x4,%esp
  80120c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801216:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121d:	eb 17                	jmp    801236 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	01 c2                	add    %eax,%edx
  801227:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	01 c8                	add    %ecx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801233:	ff 45 fc             	incl   -0x4(%ebp)
  801236:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801239:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80123c:	7c e1                	jl     80121f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801245:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80124c:	eb 1f                	jmp    80126d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801251:	8d 50 01             	lea    0x1(%eax),%edx
  801254:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801257:	89 c2                	mov    %eax,%edx
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	01 c2                	add    %eax,%edx
  80125e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 c8                	add    %ecx,%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126a:	ff 45 f8             	incl   -0x8(%ebp)
  80126d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801270:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801273:	7c d9                	jl     80124e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801275:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c6 00 00             	movb   $0x0,(%eax)
}
  801280:	90                   	nop
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128f:	8b 45 14             	mov    0x14(%ebp),%eax
  801292:	8b 00                	mov    (%eax),%eax
  801294:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	01 d0                	add    %edx,%eax
  8012a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a6:	eb 0c                	jmp    8012b4 <strsplit+0x31>
			*string++ = 0;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8d 50 01             	lea    0x1(%eax),%edx
  8012ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	84 c0                	test   %al,%al
  8012bb:	74 18                	je     8012d5 <strsplit+0x52>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	0f be c0             	movsbl %al,%eax
  8012c5:	50                   	push   %eax
  8012c6:	ff 75 0c             	pushl  0xc(%ebp)
  8012c9:	e8 13 fb ff ff       	call   800de1 <strchr>
  8012ce:	83 c4 08             	add    $0x8,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	75 d3                	jne    8012a8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	84 c0                	test   %al,%al
  8012dc:	74 5a                	je     801338 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012de:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e1:	8b 00                	mov    (%eax),%eax
  8012e3:	83 f8 0f             	cmp    $0xf,%eax
  8012e6:	75 07                	jne    8012ef <strsplit+0x6c>
		{
			return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	eb 66                	jmp    801355 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f2:	8b 00                	mov    (%eax),%eax
  8012f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fa:	89 0a                	mov    %ecx,(%edx)
  8012fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130d:	eb 03                	jmp    801312 <strsplit+0x8f>
			string++;
  80130f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 8b                	je     8012a6 <strsplit+0x23>
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	0f be c0             	movsbl %al,%eax
  801323:	50                   	push   %eax
  801324:	ff 75 0c             	pushl  0xc(%ebp)
  801327:	e8 b5 fa ff ff       	call   800de1 <strchr>
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	74 dc                	je     80130f <strsplit+0x8c>
			string++;
	}
  801333:	e9 6e ff ff ff       	jmp    8012a6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801338:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801339:	8b 45 14             	mov    0x14(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801350:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  80135d:	a1 28 30 80 00       	mov    0x803028,%eax
  801362:	85 c0                	test   %eax,%eax
  801364:	75 33                	jne    801399 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801366:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  80136d:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801370:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801377:	00 00 a0 
		spaces[0].pages = numPages;
  80137a:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801381:	00 02 00 
		spaces[0].isFree = 1;
  801384:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  80138b:	00 00 00 
		arraySize++;
  80138e:	a1 28 30 80 00       	mov    0x803028,%eax
  801393:	40                   	inc    %eax
  801394:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801399:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  8013a0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  8013a7:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b4:	01 d0                	add    %edx,%eax
  8013b6:	48                   	dec    %eax
  8013b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c2:	f7 75 e8             	divl   -0x18(%ebp)
  8013c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c8:	29 d0                	sub    %edx,%eax
  8013ca:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	c1 e8 0c             	shr    $0xc,%eax
  8013d3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8013d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8013dd:	eb 57                	jmp    801436 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8013df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e2:	c1 e0 04             	shl    $0x4,%eax
  8013e5:	05 2c 31 80 00       	add    $0x80312c,%eax
  8013ea:	8b 00                	mov    (%eax),%eax
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	74 42                	je     801432 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8013f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f3:	c1 e0 04             	shl    $0x4,%eax
  8013f6:	05 28 31 80 00       	add    $0x803128,%eax
  8013fb:	8b 00                	mov    (%eax),%eax
  8013fd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801400:	7c 31                	jl     801433 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801405:	c1 e0 04             	shl    $0x4,%eax
  801408:	05 28 31 80 00       	add    $0x803128,%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7d 1c                	jge    801433 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141a:	c1 e0 04             	shl    $0x4,%eax
  80141d:	05 28 31 80 00       	add    $0x803128,%eax
  801422:	8b 00                	mov    (%eax),%eax
  801424:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801427:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  80142a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80142d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801430:	eb 01                	jmp    801433 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801432:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801433:	ff 45 ec             	incl   -0x14(%ebp)
  801436:	a1 28 30 80 00       	mov    0x803028,%eax
  80143b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80143e:	7c 9f                	jl     8013df <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801440:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801444:	75 0a                	jne    801450 <malloc+0xf9>
	{
		return NULL;
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
  80144b:	e9 34 01 00 00       	jmp    801584 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801453:	c1 e0 04             	shl    $0x4,%eax
  801456:	05 28 31 80 00       	add    $0x803128,%eax
  80145b:	8b 00                	mov    (%eax),%eax
  80145d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801460:	75 38                	jne    80149a <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801465:	c1 e0 04             	shl    $0x4,%eax
  801468:	05 2c 31 80 00       	add    $0x80312c,%eax
  80146d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801476:	c1 e0 0c             	shl    $0xc,%eax
  801479:	89 c2                	mov    %eax,%edx
  80147b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147e:	c1 e0 04             	shl    $0x4,%eax
  801481:	05 20 31 80 00       	add    $0x803120,%eax
  801486:	8b 00                	mov    (%eax),%eax
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	52                   	push   %edx
  80148c:	50                   	push   %eax
  80148d:	e8 01 06 00 00       	call   801a93 <sys_allocateMem>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	e9 dd 00 00 00       	jmp    801577 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  80149a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149d:	c1 e0 04             	shl    $0x4,%eax
  8014a0:	05 20 31 80 00       	add    $0x803120,%eax
  8014a5:	8b 00                	mov    (%eax),%eax
  8014a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014aa:	c1 e2 0c             	shl    $0xc,%edx
  8014ad:	01 d0                	add    %edx,%eax
  8014af:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8014b2:	a1 28 30 80 00       	mov    0x803028,%eax
  8014b7:	c1 e0 04             	shl    $0x4,%eax
  8014ba:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  8014c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c3:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8014c5:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8014cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ce:	c1 e0 04             	shl    $0x4,%eax
  8014d1:	05 24 31 80 00       	add    $0x803124,%eax
  8014d6:	8b 00                	mov    (%eax),%eax
  8014d8:	c1 e2 04             	shl    $0x4,%edx
  8014db:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8014e1:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8014e3:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8014e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ec:	c1 e0 04             	shl    $0x4,%eax
  8014ef:	05 28 31 80 00       	add    $0x803128,%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8014f9:	c1 e2 04             	shl    $0x4,%edx
  8014fc:	81 c2 28 31 80 00    	add    $0x803128,%edx
  801502:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801504:	a1 28 30 80 00       	mov    0x803028,%eax
  801509:	c1 e0 04             	shl    $0x4,%eax
  80150c:	05 2c 31 80 00       	add    $0x80312c,%eax
  801511:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801517:	a1 28 30 80 00       	mov    0x803028,%eax
  80151c:	40                   	inc    %eax
  80151d:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	c1 e0 04             	shl    $0x4,%eax
  801528:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  80152e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801531:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801536:	c1 e0 04             	shl    $0x4,%eax
  801539:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  80153f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801542:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	c1 e0 04             	shl    $0x4,%eax
  80154a:	05 2c 31 80 00       	add    $0x80312c,%eax
  80154f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801558:	c1 e0 0c             	shl    $0xc,%eax
  80155b:	89 c2                	mov    %eax,%edx
  80155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801560:	c1 e0 04             	shl    $0x4,%eax
  801563:	05 20 31 80 00       	add    $0x803120,%eax
  801568:	8b 00                	mov    (%eax),%eax
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	52                   	push   %edx
  80156e:	50                   	push   %eax
  80156f:	e8 1f 05 00 00       	call   801a93 <sys_allocateMem>
  801574:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157a:	c1 e0 04             	shl    $0x4,%eax
  80157d:	05 20 31 80 00       	add    $0x803120,%eax
  801582:	8b 00                	mov    (%eax),%eax
	}


}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  80158c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801593:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  80159a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8015a1:	eb 3f                	jmp    8015e2 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  8015a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a6:	c1 e0 04             	shl    $0x4,%eax
  8015a9:	05 20 31 80 00       	add    $0x803120,%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015b3:	75 2a                	jne    8015df <free+0x59>
		{
			index=i;
  8015b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  8015bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015be:	c1 e0 04             	shl    $0x4,%eax
  8015c1:	05 28 31 80 00       	add    $0x803128,%eax
  8015c6:	8b 00                	mov    (%eax),%eax
  8015c8:	c1 e0 0c             	shl    $0xc,%eax
  8015cb:	89 c2                	mov    %eax,%edx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	52                   	push   %edx
  8015d4:	50                   	push   %eax
  8015d5:	e8 9d 04 00 00       	call   801a77 <sys_freeMem>
  8015da:	83 c4 10             	add    $0x10,%esp
			break;
  8015dd:	eb 0d                	jmp    8015ec <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8015df:	ff 45 ec             	incl   -0x14(%ebp)
  8015e2:	a1 28 30 80 00       	mov    0x803028,%eax
  8015e7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8015ea:	7c b7                	jl     8015a3 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8015ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8015f0:	75 17                	jne    801609 <free+0x83>
	{
		panic("Error");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 f0 28 80 00       	push   $0x8028f0
  8015fa:	68 81 00 00 00       	push   $0x81
  8015ff:	68 f6 28 80 00       	push   $0x8028f6
  801604:	e8 22 ed ff ff       	call   80032b <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801609:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801610:	e9 cc 00 00 00       	jmp    8016e1 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801618:	c1 e0 04             	shl    $0x4,%eax
  80161b:	05 2c 31 80 00       	add    $0x80312c,%eax
  801620:	8b 00                	mov    (%eax),%eax
  801622:	85 c0                	test   %eax,%eax
  801624:	0f 84 b3 00 00 00    	je     8016dd <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  80162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162d:	c1 e0 04             	shl    $0x4,%eax
  801630:	05 20 31 80 00       	add    $0x803120,%eax
  801635:	8b 10                	mov    (%eax),%edx
  801637:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163a:	c1 e0 04             	shl    $0x4,%eax
  80163d:	05 24 31 80 00       	add    $0x803124,%eax
  801642:	8b 00                	mov    (%eax),%eax
  801644:	39 c2                	cmp    %eax,%edx
  801646:	0f 85 92 00 00 00    	jne    8016de <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	c1 e0 04             	shl    $0x4,%eax
  801652:	05 24 31 80 00       	add    $0x803124,%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80165c:	c1 e2 04             	shl    $0x4,%edx
  80165f:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801665:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80166a:	c1 e0 04             	shl    $0x4,%eax
  80166d:	05 28 31 80 00       	add    $0x803128,%eax
  801672:	8b 10                	mov    (%eax),%edx
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	c1 e0 04             	shl    $0x4,%eax
  80167a:	05 28 31 80 00       	add    $0x803128,%eax
  80167f:	8b 00                	mov    (%eax),%eax
  801681:	01 c2                	add    %eax,%edx
  801683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801686:	c1 e0 04             	shl    $0x4,%eax
  801689:	05 28 31 80 00       	add    $0x803128,%eax
  80168e:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	c1 e0 04             	shl    $0x4,%eax
  801696:	05 20 31 80 00       	add    $0x803120,%eax
  80169b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	c1 e0 04             	shl    $0x4,%eax
  8016a7:	05 24 31 80 00       	add    $0x803124,%eax
  8016ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8016b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b5:	c1 e0 04             	shl    $0x4,%eax
  8016b8:	05 28 31 80 00       	add    $0x803128,%eax
  8016bd:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c6:	c1 e0 04             	shl    $0x4,%eax
  8016c9:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8016d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8016db:	eb 12                	jmp    8016ef <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8016dd:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  8016de:	ff 45 e8             	incl   -0x18(%ebp)
  8016e1:	a1 28 30 80 00       	mov    0x803028,%eax
  8016e6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8016e9:	0f 8c 26 ff ff ff    	jl     801615 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8016ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016f6:	e9 cc 00 00 00       	jmp    8017c7 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  8016fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016fe:	c1 e0 04             	shl    $0x4,%eax
  801701:	05 2c 31 80 00       	add    $0x80312c,%eax
  801706:	8b 00                	mov    (%eax),%eax
  801708:	85 c0                	test   %eax,%eax
  80170a:	0f 84 b3 00 00 00    	je     8017c3 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801713:	c1 e0 04             	shl    $0x4,%eax
  801716:	05 24 31 80 00       	add    $0x803124,%eax
  80171b:	8b 10                	mov    (%eax),%edx
  80171d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801720:	c1 e0 04             	shl    $0x4,%eax
  801723:	05 20 31 80 00       	add    $0x803120,%eax
  801728:	8b 00                	mov    (%eax),%eax
  80172a:	39 c2                	cmp    %eax,%edx
  80172c:	0f 85 92 00 00 00    	jne    8017c4 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	c1 e0 04             	shl    $0x4,%eax
  801738:	05 20 31 80 00       	add    $0x803120,%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801742:	c1 e2 04             	shl    $0x4,%edx
  801745:	81 c2 20 31 80 00    	add    $0x803120,%edx
  80174b:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  80174d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801750:	c1 e0 04             	shl    $0x4,%eax
  801753:	05 28 31 80 00       	add    $0x803128,%eax
  801758:	8b 10                	mov    (%eax),%edx
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	c1 e0 04             	shl    $0x4,%eax
  801760:	05 28 31 80 00       	add    $0x803128,%eax
  801765:	8b 00                	mov    (%eax),%eax
  801767:	01 c2                	add    %eax,%edx
  801769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176c:	c1 e0 04             	shl    $0x4,%eax
  80176f:	05 28 31 80 00       	add    $0x803128,%eax
  801774:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801779:	c1 e0 04             	shl    $0x4,%eax
  80177c:	05 20 31 80 00       	add    $0x803120,%eax
  801781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	c1 e0 04             	shl    $0x4,%eax
  80178d:	05 24 31 80 00       	add    $0x803124,%eax
  801792:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179b:	c1 e0 04             	shl    $0x4,%eax
  80179e:	05 28 31 80 00       	add    $0x803128,%eax
  8017a3:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	c1 e0 04             	shl    $0x4,%eax
  8017af:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8017ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8017c1:	eb 12                	jmp    8017d5 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8017c3:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8017c4:	ff 45 e4             	incl   -0x1c(%ebp)
  8017c7:	a1 28 30 80 00       	mov    0x803028,%eax
  8017cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017cf:	0f 8c 26 ff ff ff    	jl     8016fb <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  8017d5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8017d9:	75 11                	jne    8017ec <free+0x266>
	{
		spaces[index].isFree = 1;
  8017db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017de:	c1 e0 04             	shl    $0x4,%eax
  8017e1:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  8017ec:	90                   	nop
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 18             	sub    $0x18,%esp
  8017f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f8:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	68 04 29 80 00       	push   $0x802904
  801803:	68 b9 00 00 00       	push   $0xb9
  801808:	68 f6 28 80 00       	push   $0x8028f6
  80180d:	e8 19 eb ff ff       	call   80032b <_panic>

00801812 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	68 04 29 80 00       	push   $0x802904
  801820:	68 bf 00 00 00       	push   $0xbf
  801825:	68 f6 28 80 00       	push   $0x8028f6
  80182a:	e8 fc ea ff ff       	call   80032b <_panic>

0080182f <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	68 04 29 80 00       	push   $0x802904
  80183d:	68 c5 00 00 00       	push   $0xc5
  801842:	68 f6 28 80 00       	push   $0x8028f6
  801847:	e8 df ea ff ff       	call   80032b <_panic>

0080184c <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	68 04 29 80 00       	push   $0x802904
  80185a:	68 ca 00 00 00       	push   $0xca
  80185f:	68 f6 28 80 00       	push   $0x8028f6
  801864:	e8 c2 ea ff ff       	call   80032b <_panic>

00801869 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	68 04 29 80 00       	push   $0x802904
  801877:	68 d0 00 00 00       	push   $0xd0
  80187c:	68 f6 28 80 00       	push   $0x8028f6
  801881:	e8 a5 ea ff ff       	call   80032b <_panic>

00801886 <shrink>:
}
void shrink(uint32 newSize)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 04 29 80 00       	push   $0x802904
  801894:	68 d4 00 00 00       	push   $0xd4
  801899:	68 f6 28 80 00       	push   $0x8028f6
  80189e:	e8 88 ea ff ff       	call   80032b <_panic>

008018a3 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	68 04 29 80 00       	push   $0x802904
  8018b1:	68 d9 00 00 00       	push   $0xd9
  8018b6:	68 f6 28 80 00       	push   $0x8028f6
  8018bb:	e8 6b ea ff ff       	call   80032b <_panic>

008018c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	57                   	push   %edi
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018db:	cd 30                	int    $0x30
  8018dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5f                   	pop    %edi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	52                   	push   %edx
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	50                   	push   %eax
  801907:	6a 00                	push   $0x0
  801909:	e8 b2 ff ff ff       	call   8018c0 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	90                   	nop
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_cgetc>:

int
sys_cgetc(void)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 01                	push   $0x1
  801923:	e8 98 ff ff ff       	call   8018c0 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	50                   	push   %eax
  80193c:	6a 05                	push   $0x5
  80193e:	e8 7d ff ff ff       	call   8018c0 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 02                	push   $0x2
  801957:	e8 64 ff ff ff       	call   8018c0 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 03                	push   $0x3
  801970:	e8 4b ff ff ff       	call   8018c0 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 04                	push   $0x4
  801989:	e8 32 ff ff ff       	call   8018c0 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_env_exit>:


void sys_env_exit(void)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 06                	push   $0x6
  8019a2:	e8 19 ff ff ff       	call   8018c0 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	90                   	nop
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	6a 07                	push   $0x7
  8019c0:	e8 fb fe ff ff       	call   8018c0 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	56                   	push   %esi
  8019ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8019d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	51                   	push   %ecx
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 08                	push   $0x8
  8019e5:	e8 d6 fe ff ff       	call   8018c0 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f0:	5b                   	pop    %ebx
  8019f1:	5e                   	pop    %esi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 09                	push   $0x9
  801a07:	e8 b4 fe ff ff       	call   8018c0 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	6a 0a                	push   $0xa
  801a22:	e8 99 fe ff ff       	call   8018c0 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 0b                	push   $0xb
  801a3b:	e8 80 fe ff ff       	call   8018c0 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 0c                	push   $0xc
  801a54:	e8 67 fe ff ff       	call   8018c0 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 0d                	push   $0xd
  801a6d:	e8 4e fe ff ff       	call   8018c0 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 11                	push   $0x11
  801a88:	e8 33 fe ff ff       	call   8018c0 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	6a 12                	push   $0x12
  801aa4:	e8 17 fe ff ff       	call   8018c0 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aac:	90                   	nop
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 0e                	push   $0xe
  801abe:	e8 fd fd ff ff       	call   8018c0 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	6a 0f                	push   $0xf
  801ad8:	e8 e3 fd ff ff       	call   8018c0 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 10                	push   $0x10
  801af1:	e8 ca fd ff ff       	call   8018c0 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	90                   	nop
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 14                	push   $0x14
  801b0b:	e8 b0 fd ff ff       	call   8018c0 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	90                   	nop
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 15                	push   $0x15
  801b25:	e8 96 fd ff ff       	call   8018c0 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 04             	sub    $0x4,%esp
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	50                   	push   %eax
  801b49:	6a 16                	push   $0x16
  801b4b:	e8 70 fd ff ff       	call   8018c0 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	90                   	nop
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 17                	push   $0x17
  801b65:	e8 56 fd ff ff       	call   8018c0 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	6a 18                	push   $0x18
  801b82:	e8 39 fd ff ff       	call   8018c0 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 1b                	push   $0x1b
  801b9f:	e8 1c fd ff ff       	call   8018c0 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 19                	push   $0x19
  801bbc:	e8 ff fc ff ff       	call   8018c0 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	90                   	nop
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 1a                	push   $0x1a
  801bda:	e8 e1 fc ff ff       	call   8018c0 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	90                   	nop
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bf1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bf4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	51                   	push   %ecx
  801bfe:	52                   	push   %edx
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	50                   	push   %eax
  801c03:	6a 1c                	push   $0x1c
  801c05:	e8 b6 fc ff ff       	call   8018c0 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	52                   	push   %edx
  801c1f:	50                   	push   %eax
  801c20:	6a 1d                	push   $0x1d
  801c22:	e8 99 fc ff ff       	call   8018c0 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	51                   	push   %ecx
  801c3d:	52                   	push   %edx
  801c3e:	50                   	push   %eax
  801c3f:	6a 1e                	push   $0x1e
  801c41:	e8 7a fc ff ff       	call   8018c0 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	52                   	push   %edx
  801c5b:	50                   	push   %eax
  801c5c:	6a 1f                	push   $0x1f
  801c5e:	e8 5d fc ff ff       	call   8018c0 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 20                	push   $0x20
  801c77:	e8 44 fc ff ff       	call   8018c0 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	6a 00                	push   $0x0
  801c89:	ff 75 14             	pushl  0x14(%ebp)
  801c8c:	ff 75 10             	pushl  0x10(%ebp)
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	50                   	push   %eax
  801c93:	6a 21                	push   $0x21
  801c95:	e8 26 fc ff ff       	call   8018c0 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	50                   	push   %eax
  801cae:	6a 22                	push   $0x22
  801cb0:	e8 0b fc ff ff       	call   8018c0 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	90                   	nop
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	50                   	push   %eax
  801cca:	6a 23                	push   $0x23
  801ccc:	e8 ef fb ff ff       	call   8018c0 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	90                   	nop
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cdd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce0:	8d 50 04             	lea    0x4(%eax),%edx
  801ce3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	6a 24                	push   $0x24
  801cf0:	e8 cb fb ff ff       	call   8018c0 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d01:	89 01                	mov    %eax,(%ecx)
  801d03:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	c9                   	leave  
  801d0a:	c2 04 00             	ret    $0x4

00801d0d <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 13                	push   $0x13
  801d1f:	e8 9c fb ff ff       	call   8018c0 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_rcr2>:
uint32 sys_rcr2()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 25                	push   $0x25
  801d39:	e8 82 fb ff ff       	call   8018c0 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d4f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	50                   	push   %eax
  801d5c:	6a 26                	push   $0x26
  801d5e:	e8 5d fb ff ff       	call   8018c0 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return ;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <rsttst>:
void rsttst()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 28                	push   $0x28
  801d78:	e8 43 fb ff ff       	call   8018c0 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d80:	90                   	nop
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d8f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d92:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	ff 75 10             	pushl  0x10(%ebp)
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	6a 27                	push   $0x27
  801da3:	e8 18 fb ff ff       	call   8018c0 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <chktst>:
void chktst(uint32 n)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	6a 29                	push   $0x29
  801dbe:	e8 fd fa ff ff       	call   8018c0 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc6:	90                   	nop
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <inctst>:

void inctst()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 2a                	push   $0x2a
  801dd8:	e8 e3 fa ff ff       	call   8018c0 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <gettst>:
uint32 gettst()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 2b                	push   $0x2b
  801df2:	e8 c9 fa ff ff       	call   8018c0 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 2c                	push   $0x2c
  801e0e:	e8 ad fa ff ff       	call   8018c0 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
  801e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e19:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e1d:	75 07                	jne    801e26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e24:	eb 05                	jmp    801e2b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 2c                	push   $0x2c
  801e3f:	e8 7c fa ff ff       	call   8018c0 <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
  801e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e4a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e4e:	75 07                	jne    801e57 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e50:	b8 01 00 00 00       	mov    $0x1,%eax
  801e55:	eb 05                	jmp    801e5c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 2c                	push   $0x2c
  801e70:	e8 4b fa ff ff       	call   8018c0 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
  801e78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e7b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e7f:	75 07                	jne    801e88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e81:	b8 01 00 00 00       	mov    $0x1,%eax
  801e86:	eb 05                	jmp    801e8d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 2c                	push   $0x2c
  801ea1:	e8 1a fa ff ff       	call   8018c0 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
  801ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eb0:	75 07                	jne    801eb9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb7:	eb 05                	jmp    801ebe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	ff 75 08             	pushl  0x8(%ebp)
  801ece:	6a 2d                	push   $0x2d
  801ed0:	e8 eb f9 ff ff       	call   8018c0 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed8:	90                   	nop
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801edf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	6a 00                	push   $0x0
  801eed:	53                   	push   %ebx
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 2e                	push   $0x2e
  801ef3:	e8 c8 f9 ff ff       	call   8018c0 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	52                   	push   %edx
  801f10:	50                   	push   %eax
  801f11:	6a 2f                	push   $0x2f
  801f13:	e8 a8 f9 ff ff       	call   8018c0 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    
  801f1d:	66 90                	xchg   %ax,%ax
  801f1f:	90                   	nop

00801f20 <__udivdi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f37:	89 ca                	mov    %ecx,%edx
  801f39:	89 f8                	mov    %edi,%eax
  801f3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f3f:	85 f6                	test   %esi,%esi
  801f41:	75 2d                	jne    801f70 <__udivdi3+0x50>
  801f43:	39 cf                	cmp    %ecx,%edi
  801f45:	77 65                	ja     801fac <__udivdi3+0x8c>
  801f47:	89 fd                	mov    %edi,%ebp
  801f49:	85 ff                	test   %edi,%edi
  801f4b:	75 0b                	jne    801f58 <__udivdi3+0x38>
  801f4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f52:	31 d2                	xor    %edx,%edx
  801f54:	f7 f7                	div    %edi
  801f56:	89 c5                	mov    %eax,%ebp
  801f58:	31 d2                	xor    %edx,%edx
  801f5a:	89 c8                	mov    %ecx,%eax
  801f5c:	f7 f5                	div    %ebp
  801f5e:	89 c1                	mov    %eax,%ecx
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	f7 f5                	div    %ebp
  801f64:	89 cf                	mov    %ecx,%edi
  801f66:	89 fa                	mov    %edi,%edx
  801f68:	83 c4 1c             	add    $0x1c,%esp
  801f6b:	5b                   	pop    %ebx
  801f6c:	5e                   	pop    %esi
  801f6d:	5f                   	pop    %edi
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    
  801f70:	39 ce                	cmp    %ecx,%esi
  801f72:	77 28                	ja     801f9c <__udivdi3+0x7c>
  801f74:	0f bd fe             	bsr    %esi,%edi
  801f77:	83 f7 1f             	xor    $0x1f,%edi
  801f7a:	75 40                	jne    801fbc <__udivdi3+0x9c>
  801f7c:	39 ce                	cmp    %ecx,%esi
  801f7e:	72 0a                	jb     801f8a <__udivdi3+0x6a>
  801f80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f84:	0f 87 9e 00 00 00    	ja     802028 <__udivdi3+0x108>
  801f8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8f:	89 fa                	mov    %edi,%edx
  801f91:	83 c4 1c             	add    $0x1c,%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5f                   	pop    %edi
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    
  801f99:	8d 76 00             	lea    0x0(%esi),%esi
  801f9c:	31 ff                	xor    %edi,%edi
  801f9e:	31 c0                	xor    %eax,%eax
  801fa0:	89 fa                	mov    %edi,%edx
  801fa2:	83 c4 1c             	add    $0x1c,%esp
  801fa5:	5b                   	pop    %ebx
  801fa6:	5e                   	pop    %esi
  801fa7:	5f                   	pop    %edi
  801fa8:	5d                   	pop    %ebp
  801fa9:	c3                   	ret    
  801faa:	66 90                	xchg   %ax,%ax
  801fac:	89 d8                	mov    %ebx,%eax
  801fae:	f7 f7                	div    %edi
  801fb0:	31 ff                	xor    %edi,%edi
  801fb2:	89 fa                	mov    %edi,%edx
  801fb4:	83 c4 1c             	add    $0x1c,%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5f                   	pop    %edi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    
  801fbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fc1:	89 eb                	mov    %ebp,%ebx
  801fc3:	29 fb                	sub    %edi,%ebx
  801fc5:	89 f9                	mov    %edi,%ecx
  801fc7:	d3 e6                	shl    %cl,%esi
  801fc9:	89 c5                	mov    %eax,%ebp
  801fcb:	88 d9                	mov    %bl,%cl
  801fcd:	d3 ed                	shr    %cl,%ebp
  801fcf:	89 e9                	mov    %ebp,%ecx
  801fd1:	09 f1                	or     %esi,%ecx
  801fd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801fd7:	89 f9                	mov    %edi,%ecx
  801fd9:	d3 e0                	shl    %cl,%eax
  801fdb:	89 c5                	mov    %eax,%ebp
  801fdd:	89 d6                	mov    %edx,%esi
  801fdf:	88 d9                	mov    %bl,%cl
  801fe1:	d3 ee                	shr    %cl,%esi
  801fe3:	89 f9                	mov    %edi,%ecx
  801fe5:	d3 e2                	shl    %cl,%edx
  801fe7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801feb:	88 d9                	mov    %bl,%cl
  801fed:	d3 e8                	shr    %cl,%eax
  801fef:	09 c2                	or     %eax,%edx
  801ff1:	89 d0                	mov    %edx,%eax
  801ff3:	89 f2                	mov    %esi,%edx
  801ff5:	f7 74 24 0c          	divl   0xc(%esp)
  801ff9:	89 d6                	mov    %edx,%esi
  801ffb:	89 c3                	mov    %eax,%ebx
  801ffd:	f7 e5                	mul    %ebp
  801fff:	39 d6                	cmp    %edx,%esi
  802001:	72 19                	jb     80201c <__udivdi3+0xfc>
  802003:	74 0b                	je     802010 <__udivdi3+0xf0>
  802005:	89 d8                	mov    %ebx,%eax
  802007:	31 ff                	xor    %edi,%edi
  802009:	e9 58 ff ff ff       	jmp    801f66 <__udivdi3+0x46>
  80200e:	66 90                	xchg   %ax,%ax
  802010:	8b 54 24 08          	mov    0x8(%esp),%edx
  802014:	89 f9                	mov    %edi,%ecx
  802016:	d3 e2                	shl    %cl,%edx
  802018:	39 c2                	cmp    %eax,%edx
  80201a:	73 e9                	jae    802005 <__udivdi3+0xe5>
  80201c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80201f:	31 ff                	xor    %edi,%edi
  802021:	e9 40 ff ff ff       	jmp    801f66 <__udivdi3+0x46>
  802026:	66 90                	xchg   %ax,%ax
  802028:	31 c0                	xor    %eax,%eax
  80202a:	e9 37 ff ff ff       	jmp    801f66 <__udivdi3+0x46>
  80202f:	90                   	nop

00802030 <__umoddi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80203b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80203f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802043:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802047:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80204f:	89 f3                	mov    %esi,%ebx
  802051:	89 fa                	mov    %edi,%edx
  802053:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802057:	89 34 24             	mov    %esi,(%esp)
  80205a:	85 c0                	test   %eax,%eax
  80205c:	75 1a                	jne    802078 <__umoddi3+0x48>
  80205e:	39 f7                	cmp    %esi,%edi
  802060:	0f 86 a2 00 00 00    	jbe    802108 <__umoddi3+0xd8>
  802066:	89 c8                	mov    %ecx,%eax
  802068:	89 f2                	mov    %esi,%edx
  80206a:	f7 f7                	div    %edi
  80206c:	89 d0                	mov    %edx,%eax
  80206e:	31 d2                	xor    %edx,%edx
  802070:	83 c4 1c             	add    $0x1c,%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    
  802078:	39 f0                	cmp    %esi,%eax
  80207a:	0f 87 ac 00 00 00    	ja     80212c <__umoddi3+0xfc>
  802080:	0f bd e8             	bsr    %eax,%ebp
  802083:	83 f5 1f             	xor    $0x1f,%ebp
  802086:	0f 84 ac 00 00 00    	je     802138 <__umoddi3+0x108>
  80208c:	bf 20 00 00 00       	mov    $0x20,%edi
  802091:	29 ef                	sub    %ebp,%edi
  802093:	89 fe                	mov    %edi,%esi
  802095:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802099:	89 e9                	mov    %ebp,%ecx
  80209b:	d3 e0                	shl    %cl,%eax
  80209d:	89 d7                	mov    %edx,%edi
  80209f:	89 f1                	mov    %esi,%ecx
  8020a1:	d3 ef                	shr    %cl,%edi
  8020a3:	09 c7                	or     %eax,%edi
  8020a5:	89 e9                	mov    %ebp,%ecx
  8020a7:	d3 e2                	shl    %cl,%edx
  8020a9:	89 14 24             	mov    %edx,(%esp)
  8020ac:	89 d8                	mov    %ebx,%eax
  8020ae:	d3 e0                	shl    %cl,%eax
  8020b0:	89 c2                	mov    %eax,%edx
  8020b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020b6:	d3 e0                	shl    %cl,%eax
  8020b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020c0:	89 f1                	mov    %esi,%ecx
  8020c2:	d3 e8                	shr    %cl,%eax
  8020c4:	09 d0                	or     %edx,%eax
  8020c6:	d3 eb                	shr    %cl,%ebx
  8020c8:	89 da                	mov    %ebx,%edx
  8020ca:	f7 f7                	div    %edi
  8020cc:	89 d3                	mov    %edx,%ebx
  8020ce:	f7 24 24             	mull   (%esp)
  8020d1:	89 c6                	mov    %eax,%esi
  8020d3:	89 d1                	mov    %edx,%ecx
  8020d5:	39 d3                	cmp    %edx,%ebx
  8020d7:	0f 82 87 00 00 00    	jb     802164 <__umoddi3+0x134>
  8020dd:	0f 84 91 00 00 00    	je     802174 <__umoddi3+0x144>
  8020e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020e7:	29 f2                	sub    %esi,%edx
  8020e9:	19 cb                	sbb    %ecx,%ebx
  8020eb:	89 d8                	mov    %ebx,%eax
  8020ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8020f1:	d3 e0                	shl    %cl,%eax
  8020f3:	89 e9                	mov    %ebp,%ecx
  8020f5:	d3 ea                	shr    %cl,%edx
  8020f7:	09 d0                	or     %edx,%eax
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	d3 eb                	shr    %cl,%ebx
  8020fd:	89 da                	mov    %ebx,%edx
  8020ff:	83 c4 1c             	add    $0x1c,%esp
  802102:	5b                   	pop    %ebx
  802103:	5e                   	pop    %esi
  802104:	5f                   	pop    %edi
  802105:	5d                   	pop    %ebp
  802106:	c3                   	ret    
  802107:	90                   	nop
  802108:	89 fd                	mov    %edi,%ebp
  80210a:	85 ff                	test   %edi,%edi
  80210c:	75 0b                	jne    802119 <__umoddi3+0xe9>
  80210e:	b8 01 00 00 00       	mov    $0x1,%eax
  802113:	31 d2                	xor    %edx,%edx
  802115:	f7 f7                	div    %edi
  802117:	89 c5                	mov    %eax,%ebp
  802119:	89 f0                	mov    %esi,%eax
  80211b:	31 d2                	xor    %edx,%edx
  80211d:	f7 f5                	div    %ebp
  80211f:	89 c8                	mov    %ecx,%eax
  802121:	f7 f5                	div    %ebp
  802123:	89 d0                	mov    %edx,%eax
  802125:	e9 44 ff ff ff       	jmp    80206e <__umoddi3+0x3e>
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	89 c8                	mov    %ecx,%eax
  80212e:	89 f2                	mov    %esi,%edx
  802130:	83 c4 1c             	add    $0x1c,%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    
  802138:	3b 04 24             	cmp    (%esp),%eax
  80213b:	72 06                	jb     802143 <__umoddi3+0x113>
  80213d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802141:	77 0f                	ja     802152 <__umoddi3+0x122>
  802143:	89 f2                	mov    %esi,%edx
  802145:	29 f9                	sub    %edi,%ecx
  802147:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80214b:	89 14 24             	mov    %edx,(%esp)
  80214e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802152:	8b 44 24 04          	mov    0x4(%esp),%eax
  802156:	8b 14 24             	mov    (%esp),%edx
  802159:	83 c4 1c             	add    $0x1c,%esp
  80215c:	5b                   	pop    %ebx
  80215d:	5e                   	pop    %esi
  80215e:	5f                   	pop    %edi
  80215f:	5d                   	pop    %ebp
  802160:	c3                   	ret    
  802161:	8d 76 00             	lea    0x0(%esi),%esi
  802164:	2b 04 24             	sub    (%esp),%eax
  802167:	19 fa                	sbb    %edi,%edx
  802169:	89 d1                	mov    %edx,%ecx
  80216b:	89 c6                	mov    %eax,%esi
  80216d:	e9 71 ff ff ff       	jmp    8020e3 <__umoddi3+0xb3>
  802172:	66 90                	xchg   %ax,%ax
  802174:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802178:	72 ea                	jb     802164 <__umoddi3+0x134>
  80217a:	89 d9                	mov    %ebx,%ecx
  80217c:	e9 62 ff ff ff       	jmp    8020e3 <__umoddi3+0xb3>
