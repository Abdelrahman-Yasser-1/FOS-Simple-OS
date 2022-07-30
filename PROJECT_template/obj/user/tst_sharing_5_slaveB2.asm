
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 38 01 00 00       	call   80016e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 23                	jmp    80006e <_main+0x36>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
  800050:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	c1 e2 04             	shl    $0x4,%edx
  80005c:	01 d0                	add    %edx,%eax
  80005e:	8a 40 04             	mov    0x4(%eax),%al
  800061:	84 c0                	test   %al,%al
  800063:	74 06                	je     80006b <_main+0x33>
			{
				fullWS = 0;
  800065:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800069:	eb 12                	jmp    80007d <_main+0x45>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006b:	ff 45 f0             	incl   -0x10(%ebp)
  80006e:	a1 20 30 80 00       	mov    0x803020,%eax
  800073:	8b 50 74             	mov    0x74(%eax),%edx
  800076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800079:	39 c2                	cmp    %eax,%edx
  80007b:	77 ce                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80007d:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800081:	74 14                	je     800097 <_main+0x5f>
  800083:	83 ec 04             	sub    $0x4,%esp
  800086:	68 c0 21 80 00       	push   $0x8021c0
  80008b:	6a 12                	push   $0x12
  80008d:	68 dc 21 80 00       	push   $0x8021dc
  800092:	e8 1c 02 00 00       	call   8002b3 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  800097:	e8 66 18 00 00       	call   801902 <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 f9 21 80 00       	push   $0x8021f9
  8000a4:	50                   	push   %eax
  8000a5:	e8 f0 16 00 00       	call   80179a <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 fc 21 80 00       	push   $0x8021fc
  8000b8:	e8 98 04 00 00       	call   800555 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 24 22 80 00       	push   $0x802224
  8000c8:	e8 88 04 00 00       	call   800555 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 28 23 00 00       	push   $0x2328
  8000d8:	e8 c8 1d 00 00       	call   801ea5 <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 cf 18 00 00       	call   8019b4 <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 c4 16 00 00       	call   8017b7 <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 44 22 80 00       	push   $0x802244
  8000fe:	e8 52 04 00 00       	call   800555 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800106:	e8 a9 18 00 00       	call   8019b4 <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 5c 22 80 00       	push   $0x80225c
  800121:	6a 20                	push   $0x20
  800123:	68 dc 21 80 00       	push   $0x8021dc
  800128:	e8 86 01 00 00       	call   8002b3 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  80012d:	e8 39 1c 00 00       	call   801d6b <gettst>
  800132:	83 f8 02             	cmp    $0x2,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 fc 22 80 00       	push   $0x8022fc
  80013f:	6a 23                	push   $0x23
  800141:	68 dc 21 80 00       	push   $0x8021dc
  800146:	e8 68 01 00 00       	call   8002b3 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 08 23 80 00       	push   $0x802308
  800153:	e8 fd 03 00 00       	call   800555 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 2c 23 80 00       	push   $0x80232c
  800163:	e8 ed 03 00 00       	call   800555 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp

	return;
  80016b:	90                   	nop
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    

0080016e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800174:	e8 70 17 00 00       	call   8018e9 <sys_getenvindex>
  800179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017f:	89 d0                	mov    %edx,%eax
  800181:	c1 e0 03             	shl    $0x3,%eax
  800184:	01 d0                	add    %edx,%eax
  800186:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80018d:	01 c8                	add    %ecx,%eax
  80018f:	01 c0                	add    %eax,%eax
  800191:	01 d0                	add    %edx,%eax
  800193:	01 c0                	add    %eax,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	89 c2                	mov    %eax,%edx
  800199:	c1 e2 05             	shl    $0x5,%edx
  80019c:	29 c2                	sub    %eax,%edx
  80019e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ad:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b7:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001bd:	84 c0                	test   %al,%al
  8001bf:	74 0f                	je     8001d0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c6:	05 40 3c 01 00       	add    $0x13c40,%eax
  8001cb:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d4:	7e 0a                	jle    8001e0 <libmain+0x72>
		binaryname = argv[0];
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 4a fe ff ff       	call   800038 <_main>
  8001ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f1:	e8 8e 18 00 00       	call   801a84 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 90 23 80 00       	push   $0x802390
  8001fe:	e8 52 03 00 00       	call   800555 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 b8 23 80 00       	push   $0x8023b8
  800226:	e8 2a 03 00 00       	call   800555 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	52                   	push   %edx
  800248:	50                   	push   %eax
  800249:	68 e0 23 80 00       	push   $0x8023e0
  80024e:	e8 02 03 00 00       	call   800555 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	50                   	push   %eax
  800265:	68 21 24 80 00       	push   $0x802421
  80026a:	e8 e6 02 00 00       	call   800555 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 90 23 80 00       	push   $0x802390
  80027a:	e8 d6 02 00 00       	call   800555 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800282:	e8 17 18 00 00       	call   801a9e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800287:	e8 19 00 00 00       	call   8002a5 <exit>
}
  80028c:	90                   	nop
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	6a 00                	push   $0x0
  80029a:	e8 16 16 00 00       	call   8018b5 <sys_env_destroy>
  80029f:	83 c4 10             	add    $0x10,%esp
}
  8002a2:	90                   	nop
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <exit>:

void
exit(void)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002ab:	e8 6b 16 00 00       	call   80191b <sys_env_exit>
}
  8002b0:	90                   	nop
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bc:	83 c0 04             	add    $0x4,%eax
  8002bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c2:	a1 18 31 80 00       	mov    0x803118,%eax
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	74 16                	je     8002e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002cb:	a1 18 31 80 00       	mov    0x803118,%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	50                   	push   %eax
  8002d4:	68 38 24 80 00       	push   $0x802438
  8002d9:	e8 77 02 00 00       	call   800555 <cprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8002e6:	ff 75 0c             	pushl  0xc(%ebp)
  8002e9:	ff 75 08             	pushl  0x8(%ebp)
  8002ec:	50                   	push   %eax
  8002ed:	68 3d 24 80 00       	push   $0x80243d
  8002f2:	e8 5e 02 00 00       	call   800555 <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	ff 75 f4             	pushl  -0xc(%ebp)
  800303:	50                   	push   %eax
  800304:	e8 e1 01 00 00       	call   8004ea <vcprintf>
  800309:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	6a 00                	push   $0x0
  800311:	68 59 24 80 00       	push   $0x802459
  800316:	e8 cf 01 00 00       	call   8004ea <vcprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80031e:	e8 82 ff ff ff       	call   8002a5 <exit>

	// should not return here
	while (1) ;
  800323:	eb fe                	jmp    800323 <_panic+0x70>

