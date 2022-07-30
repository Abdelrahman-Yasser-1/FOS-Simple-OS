
obj/user/tst6:     file format elf32-i386


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
  800031:	e8 4d 06 00 00       	call   800683 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
	

	rsttst();
  800041:	e8 f2 1f 00 00       	call   802038 <rsttst>
	
	

	int Mega = 1024*1024;
  800046:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80004d:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	void* ptr_allocations[20] = {0};
  800054:	8d 55 88             	lea    -0x78(%ebp),%edx
  800057:	b9 14 00 00 00       	mov    $0x14,%ecx
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	89 d7                	mov    %edx,%edi
  800063:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	68 01 00 00 20       	push   $0x20000001
  80006d:	e8 b4 15 00 00       	call   801626 <malloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[0], 0,0, 'b', 0);
  800078:	8b 45 88             	mov    -0x78(%ebp),%eax
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	6a 00                	push   $0x0
  800080:	6a 62                	push   $0x62
  800082:	6a 00                	push   $0x0
  800084:	6a 00                	push   $0x0
  800086:	50                   	push   %eax
  800087:	e8 c6 1f 00 00       	call   802052 <tst>
  80008c:	83 c4 20             	add    $0x20,%esp

	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  80008f:	e8 67 1c 00 00       	call   801cfb <sys_calculate_free_frames>
  800094:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009a:	01 c0                	add    %eax,%eax
  80009c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	50                   	push   %eax
  8000a3:	e8 7e 15 00 00       	call   801626 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  8000ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	6a 62                	push   $0x62
  8000b8:	68 00 10 00 80       	push   $0x80001000
  8000bd:	68 00 00 00 80       	push   $0x80000000
  8000c2:	50                   	push   %eax
  8000c3:	e8 8a 1f 00 00       	call   802052 <tst>
  8000c8:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  8000cb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8000ce:	e8 28 1c 00 00       	call   801cfb <sys_calculate_free_frames>
  8000d3:	29 c3                	sub    %eax,%ebx
  8000d5:	89 d8                	mov    %ebx,%eax
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	6a 00                	push   $0x0
  8000dc:	6a 65                	push   $0x65
  8000de:	6a 00                	push   $0x0
  8000e0:	68 01 02 00 00       	push   $0x201
  8000e5:	50                   	push   %eax
  8000e6:	e8 67 1f 00 00       	call   802052 <tst>
  8000eb:	83 c4 20             	add    $0x20,%esp

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  8000ee:	e8 08 1c 00 00       	call   801cfb <sys_calculate_free_frames>
  8000f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  8000f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f9:	01 c0                	add    %eax,%eax
  8000fb:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 1f 15 00 00       	call   801626 <malloc>
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START+ 2*Mega,USER_HEAP_START + 2*Mega+ PAGE_SIZE, 'b', 0);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	01 c0                	add    %eax,%eax
  800112:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011b:	01 c0                	add    %eax,%eax
  80011d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800123:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800126:	83 ec 0c             	sub    $0xc,%esp
  800129:	6a 00                	push   $0x0
  80012b:	6a 62                	push   $0x62
  80012d:	51                   	push   %ecx
  80012e:	52                   	push   %edx
  80012f:	50                   	push   %eax
  800130:	e8 1d 1f 00 00       	call   802052 <tst>
  800135:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  800138:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80013b:	e8 bb 1b 00 00       	call   801cfb <sys_calculate_free_frames>
  800140:	29 c3                	sub    %eax,%ebx
  800142:	89 d8                	mov    %ebx,%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	6a 00                	push   $0x0
  800149:	6a 65                	push   $0x65
  80014b:	6a 00                	push   $0x0
  80014d:	68 00 02 00 00       	push   $0x200
  800152:	50                   	push   %eax
  800153:	e8 fa 1e 00 00       	call   802052 <tst>
  800158:	83 c4 20             	add    $0x20,%esp

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 9b 1b 00 00       	call   801cfb <sys_calculate_free_frames>
  800160:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800166:	01 c0                	add    %eax,%eax
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	50                   	push   %eax
  80016c:	e8 b5 14 00 00       	call   801626 <malloc>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START+ 4*Mega,USER_HEAP_START + 4*Mega+ PAGE_SIZE, 'b', 0);
  800177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017a:	c1 e0 02             	shl    $0x2,%eax
  80017d:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800186:	c1 e0 02             	shl    $0x2,%eax
  800189:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80018f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	6a 00                	push   $0x0
  800197:	6a 62                	push   $0x62
  800199:	51                   	push   %ecx
  80019a:	52                   	push   %edx
  80019b:	50                   	push   %eax
  80019c:	e8 b1 1e 00 00       	call   802052 <tst>
  8001a1:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1+1 ,0, 'e', 0);
  8001a4:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001a7:	e8 4f 1b 00 00       	call   801cfb <sys_calculate_free_frames>
  8001ac:	29 c3                	sub    %eax,%ebx
  8001ae:	89 d8                	mov    %ebx,%eax
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	6a 00                	push   $0x0
  8001b5:	6a 65                	push   $0x65
  8001b7:	6a 00                	push   $0x0
  8001b9:	6a 02                	push   $0x2
  8001bb:	50                   	push   %eax
  8001bc:	e8 91 1e 00 00       	call   802052 <tst>
  8001c1:	83 c4 20             	add    $0x20,%esp

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001c4:	e8 32 1b 00 00       	call   801cfb <sys_calculate_free_frames>
  8001c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8001cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cf:	01 c0                	add    %eax,%eax
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	e8 4c 14 00 00       	call   801626 <malloc>
  8001da:	83 c4 10             	add    $0x10,%esp
  8001dd:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START+ 4*Mega+ 4*kilo,USER_HEAP_START + 4*Mega+ 4*kilo+ PAGE_SIZE, 'b', 0);
  8001e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e3:	c1 e0 02             	shl    $0x2,%eax
  8001e6:	89 c2                	mov    %eax,%edx
  8001e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	01 d0                	add    %edx,%eax
  8001f0:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f9:	c1 e0 02             	shl    $0x2,%eax
  8001fc:	89 c2                	mov    %eax,%edx
  8001fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800201:	c1 e0 02             	shl    $0x2,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80020c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	6a 00                	push   $0x0
  800214:	6a 62                	push   $0x62
  800216:	51                   	push   %ecx
  800217:	52                   	push   %edx
  800218:	50                   	push   %eax
  800219:	e8 34 1e 00 00       	call   802052 <tst>
  80021e:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1 ,0, 'e', 0);
  800221:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800224:	e8 d2 1a 00 00       	call   801cfb <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 d8                	mov    %ebx,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 00                	push   $0x0
  800232:	6a 65                	push   $0x65
  800234:	6a 00                	push   $0x0
  800236:	6a 01                	push   $0x1
  800238:	50                   	push   %eax
  800239:	e8 14 1e 00 00       	call   802052 <tst>
  80023e:	83 c4 20             	add    $0x20,%esp

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  800241:	e8 b5 1a 00 00       	call   801cfb <sys_calculate_free_frames>
  800246:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  800249:	8b 45 90             	mov    -0x70(%ebp),%eax
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	e8 00 16 00 00       	call   801855 <free>
  800255:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 1,0, 'e', 0);
  800258:	e8 9e 1a 00 00       	call   801cfb <sys_calculate_free_frames>
  80025d:	89 c2                	mov    %eax,%edx
  80025f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800262:	29 c2                	sub    %eax,%edx
  800264:	89 d0                	mov    %edx,%eax
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	6a 00                	push   $0x0
  80026b:	6a 65                	push   $0x65
  80026d:	6a 00                	push   $0x0
  80026f:	6a 01                	push   $0x1
  800271:	50                   	push   %eax
  800272:	e8 db 1d 00 00       	call   802052 <tst>
  800277:	83 c4 20             	add    $0x20,%esp

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 7c 1a 00 00       	call   801cfb <sys_calculate_free_frames>
  80027f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800282:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800285:	89 d0                	mov    %edx,%eax
  800287:	01 c0                	add    %eax,%eax
  800289:	01 d0                	add    %edx,%eax
  80028b:	01 c0                	add    %eax,%eax
  80028d:	01 d0                	add    %edx,%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 8e 13 00 00       	call   801626 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START+ 4*Mega+ 8*kilo,USER_HEAP_START + 4*Mega+ 8*kilo+ PAGE_SIZE, 'b', 0);
  80029e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a1:	c1 e0 02             	shl    $0x2,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	c1 e0 03             	shl    $0x3,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b7:	c1 e0 02             	shl    $0x2,%eax
  8002ba:	89 c2                	mov    %eax,%edx
  8002bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002bf:	c1 e0 03             	shl    $0x3,%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002ca:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	6a 00                	push   $0x0
  8002d2:	6a 62                	push   $0x62
  8002d4:	51                   	push   %ecx
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	e8 76 1d 00 00       	call   802052 <tst>
  8002dc:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 2,0, 'e', 0);
  8002df:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002e2:	e8 14 1a 00 00       	call   801cfb <sys_calculate_free_frames>
  8002e7:	29 c3                	sub    %eax,%ebx
  8002e9:	89 d8                	mov    %ebx,%eax
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	6a 00                	push   $0x0
  8002f0:	6a 65                	push   $0x65
  8002f2:	6a 00                	push   $0x0
  8002f4:	6a 02                	push   $0x2
  8002f6:	50                   	push   %eax
  8002f7:	e8 56 1d 00 00       	call   802052 <tst>
  8002fc:	83 c4 20             	add    $0x20,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 f7 19 00 00       	call   801cfb <sys_calculate_free_frames>
  800304:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[0]);
  800307:	8b 45 88             	mov    -0x78(%ebp),%eax
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	50                   	push   %eax
  80030e:	e8 42 15 00 00       	call   801855 <free>
  800313:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512,0, 'e', 0);
  800316:	e8 e0 19 00 00       	call   801cfb <sys_calculate_free_frames>
  80031b:	89 c2                	mov    %eax,%edx
  80031d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800320:	29 c2                	sub    %eax,%edx
  800322:	89 d0                	mov    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	6a 00                	push   $0x0
  800329:	6a 65                	push   $0x65
  80032b:	6a 00                	push   $0x0
  80032d:	68 00 02 00 00       	push   $0x200
  800332:	50                   	push   %eax
  800333:	e8 1a 1d 00 00       	call   802052 <tst>
  800338:	83 c4 20             	add    $0x20,%esp

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  80033b:	e8 bb 19 00 00       	call   801cfb <sys_calculate_free_frames>
  800340:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800346:	89 c2                	mov    %eax,%edx
  800348:	01 d2                	add    %edx,%edx
  80034a:	01 d0                	add    %edx,%eax
  80034c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	50                   	push   %eax
  800353:	e8 ce 12 00 00       	call   801626 <malloc>
  800358:	83 c4 10             	add    $0x10,%esp
  80035b:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START+ 4*Mega+ 16*kilo,USER_HEAP_START + 4*Mega+ 16*kilo+ PAGE_SIZE, 'b', 0);
  80035e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800361:	c1 e0 02             	shl    $0x2,%eax
  800364:	89 c2                	mov    %eax,%edx
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	c1 e0 04             	shl    $0x4,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	c1 e0 02             	shl    $0x2,%eax
  80037a:	89 c2                	mov    %eax,%edx
  80037c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037f:	c1 e0 04             	shl    $0x4,%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80038a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	6a 00                	push   $0x0
  800392:	6a 62                	push   $0x62
  800394:	51                   	push   %ecx
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	e8 b6 1c 00 00       	call   802052 <tst>
  80039c:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 3*Mega/4096 ,0, 'e', 0);
  80039f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	01 d2                	add    %edx,%edx
  8003a6:	01 d0                	add    %edx,%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	79 05                	jns    8003b1 <_main+0x379>
  8003ac:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003b1:	c1 f8 0c             	sar    $0xc,%eax
  8003b4:	89 c3                	mov    %eax,%ebx
  8003b6:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8003b9:	e8 3d 19 00 00       	call   801cfb <sys_calculate_free_frames>
  8003be:	29 c6                	sub    %eax,%esi
  8003c0:	89 f0                	mov    %esi,%eax
  8003c2:	83 ec 0c             	sub    $0xc,%esp
  8003c5:	6a 00                	push   $0x0
  8003c7:	6a 65                	push   $0x65
  8003c9:	6a 00                	push   $0x0
  8003cb:	53                   	push   %ebx
  8003cc:	50                   	push   %eax
  8003cd:	e8 80 1c 00 00       	call   802052 <tst>
  8003d2:	83 c4 20             	add    $0x20,%esp

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  8003d5:	e8 21 19 00 00       	call   801cfb <sys_calculate_free_frames>
  8003da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  8003dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e0:	89 c2                	mov    %eax,%edx
  8003e2:	01 d2                	add    %edx,%edx
  8003e4:	01 c2                	add    %eax,%edx
  8003e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	01 c0                	add    %eax,%eax
  8003ed:	83 ec 0c             	sub    $0xc,%esp
  8003f0:	50                   	push   %eax
  8003f1:	e8 30 12 00 00       	call   801626 <malloc>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START+ 7*Mega+ 16*kilo,USER_HEAP_START + 7*Mega+ 16*kilo+ PAGE_SIZE, 'b', 0);
  8003fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	01 c0                	add    %eax,%eax
  800403:	01 d0                	add    %edx,%eax
  800405:	01 c0                	add    %eax,%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	89 c2                	mov    %eax,%edx
  80040b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040e:	c1 e0 04             	shl    $0x4,%eax
  800411:	01 d0                	add    %edx,%eax
  800413:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	01 c0                	add    %eax,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042b:	c1 e0 04             	shl    $0x4,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800436:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	6a 00                	push   $0x0
  80043e:	6a 62                	push   $0x62
  800440:	51                   	push   %ecx
  800441:	52                   	push   %edx
  800442:	50                   	push   %eax
  800443:	e8 0a 1c 00 00       	call   802052 <tst>
  800448:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 514+1 ,0, 'e', 0);
  80044b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80044e:	e8 a8 18 00 00       	call   801cfb <sys_calculate_free_frames>
  800453:	29 c3                	sub    %eax,%ebx
  800455:	89 d8                	mov    %ebx,%eax
  800457:	83 ec 0c             	sub    $0xc,%esp
  80045a:	6a 00                	push   $0x0
  80045c:	6a 65                	push   $0x65
  80045e:	6a 00                	push   $0x0
  800460:	68 03 02 00 00       	push   $0x203
  800465:	50                   	push   %eax
  800466:	e8 e7 1b 00 00       	call   802052 <tst>
  80046b:	83 c4 20             	add    $0x20,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80046e:	e8 88 18 00 00       	call   801cfb <sys_calculate_free_frames>
  800473:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[5]);
  800476:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	50                   	push   %eax
  80047d:	e8 d3 13 00 00       	call   801855 <free>
  800482:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 768,0, 'e', 0);
  800485:	e8 71 18 00 00       	call   801cfb <sys_calculate_free_frames>
  80048a:	89 c2                	mov    %eax,%edx
  80048c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80048f:	29 c2                	sub    %eax,%edx
  800491:	89 d0                	mov    %edx,%eax
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	6a 00                	push   $0x0
  800498:	6a 65                	push   $0x65
  80049a:	6a 00                	push   $0x0
  80049c:	68 00 03 00 00       	push   $0x300
  8004a1:	50                   	push   %eax
  8004a2:	e8 ab 1b 00 00       	call   802052 <tst>
  8004a7:	83 c4 20             	add    $0x20,%esp

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004aa:	e8 4c 18 00 00       	call   801cfb <sys_calculate_free_frames>
  8004af:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004b5:	89 d0                	mov    %edx,%eax
  8004b7:	c1 e0 02             	shl    $0x2,%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004bf:	83 ec 0c             	sub    $0xc,%esp
  8004c2:	50                   	push   %eax
  8004c3:	e8 5e 11 00 00       	call   801626 <malloc>
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tst((uint32) ptr_allocations[7], USER_HEAP_START+ 9*Mega+ 24*kilo,USER_HEAP_START + 9*Mega+ 24*kilo+ PAGE_SIZE, 'b', 0);
  8004ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004d1:	89 d0                	mov    %edx,%eax
  8004d3:	c1 e0 03             	shl    $0x3,%eax
  8004d6:	01 d0                	add    %edx,%eax
  8004d8:	89 c1                	mov    %eax,%ecx
  8004da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8004ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004f1:	89 d0                	mov    %edx,%eax
  8004f3:	c1 e0 03             	shl    $0x3,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	89 c3                	mov    %eax,%ebx
  8004fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 d8                	add    %ebx,%eax
  800508:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80050e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	6a 00                	push   $0x0
  800516:	6a 62                	push   $0x62
  800518:	51                   	push   %ecx
  800519:	52                   	push   %edx
  80051a:	50                   	push   %eax
  80051b:	e8 32 1b 00 00       	call   802052 <tst>
  800520:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 5*Mega/4096 + 1,0, 'e', 0);
  800523:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	85 c0                	test   %eax,%eax
  80052f:	79 05                	jns    800536 <_main+0x4fe>
  800531:	05 ff 0f 00 00       	add    $0xfff,%eax
  800536:	c1 f8 0c             	sar    $0xc,%eax
  800539:	40                   	inc    %eax
  80053a:	89 c3                	mov    %eax,%ebx
  80053c:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80053f:	e8 b7 17 00 00       	call   801cfb <sys_calculate_free_frames>
  800544:	29 c6                	sub    %eax,%esi
  800546:	89 f0                	mov    %esi,%eax
  800548:	83 ec 0c             	sub    $0xc,%esp
  80054b:	6a 00                	push   $0x0
  80054d:	6a 65                	push   $0x65
  80054f:	6a 00                	push   $0x0
  800551:	53                   	push   %ebx
  800552:	50                   	push   %eax
  800553:	e8 fa 1a 00 00       	call   802052 <tst>
  800558:	83 c4 20             	add    $0x20,%esp

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80055b:	e8 9b 17 00 00       	call   801cfb <sys_calculate_free_frames>
  800560:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  800563:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800566:	83 ec 0c             	sub    $0xc,%esp
  800569:	50                   	push   %eax
  80056a:	e8 e6 12 00 00       	call   801855 <free>
  80056f:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 514,0, 'e', 0);
  800572:	e8 84 17 00 00       	call   801cfb <sys_calculate_free_frames>
  800577:	89 c2                	mov    %eax,%edx
  800579:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 d0                	mov    %edx,%eax
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	6a 00                	push   $0x0
  800585:	6a 65                	push   $0x65
  800587:	6a 00                	push   $0x0
  800589:	68 02 02 00 00       	push   $0x202
  80058e:	50                   	push   %eax
  80058f:	e8 be 1a 00 00       	call   802052 <tst>
  800594:	83 c4 20             	add    $0x20,%esp

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800597:	e8 5f 17 00 00       	call   801cfb <sys_calculate_free_frames>
  80059c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(4*Mega-kilo);
  80059f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a2:	c1 e0 02             	shl    $0x2,%eax
  8005a5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005a8:	83 ec 0c             	sub    $0xc,%esp
  8005ab:	50                   	push   %eax
  8005ac:	e8 75 10 00 00       	call   801626 <malloc>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		tst((uint32) ptr_allocations[8], USER_HEAP_START+ 4*Mega+ 16*kilo,USER_HEAP_START + 4*Mega+ 16*kilo+ PAGE_SIZE, 'b', 0);
  8005b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ba:	c1 e0 02             	shl    $0x2,%eax
  8005bd:	89 c2                	mov    %eax,%edx
  8005bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c2:	c1 e0 04             	shl    $0x4,%eax
  8005c5:	01 d0                	add    %edx,%eax
  8005c7:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8005cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d0:	c1 e0 02             	shl    $0x2,%eax
  8005d3:	89 c2                	mov    %eax,%edx
  8005d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d8:	c1 e0 04             	shl    $0x4,%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8005e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	6a 00                	push   $0x0
  8005eb:	6a 62                	push   $0x62
  8005ed:	51                   	push   %ecx
  8005ee:	52                   	push   %edx
  8005ef:	50                   	push   %eax
  8005f0:	e8 5d 1a 00 00       	call   802052 <tst>
  8005f5:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 4*Mega/4096,0, 'e', 0);
  8005f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005fb:	c1 e0 02             	shl    $0x2,%eax
  8005fe:	85 c0                	test   %eax,%eax
  800600:	79 05                	jns    800607 <_main+0x5cf>
  800602:	05 ff 0f 00 00       	add    $0xfff,%eax
  800607:	c1 f8 0c             	sar    $0xc,%eax
  80060a:	89 c3                	mov    %eax,%ebx
  80060c:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80060f:	e8 e7 16 00 00       	call   801cfb <sys_calculate_free_frames>
  800614:	29 c6                	sub    %eax,%esi
  800616:	89 f0                	mov    %esi,%eax
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	6a 00                	push   $0x0
  80061d:	6a 65                	push   $0x65
  80061f:	6a 00                	push   $0x0
  800621:	53                   	push   %ebx
  800622:	50                   	push   %eax
  800623:	e8 2a 1a 00 00       	call   802052 <tst>
  800628:	83 c4 20             	add    $0x20,%esp
	}

	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		int freeFrames = sys_calculate_free_frames() ;
  80062b:	e8 cb 16 00 00       	call   801cfb <sys_calculate_free_frames>
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START + 14*Mega));
  800633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800636:	89 d0                	mov    %edx,%eax
  800638:	01 c0                	add    %eax,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	01 c0                	add    %eax,%eax
  800642:	05 00 00 00 20       	add    $0x20000000,%eax
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	50                   	push   %eax
  80064b:	e8 d6 0f 00 00       	call   801626 <malloc>
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	89 45 ac             	mov    %eax,-0x54(%ebp)
		tst((uint32) ptr_allocations[9], 0,0, 'b', 0);
  800656:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800659:	83 ec 0c             	sub    $0xc,%esp
  80065c:	6a 00                	push   $0x0
  80065e:	6a 62                	push   $0x62
  800660:	6a 00                	push   $0x0
  800662:	6a 00                	push   $0x0
  800664:	50                   	push   %eax
  800665:	e8 e8 19 00 00       	call   802052 <tst>
  80066a:	83 c4 20             	add    $0x20,%esp

		chktst(24);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	6a 18                	push   $0x18
  800672:	e8 06 1a 00 00       	call   80207d <chktst>
  800677:	83 c4 10             	add    $0x10,%esp

		return;
  80067a:	90                   	nop
	}
}
  80067b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067e:	5b                   	pop    %ebx
  80067f:	5e                   	pop    %esi
  800680:	5f                   	pop    %edi
  800681:	5d                   	pop    %ebp
  800682:	c3                   	ret    

