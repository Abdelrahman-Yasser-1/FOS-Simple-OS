
obj/user/tstmod1:     file format elf32-i386


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
  800031:	e8 d8 05 00 00       	call   80060e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	
	rsttst();
  800040:	e8 7e 1f 00 00       	call   801fc3 <rsttst>
	
	

	int Mega = 1024*1024;
  800045:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  80004c:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  800053:	8d 55 8c             	lea    -0x74(%ebp),%edx
  800056:	b9 14 00 00 00       	mov    $0x14,%ecx
  80005b:	b8 00 00 00 00       	mov    $0x0,%eax
  800060:	89 d7                	mov    %edx,%edi
  800062:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800064:	e8 1d 1c 00 00       	call   801c86 <sys_calculate_free_frames>
  800069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	50                   	push   %eax
  800076:	e8 36 15 00 00       	call   8015b1 <malloc>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 8c             	mov    %eax,-0x74(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  800081:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	6a 00                	push   $0x0
  800089:	6a 62                	push   $0x62
  80008b:	68 00 10 00 80       	push   $0x80001000
  800090:	68 00 00 00 80       	push   $0x80000000
  800095:	50                   	push   %eax
  800096:	e8 42 1f 00 00       	call   801fdd <tst>
  80009b:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256+1 ,0, 'e', 0);
  80009e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000a1:	e8 e0 1b 00 00       	call   801c86 <sys_calculate_free_frames>
  8000a6:	29 c3                	sub    %eax,%ebx
  8000a8:	89 d8                	mov    %ebx,%eax
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 65                	push   $0x65
  8000b1:	6a 00                	push   $0x0
  8000b3:	68 01 01 00 00       	push   $0x101
  8000b8:	50                   	push   %eax
  8000b9:	e8 1f 1f 00 00       	call   801fdd <tst>
  8000be:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c1:	e8 c0 1b 00 00       	call   801c86 <sys_calculate_free_frames>
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  8000c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	50                   	push   %eax
  8000d3:	e8 d9 14 00 00       	call   8015b1 <malloc>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 90             	mov    %eax,-0x70(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START + 1*Mega,USER_HEAP_START + 1*Mega + PAGE_SIZE, 'b', 0);
  8000de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e1:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8000f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	6a 62                	push   $0x62
  8000fa:	51                   	push   %ecx
  8000fb:	52                   	push   %edx
  8000fc:	50                   	push   %eax
  8000fd:	e8 db 1e 00 00       	call   801fdd <tst>
  800102:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  800105:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800108:	e8 79 1b 00 00       	call   801c86 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	6a 00                	push   $0x0
  800116:	6a 65                	push   $0x65
  800118:	6a 00                	push   $0x0
  80011a:	68 00 01 00 00       	push   $0x100
  80011f:	50                   	push   %eax
  800120:	e8 b8 1e 00 00       	call   801fdd <tst>
  800125:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800128:	e8 59 1b 00 00       	call   801c86 <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800133:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	50                   	push   %eax
  80013a:	e8 72 14 00 00       	call   8015b1 <malloc>
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	89 45 94             	mov    %eax,-0x6c(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START + 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  800145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800148:	01 c0                	add    %eax,%eax
  80014a:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80015b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	6a 00                	push   $0x0
  800163:	6a 62                	push   $0x62
  800165:	51                   	push   %ecx
  800166:	52                   	push   %edx
  800167:	50                   	push   %eax
  800168:	e8 70 1e 00 00       	call   801fdd <tst>
  80016d:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  800170:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800173:	e8 0e 1b 00 00       	call   801c86 <sys_calculate_free_frames>
  800178:	29 c3                	sub    %eax,%ebx
  80017a:	89 d8                	mov    %ebx,%eax
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	6a 00                	push   $0x0
  800181:	6a 65                	push   $0x65
  800183:	6a 00                	push   $0x0
  800185:	68 00 01 00 00       	push   $0x100
  80018a:	50                   	push   %eax
  80018b:	e8 4d 1e 00 00       	call   801fdd <tst>
  800190:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800193:	e8 ee 1a 00 00       	call   801c86 <sys_calculate_free_frames>
  800198:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80019b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	50                   	push   %eax
  8001a5:	e8 07 14 00 00       	call   8015b1 <malloc>
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	89 45 98             	mov    %eax,-0x68(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START + 3*Mega,USER_HEAP_START + 3*Mega + PAGE_SIZE, 'b', 0);
  8001b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b3:	89 c2                	mov    %eax,%edx
  8001b5:	01 d2                	add    %edx,%edx
  8001b7:	01 d0                	add    %edx,%eax
  8001b9:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c2:	89 c2                	mov    %eax,%edx
  8001c4:	01 d2                	add    %edx,%edx
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001ce:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	6a 00                	push   $0x0
  8001d6:	6a 62                	push   $0x62
  8001d8:	51                   	push   %ecx
  8001d9:	52                   	push   %edx
  8001da:	50                   	push   %eax
  8001db:	e8 fd 1d 00 00       	call   801fdd <tst>
  8001e0:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  8001e3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e6:	e8 9b 1a 00 00       	call   801c86 <sys_calculate_free_frames>
  8001eb:	29 c3                	sub    %eax,%ebx
  8001ed:	89 d8                	mov    %ebx,%eax
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 00                	push   $0x0
  8001f4:	6a 65                	push   $0x65
  8001f6:	6a 00                	push   $0x0
  8001f8:	68 00 01 00 00       	push   $0x100
  8001fd:	50                   	push   %eax
  8001fe:	e8 da 1d 00 00       	call   801fdd <tst>
  800203:	83 c4 20             	add    $0x20,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800206:	e8 7b 1a 00 00       	call   801c86 <sys_calculate_free_frames>
  80020b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	50                   	push   %eax
  80021a:	e8 92 13 00 00       	call   8015b1 <malloc>
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START + 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800228:	c1 e0 02             	shl    $0x2,%eax
  80022b:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800231:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800234:	c1 e0 02             	shl    $0x2,%eax
  800237:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80023d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	6a 00                	push   $0x0
  800245:	6a 62                	push   $0x62
  800247:	51                   	push   %ecx
  800248:	52                   	push   %edx
  800249:	50                   	push   %eax
  80024a:	e8 8e 1d 00 00       	call   801fdd <tst>
  80024f:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  800252:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800255:	e8 2c 1a 00 00       	call   801c86 <sys_calculate_free_frames>
  80025a:	29 c3                	sub    %eax,%ebx
  80025c:	89 d8                	mov    %ebx,%eax
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	6a 00                	push   $0x0
  800263:	6a 65                	push   $0x65
  800265:	6a 00                	push   $0x0
  800267:	68 01 02 00 00       	push   $0x201
  80026c:	50                   	push   %eax
  80026d:	e8 6b 1d 00 00       	call   801fdd <tst>
  800272:	83 c4 20             	add    $0x20,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800275:	e8 0c 1a 00 00       	call   801c86 <sys_calculate_free_frames>
  80027a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80027d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800280:	01 c0                	add    %eax,%eax
  800282:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	50                   	push   %eax
  800289:	e8 23 13 00 00       	call   8015b1 <malloc>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 a0             	mov    %eax,-0x60(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START + 6*Mega,USER_HEAP_START + 6*Mega + PAGE_SIZE, 'b', 0);
  800294:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800297:	89 d0                	mov    %edx,%eax
  800299:	01 c0                	add    %eax,%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	01 c0                	add    %eax,%eax
  80029f:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8002a8:	89 d0                	mov    %edx,%eax
  8002aa:	01 c0                	add    %eax,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	01 c0                	add    %eax,%eax
  8002b0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002b6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	6a 00                	push   $0x0
  8002be:	6a 62                	push   $0x62
  8002c0:	51                   	push   %ecx
  8002c1:	52                   	push   %edx
  8002c2:	50                   	push   %eax
  8002c3:	e8 15 1d 00 00       	call   801fdd <tst>
  8002c8:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  8002cb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8002ce:	e8 b3 19 00 00       	call   801c86 <sys_calculate_free_frames>
  8002d3:	29 c3                	sub    %eax,%ebx
  8002d5:	89 d8                	mov    %ebx,%eax
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	6a 65                	push   $0x65
  8002de:	6a 00                	push   $0x0
  8002e0:	68 00 02 00 00       	push   $0x200
  8002e5:	50                   	push   %eax
  8002e6:	e8 f2 1c 00 00       	call   801fdd <tst>
  8002eb:	83 c4 20             	add    $0x20,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ee:	e8 93 19 00 00       	call   801c86 <sys_calculate_free_frames>
  8002f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8002f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f9:	89 c2                	mov    %eax,%edx
  8002fb:	01 d2                	add    %edx,%edx
  8002fd:	01 d0                	add    %edx,%eax
  8002ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	50                   	push   %eax
  800306:	e8 a6 12 00 00       	call   8015b1 <malloc>
  80030b:	83 c4 10             	add    $0x10,%esp
  80030e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START + 8*Mega,USER_HEAP_START + 8*Mega + PAGE_SIZE, 'b', 0);
  800311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800314:	c1 e0 03             	shl    $0x3,%eax
  800317:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80031d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800320:	c1 e0 03             	shl    $0x3,%eax
  800323:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800329:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	6a 00                	push   $0x0
  800331:	6a 62                	push   $0x62
  800333:	51                   	push   %ecx
  800334:	52                   	push   %edx
  800335:	50                   	push   %eax
  800336:	e8 a2 1c 00 00       	call   801fdd <tst>
  80033b:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 768+1 ,0, 'e', 0);
  80033e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800341:	e8 40 19 00 00       	call   801c86 <sys_calculate_free_frames>
  800346:	29 c3                	sub    %eax,%ebx
  800348:	89 d8                	mov    %ebx,%eax
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	6a 00                	push   $0x0
  80034f:	6a 65                	push   $0x65
  800351:	6a 00                	push   $0x0
  800353:	68 01 03 00 00       	push   $0x301
  800358:	50                   	push   %eax
  800359:	e8 7f 1c 00 00       	call   801fdd <tst>
  80035e:	83 c4 20             	add    $0x20,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800361:	e8 20 19 00 00       	call   801c86 <sys_calculate_free_frames>
  800366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80036c:	89 c2                	mov    %eax,%edx
  80036e:	01 d2                	add    %edx,%edx
  800370:	01 d0                	add    %edx,%eax
  800372:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800375:	83 ec 0c             	sub    $0xc,%esp
  800378:	50                   	push   %eax
  800379:	e8 33 12 00 00       	call   8015b1 <malloc>
  80037e:	83 c4 10             	add    $0x10,%esp
  800381:	89 45 a8             	mov    %eax,-0x58(%ebp)
		tst((uint32) ptr_allocations[7], USER_HEAP_START + 11*Mega,USER_HEAP_START + 11*Mega + PAGE_SIZE, 'b', 0);
  800384:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800387:	89 d0                	mov    %edx,%eax
  800389:	c1 e0 02             	shl    $0x2,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	01 c0                	add    %eax,%eax
  800390:	01 d0                	add    %edx,%eax
  800392:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800398:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	c1 e0 02             	shl    $0x2,%eax
  8003a0:	01 d0                	add    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8003ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003af:	83 ec 0c             	sub    $0xc,%esp
  8003b2:	6a 00                	push   $0x0
  8003b4:	6a 62                	push   $0x62
  8003b6:	51                   	push   %ecx
  8003b7:	52                   	push   %edx
  8003b8:	50                   	push   %eax
  8003b9:	e8 1f 1c 00 00       	call   801fdd <tst>
  8003be:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 768+1 ,0, 'e', 0);
  8003c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8003c4:	e8 bd 18 00 00       	call   801c86 <sys_calculate_free_frames>
  8003c9:	29 c3                	sub    %eax,%ebx
  8003cb:	89 d8                	mov    %ebx,%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	6a 00                	push   $0x0
  8003d2:	6a 65                	push   $0x65
  8003d4:	6a 00                	push   $0x0
  8003d6:	68 01 03 00 00       	push   $0x301
  8003db:	50                   	push   %eax
  8003dc:	e8 fc 1b 00 00       	call   801fdd <tst>
  8003e1:	83 c4 20             	add    $0x20,%esp
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8003e4:	e8 9d 18 00 00       	call   801c86 <sys_calculate_free_frames>
  8003e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8003ec:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	50                   	push   %eax
  8003f3:	e8 e8 13 00 00       	call   8017e0 <free>
  8003f8:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 256,0, 'e', 0);
  8003fb:	e8 86 18 00 00       	call   801c86 <sys_calculate_free_frames>
  800400:	89 c2                	mov    %eax,%edx
  800402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800405:	29 c2                	sub    %eax,%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	6a 00                	push   $0x0
  80040e:	6a 65                	push   $0x65
  800410:	6a 00                	push   $0x0
  800412:	68 00 01 00 00       	push   $0x100
  800417:	50                   	push   %eax
  800418:	e8 c0 1b 00 00       	call   801fdd <tst>
  80041d:	83 c4 20             	add    $0x20,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800420:	e8 61 18 00 00       	call   801c86 <sys_calculate_free_frames>
  800425:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800428:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 ac 13 00 00       	call   8017e0 <free>
  800434:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512,0, 'e', 0);
  800437:	e8 4a 18 00 00       	call   801c86 <sys_calculate_free_frames>
  80043c:	89 c2                	mov    %eax,%edx
  80043e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800441:	29 c2                	sub    %eax,%edx
  800443:	89 d0                	mov    %edx,%eax
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	6a 00                	push   $0x0
  80044a:	6a 65                	push   $0x65
  80044c:	6a 00                	push   $0x0
  80044e:	68 00 02 00 00       	push   $0x200
  800453:	50                   	push   %eax
  800454:	e8 84 1b 00 00       	call   801fdd <tst>
  800459:	83 c4 20             	add    $0x20,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80045c:	e8 25 18 00 00       	call   801c86 <sys_calculate_free_frames>
  800461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  800464:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800467:	83 ec 0c             	sub    $0xc,%esp
  80046a:	50                   	push   %eax
  80046b:	e8 70 13 00 00       	call   8017e0 <free>
  800470:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 768,0, 'e', 0);
  800473:	e8 0e 18 00 00       	call   801c86 <sys_calculate_free_frames>
  800478:	89 c2                	mov    %eax,%edx
  80047a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047d:	29 c2                	sub    %eax,%edx
  80047f:	89 d0                	mov    %edx,%eax
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	6a 00                	push   $0x0
  800486:	6a 65                	push   $0x65
  800488:	6a 00                	push   $0x0
  80048a:	68 00 03 00 00       	push   $0x300
  80048f:	50                   	push   %eax
  800490:	e8 48 1b 00 00       	call   801fdd <tst>
  800495:	83 c4 20             	add    $0x20,%esp
	}
	int cnt = 0;
  800498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  80049f:	e8 e2 17 00 00       	call   801c86 <sys_calculate_free_frames>
  8004a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8004a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004aa:	89 d0                	mov    %edx,%eax
  8004ac:	c1 e0 09             	shl    $0x9,%eax
  8004af:	29 d0                	sub    %edx,%eax
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	50                   	push   %eax
  8004b5:	e8 f7 10 00 00       	call   8015b1 <malloc>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	89 45 ac             	mov    %eax,-0x54(%ebp)
		tst((uint32) ptr_allocations[8], USER_HEAP_START + 1*Mega,USER_HEAP_START + 1*Mega + PAGE_SIZE, 'b', 0);
  8004c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c3:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8004c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004cc:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8004d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004d5:	83 ec 0c             	sub    $0xc,%esp
  8004d8:	6a 00                	push   $0x0
  8004da:	6a 62                	push   $0x62
  8004dc:	51                   	push   %ecx
  8004dd:	52                   	push   %edx
  8004de:	50                   	push   %eax
  8004df:	e8 f9 1a 00 00       	call   801fdd <tst>
  8004e4:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 128 ,0, 'e', 0);
  8004e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004ea:	e8 97 17 00 00       	call   801c86 <sys_calculate_free_frames>
  8004ef:	29 c3                	sub    %eax,%ebx
  8004f1:	89 d8                	mov    %ebx,%eax
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	6a 00                	push   $0x0
  8004f8:	6a 65                	push   $0x65
  8004fa:	6a 00                	push   $0x0
  8004fc:	68 80 00 00 00       	push   $0x80
  800501:	50                   	push   %eax
  800502:	e8 d6 1a 00 00       	call   801fdd <tst>
  800507:	83 c4 20             	add    $0x20,%esp

		//Expand it
		freeFrames = sys_calculate_free_frames() ;
  80050a:	e8 77 17 00 00       	call   801c86 <sys_calculate_free_frames>
  80050f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		//expand(ptr_allocations[8], 512*kilo + 256*kilo - kilo);

		tst((freeFrames - sys_calculate_free_frames()) , 64 ,0, 'e', 0);
  800512:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800515:	e8 6c 17 00 00       	call   801c86 <sys_calculate_free_frames>
  80051a:	29 c3                	sub    %eax,%ebx
  80051c:	89 d8                	mov    %ebx,%eax
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	6a 00                	push   $0x0
  800523:	6a 65                	push   $0x65
  800525:	6a 00                	push   $0x0
  800527:	6a 40                	push   $0x40
  800529:	50                   	push   %eax
  80052a:	e8 ae 1a 00 00       	call   801fdd <tst>
  80052f:	83 c4 20             	add    $0x20,%esp

		int *intArr = (int*) ptr_allocations[8];
  800532:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int lastIndexOfInt = ((512+256)*kilo)/sizeof(int) - 1;
  800538:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	01 c0                	add    %eax,%eax
  80053f:	01 d0                	add    %edx,%eax
  800541:	c1 e0 08             	shl    $0x8,%eax
  800544:	c1 e8 02             	shr    $0x2,%eax
  800547:	48                   	dec    %eax
  800548:	89 45 dc             	mov    %eax,-0x24(%ebp)

		int i = 0;
  80054b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i=0; i < lastIndexOfInt ; i++)
  800552:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800559:	eb 1a                	jmp    800575 <_main+0x53d>
		{
			cnt++;
  80055b:	ff 45 f4             	incl   -0xc(%ebp)
			intArr[i] = i ;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800561:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056b:	01 c2                	add    %eax,%edx
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800570:	89 02                	mov    %eax,(%edx)

		int *intArr = (int*) ptr_allocations[8];
		int lastIndexOfInt = ((512+256)*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt ; i++)
  800572:	ff 45 f0             	incl   -0x10(%ebp)
  800575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800578:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80057b:	7c de                	jl     80055b <_main+0x523>
		{
			cnt++;
			intArr[i] = i ;
		}

		for (i=0; i < lastIndexOfInt ; i++)
  80057d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800584:	eb 2a                	jmp    8005b0 <_main+0x578>
		{
			tst(intArr[i], i,0, 'e', 0);
  800586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800589:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80058c:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	01 ca                	add    %ecx,%edx
  800598:	8b 12                	mov    (%edx),%edx
  80059a:	83 ec 0c             	sub    $0xc,%esp
  80059d:	6a 00                	push   $0x0
  80059f:	6a 65                	push   $0x65
  8005a1:	6a 00                	push   $0x0
  8005a3:	50                   	push   %eax
  8005a4:	52                   	push   %edx
  8005a5:	e8 33 1a 00 00       	call   801fdd <tst>
  8005aa:	83 c4 20             	add    $0x20,%esp
		{
			cnt++;
			intArr[i] = i ;
		}

		for (i=0; i < lastIndexOfInt ; i++)
  8005ad:	ff 45 f0             	incl   -0x10(%ebp)
  8005b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005b6:	7c ce                	jl     800586 <_main+0x54e>
		{
			tst(intArr[i], i,0, 'e', 0);
		}

		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 c9 16 00 00       	call   801c86 <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  8005c0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 14 12 00 00       	call   8017e0 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 192 ,0, 'e', 0);
  8005cf:	e8 b2 16 00 00       	call   801c86 <sys_calculate_free_frames>
  8005d4:	89 c2                	mov    %eax,%edx
  8005d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d9:	29 c2                	sub    %eax,%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	6a 00                	push   $0x0
  8005e2:	6a 65                	push   $0x65
  8005e4:	6a 00                	push   $0x0
  8005e6:	68 c0 00 00 00       	push   $0xc0
  8005eb:	50                   	push   %eax
  8005ec:	e8 ec 19 00 00       	call   801fdd <tst>
  8005f1:	83 c4 20             	add    $0x20,%esp
	}


	chktst(23 + cnt);
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	83 c0 17             	add    $0x17,%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	50                   	push   %eax
  8005fe:	e8 05 1a 00 00       	call   802008 <chktst>
  800603:	83 c4 10             	add    $0x10,%esp

	return;
  800606:	90                   	nop
}
  800607:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80060a:	5b                   	pop    %ebx
  80060b:	5f                   	pop    %edi
  80060c:	5d                   	pop    %ebp
  80060d:	c3                   	ret    

