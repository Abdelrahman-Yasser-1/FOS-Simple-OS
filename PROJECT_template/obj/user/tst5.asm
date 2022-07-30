
obj/user/tst5:     file format elf32-i386


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
  800031:	e8 58 07 00 00       	call   80078e <libmain>
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
  80003d:	83 ec 60             	sub    $0x60,%esp
	
	rsttst();
  800040:	e8 fe 20 00 00       	call   802143 <rsttst>
	
	

	int Mega = 1024*1024;
  800045:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004c:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	void* ptr_allocations[20] = {0};
  800053:	8d 55 9c             	lea    -0x64(%ebp),%edx
  800056:	b9 14 00 00 00       	mov    $0x14,%ecx
  80005b:	b8 00 00 00 00       	mov    $0x0,%eax
  800060:	89 d7                	mov    %edx,%edi
  800062:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800064:	e8 9d 1d 00 00       	call   801e06 <sys_calculate_free_frames>
  800069:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80006c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006f:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	50                   	push   %eax
  800076:	e8 b6 16 00 00       	call   801731 <malloc>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		tst((uint32) ptr_allocations[0], USER_HEAP_START,USER_HEAP_START + PAGE_SIZE, 'b', 0);
  800081:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	6a 00                	push   $0x0
  800089:	6a 62                	push   $0x62
  80008b:	68 00 10 00 80       	push   $0x80001000
  800090:	68 00 00 00 80       	push   $0x80000000
  800095:	50                   	push   %eax
  800096:	e8 c2 20 00 00       	call   80215d <tst>
  80009b:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256+1 ,0, 'e', 0);
  80009e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000a1:	e8 60 1d 00 00       	call   801e06 <sys_calculate_free_frames>
  8000a6:	29 c3                	sub    %eax,%ebx
  8000a8:	89 d8                	mov    %ebx,%eax
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 65                	push   $0x65
  8000b1:	6a 00                	push   $0x0
  8000b3:	68 01 01 00 00       	push   $0x101
  8000b8:	50                   	push   %eax
  8000b9:	e8 9f 20 00 00       	call   80215d <tst>
  8000be:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c1:	e8 40 1d 00 00       	call   801e06 <sys_calculate_free_frames>
  8000c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	50                   	push   %eax
  8000d3:	e8 59 16 00 00       	call   801731 <malloc>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 a0             	mov    %eax,-0x60(%ebp)
		tst((uint32) ptr_allocations[1], USER_HEAP_START + 1*Mega,USER_HEAP_START + 1*Mega + PAGE_SIZE, 'b', 0);
  8000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e1:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ea:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8000f0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	6a 62                	push   $0x62
  8000fa:	51                   	push   %ecx
  8000fb:	52                   	push   %edx
  8000fc:	50                   	push   %eax
  8000fd:	e8 5b 20 00 00       	call   80215d <tst>
  800102:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  800105:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800108:	e8 f9 1c 00 00       	call   801e06 <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	6a 00                	push   $0x0
  800116:	6a 65                	push   $0x65
  800118:	6a 00                	push   $0x0
  80011a:	68 00 01 00 00       	push   $0x100
  80011f:	50                   	push   %eax
  800120:	e8 38 20 00 00       	call   80215d <tst>
  800125:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800128:	e8 d9 1c 00 00       	call   801e06 <sys_calculate_free_frames>
  80012d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800133:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	50                   	push   %eax
  80013a:	e8 f2 15 00 00       	call   801731 <malloc>
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tst((uint32) ptr_allocations[2], USER_HEAP_START + 2*Mega,USER_HEAP_START + 2*Mega + PAGE_SIZE, 'b', 0);
  800145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800148:	01 c0                	add    %eax,%eax
  80014a:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80015b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	6a 00                	push   $0x0
  800163:	6a 62                	push   $0x62
  800165:	51                   	push   %ecx
  800166:	52                   	push   %edx
  800167:	50                   	push   %eax
  800168:	e8 f0 1f 00 00       	call   80215d <tst>
  80016d:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  800170:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800173:	e8 8e 1c 00 00       	call   801e06 <sys_calculate_free_frames>
  800178:	29 c3                	sub    %eax,%ebx
  80017a:	89 d8                	mov    %ebx,%eax
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	6a 00                	push   $0x0
  800181:	6a 65                	push   $0x65
  800183:	6a 00                	push   $0x0
  800185:	68 00 01 00 00       	push   $0x100
  80018a:	50                   	push   %eax
  80018b:	e8 cd 1f 00 00       	call   80215d <tst>
  800190:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800193:	e8 6e 1c 00 00       	call   801e06 <sys_calculate_free_frames>
  800198:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80019b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80019e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	50                   	push   %eax
  8001a5:	e8 87 15 00 00       	call   801731 <malloc>
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	89 45 a8             	mov    %eax,-0x58(%ebp)
		tst((uint32) ptr_allocations[3], USER_HEAP_START + 3*Mega,USER_HEAP_START + 3*Mega + PAGE_SIZE, 'b', 0);
  8001b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b3:	89 c2                	mov    %eax,%edx
  8001b5:	01 d2                	add    %edx,%edx
  8001b7:	01 d0                	add    %edx,%eax
  8001b9:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8001bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001c2:	89 c2                	mov    %eax,%edx
  8001c4:	01 d2                	add    %edx,%edx
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8001ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	6a 00                	push   $0x0
  8001d6:	6a 62                	push   $0x62
  8001d8:	51                   	push   %ecx
  8001d9:	52                   	push   %edx
  8001da:	50                   	push   %eax
  8001db:	e8 7d 1f 00 00       	call   80215d <tst>
  8001e0:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256 ,0, 'e', 0);
  8001e3:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001e6:	e8 1b 1c 00 00       	call   801e06 <sys_calculate_free_frames>
  8001eb:	29 c3                	sub    %eax,%ebx
  8001ed:	89 d8                	mov    %ebx,%eax
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	6a 00                	push   $0x0
  8001f4:	6a 65                	push   $0x65
  8001f6:	6a 00                	push   $0x0
  8001f8:	68 00 01 00 00       	push   $0x100
  8001fd:	50                   	push   %eax
  8001fe:	e8 5a 1f 00 00       	call   80215d <tst>
  800203:	83 c4 20             	add    $0x20,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800206:	e8 fb 1b 00 00       	call   801e06 <sys_calculate_free_frames>
  80020b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80020e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	50                   	push   %eax
  80021a:	e8 12 15 00 00       	call   801731 <malloc>
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	89 45 ac             	mov    %eax,-0x54(%ebp)
		tst((uint32) ptr_allocations[4], USER_HEAP_START + 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800228:	c1 e0 02             	shl    $0x2,%eax
  80022b:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800234:	c1 e0 02             	shl    $0x2,%eax
  800237:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  80023d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	6a 00                	push   $0x0
  800245:	6a 62                	push   $0x62
  800247:	51                   	push   %ecx
  800248:	52                   	push   %edx
  800249:	50                   	push   %eax
  80024a:	e8 0e 1f 00 00       	call   80215d <tst>
  80024f:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+1 ,0, 'e', 0);
  800252:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800255:	e8 ac 1b 00 00       	call   801e06 <sys_calculate_free_frames>
  80025a:	29 c3                	sub    %eax,%ebx
  80025c:	89 d8                	mov    %ebx,%eax
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	6a 00                	push   $0x0
  800263:	6a 65                	push   $0x65
  800265:	6a 00                	push   $0x0
  800267:	68 01 02 00 00       	push   $0x201
  80026c:	50                   	push   %eax
  80026d:	e8 eb 1e 00 00       	call   80215d <tst>
  800272:	83 c4 20             	add    $0x20,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800275:	e8 8c 1b 00 00       	call   801e06 <sys_calculate_free_frames>
  80027a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800280:	01 c0                	add    %eax,%eax
  800282:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	50                   	push   %eax
  800289:	e8 a3 14 00 00       	call   801731 <malloc>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 b0             	mov    %eax,-0x50(%ebp)
		tst((uint32) ptr_allocations[5], USER_HEAP_START + 6*Mega,USER_HEAP_START + 6*Mega + PAGE_SIZE, 'b', 0);
  800294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800297:	89 d0                	mov    %edx,%eax
  800299:	01 c0                	add    %eax,%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	01 c0                	add    %eax,%eax
  80029f:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8002a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002a8:	89 d0                	mov    %edx,%eax
  8002aa:	01 c0                	add    %eax,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	01 c0                	add    %eax,%eax
  8002b0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8002b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	6a 00                	push   $0x0
  8002be:	6a 62                	push   $0x62
  8002c0:	51                   	push   %ecx
  8002c1:	52                   	push   %edx
  8002c2:	50                   	push   %eax
  8002c3:	e8 95 1e 00 00       	call   80215d <tst>
  8002c8:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512 ,0, 'e', 0);
  8002cb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8002ce:	e8 33 1b 00 00       	call   801e06 <sys_calculate_free_frames>
  8002d3:	29 c3                	sub    %eax,%ebx
  8002d5:	89 d8                	mov    %ebx,%eax
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	6a 65                	push   $0x65
  8002de:	6a 00                	push   $0x0
  8002e0:	68 00 02 00 00       	push   $0x200
  8002e5:	50                   	push   %eax
  8002e6:	e8 72 1e 00 00       	call   80215d <tst>
  8002eb:	83 c4 20             	add    $0x20,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ee:	e8 13 1b 00 00       	call   801e06 <sys_calculate_free_frames>
  8002f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	89 c2                	mov    %eax,%edx
  8002fb:	01 d2                	add    %edx,%edx
  8002fd:	01 d0                	add    %edx,%eax
  8002ff:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	50                   	push   %eax
  800306:	e8 26 14 00 00       	call   801731 <malloc>
  80030b:	83 c4 10             	add    $0x10,%esp
  80030e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		tst((uint32) ptr_allocations[6], USER_HEAP_START + 8*Mega,USER_HEAP_START + 8*Mega + PAGE_SIZE, 'b', 0);
  800311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800314:	c1 e0 03             	shl    $0x3,%eax
  800317:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80031d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800320:	c1 e0 03             	shl    $0x3,%eax
  800323:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800329:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	6a 00                	push   $0x0
  800331:	6a 62                	push   $0x62
  800333:	51                   	push   %ecx
  800334:	52                   	push   %edx
  800335:	50                   	push   %eax
  800336:	e8 22 1e 00 00       	call   80215d <tst>
  80033b:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 768+1 ,0, 'e', 0);
  80033e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800341:	e8 c0 1a 00 00       	call   801e06 <sys_calculate_free_frames>
  800346:	29 c3                	sub    %eax,%ebx
  800348:	89 d8                	mov    %ebx,%eax
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	6a 00                	push   $0x0
  80034f:	6a 65                	push   $0x65
  800351:	6a 00                	push   $0x0
  800353:	68 01 03 00 00       	push   $0x301
  800358:	50                   	push   %eax
  800359:	e8 ff 1d 00 00       	call   80215d <tst>
  80035e:	83 c4 20             	add    $0x20,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800361:	e8 a0 1a 00 00       	call   801e06 <sys_calculate_free_frames>
  800366:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	89 c2                	mov    %eax,%edx
  80036e:	01 d2                	add    %edx,%edx
  800370:	01 d0                	add    %edx,%eax
  800372:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800375:	83 ec 0c             	sub    $0xc,%esp
  800378:	50                   	push   %eax
  800379:	e8 b3 13 00 00       	call   801731 <malloc>
  80037e:	83 c4 10             	add    $0x10,%esp
  800381:	89 45 b8             	mov    %eax,-0x48(%ebp)
		tst((uint32) ptr_allocations[7], USER_HEAP_START + 11*Mega,USER_HEAP_START + 11*Mega + PAGE_SIZE, 'b', 0);
  800384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800387:	89 d0                	mov    %edx,%eax
  800389:	c1 e0 02             	shl    $0x2,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	01 c0                	add    %eax,%eax
  800390:	01 d0                	add    %edx,%eax
  800392:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	c1 e0 02             	shl    $0x2,%eax
  8003a0:	01 d0                	add    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8003ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003af:	83 ec 0c             	sub    $0xc,%esp
  8003b2:	6a 00                	push   $0x0
  8003b4:	6a 62                	push   $0x62
  8003b6:	51                   	push   %ecx
  8003b7:	52                   	push   %edx
  8003b8:	50                   	push   %eax
  8003b9:	e8 9f 1d 00 00       	call   80215d <tst>
  8003be:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 768+1 ,0, 'e', 0);
  8003c1:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8003c4:	e8 3d 1a 00 00       	call   801e06 <sys_calculate_free_frames>
  8003c9:	29 c3                	sub    %eax,%ebx
  8003cb:	89 d8                	mov    %ebx,%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	6a 00                	push   $0x0
  8003d2:	6a 65                	push   $0x65
  8003d4:	6a 00                	push   $0x0
  8003d6:	68 01 03 00 00       	push   $0x301
  8003db:	50                   	push   %eax
  8003dc:	e8 7c 1d 00 00       	call   80215d <tst>
  8003e1:	83 c4 20             	add    $0x20,%esp
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8003e4:	e8 1d 1a 00 00       	call   801e06 <sys_calculate_free_frames>
  8003e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free(ptr_allocations[1]);
  8003ec:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	50                   	push   %eax
  8003f3:	e8 68 15 00 00       	call   801960 <free>
  8003f8:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 256,0, 'e', 0);
  8003fb:	e8 06 1a 00 00       	call   801e06 <sys_calculate_free_frames>
  800400:	89 c2                	mov    %eax,%edx
  800402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800405:	29 c2                	sub    %eax,%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	83 ec 0c             	sub    $0xc,%esp
  80040c:	6a 00                	push   $0x0
  80040e:	6a 65                	push   $0x65
  800410:	6a 00                	push   $0x0
  800412:	68 00 01 00 00       	push   $0x100
  800417:	50                   	push   %eax
  800418:	e8 40 1d 00 00       	call   80215d <tst>
  80041d:	83 c4 20             	add    $0x20,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800420:	e8 e1 19 00 00       	call   801e06 <sys_calculate_free_frames>
  800425:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free(ptr_allocations[4]);
  800428:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 2c 15 00 00       	call   801960 <free>
  800434:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 512,0, 'e', 0);
  800437:	e8 ca 19 00 00       	call   801e06 <sys_calculate_free_frames>
  80043c:	89 c2                	mov    %eax,%edx
  80043e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800441:	29 c2                	sub    %eax,%edx
  800443:	89 d0                	mov    %edx,%eax
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	6a 00                	push   $0x0
  80044a:	6a 65                	push   $0x65
  80044c:	6a 00                	push   $0x0
  80044e:	68 00 02 00 00       	push   $0x200
  800453:	50                   	push   %eax
  800454:	e8 04 1d 00 00       	call   80215d <tst>
  800459:	83 c4 20             	add    $0x20,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80045c:	e8 a5 19 00 00       	call   801e06 <sys_calculate_free_frames>
  800461:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free(ptr_allocations[6]);
  800464:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800467:	83 ec 0c             	sub    $0xc,%esp
  80046a:	50                   	push   %eax
  80046b:	e8 f0 14 00 00       	call   801960 <free>
  800470:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 768,0, 'e', 0);
  800473:	e8 8e 19 00 00       	call   801e06 <sys_calculate_free_frames>
  800478:	89 c2                	mov    %eax,%edx
  80047a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047d:	29 c2                	sub    %eax,%edx
  80047f:	89 d0                	mov    %edx,%eax
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	6a 00                	push   $0x0
  800486:	6a 65                	push   $0x65
  800488:	6a 00                	push   $0x0
  80048a:	68 00 03 00 00       	push   $0x300
  80048f:	50                   	push   %eax
  800490:	e8 c8 1c 00 00       	call   80215d <tst>
  800495:	83 c4 20             	add    $0x20,%esp
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800498:	e8 69 19 00 00       	call   801e06 <sys_calculate_free_frames>
  80049d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8004a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004a3:	89 d0                	mov    %edx,%eax
  8004a5:	c1 e0 09             	shl    $0x9,%eax
  8004a8:	29 d0                	sub    %edx,%eax
  8004aa:	83 ec 0c             	sub    $0xc,%esp
  8004ad:	50                   	push   %eax
  8004ae:	e8 7e 12 00 00       	call   801731 <malloc>
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
		tst((uint32) ptr_allocations[8], USER_HEAP_START + 1*Mega,USER_HEAP_START + 1*Mega + PAGE_SIZE, 'b', 0);
  8004b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bc:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8004c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	83 ec 0c             	sub    $0xc,%esp
  8004d1:	6a 00                	push   $0x0
  8004d3:	6a 62                	push   $0x62
  8004d5:	51                   	push   %ecx
  8004d6:	52                   	push   %edx
  8004d7:	50                   	push   %eax
  8004d8:	e8 80 1c 00 00       	call   80215d <tst>
  8004dd:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 128 ,0, 'e', 0);
  8004e0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8004e3:	e8 1e 19 00 00       	call   801e06 <sys_calculate_free_frames>
  8004e8:	29 c3                	sub    %eax,%ebx
  8004ea:	89 d8                	mov    %ebx,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	6a 00                	push   $0x0
  8004f1:	6a 65                	push   $0x65
  8004f3:	6a 00                	push   $0x0
  8004f5:	68 80 00 00 00       	push   $0x80
  8004fa:	50                   	push   %eax
  8004fb:	e8 5d 1c 00 00       	call   80215d <tst>
  800500:	83 c4 20             	add    $0x20,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800503:	e8 fe 18 00 00       	call   801e06 <sys_calculate_free_frames>
  800508:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80050b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	50                   	push   %eax
  800515:	e8 17 12 00 00       	call   801731 <malloc>
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		tst((uint32) ptr_allocations[9], USER_HEAP_START + 4*Mega,USER_HEAP_START + 4*Mega + PAGE_SIZE, 'b', 0);
  800520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800523:	c1 e0 02             	shl    $0x2,%eax
  800526:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  80052c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800538:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80053b:	83 ec 0c             	sub    $0xc,%esp
  80053e:	6a 00                	push   $0x0
  800540:	6a 62                	push   $0x62
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	e8 13 1c 00 00       	call   80215d <tst>
  80054a:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 256,0, 'e', 0);
  80054d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800550:	e8 b1 18 00 00       	call   801e06 <sys_calculate_free_frames>
  800555:	29 c3                	sub    %eax,%ebx
  800557:	89 d8                	mov    %ebx,%eax
  800559:	83 ec 0c             	sub    $0xc,%esp
  80055c:	6a 00                	push   $0x0
  80055e:	6a 65                	push   $0x65
  800560:	6a 00                	push   $0x0
  800562:	68 00 01 00 00       	push   $0x100
  800567:	50                   	push   %eax
  800568:	e8 f0 1b 00 00       	call   80215d <tst>
  80056d:	83 c4 20             	add    $0x20,%esp

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800570:	e8 91 18 00 00       	call   801e06 <sys_calculate_free_frames>
  800575:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80057b:	89 d0                	mov    %edx,%eax
  80057d:	c1 e0 08             	shl    $0x8,%eax
  800580:	29 d0                	sub    %edx,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 a6 11 00 00       	call   801731 <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		tst((uint32) ptr_allocations[10], USER_HEAP_START + 1*Mega + 512*kilo,USER_HEAP_START + 1*Mega + 512*kilo + PAGE_SIZE, 'b', 0);
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800594:	c1 e0 09             	shl    $0x9,%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  8005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a7:	c1 e0 09             	shl    $0x9,%eax
  8005aa:	89 c2                	mov    %eax,%edx
  8005ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8005b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005ba:	83 ec 0c             	sub    $0xc,%esp
  8005bd:	6a 00                	push   $0x0
  8005bf:	6a 62                	push   $0x62
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	50                   	push   %eax
  8005c4:	e8 94 1b 00 00       	call   80215d <tst>
  8005c9:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 64,0, 'e', 0);
  8005cc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8005cf:	e8 32 18 00 00       	call   801e06 <sys_calculate_free_frames>
  8005d4:	29 c3                	sub    %eax,%ebx
  8005d6:	89 d8                	mov    %ebx,%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	6a 00                	push   $0x0
  8005dd:	6a 65                	push   $0x65
  8005df:	6a 00                	push   $0x0
  8005e1:	6a 40                	push   $0x40
  8005e3:	50                   	push   %eax
  8005e4:	e8 74 1b 00 00       	call   80215d <tst>
  8005e9:	83 c4 20             	add    $0x20,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8005ec:	e8 15 18 00 00       	call   801e06 <sys_calculate_free_frames>
  8005f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8005f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f7:	c1 e0 02             	shl    $0x2,%eax
  8005fa:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8005fd:	83 ec 0c             	sub    $0xc,%esp
  800600:	50                   	push   %eax
  800601:	e8 2b 11 00 00       	call   801731 <malloc>
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	89 45 c8             	mov    %eax,-0x38(%ebp)
		tst((uint32) ptr_allocations[11], USER_HEAP_START + 14*Mega,USER_HEAP_START + 14*Mega + PAGE_SIZE, 'b', 0);
  80060c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	01 c0                	add    %eax,%eax
  800613:	01 d0                	add    %edx,%eax
  800615:	01 c0                	add    %eax,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	01 c0                	add    %eax,%eax
  80061b:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800624:	89 d0                	mov    %edx,%eax
  800626:	01 c0                	add    %eax,%eax
  800628:	01 d0                	add    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800636:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	6a 00                	push   $0x0
  80063e:	6a 62                	push   $0x62
  800640:	51                   	push   %ecx
  800641:	52                   	push   %edx
  800642:	50                   	push   %eax
  800643:	e8 15 1b 00 00       	call   80215d <tst>
  800648:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 1024 + 1,0, 'e', 0);
  80064b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80064e:	e8 b3 17 00 00       	call   801e06 <sys_calculate_free_frames>
  800653:	29 c3                	sub    %eax,%ebx
  800655:	89 d8                	mov    %ebx,%eax
  800657:	83 ec 0c             	sub    $0xc,%esp
  80065a:	6a 00                	push   $0x0
  80065c:	6a 65                	push   $0x65
  80065e:	6a 00                	push   $0x0
  800660:	68 01 04 00 00       	push   $0x401
  800665:	50                   	push   %eax
  800666:	e8 f2 1a 00 00       	call   80215d <tst>
  80066b:	83 c4 20             	add    $0x20,%esp
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 93 17 00 00       	call   801e06 <sys_calculate_free_frames>
  800673:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free(ptr_allocations[2]);
  800676:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800679:	83 ec 0c             	sub    $0xc,%esp
  80067c:	50                   	push   %eax
  80067d:	e8 de 12 00 00       	call   801960 <free>
  800682:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 256,0, 'e', 0);
  800685:	e8 7c 17 00 00       	call   801e06 <sys_calculate_free_frames>
  80068a:	89 c2                	mov    %eax,%edx
  80068c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80068f:	29 c2                	sub    %eax,%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	6a 00                	push   $0x0
  800698:	6a 65                	push   $0x65
  80069a:	6a 00                	push   $0x0
  80069c:	68 00 01 00 00       	push   $0x100
  8006a1:	50                   	push   %eax
  8006a2:	e8 b6 1a 00 00       	call   80215d <tst>
  8006a7:	83 c4 20             	add    $0x20,%esp

		//Next 1 MB Hole appended also
		freeFrames = sys_calculate_free_frames() ;
  8006aa:	e8 57 17 00 00       	call   801e06 <sys_calculate_free_frames>
  8006af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free(ptr_allocations[3]);
  8006b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006b5:	83 ec 0c             	sub    $0xc,%esp
  8006b8:	50                   	push   %eax
  8006b9:	e8 a2 12 00 00       	call   801960 <free>
  8006be:	83 c4 10             	add    $0x10,%esp
		tst((sys_calculate_free_frames() - freeFrames) , 256,0, 'e', 0);
  8006c1:	e8 40 17 00 00       	call   801e06 <sys_calculate_free_frames>
  8006c6:	89 c2                	mov    %eax,%edx
  8006c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006cb:	29 c2                	sub    %eax,%edx
  8006cd:	89 d0                	mov    %edx,%eax
  8006cf:	83 ec 0c             	sub    $0xc,%esp
  8006d2:	6a 00                	push   $0x0
  8006d4:	6a 65                	push   $0x65
  8006d6:	6a 00                	push   $0x0
  8006d8:	68 00 01 00 00       	push   $0x100
  8006dd:	50                   	push   %eax
  8006de:	e8 7a 1a 00 00       	call   80215d <tst>
  8006e3:	83 c4 20             	add    $0x20,%esp
	}

	//[5] Allocate again [test first fit]
	{
		//Allocate 2 MB + 128 KB - should be placed in the contiguous hole (256 KB + 2 MB)
		freeFrames = sys_calculate_free_frames() ;
  8006e6:	e8 1b 17 00 00       	call   801e06 <sys_calculate_free_frames>
  8006eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		ptr_allocations[12] = malloc(2*Mega + 128*kilo - kilo);
  8006ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f1:	c1 e0 06             	shl    $0x6,%eax
  8006f4:	89 c2                	mov    %eax,%edx
  8006f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f9:	01 d0                	add    %edx,%eax
  8006fb:	01 c0                	add    %eax,%eax
  8006fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	50                   	push   %eax
  800704:	e8 28 10 00 00       	call   801731 <malloc>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		tst((uint32) ptr_allocations[12], USER_HEAP_START + 1*Mega+ 768*kilo,USER_HEAP_START + 1*Mega+ 768*kilo + PAGE_SIZE, 'b', 0);
  80070f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800712:	89 d0                	mov    %edx,%eax
  800714:	01 c0                	add    %eax,%eax
  800716:	01 d0                	add    %edx,%eax
  800718:	c1 e0 08             	shl    $0x8,%eax
  80071b:	89 c2                	mov    %eax,%edx
  80071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800720:	01 d0                	add    %edx,%eax
  800722:	8d 88 00 10 00 80    	lea    -0x7ffff000(%eax),%ecx
  800728:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80072b:	89 d0                	mov    %edx,%eax
  80072d:	01 c0                	add    %eax,%eax
  80072f:	01 d0                	add    %edx,%eax
  800731:	c1 e0 08             	shl    $0x8,%eax
  800734:	89 c2                	mov    %eax,%edx
  800736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800739:	01 d0                	add    %edx,%eax
  80073b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  800741:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	6a 00                	push   $0x0
  800749:	6a 62                	push   $0x62
  80074b:	51                   	push   %ecx
  80074c:	52                   	push   %edx
  80074d:	50                   	push   %eax
  80074e:	e8 0a 1a 00 00       	call   80215d <tst>
  800753:	83 c4 20             	add    $0x20,%esp
		tst((freeFrames - sys_calculate_free_frames()) , 512+32,0, 'e', 0);
  800756:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800759:	e8 a8 16 00 00       	call   801e06 <sys_calculate_free_frames>
  80075e:	29 c3                	sub    %eax,%ebx
  800760:	89 d8                	mov    %ebx,%eax
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	6a 65                	push   $0x65
  800769:	6a 00                	push   $0x0
  80076b:	68 20 02 00 00       	push   $0x220
  800770:	50                   	push   %eax
  800771:	e8 e7 19 00 00       	call   80215d <tst>
  800776:	83 c4 20             	add    $0x20,%esp
	}

	chktst(31);
  800779:	83 ec 0c             	sub    $0xc,%esp
  80077c:	6a 1f                	push   $0x1f
  80077e:	e8 05 1a 00 00       	call   802188 <chktst>
  800783:	83 c4 10             	add    $0x10,%esp

	return;
  800786:	90                   	nop
}
  800787:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80078a:	5b                   	pop    %ebx
  80078b:	5f                   	pop    %edi
  80078c:	5d                   	pop    %ebp
  80078d:	c3                   	ret    

