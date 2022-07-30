
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 71 01 00 00       	call   8001a7 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  800086:	68 00 22 80 00       	push   $0x802200
  80008b:	6a 12                	push   $0x12
  80008d:	68 1c 22 80 00       	push   $0x80221c
  800092:	e8 55 02 00 00       	call   8002ec <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  800097:	e8 9f 18 00 00       	call   80193b <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 3c 22 80 00       	push   $0x80223c
  8000a4:	50                   	push   %eax
  8000a5:	e8 29 17 00 00       	call   8017d3 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b0:	83 ec 0c             	sub    $0xc,%esp
  8000b3:	68 40 22 80 00       	push   $0x802240
  8000b8:	e8 d1 04 00 00       	call   80058e <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	68 68 22 80 00       	push   $0x802268
  8000c8:	e8 c1 04 00 00       	call   80058e <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 28 23 00 00       	push   $0x2328
  8000d8:	e8 01 1e 00 00       	call   801ede <env_sleep>
  8000dd:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 08 19 00 00       	call   8019ed <sys_calculate_free_frames>
  8000e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ee:	e8 fd 16 00 00       	call   8017f0 <sfree>
  8000f3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 88 22 80 00       	push   $0x802288
  8000fe:	e8 8b 04 00 00       	call   80058e <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800106:	e8 e2 18 00 00       	call   8019ed <sys_calculate_free_frames>
  80010b:	89 c2                	mov    %eax,%edx
  80010d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800110:	29 c2                	sub    %eax,%edx
  800112:	89 d0                	mov    %edx,%eax
  800114:	83 f8 04             	cmp    $0x4,%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 a0 22 80 00       	push   $0x8022a0
  800121:	6a 20                	push   $0x20
  800123:	68 1c 22 80 00       	push   $0x80221c
  800128:	e8 bf 01 00 00       	call   8002ec <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  80012d:	e8 72 1c 00 00       	call   801da4 <gettst>
  800132:	83 f8 02             	cmp    $0x2,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 40 23 80 00       	push   $0x802340
  80013f:	6a 23                	push   $0x23
  800141:	68 1c 22 80 00       	push   $0x80221c
  800146:	e8 a1 01 00 00       	call   8002ec <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	68 4c 23 80 00       	push   $0x80234c
  800153:	e8 36 04 00 00       	call   80058e <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 70 23 80 00       	push   $0x802370
  800163:	e8 26 04 00 00       	call   80058e <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80016b:	e8 cb 17 00 00       	call   80193b <sys_getparentenvid>
  800170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800173:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800177:	7e 2b                	jle    8001a4 <_main+0x16c>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800180:	83 ec 08             	sub    $0x8,%esp
  800183:	68 bc 23 80 00       	push   $0x8023bc
  800188:	ff 75 e4             	pushl  -0x1c(%ebp)
  80018b:	e8 43 16 00 00       	call   8017d3 <sget>
  800190:	83 c4 10             	add    $0x10,%esp
  800193:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  800196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	8d 50 01             	lea    0x1(%eax),%edx
  80019e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a1:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a3:	90                   	nop
  8001a4:	90                   	nop
}
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ad:	e8 70 17 00 00       	call   801922 <sys_getenvindex>
  8001b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	c1 e0 03             	shl    $0x3,%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001c6:	01 c8                	add    %ecx,%eax
  8001c8:	01 c0                	add    %eax,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	01 c0                	add    %eax,%eax
  8001ce:	01 d0                	add    %edx,%eax
  8001d0:	89 c2                	mov    %eax,%edx
  8001d2:	c1 e2 05             	shl    $0x5,%edx
  8001d5:	29 c2                	sub    %eax,%edx
  8001d7:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8001de:	89 c2                	mov    %eax,%edx
  8001e0:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001e6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f0:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8001f6:	84 c0                	test   %al,%al
  8001f8:	74 0f                	je     800209 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8001fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ff:	05 40 3c 01 00       	add    $0x13c40,%eax
  800204:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80020d:	7e 0a                	jle    800219 <libmain+0x72>
		binaryname = argv[0];
  80020f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800212:	8b 00                	mov    (%eax),%eax
  800214:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	ff 75 08             	pushl  0x8(%ebp)
  800222:	e8 11 fe ff ff       	call   800038 <_main>
  800227:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80022a:	e8 8e 18 00 00       	call   801abd <sys_disable_interrupt>
	cprintf("**************************************\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 e4 23 80 00       	push   $0x8023e4
  800237:	e8 52 03 00 00       	call   80058e <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80023f:	a1 20 30 80 00       	mov    0x803020,%eax
  800244:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80024a:	a1 20 30 80 00       	mov    0x803020,%eax
  80024f:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	52                   	push   %edx
  800259:	50                   	push   %eax
  80025a:	68 0c 24 80 00       	push   $0x80240c
  80025f:	e8 2a 03 00 00       	call   80058e <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800267:	a1 20 30 80 00       	mov    0x803020,%eax
  80026c:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  80027d:	83 ec 04             	sub    $0x4,%esp
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 34 24 80 00       	push   $0x802434
  800287:	e8 02 03 00 00       	call   80058e <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 20 30 80 00       	mov    0x803020,%eax
  800294:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 75 24 80 00       	push   $0x802475
  8002a3:	e8 e6 02 00 00       	call   80058e <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 e4 23 80 00       	push   $0x8023e4
  8002b3:	e8 d6 02 00 00       	call   80058e <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002bb:	e8 17 18 00 00       	call   801ad7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002c0:	e8 19 00 00 00       	call   8002de <exit>
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 00                	push   $0x0
  8002d3:	e8 16 16 00 00       	call   8018ee <sys_env_destroy>
  8002d8:	83 c4 10             	add    $0x10,%esp
}
  8002db:	90                   	nop
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <exit>:

void
exit(void)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8002e4:	e8 6b 16 00 00       	call   801954 <sys_env_exit>
}
  8002e9:	90                   	nop
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f5:	83 c0 04             	add    $0x4,%eax
  8002f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002fb:	a1 18 31 80 00       	mov    0x803118,%eax
  800300:	85 c0                	test   %eax,%eax
  800302:	74 16                	je     80031a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800304:	a1 18 31 80 00       	mov    0x803118,%eax
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	50                   	push   %eax
  80030d:	68 8c 24 80 00       	push   $0x80248c
  800312:	e8 77 02 00 00       	call   80058e <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80031a:	a1 00 30 80 00       	mov    0x803000,%eax
  80031f:	ff 75 0c             	pushl  0xc(%ebp)
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	50                   	push   %eax
  800326:	68 91 24 80 00       	push   $0x802491
  80032b:	e8 5e 02 00 00       	call   80058e <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800333:	8b 45 10             	mov    0x10(%ebp),%eax
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 f4             	pushl  -0xc(%ebp)
  80033c:	50                   	push   %eax
  80033d:	e8 e1 01 00 00       	call   800523 <vcprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	6a 00                	push   $0x0
  80034a:	68 ad 24 80 00       	push   $0x8024ad
  80034f:	e8 cf 01 00 00       	call   800523 <vcprintf>
  800354:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800357:	e8 82 ff ff ff       	call   8002de <exit>

	// should not return here
	while (1) ;
  80035c:	eb fe                	jmp    80035c <_panic+0x70>