0080060e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800614:	e8 a2 15 00 00       	call   801bbb <sys_getenvindex>
  800619:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	c1 e0 03             	shl    $0x3,%eax
  800624:	01 d0                	add    %edx,%eax
  800626:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80062d:	01 c8                	add    %ecx,%eax
  80062f:	01 c0                	add    %eax,%eax
  800631:	01 d0                	add    %edx,%eax
  800633:	01 c0                	add    %eax,%eax
  800635:	01 d0                	add    %edx,%eax
  800637:	89 c2                	mov    %eax,%edx
  800639:	c1 e2 05             	shl    $0x5,%edx
  80063c:	29 c2                	sub    %eax,%edx
  80063e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800645:	89 c2                	mov    %eax,%edx
  800647:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80064d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800652:	a1 20 30 80 00       	mov    0x803020,%eax
  800657:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  80065d:	84 c0                	test   %al,%al
  80065f:	74 0f                	je     800670 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800661:	a1 20 30 80 00       	mov    0x803020,%eax
  800666:	05 40 3c 01 00       	add    $0x13c40,%eax
  80066b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800674:	7e 0a                	jle    800680 <libmain+0x72>
		binaryname = argv[0];
  800676:	8b 45 0c             	mov    0xc(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	ff 75 08             	pushl  0x8(%ebp)
  800689:	e8 aa f9 ff ff       	call   800038 <_main>
  80068e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800691:	e8 c0 16 00 00       	call   801d56 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	68 d8 25 80 00       	push   $0x8025d8
  80069e:	e8 84 01 00 00       	call   800827 <cprintf>
  8006a3:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ab:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8006b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b6:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006bc:	83 ec 04             	sub    $0x4,%esp
  8006bf:	52                   	push   %edx
  8006c0:	50                   	push   %eax
  8006c1:	68 00 26 80 00       	push   $0x802600
  8006c6:	e8 5c 01 00 00       	call   800827 <cprintf>
  8006cb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8006d3:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8006de:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006e4:	83 ec 04             	sub    $0x4,%esp
  8006e7:	52                   	push   %edx
  8006e8:	50                   	push   %eax
  8006e9:	68 28 26 80 00       	push   $0x802628
  8006ee:	e8 34 01 00 00       	call   800827 <cprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006fb:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	50                   	push   %eax
  800705:	68 69 26 80 00       	push   $0x802669
  80070a:	e8 18 01 00 00       	call   800827 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800712:	83 ec 0c             	sub    $0xc,%esp
  800715:	68 d8 25 80 00       	push   $0x8025d8
  80071a:	e8 08 01 00 00       	call   800827 <cprintf>
  80071f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800722:	e8 49 16 00 00       	call   801d70 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800727:	e8 19 00 00 00       	call   800745 <exit>
}
  80072c:	90                   	nop
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	6a 00                	push   $0x0
  80073a:	e8 48 14 00 00       	call   801b87 <sys_env_destroy>
  80073f:	83 c4 10             	add    $0x10,%esp
}
  800742:	90                   	nop
  800743:	c9                   	leave  
  800744:	c3                   	ret    

00800745 <exit>:

void
exit(void)
{
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
  800748:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  80074b:	e8 9d 14 00 00       	call   801bed <sys_env_exit>
}
  800750:	90                   	nop
  800751:	c9                   	leave  
  800752:	c3                   	ret    