0080078e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800794:	e8 a2 15 00 00       	call   801d3b <sys_getenvindex>
  800799:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80079c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079f:	89 d0                	mov    %edx,%eax
  8007a1:	c1 e0 03             	shl    $0x3,%eax
  8007a4:	01 d0                	add    %edx,%eax
  8007a6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007ad:	01 c8                	add    %ecx,%eax
  8007af:	01 c0                	add    %eax,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	89 c2                	mov    %eax,%edx
  8007b9:	c1 e2 05             	shl    $0x5,%edx
  8007bc:	29 c2                	sub    %eax,%edx
  8007be:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007cd:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d7:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8007dd:	84 c0                	test   %al,%al
  8007df:	74 0f                	je     8007f0 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8007e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e6:	05 40 3c 01 00       	add    $0x13c40,%eax
  8007eb:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007f4:	7e 0a                	jle    800800 <libmain+0x72>
		binaryname = argv[0];
  8007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	e8 2a f8 ff ff       	call   800038 <_main>
  80080e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800811:	e8 c0 16 00 00       	call   801ed6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800816:	83 ec 0c             	sub    $0xc,%esp
  800819:	68 58 27 80 00       	push   $0x802758
  80081e:	e8 84 01 00 00       	call   8009a7 <cprintf>
  800823:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800826:	a1 20 30 80 00       	mov    0x803020,%eax
  80082b:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800831:	a1 20 30 80 00       	mov    0x803020,%eax
  800836:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  80083c:	83 ec 04             	sub    $0x4,%esp
  80083f:	52                   	push   %edx
  800840:	50                   	push   %eax
  800841:	68 80 27 80 00       	push   $0x802780
  800846:	e8 5c 01 00 00       	call   8009a7 <cprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  80084e:	a1 20 30 80 00       	mov    0x803020,%eax
  800853:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800859:	a1 20 30 80 00       	mov    0x803020,%eax
  80085e:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800864:	83 ec 04             	sub    $0x4,%esp
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	68 a8 27 80 00       	push   $0x8027a8
  80086e:	e8 34 01 00 00       	call   8009a7 <cprintf>
  800873:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800876:	a1 20 30 80 00       	mov    0x803020,%eax
  80087b:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	50                   	push   %eax
  800885:	68 e9 27 80 00       	push   $0x8027e9
  80088a:	e8 18 01 00 00       	call   8009a7 <cprintf>
  80088f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	68 58 27 80 00       	push   $0x802758
  80089a:	e8 08 01 00 00       	call   8009a7 <cprintf>
  80089f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a2:	e8 49 16 00 00       	call   801ef0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008a7:	e8 19 00 00 00       	call   8008c5 <exit>
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8008b5:	83 ec 0c             	sub    $0xc,%esp
  8008b8:	6a 00                	push   $0x0
  8008ba:	e8 48 14 00 00       	call   801d07 <sys_env_destroy>
  8008bf:	83 c4 10             	add    $0x10,%esp
}
  8008c2:	90                   	nop
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    

