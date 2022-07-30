
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800086:	68 c0 20 80 00       	push   $0x8020c0
  80008b:	6a 12                	push   $0x12
  80008d:	68 dc 20 80 00       	push   $0x8020dc
  800092:	e8 c7 01 00 00       	call   80025e <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  800097:	e8 11 18 00 00       	call   8018ad <sys_getparentenvid>
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	68 f7 20 80 00       	push   $0x8020f7
  8000a4:	50                   	push   %eax
  8000a5:	e8 9b 16 00 00       	call   801745 <sget>
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b0:	e8 aa 18 00 00       	call   80195f <sys_calculate_free_frames>
  8000b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	68 fc 20 80 00       	push   $0x8020fc
  8000c0:	e8 3b 04 00 00       	call   800500 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000c8:	83 ec 0c             	sub    $0xc,%esp
  8000cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ce:	e8 8f 16 00 00       	call   801762 <sfree>
  8000d3:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 20 21 80 00       	push   $0x802120
  8000de:	e8 1d 04 00 00       	call   800500 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000e6:	e8 74 18 00 00       	call   80195f <sys_calculate_free_frames>
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f0:	29 c2                	sub    %eax,%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000f7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8000fb:	74 14                	je     800111 <_main+0xd9>
  8000fd:	83 ec 04             	sub    $0x4,%esp
  800100:	68 38 21 80 00       	push   $0x802138
  800105:	6a 1f                	push   $0x1f
  800107:	68 dc 20 80 00       	push   $0x8020dc
  80010c:	e8 4d 01 00 00       	call   80025e <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800111:	e8 e6 1b 00 00       	call   801cfc <inctst>

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
  80011f:	e8 70 17 00 00       	call   801894 <sys_getenvindex>
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
  80019c:	e8 8e 18 00 00       	call   801a2f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 dc 21 80 00       	push   $0x8021dc
  8001a9:	e8 52 03 00 00       	call   800500 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b6:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8001bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c1:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	52                   	push   %edx
  8001cb:	50                   	push   %eax
  8001cc:	68 04 22 80 00       	push   $0x802204
  8001d1:	e8 2a 03 00 00       	call   800500 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8001d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001de:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8001e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e9:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	52                   	push   %edx
  8001f3:	50                   	push   %eax
  8001f4:	68 2c 22 80 00       	push   $0x80222c
  8001f9:	e8 02 03 00 00       	call   800500 <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800201:	a1 20 30 80 00       	mov    0x803020,%eax
  800206:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	50                   	push   %eax
  800210:	68 6d 22 80 00       	push   $0x80226d
  800215:	e8 e6 02 00 00       	call   800500 <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	68 dc 21 80 00       	push   $0x8021dc
  800225:	e8 d6 02 00 00       	call   800500 <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022d:	e8 17 18 00 00       	call   801a49 <sys_enable_interrupt>

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
  800245:	e8 16 16 00 00       	call   801860 <sys_env_destroy>
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
  800256:	e8 6b 16 00 00       	call   8018c6 <sys_env_exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800264:	8d 45 10             	lea    0x10(%ebp),%eax
  800267:	83 c0 04             	add    $0x4,%eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026d:	a1 18 31 80 00       	mov    0x803118,%eax
  800272:	85 c0                	test   %eax,%eax
  800274:	74 16                	je     80028c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800276:	a1 18 31 80 00       	mov    0x803118,%eax
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	50                   	push   %eax
  80027f:	68 84 22 80 00       	push   $0x802284
  800284:	e8 77 02 00 00       	call   800500 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80028c:	a1 00 30 80 00       	mov    0x803000,%eax
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	50                   	push   %eax
  800298:	68 89 22 80 00       	push   $0x802289
  80029d:	e8 5e 02 00 00       	call   800500 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ae:	50                   	push   %eax
  8002af:	e8 e1 01 00 00       	call   800495 <vcprintf>
  8002b4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b7:	83 ec 08             	sub    $0x8,%esp
  8002ba:	6a 00                	push   $0x0
  8002bc:	68 a5 22 80 00       	push   $0x8022a5
  8002c1:	e8 cf 01 00 00       	call   800495 <vcprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c9:	e8 82 ff ff ff       	call   800250 <exit>

	// should not return here
	while (1) ;
  8002ce:	eb fe                	jmp    8002ce <_panic+0x70>