00800753 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8d 48 01             	lea    0x1(%eax),%ecx
  800761:	8b 55 0c             	mov    0xc(%ebp),%edx
  800764:	89 0a                	mov    %ecx,(%edx)
  800766:	8b 55 08             	mov    0x8(%ebp),%edx
  800769:	88 d1                	mov    %dl,%cl
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800772:	8b 45 0c             	mov    0xc(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077c:	75 2c                	jne    8007aa <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80077e:	a0 24 30 80 00       	mov    0x803024,%al
  800783:	0f b6 c0             	movzbl %al,%eax
  800786:	8b 55 0c             	mov    0xc(%ebp),%edx
  800789:	8b 12                	mov    (%edx),%edx
  80078b:	89 d1                	mov    %edx,%ecx
  80078d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800790:	83 c2 08             	add    $0x8,%edx
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	50                   	push   %eax
  800797:	51                   	push   %ecx
  800798:	52                   	push   %edx
  800799:	e8 a7 13 00 00       	call   801b45 <sys_cputs>
  80079e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ad:	8b 40 04             	mov    0x4(%eax),%eax
  8007b0:	8d 50 01             	lea    0x1(%eax),%edx
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007cc:	00 00 00 
	b.cnt = 0;
  8007cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007d6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	ff 75 08             	pushl  0x8(%ebp)
  8007df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e5:	50                   	push   %eax
  8007e6:	68 53 07 80 00       	push   $0x800753
  8007eb:	e8 11 02 00 00       	call   800a01 <vprintfmt>
  8007f0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007f3:	a0 24 30 80 00       	mov    0x803024,%al
  8007f8:	0f b6 c0             	movzbl %al,%eax
  8007fb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800801:	83 ec 04             	sub    $0x4,%esp
  800804:	50                   	push   %eax
  800805:	52                   	push   %edx
  800806:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080c:	83 c0 08             	add    $0x8,%eax
  80080f:	50                   	push   %eax
  800810:	e8 30 13 00 00       	call   801b45 <sys_cputs>
  800815:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800818:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80081f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <cprintf>:

int cprintf(const char *fmt, ...) {
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80082d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800834:	8d 45 0c             	lea    0xc(%ebp),%eax
  800837:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	e8 73 ff ff ff       	call   8007bc <vcprintf>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80084f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80085a:	e8 f7 14 00 00       	call   801d56 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80085f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800862:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	ff 75 f4             	pushl  -0xc(%ebp)
  80086e:	50                   	push   %eax
  80086f:	e8 48 ff ff ff       	call   8007bc <vcprintf>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80087a:	e8 f1 14 00 00       	call   801d70 <sys_enable_interrupt>
	return cnt;
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800882:	c9                   	leave  
  800883:	c3                   	ret    

00800884 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	53                   	push   %ebx
  800888:	83 ec 14             	sub    $0x14,%esp
  80088b:	8b 45 10             	mov    0x10(%ebp),%eax
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800897:	8b 45 18             	mov    0x18(%ebp),%eax
  80089a:	ba 00 00 00 00       	mov    $0x0,%edx
  80089f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a2:	77 55                	ja     8008f9 <printnum+0x75>
  8008a4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a7:	72 05                	jb     8008ae <printnum+0x2a>
  8008a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008ac:	77 4b                	ja     8008f9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ae:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bc:	52                   	push   %edx
  8008bd:	50                   	push   %eax
  8008be:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008c4:	e8 7f 1a 00 00       	call   802348 <__udivdi3>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	83 ec 04             	sub    $0x4,%esp
  8008cf:	ff 75 20             	pushl  0x20(%ebp)
  8008d2:	53                   	push   %ebx
  8008d3:	ff 75 18             	pushl  0x18(%ebp)
  8008d6:	52                   	push   %edx
  8008d7:	50                   	push   %eax
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 a1 ff ff ff       	call   800884 <printnum>
  8008e3:	83 c4 20             	add    $0x20,%esp
  8008e6:	eb 1a                	jmp    800902 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 20             	pushl  0x20(%ebp)
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	ff d0                	call   *%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008f9:	ff 4d 1c             	decl   0x1c(%ebp)
  8008fc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800900:	7f e6                	jg     8008e8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800902:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800905:	bb 00 00 00 00       	mov    $0x0,%ebx
  80090a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800910:	53                   	push   %ebx
  800911:	51                   	push   %ecx
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	e8 3f 1b 00 00       	call   802458 <__umoddi3>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	05 94 28 80 00       	add    $0x802894,%eax
  800921:	8a 00                	mov    (%eax),%al
  800923:	0f be c0             	movsbl %al,%eax
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	50                   	push   %eax
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
}
  800935:	90                   	nop
  800936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800942:	7e 1c                	jle    800960 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	8d 50 08             	lea    0x8(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	89 10                	mov    %edx,(%eax)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	83 e8 08             	sub    $0x8,%eax
  800959:	8b 50 04             	mov    0x4(%eax),%edx
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	eb 40                	jmp    8009a0 <getuint+0x65>
	else if (lflag)
  800960:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800964:	74 1e                	je     800984 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	ba 00 00 00 00       	mov    $0x0,%edx
  800982:	eb 1c                	jmp    8009a0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 00                	mov    (%eax),%eax
  800989:	8d 50 04             	lea    0x4(%eax),%edx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	89 10                	mov    %edx,(%eax)
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	83 e8 04             	sub    $0x4,%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009a9:	7e 1c                	jle    8009c7 <getint+0x25>
		return va_arg(*ap, long long);
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	8d 50 08             	lea    0x8(%eax),%edx
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	89 10                	mov    %edx,(%eax)
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	83 e8 08             	sub    $0x8,%eax
  8009c0:	8b 50 04             	mov    0x4(%eax),%edx
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	eb 38                	jmp    8009ff <getint+0x5d>
	else if (lflag)
  8009c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cb:	74 1a                	je     8009e7 <getint+0x45>
		return va_arg(*ap, long);
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	8d 50 04             	lea    0x4(%eax),%edx
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	89 10                	mov    %edx,(%eax)
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	83 e8 04             	sub    $0x4,%eax
  8009e2:	8b 00                	mov    (%eax),%eax
  8009e4:	99                   	cltd   
  8009e5:	eb 18                	jmp    8009ff <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 04             	lea    0x4(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 04             	sub    $0x4,%eax
  8009fc:	8b 00                	mov    (%eax),%eax
  8009fe:	99                   	cltd   
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	56                   	push   %esi
  800a05:	53                   	push   %ebx
  800a06:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a09:	eb 17                	jmp    800a22 <vprintfmt+0x21>
			if (ch == '\0')
  800a0b:	85 db                	test   %ebx,%ebx
  800a0d:	0f 84 af 03 00 00    	je     800dc2 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	8d 50 01             	lea    0x1(%eax),%edx
  800a28:	89 55 10             	mov    %edx,0x10(%ebp)
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	0f b6 d8             	movzbl %al,%ebx
  800a30:	83 fb 25             	cmp    $0x25,%ebx
  800a33:	75 d6                	jne    800a0b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a35:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a39:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a47:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a4e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a55:	8b 45 10             	mov    0x10(%ebp),%eax
  800a58:	8d 50 01             	lea    0x1(%eax),%edx
  800a5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800a5e:	8a 00                	mov    (%eax),%al
  800a60:	0f b6 d8             	movzbl %al,%ebx
  800a63:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a66:	83 f8 55             	cmp    $0x55,%eax
  800a69:	0f 87 2b 03 00 00    	ja     800d9a <vprintfmt+0x399>
  800a6f:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  800a76:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a78:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a7c:	eb d7                	jmp    800a55 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a7e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a82:	eb d1                	jmp    800a55 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8e:	89 d0                	mov    %edx,%eax
  800a90:	c1 e0 02             	shl    $0x2,%eax
  800a93:	01 d0                	add    %edx,%eax
  800a95:	01 c0                	add    %eax,%eax
  800a97:	01 d8                	add    %ebx,%eax
  800a99:	83 e8 30             	sub    $0x30,%eax
  800a9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa7:	83 fb 2f             	cmp    $0x2f,%ebx
  800aaa:	7e 3e                	jle    800aea <vprintfmt+0xe9>
  800aac:	83 fb 39             	cmp    $0x39,%ebx
  800aaf:	7f 39                	jg     800aea <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ab4:	eb d5                	jmp    800a8b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ab6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 14             	mov    %eax,0x14(%ebp)
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	83 e8 04             	sub    $0x4,%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aca:	eb 1f                	jmp    800aeb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800acc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad0:	79 83                	jns    800a55 <vprintfmt+0x54>
				width = 0;
  800ad2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ad9:	e9 77 ff ff ff       	jmp    800a55 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ade:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ae5:	e9 6b ff ff ff       	jmp    800a55 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aea:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aef:	0f 89 60 ff ff ff    	jns    800a55 <vprintfmt+0x54>
				width = precision, precision = -1;
  800af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b02:	e9 4e ff ff ff       	jmp    800a55 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b07:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b0a:	e9 46 ff ff ff       	jmp    800a55 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 14             	mov    %eax,0x14(%ebp)
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 e8 04             	sub    $0x4,%eax
  800b1e:	8b 00                	mov    (%eax),%eax
  800b20:	83 ec 08             	sub    $0x8,%esp
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	50                   	push   %eax
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	ff d0                	call   *%eax
  800b2c:	83 c4 10             	add    $0x10,%esp
			break;
  800b2f:	e9 89 02 00 00       	jmp    800dbd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b34:	8b 45 14             	mov    0x14(%ebp),%eax
  800b37:	83 c0 04             	add    $0x4,%eax
  800b3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	83 e8 04             	sub    $0x4,%eax
  800b43:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b45:	85 db                	test   %ebx,%ebx
  800b47:	79 02                	jns    800b4b <vprintfmt+0x14a>
				err = -err;
  800b49:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b4b:	83 fb 64             	cmp    $0x64,%ebx
  800b4e:	7f 0b                	jg     800b5b <vprintfmt+0x15a>
  800b50:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800b57:	85 f6                	test   %esi,%esi
  800b59:	75 19                	jne    800b74 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b5b:	53                   	push   %ebx
  800b5c:	68 a5 28 80 00       	push   $0x8028a5
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	ff 75 08             	pushl  0x8(%ebp)
  800b67:	e8 5e 02 00 00       	call   800dca <printfmt>
  800b6c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b6f:	e9 49 02 00 00       	jmp    800dbd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b74:	56                   	push   %esi
  800b75:	68 ae 28 80 00       	push   $0x8028ae
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	ff 75 08             	pushl  0x8(%ebp)
  800b80:	e8 45 02 00 00       	call   800dca <printfmt>
  800b85:	83 c4 10             	add    $0x10,%esp
			break;
  800b88:	e9 30 02 00 00       	jmp    800dbd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b90:	83 c0 04             	add    $0x4,%eax
  800b93:	89 45 14             	mov    %eax,0x14(%ebp)
  800b96:	8b 45 14             	mov    0x14(%ebp),%eax
  800b99:	83 e8 04             	sub    $0x4,%eax
  800b9c:	8b 30                	mov    (%eax),%esi
  800b9e:	85 f6                	test   %esi,%esi
  800ba0:	75 05                	jne    800ba7 <vprintfmt+0x1a6>
				p = "(null)";
  800ba2:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800ba7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bab:	7e 6d                	jle    800c1a <vprintfmt+0x219>
  800bad:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bb1:	74 67                	je     800c1a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	50                   	push   %eax
  800bba:	56                   	push   %esi
  800bbb:	e8 0c 03 00 00       	call   800ecc <strnlen>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bc6:	eb 16                	jmp    800bde <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bc8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be2:	7f e4                	jg     800bc8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be4:	eb 34                	jmp    800c1a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800be6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bea:	74 1c                	je     800c08 <vprintfmt+0x207>
  800bec:	83 fb 1f             	cmp    $0x1f,%ebx
  800bef:	7e 05                	jle    800bf6 <vprintfmt+0x1f5>
  800bf1:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf4:	7e 12                	jle    800c08 <vprintfmt+0x207>
					putch('?', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 3f                	push   $0x3f
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	eb 0f                	jmp    800c17 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	53                   	push   %ebx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	89 f0                	mov    %esi,%eax
  800c1c:	8d 70 01             	lea    0x1(%eax),%esi
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	0f be d8             	movsbl %al,%ebx
  800c24:	85 db                	test   %ebx,%ebx
  800c26:	74 24                	je     800c4c <vprintfmt+0x24b>
  800c28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c2c:	78 b8                	js     800be6 <vprintfmt+0x1e5>
  800c2e:	ff 4d e0             	decl   -0x20(%ebp)
  800c31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c35:	79 af                	jns    800be6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c37:	eb 13                	jmp    800c4c <vprintfmt+0x24b>
				putch(' ', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 20                	push   $0x20
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c49:	ff 4d e4             	decl   -0x1c(%ebp)
  800c4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c50:	7f e7                	jg     800c39 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c52:	e9 66 01 00 00       	jmp    800dbd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c60:	50                   	push   %eax
  800c61:	e8 3c fd ff ff       	call   8009a2 <getint>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c75:	85 d2                	test   %edx,%edx
  800c77:	79 23                	jns    800c9c <vprintfmt+0x29b>
				putch('-', putdat);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 0c             	pushl  0xc(%ebp)
  800c7f:	6a 2d                	push   $0x2d
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	ff d0                	call   *%eax
  800c86:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c8f:	f7 d8                	neg    %eax
  800c91:	83 d2 00             	adc    $0x0,%edx
  800c94:	f7 da                	neg    %edx
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c9c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca3:	e9 bc 00 00 00       	jmp    800d64 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 84 fc ff ff       	call   80093b <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cc0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc7:	e9 98 00 00 00       	jmp    800d64 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	6a 58                	push   $0x58
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	6a 58                	push   $0x58
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	6a 58                	push   $0x58
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	ff d0                	call   *%eax
  800cf9:	83 c4 10             	add    $0x10,%esp
			break;
  800cfc:	e9 bc 00 00 00       	jmp    800dbd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d01:	83 ec 08             	sub    $0x8,%esp
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	6a 30                	push   $0x30
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	ff d0                	call   *%eax
  800d0e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	6a 78                	push   $0x78
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d21:	8b 45 14             	mov    0x14(%ebp),%eax
  800d24:	83 c0 04             	add    $0x4,%eax
  800d27:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2d:	83 e8 04             	sub    $0x4,%eax
  800d30:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d3c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d43:	eb 1f                	jmp    800d64 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4b:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4e:	50                   	push   %eax
  800d4f:	e8 e7 fb ff ff       	call   80093b <getuint>
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d5d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d64:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	52                   	push   %edx
  800d6f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d72:	50                   	push   %eax
  800d73:	ff 75 f4             	pushl  -0xc(%ebp)
  800d76:	ff 75 f0             	pushl  -0x10(%ebp)
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	ff 75 08             	pushl  0x8(%ebp)
  800d7f:	e8 00 fb ff ff       	call   800884 <printnum>
  800d84:	83 c4 20             	add    $0x20,%esp
			break;
  800d87:	eb 34                	jmp    800dbd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d89:	83 ec 08             	sub    $0x8,%esp
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	53                   	push   %ebx
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	ff d0                	call   *%eax
  800d95:	83 c4 10             	add    $0x10,%esp
			break;
  800d98:	eb 23                	jmp    800dbd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d9a:	83 ec 08             	sub    $0x8,%esp
  800d9d:	ff 75 0c             	pushl  0xc(%ebp)
  800da0:	6a 25                	push   $0x25
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	ff d0                	call   *%eax
  800da7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800daa:	ff 4d 10             	decl   0x10(%ebp)
  800dad:	eb 03                	jmp    800db2 <vprintfmt+0x3b1>
  800daf:	ff 4d 10             	decl   0x10(%ebp)
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	48                   	dec    %eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	3c 25                	cmp    $0x25,%al
  800dba:	75 f3                	jne    800daf <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800dbc:	90                   	nop
		}
	}
  800dbd:	e9 47 fc ff ff       	jmp    800a09 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dc2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dd0:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd3:	83 c0 04             	add    $0x4,%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	ff 75 f4             	pushl  -0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	ff 75 0c             	pushl  0xc(%ebp)
  800de3:	ff 75 08             	pushl  0x8(%ebp)
  800de6:	e8 16 fc ff ff       	call   800a01 <vprintfmt>
  800deb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dee:	90                   	nop
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	8b 40 08             	mov    0x8(%eax),%eax
  800dfa:	8d 50 01             	lea    0x1(%eax),%edx
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	8b 10                	mov    (%eax),%edx
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	8b 40 04             	mov    0x4(%eax),%eax
  800e0e:	39 c2                	cmp    %eax,%edx
  800e10:	73 12                	jae    800e24 <sprintputch+0x33>
		*b->buf++ = ch;
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	8b 00                	mov    (%eax),%eax
  800e17:	8d 48 01             	lea    0x1(%eax),%ecx
  800e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1d:	89 0a                	mov    %ecx,(%edx)
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	88 10                	mov    %dl,(%eax)
}
  800e24:	90                   	nop
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	01 d0                	add    %edx,%eax
  800e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e4c:	74 06                	je     800e54 <vsnprintf+0x2d>
  800e4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e52:	7f 07                	jg     800e5b <vsnprintf+0x34>
		return -E_INVAL;
  800e54:	b8 03 00 00 00       	mov    $0x3,%eax
  800e59:	eb 20                	jmp    800e7b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e5b:	ff 75 14             	pushl  0x14(%ebp)
  800e5e:	ff 75 10             	pushl  0x10(%ebp)
  800e61:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	68 f1 0d 80 00       	push   $0x800df1
  800e6a:	e8 92 fb ff ff       	call   800a01 <vprintfmt>
  800e6f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e75:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e83:	8d 45 10             	lea    0x10(%ebp),%eax
  800e86:	83 c0 04             	add    $0x4,%eax
  800e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e92:	50                   	push   %eax
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	ff 75 08             	pushl  0x8(%ebp)
  800e99:	e8 89 ff ff ff       	call   800e27 <vsnprintf>
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb6:	eb 06                	jmp    800ebe <strlen+0x15>
		n++;
  800eb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	84 c0                	test   %al,%al
  800ec5:	75 f1                	jne    800eb8 <strlen+0xf>
		n++;
	return n;
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed9:	eb 09                	jmp    800ee4 <strnlen+0x18>
		n++;
  800edb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	ff 4d 0c             	decl   0xc(%ebp)
  800ee4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee8:	74 09                	je     800ef3 <strnlen+0x27>
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	84 c0                	test   %al,%al
  800ef1:	75 e8                	jne    800edb <strnlen+0xf>
		n++;
	return n;
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f04:	90                   	nop
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	84 c0                	test   %al,%al
  800f1f:	75 e4                	jne    800f05 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f39:	eb 1f                	jmp    800f5a <strncpy+0x34>
		*dst++ = *src;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 08             	mov    %edx,0x8(%ebp)
  800f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f47:	8a 12                	mov    (%edx),%dl
  800f49:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	84 c0                	test   %al,%al
  800f52:	74 03                	je     800f57 <strncpy+0x31>
			src++;
  800f54:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f57:	ff 45 fc             	incl   -0x4(%ebp)
  800f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f60:	72 d9                	jb     800f3b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f77:	74 30                	je     800fa9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f79:	eb 16                	jmp    800f91 <strlcpy+0x2a>
			*dst++ = *src++;
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8d 50 01             	lea    0x1(%eax),%edx
  800f81:	89 55 08             	mov    %edx,0x8(%ebp)
  800f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f8d:	8a 12                	mov    (%edx),%dl
  800f8f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f91:	ff 4d 10             	decl   0x10(%ebp)
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 09                	je     800fa3 <strlcpy+0x3c>
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	84 c0                	test   %al,%al
  800fa1:	75 d8                	jne    800f7b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	29 c2                	sub    %eax,%edx
  800fb1:	89 d0                	mov    %edx,%eax
}
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fb8:	eb 06                	jmp    800fc0 <strcmp+0xb>
		p++, q++;
  800fba:	ff 45 08             	incl   0x8(%ebp)
  800fbd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 0e                	je     800fd7 <strcmp+0x22>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 10                	mov    (%eax),%dl
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	38 c2                	cmp    %al,%dl
  800fd5:	74 e3                	je     800fba <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f b6 d0             	movzbl %al,%edx
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 c0             	movzbl %al,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
}
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ff0:	eb 09                	jmp    800ffb <strncmp+0xe>
		n--, p++, q++;
  800ff2:	ff 4d 10             	decl   0x10(%ebp)
  800ff5:	ff 45 08             	incl   0x8(%ebp)
  800ff8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fff:	74 17                	je     801018 <strncmp+0x2b>
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	84 c0                	test   %al,%al
  801008:	74 0e                	je     801018 <strncmp+0x2b>
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 10                	mov    (%eax),%dl
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	38 c2                	cmp    %al,%dl
  801016:	74 da                	je     800ff2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101c:	75 07                	jne    801025 <strncmp+0x38>
		return 0;
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
  801023:	eb 14                	jmp    801039 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	0f b6 d0             	movzbl %al,%edx
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f b6 c0             	movzbl %al,%eax
  801035:	29 c2                	sub    %eax,%edx
  801037:	89 d0                	mov    %edx,%eax
}
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 04             	sub    $0x4,%esp
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801047:	eb 12                	jmp    80105b <strchr+0x20>
		if (*s == c)
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801051:	75 05                	jne    801058 <strchr+0x1d>
			return (char *) s;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	eb 11                	jmp    801069 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	84 c0                	test   %al,%al
  801062:	75 e5                	jne    801049 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801064:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 04             	sub    $0x4,%esp
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801077:	eb 0d                	jmp    801086 <strfind+0x1b>
		if (*s == c)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801081:	74 0e                	je     801091 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801083:	ff 45 08             	incl   0x8(%ebp)
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 ea                	jne    801079 <strfind+0xe>
  80108f:	eb 01                	jmp    801092 <strfind+0x27>
		if (*s == c)
			break;
  801091:	90                   	nop
	return (char *) s;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010a9:	eb 0e                	jmp    8010b9 <memset+0x22>
		*p++ = c;
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010b9:	ff 4d f8             	decl   -0x8(%ebp)
  8010bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010c0:	79 e9                	jns    8010ab <memset+0x14>
		*p++ = c;

	return v;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010d9:	eb 16                	jmp    8010f1 <memcpy+0x2a>
		*d++ = *s++;
  8010db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ea:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ed:	8a 12                	mov    (%edx),%dl
  8010ef:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 dd                	jne    8010db <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80111b:	73 50                	jae    80116d <memmove+0x6a>
  80111d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801128:	76 43                	jbe    80116d <memmove+0x6a>
		s += n;
  80112a:	8b 45 10             	mov    0x10(%ebp),%eax
  80112d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801136:	eb 10                	jmp    801148 <memmove+0x45>
			*--d = *--s;
  801138:	ff 4d f8             	decl   -0x8(%ebp)
  80113b:	ff 4d fc             	decl   -0x4(%ebp)
  80113e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801141:	8a 10                	mov    (%eax),%dl
  801143:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801146:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114e:	89 55 10             	mov    %edx,0x10(%ebp)
  801151:	85 c0                	test   %eax,%eax
  801153:	75 e3                	jne    801138 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801155:	eb 23                	jmp    80117a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115a:	8d 50 01             	lea    0x1(%eax),%edx
  80115d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801160:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801163:	8d 4a 01             	lea    0x1(%edx),%ecx
  801166:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801169:	8a 12                	mov    (%edx),%dl
  80116b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	8d 50 ff             	lea    -0x1(%eax),%edx
  801173:	89 55 10             	mov    %edx,0x10(%ebp)
  801176:	85 c0                	test   %eax,%eax
  801178:	75 dd                	jne    801157 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801191:	eb 2a                	jmp    8011bd <memcmp+0x3e>
		if (*s1 != *s2)
  801193:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801196:	8a 10                	mov    (%eax),%dl
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	38 c2                	cmp    %al,%dl
  80119f:	74 16                	je     8011b7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	0f b6 d0             	movzbl %al,%edx
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f b6 c0             	movzbl %al,%eax
  8011b1:	29 c2                	sub    %eax,%edx
  8011b3:	89 d0                	mov    %edx,%eax
  8011b5:	eb 18                	jmp    8011cf <memcmp+0x50>
		s1++, s2++;
  8011b7:	ff 45 fc             	incl   -0x4(%ebp)
  8011ba:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 c9                	jne    801193 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 d0                	add    %edx,%eax
  8011df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011e2:	eb 15                	jmp    8011f9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	0f b6 d0             	movzbl %al,%edx
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	0f b6 c0             	movzbl %al,%eax
  8011f2:	39 c2                	cmp    %eax,%edx
  8011f4:	74 0d                	je     801203 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011f6:	ff 45 08             	incl   0x8(%ebp)
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ff:	72 e3                	jb     8011e4 <memfind+0x13>
  801201:	eb 01                	jmp    801204 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801203:	90                   	nop
	return (void *) s;
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80120f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801216:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80121d:	eb 03                	jmp    801222 <strtol+0x19>
		s++;
  80121f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 20                	cmp    $0x20,%al
  801229:	74 f4                	je     80121f <strtol+0x16>
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	3c 09                	cmp    $0x9,%al
  801232:	74 eb                	je     80121f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	3c 2b                	cmp    $0x2b,%al
  80123b:	75 05                	jne    801242 <strtol+0x39>
		s++;
  80123d:	ff 45 08             	incl   0x8(%ebp)
  801240:	eb 13                	jmp    801255 <strtol+0x4c>
	else if (*s == '-')
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 2d                	cmp    $0x2d,%al
  801249:	75 0a                	jne    801255 <strtol+0x4c>
		s++, neg = 1;
  80124b:	ff 45 08             	incl   0x8(%ebp)
  80124e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801259:	74 06                	je     801261 <strtol+0x58>
  80125b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80125f:	75 20                	jne    801281 <strtol+0x78>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 30                	cmp    $0x30,%al
  801268:	75 17                	jne    801281 <strtol+0x78>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	40                   	inc    %eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 78                	cmp    $0x78,%al
  801272:	75 0d                	jne    801281 <strtol+0x78>
		s += 2, base = 16;
  801274:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801278:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80127f:	eb 28                	jmp    8012a9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801285:	75 15                	jne    80129c <strtol+0x93>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 30                	cmp    $0x30,%al
  80128e:	75 0c                	jne    80129c <strtol+0x93>
		s++, base = 8;
  801290:	ff 45 08             	incl   0x8(%ebp)
  801293:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80129a:	eb 0d                	jmp    8012a9 <strtol+0xa0>
	else if (base == 0)
  80129c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a0:	75 07                	jne    8012a9 <strtol+0xa0>
		base = 10;
  8012a2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 2f                	cmp    $0x2f,%al
  8012b0:	7e 19                	jle    8012cb <strtol+0xc2>
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	3c 39                	cmp    $0x39,%al
  8012b9:	7f 10                	jg     8012cb <strtol+0xc2>
			dig = *s - '0';
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	0f be c0             	movsbl %al,%eax
  8012c3:	83 e8 30             	sub    $0x30,%eax
  8012c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c9:	eb 42                	jmp    80130d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	3c 60                	cmp    $0x60,%al
  8012d2:	7e 19                	jle    8012ed <strtol+0xe4>
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	3c 7a                	cmp    $0x7a,%al
  8012db:	7f 10                	jg     8012ed <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	0f be c0             	movsbl %al,%eax
  8012e5:	83 e8 57             	sub    $0x57,%eax
  8012e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012eb:	eb 20                	jmp    80130d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	3c 40                	cmp    $0x40,%al
  8012f4:	7e 39                	jle    80132f <strtol+0x126>
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	3c 5a                	cmp    $0x5a,%al
  8012fd:	7f 30                	jg     80132f <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	0f be c0             	movsbl %al,%eax
  801307:	83 e8 37             	sub    $0x37,%eax
  80130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	3b 45 10             	cmp    0x10(%ebp),%eax
  801313:	7d 19                	jge    80132e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801315:	ff 45 08             	incl   0x8(%ebp)
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80131f:	89 c2                	mov    %eax,%edx
  801321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801324:	01 d0                	add    %edx,%eax
  801326:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801329:	e9 7b ff ff ff       	jmp    8012a9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80132e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80132f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801333:	74 08                	je     80133d <strtol+0x134>
		*endptr = (char *) s;
  801335:	8b 45 0c             	mov    0xc(%ebp),%eax
  801338:	8b 55 08             	mov    0x8(%ebp),%edx
  80133b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80133d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801341:	74 07                	je     80134a <strtol+0x141>
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	f7 d8                	neg    %eax
  801348:	eb 03                	jmp    80134d <strtol+0x144>
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <ltostr>:

void
ltostr(long value, char *str)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801355:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80135c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801367:	79 13                	jns    80137c <ltostr+0x2d>
	{
		neg = 1;
  801369:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801376:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801379:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801384:	99                   	cltd   
  801385:	f7 f9                	idiv   %ecx
  801387:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138d:	8d 50 01             	lea    0x1(%eax),%edx
  801390:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801393:	89 c2                	mov    %eax,%edx
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80139d:	83 c2 30             	add    $0x30,%edx
  8013a0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013aa:	f7 e9                	imul   %ecx
  8013ac:	c1 fa 02             	sar    $0x2,%edx
  8013af:	89 c8                	mov    %ecx,%eax
  8013b1:	c1 f8 1f             	sar    $0x1f,%eax
  8013b4:	29 c2                	sub    %eax,%edx
  8013b6:	89 d0                	mov    %edx,%eax
  8013b8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013be:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c3:	f7 e9                	imul   %ecx
  8013c5:	c1 fa 02             	sar    $0x2,%edx
  8013c8:	89 c8                	mov    %ecx,%eax
  8013ca:	c1 f8 1f             	sar    $0x1f,%eax
  8013cd:	29 c2                	sub    %eax,%edx
  8013cf:	89 d0                	mov    %edx,%eax
  8013d1:	c1 e0 02             	shl    $0x2,%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	01 c0                	add    %eax,%eax
  8013d8:	29 c1                	sub    %eax,%ecx
  8013da:	89 ca                	mov    %ecx,%edx
  8013dc:	85 d2                	test   %edx,%edx
  8013de:	75 9c                	jne    80137c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ea:	48                   	dec    %eax
  8013eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f2:	74 3d                	je     801431 <ltostr+0xe2>
		start = 1 ;
  8013f4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013fb:	eb 34                	jmp    801431 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	01 d0                	add    %edx,%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80140a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 c2                	add    %eax,%edx
  801412:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	01 c8                	add    %ecx,%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80141e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 c2                	add    %eax,%edx
  801426:	8a 45 eb             	mov    -0x15(%ebp),%al
  801429:	88 02                	mov    %al,(%edx)
		start++ ;
  80142b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80142e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801434:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801437:	7c c4                	jl     8013fd <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801439:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801444:	90                   	nop
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 54 fa ff ff       	call   800ea9 <strlen>
  801455:	83 c4 04             	add    $0x4,%esp
  801458:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80145b:	ff 75 0c             	pushl  0xc(%ebp)
  80145e:	e8 46 fa ff ff       	call   800ea9 <strlen>
  801463:	83 c4 04             	add    $0x4,%esp
  801466:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801477:	eb 17                	jmp    801490 <strcconcat+0x49>
		final[s] = str1[s] ;
  801479:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147c:	8b 45 10             	mov    0x10(%ebp),%eax
  80147f:	01 c2                	add    %eax,%edx
  801481:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	01 c8                	add    %ecx,%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80148d:	ff 45 fc             	incl   -0x4(%ebp)
  801490:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801493:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801496:	7c e1                	jl     801479 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801498:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80149f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a6:	eb 1f                	jmp    8014c7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ab:	8d 50 01             	lea    0x1(%eax),%edx
  8014ae:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b1:	89 c2                	mov    %eax,%edx
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	01 c2                	add    %eax,%edx
  8014b8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014be:	01 c8                	add    %ecx,%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c4:	ff 45 f8             	incl   -0x8(%ebp)
  8014c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014cd:	7c d9                	jl     8014a8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	01 d0                	add    %edx,%eax
  8014d7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014da:	90                   	nop
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ec:	8b 00                	mov    (%eax),%eax
  8014ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f8:	01 d0                	add    %edx,%eax
  8014fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801500:	eb 0c                	jmp    80150e <strsplit+0x31>
			*string++ = 0;
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8d 50 01             	lea    0x1(%eax),%edx
  801508:	89 55 08             	mov    %edx,0x8(%ebp)
  80150b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	8a 00                	mov    (%eax),%al
  801513:	84 c0                	test   %al,%al
  801515:	74 18                	je     80152f <strsplit+0x52>
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	0f be c0             	movsbl %al,%eax
  80151f:	50                   	push   %eax
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	e8 13 fb ff ff       	call   80103b <strchr>
  801528:	83 c4 08             	add    $0x8,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	75 d3                	jne    801502 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	84 c0                	test   %al,%al
  801536:	74 5a                	je     801592 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	83 f8 0f             	cmp    $0xf,%eax
  801540:	75 07                	jne    801549 <strsplit+0x6c>
		{
			return 0;
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
  801547:	eb 66                	jmp    8015af <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801549:	8b 45 14             	mov    0x14(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 14             	mov    0x14(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	01 c2                	add    %eax,%edx
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801567:	eb 03                	jmp    80156c <strsplit+0x8f>
			string++;
  801569:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8a 00                	mov    (%eax),%al
  801571:	84 c0                	test   %al,%al
  801573:	74 8b                	je     801500 <strsplit+0x23>
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	0f be c0             	movsbl %al,%eax
  80157d:	50                   	push   %eax
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	e8 b5 fa ff ff       	call   80103b <strchr>
  801586:	83 c4 08             	add    $0x8,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	74 dc                	je     801569 <strsplit+0x8c>
			string++;
	}
  80158d:	e9 6e ff ff ff       	jmp    801500 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801592:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801593:	8b 45 14             	mov    0x14(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	01 d0                	add    %edx,%eax
  8015a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015aa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  8015b7:	a1 28 30 80 00       	mov    0x803028,%eax
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	75 33                	jne    8015f3 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  8015c0:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  8015c7:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  8015ca:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  8015d1:	00 00 a0 
		spaces[0].pages = numPages;
  8015d4:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  8015db:	00 02 00 
		spaces[0].isFree = 1;
  8015de:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  8015e5:	00 00 00 
		arraySize++;
  8015e8:	a1 28 30 80 00       	mov    0x803028,%eax
  8015ed:	40                   	inc    %eax
  8015ee:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  8015f3:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  8015fa:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801601:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801608:	8b 55 08             	mov    0x8(%ebp),%edx
  80160b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80160e:	01 d0                	add    %edx,%eax
  801610:	48                   	dec    %eax
  801611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801617:	ba 00 00 00 00       	mov    $0x0,%edx
  80161c:	f7 75 e8             	divl   -0x18(%ebp)
  80161f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801622:	29 d0                	sub    %edx,%eax
  801624:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	c1 e8 0c             	shr    $0xc,%eax
  80162d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801630:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801637:	eb 57                	jmp    801690 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163c:	c1 e0 04             	shl    $0x4,%eax
  80163f:	05 2c 31 80 00       	add    $0x80312c,%eax
  801644:	8b 00                	mov    (%eax),%eax
  801646:	85 c0                	test   %eax,%eax
  801648:	74 42                	je     80168c <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  80164a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164d:	c1 e0 04             	shl    $0x4,%eax
  801650:	05 28 31 80 00       	add    $0x803128,%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80165a:	7c 31                	jl     80168d <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  80165c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165f:	c1 e0 04             	shl    $0x4,%eax
  801662:	05 28 31 80 00       	add    $0x803128,%eax
  801667:	8b 00                	mov    (%eax),%eax
  801669:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80166c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80166f:	7d 1c                	jge    80168d <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801674:	c1 e0 04             	shl    $0x4,%eax
  801677:	05 28 31 80 00       	add    $0x803128,%eax
  80167c:	8b 00                	mov    (%eax),%eax
  80167e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801687:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168a:	eb 01                	jmp    80168d <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80168c:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  80168d:	ff 45 ec             	incl   -0x14(%ebp)
  801690:	a1 28 30 80 00       	mov    0x803028,%eax
  801695:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801698:	7c 9f                	jl     801639 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  80169a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80169e:	75 0a                	jne    8016aa <malloc+0xf9>
	{
		return NULL;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	e9 34 01 00 00       	jmp    8017de <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	c1 e0 04             	shl    $0x4,%eax
  8016b0:	05 28 31 80 00       	add    $0x803128,%eax
  8016b5:	8b 00                	mov    (%eax),%eax
  8016b7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8016ba:	75 38                	jne    8016f4 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  8016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bf:	c1 e0 04             	shl    $0x4,%eax
  8016c2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  8016cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d0:	c1 e0 0c             	shl    $0xc,%eax
  8016d3:	89 c2                	mov    %eax,%edx
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	c1 e0 04             	shl    $0x4,%eax
  8016db:	05 20 31 80 00       	add    $0x803120,%eax
  8016e0:	8b 00                	mov    (%eax),%eax
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	e8 01 06 00 00       	call   801ced <sys_allocateMem>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	e9 dd 00 00 00       	jmp    8017d1 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f7:	c1 e0 04             	shl    $0x4,%eax
  8016fa:	05 20 31 80 00       	add    $0x803120,%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801704:	c1 e2 0c             	shl    $0xc,%edx
  801707:	01 d0                	add    %edx,%eax
  801709:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  80170c:	a1 28 30 80 00       	mov    0x803028,%eax
  801711:	c1 e0 04             	shl    $0x4,%eax
  801714:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  80171a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80171d:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80171f:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801728:	c1 e0 04             	shl    $0x4,%eax
  80172b:	05 24 31 80 00       	add    $0x803124,%eax
  801730:	8b 00                	mov    (%eax),%eax
  801732:	c1 e2 04             	shl    $0x4,%edx
  801735:	81 c2 24 31 80 00    	add    $0x803124,%edx
  80173b:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80173d:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801746:	c1 e0 04             	shl    $0x4,%eax
  801749:	05 28 31 80 00       	add    $0x803128,%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801753:	c1 e2 04             	shl    $0x4,%edx
  801756:	81 c2 28 31 80 00    	add    $0x803128,%edx
  80175c:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  80175e:	a1 28 30 80 00       	mov    0x803028,%eax
  801763:	c1 e0 04             	shl    $0x4,%eax
  801766:	05 2c 31 80 00       	add    $0x80312c,%eax
  80176b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801771:	a1 28 30 80 00       	mov    0x803028,%eax
  801776:	40                   	inc    %eax
  801777:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	c1 e0 04             	shl    $0x4,%eax
  801782:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  801788:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80178b:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801790:	c1 e0 04             	shl    $0x4,%eax
  801793:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  801799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179c:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  80179e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a1:	c1 e0 04             	shl    $0x4,%eax
  8017a4:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  8017af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b2:	c1 e0 0c             	shl    $0xc,%eax
  8017b5:	89 c2                	mov    %eax,%edx
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	c1 e0 04             	shl    $0x4,%eax
  8017bd:	05 20 31 80 00       	add    $0x803120,%eax
  8017c2:	8b 00                	mov    (%eax),%eax
  8017c4:	83 ec 08             	sub    $0x8,%esp
  8017c7:	52                   	push   %edx
  8017c8:	50                   	push   %eax
  8017c9:	e8 1f 05 00 00       	call   801ced <sys_allocateMem>
  8017ce:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	c1 e0 04             	shl    $0x4,%eax
  8017d7:	05 20 31 80 00       	add    $0x803120,%eax
  8017dc:	8b 00                	mov    (%eax),%eax
	}


}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  8017e6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  8017ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  8017f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017fb:	eb 3f                	jmp    80183c <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  8017fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801800:	c1 e0 04             	shl    $0x4,%eax
  801803:	05 20 31 80 00       	add    $0x803120,%eax
  801808:	8b 00                	mov    (%eax),%eax
  80180a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80180d:	75 2a                	jne    801839 <free+0x59>
		{
			index=i;
  80180f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801812:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801818:	c1 e0 04             	shl    $0x4,%eax
  80181b:	05 28 31 80 00       	add    $0x803128,%eax
  801820:	8b 00                	mov    (%eax),%eax
  801822:	c1 e0 0c             	shl    $0xc,%eax
  801825:	89 c2                	mov    %eax,%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	52                   	push   %edx
  80182e:	50                   	push   %eax
  80182f:	e8 9d 04 00 00       	call   801cd1 <sys_freeMem>
  801834:	83 c4 10             	add    $0x10,%esp
			break;
  801837:	eb 0d                	jmp    801846 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801839:	ff 45 ec             	incl   -0x14(%ebp)
  80183c:	a1 28 30 80 00       	mov    0x803028,%eax
  801841:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801844:	7c b7                	jl     8017fd <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801846:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80184a:	75 17                	jne    801863 <free+0x83>
	{
		panic("Error");
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	68 10 2a 80 00       	push   $0x802a10
  801854:	68 81 00 00 00       	push   $0x81
  801859:	68 16 2a 80 00       	push   $0x802a16
  80185e:	e8 14 09 00 00       	call   802177 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80186a:	e9 cc 00 00 00       	jmp    80193b <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80186f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801872:	c1 e0 04             	shl    $0x4,%eax
  801875:	05 2c 31 80 00       	add    $0x80312c,%eax
  80187a:	8b 00                	mov    (%eax),%eax
  80187c:	85 c0                	test   %eax,%eax
  80187e:	0f 84 b3 00 00 00    	je     801937 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	c1 e0 04             	shl    $0x4,%eax
  80188a:	05 20 31 80 00       	add    $0x803120,%eax
  80188f:	8b 10                	mov    (%eax),%edx
  801891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801894:	c1 e0 04             	shl    $0x4,%eax
  801897:	05 24 31 80 00       	add    $0x803124,%eax
  80189c:	8b 00                	mov    (%eax),%eax
  80189e:	39 c2                	cmp    %eax,%edx
  8018a0:	0f 85 92 00 00 00    	jne    801938 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  8018a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a9:	c1 e0 04             	shl    $0x4,%eax
  8018ac:	05 24 31 80 00       	add    $0x803124,%eax
  8018b1:	8b 00                	mov    (%eax),%eax
  8018b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018b6:	c1 e2 04             	shl    $0x4,%edx
  8018b9:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8018bf:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8018c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c4:	c1 e0 04             	shl    $0x4,%eax
  8018c7:	05 28 31 80 00       	add    $0x803128,%eax
  8018cc:	8b 10                	mov    (%eax),%edx
  8018ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d1:	c1 e0 04             	shl    $0x4,%eax
  8018d4:	05 28 31 80 00       	add    $0x803128,%eax
  8018d9:	8b 00                	mov    (%eax),%eax
  8018db:	01 c2                	add    %eax,%edx
  8018dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e0:	c1 e0 04             	shl    $0x4,%eax
  8018e3:	05 28 31 80 00       	add    $0x803128,%eax
  8018e8:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8018ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ed:	c1 e0 04             	shl    $0x4,%eax
  8018f0:	05 20 31 80 00       	add    $0x803120,%eax
  8018f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	c1 e0 04             	shl    $0x4,%eax
  801901:	05 24 31 80 00       	add    $0x803124,%eax
  801906:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  80190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190f:	c1 e0 04             	shl    $0x4,%eax
  801912:	05 28 31 80 00       	add    $0x803128,%eax
  801917:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801920:	c1 e0 04             	shl    $0x4,%eax
  801923:	05 2c 31 80 00       	add    $0x80312c,%eax
  801928:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80192e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801935:	eb 12                	jmp    801949 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801937:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801938:	ff 45 e8             	incl   -0x18(%ebp)
  80193b:	a1 28 30 80 00       	mov    0x803028,%eax
  801940:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801943:	0f 8c 26 ff ff ff    	jl     80186f <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801949:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801950:	e9 cc 00 00 00       	jmp    801a21 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801958:	c1 e0 04             	shl    $0x4,%eax
  80195b:	05 2c 31 80 00       	add    $0x80312c,%eax
  801960:	8b 00                	mov    (%eax),%eax
  801962:	85 c0                	test   %eax,%eax
  801964:	0f 84 b3 00 00 00    	je     801a1d <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	c1 e0 04             	shl    $0x4,%eax
  801970:	05 24 31 80 00       	add    $0x803124,%eax
  801975:	8b 10                	mov    (%eax),%edx
  801977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80197a:	c1 e0 04             	shl    $0x4,%eax
  80197d:	05 20 31 80 00       	add    $0x803120,%eax
  801982:	8b 00                	mov    (%eax),%eax
  801984:	39 c2                	cmp    %eax,%edx
  801986:	0f 85 92 00 00 00    	jne    801a1e <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  80198c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198f:	c1 e0 04             	shl    $0x4,%eax
  801992:	05 20 31 80 00       	add    $0x803120,%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80199c:	c1 e2 04             	shl    $0x4,%edx
  80199f:	81 c2 20 31 80 00    	add    $0x803120,%edx
  8019a5:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8019a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019aa:	c1 e0 04             	shl    $0x4,%eax
  8019ad:	05 28 31 80 00       	add    $0x803128,%eax
  8019b2:	8b 10                	mov    (%eax),%edx
  8019b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b7:	c1 e0 04             	shl    $0x4,%eax
  8019ba:	05 28 31 80 00       	add    $0x803128,%eax
  8019bf:	8b 00                	mov    (%eax),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019c6:	c1 e0 04             	shl    $0x4,%eax
  8019c9:	05 28 31 80 00       	add    $0x803128,%eax
  8019ce:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	c1 e0 04             	shl    $0x4,%eax
  8019d6:	05 20 31 80 00       	add    $0x803120,%eax
  8019db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e4:	c1 e0 04             	shl    $0x4,%eax
  8019e7:	05 24 31 80 00       	add    $0x803124,%eax
  8019ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	c1 e0 04             	shl    $0x4,%eax
  8019f8:	05 28 31 80 00       	add    $0x803128,%eax
  8019fd:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a06:	c1 e0 04             	shl    $0x4,%eax
  801a09:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801a14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801a1b:	eb 12                	jmp    801a2f <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801a1d:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801a1e:	ff 45 e4             	incl   -0x1c(%ebp)
  801a21:	a1 28 30 80 00       	mov    0x803028,%eax
  801a26:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a29:	0f 8c 26 ff ff ff    	jl     801955 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801a2f:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801a33:	75 11                	jne    801a46 <free+0x266>
	{
		spaces[index].isFree = 1;
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	c1 e0 04             	shl    $0x4,%eax
  801a3b:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801a46:	90                   	nop
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 18             	sub    $0x18,%esp
  801a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a52:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	68 24 2a 80 00       	push   $0x802a24
  801a5d:	68 b9 00 00 00       	push   $0xb9
  801a62:	68 16 2a 80 00       	push   $0x802a16
  801a67:	e8 0b 07 00 00       	call   802177 <_panic>

00801a6c <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	68 24 2a 80 00       	push   $0x802a24
  801a7a:	68 bf 00 00 00       	push   $0xbf
  801a7f:	68 16 2a 80 00       	push   $0x802a16
  801a84:	e8 ee 06 00 00       	call   802177 <_panic>

00801a89 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	68 24 2a 80 00       	push   $0x802a24
  801a97:	68 c5 00 00 00       	push   $0xc5
  801a9c:	68 16 2a 80 00       	push   $0x802a16
  801aa1:	e8 d1 06 00 00       	call   802177 <_panic>

00801aa6 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	68 24 2a 80 00       	push   $0x802a24
  801ab4:	68 ca 00 00 00       	push   $0xca
  801ab9:	68 16 2a 80 00       	push   $0x802a16
  801abe:	e8 b4 06 00 00       	call   802177 <_panic>

00801ac3 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	68 24 2a 80 00       	push   $0x802a24
  801ad1:	68 d0 00 00 00       	push   $0xd0
  801ad6:	68 16 2a 80 00       	push   $0x802a16
  801adb:	e8 97 06 00 00       	call   802177 <_panic>

00801ae0 <shrink>:
}
void shrink(uint32 newSize)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	68 24 2a 80 00       	push   $0x802a24
  801aee:	68 d4 00 00 00       	push   $0xd4
  801af3:	68 16 2a 80 00       	push   $0x802a16
  801af8:	e8 7a 06 00 00       	call   802177 <_panic>

00801afd <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	68 24 2a 80 00       	push   $0x802a24
  801b0b:	68 d9 00 00 00       	push   $0xd9
  801b10:	68 16 2a 80 00       	push   $0x802a16
  801b15:	e8 5d 06 00 00       	call   802177 <_panic>

00801b1a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	57                   	push   %edi
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b32:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b35:	cd 30                	int    $0x30
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	5b                   	pop    %ebx
  801b41:	5e                   	pop    %esi
  801b42:	5f                   	pop    %edi
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    

00801b45 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b51:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	52                   	push   %edx
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	50                   	push   %eax
  801b61:	6a 00                	push   $0x0
  801b63:	e8 b2 ff ff ff       	call   801b1a <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 01                	push   $0x1
  801b7d:	e8 98 ff ff ff       	call   801b1a <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	50                   	push   %eax
  801b96:	6a 05                	push   $0x5
  801b98:	e8 7d ff ff ff       	call   801b1a <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 02                	push   $0x2
  801bb1:	e8 64 ff ff ff       	call   801b1a <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 03                	push   $0x3
  801bca:	e8 4b ff ff ff       	call   801b1a <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 04                	push   $0x4
  801be3:	e8 32 ff ff ff       	call   801b1a <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_env_exit>:


void sys_env_exit(void)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 06                	push   $0x6
  801bfc:	e8 19 ff ff ff       	call   801b1a <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	52                   	push   %edx
  801c17:	50                   	push   %eax
  801c18:	6a 07                	push   $0x7
  801c1a:	e8 fb fe ff ff       	call   801b1a <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	56                   	push   %esi
  801c28:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c29:	8b 75 18             	mov    0x18(%ebp),%esi
  801c2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	51                   	push   %ecx
  801c3b:	52                   	push   %edx
  801c3c:	50                   	push   %eax
  801c3d:	6a 08                	push   $0x8
  801c3f:	e8 d6 fe ff ff       	call   801b1a <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    

00801c4e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 09                	push   $0x9
  801c61:	e8 b4 fe ff ff       	call   801b1a <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	6a 0a                	push   $0xa
  801c7c:	e8 99 fe ff ff       	call   801b1a <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 0b                	push   $0xb
  801c95:	e8 80 fe ff ff       	call   801b1a <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 0c                	push   $0xc
  801cae:	e8 67 fe ff ff       	call   801b1a <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 0d                	push   $0xd
  801cc7:	e8 4e fe ff ff       	call   801b1a <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	6a 11                	push   $0x11
  801ce2:	e8 33 fe ff ff       	call   801b1a <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	6a 12                	push   $0x12
  801cfe:	e8 17 fe ff ff       	call   801b1a <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 0e                	push   $0xe
  801d18:	e8 fd fd ff ff       	call   801b1a <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	ff 75 08             	pushl  0x8(%ebp)
  801d30:	6a 0f                	push   $0xf
  801d32:	e8 e3 fd ff ff       	call   801b1a <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 10                	push   $0x10
  801d4b:	e8 ca fd ff ff       	call   801b1a <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	90                   	nop
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 14                	push   $0x14
  801d65:	e8 b0 fd ff ff       	call   801b1a <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	90                   	nop
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 15                	push   $0x15
  801d7f:	e8 96 fd ff ff       	call   801b1a <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	90                   	nop
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_cputc>:


void
sys_cputc(const char c)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d96:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	50                   	push   %eax
  801da3:	6a 16                	push   $0x16
  801da5:	e8 70 fd ff ff       	call   801b1a <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	90                   	nop
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 17                	push   $0x17
  801dbf:	e8 56 fd ff ff       	call   801b1a <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	90                   	nop
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	50                   	push   %eax
  801dda:	6a 18                	push   $0x18
  801ddc:	e8 39 fd ff ff       	call   801b1a <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	6a 1b                	push   $0x1b
  801df9:	e8 1c fd ff ff       	call   801b1a <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	52                   	push   %edx
  801e13:	50                   	push   %eax
  801e14:	6a 19                	push   $0x19
  801e16:	e8 ff fc ff ff       	call   801b1a <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	90                   	nop
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	52                   	push   %edx
  801e31:	50                   	push   %eax
  801e32:	6a 1a                	push   $0x1a
  801e34:	e8 e1 fc ff ff       	call   801b1a <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	90                   	nop
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	8b 45 10             	mov    0x10(%ebp),%eax
  801e48:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e4b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	6a 00                	push   $0x0
  801e57:	51                   	push   %ecx
  801e58:	52                   	push   %edx
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	50                   	push   %eax
  801e5d:	6a 1c                	push   $0x1c
  801e5f:	e8 b6 fc ff ff       	call   801b1a <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	52                   	push   %edx
  801e79:	50                   	push   %eax
  801e7a:	6a 1d                	push   $0x1d
  801e7c:	e8 99 fc ff ff       	call   801b1a <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	51                   	push   %ecx
  801e97:	52                   	push   %edx
  801e98:	50                   	push   %eax
  801e99:	6a 1e                	push   $0x1e
  801e9b:	e8 7a fc ff ff       	call   801b1a <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	6a 1f                	push   $0x1f
  801eb8:	e8 5d fc ff ff       	call   801b1a <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 20                	push   $0x20
  801ed1:	e8 44 fc ff ff       	call   801b1a <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 14             	pushl  0x14(%ebp)
  801ee6:	ff 75 10             	pushl  0x10(%ebp)
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	50                   	push   %eax
  801eed:	6a 21                	push   $0x21
  801eef:	e8 26 fc ff ff       	call   801b1a <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	50                   	push   %eax
  801f08:	6a 22                	push   $0x22
  801f0a:	e8 0b fc ff ff       	call   801b1a <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	50                   	push   %eax
  801f24:	6a 23                	push   $0x23
  801f26:	e8 ef fb ff ff       	call   801b1a <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3a:	8d 50 04             	lea    0x4(%eax),%edx
  801f3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	52                   	push   %edx
  801f47:	50                   	push   %eax
  801f48:	6a 24                	push   $0x24
  801f4a:	e8 cb fb ff ff       	call   801b1a <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
	return result;
  801f52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f5b:	89 01                	mov    %eax,(%ecx)
  801f5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	c9                   	leave  
  801f64:	c2 04 00             	ret    $0x4

00801f67 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	ff 75 10             	pushl  0x10(%ebp)
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	ff 75 08             	pushl  0x8(%ebp)
  801f77:	6a 13                	push   $0x13
  801f79:	e8 9c fb ff ff       	call   801b1a <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f81:	90                   	nop
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 25                	push   $0x25
  801f93:	e8 82 fb ff ff       	call   801b1a <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 04             	sub    $0x4,%esp
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fa9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	50                   	push   %eax
  801fb6:	6a 26                	push   $0x26
  801fb8:	e8 5d fb ff ff       	call   801b1a <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc0:	90                   	nop
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <rsttst>:
void rsttst()
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 28                	push   $0x28
  801fd2:	e8 43 fb ff ff       	call   801b1a <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fda:	90                   	nop
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fe9:	8b 55 18             	mov    0x18(%ebp),%edx
  801fec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	ff 75 10             	pushl  0x10(%ebp)
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	6a 27                	push   $0x27
  801ffd:	e8 18 fb ff ff       	call   801b1a <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
	return ;
  802005:	90                   	nop
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <chktst>:
void chktst(uint32 n)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	6a 29                	push   $0x29
  802018:	e8 fd fa ff ff       	call   801b1a <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
	return ;
  802020:	90                   	nop
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <inctst>:

void inctst()
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 2a                	push   $0x2a
  802032:	e8 e3 fa ff ff       	call   801b1a <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
	return ;
  80203a:	90                   	nop
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <gettst>:
uint32 gettst()
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 2b                	push   $0x2b
  80204c:	e8 c9 fa ff ff       	call   801b1a <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 2c                	push   $0x2c
  802068:	e8 ad fa ff ff       	call   801b1a <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
  802070:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802073:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802077:	75 07                	jne    802080 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802079:	b8 01 00 00 00       	mov    $0x1,%eax
  80207e:	eb 05                	jmp    802085 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 2c                	push   $0x2c
  802099:	e8 7c fa ff ff       	call   801b1a <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
  8020a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020a4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020a8:	75 07                	jne    8020b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8020af:	eb 05                	jmp    8020b6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 2c                	push   $0x2c
  8020ca:	e8 4b fa ff ff       	call   801b1a <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
  8020d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020d5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020d9:	75 07                	jne    8020e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020db:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e0:	eb 05                	jmp    8020e7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 2c                	push   $0x2c
  8020fb:	e8 1a fa ff ff       	call   801b1a <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
  802103:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802106:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80210a:	75 07                	jne    802113 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80210c:	b8 01 00 00 00       	mov    $0x1,%eax
  802111:	eb 05                	jmp    802118 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	6a 2d                	push   $0x2d
  80212a:	e8 eb f9 ff ff       	call   801b1a <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
	return ;
  802132:	90                   	nop
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802139:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	53                   	push   %ebx
  802148:	51                   	push   %ecx
  802149:	52                   	push   %edx
  80214a:	50                   	push   %eax
  80214b:	6a 2e                	push   $0x2e
  80214d:	e8 c8 f9 ff ff       	call   801b1a <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	52                   	push   %edx
  80216a:	50                   	push   %eax
  80216b:	6a 2f                	push   $0x2f
  80216d:	e8 a8 f9 ff ff       	call   801b1a <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80217d:	8d 45 10             	lea    0x10(%ebp),%eax
  802180:	83 c0 04             	add    $0x4,%eax
  802183:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802186:	a1 20 31 a0 00       	mov    0xa03120,%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 16                	je     8021a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80218f:	a1 20 31 a0 00       	mov    0xa03120,%eax
  802194:	83 ec 08             	sub    $0x8,%esp
  802197:	50                   	push   %eax
  802198:	68 48 2a 80 00       	push   $0x802a48
  80219d:	e8 85 e6 ff ff       	call   800827 <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8021a5:	a1 00 30 80 00       	mov    0x803000,%eax
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	ff 75 08             	pushl  0x8(%ebp)
  8021b0:	50                   	push   %eax
  8021b1:	68 4d 2a 80 00       	push   $0x802a4d
  8021b6:	e8 6c e6 ff ff       	call   800827 <cprintf>
  8021bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8021be:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c1:	83 ec 08             	sub    $0x8,%esp
  8021c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c7:	50                   	push   %eax
  8021c8:	e8 ef e5 ff ff       	call   8007bc <vcprintf>
  8021cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8021d0:	83 ec 08             	sub    $0x8,%esp
  8021d3:	6a 00                	push   $0x0
  8021d5:	68 69 2a 80 00       	push   $0x802a69
  8021da:	e8 dd e5 ff ff       	call   8007bc <vcprintf>
  8021df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8021e2:	e8 5e e5 ff ff       	call   800745 <exit>

	// should not return here
	while (1) ;
  8021e7:	eb fe                	jmp    8021e7 <_panic+0x70>

008021e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8021ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8021f4:	8b 50 74             	mov    0x74(%eax),%edx
  8021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fa:	39 c2                	cmp    %eax,%edx
  8021fc:	74 14                	je     802212 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	68 6c 2a 80 00       	push   $0x802a6c
  802206:	6a 26                	push   $0x26
  802208:	68 b8 2a 80 00       	push   $0x802ab8
  80220d:	e8 65 ff ff ff       	call   802177 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802212:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802219:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802220:	e9 b6 00 00 00       	jmp    8022db <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  802225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802228:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	01 d0                	add    %edx,%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	75 08                	jne    802242 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80223a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80223d:	e9 96 00 00 00       	jmp    8022d8 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  802242:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802249:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802250:	eb 5d                	jmp    8022af <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802252:	a1 20 30 80 00       	mov    0x803020,%eax
  802257:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80225d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802260:	c1 e2 04             	shl    $0x4,%edx
  802263:	01 d0                	add    %edx,%eax
  802265:	8a 40 04             	mov    0x4(%eax),%al
  802268:	84 c0                	test   %al,%al
  80226a:	75 40                	jne    8022ac <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80226c:	a1 20 30 80 00       	mov    0x803020,%eax
  802271:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802277:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80227a:	c1 e2 04             	shl    $0x4,%edx
  80227d:	01 d0                	add    %edx,%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802287:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80228c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	01 c8                	add    %ecx,%eax
  80229d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80229f:	39 c2                	cmp    %eax,%edx
  8022a1:	75 09                	jne    8022ac <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  8022a3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8022aa:	eb 12                	jmp    8022be <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022ac:	ff 45 e8             	incl   -0x18(%ebp)
  8022af:	a1 20 30 80 00       	mov    0x803020,%eax
  8022b4:	8b 50 74             	mov    0x74(%eax),%edx
  8022b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ba:	39 c2                	cmp    %eax,%edx
  8022bc:	77 94                	ja     802252 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8022be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c2:	75 14                	jne    8022d8 <CheckWSWithoutLastIndex+0xef>
			panic(
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 c4 2a 80 00       	push   $0x802ac4
  8022cc:	6a 3a                	push   $0x3a
  8022ce:	68 b8 2a 80 00       	push   $0x802ab8
  8022d3:	e8 9f fe ff ff       	call   802177 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8022d8:	ff 45 f0             	incl   -0x10(%ebp)
  8022db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022e1:	0f 8c 3e ff ff ff    	jl     802225 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8022e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8022ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022f5:	eb 20                	jmp    802317 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8022f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8022fc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802302:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802305:	c1 e2 04             	shl    $0x4,%edx
  802308:	01 d0                	add    %edx,%eax
  80230a:	8a 40 04             	mov    0x4(%eax),%al
  80230d:	3c 01                	cmp    $0x1,%al
  80230f:	75 03                	jne    802314 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802311:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802314:	ff 45 e0             	incl   -0x20(%ebp)
  802317:	a1 20 30 80 00       	mov    0x803020,%eax
  80231c:	8b 50 74             	mov    0x74(%eax),%edx
  80231f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802322:	39 c2                	cmp    %eax,%edx
  802324:	77 d1                	ja     8022f7 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80232c:	74 14                	je     802342 <CheckWSWithoutLastIndex+0x159>
		panic(
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 18 2b 80 00       	push   $0x802b18
  802336:	6a 44                	push   $0x44
  802338:	68 b8 2a 80 00       	push   $0x802ab8
  80233d:	e8 35 fe ff ff       	call   802177 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802342:	90                   	nop
  802343:	c9                   	leave  
  802344:	c3                   	ret    
  802345:	66 90                	xchg   %ax,%ax
  802347:	90                   	nop

00802348 <__udivdi3>:
  802348:	55                   	push   %ebp
  802349:	57                   	push   %edi
  80234a:	56                   	push   %esi
  80234b:	53                   	push   %ebx
  80234c:	83 ec 1c             	sub    $0x1c,%esp
  80234f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802353:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80235b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80235f:	89 ca                	mov    %ecx,%edx
  802361:	89 f8                	mov    %edi,%eax
  802363:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802367:	85 f6                	test   %esi,%esi
  802369:	75 2d                	jne    802398 <__udivdi3+0x50>
  80236b:	39 cf                	cmp    %ecx,%edi
  80236d:	77 65                	ja     8023d4 <__udivdi3+0x8c>
  80236f:	89 fd                	mov    %edi,%ebp
  802371:	85 ff                	test   %edi,%edi
  802373:	75 0b                	jne    802380 <__udivdi3+0x38>
  802375:	b8 01 00 00 00       	mov    $0x1,%eax
  80237a:	31 d2                	xor    %edx,%edx
  80237c:	f7 f7                	div    %edi
  80237e:	89 c5                	mov    %eax,%ebp
  802380:	31 d2                	xor    %edx,%edx
  802382:	89 c8                	mov    %ecx,%eax
  802384:	f7 f5                	div    %ebp
  802386:	89 c1                	mov    %eax,%ecx
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	f7 f5                	div    %ebp
  80238c:	89 cf                	mov    %ecx,%edi
  80238e:	89 fa                	mov    %edi,%edx
  802390:	83 c4 1c             	add    $0x1c,%esp
  802393:	5b                   	pop    %ebx
  802394:	5e                   	pop    %esi
  802395:	5f                   	pop    %edi
  802396:	5d                   	pop    %ebp
  802397:	c3                   	ret    
  802398:	39 ce                	cmp    %ecx,%esi
  80239a:	77 28                	ja     8023c4 <__udivdi3+0x7c>
  80239c:	0f bd fe             	bsr    %esi,%edi
  80239f:	83 f7 1f             	xor    $0x1f,%edi
  8023a2:	75 40                	jne    8023e4 <__udivdi3+0x9c>
  8023a4:	39 ce                	cmp    %ecx,%esi
  8023a6:	72 0a                	jb     8023b2 <__udivdi3+0x6a>
  8023a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023ac:	0f 87 9e 00 00 00    	ja     802450 <__udivdi3+0x108>
  8023b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b7:	89 fa                	mov    %edi,%edx
  8023b9:	83 c4 1c             	add    $0x1c,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    
  8023c1:	8d 76 00             	lea    0x0(%esi),%esi
  8023c4:	31 ff                	xor    %edi,%edi
  8023c6:	31 c0                	xor    %eax,%eax
  8023c8:	89 fa                	mov    %edi,%edx
  8023ca:	83 c4 1c             	add    $0x1c,%esp
  8023cd:	5b                   	pop    %ebx
  8023ce:	5e                   	pop    %esi
  8023cf:	5f                   	pop    %edi
  8023d0:	5d                   	pop    %ebp
  8023d1:	c3                   	ret    
  8023d2:	66 90                	xchg   %ax,%ax
  8023d4:	89 d8                	mov    %ebx,%eax
  8023d6:	f7 f7                	div    %edi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	89 fa                	mov    %edi,%edx
  8023dc:	83 c4 1c             	add    $0x1c,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    
  8023e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023e9:	89 eb                	mov    %ebp,%ebx
  8023eb:	29 fb                	sub    %edi,%ebx
  8023ed:	89 f9                	mov    %edi,%ecx
  8023ef:	d3 e6                	shl    %cl,%esi
  8023f1:	89 c5                	mov    %eax,%ebp
  8023f3:	88 d9                	mov    %bl,%cl
  8023f5:	d3 ed                	shr    %cl,%ebp
  8023f7:	89 e9                	mov    %ebp,%ecx
  8023f9:	09 f1                	or     %esi,%ecx
  8023fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023ff:	89 f9                	mov    %edi,%ecx
  802401:	d3 e0                	shl    %cl,%eax
  802403:	89 c5                	mov    %eax,%ebp
  802405:	89 d6                	mov    %edx,%esi
  802407:	88 d9                	mov    %bl,%cl
  802409:	d3 ee                	shr    %cl,%esi
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e2                	shl    %cl,%edx
  80240f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802413:	88 d9                	mov    %bl,%cl
  802415:	d3 e8                	shr    %cl,%eax
  802417:	09 c2                	or     %eax,%edx
  802419:	89 d0                	mov    %edx,%eax
  80241b:	89 f2                	mov    %esi,%edx
  80241d:	f7 74 24 0c          	divl   0xc(%esp)
  802421:	89 d6                	mov    %edx,%esi
  802423:	89 c3                	mov    %eax,%ebx
  802425:	f7 e5                	mul    %ebp
  802427:	39 d6                	cmp    %edx,%esi
  802429:	72 19                	jb     802444 <__udivdi3+0xfc>
  80242b:	74 0b                	je     802438 <__udivdi3+0xf0>
  80242d:	89 d8                	mov    %ebx,%eax
  80242f:	31 ff                	xor    %edi,%edi
  802431:	e9 58 ff ff ff       	jmp    80238e <__udivdi3+0x46>
  802436:	66 90                	xchg   %ax,%ax
  802438:	8b 54 24 08          	mov    0x8(%esp),%edx
  80243c:	89 f9                	mov    %edi,%ecx
  80243e:	d3 e2                	shl    %cl,%edx
  802440:	39 c2                	cmp    %eax,%edx
  802442:	73 e9                	jae    80242d <__udivdi3+0xe5>
  802444:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802447:	31 ff                	xor    %edi,%edi
  802449:	e9 40 ff ff ff       	jmp    80238e <__udivdi3+0x46>
  80244e:	66 90                	xchg   %ax,%ax
  802450:	31 c0                	xor    %eax,%eax
  802452:	e9 37 ff ff ff       	jmp    80238e <__udivdi3+0x46>
  802457:	90                   	nop

00802458 <__umoddi3>:
  802458:	55                   	push   %ebp
  802459:	57                   	push   %edi
  80245a:	56                   	push   %esi
  80245b:	53                   	push   %ebx
  80245c:	83 ec 1c             	sub    $0x1c,%esp
  80245f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802463:	8b 74 24 34          	mov    0x34(%esp),%esi
  802467:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80246b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80246f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802473:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802477:	89 f3                	mov    %esi,%ebx
  802479:	89 fa                	mov    %edi,%edx
  80247b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80247f:	89 34 24             	mov    %esi,(%esp)
  802482:	85 c0                	test   %eax,%eax
  802484:	75 1a                	jne    8024a0 <__umoddi3+0x48>
  802486:	39 f7                	cmp    %esi,%edi
  802488:	0f 86 a2 00 00 00    	jbe    802530 <__umoddi3+0xd8>
  80248e:	89 c8                	mov    %ecx,%eax
  802490:	89 f2                	mov    %esi,%edx
  802492:	f7 f7                	div    %edi
  802494:	89 d0                	mov    %edx,%eax
  802496:	31 d2                	xor    %edx,%edx
  802498:	83 c4 1c             	add    $0x1c,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    
  8024a0:	39 f0                	cmp    %esi,%eax
  8024a2:	0f 87 ac 00 00 00    	ja     802554 <__umoddi3+0xfc>
  8024a8:	0f bd e8             	bsr    %eax,%ebp
  8024ab:	83 f5 1f             	xor    $0x1f,%ebp
  8024ae:	0f 84 ac 00 00 00    	je     802560 <__umoddi3+0x108>
  8024b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8024b9:	29 ef                	sub    %ebp,%edi
  8024bb:	89 fe                	mov    %edi,%esi
  8024bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e0                	shl    %cl,%eax
  8024c5:	89 d7                	mov    %edx,%edi
  8024c7:	89 f1                	mov    %esi,%ecx
  8024c9:	d3 ef                	shr    %cl,%edi
  8024cb:	09 c7                	or     %eax,%edi
  8024cd:	89 e9                	mov    %ebp,%ecx
  8024cf:	d3 e2                	shl    %cl,%edx
  8024d1:	89 14 24             	mov    %edx,(%esp)
  8024d4:	89 d8                	mov    %ebx,%eax
  8024d6:	d3 e0                	shl    %cl,%eax
  8024d8:	89 c2                	mov    %eax,%edx
  8024da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024de:	d3 e0                	shl    %cl,%eax
  8024e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024e8:	89 f1                	mov    %esi,%ecx
  8024ea:	d3 e8                	shr    %cl,%eax
  8024ec:	09 d0                	or     %edx,%eax
  8024ee:	d3 eb                	shr    %cl,%ebx
  8024f0:	89 da                	mov    %ebx,%edx
  8024f2:	f7 f7                	div    %edi
  8024f4:	89 d3                	mov    %edx,%ebx
  8024f6:	f7 24 24             	mull   (%esp)
  8024f9:	89 c6                	mov    %eax,%esi
  8024fb:	89 d1                	mov    %edx,%ecx
  8024fd:	39 d3                	cmp    %edx,%ebx
  8024ff:	0f 82 87 00 00 00    	jb     80258c <__umoddi3+0x134>
  802505:	0f 84 91 00 00 00    	je     80259c <__umoddi3+0x144>
  80250b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80250f:	29 f2                	sub    %esi,%edx
  802511:	19 cb                	sbb    %ecx,%ebx
  802513:	89 d8                	mov    %ebx,%eax
  802515:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802519:	d3 e0                	shl    %cl,%eax
  80251b:	89 e9                	mov    %ebp,%ecx
  80251d:	d3 ea                	shr    %cl,%edx
  80251f:	09 d0                	or     %edx,%eax
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 eb                	shr    %cl,%ebx
  802525:	89 da                	mov    %ebx,%edx
  802527:	83 c4 1c             	add    $0x1c,%esp
  80252a:	5b                   	pop    %ebx
  80252b:	5e                   	pop    %esi
  80252c:	5f                   	pop    %edi
  80252d:	5d                   	pop    %ebp
  80252e:	c3                   	ret    
  80252f:	90                   	nop
  802530:	89 fd                	mov    %edi,%ebp
  802532:	85 ff                	test   %edi,%edi
  802534:	75 0b                	jne    802541 <__umoddi3+0xe9>
  802536:	b8 01 00 00 00       	mov    $0x1,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f7                	div    %edi
  80253f:	89 c5                	mov    %eax,%ebp
  802541:	89 f0                	mov    %esi,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f5                	div    %ebp
  802547:	89 c8                	mov    %ecx,%eax
  802549:	f7 f5                	div    %ebp
  80254b:	89 d0                	mov    %edx,%eax
  80254d:	e9 44 ff ff ff       	jmp    802496 <__umoddi3+0x3e>
  802552:	66 90                	xchg   %ax,%ax
  802554:	89 c8                	mov    %ecx,%eax
  802556:	89 f2                	mov    %esi,%edx
  802558:	83 c4 1c             	add    $0x1c,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	3b 04 24             	cmp    (%esp),%eax
  802563:	72 06                	jb     80256b <__umoddi3+0x113>
  802565:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802569:	77 0f                	ja     80257a <__umoddi3+0x122>
  80256b:	89 f2                	mov    %esi,%edx
  80256d:	29 f9                	sub    %edi,%ecx
  80256f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80257a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80257e:	8b 14 24             	mov    (%esp),%edx
  802581:	83 c4 1c             	add    $0x1c,%esp
  802584:	5b                   	pop    %ebx
  802585:	5e                   	pop    %esi
  802586:	5f                   	pop    %edi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    
  802589:	8d 76 00             	lea    0x0(%esi),%esi
  80258c:	2b 04 24             	sub    (%esp),%eax
  80258f:	19 fa                	sbb    %edi,%edx
  802591:	89 d1                	mov    %edx,%ecx
  802593:	89 c6                	mov    %eax,%esi
  802595:	e9 71 ff ff ff       	jmp    80250b <__umoddi3+0xb3>
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025a0:	72 ea                	jb     80258c <__umoddi3+0x134>
  8025a2:	89 d9                	mov    %ebx,%ecx
  8025a4:	e9 62 ff ff ff       	jmp    80250b <__umoddi3+0xb3>