008008c5 <exit>:

void
exit(void)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8008cb:	e8 9d 14 00 00       	call   801d6d <sys_env_exit>
}
  8008d0:	90                   	nop
  8008d1:	c9                   	leave  
  8008d2:	c3                   	ret    

008008d3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e4:	89 0a                	mov    %ecx,(%edx)
  8008e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e9:	88 d1                	mov    %dl,%cl
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008fc:	75 2c                	jne    80092a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008fe:	a0 24 30 80 00       	mov    0x803024,%al
  800903:	0f b6 c0             	movzbl %al,%eax
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
  800909:	8b 12                	mov    (%edx),%edx
  80090b:	89 d1                	mov    %edx,%ecx
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	83 c2 08             	add    $0x8,%edx
  800913:	83 ec 04             	sub    $0x4,%esp
  800916:	50                   	push   %eax
  800917:	51                   	push   %ecx
  800918:	52                   	push   %edx
  800919:	e8 a7 13 00 00       	call   801cc5 <sys_cputs>
  80091e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	8b 40 04             	mov    0x4(%eax),%eax
  800930:	8d 50 01             	lea    0x1(%eax),%edx
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	89 50 04             	mov    %edx,0x4(%eax)
}
  800939:	90                   	nop
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800945:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80094c:	00 00 00 
	b.cnt = 0;
  80094f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800956:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	ff 75 08             	pushl  0x8(%ebp)
  80095f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800965:	50                   	push   %eax
  800966:	68 d3 08 80 00       	push   $0x8008d3
  80096b:	e8 11 02 00 00       	call   800b81 <vprintfmt>
  800970:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800973:	a0 24 30 80 00       	mov    0x803024,%al
  800978:	0f b6 c0             	movzbl %al,%eax
  80097b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	50                   	push   %eax
  800985:	52                   	push   %edx
  800986:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80098c:	83 c0 08             	add    $0x8,%eax
  80098f:	50                   	push   %eax
  800990:	e8 30 13 00 00       	call   801cc5 <sys_cputs>
  800995:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800998:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80099f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009ad:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c3:	50                   	push   %eax
  8009c4:	e8 73 ff ff ff       	call   80093c <vcprintf>
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    