0080035e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800364:	a1 20 30 80 00       	mov    0x803020,%eax
  800369:	8b 50 74             	mov    0x74(%eax),%edx
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	39 c2                	cmp    %eax,%edx
  800371:	74 14                	je     800387 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800373:	83 ec 04             	sub    $0x4,%esp
  800376:	68 b0 24 80 00       	push   $0x8024b0
  80037b:	6a 26                	push   $0x26
  80037d:	68 fc 24 80 00       	push   $0x8024fc
  800382:	e8 65 ff ff ff       	call   8002ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800395:	e9 b6 00 00 00       	jmp    800450 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	75 08                	jne    8003b7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003af:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b2:	e9 96 00 00 00       	jmp    80044d <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8003b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c5:	eb 5d                	jmp    800424 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d5:	c1 e2 04             	shl    $0x4,%edx
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	8a 40 04             	mov    0x4(%eax),%al
  8003dd:	84 c0                	test   %al,%al
  8003df:	75 40                	jne    800421 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ef:	c1 e2 04             	shl    $0x4,%edx
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800401:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800406:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	01 c8                	add    %ecx,%eax
  800412:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800414:	39 c2                	cmp    %eax,%edx
  800416:	75 09                	jne    800421 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800418:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80041f:	eb 12                	jmp    800433 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800421:	ff 45 e8             	incl   -0x18(%ebp)
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 50 74             	mov    0x74(%eax),%edx
  80042c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042f:	39 c2                	cmp    %eax,%edx
  800431:	77 94                	ja     8003c7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800437:	75 14                	jne    80044d <CheckWSWithoutLastIndex+0xef>
			panic(
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 08 25 80 00       	push   $0x802508
  800441:	6a 3a                	push   $0x3a
  800443:	68 fc 24 80 00       	push   $0x8024fc
  800448:	e8 9f fe ff ff       	call   8002ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80044d:	ff 45 f0             	incl   -0x10(%ebp)
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800456:	0f 8c 3e ff ff ff    	jl     80039a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80045c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800463:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80046a:	eb 20                	jmp    80048c <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80047a:	c1 e2 04             	shl    $0x4,%edx
  80047d:	01 d0                	add    %edx,%eax
  80047f:	8a 40 04             	mov    0x4(%eax),%al
  800482:	3c 01                	cmp    $0x1,%al
  800484:	75 03                	jne    800489 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800486:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800489:	ff 45 e0             	incl   -0x20(%ebp)
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 50 74             	mov    0x74(%eax),%edx
  800494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800497:	39 c2                	cmp    %eax,%edx
  800499:	77 d1                	ja     80046c <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80049b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80049e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004a1:	74 14                	je     8004b7 <CheckWSWithoutLastIndex+0x159>
		panic(
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 5c 25 80 00       	push   $0x80255c
  8004ab:	6a 44                	push   $0x44
  8004ad:	68 fc 24 80 00       	push   $0x8024fc
  8004b2:	e8 35 fe ff ff       	call   8002ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8004c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cb:	89 0a                	mov    %ecx,(%edx)
  8004cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d0:	88 d1                	mov    %dl,%cl
  8004d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004e3:	75 2c                	jne    800511 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004e5:	a0 24 30 80 00       	mov    0x803024,%al
  8004ea:	0f b6 c0             	movzbl %al,%eax
  8004ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f0:	8b 12                	mov    (%edx),%edx
  8004f2:	89 d1                	mov    %edx,%ecx
  8004f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f7:	83 c2 08             	add    $0x8,%edx
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	50                   	push   %eax
  8004fe:	51                   	push   %ecx
  8004ff:	52                   	push   %edx
  800500:	e8 a7 13 00 00       	call   8018ac <sys_cputs>
  800505:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	8b 40 04             	mov    0x4(%eax),%eax
  800517:	8d 50 01             	lea    0x1(%eax),%edx
  80051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800520:	90                   	nop
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800533:	00 00 00 
	b.cnt = 0;
  800536:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	ff 75 08             	pushl  0x8(%ebp)
  800546:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054c:	50                   	push   %eax
  80054d:	68 ba 04 80 00       	push   $0x8004ba
  800552:	e8 11 02 00 00       	call   800768 <vprintfmt>
  800557:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80055a:	a0 24 30 80 00       	mov    0x803024,%al
  80055f:	0f b6 c0             	movzbl %al,%eax
  800562:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	50                   	push   %eax
  80056c:	52                   	push   %edx
  80056d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800573:	83 c0 08             	add    $0x8,%eax
  800576:	50                   	push   %eax
  800577:	e8 30 13 00 00       	call   8018ac <sys_cputs>
  80057c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80057f:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800586:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <cprintf>:

int cprintf(const char *fmt, ...) {
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800594:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80059b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005aa:	50                   	push   %eax
  8005ab:	e8 73 ff ff ff       	call   800523 <vcprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b9:	c9                   	leave  
  8005ba:	c3                   	ret    

008005bb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c1:	e8 f7 14 00 00       	call   801abd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	e8 48 ff ff ff       	call   800523 <vcprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005e1:	e8 f1 14 00 00       	call   801ad7 <sys_enable_interrupt>
	return cnt;
  8005e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	53                   	push   %ebx
  8005ef:	83 ec 14             	sub    $0x14,%esp
  8005f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800609:	77 55                	ja     800660 <printnum+0x75>
  80060b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80060e:	72 05                	jb     800615 <printnum+0x2a>
  800610:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800613:	77 4b                	ja     800660 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800615:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	8b 45 18             	mov    0x18(%ebp),%eax
  80061e:	ba 00 00 00 00       	mov    $0x0,%edx
  800623:	52                   	push   %edx
  800624:	50                   	push   %eax
  800625:	ff 75 f4             	pushl  -0xc(%ebp)
  800628:	ff 75 f0             	pushl  -0x10(%ebp)
  80062b:	e8 64 19 00 00       	call   801f94 <__udivdi3>
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	83 ec 04             	sub    $0x4,%esp
  800636:	ff 75 20             	pushl  0x20(%ebp)
  800639:	53                   	push   %ebx
  80063a:	ff 75 18             	pushl  0x18(%ebp)
  80063d:	52                   	push   %edx
  80063e:	50                   	push   %eax
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	ff 75 08             	pushl  0x8(%ebp)
  800645:	e8 a1 ff ff ff       	call   8005eb <printnum>
  80064a:	83 c4 20             	add    $0x20,%esp
  80064d:	eb 1a                	jmp    800669 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 20             	pushl  0x20(%ebp)
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	ff d0                	call   *%eax
  80065d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800660:	ff 4d 1c             	decl   0x1c(%ebp)
  800663:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800667:	7f e6                	jg     80064f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800669:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80066c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800677:	53                   	push   %ebx
  800678:	51                   	push   %ecx
  800679:	52                   	push   %edx
  80067a:	50                   	push   %eax
  80067b:	e8 24 1a 00 00       	call   8020a4 <__umoddi3>
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	05 d4 27 80 00       	add    $0x8027d4,%eax
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f be c0             	movsbl %al,%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	ff d0                	call   *%eax
  800699:	83 c4 10             	add    $0x10,%esp
}
  80069c:	90                   	nop
  80069d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a0:	c9                   	leave  
  8006a1:	c3                   	ret    

008006a2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a9:	7e 1c                	jle    8006c7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	8d 50 08             	lea    0x8(%eax),%edx
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	89 10                	mov    %edx,(%eax)
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	83 e8 08             	sub    $0x8,%eax
  8006c0:	8b 50 04             	mov    0x4(%eax),%edx
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	eb 40                	jmp    800707 <getuint+0x65>
	else if (lflag)
  8006c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cb:	74 1e                	je     8006eb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	8d 50 04             	lea    0x4(%eax),%edx
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	89 10                	mov    %edx,(%eax)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	83 e8 04             	sub    $0x4,%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	eb 1c                	jmp    800707 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800707:	5d                   	pop    %ebp
  800708:	c3                   	ret    

00800709 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800710:	7e 1c                	jle    80072e <getint+0x25>
		return va_arg(*ap, long long);
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	8d 50 08             	lea    0x8(%eax),%edx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 10                	mov    %edx,(%eax)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	83 e8 08             	sub    $0x8,%eax
  800727:	8b 50 04             	mov    0x4(%eax),%edx
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	eb 38                	jmp    800766 <getint+0x5d>
	else if (lflag)
  80072e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800732:	74 1a                	je     80074e <getint+0x45>
		return va_arg(*ap, long);
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	8d 50 04             	lea    0x4(%eax),%edx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	89 10                	mov    %edx,(%eax)
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	83 e8 04             	sub    $0x4,%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	99                   	cltd   
  80074c:	eb 18                	jmp    800766 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 50 04             	lea    0x4(%eax),%edx
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	89 10                	mov    %edx,(%eax)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	83 e8 04             	sub    $0x4,%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	99                   	cltd   
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	56                   	push   %esi
  80076c:	53                   	push   %ebx
  80076d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800770:	eb 17                	jmp    800789 <vprintfmt+0x21>
			if (ch == '\0')
  800772:	85 db                	test   %ebx,%ebx
  800774:	0f 84 af 03 00 00    	je     800b29 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	53                   	push   %ebx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	ff d0                	call   *%eax
  800786:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800789:	8b 45 10             	mov    0x10(%ebp),%eax
  80078c:	8d 50 01             	lea    0x1(%eax),%edx
  80078f:	89 55 10             	mov    %edx,0x10(%ebp)
  800792:	8a 00                	mov    (%eax),%al
  800794:	0f b6 d8             	movzbl %al,%ebx
  800797:	83 fb 25             	cmp    $0x25,%ebx
  80079a:	75 d6                	jne    800772 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80079c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8d 50 01             	lea    0x1(%eax),%edx
  8007c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007c5:	8a 00                	mov    (%eax),%al
  8007c7:	0f b6 d8             	movzbl %al,%ebx
  8007ca:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007cd:	83 f8 55             	cmp    $0x55,%eax
  8007d0:	0f 87 2b 03 00 00    	ja     800b01 <vprintfmt+0x399>
  8007d6:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
  8007dd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007df:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007e3:	eb d7                	jmp    8007bc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007e5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e9:	eb d1                	jmp    8007bc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007f5:	89 d0                	mov    %edx,%eax
  8007f7:	c1 e0 02             	shl    $0x2,%eax
  8007fa:	01 d0                	add    %edx,%eax
  8007fc:	01 c0                	add    %eax,%eax
  8007fe:	01 d8                	add    %ebx,%eax
  800800:	83 e8 30             	sub    $0x30,%eax
  800803:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800806:	8b 45 10             	mov    0x10(%ebp),%eax
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80080e:	83 fb 2f             	cmp    $0x2f,%ebx
  800811:	7e 3e                	jle    800851 <vprintfmt+0xe9>
  800813:	83 fb 39             	cmp    $0x39,%ebx
  800816:	7f 39                	jg     800851 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800818:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80081b:	eb d5                	jmp    8007f2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 c0 04             	add    $0x4,%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	83 e8 04             	sub    $0x4,%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800831:	eb 1f                	jmp    800852 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800833:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800837:	79 83                	jns    8007bc <vprintfmt+0x54>
				width = 0;
  800839:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800840:	e9 77 ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800845:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80084c:	e9 6b ff ff ff       	jmp    8007bc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800851:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800852:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800856:	0f 89 60 ff ff ff    	jns    8007bc <vprintfmt+0x54>
				width = precision, precision = -1;
  80085c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800862:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800869:	e9 4e ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80086e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800871:	e9 46 ff ff ff       	jmp    8007bc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	ff d0                	call   *%eax
  800893:	83 c4 10             	add    $0x10,%esp
			break;
  800896:	e9 89 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 c0 04             	add    $0x4,%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	83 e8 04             	sub    $0x4,%eax
  8008aa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ac:	85 db                	test   %ebx,%ebx
  8008ae:	79 02                	jns    8008b2 <vprintfmt+0x14a>
				err = -err;
  8008b0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008b2:	83 fb 64             	cmp    $0x64,%ebx
  8008b5:	7f 0b                	jg     8008c2 <vprintfmt+0x15a>
  8008b7:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  8008be:	85 f6                	test   %esi,%esi
  8008c0:	75 19                	jne    8008db <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008c2:	53                   	push   %ebx
  8008c3:	68 e5 27 80 00       	push   $0x8027e5
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 08             	pushl  0x8(%ebp)
  8008ce:	e8 5e 02 00 00       	call   800b31 <printfmt>
  8008d3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d6:	e9 49 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008db:	56                   	push   %esi
  8008dc:	68 ee 27 80 00       	push   $0x8027ee
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	ff 75 08             	pushl  0x8(%ebp)
  8008e7:	e8 45 02 00 00       	call   800b31 <printfmt>
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 30 02 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 30                	mov    (%eax),%esi
  800905:	85 f6                	test   %esi,%esi
  800907:	75 05                	jne    80090e <vprintfmt+0x1a6>
				p = "(null)";
  800909:	be f1 27 80 00       	mov    $0x8027f1,%esi
			if (width > 0 && padc != '-')
  80090e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800912:	7e 6d                	jle    800981 <vprintfmt+0x219>
  800914:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800918:	74 67                	je     800981 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	50                   	push   %eax
  800921:	56                   	push   %esi
  800922:	e8 0c 03 00 00       	call   800c33 <strnlen>
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80092d:	eb 16                	jmp    800945 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80092f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	50                   	push   %eax
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	ff d0                	call   *%eax
  80093f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800942:	ff 4d e4             	decl   -0x1c(%ebp)
  800945:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800949:	7f e4                	jg     80092f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094b:	eb 34                	jmp    800981 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80094d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800951:	74 1c                	je     80096f <vprintfmt+0x207>
  800953:	83 fb 1f             	cmp    $0x1f,%ebx
  800956:	7e 05                	jle    80095d <vprintfmt+0x1f5>
  800958:	83 fb 7e             	cmp    $0x7e,%ebx
  80095b:	7e 12                	jle    80096f <vprintfmt+0x207>
					putch('?', putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	6a 3f                	push   $0x3f
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	eb 0f                	jmp    80097e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80097e:	ff 4d e4             	decl   -0x1c(%ebp)
  800981:	89 f0                	mov    %esi,%eax
  800983:	8d 70 01             	lea    0x1(%eax),%esi
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f be d8             	movsbl %al,%ebx
  80098b:	85 db                	test   %ebx,%ebx
  80098d:	74 24                	je     8009b3 <vprintfmt+0x24b>
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	78 b8                	js     80094d <vprintfmt+0x1e5>
  800995:	ff 4d e0             	decl   -0x20(%ebp)
  800998:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80099c:	79 af                	jns    80094d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80099e:	eb 13                	jmp    8009b3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	6a 20                	push   $0x20
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b7:	7f e7                	jg     8009a0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b9:	e9 66 01 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c7:	50                   	push   %eax
  8009c8:	e8 3c fd ff ff       	call   800709 <getint>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	79 23                	jns    800a03 <vprintfmt+0x29b>
				putch('-', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 2d                	push   $0x2d
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f6:	f7 d8                	neg    %eax
  8009f8:	83 d2 00             	adc    $0x0,%edx
  8009fb:	f7 da                	neg    %edx
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 bc 00 00 00       	jmp    800acb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 e8             	pushl  -0x18(%ebp)
  800a15:	8d 45 14             	lea    0x14(%ebp),%eax
  800a18:	50                   	push   %eax
  800a19:	e8 84 fc ff ff       	call   8006a2 <getuint>
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a27:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a2e:	e9 98 00 00 00       	jmp    800acb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 58                	push   $0x58
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 58                	push   $0x58
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 58                	push   $0x58
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 30                	push   $0x30
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	6a 78                	push   $0x78
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 e8 04             	sub    $0x4,%eax
  800a97:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aa3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aaa:	eb 1f                	jmp    800acb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab2:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	e8 e7 fb ff ff       	call   8006a2 <getuint>
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ac4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800acb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	52                   	push   %edx
  800ad6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad9:	50                   	push   %eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 00 fb ff ff       	call   8005eb <printnum>
  800aeb:	83 c4 20             	add    $0x20,%esp
			break;
  800aee:	eb 34                	jmp    800b24 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	53                   	push   %ebx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
			break;
  800aff:	eb 23                	jmp    800b24 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	6a 25                	push   $0x25
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b11:	ff 4d 10             	decl   0x10(%ebp)
  800b14:	eb 03                	jmp    800b19 <vprintfmt+0x3b1>
  800b16:	ff 4d 10             	decl   0x10(%ebp)
  800b19:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1c:	48                   	dec    %eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	3c 25                	cmp    $0x25,%al
  800b21:	75 f3                	jne    800b16 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b23:	90                   	nop
		}
	}
  800b24:	e9 47 fc ff ff       	jmp    800770 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b29:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b37:	8d 45 10             	lea    0x10(%ebp),%eax
  800b3a:	83 c0 04             	add    $0x4,%eax
  800b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	ff 75 f4             	pushl  -0xc(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	ff 75 08             	pushl  0x8(%ebp)
  800b4d:	e8 16 fc ff ff       	call   800768 <vprintfmt>
  800b52:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b55:	90                   	nop
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 08             	mov    0x8(%eax),%eax
  800b61:	8d 50 01             	lea    0x1(%eax),%edx
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 10                	mov    (%eax),%edx
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	8b 40 04             	mov    0x4(%eax),%eax
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	73 12                	jae    800b8b <sprintputch+0x33>
		*b->buf++ = ch;
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b84:	89 0a                	mov    %ecx,(%edx)
  800b86:	8b 55 08             	mov    0x8(%ebp),%edx
  800b89:	88 10                	mov    %dl,(%eax)
}
  800b8b:	90                   	nop
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	01 d0                	add    %edx,%eax
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800baf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bb3:	74 06                	je     800bbb <vsnprintf+0x2d>
  800bb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb9:	7f 07                	jg     800bc2 <vsnprintf+0x34>
		return -E_INVAL;
  800bbb:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc0:	eb 20                	jmp    800be2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bc2:	ff 75 14             	pushl  0x14(%ebp)
  800bc5:	ff 75 10             	pushl  0x10(%ebp)
  800bc8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bcb:	50                   	push   %eax
  800bcc:	68 58 0b 80 00       	push   $0x800b58
  800bd1:	e8 92 fb ff ff       	call   800768 <vprintfmt>
  800bd6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bea:	8d 45 10             	lea    0x10(%ebp),%eax
  800bed:	83 c0 04             	add    $0x4,%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf9:	50                   	push   %eax
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 89 ff ff ff       	call   800b8e <vsnprintf>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1d:	eb 06                	jmp    800c25 <strlen+0x15>
		n++;
  800c1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c22:	ff 45 08             	incl   0x8(%ebp)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	84 c0                	test   %al,%al
  800c2c:	75 f1                	jne    800c1f <strlen+0xf>
		n++;
	return n;
  800c2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c31:	c9                   	leave  
  800c32:	c3                   	ret    

00800c33 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c40:	eb 09                	jmp    800c4b <strnlen+0x18>
		n++;
  800c42:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c45:	ff 45 08             	incl   0x8(%ebp)
  800c48:	ff 4d 0c             	decl   0xc(%ebp)
  800c4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4f:	74 09                	je     800c5a <strnlen+0x27>
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	84 c0                	test   %al,%al
  800c58:	75 e8                	jne    800c42 <strnlen+0xf>
		n++;
	return n;
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c6b:	90                   	nop
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8d 50 01             	lea    0x1(%eax),%edx
  800c72:	89 55 08             	mov    %edx,0x8(%ebp)
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c7e:	8a 12                	mov    (%edx),%dl
  800c80:	88 10                	mov    %dl,(%eax)
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	84 c0                	test   %al,%al
  800c86:	75 e4                	jne    800c6c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca0:	eb 1f                	jmp    800cc1 <strncpy+0x34>
		*dst++ = *src;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8d 50 01             	lea    0x1(%eax),%edx
  800ca8:	89 55 08             	mov    %edx,0x8(%ebp)
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	8a 12                	mov    (%edx),%dl
  800cb0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	84 c0                	test   %al,%al
  800cb9:	74 03                	je     800cbe <strncpy+0x31>
			src++;
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cbe:	ff 45 fc             	incl   -0x4(%ebp)
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cc7:	72 d9                	jb     800ca2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cde:	74 30                	je     800d10 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ce0:	eb 16                	jmp    800cf8 <strlcpy+0x2a>
			*dst++ = *src++;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8d 50 01             	lea    0x1(%eax),%edx
  800ce8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf4:	8a 12                	mov    (%edx),%dl
  800cf6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf8:	ff 4d 10             	decl   0x10(%ebp)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 09                	je     800d0a <strlcpy+0x3c>
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	75 d8                	jne    800ce2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d16:	29 c2                	sub    %eax,%edx
  800d18:	89 d0                	mov    %edx,%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d1f:	eb 06                	jmp    800d27 <strcmp+0xb>
		p++, q++;
  800d21:	ff 45 08             	incl   0x8(%ebp)
  800d24:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	84 c0                	test   %al,%al
  800d2e:	74 0e                	je     800d3e <strcmp+0x22>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 10                	mov    (%eax),%dl
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	38 c2                	cmp    %al,%dl
  800d3c:	74 e3                	je     800d21 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	0f b6 d0             	movzbl %al,%edx
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f b6 c0             	movzbl %al,%eax
  800d4e:	29 c2                	sub    %eax,%edx
  800d50:	89 d0                	mov    %edx,%eax
}
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d57:	eb 09                	jmp    800d62 <strncmp+0xe>
		n--, p++, q++;
  800d59:	ff 4d 10             	decl   0x10(%ebp)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	74 17                	je     800d7f <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 0e                	je     800d7f <strncmp+0x2b>
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	38 c2                	cmp    %al,%dl
  800d7d:	74 da                	je     800d59 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	75 07                	jne    800d8c <strncmp+0x38>
		return 0;
  800d85:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8a:	eb 14                	jmp    800da0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 04             	sub    $0x4,%esp
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dae:	eb 12                	jmp    800dc2 <strchr+0x20>
		if (*s == c)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db8:	75 05                	jne    800dbf <strchr+0x1d>
			return (char *) s;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	eb 11                	jmp    800dd0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e5                	jne    800db0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 04             	sub    $0x4,%esp
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dde:	eb 0d                	jmp    800ded <strfind+0x1b>
		if (*s == c)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800de8:	74 0e                	je     800df8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dea:	ff 45 08             	incl   0x8(%ebp)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	84 c0                	test   %al,%al
  800df4:	75 ea                	jne    800de0 <strfind+0xe>
  800df6:	eb 01                	jmp    800df9 <strfind+0x27>
		if (*s == c)
			break;
  800df8:	90                   	nop
	return (char *) s;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e10:	eb 0e                	jmp    800e20 <memset+0x22>
		*p++ = c;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	8d 50 01             	lea    0x1(%eax),%edx
  800e18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e27:	79 e9                	jns    800e12 <memset+0x14>
		*p++ = c;

	return v;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e40:	eb 16                	jmp    800e58 <memcpy+0x2a>
		*d++ = *s++;
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e51:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e54:	8a 12                	mov    (%edx),%dl
  800e56:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	75 dd                	jne    800e42 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e82:	73 50                	jae    800ed4 <memmove+0x6a>
  800e84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e8f:	76 43                	jbe    800ed4 <memmove+0x6a>
		s += n;
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e9d:	eb 10                	jmp    800eaf <memmove+0x45>
			*--d = *--s;
  800e9f:	ff 4d f8             	decl   -0x8(%ebp)
  800ea2:	ff 4d fc             	decl   -0x4(%ebp)
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 10                	mov    (%eax),%dl
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ead:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	75 e3                	jne    800e9f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ebc:	eb 23                	jmp    800ee1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ecd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ed0:	8a 12                	mov    (%edx),%dl
  800ed2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eda:	89 55 10             	mov    %edx,0x10(%ebp)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	75 dd                	jne    800ebe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ef8:	eb 2a                	jmp    800f24 <memcmp+0x3e>
		if (*s1 != *s2)
  800efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efd:	8a 10                	mov    (%eax),%dl
  800eff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	38 c2                	cmp    %al,%dl
  800f06:	74 16                	je     800f1e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f b6 d0             	movzbl %al,%edx
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f b6 c0             	movzbl %al,%eax
  800f18:	29 c2                	sub    %eax,%edx
  800f1a:	89 d0                	mov    %edx,%eax
  800f1c:	eb 18                	jmp    800f36 <memcmp+0x50>
		s1++, s2++;
  800f1e:	ff 45 fc             	incl   -0x4(%ebp)
  800f21:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	75 c9                	jne    800efa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f49:	eb 15                	jmp    800f60 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	0f b6 c0             	movzbl %al,%eax
  800f59:	39 c2                	cmp    %eax,%edx
  800f5b:	74 0d                	je     800f6a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f5d:	ff 45 08             	incl   0x8(%ebp)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f66:	72 e3                	jb     800f4b <memfind+0x13>
  800f68:	eb 01                	jmp    800f6b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f6a:	90                   	nop
	return (void *) s;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6e:	c9                   	leave  
  800f6f:	c3                   	ret    

00800f70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f84:	eb 03                	jmp    800f89 <strtol+0x19>
		s++;
  800f86:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 20                	cmp    $0x20,%al
  800f90:	74 f4                	je     800f86 <strtol+0x16>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 09                	cmp    $0x9,%al
  800f99:	74 eb                	je     800f86 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 2b                	cmp    $0x2b,%al
  800fa2:	75 05                	jne    800fa9 <strtol+0x39>
		s++;
  800fa4:	ff 45 08             	incl   0x8(%ebp)
  800fa7:	eb 13                	jmp    800fbc <strtol+0x4c>
	else if (*s == '-')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 2d                	cmp    $0x2d,%al
  800fb0:	75 0a                	jne    800fbc <strtol+0x4c>
		s++, neg = 1;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc0:	74 06                	je     800fc8 <strtol+0x58>
  800fc2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fc6:	75 20                	jne    800fe8 <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 30                	cmp    $0x30,%al
  800fcf:	75 17                	jne    800fe8 <strtol+0x78>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	40                   	inc    %eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 78                	cmp    $0x78,%al
  800fd9:	75 0d                	jne    800fe8 <strtol+0x78>
		s += 2, base = 16;
  800fdb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fdf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fe6:	eb 28                	jmp    801010 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fec:	75 15                	jne    801003 <strtol+0x93>
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 30                	cmp    $0x30,%al
  800ff5:	75 0c                	jne    801003 <strtol+0x93>
		s++, base = 8;
  800ff7:	ff 45 08             	incl   0x8(%ebp)
  800ffa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801001:	eb 0d                	jmp    801010 <strtol+0xa0>
	else if (base == 0)
  801003:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801007:	75 07                	jne    801010 <strtol+0xa0>
		base = 10;
  801009:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 2f                	cmp    $0x2f,%al
  801017:	7e 19                	jle    801032 <strtol+0xc2>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 39                	cmp    $0x39,%al
  801020:	7f 10                	jg     801032 <strtol+0xc2>
			dig = *s - '0';
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	83 e8 30             	sub    $0x30,%eax
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801030:	eb 42                	jmp    801074 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 60                	cmp    $0x60,%al
  801039:	7e 19                	jle    801054 <strtol+0xe4>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 7a                	cmp    $0x7a,%al
  801042:	7f 10                	jg     801054 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	0f be c0             	movsbl %al,%eax
  80104c:	83 e8 57             	sub    $0x57,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801052:	eb 20                	jmp    801074 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 40                	cmp    $0x40,%al
  80105b:	7e 39                	jle    801096 <strtol+0x126>
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 5a                	cmp    $0x5a,%al
  801064:	7f 30                	jg     801096 <strtol+0x126>
			dig = *s - 'A' + 10;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	0f be c0             	movsbl %al,%eax
  80106e:	83 e8 37             	sub    $0x37,%eax
  801071:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801077:	3b 45 10             	cmp    0x10(%ebp),%eax
  80107a:	7d 19                	jge    801095 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80107c:	ff 45 08             	incl   0x8(%ebp)
  80107f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801082:	0f af 45 10          	imul   0x10(%ebp),%eax
  801086:	89 c2                	mov    %eax,%edx
  801088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801090:	e9 7b ff ff ff       	jmp    801010 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801095:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801096:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109a:	74 08                	je     8010a4 <strtol+0x134>
		*endptr = (char *) s;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010a8:	74 07                	je     8010b1 <strtol+0x141>
  8010aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ad:	f7 d8                	neg    %eax
  8010af:	eb 03                	jmp    8010b4 <strtol+0x144>
  8010b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <ltostr>:

void
ltostr(long value, char *str)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ce:	79 13                	jns    8010e3 <ltostr+0x2d>
	{
		neg = 1;
  8010d0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010dd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010eb:	99                   	cltd   
  8010ec:	f7 f9                	idiv   %ecx
  8010ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8d 50 01             	lea    0x1(%eax),%edx
  8010f7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fa:	89 c2                	mov    %eax,%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801104:	83 c2 30             	add    $0x30,%edx
  801107:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801109:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801111:	f7 e9                	imul   %ecx
  801113:	c1 fa 02             	sar    $0x2,%edx
  801116:	89 c8                	mov    %ecx,%eax
  801118:	c1 f8 1f             	sar    $0x1f,%eax
  80111b:	29 c2                	sub    %eax,%edx
  80111d:	89 d0                	mov    %edx,%eax
  80111f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801125:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80112a:	f7 e9                	imul   %ecx
  80112c:	c1 fa 02             	sar    $0x2,%edx
  80112f:	89 c8                	mov    %ecx,%eax
  801131:	c1 f8 1f             	sar    $0x1f,%eax
  801134:	29 c2                	sub    %eax,%edx
  801136:	89 d0                	mov    %edx,%eax
  801138:	c1 e0 02             	shl    $0x2,%eax
  80113b:	01 d0                	add    %edx,%eax
  80113d:	01 c0                	add    %eax,%eax
  80113f:	29 c1                	sub    %eax,%ecx
  801141:	89 ca                	mov    %ecx,%edx
  801143:	85 d2                	test   %edx,%edx
  801145:	75 9c                	jne    8010e3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	48                   	dec    %eax
  801152:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801159:	74 3d                	je     801198 <ltostr+0xe2>
		start = 1 ;
  80115b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801162:	eb 34                	jmp    801198 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	01 d0                	add    %edx,%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	01 c2                	add    %eax,%edx
  801179:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c8                	add    %ecx,%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801185:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801190:	88 02                	mov    %al,(%edx)
		start++ ;
  801192:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801195:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119e:	7c c4                	jl     801164 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ab:	90                   	nop
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 54 fa ff ff       	call   800c10 <strlen>
  8011bc:	83 c4 04             	add    $0x4,%esp
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	e8 46 fa ff ff       	call   800c10 <strlen>
  8011ca:	83 c4 04             	add    $0x4,%esp
  8011cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011de:	eb 17                	jmp    8011f7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	01 c8                	add    %ecx,%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011f4:	ff 45 fc             	incl   -0x4(%ebp)
  8011f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011fd:	7c e1                	jl     8011e0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80120d:	eb 1f                	jmp    80122e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8d 50 01             	lea    0x1(%eax),%edx
  801215:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801218:	89 c2                	mov    %eax,%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 c2                	add    %eax,%edx
  80121f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 c8                	add    %ecx,%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80122b:	ff 45 f8             	incl   -0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801234:	7c d9                	jl     80120f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801236:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801239:	8b 45 10             	mov    0x10(%ebp),%eax
  80123c:	01 d0                	add    %edx,%eax
  80123e:	c6 00 00             	movb   $0x0,(%eax)
}
  801241:	90                   	nop
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801250:	8b 45 14             	mov    0x14(%ebp),%eax
  801253:	8b 00                	mov    (%eax),%eax
  801255:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125c:	8b 45 10             	mov    0x10(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801267:	eb 0c                	jmp    801275 <strsplit+0x31>
			*string++ = 0;
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8d 50 01             	lea    0x1(%eax),%edx
  80126f:	89 55 08             	mov    %edx,0x8(%ebp)
  801272:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	84 c0                	test   %al,%al
  80127c:	74 18                	je     801296 <strsplit+0x52>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	50                   	push   %eax
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	e8 13 fb ff ff       	call   800da2 <strchr>
  80128f:	83 c4 08             	add    $0x8,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	75 d3                	jne    801269 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	74 5a                	je     8012f9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	83 f8 0f             	cmp    $0xf,%eax
  8012a7:	75 07                	jne    8012b0 <strsplit+0x6c>
		{
			return 0;
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	eb 66                	jmp    801316 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8012b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8012bb:	89 0a                	mov    %ecx,(%edx)
  8012bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ce:	eb 03                	jmp    8012d3 <strsplit+0x8f>
			string++;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	84 c0                	test   %al,%al
  8012da:	74 8b                	je     801267 <strsplit+0x23>
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	50                   	push   %eax
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	e8 b5 fa ff ff       	call   800da2 <strchr>
  8012ed:	83 c4 08             	add    $0x8,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	74 dc                	je     8012d0 <strsplit+0x8c>
			string++;
	}
  8012f4:	e9 6e ff ff ff       	jmp    801267 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801311:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  80131e:	a1 28 30 80 00       	mov    0x803028,%eax
  801323:	85 c0                	test   %eax,%eax
  801325:	75 33                	jne    80135a <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801327:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  80132e:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801331:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801338:	00 00 a0 
		spaces[0].pages = numPages;
  80133b:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801342:	00 02 00 
		spaces[0].isFree = 1;
  801345:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  80134c:	00 00 00 
		arraySize++;
  80134f:	a1 28 30 80 00       	mov    0x803028,%eax
  801354:	40                   	inc    %eax
  801355:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  80135a:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801361:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801368:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80136f:	8b 55 08             	mov    0x8(%ebp),%edx
  801372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	48                   	dec    %eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137e:	ba 00 00 00 00       	mov    $0x0,%edx
  801383:	f7 75 e8             	divl   -0x18(%ebp)
  801386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801389:	29 d0                	sub    %edx,%eax
  80138b:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	c1 e8 0c             	shr    $0xc,%eax
  801394:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801397:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80139e:	eb 57                	jmp    8013f7 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8013a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a3:	c1 e0 04             	shl    $0x4,%eax
  8013a6:	05 2c 31 80 00       	add    $0x80312c,%eax
  8013ab:	8b 00                	mov    (%eax),%eax
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	74 42                	je     8013f3 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8013b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b4:	c1 e0 04             	shl    $0x4,%eax
  8013b7:	05 28 31 80 00       	add    $0x803128,%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8013c1:	7c 31                	jl     8013f4 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8013c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c6:	c1 e0 04             	shl    $0x4,%eax
  8013c9:	05 28 31 80 00       	add    $0x803128,%eax
  8013ce:	8b 00                	mov    (%eax),%eax
  8013d0:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8013d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013d6:	7d 1c                	jge    8013f4 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  8013d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013db:	c1 e0 04             	shl    $0x4,%eax
  8013de:	05 28 31 80 00       	add    $0x803128,%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8013e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8013eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f1:	eb 01                	jmp    8013f4 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8013f3:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8013f4:	ff 45 ec             	incl   -0x14(%ebp)
  8013f7:	a1 28 30 80 00       	mov    0x803028,%eax
  8013fc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8013ff:	7c 9f                	jl     8013a0 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801401:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801405:	75 0a                	jne    801411 <malloc+0xf9>
	{
		return NULL;
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
  80140c:	e9 34 01 00 00       	jmp    801545 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	c1 e0 04             	shl    $0x4,%eax
  801417:	05 28 31 80 00       	add    $0x803128,%eax
  80141c:	8b 00                	mov    (%eax),%eax
  80141e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801421:	75 38                	jne    80145b <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801426:	c1 e0 04             	shl    $0x4,%eax
  801429:	05 2c 31 80 00       	add    $0x80312c,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801434:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801437:	c1 e0 0c             	shl    $0xc,%eax
  80143a:	89 c2                	mov    %eax,%edx
  80143c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143f:	c1 e0 04             	shl    $0x4,%eax
  801442:	05 20 31 80 00       	add    $0x803120,%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	52                   	push   %edx
  80144d:	50                   	push   %eax
  80144e:	e8 01 06 00 00       	call   801a54 <sys_allocateMem>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	e9 dd 00 00 00       	jmp    801538 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  80145b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145e:	c1 e0 04             	shl    $0x4,%eax
  801461:	05 20 31 80 00       	add    $0x803120,%eax
  801466:	8b 00                	mov    (%eax),%eax
  801468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80146b:	c1 e2 0c             	shl    $0xc,%edx
  80146e:	01 d0                	add    %edx,%eax
  801470:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801473:	a1 28 30 80 00       	mov    0x803028,%eax
  801478:	c1 e0 04             	shl    $0x4,%eax
  80147b:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  801481:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801484:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801486:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148f:	c1 e0 04             	shl    $0x4,%eax
  801492:	05 24 31 80 00       	add    $0x803124,%eax
  801497:	8b 00                	mov    (%eax),%eax
  801499:	c1 e2 04             	shl    $0x4,%edx
  80149c:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8014a2:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8014a4:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	c1 e0 04             	shl    $0x4,%eax
  8014b0:	05 28 31 80 00       	add    $0x803128,%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8014ba:	c1 e2 04             	shl    $0x4,%edx
  8014bd:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8014c3:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  8014c5:	a1 28 30 80 00       	mov    0x803028,%eax
  8014ca:	c1 e0 04             	shl    $0x4,%eax
  8014cd:	05 2c 31 80 00       	add    $0x80312c,%eax
  8014d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  8014d8:	a1 28 30 80 00       	mov    0x803028,%eax
  8014dd:	40                   	inc    %eax
  8014de:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8014e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e6:	c1 e0 04             	shl    $0x4,%eax
  8014e9:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8014ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f2:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8014f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f7:	c1 e0 04             	shl    $0x4,%eax
  8014fa:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  801500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801503:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	c1 e0 04             	shl    $0x4,%eax
  80150b:	05 2c 31 80 00       	add    $0x80312c,%eax
  801510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801519:	c1 e0 0c             	shl    $0xc,%eax
  80151c:	89 c2                	mov    %eax,%edx
  80151e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801521:	c1 e0 04             	shl    $0x4,%eax
  801524:	05 20 31 80 00       	add    $0x803120,%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	52                   	push   %edx
  80152f:	50                   	push   %eax
  801530:	e8 1f 05 00 00       	call   801a54 <sys_allocateMem>
  801535:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	c1 e0 04             	shl    $0x4,%eax
  80153e:	05 20 31 80 00       	add    $0x803120,%eax
  801543:	8b 00                	mov    (%eax),%eax
	}


}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  80154d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801554:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  80155b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801562:	eb 3f                	jmp    8015a3 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801567:	c1 e0 04             	shl    $0x4,%eax
  80156a:	05 20 31 80 00       	add    $0x803120,%eax
  80156f:	8b 00                	mov    (%eax),%eax
  801571:	3b 45 08             	cmp    0x8(%ebp),%eax
  801574:	75 2a                	jne    8015a0 <free+0x59>
		{
			index=i;
  801576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801579:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  80157c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157f:	c1 e0 04             	shl    $0x4,%eax
  801582:	05 28 31 80 00       	add    $0x803128,%eax
  801587:	8b 00                	mov    (%eax),%eax
  801589:	c1 e0 0c             	shl    $0xc,%eax
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	52                   	push   %edx
  801595:	50                   	push   %eax
  801596:	e8 9d 04 00 00       	call   801a38 <sys_freeMem>
  80159b:	83 c4 10             	add    $0x10,%esp
			break;
  80159e:	eb 0d                	jmp    8015ad <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8015a0:	ff 45 ec             	incl   -0x14(%ebp)
  8015a3:	a1 28 30 80 00       	mov    0x803028,%eax
  8015a8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8015ab:	7c b7                	jl     801564 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8015ad:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8015b1:	75 17                	jne    8015ca <free+0x83>
	{
		panic("Error");
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	68 50 29 80 00       	push   $0x802950
  8015bb:	68 81 00 00 00       	push   $0x81
  8015c0:	68 56 29 80 00       	push   $0x802956
  8015c5:	e8 22 ed ff ff       	call   8002ec <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  8015ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015d1:	e9 cc 00 00 00       	jmp    8016a2 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  8015d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d9:	c1 e0 04             	shl    $0x4,%eax
  8015dc:	05 2c 31 80 00       	add    $0x80312c,%eax
  8015e1:	8b 00                	mov    (%eax),%eax
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	0f 84 b3 00 00 00    	je     80169e <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8015eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ee:	c1 e0 04             	shl    $0x4,%eax
  8015f1:	05 20 31 80 00       	add    $0x803120,%eax
  8015f6:	8b 10                	mov    (%eax),%edx
  8015f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015fb:	c1 e0 04             	shl    $0x4,%eax
  8015fe:	05 24 31 80 00       	add    $0x803124,%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	0f 85 92 00 00 00    	jne    80169f <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	c1 e0 04             	shl    $0x4,%eax
  801613:	05 24 31 80 00       	add    $0x803124,%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80161d:	c1 e2 04             	shl    $0x4,%edx
  801620:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801626:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162b:	c1 e0 04             	shl    $0x4,%eax
  80162e:	05 28 31 80 00       	add    $0x803128,%eax
  801633:	8b 10                	mov    (%eax),%edx
  801635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801638:	c1 e0 04             	shl    $0x4,%eax
  80163b:	05 28 31 80 00       	add    $0x803128,%eax
  801640:	8b 00                	mov    (%eax),%eax
  801642:	01 c2                	add    %eax,%edx
  801644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801647:	c1 e0 04             	shl    $0x4,%eax
  80164a:	05 28 31 80 00       	add    $0x803128,%eax
  80164f:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	c1 e0 04             	shl    $0x4,%eax
  801657:	05 20 31 80 00       	add    $0x803120,%eax
  80165c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801665:	c1 e0 04             	shl    $0x4,%eax
  801668:	05 24 31 80 00       	add    $0x803124,%eax
  80166d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801676:	c1 e0 04             	shl    $0x4,%eax
  801679:	05 28 31 80 00       	add    $0x803128,%eax
  80167e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	c1 e0 04             	shl    $0x4,%eax
  80168a:	05 2c 31 80 00       	add    $0x80312c,%eax
  80168f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801695:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  80169c:	eb 12                	jmp    8016b0 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80169e:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  80169f:	ff 45 e8             	incl   -0x18(%ebp)
  8016a2:	a1 28 30 80 00       	mov    0x803028,%eax
  8016a7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8016aa:	0f 8c 26 ff ff ff    	jl     8015d6 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8016b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016b7:	e9 cc 00 00 00       	jmp    801788 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  8016bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016bf:	c1 e0 04             	shl    $0x4,%eax
  8016c2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016c7:	8b 00                	mov    (%eax),%eax
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	0f 84 b3 00 00 00    	je     801784 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  8016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d4:	c1 e0 04             	shl    $0x4,%eax
  8016d7:	05 24 31 80 00       	add    $0x803124,%eax
  8016dc:	8b 10                	mov    (%eax),%edx
  8016de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e1:	c1 e0 04             	shl    $0x4,%eax
  8016e4:	05 20 31 80 00       	add    $0x803120,%eax
  8016e9:	8b 00                	mov    (%eax),%eax
  8016eb:	39 c2                	cmp    %eax,%edx
  8016ed:	0f 85 92 00 00 00    	jne    801785 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	c1 e0 04             	shl    $0x4,%eax
  8016f9:	05 20 31 80 00       	add    $0x803120,%eax
  8016fe:	8b 00                	mov    (%eax),%eax
  801700:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801703:	c1 e2 04             	shl    $0x4,%edx
  801706:	81 c2 20 31 80 00    	add    $0x803120,%edx
  80170c:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  80170e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801711:	c1 e0 04             	shl    $0x4,%eax
  801714:	05 28 31 80 00       	add    $0x803128,%eax
  801719:	8b 10                	mov    (%eax),%edx
  80171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171e:	c1 e0 04             	shl    $0x4,%eax
  801721:	05 28 31 80 00       	add    $0x803128,%eax
  801726:	8b 00                	mov    (%eax),%eax
  801728:	01 c2                	add    %eax,%edx
  80172a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172d:	c1 e0 04             	shl    $0x4,%eax
  801730:	05 28 31 80 00       	add    $0x803128,%eax
  801735:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173a:	c1 e0 04             	shl    $0x4,%eax
  80173d:	05 20 31 80 00       	add    $0x803120,%eax
  801742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174b:	c1 e0 04             	shl    $0x4,%eax
  80174e:	05 24 31 80 00       	add    $0x803124,%eax
  801753:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	c1 e0 04             	shl    $0x4,%eax
  80175f:	05 28 31 80 00       	add    $0x803128,%eax
  801764:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176d:	c1 e0 04             	shl    $0x4,%eax
  801770:	05 2c 31 80 00       	add    $0x80312c,%eax
  801775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80177b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801782:	eb 12                	jmp    801796 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801784:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801785:	ff 45 e4             	incl   -0x1c(%ebp)
  801788:	a1 28 30 80 00       	mov    0x803028,%eax
  80178d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801790:	0f 8c 26 ff ff ff    	jl     8016bc <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801796:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80179a:	75 11                	jne    8017ad <free+0x266>
	{
		spaces[index].isFree = 1;
  80179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179f:	c1 e0 04             	shl    $0x4,%eax
  8017a2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  8017ad:	90                   	nop
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 18             	sub    $0x18,%esp
  8017b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b9:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	68 64 29 80 00       	push   $0x802964
  8017c4:	68 b9 00 00 00       	push   $0xb9
  8017c9:	68 56 29 80 00       	push   $0x802956
  8017ce:	e8 19 eb ff ff       	call   8002ec <_panic>

008017d3 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	68 64 29 80 00       	push   $0x802964
  8017e1:	68 bf 00 00 00       	push   $0xbf
  8017e6:	68 56 29 80 00       	push   $0x802956
  8017eb:	e8 fc ea ff ff       	call   8002ec <_panic>

008017f0 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	68 64 29 80 00       	push   $0x802964
  8017fe:	68 c5 00 00 00       	push   $0xc5
  801803:	68 56 29 80 00       	push   $0x802956
  801808:	e8 df ea ff ff       	call   8002ec <_panic>

0080180d <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	68 64 29 80 00       	push   $0x802964
  80181b:	68 ca 00 00 00       	push   $0xca
  801820:	68 56 29 80 00       	push   $0x802956
  801825:	e8 c2 ea ff ff       	call   8002ec <_panic>

0080182a <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 64 29 80 00       	push   $0x802964
  801838:	68 d0 00 00 00       	push   $0xd0
  80183d:	68 56 29 80 00       	push   $0x802956
  801842:	e8 a5 ea ff ff       	call   8002ec <_panic>

00801847 <shrink>:
}
void shrink(uint32 newSize)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	68 64 29 80 00       	push   $0x802964
  801855:	68 d4 00 00 00       	push   $0xd4
  80185a:	68 56 29 80 00       	push   $0x802956
  80185f:	e8 88 ea ff ff       	call   8002ec <_panic>

00801864 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 64 29 80 00       	push   $0x802964
  801872:	68 d9 00 00 00       	push   $0xd9
  801877:	68 56 29 80 00       	push   $0x802956
  80187c:	e8 6b ea ff ff       	call   8002ec <_panic>

00801881 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	57                   	push   %edi
  801885:	56                   	push   %esi
  801886:	53                   	push   %ebx
  801887:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801890:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801893:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801896:	8b 7d 18             	mov    0x18(%ebp),%edi
  801899:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80189c:	cd 30                	int    $0x30
  80189e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5e                   	pop    %esi
  8018a9:	5f                   	pop    %edi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	52                   	push   %edx
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	50                   	push   %eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	e8 b2 ff ff ff       	call   801881 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 01                	push   $0x1
  8018e4:	e8 98 ff ff ff       	call   801881 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	50                   	push   %eax
  8018fd:	6a 05                	push   $0x5
  8018ff:	e8 7d ff ff ff       	call   801881 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 02                	push   $0x2
  801918:	e8 64 ff ff ff       	call   801881 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 03                	push   $0x3
  801931:	e8 4b ff ff ff       	call   801881 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 04                	push   $0x4
  80194a:	e8 32 ff ff ff       	call   801881 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_env_exit>:


void sys_env_exit(void)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 06                	push   $0x6
  801963:	e8 19 ff ff ff       	call   801881 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	52                   	push   %edx
  80197e:	50                   	push   %eax
  80197f:	6a 07                	push   $0x7
  801981:	e8 fb fe ff ff       	call   801881 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801990:	8b 75 18             	mov    0x18(%ebp),%esi
  801993:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801996:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	56                   	push   %esi
  8019a0:	53                   	push   %ebx
  8019a1:	51                   	push   %ecx
  8019a2:	52                   	push   %edx
  8019a3:	50                   	push   %eax
  8019a4:	6a 08                	push   $0x8
  8019a6:	e8 d6 fe ff ff       	call   801881 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	6a 09                	push   $0x9
  8019c8:	e8 b4 fe ff ff       	call   801881 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 0a                	push   $0xa
  8019e3:	e8 99 fe ff ff       	call   801881 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 0b                	push   $0xb
  8019fc:	e8 80 fe ff ff       	call   801881 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 0c                	push   $0xc
  801a15:	e8 67 fe ff ff       	call   801881 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 0d                	push   $0xd
  801a2e:	e8 4e fe ff ff       	call   801881 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	6a 11                	push   $0x11
  801a49:	e8 33 fe ff ff       	call   801881 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
	return;
  801a51:	90                   	nop
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	6a 12                	push   $0x12
  801a65:	e8 17 fe ff ff       	call   801881 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6d:	90                   	nop
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 0e                	push   $0xe
  801a7f:	e8 fd fd ff ff       	call   801881 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	6a 0f                	push   $0xf
  801a99:	e8 e3 fd ff ff       	call   801881 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 10                	push   $0x10
  801ab2:	e8 ca fd ff ff       	call   801881 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 14                	push   $0x14
  801acc:	e8 b0 fd ff ff       	call   801881 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 15                	push   $0x15
  801ae6:	e8 96 fd ff ff       	call   801881 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801afd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	50                   	push   %eax
  801b0a:	6a 16                	push   $0x16
  801b0c:	e8 70 fd ff ff       	call   801881 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 17                	push   $0x17
  801b26:	e8 56 fd ff ff       	call   801881 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	50                   	push   %eax
  801b41:	6a 18                	push   $0x18
  801b43:	e8 39 fd ff ff       	call   801881 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	52                   	push   %edx
  801b5d:	50                   	push   %eax
  801b5e:	6a 1b                	push   $0x1b
  801b60:	e8 1c fd ff ff       	call   801881 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 19                	push   $0x19
  801b7d:	e8 ff fc ff ff       	call   801881 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 1a                	push   $0x1a
  801b9b:	e8 e1 fc ff ff       	call   801881 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	8b 45 10             	mov    0x10(%ebp),%eax
  801baf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	51                   	push   %ecx
  801bbf:	52                   	push   %edx
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	50                   	push   %eax
  801bc4:	6a 1c                	push   $0x1c
  801bc6:	e8 b6 fc ff ff       	call   801881 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	6a 1d                	push   $0x1d
  801be3:	e8 99 fc ff ff       	call   801881 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	51                   	push   %ecx
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	6a 1e                	push   $0x1e
  801c02:	e8 7a fc ff ff       	call   801881 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	52                   	push   %edx
  801c1c:	50                   	push   %eax
  801c1d:	6a 1f                	push   $0x1f
  801c1f:	e8 5d fc ff ff       	call   801881 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 20                	push   $0x20
  801c38:	e8 44 fc ff ff       	call   801881 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	ff 75 14             	pushl  0x14(%ebp)
  801c4d:	ff 75 10             	pushl  0x10(%ebp)
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	50                   	push   %eax
  801c54:	6a 21                	push   $0x21
  801c56:	e8 26 fc ff ff       	call   801881 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	50                   	push   %eax
  801c6f:	6a 22                	push   $0x22
  801c71:	e8 0b fc ff ff       	call   801881 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	90                   	nop
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	50                   	push   %eax
  801c8b:	6a 23                	push   $0x23
  801c8d:	e8 ef fb ff ff       	call   801881 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	90                   	nop
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c9e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca1:	8d 50 04             	lea    0x4(%eax),%edx
  801ca4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	52                   	push   %edx
  801cae:	50                   	push   %eax
  801caf:	6a 24                	push   $0x24
  801cb1:	e8 cb fb ff ff       	call   801881 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cbf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc2:	89 01                	mov    %eax,(%ecx)
  801cc4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	c9                   	leave  
  801ccb:	c2 04 00             	ret    $0x4

00801cce <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 10             	pushl  0x10(%ebp)
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	ff 75 08             	pushl  0x8(%ebp)
  801cde:	6a 13                	push   $0x13
  801ce0:	e8 9c fb ff ff       	call   801881 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce8:	90                   	nop
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_rcr2>:
uint32 sys_rcr2()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 25                	push   $0x25
  801cfa:	e8 82 fb ff ff       	call   801881 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d10:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	50                   	push   %eax
  801d1d:	6a 26                	push   $0x26
  801d1f:	e8 5d fb ff ff       	call   801881 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <rsttst>:
void rsttst()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 28                	push   $0x28
  801d39:	e8 43 fb ff ff       	call   801881 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d41:	90                   	nop
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d50:	8b 55 18             	mov    0x18(%ebp),%edx
  801d53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d57:	52                   	push   %edx
  801d58:	50                   	push   %eax
  801d59:	ff 75 10             	pushl  0x10(%ebp)
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	6a 27                	push   $0x27
  801d64:	e8 18 fb ff ff       	call   801881 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6c:	90                   	nop
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <chktst>:
void chktst(uint32 n)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	ff 75 08             	pushl  0x8(%ebp)
  801d7d:	6a 29                	push   $0x29
  801d7f:	e8 fd fa ff ff       	call   801881 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <inctst>:

void inctst()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 2a                	push   $0x2a
  801d99:	e8 e3 fa ff ff       	call   801881 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <gettst>:
uint32 gettst()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 2b                	push   $0x2b
  801db3:	e8 c9 fa ff ff       	call   801881 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 2c                	push   $0x2c
  801dcf:	e8 ad fa ff ff       	call   801881 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dda:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dde:	75 07                	jne    801de7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de0:	b8 01 00 00 00       	mov    $0x1,%eax
  801de5:	eb 05                	jmp    801dec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 2c                	push   $0x2c
  801e00:	e8 7c fa ff ff       	call   801881 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
  801e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e0b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e0f:	75 07                	jne    801e18 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e11:	b8 01 00 00 00       	mov    $0x1,%eax
  801e16:	eb 05                	jmp    801e1d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 2c                	push   $0x2c
  801e31:	e8 4b fa ff ff       	call   801881 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
  801e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e3c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e40:	75 07                	jne    801e49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	eb 05                	jmp    801e4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 2c                	push   $0x2c
  801e62:	e8 1a fa ff ff       	call   801881 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
  801e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e6d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e71:	75 07                	jne    801e7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e73:	b8 01 00 00 00       	mov    $0x1,%eax
  801e78:	eb 05                	jmp    801e7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 08             	pushl  0x8(%ebp)
  801e8f:	6a 2d                	push   $0x2d
  801e91:	e8 eb f9 ff ff       	call   801881 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
	return ;
  801e99:	90                   	nop
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	6a 00                	push   $0x0
  801eae:	53                   	push   %ebx
  801eaf:	51                   	push   %ecx
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	6a 2e                	push   $0x2e
  801eb4:	e8 c8 f9 ff ff       	call   801881 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	6a 2f                	push   $0x2f
  801ed4:	e8 a8 f9 ff ff       	call   801881 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	c1 e0 02             	shl    $0x2,%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ef5:	01 d0                	add    %edx,%eax
  801ef7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801efe:	01 d0                	add    %edx,%eax
  801f00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f07:	01 d0                	add    %edx,%eax
  801f09:	c1 e0 04             	shl    $0x4,%eax
  801f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801f0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801f16:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	50                   	push   %eax
  801f1d:	e8 76 fd ff ff       	call   801c98 <sys_get_virtual_time>
  801f22:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801f25:	eb 41                	jmp    801f68 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801f27:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	50                   	push   %eax
  801f2e:	e8 65 fd ff ff       	call   801c98 <sys_get_virtual_time>
  801f33:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801f36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3c:	29 c2                	sub    %eax,%edx
  801f3e:	89 d0                	mov    %edx,%eax
  801f40:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f49:	89 d1                	mov    %edx,%ecx
  801f4b:	29 c1                	sub    %eax,%ecx
  801f4d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f53:	39 c2                	cmp    %eax,%edx
  801f55:	0f 97 c0             	seta   %al
  801f58:	0f b6 c0             	movzbl %al,%eax
  801f5b:	29 c1                	sub    %eax,%ecx
  801f5d:	89 c8                	mov    %ecx,%eax
  801f5f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801f62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f6e:	72 b7                	jb     801f27 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801f70:	90                   	nop
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801f79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801f80:	eb 03                	jmp    801f85 <busy_wait+0x12>
  801f82:	ff 45 fc             	incl   -0x4(%ebp)
  801f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f8b:	72 f5                	jb     801f82 <busy_wait+0xf>
	return i;
  801f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    
  801f92:	66 90                	xchg   %ax,%ax

00801f94 <__udivdi3>:
  801f94:	55                   	push   %ebp
  801f95:	57                   	push   %edi
  801f96:	56                   	push   %esi
  801f97:	53                   	push   %ebx
  801f98:	83 ec 1c             	sub    $0x1c,%esp
  801f9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fab:	89 ca                	mov    %ecx,%edx
  801fad:	89 f8                	mov    %edi,%eax
  801faf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fb3:	85 f6                	test   %esi,%esi
  801fb5:	75 2d                	jne    801fe4 <__udivdi3+0x50>
  801fb7:	39 cf                	cmp    %ecx,%edi
  801fb9:	77 65                	ja     802020 <__udivdi3+0x8c>
  801fbb:	89 fd                	mov    %edi,%ebp
  801fbd:	85 ff                	test   %edi,%edi
  801fbf:	75 0b                	jne    801fcc <__udivdi3+0x38>
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	31 d2                	xor    %edx,%edx
  801fc8:	f7 f7                	div    %edi
  801fca:	89 c5                	mov    %eax,%ebp
  801fcc:	31 d2                	xor    %edx,%edx
  801fce:	89 c8                	mov    %ecx,%eax
  801fd0:	f7 f5                	div    %ebp
  801fd2:	89 c1                	mov    %eax,%ecx
  801fd4:	89 d8                	mov    %ebx,%eax
  801fd6:	f7 f5                	div    %ebp
  801fd8:	89 cf                	mov    %ecx,%edi
  801fda:	89 fa                	mov    %edi,%edx
  801fdc:	83 c4 1c             	add    $0x1c,%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5f                   	pop    %edi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    
  801fe4:	39 ce                	cmp    %ecx,%esi
  801fe6:	77 28                	ja     802010 <__udivdi3+0x7c>
  801fe8:	0f bd fe             	bsr    %esi,%edi
  801feb:	83 f7 1f             	xor    $0x1f,%edi
  801fee:	75 40                	jne    802030 <__udivdi3+0x9c>
  801ff0:	39 ce                	cmp    %ecx,%esi
  801ff2:	72 0a                	jb     801ffe <__udivdi3+0x6a>
  801ff4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ff8:	0f 87 9e 00 00 00    	ja     80209c <__udivdi3+0x108>
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	89 fa                	mov    %edi,%edx
  802005:	83 c4 1c             	add    $0x1c,%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	31 ff                	xor    %edi,%edi
  802012:	31 c0                	xor    %eax,%eax
  802014:	89 fa                	mov    %edi,%edx
  802016:	83 c4 1c             	add    $0x1c,%esp
  802019:	5b                   	pop    %ebx
  80201a:	5e                   	pop    %esi
  80201b:	5f                   	pop    %edi
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    
  80201e:	66 90                	xchg   %ax,%ax
  802020:	89 d8                	mov    %ebx,%eax
  802022:	f7 f7                	div    %edi
  802024:	31 ff                	xor    %edi,%edi
  802026:	89 fa                	mov    %edi,%edx
  802028:	83 c4 1c             	add    $0x1c,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5f                   	pop    %edi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    
  802030:	bd 20 00 00 00       	mov    $0x20,%ebp
  802035:	89 eb                	mov    %ebp,%ebx
  802037:	29 fb                	sub    %edi,%ebx
  802039:	89 f9                	mov    %edi,%ecx
  80203b:	d3 e6                	shl    %cl,%esi
  80203d:	89 c5                	mov    %eax,%ebp
  80203f:	88 d9                	mov    %bl,%cl
  802041:	d3 ed                	shr    %cl,%ebp
  802043:	89 e9                	mov    %ebp,%ecx
  802045:	09 f1                	or     %esi,%ecx
  802047:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80204b:	89 f9                	mov    %edi,%ecx
  80204d:	d3 e0                	shl    %cl,%eax
  80204f:	89 c5                	mov    %eax,%ebp
  802051:	89 d6                	mov    %edx,%esi
  802053:	88 d9                	mov    %bl,%cl
  802055:	d3 ee                	shr    %cl,%esi
  802057:	89 f9                	mov    %edi,%ecx
  802059:	d3 e2                	shl    %cl,%edx
  80205b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80205f:	88 d9                	mov    %bl,%cl
  802061:	d3 e8                	shr    %cl,%eax
  802063:	09 c2                	or     %eax,%edx
  802065:	89 d0                	mov    %edx,%eax
  802067:	89 f2                	mov    %esi,%edx
  802069:	f7 74 24 0c          	divl   0xc(%esp)
  80206d:	89 d6                	mov    %edx,%esi
  80206f:	89 c3                	mov    %eax,%ebx
  802071:	f7 e5                	mul    %ebp
  802073:	39 d6                	cmp    %edx,%esi
  802075:	72 19                	jb     802090 <__udivdi3+0xfc>
  802077:	74 0b                	je     802084 <__udivdi3+0xf0>
  802079:	89 d8                	mov    %ebx,%eax
  80207b:	31 ff                	xor    %edi,%edi
  80207d:	e9 58 ff ff ff       	jmp    801fda <__udivdi3+0x46>
  802082:	66 90                	xchg   %ax,%ax
  802084:	8b 54 24 08          	mov    0x8(%esp),%edx
  802088:	89 f9                	mov    %edi,%ecx
  80208a:	d3 e2                	shl    %cl,%edx
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	73 e9                	jae    802079 <__udivdi3+0xe5>
  802090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802093:	31 ff                	xor    %edi,%edi
  802095:	e9 40 ff ff ff       	jmp    801fda <__udivdi3+0x46>
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	31 c0                	xor    %eax,%eax
  80209e:	e9 37 ff ff ff       	jmp    801fda <__udivdi3+0x46>
  8020a3:	90                   	nop

008020a4 <__umoddi3>:
  8020a4:	55                   	push   %ebp
  8020a5:	57                   	push   %edi
  8020a6:	56                   	push   %esi
  8020a7:	53                   	push   %ebx
  8020a8:	83 ec 1c             	sub    $0x1c,%esp
  8020ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020c3:	89 f3                	mov    %esi,%ebx
  8020c5:	89 fa                	mov    %edi,%edx
  8020c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020cb:	89 34 24             	mov    %esi,(%esp)
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	75 1a                	jne    8020ec <__umoddi3+0x48>
  8020d2:	39 f7                	cmp    %esi,%edi
  8020d4:	0f 86 a2 00 00 00    	jbe    80217c <__umoddi3+0xd8>
  8020da:	89 c8                	mov    %ecx,%eax
  8020dc:	89 f2                	mov    %esi,%edx
  8020de:	f7 f7                	div    %edi
  8020e0:	89 d0                	mov    %edx,%eax
  8020e2:	31 d2                	xor    %edx,%edx
  8020e4:	83 c4 1c             	add    $0x1c,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
  8020ec:	39 f0                	cmp    %esi,%eax
  8020ee:	0f 87 ac 00 00 00    	ja     8021a0 <__umoddi3+0xfc>
  8020f4:	0f bd e8             	bsr    %eax,%ebp
  8020f7:	83 f5 1f             	xor    $0x1f,%ebp
  8020fa:	0f 84 ac 00 00 00    	je     8021ac <__umoddi3+0x108>
  802100:	bf 20 00 00 00       	mov    $0x20,%edi
  802105:	29 ef                	sub    %ebp,%edi
  802107:	89 fe                	mov    %edi,%esi
  802109:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80210d:	89 e9                	mov    %ebp,%ecx
  80210f:	d3 e0                	shl    %cl,%eax
  802111:	89 d7                	mov    %edx,%edi
  802113:	89 f1                	mov    %esi,%ecx
  802115:	d3 ef                	shr    %cl,%edi
  802117:	09 c7                	or     %eax,%edi
  802119:	89 e9                	mov    %ebp,%ecx
  80211b:	d3 e2                	shl    %cl,%edx
  80211d:	89 14 24             	mov    %edx,(%esp)
  802120:	89 d8                	mov    %ebx,%eax
  802122:	d3 e0                	shl    %cl,%eax
  802124:	89 c2                	mov    %eax,%edx
  802126:	8b 44 24 08          	mov    0x8(%esp),%eax
  80212a:	d3 e0                	shl    %cl,%eax
  80212c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802130:	8b 44 24 08          	mov    0x8(%esp),%eax
  802134:	89 f1                	mov    %esi,%ecx
  802136:	d3 e8                	shr    %cl,%eax
  802138:	09 d0                	or     %edx,%eax
  80213a:	d3 eb                	shr    %cl,%ebx
  80213c:	89 da                	mov    %ebx,%edx
  80213e:	f7 f7                	div    %edi
  802140:	89 d3                	mov    %edx,%ebx
  802142:	f7 24 24             	mull   (%esp)
  802145:	89 c6                	mov    %eax,%esi
  802147:	89 d1                	mov    %edx,%ecx
  802149:	39 d3                	cmp    %edx,%ebx
  80214b:	0f 82 87 00 00 00    	jb     8021d8 <__umoddi3+0x134>
  802151:	0f 84 91 00 00 00    	je     8021e8 <__umoddi3+0x144>
  802157:	8b 54 24 04          	mov    0x4(%esp),%edx
  80215b:	29 f2                	sub    %esi,%edx
  80215d:	19 cb                	sbb    %ecx,%ebx
  80215f:	89 d8                	mov    %ebx,%eax
  802161:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802165:	d3 e0                	shl    %cl,%eax
  802167:	89 e9                	mov    %ebp,%ecx
  802169:	d3 ea                	shr    %cl,%edx
  80216b:	09 d0                	or     %edx,%eax
  80216d:	89 e9                	mov    %ebp,%ecx
  80216f:	d3 eb                	shr    %cl,%ebx
  802171:	89 da                	mov    %ebx,%edx
  802173:	83 c4 1c             	add    $0x1c,%esp
  802176:	5b                   	pop    %ebx
  802177:	5e                   	pop    %esi
  802178:	5f                   	pop    %edi
  802179:	5d                   	pop    %ebp
  80217a:	c3                   	ret    
  80217b:	90                   	nop
  80217c:	89 fd                	mov    %edi,%ebp
  80217e:	85 ff                	test   %edi,%edi
  802180:	75 0b                	jne    80218d <__umoddi3+0xe9>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	31 d2                	xor    %edx,%edx
  802189:	f7 f7                	div    %edi
  80218b:	89 c5                	mov    %eax,%ebp
  80218d:	89 f0                	mov    %esi,%eax
  80218f:	31 d2                	xor    %edx,%edx
  802191:	f7 f5                	div    %ebp
  802193:	89 c8                	mov    %ecx,%eax
  802195:	f7 f5                	div    %ebp
  802197:	89 d0                	mov    %edx,%eax
  802199:	e9 44 ff ff ff       	jmp    8020e2 <__umoddi3+0x3e>
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	89 c8                	mov    %ecx,%eax
  8021a2:	89 f2                	mov    %esi,%edx
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
  8021ac:	3b 04 24             	cmp    (%esp),%eax
  8021af:	72 06                	jb     8021b7 <__umoddi3+0x113>
  8021b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021b5:	77 0f                	ja     8021c6 <__umoddi3+0x122>
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	29 f9                	sub    %edi,%ecx
  8021bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021bf:	89 14 24             	mov    %edx,(%esp)
  8021c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ca:	8b 14 24             	mov    (%esp),%edx
  8021cd:	83 c4 1c             	add    $0x1c,%esp
  8021d0:	5b                   	pop    %ebx
  8021d1:	5e                   	pop    %esi
  8021d2:	5f                   	pop    %edi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    
  8021d5:	8d 76 00             	lea    0x0(%esi),%esi
  8021d8:	2b 04 24             	sub    (%esp),%eax
  8021db:	19 fa                	sbb    %edi,%edx
  8021dd:	89 d1                	mov    %edx,%ecx
  8021df:	89 c6                	mov    %eax,%esi
  8021e1:	e9 71 ff ff ff       	jmp    802157 <__umoddi3+0xb3>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021ec:	72 ea                	jb     8021d8 <__umoddi3+0x134>
  8021ee:	89 d9                	mov    %ebx,%ecx
  8021f0:	e9 62 ff ff ff       	jmp    802157 <__umoddi3+0xb3>