00800683 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800689:	e8 a2 15 00 00       	call   801c30 <sys_getenvindex>
  80068e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800691:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800694:	89 d0                	mov    %edx,%eax
  800696:	c1 e0 03             	shl    $0x3,%eax
  800699:	01 d0                	add    %edx,%eax
  80069b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006a2:	01 c8                	add    %ecx,%eax
  8006a4:	01 c0                	add    %eax,%eax
  8006a6:	01 d0                	add    %edx,%eax
  8006a8:	01 c0                	add    %eax,%eax
  8006aa:	01 d0                	add    %edx,%eax
  8006ac:	89 c2                	mov    %eax,%edx
  8006ae:	c1 e2 05             	shl    $0x5,%edx
  8006b1:	29 c2                	sub    %eax,%edx
  8006b3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8006ba:	89 c2                	mov    %eax,%edx
  8006bc:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006c2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006cc:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8006d2:	84 c0                	test   %al,%al
  8006d4:	74 0f                	je     8006e5 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8006d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006db:	05 40 3c 01 00       	add    $0x13c40,%eax
  8006e0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006e9:	7e 0a                	jle    8006f5 <libmain+0x72>
		binaryname = argv[0];
  8006eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	ff 75 08             	pushl  0x8(%ebp)
  8006fe:	e8 35 f9 ff ff       	call   800038 <_main>
  800703:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800706:	e8 c0 16 00 00       	call   801dcb <sys_disable_interrupt>
	cprintf("**************************************\n");
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	68 38 26 80 00       	push   $0x802638
  800713:	e8 84 01 00 00       	call   80089c <cprintf>
  800718:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80071b:	a1 20 30 80 00       	mov    0x803020,%eax
  800720:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800726:	a1 20 30 80 00       	mov    0x803020,%eax
  80072b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800731:	83 ec 04             	sub    $0x4,%esp
  800734:	52                   	push   %edx
  800735:	50                   	push   %eax
  800736:	68 60 26 80 00       	push   $0x802660
  80073b:	e8 5c 01 00 00       	call   80089c <cprintf>
  800740:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800743:	a1 20 30 80 00       	mov    0x803020,%eax
  800748:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80074e:	a1 20 30 80 00       	mov    0x803020,%eax
  800753:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	52                   	push   %edx
  80075d:	50                   	push   %eax
  80075e:	68 88 26 80 00       	push   $0x802688
  800763:	e8 34 01 00 00       	call   80089c <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80076b:	a1 20 30 80 00       	mov    0x803020,%eax
  800770:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 c9 26 80 00       	push   $0x8026c9
  80077f:	e8 18 01 00 00       	call   80089c <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800787:	83 ec 0c             	sub    $0xc,%esp
  80078a:	68 38 26 80 00       	push   $0x802638
  80078f:	e8 08 01 00 00       	call   80089c <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800797:	e8 49 16 00 00       	call   801de5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80079c:	e8 19 00 00 00       	call   8007ba <exit>
}
  8007a1:	90                   	nop
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	6a 00                	push   $0x0
  8007af:	e8 48 14 00 00       	call   801bfc <sys_env_destroy>
  8007b4:	83 c4 10             	add    $0x10,%esp
}
  8007b7:	90                   	nop
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <exit>:

void
exit(void)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8007c0:	e8 9d 14 00 00       	call   801c62 <sys_env_exit>
}
  8007c5:	90                   	nop
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8007d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d9:	89 0a                	mov    %ecx,(%edx)
  8007db:	8b 55 08             	mov    0x8(%ebp),%edx
  8007de:	88 d1                	mov    %dl,%cl
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007f1:	75 2c                	jne    80081f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007f3:	a0 24 30 80 00       	mov    0x803024,%al
  8007f8:	0f b6 c0             	movzbl %al,%eax
  8007fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fe:	8b 12                	mov    (%edx),%edx
  800800:	89 d1                	mov    %edx,%ecx
  800802:	8b 55 0c             	mov    0xc(%ebp),%edx
  800805:	83 c2 08             	add    $0x8,%edx
  800808:	83 ec 04             	sub    $0x4,%esp
  80080b:	50                   	push   %eax
  80080c:	51                   	push   %ecx
  80080d:	52                   	push   %edx
  80080e:	e8 a7 13 00 00       	call   801bba <sys_cputs>
  800813:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800816:	8b 45 0c             	mov    0xc(%ebp),%eax
  800819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80081f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800822:	8b 40 04             	mov    0x4(%eax),%eax
  800825:	8d 50 01             	lea    0x1(%eax),%edx
  800828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80082e:	90                   	nop
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80083a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800841:	00 00 00 
	b.cnt = 0;
  800844:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80084b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80085a:	50                   	push   %eax
  80085b:	68 c8 07 80 00       	push   $0x8007c8
  800860:	e8 11 02 00 00       	call   800a76 <vprintfmt>
  800865:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800868:	a0 24 30 80 00       	mov    0x803024,%al
  80086d:	0f b6 c0             	movzbl %al,%eax
  800870:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	50                   	push   %eax
  80087a:	52                   	push   %edx
  80087b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800881:	83 c0 08             	add    $0x8,%eax
  800884:	50                   	push   %eax
  800885:	e8 30 13 00 00       	call   801bba <sys_cputs>
  80088a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80088d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800894:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <cprintf>:

int cprintf(const char *fmt, ...) {
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008a2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8008a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b8:	50                   	push   %eax
  8008b9:	e8 73 ff ff ff       	call   800831 <vcprintf>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8008cf:	e8 f7 14 00 00       	call   801dcb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e3:	50                   	push   %eax
  8008e4:	e8 48 ff ff ff       	call   800831 <vcprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
  8008ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008ef:	e8 f1 14 00 00       	call   801de5 <sys_enable_interrupt>
	return cnt;
  8008f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	83 ec 14             	sub    $0x14,%esp
  800900:	8b 45 10             	mov    0x10(%ebp),%eax
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80090c:	8b 45 18             	mov    0x18(%ebp),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800917:	77 55                	ja     80096e <printnum+0x75>
  800919:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80091c:	72 05                	jb     800923 <printnum+0x2a>
  80091e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800921:	77 4b                	ja     80096e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800923:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800926:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800929:	8b 45 18             	mov    0x18(%ebp),%eax
  80092c:	ba 00 00 00 00       	mov    $0x0,%edx
  800931:	52                   	push   %edx
  800932:	50                   	push   %eax
  800933:	ff 75 f4             	pushl  -0xc(%ebp)
  800936:	ff 75 f0             	pushl  -0x10(%ebp)
  800939:	e8 7e 1a 00 00       	call   8023bc <__udivdi3>
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	ff 75 20             	pushl  0x20(%ebp)
  800947:	53                   	push   %ebx
  800948:	ff 75 18             	pushl  0x18(%ebp)
  80094b:	52                   	push   %edx
  80094c:	50                   	push   %eax
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 a1 ff ff ff       	call   8008f9 <printnum>
  800958:	83 c4 20             	add    $0x20,%esp
  80095b:	eb 1a                	jmp    800977 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	ff 75 20             	pushl  0x20(%ebp)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	ff d0                	call   *%eax
  80096b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80096e:	ff 4d 1c             	decl   0x1c(%ebp)
  800971:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800975:	7f e6                	jg     80095d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800977:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80097a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80097f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800985:	53                   	push   %ebx
  800986:	51                   	push   %ecx
  800987:	52                   	push   %edx
  800988:	50                   	push   %eax
  800989:	e8 3e 1b 00 00       	call   8024cc <__umoddi3>
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	05 f4 28 80 00       	add    $0x8028f4,%eax
  800996:	8a 00                	mov    (%eax),%al
  800998:	0f be c0             	movsbl %al,%eax
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
}
  8009aa:	90                   	nop
  8009ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009b7:	7e 1c                	jle    8009d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	8d 50 08             	lea    0x8(%eax),%edx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	89 10                	mov    %edx,(%eax)
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	83 e8 08             	sub    $0x8,%eax
  8009ce:	8b 50 04             	mov    0x4(%eax),%edx
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	eb 40                	jmp    800a15 <getuint+0x65>
	else if (lflag)
  8009d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d9:	74 1e                	je     8009f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	8d 50 04             	lea    0x4(%eax),%edx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	89 10                	mov    %edx,(%eax)
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	83 e8 04             	sub    $0x4,%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f7:	eb 1c                	jmp    800a15 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	8d 50 04             	lea    0x4(%eax),%edx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	89 10                	mov    %edx,(%eax)
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 00                	mov    (%eax),%eax
  800a0b:	83 e8 04             	sub    $0x4,%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a1a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a1e:	7e 1c                	jle    800a3c <getint+0x25>
		return va_arg(*ap, long long);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	8d 50 08             	lea    0x8(%eax),%edx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 10                	mov    %edx,(%eax)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	83 e8 08             	sub    $0x8,%eax
  800a35:	8b 50 04             	mov    0x4(%eax),%edx
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	eb 38                	jmp    800a74 <getint+0x5d>
	else if (lflag)
  800a3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a40:	74 1a                	je     800a5c <getint+0x45>
		return va_arg(*ap, long);
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	8d 50 04             	lea    0x4(%eax),%edx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	89 10                	mov    %edx,(%eax)
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 e8 04             	sub    $0x4,%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	99                   	cltd   
  800a5a:	eb 18                	jmp    800a74 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	8d 50 04             	lea    0x4(%eax),%edx
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 10                	mov    %edx,(%eax)
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	99                   	cltd   
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	56                   	push   %esi
  800a7a:	53                   	push   %ebx
  800a7b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7e:	eb 17                	jmp    800a97 <vprintfmt+0x21>
			if (ch == '\0')
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	0f 84 af 03 00 00    	je     800e37 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	53                   	push   %ebx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	8d 50 01             	lea    0x1(%eax),%edx
  800a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f b6 d8             	movzbl %al,%ebx
  800aa5:	83 fb 25             	cmp    $0x25,%ebx
  800aa8:	75 d6                	jne    800a80 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800aaa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800aae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ab5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800abc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ac3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aca:	8b 45 10             	mov    0x10(%ebp),%eax
  800acd:	8d 50 01             	lea    0x1(%eax),%edx
  800ad0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	0f b6 d8             	movzbl %al,%ebx
  800ad8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800adb:	83 f8 55             	cmp    $0x55,%eax
  800ade:	0f 87 2b 03 00 00    	ja     800e0f <vprintfmt+0x399>
  800ae4:	8b 04 85 18 29 80 00 	mov    0x802918(,%eax,4),%eax
  800aeb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800af1:	eb d7                	jmp    800aca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800af3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800af7:	eb d1                	jmp    800aca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	c1 e0 02             	shl    $0x2,%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	01 c0                	add    %eax,%eax
  800b0c:	01 d8                	add    %ebx,%eax
  800b0e:	83 e8 30             	sub    $0x30,%eax
  800b11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b14:	8b 45 10             	mov    0x10(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800b1f:	7e 3e                	jle    800b5f <vprintfmt+0xe9>
  800b21:	83 fb 39             	cmp    $0x39,%ebx
  800b24:	7f 39                	jg     800b5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b29:	eb d5                	jmp    800b00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 14             	mov    %eax,0x14(%ebp)
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	83 e8 04             	sub    $0x4,%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b3f:	eb 1f                	jmp    800b60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	79 83                	jns    800aca <vprintfmt+0x54>
				width = 0;
  800b47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b4e:	e9 77 ff ff ff       	jmp    800aca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b5a:	e9 6b ff ff ff       	jmp    800aca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b64:	0f 89 60 ff ff ff    	jns    800aca <vprintfmt+0x54>
				width = precision, precision = -1;
  800b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b77:	e9 4e ff ff ff       	jmp    800aca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b7f:	e9 46 ff ff ff       	jmp    800aca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b84:	8b 45 14             	mov    0x14(%ebp),%eax
  800b87:	83 c0 04             	add    $0x4,%eax
  800b8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b90:	83 e8 04             	sub    $0x4,%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
			break;
  800ba4:	e9 89 02 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	83 c0 04             	add    $0x4,%eax
  800baf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb5:	83 e8 04             	sub    $0x4,%eax
  800bb8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bba:	85 db                	test   %ebx,%ebx
  800bbc:	79 02                	jns    800bc0 <vprintfmt+0x14a>
				err = -err;
  800bbe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800bc0:	83 fb 64             	cmp    $0x64,%ebx
  800bc3:	7f 0b                	jg     800bd0 <vprintfmt+0x15a>
  800bc5:	8b 34 9d 60 27 80 00 	mov    0x802760(,%ebx,4),%esi
  800bcc:	85 f6                	test   %esi,%esi
  800bce:	75 19                	jne    800be9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bd0:	53                   	push   %ebx
  800bd1:	68 05 29 80 00       	push   $0x802905
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 5e 02 00 00       	call   800e3f <printfmt>
  800be1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800be4:	e9 49 02 00 00       	jmp    800e32 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800be9:	56                   	push   %esi
  800bea:	68 0e 29 80 00       	push   $0x80290e
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	ff 75 08             	pushl  0x8(%ebp)
  800bf5:	e8 45 02 00 00       	call   800e3f <printfmt>
  800bfa:	83 c4 10             	add    $0x10,%esp
			break;
  800bfd:	e9 30 02 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c02:	8b 45 14             	mov    0x14(%ebp),%eax
  800c05:	83 c0 04             	add    $0x4,%eax
  800c08:	89 45 14             	mov    %eax,0x14(%ebp)
  800c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0e:	83 e8 04             	sub    $0x4,%eax
  800c11:	8b 30                	mov    (%eax),%esi
  800c13:	85 f6                	test   %esi,%esi
  800c15:	75 05                	jne    800c1c <vprintfmt+0x1a6>
				p = "(null)";
  800c17:	be 11 29 80 00       	mov    $0x802911,%esi
			if (width > 0 && padc != '-')
  800c1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c20:	7e 6d                	jle    800c8f <vprintfmt+0x219>
  800c22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c26:	74 67                	je     800c8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	50                   	push   %eax
  800c2f:	56                   	push   %esi
  800c30:	e8 0c 03 00 00       	call   800f41 <strnlen>
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c3b:	eb 16                	jmp    800c53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	50                   	push   %eax
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c50:	ff 4d e4             	decl   -0x1c(%ebp)
  800c53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c57:	7f e4                	jg     800c3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c59:	eb 34                	jmp    800c8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c5f:	74 1c                	je     800c7d <vprintfmt+0x207>
  800c61:	83 fb 1f             	cmp    $0x1f,%ebx
  800c64:	7e 05                	jle    800c6b <vprintfmt+0x1f5>
  800c66:	83 fb 7e             	cmp    $0x7e,%ebx
  800c69:	7e 12                	jle    800c7d <vprintfmt+0x207>
					putch('?', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 3f                	push   $0x3f
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	eb 0f                	jmp    800c8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	53                   	push   %ebx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff d0                	call   *%eax
  800c89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c8f:	89 f0                	mov    %esi,%eax
  800c91:	8d 70 01             	lea    0x1(%eax),%esi
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	0f be d8             	movsbl %al,%ebx
  800c99:	85 db                	test   %ebx,%ebx
  800c9b:	74 24                	je     800cc1 <vprintfmt+0x24b>
  800c9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ca1:	78 b8                	js     800c5b <vprintfmt+0x1e5>
  800ca3:	ff 4d e0             	decl   -0x20(%ebp)
  800ca6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800caa:	79 af                	jns    800c5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cac:	eb 13                	jmp    800cc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	6a 20                	push   $0x20
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800cc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc5:	7f e7                	jg     800cae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cc7:	e9 66 01 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd5:	50                   	push   %eax
  800cd6:	e8 3c fd ff ff       	call   800a17 <getint>
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cea:	85 d2                	test   %edx,%edx
  800cec:	79 23                	jns    800d11 <vprintfmt+0x29b>
				putch('-', putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	6a 2d                	push   $0x2d
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	ff d0                	call   *%eax
  800cfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d04:	f7 d8                	neg    %eax
  800d06:	83 d2 00             	adc    $0x0,%edx
  800d09:	f7 da                	neg    %edx
  800d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d18:	e9 bc 00 00 00       	jmp    800dd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	ff 75 e8             	pushl  -0x18(%ebp)
  800d23:	8d 45 14             	lea    0x14(%ebp),%eax
  800d26:	50                   	push   %eax
  800d27:	e8 84 fc ff ff       	call   8009b0 <getuint>
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d3c:	e9 98 00 00 00       	jmp    800dd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	6a 58                	push   $0x58
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	ff d0                	call   *%eax
  800d4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	6a 58                	push   $0x58
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	ff d0                	call   *%eax
  800d5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	ff 75 0c             	pushl  0xc(%ebp)
  800d67:	6a 58                	push   $0x58
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	ff d0                	call   *%eax
  800d6e:	83 c4 10             	add    $0x10,%esp
			break;
  800d71:	e9 bc 00 00 00       	jmp    800e32 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	6a 30                	push   $0x30
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 78                	push   $0x78
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d96:	8b 45 14             	mov    0x14(%ebp),%eax
  800d99:	83 c0 04             	add    $0x4,%eax
  800d9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800da2:	83 e8 04             	sub    $0x4,%eax
  800da5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800daa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800db1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800db8:	eb 1f                	jmp    800dd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dba:	83 ec 08             	sub    $0x8,%esp
  800dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc3:	50                   	push   %eax
  800dc4:	e8 e7 fb ff ff       	call   8009b0 <getuint>
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800dd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	52                   	push   %edx
  800de4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800de7:	50                   	push   %eax
  800de8:	ff 75 f4             	pushl  -0xc(%ebp)
  800deb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dee:	ff 75 0c             	pushl  0xc(%ebp)
  800df1:	ff 75 08             	pushl  0x8(%ebp)
  800df4:	e8 00 fb ff ff       	call   8008f9 <printnum>
  800df9:	83 c4 20             	add    $0x20,%esp
			break;
  800dfc:	eb 34                	jmp    800e32 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dfe:	83 ec 08             	sub    $0x8,%esp
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	53                   	push   %ebx
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	ff d0                	call   *%eax
  800e0a:	83 c4 10             	add    $0x10,%esp
			break;
  800e0d:	eb 23                	jmp    800e32 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	6a 25                	push   $0x25
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e1f:	ff 4d 10             	decl   0x10(%ebp)
  800e22:	eb 03                	jmp    800e27 <vprintfmt+0x3b1>
  800e24:	ff 4d 10             	decl   0x10(%ebp)
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	48                   	dec    %eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 25                	cmp    $0x25,%al
  800e2f:	75 f3                	jne    800e24 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e31:	90                   	nop
		}
	}
  800e32:	e9 47 fc ff ff       	jmp    800a7e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e45:	8d 45 10             	lea    0x10(%ebp),%eax
  800e48:	83 c0 04             	add    $0x4,%eax
  800e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	ff 75 f4             	pushl  -0xc(%ebp)
  800e54:	50                   	push   %eax
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	ff 75 08             	pushl  0x8(%ebp)
  800e5b:	e8 16 fc ff ff       	call   800a76 <vprintfmt>
  800e60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e63:	90                   	nop
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8b 40 08             	mov    0x8(%eax),%eax
  800e6f:	8d 50 01             	lea    0x1(%eax),%edx
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8b 10                	mov    (%eax),%edx
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	8b 40 04             	mov    0x4(%eax),%eax
  800e83:	39 c2                	cmp    %eax,%edx
  800e85:	73 12                	jae    800e99 <sprintputch+0x33>
		*b->buf++ = ch;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8b 00                	mov    (%eax),%eax
  800e8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	89 0a                	mov    %ecx,(%edx)
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	88 10                	mov    %dl,(%eax)
}
  800e99:	90                   	nop
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	01 d0                	add    %edx,%eax
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ec1:	74 06                	je     800ec9 <vsnprintf+0x2d>
  800ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec7:	7f 07                	jg     800ed0 <vsnprintf+0x34>
		return -E_INVAL;
  800ec9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ece:	eb 20                	jmp    800ef0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ed0:	ff 75 14             	pushl  0x14(%ebp)
  800ed3:	ff 75 10             	pushl  0x10(%ebp)
  800ed6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	68 66 0e 80 00       	push   $0x800e66
  800edf:	e8 92 fb ff ff       	call   800a76 <vprintfmt>
  800ee4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ef8:	8d 45 10             	lea    0x10(%ebp),%eax
  800efb:	83 c0 04             	add    $0x4,%eax
  800efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f01:	8b 45 10             	mov    0x10(%ebp),%eax
  800f04:	ff 75 f4             	pushl  -0xc(%ebp)
  800f07:	50                   	push   %eax
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 89 ff ff ff       	call   800e9c <vsnprintf>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f2b:	eb 06                	jmp    800f33 <strlen+0x15>
		n++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	84 c0                	test   %al,%al
  800f3a:	75 f1                	jne    800f2d <strlen+0xf>
		n++;
	return n;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f4e:	eb 09                	jmp    800f59 <strnlen+0x18>
		n++;
  800f50:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	ff 4d 0c             	decl   0xc(%ebp)
  800f59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5d:	74 09                	je     800f68 <strnlen+0x27>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	84 c0                	test   %al,%al
  800f66:	75 e8                	jne    800f50 <strnlen+0xf>
		n++;
	return n;
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f79:	90                   	nop
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 08             	mov    %edx,0x8(%ebp)
  800f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	84 c0                	test   %al,%al
  800f94:	75 e4                	jne    800f7a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fae:	eb 1f                	jmp    800fcf <strncpy+0x34>
		*dst++ = *src;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8d 50 01             	lea    0x1(%eax),%edx
  800fb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbc:	8a 12                	mov    (%edx),%dl
  800fbe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 03                	je     800fcc <strncpy+0x31>
			src++;
  800fc9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fcc:	ff 45 fc             	incl   -0x4(%ebp)
  800fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fd5:	72 d9                	jb     800fb0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fe8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fec:	74 30                	je     80101e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fee:	eb 16                	jmp    801006 <strlcpy+0x2a>
			*dst++ = *src++;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801006:	ff 4d 10             	decl   0x10(%ebp)
  801009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100d:	74 09                	je     801018 <strlcpy+0x3c>
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	84 c0                	test   %al,%al
  801016:	75 d8                	jne    800ff0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801024:	29 c2                	sub    %eax,%edx
  801026:	89 d0                	mov    %edx,%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80102d:	eb 06                	jmp    801035 <strcmp+0xb>
		p++, q++;
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	84 c0                	test   %al,%al
  80103c:	74 0e                	je     80104c <strcmp+0x22>
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 10                	mov    (%eax),%dl
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	38 c2                	cmp    %al,%dl
  80104a:	74 e3                	je     80102f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	0f b6 d0             	movzbl %al,%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	0f b6 c0             	movzbl %al,%eax
  80105c:	29 c2                	sub    %eax,%edx
  80105e:	89 d0                	mov    %edx,%eax
}
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801065:	eb 09                	jmp    801070 <strncmp+0xe>
		n--, p++, q++;
  801067:	ff 4d 10             	decl   0x10(%ebp)
  80106a:	ff 45 08             	incl   0x8(%ebp)
  80106d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801074:	74 17                	je     80108d <strncmp+0x2b>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	84 c0                	test   %al,%al
  80107d:	74 0e                	je     80108d <strncmp+0x2b>
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 10                	mov    (%eax),%dl
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	38 c2                	cmp    %al,%dl
  80108b:	74 da                	je     801067 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80108d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801091:	75 07                	jne    80109a <strncmp+0x38>
		return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	eb 14                	jmp    8010ae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f b6 d0             	movzbl %al,%edx
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	0f b6 c0             	movzbl %al,%eax
  8010aa:	29 c2                	sub    %eax,%edx
  8010ac:	89 d0                	mov    %edx,%eax
}
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010bc:	eb 12                	jmp    8010d0 <strchr+0x20>
		if (*s == c)
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010c6:	75 05                	jne    8010cd <strchr+0x1d>
			return (char *) s;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	eb 11                	jmp    8010de <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e5                	jne    8010be <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010ec:	eb 0d                	jmp    8010fb <strfind+0x1b>
		if (*s == c)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010f6:	74 0e                	je     801106 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	84 c0                	test   %al,%al
  801102:	75 ea                	jne    8010ee <strfind+0xe>
  801104:	eb 01                	jmp    801107 <strfind+0x27>
		if (*s == c)
			break;
  801106:	90                   	nop
	return (char *) s;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80111e:	eb 0e                	jmp    80112e <memset+0x22>
		*p++ = c;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8d 50 01             	lea    0x1(%eax),%edx
  801126:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801129:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80112e:	ff 4d f8             	decl   -0x8(%ebp)
  801131:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801135:	79 e9                	jns    801120 <memset+0x14>
		*p++ = c;

	return v;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80114e:	eb 16                	jmp    801166 <memcpy+0x2a>
		*d++ = *s++;
  801150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801162:	8a 12                	mov    (%edx),%dl
  801164:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116c:	89 55 10             	mov    %edx,0x10(%ebp)
  80116f:	85 c0                	test   %eax,%eax
  801171:	75 dd                	jne    801150 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801190:	73 50                	jae    8011e2 <memmove+0x6a>
  801192:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	01 d0                	add    %edx,%eax
  80119a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80119d:	76 43                	jbe    8011e2 <memmove+0x6a>
		s += n;
  80119f:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011ab:	eb 10                	jmp    8011bd <memmove+0x45>
			*--d = *--s;
  8011ad:	ff 4d f8             	decl   -0x8(%ebp)
  8011b0:	ff 4d fc             	decl   -0x4(%ebp)
  8011b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b6:	8a 10                	mov    (%eax),%dl
  8011b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 e3                	jne    8011ad <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011ca:	eb 23                	jmp    8011ef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	8d 50 01             	lea    0x1(%eax),%edx
  8011d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011db:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011de:	8a 12                	mov    (%edx),%dl
  8011e0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	75 dd                	jne    8011cc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801206:	eb 2a                	jmp    801232 <memcmp+0x3e>
		if (*s1 != *s2)
  801208:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120b:	8a 10                	mov    (%eax),%dl
  80120d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	38 c2                	cmp    %al,%dl
  801214:	74 16                	je     80122c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801216:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	0f b6 d0             	movzbl %al,%edx
  80121e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f b6 c0             	movzbl %al,%eax
  801226:	29 c2                	sub    %eax,%edx
  801228:	89 d0                	mov    %edx,%eax
  80122a:	eb 18                	jmp    801244 <memcmp+0x50>
		s1++, s2++;
  80122c:	ff 45 fc             	incl   -0x4(%ebp)
  80122f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	8d 50 ff             	lea    -0x1(%eax),%edx
  801238:	89 55 10             	mov    %edx,0x10(%ebp)
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 c9                	jne    801208 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80124c:	8b 55 08             	mov    0x8(%ebp),%edx
  80124f:	8b 45 10             	mov    0x10(%ebp),%eax
  801252:	01 d0                	add    %edx,%eax
  801254:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801257:	eb 15                	jmp    80126e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	0f b6 d0             	movzbl %al,%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	0f b6 c0             	movzbl %al,%eax
  801267:	39 c2                	cmp    %eax,%edx
  801269:	74 0d                	je     801278 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801274:	72 e3                	jb     801259 <memfind+0x13>
  801276:	eb 01                	jmp    801279 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801278:	90                   	nop
	return (void *) s;
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80128b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801292:	eb 03                	jmp    801297 <strtol+0x19>
		s++;
  801294:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 20                	cmp    $0x20,%al
  80129e:	74 f4                	je     801294 <strtol+0x16>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 09                	cmp    $0x9,%al
  8012a7:	74 eb                	je     801294 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 2b                	cmp    $0x2b,%al
  8012b0:	75 05                	jne    8012b7 <strtol+0x39>
		s++;
  8012b2:	ff 45 08             	incl   0x8(%ebp)
  8012b5:	eb 13                	jmp    8012ca <strtol+0x4c>
	else if (*s == '-')
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 2d                	cmp    $0x2d,%al
  8012be:	75 0a                	jne    8012ca <strtol+0x4c>
		s++, neg = 1;
  8012c0:	ff 45 08             	incl   0x8(%ebp)
  8012c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	74 06                	je     8012d6 <strtol+0x58>
  8012d0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012d4:	75 20                	jne    8012f6 <strtol+0x78>
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 30                	cmp    $0x30,%al
  8012dd:	75 17                	jne    8012f6 <strtol+0x78>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	40                   	inc    %eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	3c 78                	cmp    $0x78,%al
  8012e7:	75 0d                	jne    8012f6 <strtol+0x78>
		s += 2, base = 16;
  8012e9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012f4:	eb 28                	jmp    80131e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012fa:	75 15                	jne    801311 <strtol+0x93>
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 30                	cmp    $0x30,%al
  801303:	75 0c                	jne    801311 <strtol+0x93>
		s++, base = 8;
  801305:	ff 45 08             	incl   0x8(%ebp)
  801308:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80130f:	eb 0d                	jmp    80131e <strtol+0xa0>
	else if (base == 0)
  801311:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801315:	75 07                	jne    80131e <strtol+0xa0>
		base = 10;
  801317:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	3c 2f                	cmp    $0x2f,%al
  801325:	7e 19                	jle    801340 <strtol+0xc2>
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	3c 39                	cmp    $0x39,%al
  80132e:	7f 10                	jg     801340 <strtol+0xc2>
			dig = *s - '0';
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be c0             	movsbl %al,%eax
  801338:	83 e8 30             	sub    $0x30,%eax
  80133b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133e:	eb 42                	jmp    801382 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	3c 60                	cmp    $0x60,%al
  801347:	7e 19                	jle    801362 <strtol+0xe4>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	3c 7a                	cmp    $0x7a,%al
  801350:	7f 10                	jg     801362 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f be c0             	movsbl %al,%eax
  80135a:	83 e8 57             	sub    $0x57,%eax
  80135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801360:	eb 20                	jmp    801382 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 40                	cmp    $0x40,%al
  801369:	7e 39                	jle    8013a4 <strtol+0x126>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 5a                	cmp    $0x5a,%al
  801372:	7f 30                	jg     8013a4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	0f be c0             	movsbl %al,%eax
  80137c:	83 e8 37             	sub    $0x37,%eax
  80137f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801385:	3b 45 10             	cmp    0x10(%ebp),%eax
  801388:	7d 19                	jge    8013a3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80138a:	ff 45 08             	incl   0x8(%ebp)
  80138d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801390:	0f af 45 10          	imul   0x10(%ebp),%eax
  801394:	89 c2                	mov    %eax,%edx
  801396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80139e:	e9 7b ff ff ff       	jmp    80131e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013a3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a8:	74 08                	je     8013b2 <strtol+0x134>
		*endptr = (char *) s;
  8013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b6:	74 07                	je     8013bf <strtol+0x141>
  8013b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bb:	f7 d8                	neg    %eax
  8013bd:	eb 03                	jmp    8013c2 <strtol+0x144>
  8013bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <ltostr>:

void
ltostr(long value, char *str)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013dc:	79 13                	jns    8013f1 <ltostr+0x2d>
	{
		neg = 1;
  8013de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013eb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f9:	99                   	cltd   
  8013fa:	f7 f9                	idiv   %ecx
  8013fc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801402:	8d 50 01             	lea    0x1(%eax),%edx
  801405:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801408:	89 c2                	mov    %eax,%edx
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	01 d0                	add    %edx,%eax
  80140f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801412:	83 c2 30             	add    $0x30,%edx
  801415:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801417:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80141f:	f7 e9                	imul   %ecx
  801421:	c1 fa 02             	sar    $0x2,%edx
  801424:	89 c8                	mov    %ecx,%eax
  801426:	c1 f8 1f             	sar    $0x1f,%eax
  801429:	29 c2                	sub    %eax,%edx
  80142b:	89 d0                	mov    %edx,%eax
  80142d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801433:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801438:	f7 e9                	imul   %ecx
  80143a:	c1 fa 02             	sar    $0x2,%edx
  80143d:	89 c8                	mov    %ecx,%eax
  80143f:	c1 f8 1f             	sar    $0x1f,%eax
  801442:	29 c2                	sub    %eax,%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	c1 e0 02             	shl    $0x2,%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	01 c0                	add    %eax,%eax
  80144d:	29 c1                	sub    %eax,%ecx
  80144f:	89 ca                	mov    %ecx,%edx
  801451:	85 d2                	test   %edx,%edx
  801453:	75 9c                	jne    8013f1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80145c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145f:	48                   	dec    %eax
  801460:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801463:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801467:	74 3d                	je     8014a6 <ltostr+0xe2>
		start = 1 ;
  801469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801470:	eb 34                	jmp    8014a6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	01 d0                	add    %edx,%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80147f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	01 c2                	add    %eax,%edx
  801487:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	01 c8                	add    %ecx,%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801493:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801496:	8b 45 0c             	mov    0xc(%ebp),%eax
  801499:	01 c2                	add    %eax,%edx
  80149b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80149e:	88 02                	mov    %al,(%edx)
		start++ ;
  8014a0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014a3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ac:	7c c4                	jl     801472 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014b9:	90                   	nop
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014c2:	ff 75 08             	pushl  0x8(%ebp)
  8014c5:	e8 54 fa ff ff       	call   800f1e <strlen>
  8014ca:	83 c4 04             	add    $0x4,%esp
  8014cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014d0:	ff 75 0c             	pushl  0xc(%ebp)
  8014d3:	e8 46 fa ff ff       	call   800f1e <strlen>
  8014d8:	83 c4 04             	add    $0x4,%esp
  8014db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ec:	eb 17                	jmp    801505 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	01 c2                	add    %eax,%edx
  8014f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	01 c8                	add    %ecx,%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801502:	ff 45 fc             	incl   -0x4(%ebp)
  801505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801508:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80150b:	7c e1                	jl     8014ee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80150d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801514:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80151b:	eb 1f                	jmp    80153c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80151d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801520:	8d 50 01             	lea    0x1(%eax),%edx
  801523:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 45 10             	mov    0x10(%ebp),%eax
  80152b:	01 c2                	add    %eax,%edx
  80152d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	01 c8                	add    %ecx,%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801539:	ff 45 f8             	incl   -0x8(%ebp)
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801542:	7c d9                	jl     80151d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801544:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	c6 00 00             	movb   $0x0,(%eax)
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801555:	8b 45 14             	mov    0x14(%ebp),%eax
  801558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80155e:	8b 45 14             	mov    0x14(%ebp),%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801575:	eb 0c                	jmp    801583 <strsplit+0x31>
			*string++ = 0;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8d 50 01             	lea    0x1(%eax),%edx
  80157d:	89 55 08             	mov    %edx,0x8(%ebp)
  801580:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	84 c0                	test   %al,%al
  80158a:	74 18                	je     8015a4 <strsplit+0x52>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 13 fb ff ff       	call   8010b0 <strchr>
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	75 d3                	jne    801577 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	84 c0                	test   %al,%al
  8015ab:	74 5a                	je     801607 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	83 f8 0f             	cmp    $0xf,%eax
  8015b5:	75 07                	jne    8015be <strsplit+0x6c>
		{
			return 0;
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	eb 66                	jmp    801624 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015be:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8015c6:	8b 55 14             	mov    0x14(%ebp),%edx
  8015c9:	89 0a                	mov    %ecx,(%edx)
  8015cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d5:	01 c2                	add    %eax,%edx
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015dc:	eb 03                	jmp    8015e1 <strsplit+0x8f>
			string++;
  8015de:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	84 c0                	test   %al,%al
  8015e8:	74 8b                	je     801575 <strsplit+0x23>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	0f be c0             	movsbl %al,%eax
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	e8 b5 fa ff ff       	call   8010b0 <strchr>
  8015fb:	83 c4 08             	add    $0x8,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	74 dc                	je     8015de <strsplit+0x8c>
			string++;
	}
  801602:	e9 6e ff ff ff       	jmp    801575 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801607:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801608:	8b 45 14             	mov    0x14(%ebp),%eax
  80160b:	8b 00                	mov    (%eax),%eax
  80160d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801614:	8b 45 10             	mov    0x10(%ebp),%eax
  801617:	01 d0                	add    %edx,%eax
  801619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80161f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  80162c:	a1 28 30 80 00       	mov    0x803028,%eax
  801631:	85 c0                	test   %eax,%eax
  801633:	75 33                	jne    801668 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801635:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  80163c:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  80163f:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801646:	00 00 a0 
		spaces[0].pages = numPages;
  801649:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801650:	00 02 00 
		spaces[0].isFree = 1;
  801653:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  80165a:	00 00 00 
		arraySize++;
  80165d:	a1 28 30 80 00       	mov    0x803028,%eax
  801662:	40                   	inc    %eax
  801663:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801668:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  80166f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801676:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80167d:	8b 55 08             	mov    0x8(%ebp),%edx
  801680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801683:	01 d0                	add    %edx,%eax
  801685:	48                   	dec    %eax
  801686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80168c:	ba 00 00 00 00       	mov    $0x0,%edx
  801691:	f7 75 e8             	divl   -0x18(%ebp)
  801694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801697:	29 d0                	sub    %edx,%eax
  801699:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	c1 e8 0c             	shr    $0xc,%eax
  8016a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8016a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8016ac:	eb 57                	jmp    801705 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8016ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b1:	c1 e0 04             	shl    $0x4,%eax
  8016b4:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016b9:	8b 00                	mov    (%eax),%eax
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	74 42                	je     801701 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8016bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c2:	c1 e0 04             	shl    $0x4,%eax
  8016c5:	05 28 31 80 00       	add    $0x803128,%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8016cf:	7c 31                	jl     801702 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8016d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d4:	c1 e0 04             	shl    $0x4,%eax
  8016d7:	05 28 31 80 00       	add    $0x803128,%eax
  8016dc:	8b 00                	mov    (%eax),%eax
  8016de:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8016e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e4:	7d 1c                	jge    801702 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  8016e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e9:	c1 e0 04             	shl    $0x4,%eax
  8016ec:	05 28 31 80 00       	add    $0x803128,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8016f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ff:	eb 01                	jmp    801702 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801701:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801702:	ff 45 ec             	incl   -0x14(%ebp)
  801705:	a1 28 30 80 00       	mov    0x803028,%eax
  80170a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80170d:	7c 9f                	jl     8016ae <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  80170f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801713:	75 0a                	jne    80171f <malloc+0xf9>
	{
		return NULL;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	e9 34 01 00 00       	jmp    801853 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  80171f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801722:	c1 e0 04             	shl    $0x4,%eax
  801725:	05 28 31 80 00       	add    $0x803128,%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80172f:	75 38                	jne    801769 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	c1 e0 04             	shl    $0x4,%eax
  801737:	05 2c 31 80 00       	add    $0x80312c,%eax
  80173c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801742:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801745:	c1 e0 0c             	shl    $0xc,%eax
  801748:	89 c2                	mov    %eax,%edx
  80174a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174d:	c1 e0 04             	shl    $0x4,%eax
  801750:	05 20 31 80 00       	add    $0x803120,%eax
  801755:	8b 00                	mov    (%eax),%eax
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	52                   	push   %edx
  80175b:	50                   	push   %eax
  80175c:	e8 01 06 00 00       	call   801d62 <sys_allocateMem>
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	e9 dd 00 00 00       	jmp    801846 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176c:	c1 e0 04             	shl    $0x4,%eax
  80176f:	05 20 31 80 00       	add    $0x803120,%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801779:	c1 e2 0c             	shl    $0xc,%edx
  80177c:	01 d0                	add    %edx,%eax
  80177e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801781:	a1 28 30 80 00       	mov    0x803028,%eax
  801786:	c1 e0 04             	shl    $0x4,%eax
  801789:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  80178f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801792:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801794:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80179a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179d:	c1 e0 04             	shl    $0x4,%eax
  8017a0:	05 24 31 80 00       	add    $0x803124,%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	c1 e2 04             	shl    $0x4,%edx
  8017aa:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8017b0:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8017b2:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8017b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bb:	c1 e0 04             	shl    $0x4,%eax
  8017be:	05 28 31 80 00       	add    $0x803128,%eax
  8017c3:	8b 00                	mov    (%eax),%eax
  8017c5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8017c8:	c1 e2 04             	shl    $0x4,%edx
  8017cb:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8017d1:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  8017d3:	a1 28 30 80 00       	mov    0x803028,%eax
  8017d8:	c1 e0 04             	shl    $0x4,%eax
  8017db:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  8017e6:	a1 28 30 80 00       	mov    0x803028,%eax
  8017eb:	40                   	inc    %eax
  8017ec:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8017f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f4:	c1 e0 04             	shl    $0x4,%eax
  8017f7:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8017fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801800:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	c1 e0 04             	shl    $0x4,%eax
  801808:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  80180e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801811:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	c1 e0 04             	shl    $0x4,%eax
  801819:	05 2c 31 80 00       	add    $0x80312c,%eax
  80181e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801824:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801827:	c1 e0 0c             	shl    $0xc,%eax
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182f:	c1 e0 04             	shl    $0x4,%eax
  801832:	05 20 31 80 00       	add    $0x803120,%eax
  801837:	8b 00                	mov    (%eax),%eax
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	52                   	push   %edx
  80183d:	50                   	push   %eax
  80183e:	e8 1f 05 00 00       	call   801d62 <sys_allocateMem>
  801843:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801849:	c1 e0 04             	shl    $0x4,%eax
  80184c:	05 20 31 80 00       	add    $0x803120,%eax
  801851:	8b 00                	mov    (%eax),%eax
	}


}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  80185b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801862:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801869:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801870:	eb 3f                	jmp    8018b1 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801875:	c1 e0 04             	shl    $0x4,%eax
  801878:	05 20 31 80 00       	add    $0x803120,%eax
  80187d:	8b 00                	mov    (%eax),%eax
  80187f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801882:	75 2a                	jne    8018ae <free+0x59>
		{
			index=i;
  801884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801887:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  80188a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188d:	c1 e0 04             	shl    $0x4,%eax
  801890:	05 28 31 80 00       	add    $0x803128,%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	c1 e0 0c             	shl    $0xc,%eax
  80189a:	89 c2                	mov    %eax,%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	83 ec 08             	sub    $0x8,%esp
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	e8 9d 04 00 00       	call   801d46 <sys_freeMem>
  8018a9:	83 c4 10             	add    $0x10,%esp
			break;
  8018ac:	eb 0d                	jmp    8018bb <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8018ae:	ff 45 ec             	incl   -0x14(%ebp)
  8018b1:	a1 28 30 80 00       	mov    0x803028,%eax
  8018b6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8018b9:	7c b7                	jl     801872 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8018bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8018bf:	75 17                	jne    8018d8 <free+0x83>
	{
		panic("Error");
  8018c1:	83 ec 04             	sub    $0x4,%esp
  8018c4:	68 70 2a 80 00       	push   $0x802a70
  8018c9:	68 81 00 00 00       	push   $0x81
  8018ce:	68 76 2a 80 00       	push   $0x802a76
  8018d3:	e8 14 09 00 00       	call   8021ec <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  8018d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018df:	e9 cc 00 00 00       	jmp    8019b0 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  8018e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e7:	c1 e0 04             	shl    $0x4,%eax
  8018ea:	05 2c 31 80 00       	add    $0x80312c,%eax
  8018ef:	8b 00                	mov    (%eax),%eax
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	0f 84 b3 00 00 00    	je     8019ac <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	c1 e0 04             	shl    $0x4,%eax
  8018ff:	05 20 31 80 00       	add    $0x803120,%eax
  801904:	8b 10                	mov    (%eax),%edx
  801906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801909:	c1 e0 04             	shl    $0x4,%eax
  80190c:	05 24 31 80 00       	add    $0x803124,%eax
  801911:	8b 00                	mov    (%eax),%eax
  801913:	39 c2                	cmp    %eax,%edx
  801915:	0f 85 92 00 00 00    	jne    8019ad <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	c1 e0 04             	shl    $0x4,%eax
  801921:	05 24 31 80 00       	add    $0x803124,%eax
  801926:	8b 00                	mov    (%eax),%eax
  801928:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80192b:	c1 e2 04             	shl    $0x4,%edx
  80192e:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801934:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801936:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801939:	c1 e0 04             	shl    $0x4,%eax
  80193c:	05 28 31 80 00       	add    $0x803128,%eax
  801941:	8b 10                	mov    (%eax),%edx
  801943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801946:	c1 e0 04             	shl    $0x4,%eax
  801949:	05 28 31 80 00       	add    $0x803128,%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	01 c2                	add    %eax,%edx
  801952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801955:	c1 e0 04             	shl    $0x4,%eax
  801958:	05 28 31 80 00       	add    $0x803128,%eax
  80195d:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  80195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801962:	c1 e0 04             	shl    $0x4,%eax
  801965:	05 20 31 80 00       	add    $0x803120,%eax
  80196a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	c1 e0 04             	shl    $0x4,%eax
  801976:	05 24 31 80 00       	add    $0x803124,%eax
  80197b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801984:	c1 e0 04             	shl    $0x4,%eax
  801987:	05 28 31 80 00       	add    $0x803128,%eax
  80198c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801995:	c1 e0 04             	shl    $0x4,%eax
  801998:	05 2c 31 80 00       	add    $0x80312c,%eax
  80199d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8019a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8019aa:	eb 12                	jmp    8019be <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8019ac:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  8019ad:	ff 45 e8             	incl   -0x18(%ebp)
  8019b0:	a1 28 30 80 00       	mov    0x803028,%eax
  8019b5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8019b8:	0f 8c 26 ff ff ff    	jl     8018e4 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8019be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8019c5:	e9 cc 00 00 00       	jmp    801a96 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  8019ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019cd:	c1 e0 04             	shl    $0x4,%eax
  8019d0:	05 2c 31 80 00       	add    $0x80312c,%eax
  8019d5:	8b 00                	mov    (%eax),%eax
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	0f 84 b3 00 00 00    	je     801a92 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  8019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e2:	c1 e0 04             	shl    $0x4,%eax
  8019e5:	05 24 31 80 00       	add    $0x803124,%eax
  8019ea:	8b 10                	mov    (%eax),%edx
  8019ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ef:	c1 e0 04             	shl    $0x4,%eax
  8019f2:	05 20 31 80 00       	add    $0x803120,%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	39 c2                	cmp    %eax,%edx
  8019fb:	0f 85 92 00 00 00    	jne    801a93 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	c1 e0 04             	shl    $0x4,%eax
  801a07:	05 20 31 80 00       	add    $0x803120,%eax
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a11:	c1 e2 04             	shl    $0x4,%edx
  801a14:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801a1a:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1f:	c1 e0 04             	shl    $0x4,%eax
  801a22:	05 28 31 80 00       	add    $0x803128,%eax
  801a27:	8b 10                	mov    (%eax),%edx
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	c1 e0 04             	shl    $0x4,%eax
  801a2f:	05 28 31 80 00       	add    $0x803128,%eax
  801a34:	8b 00                	mov    (%eax),%eax
  801a36:	01 c2                	add    %eax,%edx
  801a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3b:	c1 e0 04             	shl    $0x4,%eax
  801a3e:	05 28 31 80 00       	add    $0x803128,%eax
  801a43:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a48:	c1 e0 04             	shl    $0x4,%eax
  801a4b:	05 20 31 80 00       	add    $0x803120,%eax
  801a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a59:	c1 e0 04             	shl    $0x4,%eax
  801a5c:	05 24 31 80 00       	add    $0x803124,%eax
  801a61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	c1 e0 04             	shl    $0x4,%eax
  801a6d:	05 28 31 80 00       	add    $0x803128,%eax
  801a72:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7b:	c1 e0 04             	shl    $0x4,%eax
  801a7e:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801a89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801a90:	eb 12                	jmp    801aa4 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801a92:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801a93:	ff 45 e4             	incl   -0x1c(%ebp)
  801a96:	a1 28 30 80 00       	mov    0x803028,%eax
  801a9b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a9e:	0f 8c 26 ff ff ff    	jl     8019ca <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801aa4:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801aa8:	75 11                	jne    801abb <free+0x266>
	{
		spaces[index].isFree = 1;
  801aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aad:	c1 e0 04             	shl    $0x4,%eax
  801ab0:	05 2c 31 80 00       	add    $0x80312c,%eax
  801ab5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 18             	sub    $0x18,%esp
  801ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac7:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	68 84 2a 80 00       	push   $0x802a84
  801ad2:	68 b9 00 00 00       	push   $0xb9
  801ad7:	68 76 2a 80 00       	push   $0x802a76
  801adc:	e8 0b 07 00 00       	call   8021ec <_panic>

00801ae1 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	68 84 2a 80 00       	push   $0x802a84
  801aef:	68 bf 00 00 00       	push   $0xbf
  801af4:	68 76 2a 80 00       	push   $0x802a76
  801af9:	e8 ee 06 00 00       	call   8021ec <_panic>

00801afe <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	68 84 2a 80 00       	push   $0x802a84
  801b0c:	68 c5 00 00 00       	push   $0xc5
  801b11:	68 76 2a 80 00       	push   $0x802a76
  801b16:	e8 d1 06 00 00       	call   8021ec <_panic>

00801b1b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	68 84 2a 80 00       	push   $0x802a84
  801b29:	68 ca 00 00 00       	push   $0xca
  801b2e:	68 76 2a 80 00       	push   $0x802a76
  801b33:	e8 b4 06 00 00       	call   8021ec <_panic>

00801b38 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	68 84 2a 80 00       	push   $0x802a84
  801b46:	68 d0 00 00 00       	push   $0xd0
  801b4b:	68 76 2a 80 00       	push   $0x802a76
  801b50:	e8 97 06 00 00       	call   8021ec <_panic>

00801b55 <shrink>:
}
void shrink(uint32 newSize)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	68 84 2a 80 00       	push   $0x802a84
  801b63:	68 d4 00 00 00       	push   $0xd4
  801b68:	68 76 2a 80 00       	push   $0x802a76
  801b6d:	e8 7a 06 00 00       	call   8021ec <_panic>

00801b72 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	68 84 2a 80 00       	push   $0x802a84
  801b80:	68 d9 00 00 00       	push   $0xd9
  801b85:	68 76 2a 80 00       	push   $0x802a76
  801b8a:	e8 5d 06 00 00       	call   8021ec <_panic>

00801b8f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	57                   	push   %edi
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ba7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801baa:	cd 30                	int    $0x30
  801bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	5b                   	pop    %ebx
  801bb6:	5e                   	pop    %esi
  801bb7:	5f                   	pop    %edi
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    

00801bba <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bc6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	50                   	push   %eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	e8 b2 ff ff ff       	call   801b8f <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	90                   	nop
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 01                	push   $0x1
  801bf2:	e8 98 ff ff ff       	call   801b8f <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	50                   	push   %eax
  801c0b:	6a 05                	push   $0x5
  801c0d:	e8 7d ff ff ff       	call   801b8f <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 02                	push   $0x2
  801c26:	e8 64 ff ff ff       	call   801b8f <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 03                	push   $0x3
  801c3f:	e8 4b ff ff ff       	call   801b8f <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 04                	push   $0x4
  801c58:	e8 32 ff ff ff       	call   801b8f <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_env_exit>:


void sys_env_exit(void)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 06                	push   $0x6
  801c71:	e8 19 ff ff ff       	call   801b8f <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	90                   	nop
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	52                   	push   %edx
  801c8c:	50                   	push   %eax
  801c8d:	6a 07                	push   $0x7
  801c8f:	e8 fb fe ff ff       	call   801b8f <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	56                   	push   %esi
  801c9d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c9e:	8b 75 18             	mov    0x18(%ebp),%esi
  801ca1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	56                   	push   %esi
  801cae:	53                   	push   %ebx
  801caf:	51                   	push   %ecx
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 08                	push   $0x8
  801cb4:	e8 d6 fe ff ff       	call   801b8f <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	6a 09                	push   $0x9
  801cd6:	e8 b4 fe ff ff       	call   801b8f <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	ff 75 08             	pushl  0x8(%ebp)
  801cef:	6a 0a                	push   $0xa
  801cf1:	e8 99 fe ff ff       	call   801b8f <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 0b                	push   $0xb
  801d0a:	e8 80 fe ff ff       	call   801b8f <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 0c                	push   $0xc
  801d23:	e8 67 fe ff ff       	call   801b8f <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 0d                	push   $0xd
  801d3c:	e8 4e fe ff ff       	call   801b8f <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	6a 11                	push   $0x11
  801d57:	e8 33 fe ff ff       	call   801b8f <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	ff 75 08             	pushl  0x8(%ebp)
  801d71:	6a 12                	push   $0x12
  801d73:	e8 17 fe ff ff       	call   801b8f <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7b:	90                   	nop
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 0e                	push   $0xe
  801d8d:	e8 fd fd ff ff       	call   801b8f <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	6a 0f                	push   $0xf
  801da7:	e8 e3 fd ff ff       	call   801b8f <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 10                	push   $0x10
  801dc0:	e8 ca fd ff ff       	call   801b8f <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	90                   	nop
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 14                	push   $0x14
  801dda:	e8 b0 fd ff ff       	call   801b8f <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	90                   	nop
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 15                	push   $0x15
  801df4:	e8 96 fd ff ff       	call   801b8f <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	90                   	nop
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_cputc>:


void
sys_cputc(const char c)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	50                   	push   %eax
  801e18:	6a 16                	push   $0x16
  801e1a:	e8 70 fd ff ff       	call   801b8f <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	90                   	nop
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 17                	push   $0x17
  801e34:	e8 56 fd ff ff       	call   801b8f <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	90                   	nop
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	50                   	push   %eax
  801e4f:	6a 18                	push   $0x18
  801e51:	e8 39 fd ff ff       	call   801b8f <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 1b                	push   $0x1b
  801e6e:	e8 1c fd ff ff       	call   801b8f <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	6a 19                	push   $0x19
  801e8b:	e8 ff fc ff ff       	call   801b8f <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	52                   	push   %edx
  801ea6:	50                   	push   %eax
  801ea7:	6a 1a                	push   $0x1a
  801ea9:	e8 e1 fc ff ff       	call   801b8f <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	90                   	nop
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ec0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	51                   	push   %ecx
  801ecd:	52                   	push   %edx
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	50                   	push   %eax
  801ed2:	6a 1c                	push   $0x1c
  801ed4:	e8 b6 fc ff ff       	call   801b8f <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	6a 1d                	push   $0x1d
  801ef1:	e8 99 fc ff ff       	call   801b8f <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801efe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	51                   	push   %ecx
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 1e                	push   $0x1e
  801f10:	e8 7a fc ff ff       	call   801b8f <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	6a 1f                	push   $0x1f
  801f2d:	e8 5d fc ff ff       	call   801b8f <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 20                	push   $0x20
  801f46:	e8 44 fc ff ff       	call   801b8f <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	ff 75 14             	pushl  0x14(%ebp)
  801f5b:	ff 75 10             	pushl  0x10(%ebp)
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	50                   	push   %eax
  801f62:	6a 21                	push   $0x21
  801f64:	e8 26 fc ff ff       	call   801b8f <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	50                   	push   %eax
  801f7d:	6a 22                	push   $0x22
  801f7f:	e8 0b fc ff ff       	call   801b8f <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	90                   	nop
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	50                   	push   %eax
  801f99:	6a 23                	push   $0x23
  801f9b:	e8 ef fb ff ff       	call   801b8f <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	90                   	nop
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801faf:	8d 50 04             	lea    0x4(%eax),%edx
  801fb2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 24                	push   $0x24
  801fbf:	e8 cb fb ff ff       	call   801b8f <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return result;
  801fc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd0:	89 01                	mov    %eax,(%ecx)
  801fd2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	c9                   	leave  
  801fd9:	c2 04 00             	ret    $0x4

00801fdc <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	ff 75 10             	pushl  0x10(%ebp)
  801fe6:	ff 75 0c             	pushl  0xc(%ebp)
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	6a 13                	push   $0x13
  801fee:	e8 9c fb ff ff       	call   801b8f <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff6:	90                   	nop
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 25                	push   $0x25
  802008:	e8 82 fb ff ff       	call   801b8f <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80201e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	50                   	push   %eax
  80202b:	6a 26                	push   $0x26
  80202d:	e8 5d fb ff ff       	call   801b8f <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
	return ;
  802035:	90                   	nop
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <rsttst>:
void rsttst()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 28                	push   $0x28
  802047:	e8 43 fb ff ff       	call   801b8f <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
	return ;
  80204f:	90                   	nop
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	8b 45 14             	mov    0x14(%ebp),%eax
  80205b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80205e:	8b 55 18             	mov    0x18(%ebp),%edx
  802061:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802065:	52                   	push   %edx
  802066:	50                   	push   %eax
  802067:	ff 75 10             	pushl  0x10(%ebp)
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	6a 27                	push   $0x27
  802072:	e8 18 fb ff ff       	call   801b8f <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return ;
  80207a:	90                   	nop
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <chktst>:
void chktst(uint32 n)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	ff 75 08             	pushl  0x8(%ebp)
  80208b:	6a 29                	push   $0x29
  80208d:	e8 fd fa ff ff       	call   801b8f <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
	return ;
  802095:	90                   	nop
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <inctst>:

void inctst()
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 2a                	push   $0x2a
  8020a7:	e8 e3 fa ff ff       	call   801b8f <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8020af:	90                   	nop
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <gettst>:
uint32 gettst()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 2b                	push   $0x2b
  8020c1:	e8 c9 fa ff ff       	call   801b8f <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 2c                	push   $0x2c
  8020dd:	e8 ad fa ff ff       	call   801b8f <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
  8020e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020e8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020ec:	75 07                	jne    8020f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	eb 05                	jmp    8020fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 2c                	push   $0x2c
  80210e:	e8 7c fa ff ff       	call   801b8f <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
  802116:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802119:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80211d:	75 07                	jne    802126 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80211f:	b8 01 00 00 00       	mov    $0x1,%eax
  802124:	eb 05                	jmp    80212b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 2c                	push   $0x2c
  80213f:	e8 4b fa ff ff       	call   801b8f <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
  802147:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80214a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80214e:	75 07                	jne    802157 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802150:	b8 01 00 00 00       	mov    $0x1,%eax
  802155:	eb 05                	jmp    80215c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 2c                	push   $0x2c
  802170:	e8 1a fa ff ff       	call   801b8f <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
  802178:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80217b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80217f:	75 07                	jne    802188 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802181:	b8 01 00 00 00       	mov    $0x1,%eax
  802186:	eb 05                	jmp    80218d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	6a 2d                	push   $0x2d
  80219f:	e8 eb f9 ff ff       	call   801b8f <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a7:	90                   	nop
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	6a 00                	push   $0x0
  8021bc:	53                   	push   %ebx
  8021bd:	51                   	push   %ecx
  8021be:	52                   	push   %edx
  8021bf:	50                   	push   %eax
  8021c0:	6a 2e                	push   $0x2e
  8021c2:	e8 c8 f9 ff ff       	call   801b8f <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
}
  8021ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	52                   	push   %edx
  8021df:	50                   	push   %eax
  8021e0:	6a 2f                	push   $0x2f
  8021e2:	e8 a8 f9 ff ff       	call   801b8f <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8021f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8021f5:	83 c0 04             	add    $0x4,%eax
  8021f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8021fb:	a1 20 31 a0 00       	mov    0xa03120,%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 16                	je     80221a <_panic+0x2e>
		cprintf("%s: ", argv0);
  802204:	a1 20 31 a0 00       	mov    0xa03120,%eax
  802209:	83 ec 08             	sub    $0x8,%esp
  80220c:	50                   	push   %eax
  80220d:	68 a8 2a 80 00       	push   $0x802aa8
  802212:	e8 85 e6 ff ff       	call   80089c <cprintf>
  802217:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80221a:	a1 00 30 80 00       	mov    0x803000,%eax
  80221f:	ff 75 0c             	pushl  0xc(%ebp)
  802222:	ff 75 08             	pushl  0x8(%ebp)
  802225:	50                   	push   %eax
  802226:	68 ad 2a 80 00       	push   $0x802aad
  80222b:	e8 6c e6 ff ff       	call   80089c <cprintf>
  802230:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802233:	8b 45 10             	mov    0x10(%ebp),%eax
  802236:	83 ec 08             	sub    $0x8,%esp
  802239:	ff 75 f4             	pushl  -0xc(%ebp)
  80223c:	50                   	push   %eax
  80223d:	e8 ef e5 ff ff       	call   800831 <vcprintf>
  802242:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802245:	83 ec 08             	sub    $0x8,%esp
  802248:	6a 00                	push   $0x0
  80224a:	68 c9 2a 80 00       	push   $0x802ac9
  80224f:	e8 dd e5 ff ff       	call   800831 <vcprintf>
  802254:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802257:	e8 5e e5 ff ff       	call   8007ba <exit>

	// should not return here
	while (1) ;
  80225c:	eb fe                	jmp    80225c <_panic+0x70>

0080225e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802264:	a1 20 30 80 00       	mov    0x803020,%eax
  802269:	8b 50 74             	mov    0x74(%eax),%edx
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	39 c2                	cmp    %eax,%edx
  802271:	74 14                	je     802287 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 cc 2a 80 00       	push   $0x802acc
  80227b:	6a 26                	push   $0x26
  80227d:	68 18 2b 80 00       	push   $0x802b18
  802282:	e8 65 ff ff ff       	call   8021ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802287:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80228e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802295:	e9 b6 00 00 00       	jmp    802350 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	8b 00                	mov    (%eax),%eax
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	75 08                	jne    8022b7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8022af:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8022b2:	e9 96 00 00 00       	jmp    80234d <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8022b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8022c5:	eb 5d                	jmp    802324 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8022c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8022cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8022d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022d5:	c1 e2 04             	shl    $0x4,%edx
  8022d8:	01 d0                	add    %edx,%eax
  8022da:	8a 40 04             	mov    0x4(%eax),%al
  8022dd:	84 c0                	test   %al,%al
  8022df:	75 40                	jne    802321 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8022e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8022e6:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8022ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022ef:	c1 e2 04             	shl    $0x4,%edx
  8022f2:	01 d0                	add    %edx,%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8022f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802301:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	01 c8                	add    %ecx,%eax
  802312:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802314:	39 c2                	cmp    %eax,%edx
  802316:	75 09                	jne    802321 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  802318:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80231f:	eb 12                	jmp    802333 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802321:	ff 45 e8             	incl   -0x18(%ebp)
  802324:	a1 20 30 80 00       	mov    0x803020,%eax
  802329:	8b 50 74             	mov    0x74(%eax),%edx
  80232c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232f:	39 c2                	cmp    %eax,%edx
  802331:	77 94                	ja     8022c7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802333:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802337:	75 14                	jne    80234d <CheckWSWithoutLastIndex+0xef>
			panic(
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 24 2b 80 00       	push   $0x802b24
  802341:	6a 3a                	push   $0x3a
  802343:	68 18 2b 80 00       	push   $0x802b18
  802348:	e8 9f fe ff ff       	call   8021ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80234d:	ff 45 f0             	incl   -0x10(%ebp)
  802350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802353:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802356:	0f 8c 3e ff ff ff    	jl     80229a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80235c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802363:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80236a:	eb 20                	jmp    80238c <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80236c:	a1 20 30 80 00       	mov    0x803020,%eax
  802371:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802377:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80237a:	c1 e2 04             	shl    $0x4,%edx
  80237d:	01 d0                	add    %edx,%eax
  80237f:	8a 40 04             	mov    0x4(%eax),%al
  802382:	3c 01                	cmp    $0x1,%al
  802384:	75 03                	jne    802389 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802386:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802389:	ff 45 e0             	incl   -0x20(%ebp)
  80238c:	a1 20 30 80 00       	mov    0x803020,%eax
  802391:	8b 50 74             	mov    0x74(%eax),%edx
  802394:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802397:	39 c2                	cmp    %eax,%edx
  802399:	77 d1                	ja     80236c <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8023a1:	74 14                	je     8023b7 <CheckWSWithoutLastIndex+0x159>
		panic(
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	68 78 2b 80 00       	push   $0x802b78
  8023ab:	6a 44                	push   $0x44
  8023ad:	68 18 2b 80 00       	push   $0x802b18
  8023b2:	e8 35 fe ff ff       	call   8021ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8023b7:	90                   	nop
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    
  8023ba:	66 90                	xchg   %ax,%ax

008023bc <__udivdi3>:
  8023bc:	55                   	push   %ebp
  8023bd:	57                   	push   %edi
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 1c             	sub    $0x1c,%esp
  8023c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d3:	89 ca                	mov    %ecx,%edx
  8023d5:	89 f8                	mov    %edi,%eax
  8023d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023db:	85 f6                	test   %esi,%esi
  8023dd:	75 2d                	jne    80240c <__udivdi3+0x50>
  8023df:	39 cf                	cmp    %ecx,%edi
  8023e1:	77 65                	ja     802448 <__udivdi3+0x8c>
  8023e3:	89 fd                	mov    %edi,%ebp
  8023e5:	85 ff                	test   %edi,%edi
  8023e7:	75 0b                	jne    8023f4 <__udivdi3+0x38>
  8023e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ee:	31 d2                	xor    %edx,%edx
  8023f0:	f7 f7                	div    %edi
  8023f2:	89 c5                	mov    %eax,%ebp
  8023f4:	31 d2                	xor    %edx,%edx
  8023f6:	89 c8                	mov    %ecx,%eax
  8023f8:	f7 f5                	div    %ebp
  8023fa:	89 c1                	mov    %eax,%ecx
  8023fc:	89 d8                	mov    %ebx,%eax
  8023fe:	f7 f5                	div    %ebp
  802400:	89 cf                	mov    %ecx,%edi
  802402:	89 fa                	mov    %edi,%edx
  802404:	83 c4 1c             	add    $0x1c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    
  80240c:	39 ce                	cmp    %ecx,%esi
  80240e:	77 28                	ja     802438 <__udivdi3+0x7c>
  802410:	0f bd fe             	bsr    %esi,%edi
  802413:	83 f7 1f             	xor    $0x1f,%edi
  802416:	75 40                	jne    802458 <__udivdi3+0x9c>
  802418:	39 ce                	cmp    %ecx,%esi
  80241a:	72 0a                	jb     802426 <__udivdi3+0x6a>
  80241c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802420:	0f 87 9e 00 00 00    	ja     8024c4 <__udivdi3+0x108>
  802426:	b8 01 00 00 00       	mov    $0x1,%eax
  80242b:	89 fa                	mov    %edi,%edx
  80242d:	83 c4 1c             	add    $0x1c,%esp
  802430:	5b                   	pop    %ebx
  802431:	5e                   	pop    %esi
  802432:	5f                   	pop    %edi
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	89 fa                	mov    %edi,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	66 90                	xchg   %ax,%ax
  802448:	89 d8                	mov    %ebx,%eax
  80244a:	f7 f7                	div    %edi
  80244c:	31 ff                	xor    %edi,%edi
  80244e:	89 fa                	mov    %edi,%edx
  802450:	83 c4 1c             	add    $0x1c,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	bd 20 00 00 00       	mov    $0x20,%ebp
  80245d:	89 eb                	mov    %ebp,%ebx
  80245f:	29 fb                	sub    %edi,%ebx
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e6                	shl    %cl,%esi
  802465:	89 c5                	mov    %eax,%ebp
  802467:	88 d9                	mov    %bl,%cl
  802469:	d3 ed                	shr    %cl,%ebp
  80246b:	89 e9                	mov    %ebp,%ecx
  80246d:	09 f1                	or     %esi,%ecx
  80246f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802473:	89 f9                	mov    %edi,%ecx
  802475:	d3 e0                	shl    %cl,%eax
  802477:	89 c5                	mov    %eax,%ebp
  802479:	89 d6                	mov    %edx,%esi
  80247b:	88 d9                	mov    %bl,%cl
  80247d:	d3 ee                	shr    %cl,%esi
  80247f:	89 f9                	mov    %edi,%ecx
  802481:	d3 e2                	shl    %cl,%edx
  802483:	8b 44 24 08          	mov    0x8(%esp),%eax
  802487:	88 d9                	mov    %bl,%cl
  802489:	d3 e8                	shr    %cl,%eax
  80248b:	09 c2                	or     %eax,%edx
  80248d:	89 d0                	mov    %edx,%eax
  80248f:	89 f2                	mov    %esi,%edx
  802491:	f7 74 24 0c          	divl   0xc(%esp)
  802495:	89 d6                	mov    %edx,%esi
  802497:	89 c3                	mov    %eax,%ebx
  802499:	f7 e5                	mul    %ebp
  80249b:	39 d6                	cmp    %edx,%esi
  80249d:	72 19                	jb     8024b8 <__udivdi3+0xfc>
  80249f:	74 0b                	je     8024ac <__udivdi3+0xf0>
  8024a1:	89 d8                	mov    %ebx,%eax
  8024a3:	31 ff                	xor    %edi,%edi
  8024a5:	e9 58 ff ff ff       	jmp    802402 <__udivdi3+0x46>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024b0:	89 f9                	mov    %edi,%ecx
  8024b2:	d3 e2                	shl    %cl,%edx
  8024b4:	39 c2                	cmp    %eax,%edx
  8024b6:	73 e9                	jae    8024a1 <__udivdi3+0xe5>
  8024b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024bb:	31 ff                	xor    %edi,%edi
  8024bd:	e9 40 ff ff ff       	jmp    802402 <__udivdi3+0x46>
  8024c2:	66 90                	xchg   %ax,%ax
  8024c4:	31 c0                	xor    %eax,%eax
  8024c6:	e9 37 ff ff ff       	jmp    802402 <__udivdi3+0x46>
  8024cb:	90                   	nop

008024cc <__umoddi3>:
  8024cc:	55                   	push   %ebp
  8024cd:	57                   	push   %edi
  8024ce:	56                   	push   %esi
  8024cf:	53                   	push   %ebx
  8024d0:	83 ec 1c             	sub    $0x1c,%esp
  8024d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024eb:	89 f3                	mov    %esi,%ebx
  8024ed:	89 fa                	mov    %edi,%edx
  8024ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024f3:	89 34 24             	mov    %esi,(%esp)
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	75 1a                	jne    802514 <__umoddi3+0x48>
  8024fa:	39 f7                	cmp    %esi,%edi
  8024fc:	0f 86 a2 00 00 00    	jbe    8025a4 <__umoddi3+0xd8>
  802502:	89 c8                	mov    %ecx,%eax
  802504:	89 f2                	mov    %esi,%edx
  802506:	f7 f7                	div    %edi
  802508:	89 d0                	mov    %edx,%eax
  80250a:	31 d2                	xor    %edx,%edx
  80250c:	83 c4 1c             	add    $0x1c,%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
  802514:	39 f0                	cmp    %esi,%eax
  802516:	0f 87 ac 00 00 00    	ja     8025c8 <__umoddi3+0xfc>
  80251c:	0f bd e8             	bsr    %eax,%ebp
  80251f:	83 f5 1f             	xor    $0x1f,%ebp
  802522:	0f 84 ac 00 00 00    	je     8025d4 <__umoddi3+0x108>
  802528:	bf 20 00 00 00       	mov    $0x20,%edi
  80252d:	29 ef                	sub    %ebp,%edi
  80252f:	89 fe                	mov    %edi,%esi
  802531:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802535:	89 e9                	mov    %ebp,%ecx
  802537:	d3 e0                	shl    %cl,%eax
  802539:	89 d7                	mov    %edx,%edi
  80253b:	89 f1                	mov    %esi,%ecx
  80253d:	d3 ef                	shr    %cl,%edi
  80253f:	09 c7                	or     %eax,%edi
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 e2                	shl    %cl,%edx
  802545:	89 14 24             	mov    %edx,(%esp)
  802548:	89 d8                	mov    %ebx,%eax
  80254a:	d3 e0                	shl    %cl,%eax
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802552:	d3 e0                	shl    %cl,%eax
  802554:	89 44 24 04          	mov    %eax,0x4(%esp)
  802558:	8b 44 24 08          	mov    0x8(%esp),%eax
  80255c:	89 f1                	mov    %esi,%ecx
  80255e:	d3 e8                	shr    %cl,%eax
  802560:	09 d0                	or     %edx,%eax
  802562:	d3 eb                	shr    %cl,%ebx
  802564:	89 da                	mov    %ebx,%edx
  802566:	f7 f7                	div    %edi
  802568:	89 d3                	mov    %edx,%ebx
  80256a:	f7 24 24             	mull   (%esp)
  80256d:	89 c6                	mov    %eax,%esi
  80256f:	89 d1                	mov    %edx,%ecx
  802571:	39 d3                	cmp    %edx,%ebx
  802573:	0f 82 87 00 00 00    	jb     802600 <__umoddi3+0x134>
  802579:	0f 84 91 00 00 00    	je     802610 <__umoddi3+0x144>
  80257f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802583:	29 f2                	sub    %esi,%edx
  802585:	19 cb                	sbb    %ecx,%ebx
  802587:	89 d8                	mov    %ebx,%eax
  802589:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80258d:	d3 e0                	shl    %cl,%eax
  80258f:	89 e9                	mov    %ebp,%ecx
  802591:	d3 ea                	shr    %cl,%edx
  802593:	09 d0                	or     %edx,%eax
  802595:	89 e9                	mov    %ebp,%ecx
  802597:	d3 eb                	shr    %cl,%ebx
  802599:	89 da                	mov    %ebx,%edx
  80259b:	83 c4 1c             	add    $0x1c,%esp
  80259e:	5b                   	pop    %ebx
  80259f:	5e                   	pop    %esi
  8025a0:	5f                   	pop    %edi
  8025a1:	5d                   	pop    %ebp
  8025a2:	c3                   	ret    
  8025a3:	90                   	nop
  8025a4:	89 fd                	mov    %edi,%ebp
  8025a6:	85 ff                	test   %edi,%edi
  8025a8:	75 0b                	jne    8025b5 <__umoddi3+0xe9>
  8025aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025af:	31 d2                	xor    %edx,%edx
  8025b1:	f7 f7                	div    %edi
  8025b3:	89 c5                	mov    %eax,%ebp
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	31 d2                	xor    %edx,%edx
  8025b9:	f7 f5                	div    %ebp
  8025bb:	89 c8                	mov    %ecx,%eax
  8025bd:	f7 f5                	div    %ebp
  8025bf:	89 d0                	mov    %edx,%eax
  8025c1:	e9 44 ff ff ff       	jmp    80250a <__umoddi3+0x3e>
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	89 c8                	mov    %ecx,%eax
  8025ca:	89 f2                	mov    %esi,%edx
  8025cc:	83 c4 1c             	add    $0x1c,%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    
  8025d4:	3b 04 24             	cmp    (%esp),%eax
  8025d7:	72 06                	jb     8025df <__umoddi3+0x113>
  8025d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025dd:	77 0f                	ja     8025ee <__umoddi3+0x122>
  8025df:	89 f2                	mov    %esi,%edx
  8025e1:	29 f9                	sub    %edi,%ecx
  8025e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025e7:	89 14 24             	mov    %edx,(%esp)
  8025ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f2:	8b 14 24             	mov    (%esp),%edx
  8025f5:	83 c4 1c             	add    $0x1c,%esp
  8025f8:	5b                   	pop    %ebx
  8025f9:	5e                   	pop    %esi
  8025fa:	5f                   	pop    %edi
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	2b 04 24             	sub    (%esp),%eax
  802603:	19 fa                	sbb    %edi,%edx
  802605:	89 d1                	mov    %edx,%ecx
  802607:	89 c6                	mov    %eax,%esi
  802609:	e9 71 ff ff ff       	jmp    80257f <__umoddi3+0xb3>
  80260e:	66 90                	xchg   %ax,%ax
  802610:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802614:	72 ea                	jb     802600 <__umoddi3+0x134>
  802616:	89 d9                	mov    %ebx,%ecx
  802618:	e9 62 ff ff ff       	jmp    80257f <__umoddi3+0xb3>