008009d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009da:	e8 f7 14 00 00       	call   801ed6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 48 ff ff ff       	call   80093c <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009fa:	e8 f1 14 00 00       	call   801ef0 <sys_enable_interrupt>
	return cnt;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	53                   	push   %ebx
  800a08:	83 ec 14             	sub    $0x14,%esp
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a17:	8b 45 18             	mov    0x18(%ebp),%eax
  800a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a22:	77 55                	ja     800a79 <printnum+0x75>
  800a24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a27:	72 05                	jb     800a2e <printnum+0x2a>
  800a29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a2c:	77 4b                	ja     800a79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a34:	8b 45 18             	mov    0x18(%ebp),%eax
  800a37:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3c:	52                   	push   %edx
  800a3d:	50                   	push   %eax
  800a3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a41:	ff 75 f0             	pushl  -0x10(%ebp)
  800a44:	e8 7f 1a 00 00       	call   8024c8 <__udivdi3>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	ff 75 20             	pushl  0x20(%ebp)
  800a52:	53                   	push   %ebx
  800a53:	ff 75 18             	pushl  0x18(%ebp)
  800a56:	52                   	push   %edx
  800a57:	50                   	push   %eax
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	ff 75 08             	pushl  0x8(%ebp)
  800a5e:	e8 a1 ff ff ff       	call   800a04 <printnum>
  800a63:	83 c4 20             	add    $0x20,%esp
  800a66:	eb 1a                	jmp    800a82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	ff 75 20             	pushl  0x20(%ebp)
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a79:	ff 4d 1c             	decl   0x1c(%ebp)
  800a7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a80:	7f e6                	jg     800a68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a90:	53                   	push   %ebx
  800a91:	51                   	push   %ecx
  800a92:	52                   	push   %edx
  800a93:	50                   	push   %eax
  800a94:	e8 3f 1b 00 00       	call   8025d8 <__umoddi3>
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	05 14 2a 80 00       	add    $0x802a14,%eax
  800aa1:	8a 00                	mov    (%eax),%al
  800aa3:	0f be c0             	movsbl %al,%eax
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	50                   	push   %eax
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
}
  800ab5:	90                   	nop
  800ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800abe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ac2:	7e 1c                	jle    800ae0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 08             	lea    0x8(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 08             	sub    $0x8,%eax
  800ad9:	8b 50 04             	mov    0x4(%eax),%edx
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	eb 40                	jmp    800b20 <getuint+0x65>
	else if (lflag)
  800ae0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae4:	74 1e                	je     800b04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	8d 50 04             	lea    0x4(%eax),%edx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	89 10                	mov    %edx,(%eax)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	83 e8 04             	sub    $0x4,%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	ba 00 00 00 00       	mov    $0x0,%edx
  800b02:	eb 1c                	jmp    800b20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	8d 50 04             	lea    0x4(%eax),%edx
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	89 10                	mov    %edx,(%eax)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	83 e8 04             	sub    $0x4,%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b29:	7e 1c                	jle    800b47 <getint+0x25>
		return va_arg(*ap, long long);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	8d 50 08             	lea    0x8(%eax),%edx
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	89 10                	mov    %edx,(%eax)
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	83 e8 08             	sub    $0x8,%eax
  800b40:	8b 50 04             	mov    0x4(%eax),%edx
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	eb 38                	jmp    800b7f <getint+0x5d>
	else if (lflag)
  800b47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4b:	74 1a                	je     800b67 <getint+0x45>
		return va_arg(*ap, long);
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	8d 50 04             	lea    0x4(%eax),%edx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	89 10                	mov    %edx,(%eax)
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	83 e8 04             	sub    $0x4,%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	99                   	cltd   
  800b65:	eb 18                	jmp    800b7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	8d 50 04             	lea    0x4(%eax),%edx
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	89 10                	mov    %edx,(%eax)
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8b 00                	mov    (%eax),%eax
  800b79:	83 e8 04             	sub    $0x4,%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	99                   	cltd   
}
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b89:	eb 17                	jmp    800ba2 <vprintfmt+0x21>
			if (ch == '\0')
  800b8b:	85 db                	test   %ebx,%ebx
  800b8d:	0f 84 af 03 00 00    	je     800f42 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	53                   	push   %ebx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	8d 50 01             	lea    0x1(%eax),%edx
  800ba8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bab:	8a 00                	mov    (%eax),%al
  800bad:	0f b6 d8             	movzbl %al,%ebx
  800bb0:	83 fb 25             	cmp    $0x25,%ebx
  800bb3:	75 d6                	jne    800b8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bb5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bb9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800be6:	83 f8 55             	cmp    $0x55,%eax
  800be9:	0f 87 2b 03 00 00    	ja     800f1a <vprintfmt+0x399>
  800bef:	8b 04 85 38 2a 80 00 	mov    0x802a38(,%eax,4),%eax
  800bf6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bf8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bfc:	eb d7                	jmp    800bd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c02:	eb d1                	jmp    800bd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c0e:	89 d0                	mov    %edx,%eax
  800c10:	c1 e0 02             	shl    $0x2,%eax
  800c13:	01 d0                	add    %edx,%eax
  800c15:	01 c0                	add    %eax,%eax
  800c17:	01 d8                	add    %ebx,%eax
  800c19:	83 e8 30             	sub    $0x30,%eax
  800c1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c22:	8a 00                	mov    (%eax),%al
  800c24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c27:	83 fb 2f             	cmp    $0x2f,%ebx
  800c2a:	7e 3e                	jle    800c6a <vprintfmt+0xe9>
  800c2c:	83 fb 39             	cmp    $0x39,%ebx
  800c2f:	7f 39                	jg     800c6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c34:	eb d5                	jmp    800c0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c4a:	eb 1f                	jmp    800c6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c50:	79 83                	jns    800bd5 <vprintfmt+0x54>
				width = 0;
  800c52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c59:	e9 77 ff ff ff       	jmp    800bd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c65:	e9 6b ff ff ff       	jmp    800bd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c6f:	0f 89 60 ff ff ff    	jns    800bd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c82:	e9 4e ff ff ff       	jmp    800bd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c8a:	e9 46 ff ff ff       	jmp    800bd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 14             	mov    %eax,0x14(%ebp)
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	83 e8 04             	sub    $0x4,%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
			break;
  800caf:	e9 89 02 00 00       	jmp    800f3d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 c0 04             	add    $0x4,%eax
  800cba:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cc5:	85 db                	test   %ebx,%ebx
  800cc7:	79 02                	jns    800ccb <vprintfmt+0x14a>
				err = -err;
  800cc9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ccb:	83 fb 64             	cmp    $0x64,%ebx
  800cce:	7f 0b                	jg     800cdb <vprintfmt+0x15a>
  800cd0:	8b 34 9d 80 28 80 00 	mov    0x802880(,%ebx,4),%esi
  800cd7:	85 f6                	test   %esi,%esi
  800cd9:	75 19                	jne    800cf4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cdb:	53                   	push   %ebx
  800cdc:	68 25 2a 80 00       	push   $0x802a25
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	ff 75 08             	pushl  0x8(%ebp)
  800ce7:	e8 5e 02 00 00       	call   800f4a <printfmt>
  800cec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cef:	e9 49 02 00 00       	jmp    800f3d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cf4:	56                   	push   %esi
  800cf5:	68 2e 2a 80 00       	push   $0x802a2e
  800cfa:	ff 75 0c             	pushl  0xc(%ebp)
  800cfd:	ff 75 08             	pushl  0x8(%ebp)
  800d00:	e8 45 02 00 00       	call   800f4a <printfmt>
  800d05:	83 c4 10             	add    $0x10,%esp
			break;
  800d08:	e9 30 02 00 00       	jmp    800f3d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d10:	83 c0 04             	add    $0x4,%eax
  800d13:	89 45 14             	mov    %eax,0x14(%ebp)
  800d16:	8b 45 14             	mov    0x14(%ebp),%eax
  800d19:	83 e8 04             	sub    $0x4,%eax
  800d1c:	8b 30                	mov    (%eax),%esi
  800d1e:	85 f6                	test   %esi,%esi
  800d20:	75 05                	jne    800d27 <vprintfmt+0x1a6>
				p = "(null)";
  800d22:	be 31 2a 80 00       	mov    $0x802a31,%esi
			if (width > 0 && padc != '-')
  800d27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2b:	7e 6d                	jle    800d9a <vprintfmt+0x219>
  800d2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d31:	74 67                	je     800d9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	50                   	push   %eax
  800d3a:	56                   	push   %esi
  800d3b:	e8 0c 03 00 00       	call   80104c <strnlen>
  800d40:	83 c4 10             	add    $0x10,%esp
  800d43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d46:	eb 16                	jmp    800d5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d4c:	83 ec 08             	sub    $0x8,%esp
  800d4f:	ff 75 0c             	pushl  0xc(%ebp)
  800d52:	50                   	push   %eax
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	ff d0                	call   *%eax
  800d58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d62:	7f e4                	jg     800d48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d64:	eb 34                	jmp    800d9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d6a:	74 1c                	je     800d88 <vprintfmt+0x207>
  800d6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d6f:	7e 05                	jle    800d76 <vprintfmt+0x1f5>
  800d71:	83 fb 7e             	cmp    $0x7e,%ebx
  800d74:	7e 12                	jle    800d88 <vprintfmt+0x207>
					putch('?', putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	6a 3f                	push   $0x3f
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
  800d86:	eb 0f                	jmp    800d97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d88:	83 ec 08             	sub    $0x8,%esp
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	53                   	push   %ebx
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	ff d0                	call   *%eax
  800d94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	ff 4d e4             	decl   -0x1c(%ebp)
  800d9a:	89 f0                	mov    %esi,%eax
  800d9c:	8d 70 01             	lea    0x1(%eax),%esi
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	0f be d8             	movsbl %al,%ebx
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	74 24                	je     800dcc <vprintfmt+0x24b>
  800da8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dac:	78 b8                	js     800d66 <vprintfmt+0x1e5>
  800dae:	ff 4d e0             	decl   -0x20(%ebp)
  800db1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800db5:	79 af                	jns    800d66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	eb 13                	jmp    800dcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 20                	push   $0x20
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd0:	7f e7                	jg     800db9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dd2:	e9 66 01 00 00       	jmp    800f3d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	ff 75 e8             	pushl  -0x18(%ebp)
  800ddd:	8d 45 14             	lea    0x14(%ebp),%eax
  800de0:	50                   	push   %eax
  800de1:	e8 3c fd ff ff       	call   800b22 <getint>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df5:	85 d2                	test   %edx,%edx
  800df7:	79 23                	jns    800e1c <vprintfmt+0x29b>
				putch('-', putdat);
  800df9:	83 ec 08             	sub    $0x8,%esp
  800dfc:	ff 75 0c             	pushl  0xc(%ebp)
  800dff:	6a 2d                	push   $0x2d
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	ff d0                	call   *%eax
  800e06:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0f:	f7 d8                	neg    %eax
  800e11:	83 d2 00             	adc    $0x0,%edx
  800e14:	f7 da                	neg    %edx
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 bc 00 00 00       	jmp    800ee4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e2e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e31:	50                   	push   %eax
  800e32:	e8 84 fc ff ff       	call   800abb <getuint>
  800e37:	83 c4 10             	add    $0x10,%esp
  800e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e47:	e9 98 00 00 00       	jmp    800ee4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	ff 75 0c             	pushl  0xc(%ebp)
  800e52:	6a 58                	push   $0x58
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	ff d0                	call   *%eax
  800e59:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	6a 58                	push   $0x58
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	ff d0                	call   *%eax
  800e69:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	ff 75 0c             	pushl  0xc(%ebp)
  800e72:	6a 58                	push   $0x58
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	ff d0                	call   *%eax
  800e79:	83 c4 10             	add    $0x10,%esp
			break;
  800e7c:	e9 bc 00 00 00       	jmp    800f3d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	6a 30                	push   $0x30
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	ff d0                	call   *%eax
  800e8e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	6a 78                	push   $0x78
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	ff d0                	call   *%eax
  800e9e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 c0 04             	add    $0x4,%eax
  800ea7:	89 45 14             	mov    %eax,0x14(%ebp)
  800eaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ebc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ec3:	eb 1f                	jmp    800ee4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ece:	50                   	push   %eax
  800ecf:	e8 e7 fb ff ff       	call   800abb <getuint>
  800ed4:	83 c4 10             	add    $0x10,%esp
  800ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800edd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ee4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eeb:	83 ec 04             	sub    $0x4,%esp
  800eee:	52                   	push   %edx
  800eef:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ef2:	50                   	push   %eax
  800ef3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef6:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	ff 75 08             	pushl  0x8(%ebp)
  800eff:	e8 00 fb ff ff       	call   800a04 <printnum>
  800f04:	83 c4 20             	add    $0x20,%esp
			break;
  800f07:	eb 34                	jmp    800f3d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	53                   	push   %ebx
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			break;
  800f18:	eb 23                	jmp    800f3d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	6a 25                	push   $0x25
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	ff d0                	call   *%eax
  800f27:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f2a:	ff 4d 10             	decl   0x10(%ebp)
  800f2d:	eb 03                	jmp    800f32 <vprintfmt+0x3b1>
  800f2f:	ff 4d 10             	decl   0x10(%ebp)
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	48                   	dec    %eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 25                	cmp    $0x25,%al
  800f3a:	75 f3                	jne    800f2f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f3c:	90                   	nop
		}
	}
  800f3d:	e9 47 fc ff ff       	jmp    800b89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f42:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f50:	8d 45 10             	lea    0x10(%ebp),%eax
  800f53:	83 c0 04             	add    $0x4,%eax
  800f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5f:	50                   	push   %eax
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	ff 75 08             	pushl  0x8(%ebp)
  800f66:	e8 16 fc ff ff       	call   800b81 <vprintfmt>
  800f6b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	8b 40 08             	mov    0x8(%eax),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8b 10                	mov    (%eax),%edx
  800f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8b:	8b 40 04             	mov    0x4(%eax),%eax
  800f8e:	39 c2                	cmp    %eax,%edx
  800f90:	73 12                	jae    800fa4 <sprintputch+0x33>
		*b->buf++ = ch;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	8b 00                	mov    (%eax),%eax
  800f97:	8d 48 01             	lea    0x1(%eax),%ecx
  800f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9d:	89 0a                	mov    %ecx,(%edx)
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	88 10                	mov    %dl,(%eax)
}
  800fa4:	90                   	nop
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	01 d0                	add    %edx,%eax
  800fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fcc:	74 06                	je     800fd4 <vsnprintf+0x2d>
  800fce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fd2:	7f 07                	jg     800fdb <vsnprintf+0x34>
		return -E_INVAL;
  800fd4:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd9:	eb 20                	jmp    800ffb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fdb:	ff 75 14             	pushl  0x14(%ebp)
  800fde:	ff 75 10             	pushl  0x10(%ebp)
  800fe1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fe4:	50                   	push   %eax
  800fe5:	68 71 0f 80 00       	push   $0x800f71
  800fea:	e8 92 fb ff ff       	call   800b81 <vprintfmt>
  800fef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ff5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801003:	8d 45 10             	lea    0x10(%ebp),%eax
  801006:	83 c0 04             	add    $0x4,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	ff 75 f4             	pushl  -0xc(%ebp)
  801012:	50                   	push   %eax
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	ff 75 08             	pushl  0x8(%ebp)
  801019:	e8 89 ff ff ff       	call   800fa7 <vsnprintf>
  80101e:	83 c4 10             	add    $0x10,%esp
  801021:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801024:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80102f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801036:	eb 06                	jmp    80103e <strlen+0x15>
		n++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80103b:	ff 45 08             	incl   0x8(%ebp)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	84 c0                	test   %al,%al
  801045:	75 f1                	jne    801038 <strlen+0xf>
		n++;
	return n;
  801047:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801059:	eb 09                	jmp    801064 <strnlen+0x18>
		n++;
  80105b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80105e:	ff 45 08             	incl   0x8(%ebp)
  801061:	ff 4d 0c             	decl   0xc(%ebp)
  801064:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801068:	74 09                	je     801073 <strnlen+0x27>
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	84 c0                	test   %al,%al
  801071:	75 e8                	jne    80105b <strnlen+0xf>
		n++;
	return n;
  801073:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801084:	90                   	nop
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8d 50 01             	lea    0x1(%eax),%edx
  80108b:	89 55 08             	mov    %edx,0x8(%ebp)
  80108e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801091:	8d 4a 01             	lea    0x1(%edx),%ecx
  801094:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801097:	8a 12                	mov    (%edx),%dl
  801099:	88 10                	mov    %dl,(%eax)
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	84 c0                	test   %al,%al
  80109f:	75 e4                	jne    801085 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010b9:	eb 1f                	jmp    8010da <strncpy+0x34>
		*dst++ = *src;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8a 12                	mov    (%edx),%dl
  8010c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	84 c0                	test   %al,%al
  8010d2:	74 03                	je     8010d7 <strncpy+0x31>
			src++;
  8010d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010d7:	ff 45 fc             	incl   -0x4(%ebp)
  8010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010e0:	72 d9                	jb     8010bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f7:	74 30                	je     801129 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010f9:	eb 16                	jmp    801111 <strlcpy+0x2a>
			*dst++ = *src++;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8d 50 01             	lea    0x1(%eax),%edx
  801101:	89 55 08             	mov    %edx,0x8(%ebp)
  801104:	8b 55 0c             	mov    0xc(%ebp),%edx
  801107:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80110d:	8a 12                	mov    (%edx),%dl
  80110f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801111:	ff 4d 10             	decl   0x10(%ebp)
  801114:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801118:	74 09                	je     801123 <strlcpy+0x3c>
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	84 c0                	test   %al,%al
  801121:	75 d8                	jne    8010fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112f:	29 c2                	sub    %eax,%edx
  801131:	89 d0                	mov    %edx,%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801138:	eb 06                	jmp    801140 <strcmp+0xb>
		p++, q++;
  80113a:	ff 45 08             	incl   0x8(%ebp)
  80113d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	74 0e                	je     801157 <strcmp+0x22>
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 10                	mov    (%eax),%dl
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	38 c2                	cmp    %al,%dl
  801155:	74 e3                	je     80113a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	0f b6 d0             	movzbl %al,%edx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 c0             	movzbl %al,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
}
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801170:	eb 09                	jmp    80117b <strncmp+0xe>
		n--, p++, q++;
  801172:	ff 4d 10             	decl   0x10(%ebp)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 17                	je     801198 <strncmp+0x2b>
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	84 c0                	test   %al,%al
  801188:	74 0e                	je     801198 <strncmp+0x2b>
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 10                	mov    (%eax),%dl
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	38 c2                	cmp    %al,%dl
  801196:	74 da                	je     801172 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119c:	75 07                	jne    8011a5 <strncmp+0x38>
		return 0;
  80119e:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a3:	eb 14                	jmp    8011b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	0f b6 d0             	movzbl %al,%edx
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	0f b6 c0             	movzbl %al,%eax
  8011b5:	29 c2                	sub    %eax,%edx
  8011b7:	89 d0                	mov    %edx,%eax
}
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 04             	sub    $0x4,%esp
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011c7:	eb 12                	jmp    8011db <strchr+0x20>
		if (*s == c)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011d1:	75 05                	jne    8011d8 <strchr+0x1d>
			return (char *) s;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	eb 11                	jmp    8011e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	84 c0                	test   %al,%al
  8011e2:	75 e5                	jne    8011c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f7:	eb 0d                	jmp    801206 <strfind+0x1b>
		if (*s == c)
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801201:	74 0e                	je     801211 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 ea                	jne    8011f9 <strfind+0xe>
  80120f:	eb 01                	jmp    801212 <strfind+0x27>
		if (*s == c)
			break;
  801211:	90                   	nop
	return (char *) s;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801229:	eb 0e                	jmp    801239 <memset+0x22>
		*p++ = c;
  80122b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801239:	ff 4d f8             	decl   -0x8(%ebp)
  80123c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801240:	79 e9                	jns    80122b <memset+0x14>
		*p++ = c;

	return v;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801259:	eb 16                	jmp    801271 <memcpy+0x2a>
		*d++ = *s++;
  80125b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801264:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801267:	8d 4a 01             	lea    0x1(%edx),%ecx
  80126a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80126d:	8a 12                	mov    (%edx),%dl
  80126f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801271:	8b 45 10             	mov    0x10(%ebp),%eax
  801274:	8d 50 ff             	lea    -0x1(%eax),%edx
  801277:	89 55 10             	mov    %edx,0x10(%ebp)
  80127a:	85 c0                	test   %eax,%eax
  80127c:	75 dd                	jne    80125b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801295:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801298:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80129b:	73 50                	jae    8012ed <memmove+0x6a>
  80129d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a8:	76 43                	jbe    8012ed <memmove+0x6a>
		s += n;
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012b6:	eb 10                	jmp    8012c8 <memmove+0x45>
			*--d = *--s;
  8012b8:	ff 4d f8             	decl   -0x8(%ebp)
  8012bb:	ff 4d fc             	decl   -0x4(%ebp)
  8012be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c1:	8a 10                	mov    (%eax),%dl
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	75 e3                	jne    8012b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012d5:	eb 23                	jmp    8012fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012da:	8d 50 01             	lea    0x1(%eax),%edx
  8012dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012e9:	8a 12                	mov    (%edx),%dl
  8012eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	75 dd                	jne    8012d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801311:	eb 2a                	jmp    80133d <memcmp+0x3e>
		if (*s1 != *s2)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	8a 10                	mov    (%eax),%dl
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	38 c2                	cmp    %al,%dl
  80131f:	74 16                	je     801337 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	0f b6 d0             	movzbl %al,%edx
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	0f b6 c0             	movzbl %al,%eax
  801331:	29 c2                	sub    %eax,%edx
  801333:	89 d0                	mov    %edx,%eax
  801335:	eb 18                	jmp    80134f <memcmp+0x50>
		s1++, s2++;
  801337:	ff 45 fc             	incl   -0x4(%ebp)
  80133a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	8d 50 ff             	lea    -0x1(%eax),%edx
  801343:	89 55 10             	mov    %edx,0x10(%ebp)
  801346:	85 c0                	test   %eax,%eax
  801348:	75 c9                	jne    801313 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801357:	8b 55 08             	mov    0x8(%ebp),%edx
  80135a:	8b 45 10             	mov    0x10(%ebp),%eax
  80135d:	01 d0                	add    %edx,%eax
  80135f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801362:	eb 15                	jmp    801379 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	0f b6 d0             	movzbl %al,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	0f b6 c0             	movzbl %al,%eax
  801372:	39 c2                	cmp    %eax,%edx
  801374:	74 0d                	je     801383 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801376:	ff 45 08             	incl   0x8(%ebp)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80137f:	72 e3                	jb     801364 <memfind+0x13>
  801381:	eb 01                	jmp    801384 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801383:	90                   	nop
	return (void *) s;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801396:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139d:	eb 03                	jmp    8013a2 <strtol+0x19>
		s++;
  80139f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 20                	cmp    $0x20,%al
  8013a9:	74 f4                	je     80139f <strtol+0x16>
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 09                	cmp    $0x9,%al
  8013b2:	74 eb                	je     80139f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	3c 2b                	cmp    $0x2b,%al
  8013bb:	75 05                	jne    8013c2 <strtol+0x39>
		s++;
  8013bd:	ff 45 08             	incl   0x8(%ebp)
  8013c0:	eb 13                	jmp    8013d5 <strtol+0x4c>
	else if (*s == '-')
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 2d                	cmp    $0x2d,%al
  8013c9:	75 0a                	jne    8013d5 <strtol+0x4c>
		s++, neg = 1;
  8013cb:	ff 45 08             	incl   0x8(%ebp)
  8013ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d9:	74 06                	je     8013e1 <strtol+0x58>
  8013db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013df:	75 20                	jne    801401 <strtol+0x78>
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	3c 30                	cmp    $0x30,%al
  8013e8:	75 17                	jne    801401 <strtol+0x78>
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	40                   	inc    %eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	3c 78                	cmp    $0x78,%al
  8013f2:	75 0d                	jne    801401 <strtol+0x78>
		s += 2, base = 16;
  8013f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ff:	eb 28                	jmp    801429 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801401:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801405:	75 15                	jne    80141c <strtol+0x93>
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	3c 30                	cmp    $0x30,%al
  80140e:	75 0c                	jne    80141c <strtol+0x93>
		s++, base = 8;
  801410:	ff 45 08             	incl   0x8(%ebp)
  801413:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80141a:	eb 0d                	jmp    801429 <strtol+0xa0>
	else if (base == 0)
  80141c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801420:	75 07                	jne    801429 <strtol+0xa0>
		base = 10;
  801422:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 2f                	cmp    $0x2f,%al
  801430:	7e 19                	jle    80144b <strtol+0xc2>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 39                	cmp    $0x39,%al
  801439:	7f 10                	jg     80144b <strtol+0xc2>
			dig = *s - '0';
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	0f be c0             	movsbl %al,%eax
  801443:	83 e8 30             	sub    $0x30,%eax
  801446:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801449:	eb 42                	jmp    80148d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	3c 60                	cmp    $0x60,%al
  801452:	7e 19                	jle    80146d <strtol+0xe4>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 7a                	cmp    $0x7a,%al
  80145b:	7f 10                	jg     80146d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	0f be c0             	movsbl %al,%eax
  801465:	83 e8 57             	sub    $0x57,%eax
  801468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80146b:	eb 20                	jmp    80148d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 40                	cmp    $0x40,%al
  801474:	7e 39                	jle    8014af <strtol+0x126>
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 5a                	cmp    $0x5a,%al
  80147d:	7f 30                	jg     8014af <strtol+0x126>
			dig = *s - 'A' + 10;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	0f be c0             	movsbl %al,%eax
  801487:	83 e8 37             	sub    $0x37,%eax
  80148a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80148d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801490:	3b 45 10             	cmp    0x10(%ebp),%eax
  801493:	7d 19                	jge    8014ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801495:	ff 45 08             	incl   0x8(%ebp)
  801498:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80149f:	89 c2                	mov    %eax,%edx
  8014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a4:	01 d0                	add    %edx,%eax
  8014a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014a9:	e9 7b ff ff ff       	jmp    801429 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014b3:	74 08                	je     8014bd <strtol+0x134>
		*endptr = (char *) s;
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014c1:	74 07                	je     8014ca <strtol+0x141>
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	f7 d8                	neg    %eax
  8014c8:	eb 03                	jmp    8014cd <strtol+0x144>
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <ltostr>:

void
ltostr(long value, char *str)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e7:	79 13                	jns    8014fc <ltostr+0x2d>
	{
		neg = 1;
  8014e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801504:	99                   	cltd   
  801505:	f7 f9                	idiv   %ecx
  801507:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80150a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150d:	8d 50 01             	lea    0x1(%eax),%edx
  801510:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801513:	89 c2                	mov    %eax,%edx
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151d:	83 c2 30             	add    $0x30,%edx
  801520:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801522:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801525:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80152a:	f7 e9                	imul   %ecx
  80152c:	c1 fa 02             	sar    $0x2,%edx
  80152f:	89 c8                	mov    %ecx,%eax
  801531:	c1 f8 1f             	sar    $0x1f,%eax
  801534:	29 c2                	sub    %eax,%edx
  801536:	89 d0                	mov    %edx,%eax
  801538:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80153b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801543:	f7 e9                	imul   %ecx
  801545:	c1 fa 02             	sar    $0x2,%edx
  801548:	89 c8                	mov    %ecx,%eax
  80154a:	c1 f8 1f             	sar    $0x1f,%eax
  80154d:	29 c2                	sub    %eax,%edx
  80154f:	89 d0                	mov    %edx,%eax
  801551:	c1 e0 02             	shl    $0x2,%eax
  801554:	01 d0                	add    %edx,%eax
  801556:	01 c0                	add    %eax,%eax
  801558:	29 c1                	sub    %eax,%ecx
  80155a:	89 ca                	mov    %ecx,%edx
  80155c:	85 d2                	test   %edx,%edx
  80155e:	75 9c                	jne    8014fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80156e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801572:	74 3d                	je     8015b1 <ltostr+0xe2>
		start = 1 ;
  801574:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80157b:	eb 34                	jmp    8015b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80157d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	01 c2                	add    %eax,%edx
  801592:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801595:	8b 45 0c             	mov    0xc(%ebp),%eax
  801598:	01 c8                	add    %ecx,%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80159e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	01 c2                	add    %eax,%edx
  8015a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8015ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b7:	7c c4                	jl     80157d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	01 d0                	add    %edx,%eax
  8015c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 54 fa ff ff       	call   801029 <strlen>
  8015d5:	83 c4 04             	add    $0x4,%esp
  8015d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015db:	ff 75 0c             	pushl  0xc(%ebp)
  8015de:	e8 46 fa ff ff       	call   801029 <strlen>
  8015e3:	83 c4 04             	add    $0x4,%esp
  8015e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015f7:	eb 17                	jmp    801610 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	01 c2                	add    %eax,%edx
  801601:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	01 c8                	add    %ecx,%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80160d:	ff 45 fc             	incl   -0x4(%ebp)
  801610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801613:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801616:	7c e1                	jl     8015f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801618:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80161f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801626:	eb 1f                	jmp    801647 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162b:	8d 50 01             	lea    0x1(%eax),%edx
  80162e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801631:	89 c2                	mov    %eax,%edx
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	01 c2                	add    %eax,%edx
  801638:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	01 c8                	add    %ecx,%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801644:	ff 45 f8             	incl   -0x8(%ebp)
  801647:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164d:	7c d9                	jl     801628 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80164f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801652:	8b 45 10             	mov    0x10(%ebp),%eax
  801655:	01 d0                	add    %edx,%eax
  801657:	c6 00 00             	movb   $0x0,(%eax)
}
  80165a:	90                   	nop
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801660:	8b 45 14             	mov    0x14(%ebp),%eax
  801663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801669:	8b 45 14             	mov    0x14(%ebp),%eax
  80166c:	8b 00                	mov    (%eax),%eax
  80166e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801675:	8b 45 10             	mov    0x10(%ebp),%eax
  801678:	01 d0                	add    %edx,%eax
  80167a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801680:	eb 0c                	jmp    80168e <strsplit+0x31>
			*string++ = 0;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8d 50 01             	lea    0x1(%eax),%edx
  801688:	89 55 08             	mov    %edx,0x8(%ebp)
  80168b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	84 c0                	test   %al,%al
  801695:	74 18                	je     8016af <strsplit+0x52>
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	0f be c0             	movsbl %al,%eax
  80169f:	50                   	push   %eax
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	e8 13 fb ff ff       	call   8011bb <strchr>
  8016a8:	83 c4 08             	add    $0x8,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	75 d3                	jne    801682 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	84 c0                	test   %al,%al
  8016b6:	74 5a                	je     801712 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bb:	8b 00                	mov    (%eax),%eax
  8016bd:	83 f8 0f             	cmp    $0xf,%eax
  8016c0:	75 07                	jne    8016c9 <strsplit+0x6c>
		{
			return 0;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c7:	eb 66                	jmp    80172f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8016d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8016d4:	89 0a                	mov    %ecx,(%edx)
  8016d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	01 c2                	add    %eax,%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016e7:	eb 03                	jmp    8016ec <strsplit+0x8f>
			string++;
  8016e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	84 c0                	test   %al,%al
  8016f3:	74 8b                	je     801680 <strsplit+0x23>
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f be c0             	movsbl %al,%eax
  8016fd:	50                   	push   %eax
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	e8 b5 fa ff ff       	call   8011bb <strchr>
  801706:	83 c4 08             	add    $0x8,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	74 dc                	je     8016e9 <strsplit+0x8c>
			string++;
	}
  80170d:	e9 6e ff ff ff       	jmp    801680 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801712:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801713:	8b 45 14             	mov    0x14(%ebp),%eax
  801716:	8b 00                	mov    (%eax),%eax
  801718:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171f:	8b 45 10             	mov    0x10(%ebp),%eax
  801722:	01 d0                	add    %edx,%eax
  801724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80172a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801737:	a1 28 30 80 00       	mov    0x803028,%eax
  80173c:	85 c0                	test   %eax,%eax
  80173e:	75 33                	jne    801773 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801740:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  801747:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  80174a:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801751:	00 00 a0 
		spaces[0].pages = numPages;
  801754:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  80175b:	00 02 00 
		spaces[0].isFree = 1;
  80175e:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801765:	00 00 00 
		arraySize++;
  801768:	a1 28 30 80 00       	mov    0x803028,%eax
  80176d:	40                   	inc    %eax
  80176e:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801773:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  80177a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801781:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801788:	8b 55 08             	mov    0x8(%ebp),%edx
  80178b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178e:	01 d0                	add    %edx,%eax
  801790:	48                   	dec    %eax
  801791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	f7 75 e8             	divl   -0x18(%ebp)
  80179f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a2:	29 d0                	sub    %edx,%eax
  8017a4:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	c1 e8 0c             	shr    $0xc,%eax
  8017ad:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8017b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017b7:	eb 57                	jmp    801810 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8017b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bc:	c1 e0 04             	shl    $0x4,%eax
  8017bf:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017c4:	8b 00                	mov    (%eax),%eax
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	74 42                	je     80180c <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8017ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cd:	c1 e0 04             	shl    $0x4,%eax
  8017d0:	05 28 31 80 00       	add    $0x803128,%eax
  8017d5:	8b 00                	mov    (%eax),%eax
  8017d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8017da:	7c 31                	jl     80180d <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8017dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017df:	c1 e0 04             	shl    $0x4,%eax
  8017e2:	05 28 31 80 00       	add    $0x803128,%eax
  8017e7:	8b 00                	mov    (%eax),%eax
  8017e9:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8017ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8017ef:	7d 1c                	jge    80180d <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  8017f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f4:	c1 e0 04             	shl    $0x4,%eax
  8017f7:	05 28 31 80 00       	add    $0x803128,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801801:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80180a:	eb 01                	jmp    80180d <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80180c:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  80180d:	ff 45 ec             	incl   -0x14(%ebp)
  801810:	a1 28 30 80 00       	mov    0x803028,%eax
  801815:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801818:	7c 9f                	jl     8017b9 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  80181a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80181e:	75 0a                	jne    80182a <malloc+0xf9>
	{
		return NULL;
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	e9 34 01 00 00       	jmp    80195e <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  80182a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182d:	c1 e0 04             	shl    $0x4,%eax
  801830:	05 28 31 80 00       	add    $0x803128,%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80183a:	75 38                	jne    801874 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  80183c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183f:	c1 e0 04             	shl    $0x4,%eax
  801842:	05 2c 31 80 00       	add    $0x80312c,%eax
  801847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  80184d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801850:	c1 e0 0c             	shl    $0xc,%eax
  801853:	89 c2                	mov    %eax,%edx
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801858:	c1 e0 04             	shl    $0x4,%eax
  80185b:	05 20 31 80 00       	add    $0x803120,%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	52                   	push   %edx
  801866:	50                   	push   %eax
  801867:	e8 01 06 00 00       	call   801e6d <sys_allocateMem>
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	e9 dd 00 00 00       	jmp    801951 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801877:	c1 e0 04             	shl    $0x4,%eax
  80187a:	05 20 31 80 00       	add    $0x803120,%eax
  80187f:	8b 00                	mov    (%eax),%eax
  801881:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801884:	c1 e2 0c             	shl    $0xc,%edx
  801887:	01 d0                	add    %edx,%eax
  801889:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  80188c:	a1 28 30 80 00       	mov    0x803028,%eax
  801891:	c1 e0 04             	shl    $0x4,%eax
  801894:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  80189a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80189d:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  80189f:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a8:	c1 e0 04             	shl    $0x4,%eax
  8018ab:	05 24 31 80 00       	add    $0x803124,%eax
  8018b0:	8b 00                	mov    (%eax),%eax
  8018b2:	c1 e2 04             	shl    $0x4,%edx
  8018b5:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8018bb:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8018bd:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c6:	c1 e0 04             	shl    $0x4,%eax
  8018c9:	05 28 31 80 00       	add    $0x803128,%eax
  8018ce:	8b 00                	mov    (%eax),%eax
  8018d0:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8018d3:	c1 e2 04             	shl    $0x4,%edx
  8018d6:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8018dc:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  8018de:	a1 28 30 80 00       	mov    0x803028,%eax
  8018e3:	c1 e0 04             	shl    $0x4,%eax
  8018e6:	05 2c 31 80 00       	add    $0x80312c,%eax
  8018eb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  8018f1:	a1 28 30 80 00       	mov    0x803028,%eax
  8018f6:	40                   	inc    %eax
  8018f7:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ff:	c1 e0 04             	shl    $0x4,%eax
  801902:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  801908:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80190b:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  80190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801910:	c1 e0 04             	shl    $0x4,%eax
  801913:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  801919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191c:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  80191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801921:	c1 e0 04             	shl    $0x4,%eax
  801924:	05 2c 31 80 00       	add    $0x80312c,%eax
  801929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  80192f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801932:	c1 e0 0c             	shl    $0xc,%eax
  801935:	89 c2                	mov    %eax,%edx
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193a:	c1 e0 04             	shl    $0x4,%eax
  80193d:	05 20 31 80 00       	add    $0x803120,%eax
  801942:	8b 00                	mov    (%eax),%eax
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	e8 1f 05 00 00       	call   801e6d <sys_allocateMem>
  80194e:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	c1 e0 04             	shl    $0x4,%eax
  801957:	05 20 31 80 00       	add    $0x803120,%eax
  80195c:	8b 00                	mov    (%eax),%eax
	}


}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801966:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  80196d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801974:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80197b:	eb 3f                	jmp    8019bc <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  80197d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801980:	c1 e0 04             	shl    $0x4,%eax
  801983:	05 20 31 80 00       	add    $0x803120,%eax
  801988:	8b 00                	mov    (%eax),%eax
  80198a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80198d:	75 2a                	jne    8019b9 <free+0x59>
		{
			index=i;
  80198f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801992:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801998:	c1 e0 04             	shl    $0x4,%eax
  80199b:	05 28 31 80 00       	add    $0x803128,%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	c1 e0 0c             	shl    $0xc,%eax
  8019a5:	89 c2                	mov    %eax,%edx
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	52                   	push   %edx
  8019ae:	50                   	push   %eax
  8019af:	e8 9d 04 00 00       	call   801e51 <sys_freeMem>
  8019b4:	83 c4 10             	add    $0x10,%esp
			break;
  8019b7:	eb 0d                	jmp    8019c6 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8019b9:	ff 45 ec             	incl   -0x14(%ebp)
  8019bc:	a1 28 30 80 00       	mov    0x803028,%eax
  8019c1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8019c4:	7c b7                	jl     80197d <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8019c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8019ca:	75 17                	jne    8019e3 <free+0x83>
	{
		panic("Error");
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 90 2b 80 00       	push   $0x802b90
  8019d4:	68 81 00 00 00       	push   $0x81
  8019d9:	68 96 2b 80 00       	push   $0x802b96
  8019de:	e8 14 09 00 00       	call   8022f7 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  8019e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019ea:	e9 cc 00 00 00       	jmp    801abb <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  8019ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f2:	c1 e0 04             	shl    $0x4,%eax
  8019f5:	05 2c 31 80 00       	add    $0x80312c,%eax
  8019fa:	8b 00                	mov    (%eax),%eax
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	0f 84 b3 00 00 00    	je     801ab7 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a07:	c1 e0 04             	shl    $0x4,%eax
  801a0a:	05 20 31 80 00       	add    $0x803120,%eax
  801a0f:	8b 10                	mov    (%eax),%edx
  801a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a14:	c1 e0 04             	shl    $0x4,%eax
  801a17:	05 24 31 80 00       	add    $0x803124,%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	39 c2                	cmp    %eax,%edx
  801a20:	0f 85 92 00 00 00    	jne    801ab8 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a29:	c1 e0 04             	shl    $0x4,%eax
  801a2c:	05 24 31 80 00       	add    $0x803124,%eax
  801a31:	8b 00                	mov    (%eax),%eax
  801a33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a36:	c1 e2 04             	shl    $0x4,%edx
  801a39:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801a3f:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a44:	c1 e0 04             	shl    $0x4,%eax
  801a47:	05 28 31 80 00       	add    $0x803128,%eax
  801a4c:	8b 10                	mov    (%eax),%edx
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	c1 e0 04             	shl    $0x4,%eax
  801a54:	05 28 31 80 00       	add    $0x803128,%eax
  801a59:	8b 00                	mov    (%eax),%eax
  801a5b:	01 c2                	add    %eax,%edx
  801a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a60:	c1 e0 04             	shl    $0x4,%eax
  801a63:	05 28 31 80 00       	add    $0x803128,%eax
  801a68:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	c1 e0 04             	shl    $0x4,%eax
  801a70:	05 20 31 80 00       	add    $0x803120,%eax
  801a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7e:	c1 e0 04             	shl    $0x4,%eax
  801a81:	05 24 31 80 00       	add    $0x803124,%eax
  801a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8f:	c1 e0 04             	shl    $0x4,%eax
  801a92:	05 28 31 80 00       	add    $0x803128,%eax
  801a97:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa0:	c1 e0 04             	shl    $0x4,%eax
  801aa3:	05 2c 31 80 00       	add    $0x80312c,%eax
  801aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801aae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801ab5:	eb 12                	jmp    801ac9 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801ab7:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ab8:	ff 45 e8             	incl   -0x18(%ebp)
  801abb:	a1 28 30 80 00       	mov    0x803028,%eax
  801ac0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801ac3:	0f 8c 26 ff ff ff    	jl     8019ef <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ac9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801ad0:	e9 cc 00 00 00       	jmp    801ba1 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad8:	c1 e0 04             	shl    $0x4,%eax
  801adb:	05 2c 31 80 00       	add    $0x80312c,%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	0f 84 b3 00 00 00    	je     801b9d <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aed:	c1 e0 04             	shl    $0x4,%eax
  801af0:	05 24 31 80 00       	add    $0x803124,%eax
  801af5:	8b 10                	mov    (%eax),%edx
  801af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801afa:	c1 e0 04             	shl    $0x4,%eax
  801afd:	05 20 31 80 00       	add    $0x803120,%eax
  801b02:	8b 00                	mov    (%eax),%eax
  801b04:	39 c2                	cmp    %eax,%edx
  801b06:	0f 85 92 00 00 00    	jne    801b9e <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0f:	c1 e0 04             	shl    $0x4,%eax
  801b12:	05 20 31 80 00       	add    $0x803120,%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b1c:	c1 e2 04             	shl    $0x4,%edx
  801b1f:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801b25:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2a:	c1 e0 04             	shl    $0x4,%eax
  801b2d:	05 28 31 80 00       	add    $0x803128,%eax
  801b32:	8b 10                	mov    (%eax),%edx
  801b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b37:	c1 e0 04             	shl    $0x4,%eax
  801b3a:	05 28 31 80 00       	add    $0x803128,%eax
  801b3f:	8b 00                	mov    (%eax),%eax
  801b41:	01 c2                	add    %eax,%edx
  801b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b46:	c1 e0 04             	shl    $0x4,%eax
  801b49:	05 28 31 80 00       	add    $0x803128,%eax
  801b4e:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b53:	c1 e0 04             	shl    $0x4,%eax
  801b56:	05 20 31 80 00       	add    $0x803120,%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b64:	c1 e0 04             	shl    $0x4,%eax
  801b67:	05 24 31 80 00       	add    $0x803124,%eax
  801b6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	c1 e0 04             	shl    $0x4,%eax
  801b78:	05 28 31 80 00       	add    $0x803128,%eax
  801b7d:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	c1 e0 04             	shl    $0x4,%eax
  801b89:	05 2c 31 80 00       	add    $0x80312c,%eax
  801b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801b94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801b9b:	eb 12                	jmp    801baf <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801b9d:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801b9e:	ff 45 e4             	incl   -0x1c(%ebp)
  801ba1:	a1 28 30 80 00       	mov    0x803028,%eax
  801ba6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba9:	0f 8c 26 ff ff ff    	jl     801ad5 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801baf:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801bb3:	75 11                	jne    801bc6 <free+0x266>
	{
		spaces[index].isFree = 1;
  801bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb8:	c1 e0 04             	shl    $0x4,%eax
  801bbb:	05 2c 31 80 00       	add    $0x80312c,%eax
  801bc0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801bc6:	90                   	nop
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 18             	sub    $0x18,%esp
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	68 a4 2b 80 00       	push   $0x802ba4
  801bdd:	68 b9 00 00 00       	push   $0xb9
  801be2:	68 96 2b 80 00       	push   $0x802b96
  801be7:	e8 0b 07 00 00       	call   8022f7 <_panic>

00801bec <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 a4 2b 80 00       	push   $0x802ba4
  801bfa:	68 bf 00 00 00       	push   $0xbf
  801bff:	68 96 2b 80 00       	push   $0x802b96
  801c04:	e8 ee 06 00 00       	call   8022f7 <_panic>

00801c09 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 a4 2b 80 00       	push   $0x802ba4
  801c17:	68 c5 00 00 00       	push   $0xc5
  801c1c:	68 96 2b 80 00       	push   $0x802b96
  801c21:	e8 d1 06 00 00       	call   8022f7 <_panic>

00801c26 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	68 a4 2b 80 00       	push   $0x802ba4
  801c34:	68 ca 00 00 00       	push   $0xca
  801c39:	68 96 2b 80 00       	push   $0x802b96
  801c3e:	e8 b4 06 00 00       	call   8022f7 <_panic>

00801c43 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	68 a4 2b 80 00       	push   $0x802ba4
  801c51:	68 d0 00 00 00       	push   $0xd0
  801c56:	68 96 2b 80 00       	push   $0x802b96
  801c5b:	e8 97 06 00 00       	call   8022f7 <_panic>

00801c60 <shrink>:
}
void shrink(uint32 newSize)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	68 a4 2b 80 00       	push   $0x802ba4
  801c6e:	68 d4 00 00 00       	push   $0xd4
  801c73:	68 96 2b 80 00       	push   $0x802b96
  801c78:	e8 7a 06 00 00       	call   8022f7 <_panic>

00801c7d <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	68 a4 2b 80 00       	push   $0x802ba4
  801c8b:	68 d9 00 00 00       	push   $0xd9
  801c90:	68 96 2b 80 00       	push   $0x802b96
  801c95:	e8 5d 06 00 00       	call   8022f7 <_panic>

00801c9a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801caf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cb2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb5:	cd 30                	int    $0x30
  801cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5f                   	pop    %edi
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    

00801cc5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cd1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	52                   	push   %edx
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	e8 b2 ff ff ff       	call   801c9a <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	90                   	nop
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_cgetc>:

int
sys_cgetc(void)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 01                	push   $0x1
  801cfd:	e8 98 ff ff ff       	call   801c9a <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	50                   	push   %eax
  801d16:	6a 05                	push   $0x5
  801d18:	e8 7d ff ff ff       	call   801c9a <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 02                	push   $0x2
  801d31:	e8 64 ff ff ff       	call   801c9a <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 03                	push   $0x3
  801d4a:	e8 4b ff ff ff       	call   801c9a <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 04                	push   $0x4
  801d63:	e8 32 ff ff ff       	call   801c9a <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_env_exit>:


void sys_env_exit(void)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 06                	push   $0x6
  801d7c:	e8 19 ff ff ff       	call   801c9a <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	90                   	nop
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	6a 07                	push   $0x7
  801d9a:	e8 fb fe ff ff       	call   801c9a <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801da9:	8b 75 18             	mov    0x18(%ebp),%esi
  801dac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801daf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	56                   	push   %esi
  801db9:	53                   	push   %ebx
  801dba:	51                   	push   %ecx
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 08                	push   $0x8
  801dbf:	e8 d6 fe ff ff       	call   801c9a <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dca:	5b                   	pop    %ebx
  801dcb:	5e                   	pop    %esi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	52                   	push   %edx
  801dde:	50                   	push   %eax
  801ddf:	6a 09                	push   $0x9
  801de1:	e8 b4 fe ff ff       	call   801c9a <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 0c             	pushl  0xc(%ebp)
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	6a 0a                	push   $0xa
  801dfc:	e8 99 fe ff ff       	call   801c9a <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 0b                	push   $0xb
  801e15:	e8 80 fe ff ff       	call   801c9a <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 0c                	push   $0xc
  801e2e:	e8 67 fe ff ff       	call   801c9a <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 0d                	push   $0xd
  801e47:	e8 4e fe ff ff       	call   801c9a <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	6a 11                	push   $0x11
  801e62:	e8 33 fe ff ff       	call   801c9a <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
	return;
  801e6a:	90                   	nop
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	ff 75 0c             	pushl  0xc(%ebp)
  801e79:	ff 75 08             	pushl  0x8(%ebp)
  801e7c:	6a 12                	push   $0x12
  801e7e:	e8 17 fe ff ff       	call   801c9a <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
	return ;
  801e86:	90                   	nop
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 0e                	push   $0xe
  801e98:	e8 fd fd ff ff       	call   801c9a <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	ff 75 08             	pushl  0x8(%ebp)
  801eb0:	6a 0f                	push   $0xf
  801eb2:	e8 e3 fd ff ff       	call   801c9a <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 10                	push   $0x10
  801ecb:	e8 ca fd ff ff       	call   801c9a <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
}
  801ed3:	90                   	nop
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 14                	push   $0x14
  801ee5:	e8 b0 fd ff ff       	call   801c9a <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	90                   	nop
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 15                	push   $0x15
  801eff:	e8 96 fd ff ff       	call   801c9a <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_cputc>:


void
sys_cputc(const char c)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	50                   	push   %eax
  801f23:	6a 16                	push   $0x16
  801f25:	e8 70 fd ff ff       	call   801c9a <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	90                   	nop
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 17                	push   $0x17
  801f3f:	e8 56 fd ff ff       	call   801c9a <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	90                   	nop
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	ff 75 0c             	pushl  0xc(%ebp)
  801f59:	50                   	push   %eax
  801f5a:	6a 18                	push   $0x18
  801f5c:	e8 39 fd ff ff       	call   801c9a <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	52                   	push   %edx
  801f76:	50                   	push   %eax
  801f77:	6a 1b                	push   $0x1b
  801f79:	e8 1c fd ff ff       	call   801c9a <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	52                   	push   %edx
  801f93:	50                   	push   %eax
  801f94:	6a 19                	push   $0x19
  801f96:	e8 ff fc ff ff       	call   801c9a <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
}
  801f9e:	90                   	nop
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	52                   	push   %edx
  801fb1:	50                   	push   %eax
  801fb2:	6a 1a                	push   $0x1a
  801fb4:	e8 e1 fc ff ff       	call   801c9a <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	90                   	nop
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 04             	sub    $0x4,%esp
  801fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fcb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	6a 00                	push   $0x0
  801fd7:	51                   	push   %ecx
  801fd8:	52                   	push   %edx
  801fd9:	ff 75 0c             	pushl  0xc(%ebp)
  801fdc:	50                   	push   %eax
  801fdd:	6a 1c                	push   $0x1c
  801fdf:	e8 b6 fc ff ff       	call   801c9a <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	52                   	push   %edx
  801ff9:	50                   	push   %eax
  801ffa:	6a 1d                	push   $0x1d
  801ffc:	e8 99 fc ff ff       	call   801c9a <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802009:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	51                   	push   %ecx
  802017:	52                   	push   %edx
  802018:	50                   	push   %eax
  802019:	6a 1e                	push   $0x1e
  80201b:	e8 7a fc ff ff       	call   801c9a <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	6a 1f                	push   $0x1f
  802038:	e8 5d fc ff ff       	call   801c9a <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 20                	push   $0x20
  802051:	e8 44 fc ff ff       	call   801c9a <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	ff 75 14             	pushl  0x14(%ebp)
  802066:	ff 75 10             	pushl  0x10(%ebp)
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	50                   	push   %eax
  80206d:	6a 21                	push   $0x21
  80206f:	e8 26 fc ff ff       	call   801c9a <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	50                   	push   %eax
  802088:	6a 22                	push   $0x22
  80208a:	e8 0b fc ff ff       	call   801c9a <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	50                   	push   %eax
  8020a4:	6a 23                	push   $0x23
  8020a6:	e8 ef fb ff ff       	call   801c9a <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	90                   	nop
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ba:	8d 50 04             	lea    0x4(%eax),%edx
  8020bd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	52                   	push   %edx
  8020c7:	50                   	push   %eax
  8020c8:	6a 24                	push   $0x24
  8020ca:	e8 cb fb ff ff       	call   801c9a <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
	return result;
  8020d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020db:	89 01                	mov    %eax,(%ecx)
  8020dd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	c9                   	leave  
  8020e4:	c2 04 00             	ret    $0x4