008002d0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002db:	8b 50 74             	mov    0x74(%eax),%edx
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	39 c2                	cmp    %eax,%edx
  8002e3:	74 14                	je     8002f9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e5:	83 ec 04             	sub    $0x4,%esp
  8002e8:	68 a8 22 80 00       	push   $0x8022a8
  8002ed:	6a 26                	push   $0x26
  8002ef:	68 f4 22 80 00       	push   $0x8022f4
  8002f4:	e8 65 ff ff ff       	call   80025e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800307:	e9 b6 00 00 00       	jmp    8003c2 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80030c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800316:	8b 45 08             	mov    0x8(%ebp),%eax
  800319:	01 d0                	add    %edx,%eax
  80031b:	8b 00                	mov    (%eax),%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	75 08                	jne    800329 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800321:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800324:	e9 96 00 00 00       	jmp    8003bf <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800329:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800330:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800337:	eb 5d                	jmp    800396 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800339:	a1 20 30 80 00       	mov    0x803020,%eax
  80033e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800344:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800347:	c1 e2 04             	shl    $0x4,%edx
  80034a:	01 d0                	add    %edx,%eax
  80034c:	8a 40 04             	mov    0x4(%eax),%al
  80034f:	84 c0                	test   %al,%al
  800351:	75 40                	jne    800393 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800353:	a1 20 30 80 00       	mov    0x803020,%eax
  800358:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80035e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800361:	c1 e2 04             	shl    $0x4,%edx
  800364:	01 d0                	add    %edx,%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80036b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80036e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800373:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800378:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800386:	39 c2                	cmp    %eax,%edx
  800388:	75 09                	jne    800393 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80038a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800391:	eb 12                	jmp    8003a5 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800393:	ff 45 e8             	incl   -0x18(%ebp)
  800396:	a1 20 30 80 00       	mov    0x803020,%eax
  80039b:	8b 50 74             	mov    0x74(%eax),%edx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	77 94                	ja     800339 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003a9:	75 14                	jne    8003bf <CheckWSWithoutLastIndex+0xef>
			panic(
  8003ab:	83 ec 04             	sub    $0x4,%esp
  8003ae:	68 00 23 80 00       	push   $0x802300
  8003b3:	6a 3a                	push   $0x3a
  8003b5:	68 f4 22 80 00       	push   $0x8022f4
  8003ba:	e8 9f fe ff ff       	call   80025e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003bf:	ff 45 f0             	incl   -0x10(%ebp)
  8003c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003c8:	0f 8c 3e ff ff ff    	jl     80030c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003dc:	eb 20                	jmp    8003fe <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003de:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e3:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8003e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ec:	c1 e2 04             	shl    $0x4,%edx
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	8a 40 04             	mov    0x4(%eax),%al
  8003f4:	3c 01                	cmp    $0x1,%al
  8003f6:	75 03                	jne    8003fb <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8003f8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fb:	ff 45 e0             	incl   -0x20(%ebp)
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 50 74             	mov    0x74(%eax),%edx
  800406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800409:	39 c2                	cmp    %eax,%edx
  80040b:	77 d1                	ja     8003de <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800410:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800413:	74 14                	je     800429 <CheckWSWithoutLastIndex+0x159>
		panic(
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 54 23 80 00       	push   $0x802354
  80041d:	6a 44                	push   $0x44
  80041f:	68 f4 22 80 00       	push   $0x8022f4
  800424:	e8 35 fe ff ff       	call   80025e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800429:	90                   	nop
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800432:	8b 45 0c             	mov    0xc(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	8d 48 01             	lea    0x1(%eax),%ecx
  80043a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043d:	89 0a                	mov    %ecx,(%edx)
  80043f:	8b 55 08             	mov    0x8(%ebp),%edx
  800442:	88 d1                	mov    %dl,%cl
  800444:	8b 55 0c             	mov    0xc(%ebp),%edx
  800447:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	3d ff 00 00 00       	cmp    $0xff,%eax
  800455:	75 2c                	jne    800483 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800457:	a0 24 30 80 00       	mov    0x803024,%al
  80045c:	0f b6 c0             	movzbl %al,%eax
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	8b 12                	mov    (%edx),%edx
  800464:	89 d1                	mov    %edx,%ecx
  800466:	8b 55 0c             	mov    0xc(%ebp),%edx
  800469:	83 c2 08             	add    $0x8,%edx
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	50                   	push   %eax
  800470:	51                   	push   %ecx
  800471:	52                   	push   %edx
  800472:	e8 a7 13 00 00       	call   80181e <sys_cputs>
  800477:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800483:	8b 45 0c             	mov    0xc(%ebp),%eax
  800486:	8b 40 04             	mov    0x4(%eax),%eax
  800489:	8d 50 01             	lea    0x1(%eax),%edx
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800492:	90                   	nop
  800493:	c9                   	leave  
  800494:	c3                   	ret    

00800495 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800495:	55                   	push   %ebp
  800496:	89 e5                	mov    %esp,%ebp
  800498:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80049e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004a5:	00 00 00 
	b.cnt = 0;
  8004a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	ff 75 08             	pushl  0x8(%ebp)
  8004b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004be:	50                   	push   %eax
  8004bf:	68 2c 04 80 00       	push   $0x80042c
  8004c4:	e8 11 02 00 00       	call   8006da <vprintfmt>
  8004c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004cc:	a0 24 30 80 00       	mov    0x803024,%al
  8004d1:	0f b6 c0             	movzbl %al,%eax
  8004d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	50                   	push   %eax
  8004de:	52                   	push   %edx
  8004df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e5:	83 c0 08             	add    $0x8,%eax
  8004e8:	50                   	push   %eax
  8004e9:	e8 30 13 00 00       	call   80181e <sys_cputs>
  8004ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004f1:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8004f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <cprintf>:

int cprintf(const char *fmt, ...) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800506:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80050d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 f4             	pushl  -0xc(%ebp)
  80051c:	50                   	push   %eax
  80051d:	e8 73 ff ff ff       	call   800495 <vcprintf>
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800528:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800533:	e8 f7 14 00 00       	call   801a2f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 48 ff ff ff       	call   800495 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800553:	e8 f1 14 00 00       	call   801a49 <sys_enable_interrupt>
	return cnt;
  800558:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

0080055d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	53                   	push   %ebx
  800561:	83 ec 14             	sub    $0x14,%esp
  800564:	8b 45 10             	mov    0x10(%ebp),%eax
  800567:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800570:	8b 45 18             	mov    0x18(%ebp),%eax
  800573:	ba 00 00 00 00       	mov    $0x0,%edx
  800578:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80057b:	77 55                	ja     8005d2 <printnum+0x75>
  80057d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800580:	72 05                	jb     800587 <printnum+0x2a>
  800582:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800585:	77 4b                	ja     8005d2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800587:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80058a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80058d:	8b 45 18             	mov    0x18(%ebp),%eax
  800590:	ba 00 00 00 00       	mov    $0x0,%edx
  800595:	52                   	push   %edx
  800596:	50                   	push   %eax
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	ff 75 f0             	pushl  -0x10(%ebp)
  80059d:	e8 ae 18 00 00       	call   801e50 <__udivdi3>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	83 ec 04             	sub    $0x4,%esp
  8005a8:	ff 75 20             	pushl  0x20(%ebp)
  8005ab:	53                   	push   %ebx
  8005ac:	ff 75 18             	pushl  0x18(%ebp)
  8005af:	52                   	push   %edx
  8005b0:	50                   	push   %eax
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	ff 75 08             	pushl  0x8(%ebp)
  8005b7:	e8 a1 ff ff ff       	call   80055d <printnum>
  8005bc:	83 c4 20             	add    $0x20,%esp
  8005bf:	eb 1a                	jmp    8005db <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	ff 75 20             	pushl  0x20(%ebp)
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	ff d0                	call   *%eax
  8005cf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d2:	ff 4d 1c             	decl   0x1c(%ebp)
  8005d5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005d9:	7f e6                	jg     8005c1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005db:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005e9:	53                   	push   %ebx
  8005ea:	51                   	push   %ecx
  8005eb:	52                   	push   %edx
  8005ec:	50                   	push   %eax
  8005ed:	e8 6e 19 00 00       	call   801f60 <__umoddi3>
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	05 b4 25 80 00       	add    $0x8025b4,%eax
  8005fa:	8a 00                	mov    (%eax),%al
  8005fc:	0f be c0             	movsbl %al,%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	ff d0                	call   *%eax
  80060b:	83 c4 10             	add    $0x10,%esp
}
  80060e:	90                   	nop
  80060f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800617:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80061b:	7e 1c                	jle    800639 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	8d 50 08             	lea    0x8(%eax),%edx
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	89 10                	mov    %edx,(%eax)
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	83 e8 08             	sub    $0x8,%eax
  800632:	8b 50 04             	mov    0x4(%eax),%edx
  800635:	8b 00                	mov    (%eax),%eax
  800637:	eb 40                	jmp    800679 <getuint+0x65>
	else if (lflag)
  800639:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80063d:	74 1e                	je     80065d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	8d 50 04             	lea    0x4(%eax),%edx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	89 10                	mov    %edx,(%eax)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	83 e8 04             	sub    $0x4,%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	ba 00 00 00 00       	mov    $0x0,%edx
  80065b:	eb 1c                	jmp    800679 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	8d 50 04             	lea    0x4(%eax),%edx
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	89 10                	mov    %edx,(%eax)
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800679:	5d                   	pop    %ebp
  80067a:	c3                   	ret    

0080067b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800682:	7e 1c                	jle    8006a0 <getint+0x25>
		return va_arg(*ap, long long);
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	8d 50 08             	lea    0x8(%eax),%edx
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	89 10                	mov    %edx,(%eax)
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	83 e8 08             	sub    $0x8,%eax
  800699:	8b 50 04             	mov    0x4(%eax),%edx
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	eb 38                	jmp    8006d8 <getint+0x5d>
	else if (lflag)
  8006a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a4:	74 1a                	je     8006c0 <getint+0x45>
		return va_arg(*ap, long);
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	8d 50 04             	lea    0x4(%eax),%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	89 10                	mov    %edx,(%eax)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	83 e8 04             	sub    $0x4,%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	99                   	cltd   
  8006be:	eb 18                	jmp    8006d8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	8d 50 04             	lea    0x4(%eax),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	89 10                	mov    %edx,(%eax)
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	83 e8 04             	sub    $0x4,%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	99                   	cltd   
}
  8006d8:	5d                   	pop    %ebp
  8006d9:	c3                   	ret    

008006da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	56                   	push   %esi
  8006de:	53                   	push   %ebx
  8006df:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	eb 17                	jmp    8006fb <vprintfmt+0x21>
			if (ch == '\0')
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	0f 84 af 03 00 00    	je     800a9b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	53                   	push   %ebx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	ff d0                	call   *%eax
  8006f8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fe:	8d 50 01             	lea    0x1(%eax),%edx
  800701:	89 55 10             	mov    %edx,0x10(%ebp)
  800704:	8a 00                	mov    (%eax),%al
  800706:	0f b6 d8             	movzbl %al,%ebx
  800709:	83 fb 25             	cmp    $0x25,%ebx
  80070c:	75 d6                	jne    8006e4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80070e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800712:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800719:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800720:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800727:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80073f:	83 f8 55             	cmp    $0x55,%eax
  800742:	0f 87 2b 03 00 00    	ja     800a73 <vprintfmt+0x399>
  800748:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  80074f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800751:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800755:	eb d7                	jmp    80072e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800757:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80075b:	eb d1                	jmp    80072e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800764:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800767:	89 d0                	mov    %edx,%eax
  800769:	c1 e0 02             	shl    $0x2,%eax
  80076c:	01 d0                	add    %edx,%eax
  80076e:	01 c0                	add    %eax,%eax
  800770:	01 d8                	add    %ebx,%eax
  800772:	83 e8 30             	sub    $0x30,%eax
  800775:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800778:	8b 45 10             	mov    0x10(%ebp),%eax
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800780:	83 fb 2f             	cmp    $0x2f,%ebx
  800783:	7e 3e                	jle    8007c3 <vprintfmt+0xe9>
  800785:	83 fb 39             	cmp    $0x39,%ebx
  800788:	7f 39                	jg     8007c3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80078d:	eb d5                	jmp    800764 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	83 c0 04             	add    $0x4,%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007a3:	eb 1f                	jmp    8007c4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a9:	79 83                	jns    80072e <vprintfmt+0x54>
				width = 0;
  8007ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007b2:	e9 77 ff ff ff       	jmp    80072e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007b7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007be:	e9 6b ff ff ff       	jmp    80072e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	0f 89 60 ff ff ff    	jns    80072e <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007db:	e9 4e ff ff ff       	jmp    80072e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007e3:	e9 46 ff ff ff       	jmp    80072e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	83 c0 04             	add    $0x4,%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	50                   	push   %eax
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
			break;
  800808:	e9 89 02 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80081e:	85 db                	test   %ebx,%ebx
  800820:	79 02                	jns    800824 <vprintfmt+0x14a>
				err = -err;
  800822:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800824:	83 fb 64             	cmp    $0x64,%ebx
  800827:	7f 0b                	jg     800834 <vprintfmt+0x15a>
  800829:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800830:	85 f6                	test   %esi,%esi
  800832:	75 19                	jne    80084d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800834:	53                   	push   %ebx
  800835:	68 c5 25 80 00       	push   $0x8025c5
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	ff 75 08             	pushl  0x8(%ebp)
  800840:	e8 5e 02 00 00       	call   800aa3 <printfmt>
  800845:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800848:	e9 49 02 00 00       	jmp    800a96 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80084d:	56                   	push   %esi
  80084e:	68 ce 25 80 00       	push   $0x8025ce
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	ff 75 08             	pushl  0x8(%ebp)
  800859:	e8 45 02 00 00       	call   800aa3 <printfmt>
  80085e:	83 c4 10             	add    $0x10,%esp
			break;
  800861:	e9 30 02 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	83 c0 04             	add    $0x4,%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	83 e8 04             	sub    $0x4,%eax
  800875:	8b 30                	mov    (%eax),%esi
  800877:	85 f6                	test   %esi,%esi
  800879:	75 05                	jne    800880 <vprintfmt+0x1a6>
				p = "(null)";
  80087b:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	7e 6d                	jle    8008f3 <vprintfmt+0x219>
  800886:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80088a:	74 67                	je     8008f3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	50                   	push   %eax
  800893:	56                   	push   %esi
  800894:	e8 0c 03 00 00       	call   800ba5 <strnlen>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80089f:	eb 16                	jmp    8008b7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008a1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8008b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bb:	7f e4                	jg     8008a1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bd:	eb 34                	jmp    8008f3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008c3:	74 1c                	je     8008e1 <vprintfmt+0x207>
  8008c5:	83 fb 1f             	cmp    $0x1f,%ebx
  8008c8:	7e 05                	jle    8008cf <vprintfmt+0x1f5>
  8008ca:	83 fb 7e             	cmp    $0x7e,%ebx
  8008cd:	7e 12                	jle    8008e1 <vprintfmt+0x207>
					putch('?', putdat);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	6a 3f                	push   $0x3f
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	eb 0f                	jmp    8008f0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	53                   	push   %ebx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	ff d0                	call   *%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f3:	89 f0                	mov    %esi,%eax
  8008f5:	8d 70 01             	lea    0x1(%eax),%esi
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be d8             	movsbl %al,%ebx
  8008fd:	85 db                	test   %ebx,%ebx
  8008ff:	74 24                	je     800925 <vprintfmt+0x24b>
  800901:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800905:	78 b8                	js     8008bf <vprintfmt+0x1e5>
  800907:	ff 4d e0             	decl   -0x20(%ebp)
  80090a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80090e:	79 af                	jns    8008bf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800910:	eb 13                	jmp    800925 <vprintfmt+0x24b>
				putch(' ', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	6a 20                	push   $0x20
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800922:	ff 4d e4             	decl   -0x1c(%ebp)
  800925:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800929:	7f e7                	jg     800912 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80092b:	e9 66 01 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 e8             	pushl  -0x18(%ebp)
  800936:	8d 45 14             	lea    0x14(%ebp),%eax
  800939:	50                   	push   %eax
  80093a:	e8 3c fd ff ff       	call   80067b <getint>
  80093f:	83 c4 10             	add    $0x10,%esp
  800942:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800945:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094e:	85 d2                	test   %edx,%edx
  800950:	79 23                	jns    800975 <vprintfmt+0x29b>
				putch('-', putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	6a 2d                	push   $0x2d
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800968:	f7 d8                	neg    %eax
  80096a:	83 d2 00             	adc    $0x0,%edx
  80096d:	f7 da                	neg    %edx
  80096f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800972:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800975:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80097c:	e9 bc 00 00 00       	jmp    800a3d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 e8             	pushl  -0x18(%ebp)
  800987:	8d 45 14             	lea    0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	e8 84 fc ff ff       	call   800614 <getuint>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800999:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a0:	e9 98 00 00 00       	jmp    800a3d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	6a 58                	push   $0x58
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	6a 58                	push   $0x58
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	6a 58                	push   $0x58
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	ff d0                	call   *%eax
  8009d2:	83 c4 10             	add    $0x10,%esp
			break;
  8009d5:	e9 bc 00 00 00       	jmp    800a96 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 30                	push   $0x30
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 78                	push   $0x78
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	83 c0 04             	add    $0x4,%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 e8 04             	sub    $0x4,%eax
  800a09:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a1c:	eb 1f                	jmp    800a3d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 e7 fb ff ff       	call   800614 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a44:	83 ec 04             	sub    $0x4,%esp
  800a47:	52                   	push   %edx
  800a48:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a4b:	50                   	push   %eax
  800a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	ff 75 08             	pushl  0x8(%ebp)
  800a58:	e8 00 fb ff ff       	call   80055d <printnum>
  800a5d:	83 c4 20             	add    $0x20,%esp
			break;
  800a60:	eb 34                	jmp    800a96 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
			break;
  800a71:	eb 23                	jmp    800a96 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	6a 25                	push   $0x25
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	ff d0                	call   *%eax
  800a80:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a83:	ff 4d 10             	decl   0x10(%ebp)
  800a86:	eb 03                	jmp    800a8b <vprintfmt+0x3b1>
  800a88:	ff 4d 10             	decl   0x10(%ebp)
  800a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8e:	48                   	dec    %eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	3c 25                	cmp    $0x25,%al
  800a93:	75 f3                	jne    800a88 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800a95:	90                   	nop
		}
	}
  800a96:	e9 47 fc ff ff       	jmp    8006e2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a9b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aa9:	8d 45 10             	lea    0x10(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 16 fc ff ff       	call   8006da <vprintfmt>
  800ac4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ac7:	90                   	nop
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad0:	8b 40 08             	mov    0x8(%eax),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 10                	mov    (%eax),%edx
  800ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae4:	8b 40 04             	mov    0x4(%eax),%eax
  800ae7:	39 c2                	cmp    %eax,%edx
  800ae9:	73 12                	jae    800afd <sprintputch+0x33>
		*b->buf++ = ch;
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 48 01             	lea    0x1(%eax),%ecx
  800af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af6:	89 0a                	mov    %ecx,(%edx)
  800af8:	8b 55 08             	mov    0x8(%ebp),%edx
  800afb:	88 10                	mov    %dl,(%eax)
}
  800afd:	90                   	nop
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	01 d0                	add    %edx,%eax
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b25:	74 06                	je     800b2d <vsnprintf+0x2d>
  800b27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2b:	7f 07                	jg     800b34 <vsnprintf+0x34>
		return -E_INVAL;
  800b2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b32:	eb 20                	jmp    800b54 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b34:	ff 75 14             	pushl  0x14(%ebp)
  800b37:	ff 75 10             	pushl  0x10(%ebp)
  800b3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	68 ca 0a 80 00       	push   $0x800aca
  800b43:	e8 92 fb ff ff       	call   8006da <vprintfmt>
  800b48:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b4e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b5c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b5f:	83 c0 04             	add    $0x4,%eax
  800b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6b:	50                   	push   %eax
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	e8 89 ff ff ff       	call   800b00 <vsnprintf>
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 06                	jmp    800b97 <strlen+0x15>
		n++;
  800b91:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 f1                	jne    800b91 <strlen+0xf>
		n++;
	return n;
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb2:	eb 09                	jmp    800bbd <strnlen+0x18>
		n++;
  800bb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb7:	ff 45 08             	incl   0x8(%ebp)
  800bba:	ff 4d 0c             	decl   0xc(%ebp)
  800bbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc1:	74 09                	je     800bcc <strnlen+0x27>
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 e8                	jne    800bb4 <strnlen+0xf>
		n++;
	return n;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bdd:	90                   	nop
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8d 50 01             	lea    0x1(%eax),%edx
  800be4:	89 55 08             	mov    %edx,0x8(%ebp)
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf0:	8a 12                	mov    (%edx),%dl
  800bf2:	88 10                	mov    %dl,(%eax)
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	84 c0                	test   %al,%al
  800bf8:	75 e4                	jne    800bde <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c12:	eb 1f                	jmp    800c33 <strncpy+0x34>
		*dst++ = *src;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8a 12                	mov    (%edx),%dl
  800c22:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 03                	je     800c30 <strncpy+0x31>
			src++;
  800c2d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c30:	ff 45 fc             	incl   -0x4(%ebp)
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c36:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c39:	72 d9                	jb     800c14 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c50:	74 30                	je     800c82 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c52:	eb 16                	jmp    800c6a <strlcpy+0x2a>
			*dst++ = *src++;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8d 50 01             	lea    0x1(%eax),%edx
  800c5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c66:	8a 12                	mov    (%edx),%dl
  800c68:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c6a:	ff 4d 10             	decl   0x10(%ebp)
  800c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c71:	74 09                	je     800c7c <strlcpy+0x3c>
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 d8                	jne    800c54 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c88:	29 c2                	sub    %eax,%edx
  800c8a:	89 d0                	mov    %edx,%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c91:	eb 06                	jmp    800c99 <strcmp+0xb>
		p++, q++;
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	74 0e                	je     800cb0 <strcmp+0x22>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 10                	mov    (%eax),%dl
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	38 c2                	cmp    %al,%dl
  800cae:	74 e3                	je     800c93 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	0f b6 d0             	movzbl %al,%edx
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 c0             	movzbl %al,%eax
  800cc0:	29 c2                	sub    %eax,%edx
  800cc2:	89 d0                	mov    %edx,%eax
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cc9:	eb 09                	jmp    800cd4 <strncmp+0xe>
		n--, p++, q++;
  800ccb:	ff 4d 10             	decl   0x10(%ebp)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	74 17                	je     800cf1 <strncmp+0x2b>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0e                	je     800cf1 <strncmp+0x2b>
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 10                	mov    (%eax),%dl
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	38 c2                	cmp    %al,%dl
  800cef:	74 da                	je     800ccb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	75 07                	jne    800cfe <strncmp+0x38>
		return 0;
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfc:	eb 14                	jmp    800d12 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d0             	movzbl %al,%edx
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	29 c2                	sub    %eax,%edx
  800d10:	89 d0                	mov    %edx,%eax
}
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d20:	eb 12                	jmp    800d34 <strchr+0x20>
		if (*s == c)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2a:	75 05                	jne    800d31 <strchr+0x1d>
			return (char *) s;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	eb 11                	jmp    800d42 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d31:	ff 45 08             	incl   0x8(%ebp)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 e5                	jne    800d22 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d50:	eb 0d                	jmp    800d5f <strfind+0x1b>
		if (*s == c)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5a:	74 0e                	je     800d6a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 ea                	jne    800d52 <strfind+0xe>
  800d68:	eb 01                	jmp    800d6b <strfind+0x27>
		if (*s == c)
			break;
  800d6a:	90                   	nop
	return (char *) s;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d82:	eb 0e                	jmp    800d92 <memset+0x22>
		*p++ = c;
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d90:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d92:	ff 4d f8             	decl   -0x8(%ebp)
  800d95:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d99:	79 e9                	jns    800d84 <memset+0x14>
		*p++ = c;

	return v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db2:	eb 16                	jmp    800dca <memcpy+0x2a>
		*d++ = *s++;
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc6:	8a 12                	mov    (%edx),%dl
  800dc8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dca:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	75 dd                	jne    800db4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df4:	73 50                	jae    800e46 <memmove+0x6a>
  800df6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e01:	76 43                	jbe    800e46 <memmove+0x6a>
		s += n;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e0f:	eb 10                	jmp    800e21 <memmove+0x45>
			*--d = *--s;
  800e11:	ff 4d f8             	decl   -0x8(%ebp)
  800e14:	ff 4d fc             	decl   -0x4(%ebp)
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1a:	8a 10                	mov    (%eax),%dl
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e27:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	75 e3                	jne    800e11 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2e:	eb 23                	jmp    800e53 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e33:	8d 50 01             	lea    0x1(%eax),%edx
  800e36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 dd                	jne    800e30 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6a:	eb 2a                	jmp    800e96 <memcmp+0x3e>
		if (*s1 != *s2)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	38 c2                	cmp    %al,%dl
  800e78:	74 16                	je     800e90 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f b6 d0             	movzbl %al,%edx
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	0f b6 c0             	movzbl %al,%eax
  800e8a:	29 c2                	sub    %eax,%edx
  800e8c:	89 d0                	mov    %edx,%eax
  800e8e:	eb 18                	jmp    800ea8 <memcmp+0x50>
		s1++, s2++;
  800e90:	ff 45 fc             	incl   -0x4(%ebp)
  800e93:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	75 c9                	jne    800e6c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	01 d0                	add    %edx,%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ebb:	eb 15                	jmp    800ed2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	0f b6 c0             	movzbl %al,%eax
  800ecb:	39 c2                	cmp    %eax,%edx
  800ecd:	74 0d                	je     800edc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ed8:	72 e3                	jb     800ebd <memfind+0x13>
  800eda:	eb 01                	jmp    800edd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800edc:	90                   	nop
	return (void *) s;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800eef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef6:	eb 03                	jmp    800efb <strtol+0x19>
		s++;
  800ef8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 20                	cmp    $0x20,%al
  800f02:	74 f4                	je     800ef8 <strtol+0x16>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 09                	cmp    $0x9,%al
  800f0b:	74 eb                	je     800ef8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 2b                	cmp    $0x2b,%al
  800f14:	75 05                	jne    800f1b <strtol+0x39>
		s++;
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	eb 13                	jmp    800f2e <strtol+0x4c>
	else if (*s == '-')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 2d                	cmp    $0x2d,%al
  800f22:	75 0a                	jne    800f2e <strtol+0x4c>
		s++, neg = 1;
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 06                	je     800f3a <strtol+0x58>
  800f34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f38:	75 20                	jne    800f5a <strtol+0x78>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 30                	cmp    $0x30,%al
  800f41:	75 17                	jne    800f5a <strtol+0x78>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	40                   	inc    %eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 78                	cmp    $0x78,%al
  800f4b:	75 0d                	jne    800f5a <strtol+0x78>
		s += 2, base = 16;
  800f4d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f51:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f58:	eb 28                	jmp    800f82 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	75 15                	jne    800f75 <strtol+0x93>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	3c 30                	cmp    $0x30,%al
  800f67:	75 0c                	jne    800f75 <strtol+0x93>
		s++, base = 8;
  800f69:	ff 45 08             	incl   0x8(%ebp)
  800f6c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f73:	eb 0d                	jmp    800f82 <strtol+0xa0>
	else if (base == 0)
  800f75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f79:	75 07                	jne    800f82 <strtol+0xa0>
		base = 10;
  800f7b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 2f                	cmp    $0x2f,%al
  800f89:	7e 19                	jle    800fa4 <strtol+0xc2>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 39                	cmp    $0x39,%al
  800f92:	7f 10                	jg     800fa4 <strtol+0xc2>
			dig = *s - '0';
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	0f be c0             	movsbl %al,%eax
  800f9c:	83 e8 30             	sub    $0x30,%eax
  800f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa2:	eb 42                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 60                	cmp    $0x60,%al
  800fab:	7e 19                	jle    800fc6 <strtol+0xe4>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 7a                	cmp    $0x7a,%al
  800fb4:	7f 10                	jg     800fc6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f be c0             	movsbl %al,%eax
  800fbe:	83 e8 57             	sub    $0x57,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc4:	eb 20                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 40                	cmp    $0x40,%al
  800fcd:	7e 39                	jle    801008 <strtol+0x126>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 5a                	cmp    $0x5a,%al
  800fd6:	7f 30                	jg     801008 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 37             	sub    $0x37,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fec:	7d 19                	jge    801007 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801002:	e9 7b ff ff ff       	jmp    800f82 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801007:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	74 08                	je     801016 <strtol+0x134>
		*endptr = (char *) s;
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101a:	74 07                	je     801023 <strtol+0x141>
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	f7 d8                	neg    %eax
  801021:	eb 03                	jmp    801026 <strtol+0x144>
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <ltostr>:

void
ltostr(long value, char *str)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801035:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80103c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801040:	79 13                	jns    801055 <ltostr+0x2d>
	{
		neg = 1;
  801042:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80104f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801052:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80105d:	99                   	cltd   
  80105e:	f7 f9                	idiv   %ecx
  801060:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	8d 50 01             	lea    0x1(%eax),%edx
  801069:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801076:	83 c2 30             	add    $0x30,%edx
  801079:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80107b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801083:	f7 e9                	imul   %ecx
  801085:	c1 fa 02             	sar    $0x2,%edx
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	c1 f8 1f             	sar    $0x1f,%eax
  80108d:	29 c2                	sub    %eax,%edx
  80108f:	89 d0                	mov    %edx,%eax
  801091:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801094:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801097:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109c:	f7 e9                	imul   %ecx
  80109e:	c1 fa 02             	sar    $0x2,%edx
  8010a1:	89 c8                	mov    %ecx,%eax
  8010a3:	c1 f8 1f             	sar    $0x1f,%eax
  8010a6:	29 c2                	sub    %eax,%edx
  8010a8:	89 d0                	mov    %edx,%eax
  8010aa:	c1 e0 02             	shl    $0x2,%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	29 c1                	sub    %eax,%ecx
  8010b3:	89 ca                	mov    %ecx,%edx
  8010b5:	85 d2                	test   %edx,%edx
  8010b7:	75 9c                	jne    801055 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c3:	48                   	dec    %eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cb:	74 3d                	je     80110a <ltostr+0xe2>
		start = 1 ;
  8010cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d4:	eb 34                	jmp    80110a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	01 c2                	add    %eax,%edx
  8010ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801102:	88 02                	mov    %al,(%edx)
		start++ ;
  801104:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801107:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801110:	7c c4                	jl     8010d6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801112:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111d:	90                   	nop
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801126:	ff 75 08             	pushl  0x8(%ebp)
  801129:	e8 54 fa ff ff       	call   800b82 <strlen>
  80112e:	83 c4 04             	add    $0x4,%esp
  801131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	e8 46 fa ff ff       	call   800b82 <strlen>
  80113c:	83 c4 04             	add    $0x4,%esp
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801150:	eb 17                	jmp    801169 <strcconcat+0x49>
		final[s] = str1[s] ;
  801152:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	01 c2                	add    %eax,%edx
  80115a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	01 c8                	add    %ecx,%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801166:	ff 45 fc             	incl   -0x4(%ebp)
  801169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80116f:	7c e1                	jl     801152 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801171:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80117f:	eb 1f                	jmp    8011a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a6:	7c d9                	jl     801181 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b3:	90                   	nop
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	8b 00                	mov    (%eax),%eax
  8011c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d9:	eb 0c                	jmp    8011e7 <strsplit+0x31>
			*string++ = 0;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8d 50 01             	lea    0x1(%eax),%edx
  8011e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 18                	je     801208 <strsplit+0x52>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f be c0             	movsbl %al,%eax
  8011f8:	50                   	push   %eax
  8011f9:	ff 75 0c             	pushl  0xc(%ebp)
  8011fc:	e8 13 fb ff ff       	call   800d14 <strchr>
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	75 d3                	jne    8011db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	84 c0                	test   %al,%al
  80120f:	74 5a                	je     80126b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801211:	8b 45 14             	mov    0x14(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 f8 0f             	cmp    $0xf,%eax
  801219:	75 07                	jne    801222 <strsplit+0x6c>
		{
			return 0;
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
  801220:	eb 66                	jmp    801288 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801222:	8b 45 14             	mov    0x14(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	8d 48 01             	lea    0x1(%eax),%ecx
  80122a:	8b 55 14             	mov    0x14(%ebp),%edx
  80122d:	89 0a                	mov    %ecx,(%edx)
  80122f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801236:	8b 45 10             	mov    0x10(%ebp),%eax
  801239:	01 c2                	add    %eax,%edx
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801240:	eb 03                	jmp    801245 <strsplit+0x8f>
			string++;
  801242:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	84 c0                	test   %al,%al
  80124c:	74 8b                	je     8011d9 <strsplit+0x23>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	50                   	push   %eax
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	e8 b5 fa ff ff       	call   800d14 <strchr>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	74 dc                	je     801242 <strsplit+0x8c>
			string++;
	}
  801266:	e9 6e ff ff ff       	jmp    8011d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801278:	8b 45 10             	mov    0x10(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801283:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801290:	a1 28 30 80 00       	mov    0x803028,%eax
  801295:	85 c0                	test   %eax,%eax
  801297:	75 33                	jne    8012cc <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801299:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  8012a0:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  8012a3:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  8012aa:	00 00 a0 
		spaces[0].pages = numPages;
  8012ad:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  8012b4:	00 02 00 
		spaces[0].isFree = 1;
  8012b7:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  8012be:	00 00 00 
		arraySize++;
  8012c1:	a1 28 30 80 00       	mov    0x803028,%eax
  8012c6:	40                   	inc    %eax
  8012c7:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  8012cc:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  8012d3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  8012da:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8012e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012e7:	01 d0                	add    %edx,%eax
  8012e9:	48                   	dec    %eax
  8012ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f5:	f7 75 e8             	divl   -0x18(%ebp)
  8012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012fb:	29 d0                	sub    %edx,%eax
  8012fd:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	c1 e8 0c             	shr    $0xc,%eax
  801306:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801309:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801310:	eb 57                	jmp    801369 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801315:	c1 e0 04             	shl    $0x4,%eax
  801318:	05 2c 31 80 00       	add    $0x80312c,%eax
  80131d:	8b 00                	mov    (%eax),%eax
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 42                	je     801365 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801326:	c1 e0 04             	shl    $0x4,%eax
  801329:	05 28 31 80 00       	add    $0x803128,%eax
  80132e:	8b 00                	mov    (%eax),%eax
  801330:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801333:	7c 31                	jl     801366 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801335:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801338:	c1 e0 04             	shl    $0x4,%eax
  80133b:	05 28 31 80 00       	add    $0x803128,%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801345:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801348:	7d 1c                	jge    801366 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  80134a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134d:	c1 e0 04             	shl    $0x4,%eax
  801350:	05 28 31 80 00       	add    $0x803128,%eax
  801355:	8b 00                	mov    (%eax),%eax
  801357:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80135a:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  80135d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801360:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801363:	eb 01                	jmp    801366 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801365:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801366:	ff 45 ec             	incl   -0x14(%ebp)
  801369:	a1 28 30 80 00       	mov    0x803028,%eax
  80136e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801371:	7c 9f                	jl     801312 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801373:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801377:	75 0a                	jne    801383 <malloc+0xf9>
	{
		return NULL;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
  80137e:	e9 34 01 00 00       	jmp    8014b7 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	c1 e0 04             	shl    $0x4,%eax
  801389:	05 28 31 80 00       	add    $0x803128,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801393:	75 38                	jne    8013cd <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801398:	c1 e0 04             	shl    $0x4,%eax
  80139b:	05 2c 31 80 00       	add    $0x80312c,%eax
  8013a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  8013a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a9:	c1 e0 0c             	shl    $0xc,%eax
  8013ac:	89 c2                	mov    %eax,%edx
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	c1 e0 04             	shl    $0x4,%eax
  8013b4:	05 20 31 80 00       	add    $0x803120,%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	52                   	push   %edx
  8013bf:	50                   	push   %eax
  8013c0:	e8 01 06 00 00       	call   8019c6 <sys_allocateMem>
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	e9 dd 00 00 00       	jmp    8014aa <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	c1 e0 04             	shl    $0x4,%eax
  8013d3:	05 20 31 80 00       	add    $0x803120,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	c1 e2 0c             	shl    $0xc,%edx
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8013e5:	a1 28 30 80 00       	mov    0x803028,%eax
  8013ea:	c1 e0 04             	shl    $0x4,%eax
  8013ed:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  8013f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f6:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8013f8:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	c1 e0 04             	shl    $0x4,%eax
  801404:	05 24 31 80 00       	add    $0x803124,%eax
  801409:	8b 00                	mov    (%eax),%eax
  80140b:	c1 e2 04             	shl    $0x4,%edx
  80140e:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801414:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801416:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80141c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141f:	c1 e0 04             	shl    $0x4,%eax
  801422:	05 28 31 80 00       	add    $0x803128,%eax
  801427:	8b 00                	mov    (%eax),%eax
  801429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80142c:	c1 e2 04             	shl    $0x4,%edx
  80142f:	81 c2 28 31 80 00    	add    $0x803128,%edx
  801435:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801437:	a1 28 30 80 00       	mov    0x803028,%eax
  80143c:	c1 e0 04             	shl    $0x4,%eax
  80143f:	05 2c 31 80 00       	add    $0x80312c,%eax
  801444:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  80144a:	a1 28 30 80 00       	mov    0x803028,%eax
  80144f:	40                   	inc    %eax
  801450:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801458:	c1 e0 04             	shl    $0x4,%eax
  80145b:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  801461:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801464:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801469:	c1 e0 04             	shl    $0x4,%eax
  80146c:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  801472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801475:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147a:	c1 e0 04             	shl    $0x4,%eax
  80147d:	05 2c 31 80 00       	add    $0x80312c,%eax
  801482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148b:	c1 e0 0c             	shl    $0xc,%eax
  80148e:	89 c2                	mov    %eax,%edx
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	c1 e0 04             	shl    $0x4,%eax
  801496:	05 20 31 80 00       	add    $0x803120,%eax
  80149b:	8b 00                	mov    (%eax),%eax
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	52                   	push   %edx
  8014a1:	50                   	push   %eax
  8014a2:	e8 1f 05 00 00       	call   8019c6 <sys_allocateMem>
  8014a7:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	c1 e0 04             	shl    $0x4,%eax
  8014b0:	05 20 31 80 00       	add    $0x803120,%eax
  8014b5:	8b 00                	mov    (%eax),%eax
	}


}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  8014bf:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  8014c6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  8014cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8014d4:	eb 3f                	jmp    801515 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  8014d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d9:	c1 e0 04             	shl    $0x4,%eax
  8014dc:	05 20 31 80 00       	add    $0x803120,%eax
  8014e1:	8b 00                	mov    (%eax),%eax
  8014e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014e6:	75 2a                	jne    801512 <free+0x59>
		{
			index=i;
  8014e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  8014ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f1:	c1 e0 04             	shl    $0x4,%eax
  8014f4:	05 28 31 80 00       	add    $0x803128,%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	c1 e0 0c             	shl    $0xc,%eax
  8014fe:	89 c2                	mov    %eax,%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	e8 9d 04 00 00       	call   8019aa <sys_freeMem>
  80150d:	83 c4 10             	add    $0x10,%esp
			break;
  801510:	eb 0d                	jmp    80151f <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801512:	ff 45 ec             	incl   -0x14(%ebp)
  801515:	a1 28 30 80 00       	mov    0x803028,%eax
  80151a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80151d:	7c b7                	jl     8014d6 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  80151f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801523:	75 17                	jne    80153c <free+0x83>
	{
		panic("Error");
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	68 30 27 80 00       	push   $0x802730
  80152d:	68 81 00 00 00       	push   $0x81
  801532:	68 36 27 80 00       	push   $0x802736
  801537:	e8 22 ed ff ff       	call   80025e <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  80153c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801543:	e9 cc 00 00 00       	jmp    801614 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80154b:	c1 e0 04             	shl    $0x4,%eax
  80154e:	05 2c 31 80 00       	add    $0x80312c,%eax
  801553:	8b 00                	mov    (%eax),%eax
  801555:	85 c0                	test   %eax,%eax
  801557:	0f 84 b3 00 00 00    	je     801610 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  80155d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801560:	c1 e0 04             	shl    $0x4,%eax
  801563:	05 20 31 80 00       	add    $0x803120,%eax
  801568:	8b 10                	mov    (%eax),%edx
  80156a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156d:	c1 e0 04             	shl    $0x4,%eax
  801570:	05 24 31 80 00       	add    $0x803124,%eax
  801575:	8b 00                	mov    (%eax),%eax
  801577:	39 c2                	cmp    %eax,%edx
  801579:	0f 85 92 00 00 00    	jne    801611 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	c1 e0 04             	shl    $0x4,%eax
  801585:	05 24 31 80 00       	add    $0x803124,%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80158f:	c1 e2 04             	shl    $0x4,%edx
  801592:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801598:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  80159a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159d:	c1 e0 04             	shl    $0x4,%eax
  8015a0:	05 28 31 80 00       	add    $0x803128,%eax
  8015a5:	8b 10                	mov    (%eax),%edx
  8015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015aa:	c1 e0 04             	shl    $0x4,%eax
  8015ad:	05 28 31 80 00       	add    $0x803128,%eax
  8015b2:	8b 00                	mov    (%eax),%eax
  8015b4:	01 c2                	add    %eax,%edx
  8015b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b9:	c1 e0 04             	shl    $0x4,%eax
  8015bc:	05 28 31 80 00       	add    $0x803128,%eax
  8015c1:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	c1 e0 04             	shl    $0x4,%eax
  8015c9:	05 20 31 80 00       	add    $0x803120,%eax
  8015ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d7:	c1 e0 04             	shl    $0x4,%eax
  8015da:	05 24 31 80 00       	add    $0x803124,%eax
  8015df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8015e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e8:	c1 e0 04             	shl    $0x4,%eax
  8015eb:	05 28 31 80 00       	add    $0x803128,%eax
  8015f0:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f9:	c1 e0 04             	shl    $0x4,%eax
  8015fc:	05 2c 31 80 00       	add    $0x80312c,%eax
  801601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801607:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  80160e:	eb 12                	jmp    801622 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801610:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801611:	ff 45 e8             	incl   -0x18(%ebp)
  801614:	a1 28 30 80 00       	mov    0x803028,%eax
  801619:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80161c:	0f 8c 26 ff ff ff    	jl     801548 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801622:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801629:	e9 cc 00 00 00       	jmp    8016fa <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  80162e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801631:	c1 e0 04             	shl    $0x4,%eax
  801634:	05 2c 31 80 00       	add    $0x80312c,%eax
  801639:	8b 00                	mov    (%eax),%eax
  80163b:	85 c0                	test   %eax,%eax
  80163d:	0f 84 b3 00 00 00    	je     8016f6 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	c1 e0 04             	shl    $0x4,%eax
  801649:	05 24 31 80 00       	add    $0x803124,%eax
  80164e:	8b 10                	mov    (%eax),%edx
  801650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801653:	c1 e0 04             	shl    $0x4,%eax
  801656:	05 20 31 80 00       	add    $0x803120,%eax
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	39 c2                	cmp    %eax,%edx
  80165f:	0f 85 92 00 00 00    	jne    8016f7 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	c1 e0 04             	shl    $0x4,%eax
  80166b:	05 20 31 80 00       	add    $0x803120,%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801675:	c1 e2 04             	shl    $0x4,%edx
  801678:	81 c2 20 31 80 00    	add    $0x803120,%edx
  80167e:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801683:	c1 e0 04             	shl    $0x4,%eax
  801686:	05 28 31 80 00       	add    $0x803128,%eax
  80168b:	8b 10                	mov    (%eax),%edx
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	c1 e0 04             	shl    $0x4,%eax
  801693:	05 28 31 80 00       	add    $0x803128,%eax
  801698:	8b 00                	mov    (%eax),%eax
  80169a:	01 c2                	add    %eax,%edx
  80169c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169f:	c1 e0 04             	shl    $0x4,%eax
  8016a2:	05 28 31 80 00       	add    $0x803128,%eax
  8016a7:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	c1 e0 04             	shl    $0x4,%eax
  8016af:	05 20 31 80 00       	add    $0x803120,%eax
  8016b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	c1 e0 04             	shl    $0x4,%eax
  8016c0:	05 24 31 80 00       	add    $0x803124,%eax
  8016c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8016cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ce:	c1 e0 04             	shl    $0x4,%eax
  8016d1:	05 28 31 80 00       	add    $0x803128,%eax
  8016d6:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016df:	c1 e0 04             	shl    $0x4,%eax
  8016e2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8016ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8016f4:	eb 12                	jmp    801708 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8016f6:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8016f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8016fa:	a1 28 30 80 00       	mov    0x803028,%eax
  8016ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801702:	0f 8c 26 ff ff ff    	jl     80162e <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801708:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80170c:	75 11                	jne    80171f <free+0x266>
	{
		spaces[index].isFree = 1;
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	c1 e0 04             	shl    $0x4,%eax
  801714:	05 2c 31 80 00       	add    $0x80312c,%eax
  801719:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 18             	sub    $0x18,%esp
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	68 44 27 80 00       	push   $0x802744
  801736:	68 b9 00 00 00       	push   $0xb9
  80173b:	68 36 27 80 00       	push   $0x802736
  801740:	e8 19 eb ff ff       	call   80025e <_panic>

00801745 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 44 27 80 00       	push   $0x802744
  801753:	68 bf 00 00 00       	push   $0xbf
  801758:	68 36 27 80 00       	push   $0x802736
  80175d:	e8 fc ea ff ff       	call   80025e <_panic>

00801762 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	68 44 27 80 00       	push   $0x802744
  801770:	68 c5 00 00 00       	push   $0xc5
  801775:	68 36 27 80 00       	push   $0x802736
  80177a:	e8 df ea ff ff       	call   80025e <_panic>

0080177f <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 44 27 80 00       	push   $0x802744
  80178d:	68 ca 00 00 00       	push   $0xca
  801792:	68 36 27 80 00       	push   $0x802736
  801797:	e8 c2 ea ff ff       	call   80025e <_panic>

0080179c <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 44 27 80 00       	push   $0x802744
  8017aa:	68 d0 00 00 00       	push   $0xd0
  8017af:	68 36 27 80 00       	push   $0x802736
  8017b4:	e8 a5 ea ff ff       	call   80025e <_panic>

008017b9 <shrink>:
}
void shrink(uint32 newSize)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 44 27 80 00       	push   $0x802744
  8017c7:	68 d4 00 00 00       	push   $0xd4
  8017cc:	68 36 27 80 00       	push   $0x802736
  8017d1:	e8 88 ea ff ff       	call   80025e <_panic>

008017d6 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 44 27 80 00       	push   $0x802744
  8017e4:	68 d9 00 00 00       	push   $0xd9
  8017e9:	68 36 27 80 00       	push   $0x802736
  8017ee:	e8 6b ea ff ff       	call   80025e <_panic>

008017f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801805:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801808:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180e:	cd 30                	int    $0x30
  801810:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5f                   	pop    %edi
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	52                   	push   %edx
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	50                   	push   %eax
  80183a:	6a 00                	push   $0x0
  80183c:	e8 b2 ff ff ff       	call   8017f3 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_cgetc>:

int
sys_cgetc(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 01                	push   $0x1
  801856:	e8 98 ff ff ff       	call   8017f3 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	50                   	push   %eax
  80186f:	6a 05                	push   $0x5
  801871:	e8 7d ff ff ff       	call   8017f3 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 02                	push   $0x2
  80188a:	e8 64 ff ff ff       	call   8017f3 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 03                	push   $0x3
  8018a3:	e8 4b ff ff ff       	call   8017f3 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 04                	push   $0x4
  8018bc:	e8 32 ff ff ff       	call   8017f3 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_env_exit>:


void sys_env_exit(void)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 06                	push   $0x6
  8018d5:	e8 19 ff ff ff       	call   8017f3 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	52                   	push   %edx
  8018f0:	50                   	push   %eax
  8018f1:	6a 07                	push   $0x7
  8018f3:	e8 fb fe ff ff       	call   8017f3 <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801902:	8b 75 18             	mov    0x18(%ebp),%esi
  801905:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801908:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	56                   	push   %esi
  801912:	53                   	push   %ebx
  801913:	51                   	push   %ecx
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 08                	push   $0x8
  801918:	e8 d6 fe ff ff       	call   8017f3 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    

00801927 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 09                	push   $0x9
  80193a:	e8 b4 fe ff ff       	call   8017f3 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 0a                	push   $0xa
  801955:	e8 99 fe ff ff       	call   8017f3 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 0b                	push   $0xb
  80196e:	e8 80 fe ff ff       	call   8017f3 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 0c                	push   $0xc
  801987:	e8 67 fe ff ff       	call   8017f3 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 0d                	push   $0xd
  8019a0:	e8 4e fe ff ff       	call   8017f3 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	6a 11                	push   $0x11
  8019bb:	e8 33 fe ff ff       	call   8017f3 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
	return;
  8019c3:	90                   	nop
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 12                	push   $0x12
  8019d7:	e8 17 fe ff ff       	call   8017f3 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 0e                	push   $0xe
  8019f1:	e8 fd fd ff ff       	call   8017f3 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 08             	pushl  0x8(%ebp)
  801a09:	6a 0f                	push   $0xf
  801a0b:	e8 e3 fd ff ff       	call   8017f3 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 10                	push   $0x10
  801a24:	e8 ca fd ff ff       	call   8017f3 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	90                   	nop
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 14                	push   $0x14
  801a3e:	e8 b0 fd ff ff       	call   8017f3 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	90                   	nop
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 15                	push   $0x15
  801a58:	e8 96 fd ff ff       	call   8017f3 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	50                   	push   %eax
  801a7c:	6a 16                	push   $0x16
  801a7e:	e8 70 fd ff ff       	call   8017f3 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	90                   	nop
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 17                	push   $0x17
  801a98:	e8 56 fd ff ff       	call   8017f3 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	90                   	nop
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	50                   	push   %eax
  801ab3:	6a 18                	push   $0x18
  801ab5:	e8 39 fd ff ff       	call   8017f3 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	6a 1b                	push   $0x1b
  801ad2:	e8 1c fd ff ff       	call   8017f3 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 19                	push   $0x19
  801aef:	e8 ff fc ff ff       	call   8017f3 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	90                   	nop
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 1a                	push   $0x1a
  801b0d:	e8 e1 fc ff ff       	call   8017f3 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 04             	sub    $0x4,%esp
  801b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	51                   	push   %ecx
  801b31:	52                   	push   %edx
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	50                   	push   %eax
  801b36:	6a 1c                	push   $0x1c
  801b38:	e8 b6 fc ff ff       	call   8017f3 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 1d                	push   $0x1d
  801b55:	e8 99 fc ff ff       	call   8017f3 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 1e                	push   $0x1e
  801b74:	e8 7a fc ff ff       	call   8017f3 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	52                   	push   %edx
  801b8e:	50                   	push   %eax
  801b8f:	6a 1f                	push   $0x1f
  801b91:	e8 5d fc ff ff       	call   8017f3 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 20                	push   $0x20
  801baa:	e8 44 fc ff ff       	call   8017f3 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	ff 75 14             	pushl  0x14(%ebp)
  801bbf:	ff 75 10             	pushl  0x10(%ebp)
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	50                   	push   %eax
  801bc6:	6a 21                	push   $0x21
  801bc8:	e8 26 fc ff ff       	call   8017f3 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	50                   	push   %eax
  801be1:	6a 22                	push   $0x22
  801be3:	e8 0b fc ff ff       	call   8017f3 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	90                   	nop
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	50                   	push   %eax
  801bfd:	6a 23                	push   $0x23
  801bff:	e8 ef fb ff ff       	call   8017f3 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c10:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c13:	8d 50 04             	lea    0x4(%eax),%edx
  801c16:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	6a 24                	push   $0x24
  801c23:	e8 cb fb ff ff       	call   8017f3 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c34:	89 01                	mov    %eax,(%ecx)
  801c36:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	c9                   	leave  
  801c3d:	c2 04 00             	ret    $0x4

00801c40 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	ff 75 10             	pushl  0x10(%ebp)
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	6a 13                	push   $0x13
  801c52:	e8 9c fb ff ff       	call   8017f3 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 25                	push   $0x25
  801c6c:	e8 82 fb ff ff       	call   8017f3 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c82:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	50                   	push   %eax
  801c8f:	6a 26                	push   $0x26
  801c91:	e8 5d fb ff ff       	call   8017f3 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return ;
  801c99:	90                   	nop
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <rsttst>:
void rsttst()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 28                	push   $0x28
  801cab:	e8 43 fb ff ff       	call   8017f3 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb3:	90                   	nop
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc2:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	6a 27                	push   $0x27
  801cd6:	e8 18 fb ff ff       	call   8017f3 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <chktst>:
void chktst(uint32 n)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	6a 29                	push   $0x29
  801cf1:	e8 fd fa ff ff       	call   8017f3 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf9:	90                   	nop
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <inctst>:

void inctst()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 2a                	push   $0x2a
  801d0b:	e8 e3 fa ff ff       	call   8017f3 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
	return ;
  801d13:	90                   	nop
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <gettst>:
uint32 gettst()
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 2b                	push   $0x2b
  801d25:	e8 c9 fa ff ff       	call   8017f3 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 2c                	push   $0x2c
  801d41:	e8 ad fa ff ff       	call   8017f3 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
  801d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d50:	75 07                	jne    801d59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	eb 05                	jmp    801d5e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 2c                	push   $0x2c
  801d72:	e8 7c fa ff ff       	call   8017f3 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
  801d7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d81:	75 07                	jne    801d8a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d83:	b8 01 00 00 00       	mov    $0x1,%eax
  801d88:	eb 05                	jmp    801d8f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 2c                	push   $0x2c
  801da3:	e8 4b fa ff ff       	call   8017f3 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
  801dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dae:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db2:	75 07                	jne    801dbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db4:	b8 01 00 00 00       	mov    $0x1,%eax
  801db9:	eb 05                	jmp    801dc0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 2c                	push   $0x2c
  801dd4:	e8 1a fa ff ff       	call   8017f3 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
  801ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ddf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de3:	75 07                	jne    801dec <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dea:	eb 05                	jmp    801df1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	6a 2d                	push   $0x2d
  801e03:	e8 eb f9 ff ff       	call   8017f3 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e12:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	53                   	push   %ebx
  801e21:	51                   	push   %ecx
  801e22:	52                   	push   %edx
  801e23:	50                   	push   %eax
  801e24:	6a 2e                	push   $0x2e
  801e26:	e8 c8 f9 ff ff       	call   8017f3 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	52                   	push   %edx
  801e43:	50                   	push   %eax
  801e44:	6a 2f                	push   $0x2f
  801e46:	e8 a8 f9 ff ff       	call   8017f3 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
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