00800325 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032b:	a1 20 30 80 00       	mov    0x803020,%eax
  800330:	8b 50 74             	mov    0x74(%eax),%edx
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	39 c2                	cmp    %eax,%edx
  800338:	74 14                	je     80034e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033a:	83 ec 04             	sub    $0x4,%esp
  80033d:	68 5c 24 80 00       	push   $0x80245c
  800342:	6a 26                	push   $0x26
  800344:	68 a8 24 80 00       	push   $0x8024a8
  800349:	e8 65 ff ff ff       	call   8002b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80034e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800355:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035c:	e9 b6 00 00 00       	jmp    800417 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	85 c0                	test   %eax,%eax
  800374:	75 08                	jne    80037e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800376:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800379:	e9 96 00 00 00       	jmp    800414 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80037e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800385:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038c:	eb 5d                	jmp    8003eb <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80038e:	a1 20 30 80 00       	mov    0x803020,%eax
  800393:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800399:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039c:	c1 e2 04             	shl    $0x4,%edx
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	8a 40 04             	mov    0x4(%eax),%al
  8003a4:	84 c0                	test   %al,%al
  8003a6:	75 40                	jne    8003e8 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ad:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b6:	c1 e2 04             	shl    $0x4,%edx
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	01 c8                	add    %ecx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003db:	39 c2                	cmp    %eax,%edx
  8003dd:	75 09                	jne    8003e8 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8003df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e6:	eb 12                	jmp    8003fa <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e8:	ff 45 e8             	incl   -0x18(%ebp)
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 50 74             	mov    0x74(%eax),%edx
  8003f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	77 94                	ja     80038e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003fe:	75 14                	jne    800414 <CheckWSWithoutLastIndex+0xef>
			panic(
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 b4 24 80 00       	push   $0x8024b4
  800408:	6a 3a                	push   $0x3a
  80040a:	68 a8 24 80 00       	push   $0x8024a8
  80040f:	e8 9f fe ff ff       	call   8002b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800414:	ff 45 f0             	incl   -0x10(%ebp)
  800417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041d:	0f 8c 3e ff ff ff    	jl     800361 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800423:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800431:	eb 20                	jmp    800453 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80043e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800441:	c1 e2 04             	shl    $0x4,%edx
  800444:	01 d0                	add    %edx,%eax
  800446:	8a 40 04             	mov    0x4(%eax),%al
  800449:	3c 01                	cmp    $0x1,%al
  80044b:	75 03                	jne    800450 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  80044d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	ff 45 e0             	incl   -0x20(%ebp)
  800453:	a1 20 30 80 00       	mov    0x803020,%eax
  800458:	8b 50 74             	mov    0x74(%eax),%edx
  80045b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	77 d1                	ja     800433 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800465:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800468:	74 14                	je     80047e <CheckWSWithoutLastIndex+0x159>
		panic(
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	68 08 25 80 00       	push   $0x802508
  800472:	6a 44                	push   $0x44
  800474:	68 a8 24 80 00       	push   $0x8024a8
  800479:	e8 35 fe ff ff       	call   8002b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80047e:	90                   	nop
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 48 01             	lea    0x1(%eax),%ecx
  80048f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800492:	89 0a                	mov    %ecx,(%edx)
  800494:	8b 55 08             	mov    0x8(%ebp),%edx
  800497:	88 d1                	mov    %dl,%cl
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004aa:	75 2c                	jne    8004d8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ac:	a0 24 30 80 00       	mov    0x803024,%al
  8004b1:	0f b6 c0             	movzbl %al,%eax
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 12                	mov    (%edx),%edx
  8004b9:	89 d1                	mov    %edx,%ecx
  8004bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004be:	83 c2 08             	add    $0x8,%edx
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	50                   	push   %eax
  8004c5:	51                   	push   %ecx
  8004c6:	52                   	push   %edx
  8004c7:	e8 a7 13 00 00       	call   801873 <sys_cputs>
  8004cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	8b 40 04             	mov    0x4(%eax),%eax
  8004de:	8d 50 01             	lea    0x1(%eax),%edx
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004e7:	90                   	nop
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004fa:	00 00 00 
	b.cnt = 0;
  8004fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800504:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	ff 75 08             	pushl  0x8(%ebp)
  80050d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800513:	50                   	push   %eax
  800514:	68 81 04 80 00       	push   $0x800481
  800519:	e8 11 02 00 00       	call   80072f <vprintfmt>
  80051e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800521:	a0 24 30 80 00       	mov    0x803024,%al
  800526:	0f b6 c0             	movzbl %al,%eax
  800529:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	50                   	push   %eax
  800533:	52                   	push   %edx
  800534:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053a:	83 c0 08             	add    $0x8,%eax
  80053d:	50                   	push   %eax
  80053e:	e8 30 13 00 00       	call   801873 <sys_cputs>
  800543:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800546:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80054d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <cprintf>:

int cprintf(const char *fmt, ...) {
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80055b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800562:	8d 45 0c             	lea    0xc(%ebp),%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 f4             	pushl  -0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	e8 73 ff ff ff       	call   8004ea <vcprintf>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800588:	e8 f7 14 00 00       	call   801a84 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80058d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 f4             	pushl  -0xc(%ebp)
  80059c:	50                   	push   %eax
  80059d:	e8 48 ff ff ff       	call   8004ea <vcprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005a8:	e8 f1 14 00 00       	call   801a9e <sys_enable_interrupt>
	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 14             	sub    $0x14,%esp
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d0:	77 55                	ja     800627 <printnum+0x75>
  8005d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d5:	72 05                	jb     8005dc <printnum+0x2a>
  8005d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005da:	77 4b                	ja     800627 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	52                   	push   %edx
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8005f2:	e8 65 19 00 00       	call   801f5c <__udivdi3>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	53                   	push   %ebx
  800601:	ff 75 18             	pushl  0x18(%ebp)
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	e8 a1 ff ff ff       	call   8005b2 <printnum>
  800611:	83 c4 20             	add    $0x20,%esp
  800614:	eb 1a                	jmp    800630 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 20             	pushl  0x20(%ebp)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	ff d0                	call   *%eax
  800624:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800627:	ff 4d 1c             	decl   0x1c(%ebp)
  80062a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80062e:	7f e6                	jg     800616 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800630:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800633:	bb 00 00 00 00       	mov    $0x0,%ebx
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80063e:	53                   	push   %ebx
  80063f:	51                   	push   %ecx
  800640:	52                   	push   %edx
  800641:	50                   	push   %eax
  800642:	e8 25 1a 00 00       	call   80206c <__umoddi3>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	05 74 27 80 00       	add    $0x802774,%eax
  80064f:	8a 00                	mov    (%eax),%al
  800651:	0f be c0             	movsbl %al,%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
}
  800663:	90                   	nop
  800664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800670:	7e 1c                	jle    80068e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 08             	lea    0x8(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 08             	sub    $0x8,%eax
  800687:	8b 50 04             	mov    0x4(%eax),%edx
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	eb 40                	jmp    8006ce <getuint+0x65>
	else if (lflag)
  80068e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800692:	74 1e                	je     8006b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 04             	sub    $0x4,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	eb 1c                	jmp    8006ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 10                	mov    %edx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d7:	7e 1c                	jle    8006f5 <getint+0x25>
		return va_arg(*ap, long long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 08             	lea    0x8(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 08             	sub    $0x8,%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	eb 38                	jmp    80072d <getint+0x5d>
	else if (lflag)
  8006f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f9:	74 1a                	je     800715 <getint+0x45>
		return va_arg(*ap, long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 04             	sub    $0x4,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	99                   	cltd   
  800713:	eb 18                	jmp    80072d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	89 10                	mov    %edx,(%eax)
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	83 e8 04             	sub    $0x4,%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	99                   	cltd   
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800737:	eb 17                	jmp    800750 <vprintfmt+0x21>
			if (ch == '\0')
  800739:	85 db                	test   %ebx,%ebx
  80073b:	0f 84 af 03 00 00    	je     800af0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	8d 50 01             	lea    0x1(%eax),%edx
  800756:	89 55 10             	mov    %edx,0x10(%ebp)
  800759:	8a 00                	mov    (%eax),%al
  80075b:	0f b6 d8             	movzbl %al,%ebx
  80075e:	83 fb 25             	cmp    $0x25,%ebx
  800761:	75 d6                	jne    800739 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800763:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800767:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80076e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80077c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800783:	8b 45 10             	mov    0x10(%ebp),%eax
  800786:	8d 50 01             	lea    0x1(%eax),%edx
  800789:	89 55 10             	mov    %edx,0x10(%ebp)
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f b6 d8             	movzbl %al,%ebx
  800791:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800794:	83 f8 55             	cmp    $0x55,%eax
  800797:	0f 87 2b 03 00 00    	ja     800ac8 <vprintfmt+0x399>
  80079d:	8b 04 85 98 27 80 00 	mov    0x802798(,%eax,4),%eax
  8007a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007aa:	eb d7                	jmp    800783 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b0:	eb d1                	jmp    800783 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	c1 e0 02             	shl    $0x2,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	01 c0                	add    %eax,%eax
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	83 e8 30             	sub    $0x30,%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	8a 00                	mov    (%eax),%al
  8007d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d8:	7e 3e                	jle    800818 <vprintfmt+0xe9>
  8007da:	83 fb 39             	cmp    $0x39,%ebx
  8007dd:	7f 39                	jg     800818 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e2:	eb d5                	jmp    8007b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007f8:	eb 1f                	jmp    800819 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	79 83                	jns    800783 <vprintfmt+0x54>
				width = 0;
  800800:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800807:	e9 77 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80080c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800813:	e9 6b ff ff ff       	jmp    800783 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800818:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081d:	0f 89 60 ff ff ff    	jns    800783 <vprintfmt+0x54>
				width = precision, precision = -1;
  800823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800830:	e9 4e ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800835:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800838:	e9 46 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	e9 89 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 e8 04             	sub    $0x4,%eax
  800871:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800873:	85 db                	test   %ebx,%ebx
  800875:	79 02                	jns    800879 <vprintfmt+0x14a>
				err = -err;
  800877:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800879:	83 fb 64             	cmp    $0x64,%ebx
  80087c:	7f 0b                	jg     800889 <vprintfmt+0x15a>
  80087e:	8b 34 9d e0 25 80 00 	mov    0x8025e0(,%ebx,4),%esi
  800885:	85 f6                	test   %esi,%esi
  800887:	75 19                	jne    8008a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800889:	53                   	push   %ebx
  80088a:	68 85 27 80 00       	push   $0x802785
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 5e 02 00 00       	call   800af8 <printfmt>
  80089a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80089d:	e9 49 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a2:	56                   	push   %esi
  8008a3:	68 8e 27 80 00       	push   $0x80278e
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 08             	pushl  0x8(%ebp)
  8008ae:	e8 45 02 00 00       	call   800af8 <printfmt>
  8008b3:	83 c4 10             	add    $0x10,%esp
			break;
  8008b6:	e9 30 02 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 30                	mov    (%eax),%esi
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	75 05                	jne    8008d5 <vprintfmt+0x1a6>
				p = "(null)";
  8008d0:	be 91 27 80 00       	mov    $0x802791,%esi
			if (width > 0 && padc != '-')
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	7e 6d                	jle    800948 <vprintfmt+0x219>
  8008db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008df:	74 67                	je     800948 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	50                   	push   %eax
  8008e8:	56                   	push   %esi
  8008e9:	e8 0c 03 00 00       	call   800bfa <strnlen>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008f4:	eb 16                	jmp    80090c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800909:	ff 4d e4             	decl   -0x1c(%ebp)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800910:	7f e4                	jg     8008f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	eb 34                	jmp    800948 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800914:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800918:	74 1c                	je     800936 <vprintfmt+0x207>
  80091a:	83 fb 1f             	cmp    $0x1f,%ebx
  80091d:	7e 05                	jle    800924 <vprintfmt+0x1f5>
  80091f:	83 fb 7e             	cmp    $0x7e,%ebx
  800922:	7e 12                	jle    800936 <vprintfmt+0x207>
					putch('?', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 3f                	push   $0x3f
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb 0f                	jmp    800945 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	89 f0                	mov    %esi,%eax
  80094a:	8d 70 01             	lea    0x1(%eax),%esi
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	0f be d8             	movsbl %al,%ebx
  800952:	85 db                	test   %ebx,%ebx
  800954:	74 24                	je     80097a <vprintfmt+0x24b>
  800956:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095a:	78 b8                	js     800914 <vprintfmt+0x1e5>
  80095c:	ff 4d e0             	decl   -0x20(%ebp)
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	79 af                	jns    800914 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	eb 13                	jmp    80097a <vprintfmt+0x24b>
				putch(' ', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 20                	push   $0x20
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	ff 4d e4             	decl   -0x1c(%ebp)
  80097a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097e:	7f e7                	jg     800967 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800980:	e9 66 01 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 e8             	pushl  -0x18(%ebp)
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	e8 3c fd ff ff       	call   8006d0 <getint>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	79 23                	jns    8009ca <vprintfmt+0x29b>
				putch('-', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 2d                	push   $0x2d
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bd:	f7 d8                	neg    %eax
  8009bf:	83 d2 00             	adc    $0x0,%edx
  8009c2:	f7 da                	neg    %edx
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 bc 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 84 fc ff ff       	call   800669 <getuint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f5:	e9 98 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 58                	push   $0x58
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 58                	push   $0x58
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			break;
  800a2a:	e9 bc 00 00 00       	jmp    800aeb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 30                	push   $0x30
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	6a 78                	push   $0x78
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a71:	eb 1f                	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 e7 fb ff ff       	call   800669 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a99:	83 ec 04             	sub    $0x4,%esp
  800a9c:	52                   	push   %edx
  800a9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa4:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	ff 75 08             	pushl  0x8(%ebp)
  800aad:	e8 00 fb ff ff       	call   8005b2 <printnum>
  800ab2:	83 c4 20             	add    $0x20,%esp
			break;
  800ab5:	eb 34                	jmp    800aeb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			break;
  800ac6:	eb 23                	jmp    800aeb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	6a 25                	push   $0x25
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	ff d0                	call   *%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad8:	ff 4d 10             	decl   0x10(%ebp)
  800adb:	eb 03                	jmp    800ae0 <vprintfmt+0x3b1>
  800add:	ff 4d 10             	decl   0x10(%ebp)
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	48                   	dec    %eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	3c 25                	cmp    $0x25,%al
  800ae8:	75 f3                	jne    800add <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aea:	90                   	nop
		}
	}
  800aeb:	e9 47 fc ff ff       	jmp    800737 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800afe:	8d 45 10             	lea    0x10(%ebp),%eax
  800b01:	83 c0 04             	add    $0x4,%eax
  800b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 16 fc ff ff       	call   80072f <vprintfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1c:	90                   	nop
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8b 40 08             	mov    0x8(%eax),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 10                	mov    (%eax),%edx
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 40 04             	mov    0x4(%eax),%eax
  800b3c:	39 c2                	cmp    %eax,%edx
  800b3e:	73 12                	jae    800b52 <sprintputch+0x33>
		*b->buf++ = ch;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	8d 48 01             	lea    0x1(%eax),%ecx
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	89 0a                	mov    %ecx,(%edx)
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	88 10                	mov    %dl,(%eax)
}
  800b52:	90                   	nop
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
  800b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7a:	74 06                	je     800b82 <vsnprintf+0x2d>
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	7f 07                	jg     800b89 <vsnprintf+0x34>
		return -E_INVAL;
  800b82:	b8 03 00 00 00       	mov    $0x3,%eax
  800b87:	eb 20                	jmp    800ba9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b89:	ff 75 14             	pushl  0x14(%ebp)
  800b8c:	ff 75 10             	pushl  0x10(%ebp)
  800b8f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b92:	50                   	push   %eax
  800b93:	68 1f 0b 80 00       	push   $0x800b1f
  800b98:	e8 92 fb ff ff       	call   80072f <vprintfmt>
  800b9d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb1:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb4:	83 c0 04             	add    $0x4,%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bba:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 89 ff ff ff       	call   800b55 <vsnprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be4:	eb 06                	jmp    800bec <strlen+0x15>
		n++;
  800be6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be9:	ff 45 08             	incl   0x8(%ebp)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	84 c0                	test   %al,%al
  800bf3:	75 f1                	jne    800be6 <strlen+0xf>
		n++;
	return n;
  800bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c07:	eb 09                	jmp    800c12 <strnlen+0x18>
		n++;
  800c09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0c:	ff 45 08             	incl   0x8(%ebp)
  800c0f:	ff 4d 0c             	decl   0xc(%ebp)
  800c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c16:	74 09                	je     800c21 <strnlen+0x27>
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e8                	jne    800c09 <strnlen+0xf>
		n++;
	return n;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c32:	90                   	nop
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8d 50 01             	lea    0x1(%eax),%edx
  800c39:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 e4                	jne    800c33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c67:	eb 1f                	jmp    800c88 <strncpy+0x34>
		*dst++ = *src;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8d 50 01             	lea    0x1(%eax),%edx
  800c6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	74 03                	je     800c85 <strncpy+0x31>
			src++;
  800c82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c85:	ff 45 fc             	incl   -0x4(%ebp)
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8e:	72 d9                	jb     800c69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca5:	74 30                	je     800cd7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca7:	eb 16                	jmp    800cbf <strlcpy+0x2a>
			*dst++ = *src++;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc6:	74 09                	je     800cd1 <strlcpy+0x3c>
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	75 d8                	jne    800ca9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdd:	29 c2                	sub    %eax,%edx
  800cdf:	89 d0                	mov    %edx,%eax
}
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce6:	eb 06                	jmp    800cee <strcmp+0xb>
		p++, q++;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 0e                	je     800d05 <strcmp+0x22>
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 10                	mov    (%eax),%dl
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	38 c2                	cmp    %al,%dl
  800d03:	74 e3                	je     800ce8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 c0             	movzbl %al,%eax
  800d15:	29 c2                	sub    %eax,%edx
  800d17:	89 d0                	mov    %edx,%eax
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1e:	eb 09                	jmp    800d29 <strncmp+0xe>
		n--, p++, q++;
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2d:	74 17                	je     800d46 <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	84 c0                	test   %al,%al
  800d36:	74 0e                	je     800d46 <strncmp+0x2b>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 10                	mov    (%eax),%dl
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	38 c2                	cmp    %al,%dl
  800d44:	74 da                	je     800d20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4a:	75 07                	jne    800d53 <strncmp+0x38>
		return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d51:	eb 14                	jmp    800d67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	0f b6 d0             	movzbl %al,%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	0f b6 c0             	movzbl %al,%eax
  800d63:	29 c2                	sub    %eax,%edx
  800d65:	89 d0                	mov    %edx,%eax
}
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 12                	jmp    800d89 <strchr+0x20>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	75 05                	jne    800d86 <strchr+0x1d>
			return (char *) s;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	eb 11                	jmp    800d97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e5                	jne    800d77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 0d                	jmp    800db4 <strfind+0x1b>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	74 0e                	je     800dbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 ea                	jne    800da7 <strfind+0xe>
  800dbd:	eb 01                	jmp    800dc0 <strfind+0x27>
		if (*s == c)
			break;
  800dbf:	90                   	nop
	return (char *) s;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd7:	eb 0e                	jmp    800de7 <memset+0x22>
		*p++ = c;
  800dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de7:	ff 4d f8             	decl   -0x8(%ebp)
  800dea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dee:	79 e9                	jns    800dd9 <memset+0x14>
		*p++ = c;

	return v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e07:	eb 16                	jmp    800e1f <memcpy+0x2a>
		*d++ = *s++;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1b:	8a 12                	mov    (%edx),%dl
  800e1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e25:	89 55 10             	mov    %edx,0x10(%ebp)
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 dd                	jne    800e09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e49:	73 50                	jae    800e9b <memmove+0x6a>
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e56:	76 43                	jbe    800e9b <memmove+0x6a>
		s += n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e64:	eb 10                	jmp    800e76 <memmove+0x45>
			*--d = *--s;
  800e66:	ff 4d f8             	decl   -0x8(%ebp)
  800e69:	ff 4d fc             	decl   -0x4(%ebp)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e76:	8b 45 10             	mov    0x10(%ebp),%eax
  800e79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	75 e3                	jne    800e66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e83:	eb 23                	jmp    800ea8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	8d 50 01             	lea    0x1(%eax),%edx
  800e8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e97:	8a 12                	mov    (%edx),%dl
  800e99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	75 dd                	jne    800e85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ebf:	eb 2a                	jmp    800eeb <memcmp+0x3e>
		if (*s1 != *s2)
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	8a 10                	mov    (%eax),%dl
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	38 c2                	cmp    %al,%dl
  800ecd:	74 16                	je     800ee5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	29 c2                	sub    %eax,%edx
  800ee1:	89 d0                	mov    %edx,%eax
  800ee3:	eb 18                	jmp    800efd <memcmp+0x50>
		s1++, s2++;
  800ee5:	ff 45 fc             	incl   -0x4(%ebp)
  800ee8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 c9                	jne    800ec1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f10:	eb 15                	jmp    800f27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	0f b6 c0             	movzbl %al,%eax
  800f20:	39 c2                	cmp    %eax,%edx
  800f22:	74 0d                	je     800f31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2d:	72 e3                	jb     800f12 <memfind+0x13>
  800f2f:	eb 01                	jmp    800f32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f31:	90                   	nop
	return (void *) s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4b:	eb 03                	jmp    800f50 <strtol+0x19>
		s++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 20                	cmp    $0x20,%al
  800f57:	74 f4                	je     800f4d <strtol+0x16>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 09                	cmp    $0x9,%al
  800f60:	74 eb                	je     800f4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 2b                	cmp    $0x2b,%al
  800f69:	75 05                	jne    800f70 <strtol+0x39>
		s++;
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	eb 13                	jmp    800f83 <strtol+0x4c>
	else if (*s == '-')
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 2d                	cmp    $0x2d,%al
  800f77:	75 0a                	jne    800f83 <strtol+0x4c>
		s++, neg = 1;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 06                	je     800f8f <strtol+0x58>
  800f89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8d:	75 20                	jne    800faf <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 30                	cmp    $0x30,%al
  800f96:	75 17                	jne    800faf <strtol+0x78>
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	40                   	inc    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 78                	cmp    $0x78,%al
  800fa0:	75 0d                	jne    800faf <strtol+0x78>
		s += 2, base = 16;
  800fa2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fad:	eb 28                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	75 15                	jne    800fca <strtol+0x93>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 30                	cmp    $0x30,%al
  800fbc:	75 0c                	jne    800fca <strtol+0x93>
		s++, base = 8;
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc8:	eb 0d                	jmp    800fd7 <strtol+0xa0>
	else if (base == 0)
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	75 07                	jne    800fd7 <strtol+0xa0>
		base = 10;
  800fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 2f                	cmp    $0x2f,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xc2>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 39                	cmp    $0x39,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xc2>
			dig = *s - '0';
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 30             	sub    $0x30,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 42                	jmp    80103b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 60                	cmp    $0x60,%al
  801000:	7e 19                	jle    80101b <strtol+0xe4>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 7a                	cmp    $0x7a,%al
  801009:	7f 10                	jg     80101b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 57             	sub    $0x57,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801019:	eb 20                	jmp    80103b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 40                	cmp    $0x40,%al
  801022:	7e 39                	jle    80105d <strtol+0x126>
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 5a                	cmp    $0x5a,%al
  80102b:	7f 30                	jg     80105d <strtol+0x126>
			dig = *s - 'A' + 10;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f be c0             	movsbl %al,%eax
  801035:	83 e8 37             	sub    $0x37,%eax
  801038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801041:	7d 19                	jge    80105c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801057:	e9 7b ff ff ff       	jmp    800fd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801061:	74 08                	je     80106b <strtol+0x134>
		*endptr = (char *) s;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80106f:	74 07                	je     801078 <strtol+0x141>
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	f7 d8                	neg    %eax
  801076:	eb 03                	jmp    80107b <strtol+0x144>
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <ltostr>:

void
ltostr(long value, char *str)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	79 13                	jns    8010aa <ltostr+0x2d>
	{
		neg = 1;
  801097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b2:	99                   	cltd   
  8010b3:	f7 f9                	idiv   %ecx
  8010b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cb:	83 c2 30             	add    $0x30,%edx
  8010ce:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d8:	f7 e9                	imul   %ecx
  8010da:	c1 fa 02             	sar    $0x2,%edx
  8010dd:	89 c8                	mov    %ecx,%eax
  8010df:	c1 f8 1f             	sar    $0x1f,%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
  8010e6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f1:	f7 e9                	imul   %ecx
  8010f3:	c1 fa 02             	sar    $0x2,%edx
  8010f6:	89 c8                	mov    %ecx,%eax
  8010f8:	c1 f8 1f             	sar    $0x1f,%eax
  8010fb:	29 c2                	sub    %eax,%edx
  8010fd:	89 d0                	mov    %edx,%eax
  8010ff:	c1 e0 02             	shl    $0x2,%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	29 c1                	sub    %eax,%ecx
  801108:	89 ca                	mov    %ecx,%edx
  80110a:	85 d2                	test   %edx,%edx
  80110c:	75 9c                	jne    8010aa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80110e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	48                   	dec    %eax
  801119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80111c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801120:	74 3d                	je     80115f <ltostr+0xe2>
		start = 1 ;
  801122:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801129:	eb 34                	jmp    80115f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80112b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80114c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8a 45 eb             	mov    -0x15(%ebp),%al
  801157:	88 02                	mov    %al,(%edx)
		start++ ;
  801159:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80115c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801162:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801165:	7c c4                	jl     80112b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801167:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801172:	90                   	nop
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 54 fa ff ff       	call   800bd7 <strlen>
  801183:	83 c4 04             	add    $0x4,%esp
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801189:	ff 75 0c             	pushl  0xc(%ebp)
  80118c:	e8 46 fa ff ff       	call   800bd7 <strlen>
  801191:	83 c4 04             	add    $0x4,%esp
  801194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80119e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a5:	eb 17                	jmp    8011be <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	01 c2                	add    %eax,%edx
  8011af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	01 c8                	add    %ecx,%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011bb:	ff 45 fc             	incl   -0x4(%ebp)
  8011be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011c4:	7c e1                	jl     8011a7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011d4:	eb 1f                	jmp    8011f5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011df:	89 c2                	mov    %eax,%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 c2                	add    %eax,%edx
  8011e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	01 c8                	add    %ecx,%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011f2:	ff 45 f8             	incl   -0x8(%ebp)
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	7c d9                	jl     8011d6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801200:	8b 45 10             	mov    0x10(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	c6 00 00             	movb   $0x0,(%eax)
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801217:	8b 45 14             	mov    0x14(%ebp),%eax
  80121a:	8b 00                	mov    (%eax),%eax
  80121c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122e:	eb 0c                	jmp    80123c <strsplit+0x31>
			*string++ = 0;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 08             	mov    %edx,0x8(%ebp)
  801239:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 18                	je     80125d <strsplit+0x52>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f be c0             	movsbl %al,%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	e8 13 fb ff ff       	call   800d69 <strchr>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	75 d3                	jne    801230 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	84 c0                	test   %al,%al
  801264:	74 5a                	je     8012c0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	83 f8 0f             	cmp    $0xf,%eax
  80126e:	75 07                	jne    801277 <strsplit+0x6c>
		{
			return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	eb 66                	jmp    8012dd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	8d 48 01             	lea    0x1(%eax),%ecx
  80127f:	8b 55 14             	mov    0x14(%ebp),%edx
  801282:	89 0a                	mov    %ecx,(%edx)
  801284:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	01 c2                	add    %eax,%edx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801295:	eb 03                	jmp    80129a <strsplit+0x8f>
			string++;
  801297:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	84 c0                	test   %al,%al
  8012a1:	74 8b                	je     80122e <strsplit+0x23>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f be c0             	movsbl %al,%eax
  8012ab:	50                   	push   %eax
  8012ac:	ff 75 0c             	pushl  0xc(%ebp)
  8012af:	e8 b5 fa ff ff       	call   800d69 <strchr>
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	74 dc                	je     801297 <strsplit+0x8c>
			string++;
	}
  8012bb:	e9 6e ff ff ff       	jmp    80122e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012c0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  8012e5:	a1 28 30 80 00       	mov    0x803028,%eax
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	75 33                	jne    801321 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  8012ee:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  8012f5:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  8012f8:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  8012ff:	00 00 a0 
		spaces[0].pages = numPages;
  801302:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801309:	00 02 00 
		spaces[0].isFree = 1;
  80130c:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801313:	00 00 00 
		arraySize++;
  801316:	a1 28 30 80 00       	mov    0x803028,%eax
  80131b:	40                   	inc    %eax
  80131c:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801321:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801328:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  80132f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801336:	8b 55 08             	mov    0x8(%ebp),%edx
  801339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80133c:	01 d0                	add    %edx,%eax
  80133e:	48                   	dec    %eax
  80133f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801345:	ba 00 00 00 00       	mov    $0x0,%edx
  80134a:	f7 75 e8             	divl   -0x18(%ebp)
  80134d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801350:	29 d0                	sub    %edx,%eax
  801352:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	c1 e8 0c             	shr    $0xc,%eax
  80135b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  80135e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801365:	eb 57                	jmp    8013be <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136a:	c1 e0 04             	shl    $0x4,%eax
  80136d:	05 2c 31 80 00       	add    $0x80312c,%eax
  801372:	8b 00                	mov    (%eax),%eax
  801374:	85 c0                	test   %eax,%eax
  801376:	74 42                	je     8013ba <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137b:	c1 e0 04             	shl    $0x4,%eax
  80137e:	05 28 31 80 00       	add    $0x803128,%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801388:	7c 31                	jl     8013bb <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  80138a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138d:	c1 e0 04             	shl    $0x4,%eax
  801390:	05 28 31 80 00       	add    $0x803128,%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80139a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80139d:	7d 1c                	jge    8013bb <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  80139f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a2:	c1 e0 04             	shl    $0x4,%eax
  8013a5:	05 28 31 80 00       	add    $0x803128,%eax
  8013aa:	8b 00                	mov    (%eax),%eax
  8013ac:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8013af:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8013b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013b8:	eb 01                	jmp    8013bb <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8013ba:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8013bb:	ff 45 ec             	incl   -0x14(%ebp)
  8013be:	a1 28 30 80 00       	mov    0x803028,%eax
  8013c3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8013c6:	7c 9f                	jl     801367 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8013c8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8013cc:	75 0a                	jne    8013d8 <malloc+0xf9>
	{
		return NULL;
  8013ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d3:	e9 34 01 00 00       	jmp    80150c <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  8013d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013db:	c1 e0 04             	shl    $0x4,%eax
  8013de:	05 28 31 80 00       	add    $0x803128,%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8013e8:	75 38                	jne    801422 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ed:	c1 e0 04             	shl    $0x4,%eax
  8013f0:	05 2c 31 80 00       	add    $0x80312c,%eax
  8013f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  8013fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fe:	c1 e0 0c             	shl    $0xc,%eax
  801401:	89 c2                	mov    %eax,%edx
  801403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801406:	c1 e0 04             	shl    $0x4,%eax
  801409:	05 20 31 80 00       	add    $0x803120,%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	83 ec 08             	sub    $0x8,%esp
  801413:	52                   	push   %edx
  801414:	50                   	push   %eax
  801415:	e8 01 06 00 00       	call   801a1b <sys_allocateMem>
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	e9 dd 00 00 00       	jmp    8014ff <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801425:	c1 e0 04             	shl    $0x4,%eax
  801428:	05 20 31 80 00       	add    $0x803120,%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801432:	c1 e2 0c             	shl    $0xc,%edx
  801435:	01 d0                	add    %edx,%eax
  801437:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  80143a:	a1 28 30 80 00       	mov    0x803028,%eax
  80143f:	c1 e0 04             	shl    $0x4,%eax
  801442:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  801448:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80144b:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80144d:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	c1 e0 04             	shl    $0x4,%eax
  801459:	05 24 31 80 00       	add    $0x803124,%eax
  80145e:	8b 00                	mov    (%eax),%eax
  801460:	c1 e2 04             	shl    $0x4,%edx
  801463:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801469:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80146b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	c1 e0 04             	shl    $0x4,%eax
  801477:	05 28 31 80 00       	add    $0x803128,%eax
  80147c:	8b 00                	mov    (%eax),%eax
  80147e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801481:	c1 e2 04             	shl    $0x4,%edx
  801484:	81 c2 28 31 80 00    	add    $0x803128,%edx
  80148a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  80148c:	a1 28 30 80 00       	mov    0x803028,%eax
  801491:	c1 e0 04             	shl    $0x4,%eax
  801494:	05 2c 31 80 00       	add    $0x80312c,%eax
  801499:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  80149f:	a1 28 30 80 00       	mov    0x803028,%eax
  8014a4:	40                   	inc    %eax
  8014a5:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	c1 e0 04             	shl    $0x4,%eax
  8014b0:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8014b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b9:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014be:	c1 e0 04             	shl    $0x4,%eax
  8014c1:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  8014c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ca:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cf:	c1 e0 04             	shl    $0x4,%eax
  8014d2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8014d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  8014dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e0:	c1 e0 0c             	shl    $0xc,%eax
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e8:	c1 e0 04             	shl    $0x4,%eax
  8014eb:	05 20 31 80 00       	add    $0x803120,%eax
  8014f0:	8b 00                	mov    (%eax),%eax
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	52                   	push   %edx
  8014f6:	50                   	push   %eax
  8014f7:	e8 1f 05 00 00       	call   801a1b <sys_allocateMem>
  8014fc:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	c1 e0 04             	shl    $0x4,%eax
  801505:	05 20 31 80 00       	add    $0x803120,%eax
  80150a:	8b 00                	mov    (%eax),%eax
	}


}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801514:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80151b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801522:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801529:	eb 3f                	jmp    80156a <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80152b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152e:	c1 e0 04             	shl    $0x4,%eax
  801531:	05 20 31 80 00       	add    $0x803120,%eax
  801536:	8b 00                	mov    (%eax),%eax
  801538:	3b 45 08             	cmp    0x8(%ebp),%eax
  80153b:	75 2a                	jne    801567 <free+0x59>
		{
			index=i;
  80153d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801540:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c1 e0 04             	shl    $0x4,%eax
  801549:	05 28 31 80 00       	add    $0x803128,%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	c1 e0 0c             	shl    $0xc,%eax
  801553:	89 c2                	mov    %eax,%edx
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	52                   	push   %edx
  80155c:	50                   	push   %eax
  80155d:	e8 9d 04 00 00       	call   8019ff <sys_freeMem>
  801562:	83 c4 10             	add    $0x10,%esp
			break;
  801565:	eb 0d                	jmp    801574 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801567:	ff 45 ec             	incl   -0x14(%ebp)
  80156a:	a1 28 30 80 00       	mov    0x803028,%eax
  80156f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801572:	7c b7                	jl     80152b <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801574:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801578:	75 17                	jne    801591 <free+0x83>
	{
		panic("Error");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 f0 28 80 00       	push   $0x8028f0
  801582:	68 81 00 00 00       	push   $0x81
  801587:	68 f6 28 80 00       	push   $0x8028f6
  80158c:	e8 22 ed ff ff       	call   8002b3 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801591:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801598:	e9 cc 00 00 00       	jmp    801669 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80159d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a0:	c1 e0 04             	shl    $0x4,%eax
  8015a3:	05 2c 31 80 00       	add    $0x80312c,%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	0f 84 b3 00 00 00    	je     801665 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	c1 e0 04             	shl    $0x4,%eax
  8015b8:	05 20 31 80 00       	add    $0x803120,%eax
  8015bd:	8b 10                	mov    (%eax),%edx
  8015bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c2:	c1 e0 04             	shl    $0x4,%eax
  8015c5:	05 24 31 80 00       	add    $0x803124,%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	39 c2                	cmp    %eax,%edx
  8015ce:	0f 85 92 00 00 00    	jne    801666 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  8015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d7:	c1 e0 04             	shl    $0x4,%eax
  8015da:	05 24 31 80 00       	add    $0x803124,%eax
  8015df:	8b 00                	mov    (%eax),%eax
  8015e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015e4:	c1 e2 04             	shl    $0x4,%edx
  8015e7:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8015ed:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8015ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f2:	c1 e0 04             	shl    $0x4,%eax
  8015f5:	05 28 31 80 00       	add    $0x803128,%eax
  8015fa:	8b 10                	mov    (%eax),%edx
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	c1 e0 04             	shl    $0x4,%eax
  801602:	05 28 31 80 00       	add    $0x803128,%eax
  801607:	8b 00                	mov    (%eax),%eax
  801609:	01 c2                	add    %eax,%edx
  80160b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80160e:	c1 e0 04             	shl    $0x4,%eax
  801611:	05 28 31 80 00       	add    $0x803128,%eax
  801616:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161b:	c1 e0 04             	shl    $0x4,%eax
  80161e:	05 20 31 80 00       	add    $0x803120,%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	c1 e0 04             	shl    $0x4,%eax
  80162f:	05 24 31 80 00       	add    $0x803124,%eax
  801634:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  80163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163d:	c1 e0 04             	shl    $0x4,%eax
  801640:	05 28 31 80 00       	add    $0x803128,%eax
  801645:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164e:	c1 e0 04             	shl    $0x4,%eax
  801651:	05 2c 31 80 00       	add    $0x80312c,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80165c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801663:	eb 12                	jmp    801677 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801665:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801666:	ff 45 e8             	incl   -0x18(%ebp)
  801669:	a1 28 30 80 00       	mov    0x803028,%eax
  80166e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801671:	0f 8c 26 ff ff ff    	jl     80159d <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801677:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80167e:	e9 cc 00 00 00       	jmp    80174f <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801686:	c1 e0 04             	shl    $0x4,%eax
  801689:	05 2c 31 80 00       	add    $0x80312c,%eax
  80168e:	8b 00                	mov    (%eax),%eax
  801690:	85 c0                	test   %eax,%eax
  801692:	0f 84 b3 00 00 00    	je     80174b <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	c1 e0 04             	shl    $0x4,%eax
  80169e:	05 24 31 80 00       	add    $0x803124,%eax
  8016a3:	8b 10                	mov    (%eax),%edx
  8016a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a8:	c1 e0 04             	shl    $0x4,%eax
  8016ab:	05 20 31 80 00       	add    $0x803120,%eax
  8016b0:	8b 00                	mov    (%eax),%eax
  8016b2:	39 c2                	cmp    %eax,%edx
  8016b4:	0f 85 92 00 00 00    	jne    80174c <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	c1 e0 04             	shl    $0x4,%eax
  8016c0:	05 20 31 80 00       	add    $0x803120,%eax
  8016c5:	8b 00                	mov    (%eax),%eax
  8016c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016ca:	c1 e2 04             	shl    $0x4,%edx
  8016cd:	81 c2 20 31 80 00    	add    $0x803120,%edx
  8016d3:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8016d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d8:	c1 e0 04             	shl    $0x4,%eax
  8016db:	05 28 31 80 00       	add    $0x803128,%eax
  8016e0:	8b 10                	mov    (%eax),%edx
  8016e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e5:	c1 e0 04             	shl    $0x4,%eax
  8016e8:	05 28 31 80 00       	add    $0x803128,%eax
  8016ed:	8b 00                	mov    (%eax),%eax
  8016ef:	01 c2                	add    %eax,%edx
  8016f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f4:	c1 e0 04             	shl    $0x4,%eax
  8016f7:	05 28 31 80 00       	add    $0x803128,%eax
  8016fc:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	c1 e0 04             	shl    $0x4,%eax
  801704:	05 20 31 80 00       	add    $0x803120,%eax
  801709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	c1 e0 04             	shl    $0x4,%eax
  801715:	05 24 31 80 00       	add    $0x803124,%eax
  80171a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	c1 e0 04             	shl    $0x4,%eax
  801726:	05 28 31 80 00       	add    $0x803128,%eax
  80172b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	c1 e0 04             	shl    $0x4,%eax
  801737:	05 2c 31 80 00       	add    $0x80312c,%eax
  80173c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801742:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801749:	eb 12                	jmp    80175d <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80174b:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  80174c:	ff 45 e4             	incl   -0x1c(%ebp)
  80174f:	a1 28 30 80 00       	mov    0x803028,%eax
  801754:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801757:	0f 8c 26 ff ff ff    	jl     801683 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80175d:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801761:	75 11                	jne    801774 <free+0x266>
	{
		spaces[index].isFree = 1;
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	c1 e0 04             	shl    $0x4,%eax
  801769:	05 2c 31 80 00       	add    $0x80312c,%eax
  80176e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 18             	sub    $0x18,%esp
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 04 29 80 00       	push   $0x802904
  80178b:	68 b9 00 00 00       	push   $0xb9
  801790:	68 f6 28 80 00       	push   $0x8028f6
  801795:	e8 19 eb ff ff       	call   8002b3 <_panic>

0080179a <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 04 29 80 00       	push   $0x802904
  8017a8:	68 bf 00 00 00       	push   $0xbf
  8017ad:	68 f6 28 80 00       	push   $0x8028f6
  8017b2:	e8 fc ea ff ff       	call   8002b3 <_panic>

008017b7 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 04 29 80 00       	push   $0x802904
  8017c5:	68 c5 00 00 00       	push   $0xc5
  8017ca:	68 f6 28 80 00       	push   $0x8028f6
  8017cf:	e8 df ea ff ff       	call   8002b3 <_panic>

008017d4 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 04 29 80 00       	push   $0x802904
  8017e2:	68 ca 00 00 00       	push   $0xca
  8017e7:	68 f6 28 80 00       	push   $0x8028f6
  8017ec:	e8 c2 ea ff ff       	call   8002b3 <_panic>

008017f1 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 04 29 80 00       	push   $0x802904
  8017ff:	68 d0 00 00 00       	push   $0xd0
  801804:	68 f6 28 80 00       	push   $0x8028f6
  801809:	e8 a5 ea ff ff       	call   8002b3 <_panic>

0080180e <shrink>:
}
void shrink(uint32 newSize)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 04 29 80 00       	push   $0x802904
  80181c:	68 d4 00 00 00       	push   $0xd4
  801821:	68 f6 28 80 00       	push   $0x8028f6
  801826:	e8 88 ea ff ff       	call   8002b3 <_panic>

0080182b <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 04 29 80 00       	push   $0x802904
  801839:	68 d9 00 00 00       	push   $0xd9
  80183e:	68 f6 28 80 00       	push   $0x8028f6
  801843:	e8 6b ea ff ff       	call   8002b3 <_panic>

00801848 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	57                   	push   %edi
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
  80184e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801860:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801863:	cd 30                	int    $0x30
  801865:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5f                   	pop    %edi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80187f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	52                   	push   %edx
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	50                   	push   %eax
  80188f:	6a 00                	push   $0x0
  801891:	e8 b2 ff ff ff       	call   801848 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_cgetc>:

int
sys_cgetc(void)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 01                	push   $0x1
  8018ab:	e8 98 ff ff ff       	call   801848 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	50                   	push   %eax
  8018c4:	6a 05                	push   $0x5
  8018c6:	e8 7d ff ff ff       	call   801848 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 02                	push   $0x2
  8018df:	e8 64 ff ff ff       	call   801848 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 03                	push   $0x3
  8018f8:	e8 4b ff ff ff       	call   801848 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 04                	push   $0x4
  801911:	e8 32 ff ff ff       	call   801848 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_env_exit>:


void sys_env_exit(void)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 06                	push   $0x6
  80192a:	e8 19 ff ff ff       	call   801848 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	90                   	nop
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	52                   	push   %edx
  801945:	50                   	push   %eax
  801946:	6a 07                	push   $0x7
  801948:	e8 fb fe ff ff       	call   801848 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	56                   	push   %esi
  801956:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801957:	8b 75 18             	mov    0x18(%ebp),%esi
  80195a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801960:	8b 55 0c             	mov    0xc(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 08                	push   $0x8
  80196d:	e8 d6 fe ff ff       	call   801848 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801978:	5b                   	pop    %ebx
  801979:	5e                   	pop    %esi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80197f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	52                   	push   %edx
  80198c:	50                   	push   %eax
  80198d:	6a 09                	push   $0x9
  80198f:	e8 b4 fe ff ff       	call   801848 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	6a 0a                	push   $0xa
  8019aa:	e8 99 fe ff ff       	call   801848 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 0b                	push   $0xb
  8019c3:	e8 80 fe ff ff       	call   801848 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 0c                	push   $0xc
  8019dc:	e8 67 fe ff ff       	call   801848 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 0d                	push   $0xd
  8019f5:	e8 4e fe ff ff       	call   801848 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	ff 75 0c             	pushl  0xc(%ebp)
  801a0b:	ff 75 08             	pushl  0x8(%ebp)
  801a0e:	6a 11                	push   $0x11
  801a10:	e8 33 fe ff ff       	call   801848 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
	return;
  801a18:	90                   	nop
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 12                	push   $0x12
  801a2c:	e8 17 fe ff ff       	call   801848 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 0e                	push   $0xe
  801a46:	e8 fd fd ff ff       	call   801848 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	6a 0f                	push   $0xf
  801a60:	e8 e3 fd ff ff       	call   801848 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 10                	push   $0x10
  801a79:	e8 ca fd ff ff       	call   801848 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 14                	push   $0x14
  801a93:	e8 b0 fd ff ff       	call   801848 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 15                	push   $0x15
  801aad:	e8 96 fd ff ff       	call   801848 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	90                   	nop
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ac4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	50                   	push   %eax
  801ad1:	6a 16                	push   $0x16
  801ad3:	e8 70 fd ff ff       	call   801848 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	90                   	nop
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 17                	push   $0x17
  801aed:	e8 56 fd ff ff       	call   801848 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	50                   	push   %eax
  801b08:	6a 18                	push   $0x18
  801b0a:	e8 39 fd ff ff       	call   801848 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 1b                	push   $0x1b
  801b27:	e8 1c fd ff ff       	call   801848 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 19                	push   $0x19
  801b44:	e8 ff fc ff ff       	call   801848 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	90                   	nop
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	52                   	push   %edx
  801b5f:	50                   	push   %eax
  801b60:	6a 1a                	push   $0x1a
  801b62:	e8 e1 fc ff ff       	call   801848 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	8b 45 10             	mov    0x10(%ebp),%eax
  801b76:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	51                   	push   %ecx
  801b86:	52                   	push   %edx
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	50                   	push   %eax
  801b8b:	6a 1c                	push   $0x1c
  801b8d:	e8 b6 fc ff ff       	call   801848 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 1d                	push   $0x1d
  801baa:	e8 99 fc ff ff       	call   801848 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	51                   	push   %ecx
  801bc5:	52                   	push   %edx
  801bc6:	50                   	push   %eax
  801bc7:	6a 1e                	push   $0x1e
  801bc9:	e8 7a fc ff ff       	call   801848 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	52                   	push   %edx
  801be3:	50                   	push   %eax
  801be4:	6a 1f                	push   $0x1f
  801be6:	e8 5d fc ff ff       	call   801848 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 20                	push   $0x20
  801bff:	e8 44 fc ff ff       	call   801848 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	ff 75 14             	pushl  0x14(%ebp)
  801c14:	ff 75 10             	pushl  0x10(%ebp)
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	50                   	push   %eax
  801c1b:	6a 21                	push   $0x21
  801c1d:	e8 26 fc ff ff       	call   801848 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	50                   	push   %eax
  801c36:	6a 22                	push   $0x22
  801c38:	e8 0b fc ff ff       	call   801848 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	50                   	push   %eax
  801c52:	6a 23                	push   $0x23
  801c54:	e8 ef fb ff ff       	call   801848 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c68:	8d 50 04             	lea    0x4(%eax),%edx
  801c6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	6a 24                	push   $0x24
  801c78:	e8 cb fb ff ff       	call   801848 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c89:	89 01                	mov    %eax,(%ecx)
  801c8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	c9                   	leave  
  801c92:	c2 04 00             	ret    $0x4

00801c95 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 10             	pushl  0x10(%ebp)
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	ff 75 08             	pushl  0x8(%ebp)
  801ca5:	6a 13                	push   $0x13
  801ca7:	e8 9c fb ff ff       	call   801848 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return ;
  801caf:	90                   	nop
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 25                	push   $0x25
  801cc1:	e8 82 fb ff ff       	call   801848 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	50                   	push   %eax
  801ce4:	6a 26                	push   $0x26
  801ce6:	e8 5d fb ff ff       	call   801848 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <rsttst>:
void rsttst()
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 28                	push   $0x28
  801d00:	e8 43 fb ff ff       	call   801848 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return ;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	8b 45 14             	mov    0x14(%ebp),%eax
  801d14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d17:	8b 55 18             	mov    0x18(%ebp),%edx
  801d1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	ff 75 10             	pushl  0x10(%ebp)
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	6a 27                	push   $0x27
  801d2b:	e8 18 fb ff ff       	call   801848 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <chktst>:
void chktst(uint32 n)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 29                	push   $0x29
  801d46:	e8 fd fa ff ff       	call   801848 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <inctst>:

void inctst()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 2a                	push   $0x2a
  801d60:	e8 e3 fa ff ff       	call   801848 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <gettst>:
uint32 gettst()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 2b                	push   $0x2b
  801d7a:	e8 c9 fa ff ff       	call   801848 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 2c                	push   $0x2c
  801d96:	e8 ad fa ff ff       	call   801848 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
  801d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801da5:	75 07                	jne    801dae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801da7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dac:	eb 05                	jmp    801db3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 2c                	push   $0x2c
  801dc7:	e8 7c fa ff ff       	call   801848 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
  801dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dd6:	75 07                	jne    801ddf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddd:	eb 05                	jmp    801de4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 2c                	push   $0x2c
  801df8:	e8 4b fa ff ff       	call   801848 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e07:	75 07                	jne    801e10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e09:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0e:	eb 05                	jmp    801e15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 2c                	push   $0x2c
  801e29:	e8 1a fa ff ff       	call   801848 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
  801e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e38:	75 07                	jne    801e41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3f:	eb 05                	jmp    801e46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	6a 2d                	push   $0x2d
  801e58:	e8 eb f9 ff ff       	call   801848 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	6a 00                	push   $0x0
  801e75:	53                   	push   %ebx
  801e76:	51                   	push   %ecx
  801e77:	52                   	push   %edx
  801e78:	50                   	push   %eax
  801e79:	6a 2e                	push   $0x2e
  801e7b:	e8 c8 f9 ff ff       	call   801848 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	6a 2f                	push   $0x2f
  801e9b:	e8 a8 f9 ff ff       	call   801848 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801eab:	8b 55 08             	mov    0x8(%ebp),%edx
  801eae:	89 d0                	mov    %edx,%eax
  801eb0:	c1 e0 02             	shl    $0x2,%eax
  801eb3:	01 d0                	add    %edx,%eax
  801eb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 04             	shl    $0x4,%eax
  801ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ed6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801edd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	50                   	push   %eax
  801ee4:	e8 76 fd ff ff       	call   801c5f <sys_get_virtual_time>
  801ee9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801eec:	eb 41                	jmp    801f2f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801eee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	50                   	push   %eax
  801ef5:	e8 65 fd ff ff       	call   801c5f <sys_get_virtual_time>
  801efa:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801efd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f03:	29 c2                	sub    %eax,%edx
  801f05:	89 d0                	mov    %edx,%eax
  801f07:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801f0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f10:	89 d1                	mov    %edx,%ecx
  801f12:	29 c1                	sub    %eax,%ecx
  801f14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f1a:	39 c2                	cmp    %eax,%edx
  801f1c:	0f 97 c0             	seta   %al
  801f1f:	0f b6 c0             	movzbl %al,%eax
  801f22:	29 c1                	sub    %eax,%ecx
  801f24:	89 c8                	mov    %ecx,%eax
  801f26:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801f29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f35:	72 b7                	jb     801eee <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801f37:	90                   	nop
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801f40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801f47:	eb 03                	jmp    801f4c <busy_wait+0x12>
  801f49:	ff 45 fc             	incl   -0x4(%ebp)
  801f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f52:	72 f5                	jb     801f49 <busy_wait+0xf>
	return i;
  801f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    
  801f59:	66 90                	xchg   %ax,%ax
  801f5b:	90                   	nop

00801f5c <__udivdi3>:
  801f5c:	55                   	push   %ebp
  801f5d:	57                   	push   %edi
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 1c             	sub    $0x1c,%esp
  801f63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f73:	89 ca                	mov    %ecx,%edx
  801f75:	89 f8                	mov    %edi,%eax
  801f77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f7b:	85 f6                	test   %esi,%esi
  801f7d:	75 2d                	jne    801fac <__udivdi3+0x50>
  801f7f:	39 cf                	cmp    %ecx,%edi
  801f81:	77 65                	ja     801fe8 <__udivdi3+0x8c>
  801f83:	89 fd                	mov    %edi,%ebp
  801f85:	85 ff                	test   %edi,%edi
  801f87:	75 0b                	jne    801f94 <__udivdi3+0x38>
  801f89:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8e:	31 d2                	xor    %edx,%edx
  801f90:	f7 f7                	div    %edi
  801f92:	89 c5                	mov    %eax,%ebp
  801f94:	31 d2                	xor    %edx,%edx
  801f96:	89 c8                	mov    %ecx,%eax
  801f98:	f7 f5                	div    %ebp
  801f9a:	89 c1                	mov    %eax,%ecx
  801f9c:	89 d8                	mov    %ebx,%eax
  801f9e:	f7 f5                	div    %ebp
  801fa0:	89 cf                	mov    %ecx,%edi
  801fa2:	89 fa                	mov    %edi,%edx
  801fa4:	83 c4 1c             	add    $0x1c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    
  801fac:	39 ce                	cmp    %ecx,%esi
  801fae:	77 28                	ja     801fd8 <__udivdi3+0x7c>
  801fb0:	0f bd fe             	bsr    %esi,%edi
  801fb3:	83 f7 1f             	xor    $0x1f,%edi
  801fb6:	75 40                	jne    801ff8 <__udivdi3+0x9c>
  801fb8:	39 ce                	cmp    %ecx,%esi
  801fba:	72 0a                	jb     801fc6 <__udivdi3+0x6a>
  801fbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fc0:	0f 87 9e 00 00 00    	ja     802064 <__udivdi3+0x108>
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	89 fa                	mov    %edi,%edx
  801fcd:	83 c4 1c             	add    $0x1c,%esp
  801fd0:	5b                   	pop    %ebx
  801fd1:	5e                   	pop    %esi
  801fd2:	5f                   	pop    %edi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    
  801fd5:	8d 76 00             	lea    0x0(%esi),%esi
  801fd8:	31 ff                	xor    %edi,%edi
  801fda:	31 c0                	xor    %eax,%eax
  801fdc:	89 fa                	mov    %edi,%edx
  801fde:	83 c4 1c             	add    $0x1c,%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5f                   	pop    %edi
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    
  801fe6:	66 90                	xchg   %ax,%ax
  801fe8:	89 d8                	mov    %ebx,%eax
  801fea:	f7 f7                	div    %edi
  801fec:	31 ff                	xor    %edi,%edi
  801fee:	89 fa                	mov    %edi,%edx
  801ff0:	83 c4 1c             	add    $0x1c,%esp
  801ff3:	5b                   	pop    %ebx
  801ff4:	5e                   	pop    %esi
  801ff5:	5f                   	pop    %edi
  801ff6:	5d                   	pop    %ebp
  801ff7:	c3                   	ret    
  801ff8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ffd:	89 eb                	mov    %ebp,%ebx
  801fff:	29 fb                	sub    %edi,%ebx
  802001:	89 f9                	mov    %edi,%ecx
  802003:	d3 e6                	shl    %cl,%esi
  802005:	89 c5                	mov    %eax,%ebp
  802007:	88 d9                	mov    %bl,%cl
  802009:	d3 ed                	shr    %cl,%ebp
  80200b:	89 e9                	mov    %ebp,%ecx
  80200d:	09 f1                	or     %esi,%ecx
  80200f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802013:	89 f9                	mov    %edi,%ecx
  802015:	d3 e0                	shl    %cl,%eax
  802017:	89 c5                	mov    %eax,%ebp
  802019:	89 d6                	mov    %edx,%esi
  80201b:	88 d9                	mov    %bl,%cl
  80201d:	d3 ee                	shr    %cl,%esi
  80201f:	89 f9                	mov    %edi,%ecx
  802021:	d3 e2                	shl    %cl,%edx
  802023:	8b 44 24 08          	mov    0x8(%esp),%eax
  802027:	88 d9                	mov    %bl,%cl
  802029:	d3 e8                	shr    %cl,%eax
  80202b:	09 c2                	or     %eax,%edx
  80202d:	89 d0                	mov    %edx,%eax
  80202f:	89 f2                	mov    %esi,%edx
  802031:	f7 74 24 0c          	divl   0xc(%esp)
  802035:	89 d6                	mov    %edx,%esi
  802037:	89 c3                	mov    %eax,%ebx
  802039:	f7 e5                	mul    %ebp
  80203b:	39 d6                	cmp    %edx,%esi
  80203d:	72 19                	jb     802058 <__udivdi3+0xfc>
  80203f:	74 0b                	je     80204c <__udivdi3+0xf0>
  802041:	89 d8                	mov    %ebx,%eax
  802043:	31 ff                	xor    %edi,%edi
  802045:	e9 58 ff ff ff       	jmp    801fa2 <__udivdi3+0x46>
  80204a:	66 90                	xchg   %ax,%ax
  80204c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802050:	89 f9                	mov    %edi,%ecx
  802052:	d3 e2                	shl    %cl,%edx
  802054:	39 c2                	cmp    %eax,%edx
  802056:	73 e9                	jae    802041 <__udivdi3+0xe5>
  802058:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80205b:	31 ff                	xor    %edi,%edi
  80205d:	e9 40 ff ff ff       	jmp    801fa2 <__udivdi3+0x46>
  802062:	66 90                	xchg   %ax,%ax
  802064:	31 c0                	xor    %eax,%eax
  802066:	e9 37 ff ff ff       	jmp    801fa2 <__udivdi3+0x46>
  80206b:	90                   	nop

0080206c <__umoddi3>:
  80206c:	55                   	push   %ebp
  80206d:	57                   	push   %edi
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
  802070:	83 ec 1c             	sub    $0x1c,%esp
  802073:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802077:	8b 74 24 34          	mov    0x34(%esp),%esi
  80207b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80207f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802087:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80208b:	89 f3                	mov    %esi,%ebx
  80208d:	89 fa                	mov    %edi,%edx
  80208f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802093:	89 34 24             	mov    %esi,(%esp)
  802096:	85 c0                	test   %eax,%eax
  802098:	75 1a                	jne    8020b4 <__umoddi3+0x48>
  80209a:	39 f7                	cmp    %esi,%edi
  80209c:	0f 86 a2 00 00 00    	jbe    802144 <__umoddi3+0xd8>
  8020a2:	89 c8                	mov    %ecx,%eax
  8020a4:	89 f2                	mov    %esi,%edx
  8020a6:	f7 f7                	div    %edi
  8020a8:	89 d0                	mov    %edx,%eax
  8020aa:	31 d2                	xor    %edx,%edx
  8020ac:	83 c4 1c             	add    $0x1c,%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5f                   	pop    %edi
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
  8020b4:	39 f0                	cmp    %esi,%eax
  8020b6:	0f 87 ac 00 00 00    	ja     802168 <__umoddi3+0xfc>
  8020bc:	0f bd e8             	bsr    %eax,%ebp
  8020bf:	83 f5 1f             	xor    $0x1f,%ebp
  8020c2:	0f 84 ac 00 00 00    	je     802174 <__umoddi3+0x108>
  8020c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8020cd:	29 ef                	sub    %ebp,%edi
  8020cf:	89 fe                	mov    %edi,%esi
  8020d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020d5:	89 e9                	mov    %ebp,%ecx
  8020d7:	d3 e0                	shl    %cl,%eax
  8020d9:	89 d7                	mov    %edx,%edi
  8020db:	89 f1                	mov    %esi,%ecx
  8020dd:	d3 ef                	shr    %cl,%edi
  8020df:	09 c7                	or     %eax,%edi
  8020e1:	89 e9                	mov    %ebp,%ecx
  8020e3:	d3 e2                	shl    %cl,%edx
  8020e5:	89 14 24             	mov    %edx,(%esp)
  8020e8:	89 d8                	mov    %ebx,%eax
  8020ea:	d3 e0                	shl    %cl,%eax
  8020ec:	89 c2                	mov    %eax,%edx
  8020ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020f2:	d3 e0                	shl    %cl,%eax
  8020f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020fc:	89 f1                	mov    %esi,%ecx
  8020fe:	d3 e8                	shr    %cl,%eax
  802100:	09 d0                	or     %edx,%eax
  802102:	d3 eb                	shr    %cl,%ebx
  802104:	89 da                	mov    %ebx,%edx
  802106:	f7 f7                	div    %edi
  802108:	89 d3                	mov    %edx,%ebx
  80210a:	f7 24 24             	mull   (%esp)
  80210d:	89 c6                	mov    %eax,%esi
  80210f:	89 d1                	mov    %edx,%ecx
  802111:	39 d3                	cmp    %edx,%ebx
  802113:	0f 82 87 00 00 00    	jb     8021a0 <__umoddi3+0x134>
  802119:	0f 84 91 00 00 00    	je     8021b0 <__umoddi3+0x144>
  80211f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802123:	29 f2                	sub    %esi,%edx
  802125:	19 cb                	sbb    %ecx,%ebx
  802127:	89 d8                	mov    %ebx,%eax
  802129:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80212d:	d3 e0                	shl    %cl,%eax
  80212f:	89 e9                	mov    %ebp,%ecx
  802131:	d3 ea                	shr    %cl,%edx
  802133:	09 d0                	or     %edx,%eax
  802135:	89 e9                	mov    %ebp,%ecx
  802137:	d3 eb                	shr    %cl,%ebx
  802139:	89 da                	mov    %ebx,%edx
  80213b:	83 c4 1c             	add    $0x1c,%esp
  80213e:	5b                   	pop    %ebx
  80213f:	5e                   	pop    %esi
  802140:	5f                   	pop    %edi
  802141:	5d                   	pop    %ebp
  802142:	c3                   	ret    
  802143:	90                   	nop
  802144:	89 fd                	mov    %edi,%ebp
  802146:	85 ff                	test   %edi,%edi
  802148:	75 0b                	jne    802155 <__umoddi3+0xe9>
  80214a:	b8 01 00 00 00       	mov    $0x1,%eax
  80214f:	31 d2                	xor    %edx,%edx
  802151:	f7 f7                	div    %edi
  802153:	89 c5                	mov    %eax,%ebp
  802155:	89 f0                	mov    %esi,%eax
  802157:	31 d2                	xor    %edx,%edx
  802159:	f7 f5                	div    %ebp
  80215b:	89 c8                	mov    %ecx,%eax
  80215d:	f7 f5                	div    %ebp
  80215f:	89 d0                	mov    %edx,%eax
  802161:	e9 44 ff ff ff       	jmp    8020aa <__umoddi3+0x3e>
  802166:	66 90                	xchg   %ax,%ax
  802168:	89 c8                	mov    %ecx,%eax
  80216a:	89 f2                	mov    %esi,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	3b 04 24             	cmp    (%esp),%eax
  802177:	72 06                	jb     80217f <__umoddi3+0x113>
  802179:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80217d:	77 0f                	ja     80218e <__umoddi3+0x122>
  80217f:	89 f2                	mov    %esi,%edx
  802181:	29 f9                	sub    %edi,%ecx
  802183:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802187:	89 14 24             	mov    %edx,(%esp)
  80218a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80218e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802192:	8b 14 24             	mov    (%esp),%edx
  802195:	83 c4 1c             	add    $0x1c,%esp
  802198:	5b                   	pop    %ebx
  802199:	5e                   	pop    %esi
  80219a:	5f                   	pop    %edi
  80219b:	5d                   	pop    %ebp
  80219c:	c3                   	ret    
  80219d:	8d 76 00             	lea    0x0(%esi),%esi
  8021a0:	2b 04 24             	sub    (%esp),%eax
  8021a3:	19 fa                	sbb    %edi,%edx
  8021a5:	89 d1                	mov    %edx,%ecx
  8021a7:	89 c6                	mov    %eax,%esi
  8021a9:	e9 71 ff ff ff       	jmp    80211f <__umoddi3+0xb3>
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021b4:	72 ea                	jb     8021a0 <__umoddi3+0x134>
  8021b6:	89 d9                	mov    %ebx,%ecx
  8021b8:	e9 62 ff ff ff       	jmp    80211f <__umoddi3+0xb3>