008020e7 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	ff 75 10             	pushl  0x10(%ebp)
  8020f1:	ff 75 0c             	pushl  0xc(%ebp)
  8020f4:	ff 75 08             	pushl  0x8(%ebp)
  8020f7:	6a 13                	push   $0x13
  8020f9:	e8 9c fb ff ff       	call   801c9a <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802101:	90                   	nop
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_rcr2>:
uint32 sys_rcr2()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 25                	push   $0x25
  802113:	e8 82 fb ff ff       	call   801c9a <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802129:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	50                   	push   %eax
  802136:	6a 26                	push   $0x26
  802138:	e8 5d fb ff ff       	call   801c9a <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
	return ;
  802140:	90                   	nop
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <rsttst>:
void rsttst()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 28                	push   $0x28
  802152:	e8 43 fb ff ff       	call   801c9a <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
	return ;
  80215a:	90                   	nop
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	8b 45 14             	mov    0x14(%ebp),%eax
  802166:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802169:	8b 55 18             	mov    0x18(%ebp),%edx
  80216c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	ff 75 10             	pushl  0x10(%ebp)
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	6a 27                	push   $0x27
  80217d:	e8 18 fb ff ff       	call   801c9a <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
	return ;
  802185:	90                   	nop
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <chktst>:
void chktst(uint32 n)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	ff 75 08             	pushl  0x8(%ebp)
  802196:	6a 29                	push   $0x29
  802198:	e8 fd fa ff ff       	call   801c9a <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a0:	90                   	nop
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <inctst>:

void inctst()
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 2a                	push   $0x2a
  8021b2:	e8 e3 fa ff ff       	call   801c9a <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ba:	90                   	nop
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <gettst>:
uint32 gettst()
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 2b                	push   $0x2b
  8021cc:	e8 c9 fa ff ff       	call   801c9a <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 2c                	push   $0x2c
  8021e8:	e8 ad fa ff ff       	call   801c9a <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
  8021f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021f3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021f7:	75 07                	jne    802200 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fe:	eb 05                	jmp    802205 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 2c                	push   $0x2c
  802219:	e8 7c fa ff ff       	call   801c9a <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
  802221:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802224:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802228:	75 07                	jne    802231 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80222a:	b8 01 00 00 00       	mov    $0x1,%eax
  80222f:	eb 05                	jmp    802236 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802231:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 2c                	push   $0x2c
  80224a:	e8 4b fa ff ff       	call   801c9a <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
  802252:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802255:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802259:	75 07                	jne    802262 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80225b:	b8 01 00 00 00       	mov    $0x1,%eax
  802260:	eb 05                	jmp    802267 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 2c                	push   $0x2c
  80227b:	e8 1a fa ff ff       	call   801c9a <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
  802283:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802286:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80228a:	75 07                	jne    802293 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80228c:	b8 01 00 00 00       	mov    $0x1,%eax
  802291:	eb 05                	jmp    802298 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	ff 75 08             	pushl  0x8(%ebp)
  8022a8:	6a 2d                	push   $0x2d
  8022aa:	e8 eb f9 ff ff       	call   801c9a <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b2:	90                   	nop
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	6a 00                	push   $0x0
  8022c7:	53                   	push   %ebx
  8022c8:	51                   	push   %ecx
  8022c9:	52                   	push   %edx
  8022ca:	50                   	push   %eax
  8022cb:	6a 2e                	push   $0x2e
  8022cd:	e8 c8 f9 ff ff       	call   801c9a <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
}
  8022d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	52                   	push   %edx
  8022ea:	50                   	push   %eax
  8022eb:	6a 2f                	push   $0x2f
  8022ed:	e8 a8 f9 ff ff       	call   801c9a <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8022fd:	8d 45 10             	lea    0x10(%ebp),%eax
  802300:	83 c0 04             	add    $0x4,%eax
  802303:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802306:	a1 20 31 a0 00       	mov    0xa03120,%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 16                	je     802325 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80230f:	a1 20 31 a0 00       	mov    0xa03120,%eax
  802314:	83 ec 08             	sub    $0x8,%esp
  802317:	50                   	push   %eax
  802318:	68 c8 2b 80 00       	push   $0x802bc8
  80231d:	e8 85 e6 ff ff       	call   8009a7 <cprintf>
  802322:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802325:	a1 00 30 80 00       	mov    0x803000,%eax
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	50                   	push   %eax
  802331:	68 cd 2b 80 00       	push   $0x802bcd
  802336:	e8 6c e6 ff ff       	call   8009a7 <cprintf>
  80233b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80233e:	8b 45 10             	mov    0x10(%ebp),%eax
  802341:	83 ec 08             	sub    $0x8,%esp
  802344:	ff 75 f4             	pushl  -0xc(%ebp)
  802347:	50                   	push   %eax
  802348:	e8 ef e5 ff ff       	call   80093c <vcprintf>
  80234d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802350:	83 ec 08             	sub    $0x8,%esp
  802353:	6a 00                	push   $0x0
  802355:	68 e9 2b 80 00       	push   $0x802be9
  80235a:	e8 dd e5 ff ff       	call   80093c <vcprintf>
  80235f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802362:	e8 5e e5 ff ff       	call   8008c5 <exit>

	// should not return here
	while (1) ;
  802367:	eb fe                	jmp    802367 <_panic+0x70>

00802369 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80236f:	a1 20 30 80 00       	mov    0x803020,%eax
  802374:	8b 50 74             	mov    0x74(%eax),%edx
  802377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237a:	39 c2                	cmp    %eax,%edx
  80237c:	74 14                	je     802392 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	68 ec 2b 80 00       	push   $0x802bec
  802386:	6a 26                	push   $0x26
  802388:	68 38 2c 80 00       	push   $0x802c38
  80238d:	e8 65 ff ff ff       	call   8022f7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802399:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023a0:	e9 b6 00 00 00       	jmp    80245b <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8023a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	01 d0                	add    %edx,%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	75 08                	jne    8023c2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8023ba:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8023bd:	e9 96 00 00 00       	jmp    802458 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8023c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8023c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023d0:	eb 5d                	jmp    80242f <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8023d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8023d7:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8023dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e0:	c1 e2 04             	shl    $0x4,%edx
  8023e3:	01 d0                	add    %edx,%eax
  8023e5:	8a 40 04             	mov    0x4(%eax),%al
  8023e8:	84 c0                	test   %al,%al
  8023ea:	75 40                	jne    80242c <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8023ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8023f1:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8023f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023fa:	c1 e2 04             	shl    $0x4,%edx
  8023fd:	01 d0                	add    %edx,%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802404:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802407:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80240c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	01 c8                	add    %ecx,%eax
  80241d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80241f:	39 c2                	cmp    %eax,%edx
  802421:	75 09                	jne    80242c <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  802423:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80242a:	eb 12                	jmp    80243e <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80242c:	ff 45 e8             	incl   -0x18(%ebp)
  80242f:	a1 20 30 80 00       	mov    0x803020,%eax
  802434:	8b 50 74             	mov    0x74(%eax),%edx
  802437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80243a:	39 c2                	cmp    %eax,%edx
  80243c:	77 94                	ja     8023d2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80243e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802442:	75 14                	jne    802458 <CheckWSWithoutLastIndex+0xef>
			panic(
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 44 2c 80 00       	push   $0x802c44
  80244c:	6a 3a                	push   $0x3a
  80244e:	68 38 2c 80 00       	push   $0x802c38
  802453:	e8 9f fe ff ff       	call   8022f7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802458:	ff 45 f0             	incl   -0x10(%ebp)
  80245b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802461:	0f 8c 3e ff ff ff    	jl     8023a5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80246e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802475:	eb 20                	jmp    802497 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802477:	a1 20 30 80 00       	mov    0x803020,%eax
  80247c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  802482:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802485:	c1 e2 04             	shl    $0x4,%edx
  802488:	01 d0                	add    %edx,%eax
  80248a:	8a 40 04             	mov    0x4(%eax),%al
  80248d:	3c 01                	cmp    $0x1,%al
  80248f:	75 03                	jne    802494 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  802491:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802494:	ff 45 e0             	incl   -0x20(%ebp)
  802497:	a1 20 30 80 00       	mov    0x803020,%eax
  80249c:	8b 50 74             	mov    0x74(%eax),%edx
  80249f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a2:	39 c2                	cmp    %eax,%edx
  8024a4:	77 d1                	ja     802477 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8024ac:	74 14                	je     8024c2 <CheckWSWithoutLastIndex+0x159>
		panic(
  8024ae:	83 ec 04             	sub    $0x4,%esp
  8024b1:	68 98 2c 80 00       	push   $0x802c98
  8024b6:	6a 44                	push   $0x44
  8024b8:	68 38 2c 80 00       	push   $0x802c38
  8024bd:	e8 35 fe ff ff       	call   8022f7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8024c2:	90                   	nop
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    
  8024c5:	66 90                	xchg   %ax,%ax
  8024c7:	90                   	nop

008024c8 <__udivdi3>:
  8024c8:	55                   	push   %ebp
  8024c9:	57                   	push   %edi
  8024ca:	56                   	push   %esi
  8024cb:	53                   	push   %ebx
  8024cc:	83 ec 1c             	sub    $0x1c,%esp
  8024cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8024d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8024d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024df:	89 ca                	mov    %ecx,%edx
  8024e1:	89 f8                	mov    %edi,%eax
  8024e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8024e7:	85 f6                	test   %esi,%esi
  8024e9:	75 2d                	jne    802518 <__udivdi3+0x50>
  8024eb:	39 cf                	cmp    %ecx,%edi
  8024ed:	77 65                	ja     802554 <__udivdi3+0x8c>
  8024ef:	89 fd                	mov    %edi,%ebp
  8024f1:	85 ff                	test   %edi,%edi
  8024f3:	75 0b                	jne    802500 <__udivdi3+0x38>
  8024f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fa:	31 d2                	xor    %edx,%edx
  8024fc:	f7 f7                	div    %edi
  8024fe:	89 c5                	mov    %eax,%ebp
  802500:	31 d2                	xor    %edx,%edx
  802502:	89 c8                	mov    %ecx,%eax
  802504:	f7 f5                	div    %ebp
  802506:	89 c1                	mov    %eax,%ecx
  802508:	89 d8                	mov    %ebx,%eax
  80250a:	f7 f5                	div    %ebp
  80250c:	89 cf                	mov    %ecx,%edi
  80250e:	89 fa                	mov    %edi,%edx
  802510:	83 c4 1c             	add    $0x1c,%esp
  802513:	5b                   	pop    %ebx
  802514:	5e                   	pop    %esi
  802515:	5f                   	pop    %edi
  802516:	5d                   	pop    %ebp
  802517:	c3                   	ret    
  802518:	39 ce                	cmp    %ecx,%esi
  80251a:	77 28                	ja     802544 <__udivdi3+0x7c>
  80251c:	0f bd fe             	bsr    %esi,%edi
  80251f:	83 f7 1f             	xor    $0x1f,%edi
  802522:	75 40                	jne    802564 <__udivdi3+0x9c>
  802524:	39 ce                	cmp    %ecx,%esi
  802526:	72 0a                	jb     802532 <__udivdi3+0x6a>
  802528:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80252c:	0f 87 9e 00 00 00    	ja     8025d0 <__udivdi3+0x108>
  802532:	b8 01 00 00 00       	mov    $0x1,%eax
  802537:	89 fa                	mov    %edi,%edx
  802539:	83 c4 1c             	add    $0x1c,%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
  802541:	8d 76 00             	lea    0x0(%esi),%esi
  802544:	31 ff                	xor    %edi,%edi
  802546:	31 c0                	xor    %eax,%eax
  802548:	89 fa                	mov    %edi,%edx
  80254a:	83 c4 1c             	add    $0x1c,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    
  802552:	66 90                	xchg   %ax,%ax
  802554:	89 d8                	mov    %ebx,%eax
  802556:	f7 f7                	div    %edi
  802558:	31 ff                	xor    %edi,%edi
  80255a:	89 fa                	mov    %edi,%edx
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	bd 20 00 00 00       	mov    $0x20,%ebp
  802569:	89 eb                	mov    %ebp,%ebx
  80256b:	29 fb                	sub    %edi,%ebx
  80256d:	89 f9                	mov    %edi,%ecx
  80256f:	d3 e6                	shl    %cl,%esi
  802571:	89 c5                	mov    %eax,%ebp
  802573:	88 d9                	mov    %bl,%cl
  802575:	d3 ed                	shr    %cl,%ebp
  802577:	89 e9                	mov    %ebp,%ecx
  802579:	09 f1                	or     %esi,%ecx
  80257b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80257f:	89 f9                	mov    %edi,%ecx
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 c5                	mov    %eax,%ebp
  802585:	89 d6                	mov    %edx,%esi
  802587:	88 d9                	mov    %bl,%cl
  802589:	d3 ee                	shr    %cl,%esi
  80258b:	89 f9                	mov    %edi,%ecx
  80258d:	d3 e2                	shl    %cl,%edx
  80258f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802593:	88 d9                	mov    %bl,%cl
  802595:	d3 e8                	shr    %cl,%eax
  802597:	09 c2                	or     %eax,%edx
  802599:	89 d0                	mov    %edx,%eax
  80259b:	89 f2                	mov    %esi,%edx
  80259d:	f7 74 24 0c          	divl   0xc(%esp)
  8025a1:	89 d6                	mov    %edx,%esi
  8025a3:	89 c3                	mov    %eax,%ebx
  8025a5:	f7 e5                	mul    %ebp
  8025a7:	39 d6                	cmp    %edx,%esi
  8025a9:	72 19                	jb     8025c4 <__udivdi3+0xfc>
  8025ab:	74 0b                	je     8025b8 <__udivdi3+0xf0>
  8025ad:	89 d8                	mov    %ebx,%eax
  8025af:	31 ff                	xor    %edi,%edi
  8025b1:	e9 58 ff ff ff       	jmp    80250e <__udivdi3+0x46>
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8025bc:	89 f9                	mov    %edi,%ecx
  8025be:	d3 e2                	shl    %cl,%edx
  8025c0:	39 c2                	cmp    %eax,%edx
  8025c2:	73 e9                	jae    8025ad <__udivdi3+0xe5>
  8025c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025c7:	31 ff                	xor    %edi,%edi
  8025c9:	e9 40 ff ff ff       	jmp    80250e <__udivdi3+0x46>
  8025ce:	66 90                	xchg   %ax,%ax
  8025d0:	31 c0                	xor    %eax,%eax
  8025d2:	e9 37 ff ff ff       	jmp    80250e <__udivdi3+0x46>
  8025d7:	90                   	nop

008025d8 <__umoddi3>:
  8025d8:	55                   	push   %ebp
  8025d9:	57                   	push   %edi
  8025da:	56                   	push   %esi
  8025db:	53                   	push   %ebx
  8025dc:	83 ec 1c             	sub    $0x1c,%esp
  8025df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8025e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025f7:	89 f3                	mov    %esi,%ebx
  8025f9:	89 fa                	mov    %edi,%edx
  8025fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025ff:	89 34 24             	mov    %esi,(%esp)
  802602:	85 c0                	test   %eax,%eax
  802604:	75 1a                	jne    802620 <__umoddi3+0x48>
  802606:	39 f7                	cmp    %esi,%edi
  802608:	0f 86 a2 00 00 00    	jbe    8026b0 <__umoddi3+0xd8>
  80260e:	89 c8                	mov    %ecx,%eax
  802610:	89 f2                	mov    %esi,%edx
  802612:	f7 f7                	div    %edi
  802614:	89 d0                	mov    %edx,%eax
  802616:	31 d2                	xor    %edx,%edx
  802618:	83 c4 1c             	add    $0x1c,%esp
  80261b:	5b                   	pop    %ebx
  80261c:	5e                   	pop    %esi
  80261d:	5f                   	pop    %edi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    
  802620:	39 f0                	cmp    %esi,%eax
  802622:	0f 87 ac 00 00 00    	ja     8026d4 <__umoddi3+0xfc>
  802628:	0f bd e8             	bsr    %eax,%ebp
  80262b:	83 f5 1f             	xor    $0x1f,%ebp
  80262e:	0f 84 ac 00 00 00    	je     8026e0 <__umoddi3+0x108>
  802634:	bf 20 00 00 00       	mov    $0x20,%edi
  802639:	29 ef                	sub    %ebp,%edi
  80263b:	89 fe                	mov    %edi,%esi
  80263d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802641:	89 e9                	mov    %ebp,%ecx
  802643:	d3 e0                	shl    %cl,%eax
  802645:	89 d7                	mov    %edx,%edi
  802647:	89 f1                	mov    %esi,%ecx
  802649:	d3 ef                	shr    %cl,%edi
  80264b:	09 c7                	or     %eax,%edi
  80264d:	89 e9                	mov    %ebp,%ecx
  80264f:	d3 e2                	shl    %cl,%edx
  802651:	89 14 24             	mov    %edx,(%esp)
  802654:	89 d8                	mov    %ebx,%eax
  802656:	d3 e0                	shl    %cl,%eax
  802658:	89 c2                	mov    %eax,%edx
  80265a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80265e:	d3 e0                	shl    %cl,%eax
  802660:	89 44 24 04          	mov    %eax,0x4(%esp)
  802664:	8b 44 24 08          	mov    0x8(%esp),%eax
  802668:	89 f1                	mov    %esi,%ecx
  80266a:	d3 e8                	shr    %cl,%eax
  80266c:	09 d0                	or     %edx,%eax
  80266e:	d3 eb                	shr    %cl,%ebx
  802670:	89 da                	mov    %ebx,%edx
  802672:	f7 f7                	div    %edi
  802674:	89 d3                	mov    %edx,%ebx
  802676:	f7 24 24             	mull   (%esp)
  802679:	89 c6                	mov    %eax,%esi
  80267b:	89 d1                	mov    %edx,%ecx
  80267d:	39 d3                	cmp    %edx,%ebx
  80267f:	0f 82 87 00 00 00    	jb     80270c <__umoddi3+0x134>
  802685:	0f 84 91 00 00 00    	je     80271c <__umoddi3+0x144>
  80268b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80268f:	29 f2                	sub    %esi,%edx
  802691:	19 cb                	sbb    %ecx,%ebx
  802693:	89 d8                	mov    %ebx,%eax
  802695:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802699:	d3 e0                	shl    %cl,%eax
  80269b:	89 e9                	mov    %ebp,%ecx
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	09 d0                	or     %edx,%eax
  8026a1:	89 e9                	mov    %ebp,%ecx
  8026a3:	d3 eb                	shr    %cl,%ebx
  8026a5:	89 da                	mov    %ebx,%edx
  8026a7:	83 c4 1c             	add    $0x1c,%esp
  8026aa:	5b                   	pop    %ebx
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    
  8026af:	90                   	nop
  8026b0:	89 fd                	mov    %edi,%ebp
  8026b2:	85 ff                	test   %edi,%edi
  8026b4:	75 0b                	jne    8026c1 <__umoddi3+0xe9>
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	f7 f7                	div    %edi
  8026bf:	89 c5                	mov    %eax,%ebp
  8026c1:	89 f0                	mov    %esi,%eax
  8026c3:	31 d2                	xor    %edx,%edx
  8026c5:	f7 f5                	div    %ebp
  8026c7:	89 c8                	mov    %ecx,%eax
  8026c9:	f7 f5                	div    %ebp
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	e9 44 ff ff ff       	jmp    802616 <__umoddi3+0x3e>
  8026d2:	66 90                	xchg   %ax,%ax
  8026d4:	89 c8                	mov    %ecx,%eax
  8026d6:	89 f2                	mov    %esi,%edx
  8026d8:	83 c4 1c             	add    $0x1c,%esp
  8026db:	5b                   	pop    %ebx
  8026dc:	5e                   	pop    %esi
  8026dd:	5f                   	pop    %edi
  8026de:	5d                   	pop    %ebp
  8026df:	c3                   	ret    
  8026e0:	3b 04 24             	cmp    (%esp),%eax
  8026e3:	72 06                	jb     8026eb <__umoddi3+0x113>
  8026e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8026e9:	77 0f                	ja     8026fa <__umoddi3+0x122>
  8026eb:	89 f2                	mov    %esi,%edx
  8026ed:	29 f9                	sub    %edi,%ecx
  8026ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8026f3:	89 14 24             	mov    %edx,(%esp)
  8026f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026fe:	8b 14 24             	mov    (%esp),%edx
  802701:	83 c4 1c             	add    $0x1c,%esp
  802704:	5b                   	pop    %ebx
  802705:	5e                   	pop    %esi
  802706:	5f                   	pop    %edi
  802707:	5d                   	pop    %ebp
  802708:	c3                   	ret    
  802709:	8d 76 00             	lea    0x0(%esi),%esi
  80270c:	2b 04 24             	sub    (%esp),%eax
  80270f:	19 fa                	sbb    %edi,%edx
  802711:	89 d1                	mov    %edx,%ecx
  802713:	89 c6                	mov    %eax,%esi
  802715:	e9 71 ff ff ff       	jmp    80268b <__umoddi3+0xb3>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802720:	72 ea                	jb     80270c <__umoddi3+0x134>
  802722:	89 d9                	mov    %ebx,%ecx
  802724:	e9 62 ff ff ff       	jmp    80268b <__umoddi3+0xb3>
