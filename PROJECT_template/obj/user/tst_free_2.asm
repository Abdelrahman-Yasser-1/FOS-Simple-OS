
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 95 09 00 00       	call   8009cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
//				fullWS = 0;
//				break;
//			}
//		}

		if (LIST_SIZE(&(myEnv->PageWorkingSetList)) > 0)
  800046:	a1 20 40 80 00       	mov    0x804020,%eax
  80004b:	8b 80 9c 3c 01 00    	mov    0x13c9c(%eax),%eax
  800051:	85 c0                	test   %eax,%eax
  800053:	74 04                	je     800059 <_main+0x21>
		{
			fullWS = 0;
  800055:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		}
		if (fullWS) panic("Please increase the WS size");
  800059:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80005d:	74 14                	je     800073 <_main+0x3b>
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	68 80 29 80 00       	push   $0x802980
  800067:	6a 19                	push   $0x19
  800069:	68 9c 29 80 00       	push   $0x80299c
  80006e:	e8 9d 0a 00 00       	call   800b10 <_panic>
	}

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	6a 03                	push   $0x3
  800078:	e8 ab 24 00 00       	call   802528 <sys_bypassPageFault>
  80007d:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  800080:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800087:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  80008e:	e8 7e 21 00 00       	call   802211 <sys_calculate_free_frames>
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  800096:	8d 55 84             	lea    -0x7c(%ebp),%edx
  800099:	b9 14 00 00 00       	mov    $0x14,%ecx
  80009e:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a3:	89 d7                	mov    %edx,%edi
  8000a5:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000a7:	8d 95 34 ff ff ff    	lea    -0xcc(%ebp),%edx
  8000ad:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	89 d7                	mov    %edx,%edi
  8000b9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 51 21 00 00       	call   802211 <sys_calculate_free_frames>
  8000c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c3:	e8 cc 21 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8000c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ce:	01 c0                	add    %eax,%eax
  8000d0:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	50                   	push   %eax
  8000d7:	e8 60 1a 00 00       	call   801b3c <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8000e2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	78 14                	js     8000fd <_main+0xc5>
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	68 b0 29 80 00       	push   $0x8029b0
  8000f1:	6a 30                	push   $0x30
  8000f3:	68 9c 29 80 00       	push   $0x80299c
  8000f8:	e8 13 0a 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8000fd:	e8 92 21 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800102:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800105:	3d 00 02 00 00       	cmp    $0x200,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 18 2a 80 00       	push   $0x802a18
  800114:	6a 31                	push   $0x31
  800116:	68 9c 29 80 00       	push   $0x80299c
  80011b:	e8 f0 09 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800123:	01 c0                	add    %eax,%eax
  800125:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800128:	48                   	dec    %eax
  800129:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  80012f:	e8 dd 20 00 00       	call   802211 <sys_calculate_free_frames>
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800137:	e8 58 21 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80013c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80013f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	50                   	push   %eax
  80014b:	e8 ec 19 00 00       	call   801b3c <malloc>
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800156:	8b 45 88             	mov    -0x78(%ebp),%eax
  800159:	89 c2                	mov    %eax,%edx
  80015b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	05 00 00 00 80       	add    $0x80000000,%eax
  800165:	39 c2                	cmp    %eax,%edx
  800167:	73 14                	jae    80017d <_main+0x145>
  800169:	83 ec 04             	sub    $0x4,%esp
  80016c:	68 b0 29 80 00       	push   $0x8029b0
  800171:	6a 38                	push   $0x38
  800173:	68 9c 29 80 00       	push   $0x80299c
  800178:	e8 93 09 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80017d:	e8 12 21 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800182:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800185:	3d 00 02 00 00       	cmp    $0x200,%eax
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 18 2a 80 00       	push   $0x802a18
  800194:	6a 39                	push   $0x39
  800196:	68 9c 29 80 00       	push   $0x80299c
  80019b:	e8 70 09 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001a3:	01 c0                	add    %eax,%eax
  8001a5:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001a8:	48                   	dec    %eax
  8001a9:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001af:	e8 5d 20 00 00       	call   802211 <sys_calculate_free_frames>
  8001b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b7:	e8 d8 20 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8001bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c2:	89 c2                	mov    %eax,%edx
  8001c4:	01 d2                	add    %edx,%edx
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	50                   	push   %eax
  8001cc:	e8 6b 19 00 00       	call   801b3c <malloc>
  8001d1:	83 c4 10             	add    $0x10,%esp
  8001d4:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8001d7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001df:	c1 e0 02             	shl    $0x2,%eax
  8001e2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001e7:	39 c2                	cmp    %eax,%edx
  8001e9:	73 14                	jae    8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 b0 29 80 00       	push   $0x8029b0
  8001f3:	6a 40                	push   $0x40
  8001f5:	68 9c 29 80 00       	push   $0x80299c
  8001fa:	e8 11 09 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  8001ff:	e8 90 20 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800204:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800207:	83 f8 01             	cmp    $0x1,%eax
  80020a:	74 14                	je     800220 <_main+0x1e8>
  80020c:	83 ec 04             	sub    $0x4,%esp
  80020f:	68 18 2a 80 00       	push   $0x802a18
  800214:	6a 41                	push   $0x41
  800216:	68 9c 29 80 00       	push   $0x80299c
  80021b:	e8 f0 08 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (3*kilo)/sizeof(char) - 1;
  800220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800223:	89 c2                	mov    %eax,%edx
  800225:	01 d2                	add    %edx,%edx
  800227:	01 d0                	add    %edx,%eax
  800229:	48                   	dec    %eax
  80022a:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800230:	e8 dc 1f 00 00       	call   802211 <sys_calculate_free_frames>
  800235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800238:	e8 57 20 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80023d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800243:	89 c2                	mov    %eax,%edx
  800245:	01 d2                	add    %edx,%edx
  800247:	01 d0                	add    %edx,%eax
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	50                   	push   %eax
  80024d:	e8 ea 18 00 00       	call   801b3c <malloc>
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800258:	8b 45 90             	mov    -0x70(%ebp),%eax
  80025b:	89 c2                	mov    %eax,%edx
  80025d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800260:	c1 e0 02             	shl    $0x2,%eax
  800263:	89 c1                	mov    %eax,%ecx
  800265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800268:	c1 e0 02             	shl    $0x2,%eax
  80026b:	01 c8                	add    %ecx,%eax
  80026d:	05 00 00 00 80       	add    $0x80000000,%eax
  800272:	39 c2                	cmp    %eax,%edx
  800274:	73 14                	jae    80028a <_main+0x252>
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	68 b0 29 80 00       	push   $0x8029b0
  80027e:	6a 48                	push   $0x48
  800280:	68 9c 29 80 00       	push   $0x80299c
  800285:	e8 86 08 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  80028a:	e8 05 20 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80028f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800292:	83 f8 01             	cmp    $0x1,%eax
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 18 2a 80 00       	push   $0x802a18
  80029f:	6a 49                	push   $0x49
  8002a1:	68 9c 29 80 00       	push   $0x80299c
  8002a6:	e8 65 08 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (3*kilo)/sizeof(char) - 1;
  8002ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	48                   	dec    %eax
  8002b5:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 51 1f 00 00       	call   802211 <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c3:	e8 cc 1f 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8002ce:	89 d0                	mov    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	01 c0                	add    %eax,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	e8 5b 18 00 00       	call   801b3c <malloc>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002e7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8002ea:	89 c2                	mov    %eax,%edx
  8002ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ef:	c1 e0 02             	shl    $0x2,%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f7:	c1 e0 03             	shl    $0x3,%eax
  8002fa:	01 c8                	add    %ecx,%eax
  8002fc:	05 00 00 00 80       	add    $0x80000000,%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	73 14                	jae    800319 <_main+0x2e1>
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	68 b0 29 80 00       	push   $0x8029b0
  80030d:	6a 50                	push   $0x50
  80030f:	68 9c 29 80 00       	push   $0x80299c
  800314:	e8 f7 07 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800319:	e8 76 1f 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80031e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800321:	83 f8 02             	cmp    $0x2,%eax
  800324:	74 14                	je     80033a <_main+0x302>
  800326:	83 ec 04             	sub    $0x4,%esp
  800329:	68 18 2a 80 00       	push   $0x802a18
  80032e:	6a 51                	push   $0x51
  800330:	68 9c 29 80 00       	push   $0x80299c
  800335:	e8 d6 07 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  80033a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80033d:	89 d0                	mov    %edx,%eax
  80033f:	01 c0                	add    %eax,%eax
  800341:	01 d0                	add    %edx,%eax
  800343:	01 c0                	add    %eax,%eax
  800345:	01 d0                	add    %edx,%eax
  800347:	48                   	dec    %eax
  800348:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  80034e:	e8 be 1e 00 00       	call   802211 <sys_calculate_free_frames>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800356:	e8 39 1f 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80035b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80035e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800361:	89 c2                	mov    %eax,%edx
  800363:	01 d2                	add    %edx,%edx
  800365:	01 d0                	add    %edx,%eax
  800367:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	50                   	push   %eax
  80036e:	e8 c9 17 00 00       	call   801b3c <malloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800379:	8b 45 98             	mov    -0x68(%ebp),%eax
  80037c:	89 c2                	mov    %eax,%edx
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	c1 e0 02             	shl    $0x2,%eax
  800384:	89 c1                	mov    %eax,%ecx
  800386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800389:	c1 e0 04             	shl    $0x4,%eax
  80038c:	01 c8                	add    %ecx,%eax
  80038e:	05 00 00 00 80       	add    $0x80000000,%eax
  800393:	39 c2                	cmp    %eax,%edx
  800395:	73 14                	jae    8003ab <_main+0x373>
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	68 b0 29 80 00       	push   $0x8029b0
  80039f:	6a 58                	push   $0x58
  8003a1:	68 9c 29 80 00       	push   $0x80299c
  8003a6:	e8 65 07 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8003ab:	e8 e4 1e 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8003b0:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8003b3:	89 c2                	mov    %eax,%edx
  8003b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b8:	89 c1                	mov    %eax,%ecx
  8003ba:	01 c9                	add    %ecx,%ecx
  8003bc:	01 c8                	add    %ecx,%eax
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	79 05                	jns    8003c7 <_main+0x38f>
  8003c2:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003c7:	c1 f8 0c             	sar    $0xc,%eax
  8003ca:	39 c2                	cmp    %eax,%edx
  8003cc:	74 14                	je     8003e2 <_main+0x3aa>
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	68 18 2a 80 00       	push   $0x802a18
  8003d6:	6a 59                	push   $0x59
  8003d8:	68 9c 29 80 00       	push   $0x80299c
  8003dd:	e8 2e 07 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e5:	89 c2                	mov    %eax,%edx
  8003e7:	01 d2                	add    %edx,%edx
  8003e9:	01 d0                	add    %edx,%eax
  8003eb:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003ee:	48                   	dec    %eax
  8003ef:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f5:	e8 17 1e 00 00       	call   802211 <sys_calculate_free_frames>
  8003fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fd:	e8 92 1e 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800402:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800408:	01 c0                	add    %eax,%eax
  80040a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	50                   	push   %eax
  800411:	e8 26 17 00 00       	call   801b3c <malloc>
  800416:	83 c4 10             	add    $0x10,%esp
  800419:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80041f:	89 c1                	mov    %eax,%ecx
  800421:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800424:	89 d0                	mov    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	89 c2                	mov    %eax,%edx
  800430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	05 00 00 00 80       	add    $0x80000000,%eax
  80043d:	39 c1                	cmp    %eax,%ecx
  80043f:	73 14                	jae    800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 b0 29 80 00       	push   $0x8029b0
  800449:	6a 60                	push   $0x60
  80044b:	68 9c 29 80 00       	push   $0x80299c
  800450:	e8 bb 06 00 00       	call   800b10 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800455:	e8 3a 1e 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80045a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80045d:	3d 00 02 00 00       	cmp    $0x200,%eax
  800462:	74 14                	je     800478 <_main+0x440>
  800464:	83 ec 04             	sub    $0x4,%esp
  800467:	68 18 2a 80 00       	push   $0x802a18
  80046c:	6a 61                	push   $0x61
  80046e:	68 9c 29 80 00       	push   $0x80299c
  800473:	e8 98 06 00 00       	call   800b10 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800480:	48                   	dec    %eax
  800481:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800487:	e8 85 1d 00 00       	call   802211 <sys_calculate_free_frames>
  80048c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 00 1e 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800494:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[0]);
  800497:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	50                   	push   %eax
  80049e:	e8 c8 18 00 00       	call   801d6b <free>
  8004a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a6:	e8 e9 1d 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8004ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004ae:	29 c2                	sub    %eax,%edx
  8004b0:	89 d0                	mov    %edx,%eax
  8004b2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004b7:	74 14                	je     8004cd <_main+0x495>
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	68 48 2a 80 00       	push   $0x802a48
  8004c1:	6a 6e                	push   $0x6e
  8004c3:	68 9c 29 80 00       	push   $0x80299c
  8004c8:	e8 43 06 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004cd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8004d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  8004d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004d6:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004d9:	e8 31 20 00 00       	call   80250f <sys_rcr2>
  8004de:	89 c2                	mov    %eax,%edx
  8004e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	74 14                	je     8004fb <_main+0x4c3>
  8004e7:	83 ec 04             	sub    $0x4,%esp
  8004ea:	68 84 2a 80 00       	push   $0x802a84
  8004ef:	6a 72                	push   $0x72
  8004f1:	68 9c 29 80 00       	push   $0x80299c
  8004f6:	e8 15 06 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004fb:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800501:	89 c2                	mov    %eax,%edx
  800503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800506:	01 d0                	add    %edx,%eax
  800508:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80050b:	e8 ff 1f 00 00       	call   80250f <sys_rcr2>
  800510:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  800516:	89 d1                	mov    %edx,%ecx
  800518:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80051b:	01 ca                	add    %ecx,%edx
  80051d:	39 d0                	cmp    %edx,%eax
  80051f:	74 14                	je     800535 <_main+0x4fd>
  800521:	83 ec 04             	sub    $0x4,%esp
  800524:	68 84 2a 80 00       	push   $0x802a84
  800529:	6a 74                	push   $0x74
  80052b:	68 9c 29 80 00       	push   $0x80299c
  800530:	e8 db 05 00 00       	call   800b10 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800535:	e8 d7 1c 00 00       	call   802211 <sys_calculate_free_frames>
  80053a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80053d:	e8 52 1d 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  800545:	8b 45 88             	mov    -0x78(%ebp),%eax
  800548:	83 ec 0c             	sub    $0xc,%esp
  80054b:	50                   	push   %eax
  80054c:	e8 1a 18 00 00       	call   801d6b <free>
  800551:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800554:	e8 3b 1d 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800559:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80055c:	29 c2                	sub    %eax,%edx
  80055e:	89 d0                	mov    %edx,%eax
  800560:	3d 00 02 00 00       	cmp    $0x200,%eax
  800565:	74 14                	je     80057b <_main+0x543>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 48 2a 80 00       	push   $0x802a48
  80056f:	6a 79                	push   $0x79
  800571:	68 9c 29 80 00       	push   $0x80299c
  800576:	e8 95 05 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  80057b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80057e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  800581:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800584:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800587:	e8 83 1f 00 00       	call   80250f <sys_rcr2>
  80058c:	89 c2                	mov    %eax,%edx
  80058e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800591:	39 c2                	cmp    %eax,%edx
  800593:	74 14                	je     8005a9 <_main+0x571>
  800595:	83 ec 04             	sub    $0x4,%esp
  800598:	68 84 2a 80 00       	push   $0x802a84
  80059d:	6a 7d                	push   $0x7d
  80059f:	68 9c 29 80 00       	push   $0x80299c
  8005a4:	e8 67 05 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[1]] = 10;
  8005a9:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8005af:	89 c2                	mov    %eax,%edx
  8005b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005b9:	e8 51 1f 00 00       	call   80250f <sys_rcr2>
  8005be:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  8005c4:	89 d1                	mov    %edx,%ecx
  8005c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c9:	01 ca                	add    %ecx,%edx
  8005cb:	39 d0                	cmp    %edx,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 84 2a 80 00       	push   $0x802a84
  8005d7:	6a 7f                	push   $0x7f
  8005d9:	68 9c 29 80 00       	push   $0x80299c
  8005de:	e8 2d 05 00 00       	call   800b10 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 29 1c 00 00       	call   802211 <sys_calculate_free_frames>
  8005e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 a4 1c 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  8005f3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	50                   	push   %eax
  8005fa:	e8 6c 17 00 00       	call   801d6b <free>
  8005ff:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  800602:	e8 8d 1c 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800607:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80060a:	29 c2                	sub    %eax,%edx
  80060c:	89 d0                	mov    %edx,%eax
  80060e:	83 f8 01             	cmp    $0x1,%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 48 2a 80 00       	push   $0x802a48
  80061b:	68 84 00 00 00       	push   $0x84
  800620:	68 9c 29 80 00       	push   $0x80299c
  800625:	e8 e6 04 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80062a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80062d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  800630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800633:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800636:	e8 d4 1e 00 00       	call   80250f <sys_rcr2>
  80063b:	89 c2                	mov    %eax,%edx
  80063d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800640:	39 c2                	cmp    %eax,%edx
  800642:	74 17                	je     80065b <_main+0x623>
  800644:	83 ec 04             	sub    $0x4,%esp
  800647:	68 84 2a 80 00       	push   $0x802a84
  80064c:	68 88 00 00 00       	push   $0x88
  800651:	68 9c 29 80 00       	push   $0x80299c
  800656:	e8 b5 04 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[2]] = 10;
  80065b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800661:	89 c2                	mov    %eax,%edx
  800663:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800666:	01 d0                	add    %edx,%eax
  800668:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80066b:	e8 9f 1e 00 00       	call   80250f <sys_rcr2>
  800670:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800676:	89 d1                	mov    %edx,%ecx
  800678:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067b:	01 ca                	add    %ecx,%edx
  80067d:	39 d0                	cmp    %edx,%eax
  80067f:	74 17                	je     800698 <_main+0x660>
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	68 84 2a 80 00       	push   $0x802a84
  800689:	68 8a 00 00 00       	push   $0x8a
  80068e:	68 9c 29 80 00       	push   $0x80299c
  800693:	e8 78 04 00 00       	call   800b10 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800698:	e8 74 1b 00 00       	call   802211 <sys_calculate_free_frames>
  80069d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006a0:	e8 ef 1b 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8006a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  8006a8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006ab:	83 ec 0c             	sub    $0xc,%esp
  8006ae:	50                   	push   %eax
  8006af:	e8 b7 16 00 00       	call   801d6b <free>
  8006b4:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006b7:	e8 d8 1b 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8006bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bf:	29 c2                	sub    %eax,%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	83 f8 01             	cmp    $0x1,%eax
  8006c6:	74 17                	je     8006df <_main+0x6a7>
  8006c8:	83 ec 04             	sub    $0x4,%esp
  8006cb:	68 48 2a 80 00       	push   $0x802a48
  8006d0:	68 8f 00 00 00       	push   $0x8f
  8006d5:	68 9c 29 80 00       	push   $0x80299c
  8006da:	e8 31 04 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006df:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  8006e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006eb:	e8 1f 1e 00 00       	call   80250f <sys_rcr2>
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	39 c2                	cmp    %eax,%edx
  8006f7:	74 17                	je     800710 <_main+0x6d8>
  8006f9:	83 ec 04             	sub    $0x4,%esp
  8006fc:	68 84 2a 80 00       	push   $0x802a84
  800701:	68 93 00 00 00       	push   $0x93
  800706:	68 9c 29 80 00       	push   $0x80299c
  80070b:	e8 00 04 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[3]] = 10;
  800710:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800716:	89 c2                	mov    %eax,%edx
  800718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80071b:	01 d0                	add    %edx,%eax
  80071d:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800720:	e8 ea 1d 00 00       	call   80250f <sys_rcr2>
  800725:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  80072b:	89 d1                	mov    %edx,%ecx
  80072d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800730:	01 ca                	add    %ecx,%edx
  800732:	39 d0                	cmp    %edx,%eax
  800734:	74 17                	je     80074d <_main+0x715>
  800736:	83 ec 04             	sub    $0x4,%esp
  800739:	68 84 2a 80 00       	push   $0x802a84
  80073e:	68 95 00 00 00       	push   $0x95
  800743:	68 9c 29 80 00       	push   $0x80299c
  800748:	e8 c3 03 00 00       	call   800b10 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80074d:	e8 bf 1a 00 00       	call   802211 <sys_calculate_free_frames>
  800752:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800755:	e8 3a 1b 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80075a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80075d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800760:	83 ec 0c             	sub    $0xc,%esp
  800763:	50                   	push   %eax
  800764:	e8 02 16 00 00       	call   801d6b <free>
  800769:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  80076c:	e8 23 1b 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800771:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800774:	29 c2                	sub    %eax,%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	83 f8 02             	cmp    $0x2,%eax
  80077b:	74 17                	je     800794 <_main+0x75c>
  80077d:	83 ec 04             	sub    $0x4,%esp
  800780:	68 48 2a 80 00       	push   $0x802a48
  800785:	68 9a 00 00 00       	push   $0x9a
  80078a:	68 9c 29 80 00       	push   $0x80299c
  80078f:	e8 7c 03 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800794:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800797:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  80079a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80079d:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a0:	e8 6a 1d 00 00       	call   80250f <sys_rcr2>
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007aa:	39 c2                	cmp    %eax,%edx
  8007ac:	74 17                	je     8007c5 <_main+0x78d>
  8007ae:	83 ec 04             	sub    $0x4,%esp
  8007b1:	68 84 2a 80 00       	push   $0x802a84
  8007b6:	68 9e 00 00 00       	push   $0x9e
  8007bb:	68 9c 29 80 00       	push   $0x80299c
  8007c0:	e8 4b 03 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[4]] = 10;
  8007c5:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8007cb:	89 c2                	mov    %eax,%edx
  8007cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007d0:	01 d0                	add    %edx,%eax
  8007d2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007d5:	e8 35 1d 00 00       	call   80250f <sys_rcr2>
  8007da:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  8007e0:	89 d1                	mov    %edx,%ecx
  8007e2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007e5:	01 ca                	add    %ecx,%edx
  8007e7:	39 d0                	cmp    %edx,%eax
  8007e9:	74 17                	je     800802 <_main+0x7ca>
  8007eb:	83 ec 04             	sub    $0x4,%esp
  8007ee:	68 84 2a 80 00       	push   $0x802a84
  8007f3:	68 a0 00 00 00       	push   $0xa0
  8007f8:	68 9c 29 80 00       	push   $0x80299c
  8007fd:	e8 0e 03 00 00       	call   800b10 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800802:	e8 0a 1a 00 00       	call   802211 <sys_calculate_free_frames>
  800807:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80080a:	e8 85 1a 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  80080f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[5]);
  800812:	8b 45 98             	mov    -0x68(%ebp),%eax
  800815:	83 ec 0c             	sub    $0xc,%esp
  800818:	50                   	push   %eax
  800819:	e8 4d 15 00 00       	call   801d6b <free>
  80081e:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  800821:	e8 6e 1a 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  800826:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800829:	89 d1                	mov    %edx,%ecx
  80082b:	29 c1                	sub    %eax,%ecx
  80082d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800830:	89 c2                	mov    %eax,%edx
  800832:	01 d2                	add    %edx,%edx
  800834:	01 d0                	add    %edx,%eax
  800836:	85 c0                	test   %eax,%eax
  800838:	79 05                	jns    80083f <_main+0x807>
  80083a:	05 ff 0f 00 00       	add    $0xfff,%eax
  80083f:	c1 f8 0c             	sar    $0xc,%eax
  800842:	39 c1                	cmp    %eax,%ecx
  800844:	74 17                	je     80085d <_main+0x825>
  800846:	83 ec 04             	sub    $0x4,%esp
  800849:	68 48 2a 80 00       	push   $0x802a48
  80084e:	68 a5 00 00 00       	push   $0xa5
  800853:	68 9c 29 80 00       	push   $0x80299c
  800858:	e8 b3 02 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  80085d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800860:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  800863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800866:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800869:	e8 a1 1c 00 00       	call   80250f <sys_rcr2>
  80086e:	89 c2                	mov    %eax,%edx
  800870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800873:	39 c2                	cmp    %eax,%edx
  800875:	74 17                	je     80088e <_main+0x856>
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 84 2a 80 00       	push   $0x802a84
  80087f:	68 a9 00 00 00       	push   $0xa9
  800884:	68 9c 29 80 00       	push   $0x80299c
  800889:	e8 82 02 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[5]] = 10;
  80088e:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800894:	89 c2                	mov    %eax,%edx
  800896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800899:	01 d0                	add    %edx,%eax
  80089b:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80089e:	e8 6c 1c 00 00       	call   80250f <sys_rcr2>
  8008a3:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  8008a9:	89 d1                	mov    %edx,%ecx
  8008ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008ae:	01 ca                	add    %ecx,%edx
  8008b0:	39 d0                	cmp    %edx,%eax
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 84 2a 80 00       	push   $0x802a84
  8008bc:	68 ab 00 00 00       	push   $0xab
  8008c1:	68 9c 29 80 00       	push   $0x80299c
  8008c6:	e8 45 02 00 00       	call   800b10 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 41 19 00 00       	call   802211 <sys_calculate_free_frames>
  8008d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 bc 19 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  8008db:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8008de:	83 ec 0c             	sub    $0xc,%esp
  8008e1:	50                   	push   %eax
  8008e2:	e8 84 14 00 00       	call   801d6b <free>
  8008e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008ea:	e8 a5 19 00 00       	call   802294 <sys_pf_calculate_allocated_pages>
  8008ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008f2:	29 c2                	sub    %eax,%edx
  8008f4:	89 d0                	mov    %edx,%eax
  8008f6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8008fb:	74 17                	je     800914 <_main+0x8dc>
  8008fd:	83 ec 04             	sub    $0x4,%esp
  800900:	68 48 2a 80 00       	push   $0x802a48
  800905:	68 b0 00 00 00       	push   $0xb0
  80090a:	68 9c 29 80 00       	push   $0x80299c
  80090f:	e8 fc 01 00 00       	call   800b10 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  800914:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800917:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		byteArr[0] = 10;
  80091a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091d:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800920:	e8 ea 1b 00 00       	call   80250f <sys_rcr2>
  800925:	89 c2                	mov    %eax,%edx
  800927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80092a:	39 c2                	cmp    %eax,%edx
  80092c:	74 17                	je     800945 <_main+0x90d>
  80092e:	83 ec 04             	sub    $0x4,%esp
  800931:	68 84 2a 80 00       	push   $0x802a84
  800936:	68 b4 00 00 00       	push   $0xb4
  80093b:	68 9c 29 80 00       	push   $0x80299c
  800940:	e8 cb 01 00 00       	call   800b10 <_panic>
		byteArr[lastIndices[6]] = 10;
  800945:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80094b:	89 c2                	mov    %eax,%edx
  80094d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800950:	01 d0                	add    %edx,%eax
  800952:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800955:	e8 b5 1b 00 00       	call   80250f <sys_rcr2>
  80095a:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800960:	89 d1                	mov    %edx,%ecx
  800962:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800965:	01 ca                	add    %ecx,%edx
  800967:	39 d0                	cmp    %edx,%eax
  800969:	74 17                	je     800982 <_main+0x94a>
  80096b:	83 ec 04             	sub    $0x4,%esp
  80096e:	68 84 2a 80 00       	push   $0x802a84
  800973:	68 b6 00 00 00       	push   $0xb6
  800978:	68 9c 29 80 00       	push   $0x80299c
  80097d:	e8 8e 01 00 00       	call   800b10 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames() + 3) ) {panic("Wrong free: not all pages removed correctly at end");}
  800982:	e8 8a 18 00 00       	call   802211 <sys_calculate_free_frames>
  800987:	8d 50 03             	lea    0x3(%eax),%edx
  80098a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80098d:	39 c2                	cmp    %eax,%edx
  80098f:	74 17                	je     8009a8 <_main+0x970>
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	68 c8 2a 80 00       	push   $0x802ac8
  800999:	68 b8 00 00 00       	push   $0xb8
  80099e:	68 9c 29 80 00       	push   $0x80299c
  8009a3:	e8 68 01 00 00       	call   800b10 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	6a 00                	push   $0x0
  8009ad:	e8 76 1b 00 00       	call   802528 <sys_bypassPageFault>
  8009b2:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  8009b5:	83 ec 0c             	sub    $0xc,%esp
  8009b8:	68 fc 2a 80 00       	push   $0x802afc
  8009bd:	e8 f0 03 00 00       	call   800db2 <cprintf>
  8009c2:	83 c4 10             	add    $0x10,%esp

	return;
  8009c5:	90                   	nop
}
  8009c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    

008009cb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8009d1:	e8 70 17 00 00       	call   802146 <sys_getenvindex>
  8009d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8009d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 03             	shl    $0x3,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8009ea:	01 c8                	add    %ecx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	01 c0                	add    %eax,%eax
  8009f2:	01 d0                	add    %edx,%eax
  8009f4:	89 c2                	mov    %eax,%edx
  8009f6:	c1 e2 05             	shl    $0x5,%edx
  8009f9:	29 c2                	sub    %eax,%edx
  8009fb:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800a0a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800a14:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0f                	je     800a2d <libmain+0x62>
		binaryname = myEnv->prog_name;
  800a1e:	a1 20 40 80 00       	mov    0x804020,%eax
  800a23:	05 40 3c 01 00       	add    $0x13c40,%eax
  800a28:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a31:	7e 0a                	jle    800a3d <libmain+0x72>
		binaryname = argv[0];
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8b 00                	mov    (%eax),%eax
  800a38:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	ff 75 0c             	pushl  0xc(%ebp)
  800a43:	ff 75 08             	pushl  0x8(%ebp)
  800a46:	e8 ed f5 ff ff       	call   800038 <_main>
  800a4b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800a4e:	e8 8e 18 00 00       	call   8022e1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800a53:	83 ec 0c             	sub    $0xc,%esp
  800a56:	68 50 2b 80 00       	push   $0x802b50
  800a5b:	e8 52 03 00 00       	call   800db2 <cprintf>
  800a60:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a63:	a1 20 40 80 00       	mov    0x804020,%eax
  800a68:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800a6e:	a1 20 40 80 00       	mov    0x804020,%eax
  800a73:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800a79:	83 ec 04             	sub    $0x4,%esp
  800a7c:	52                   	push   %edx
  800a7d:	50                   	push   %eax
  800a7e:	68 78 2b 80 00       	push   $0x802b78
  800a83:	e8 2a 03 00 00       	call   800db2 <cprintf>
  800a88:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800a8b:	a1 20 40 80 00       	mov    0x804020,%eax
  800a90:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800a96:	a1 20 40 80 00       	mov    0x804020,%eax
  800a9b:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800aa1:	83 ec 04             	sub    $0x4,%esp
  800aa4:	52                   	push   %edx
  800aa5:	50                   	push   %eax
  800aa6:	68 a0 2b 80 00       	push   $0x802ba0
  800aab:	e8 02 03 00 00       	call   800db2 <cprintf>
  800ab0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ab3:	a1 20 40 80 00       	mov    0x804020,%eax
  800ab8:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	50                   	push   %eax
  800ac2:	68 e1 2b 80 00       	push   $0x802be1
  800ac7:	e8 e6 02 00 00       	call   800db2 <cprintf>
  800acc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800acf:	83 ec 0c             	sub    $0xc,%esp
  800ad2:	68 50 2b 80 00       	push   $0x802b50
  800ad7:	e8 d6 02 00 00       	call   800db2 <cprintf>
  800adc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800adf:	e8 17 18 00 00       	call   8022fb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800ae4:	e8 19 00 00 00       	call   800b02 <exit>
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800af2:	83 ec 0c             	sub    $0xc,%esp
  800af5:	6a 00                	push   $0x0
  800af7:	e8 16 16 00 00       	call   802112 <sys_env_destroy>
  800afc:	83 c4 10             	add    $0x10,%esp
}
  800aff:	90                   	nop
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <exit>:

void
exit(void)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800b08:	e8 6b 16 00 00       	call   802178 <sys_env_exit>
}
  800b0d:	90                   	nop
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800b16:	8d 45 10             	lea    0x10(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800b1f:	a1 18 41 80 00       	mov    0x804118,%eax
  800b24:	85 c0                	test   %eax,%eax
  800b26:	74 16                	je     800b3e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800b28:	a1 18 41 80 00       	mov    0x804118,%eax
  800b2d:	83 ec 08             	sub    $0x8,%esp
  800b30:	50                   	push   %eax
  800b31:	68 f8 2b 80 00       	push   $0x802bf8
  800b36:	e8 77 02 00 00       	call   800db2 <cprintf>
  800b3b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800b3e:	a1 00 40 80 00       	mov    0x804000,%eax
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	ff 75 08             	pushl  0x8(%ebp)
  800b49:	50                   	push   %eax
  800b4a:	68 fd 2b 80 00       	push   $0x802bfd
  800b4f:	e8 5e 02 00 00       	call   800db2 <cprintf>
  800b54:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b57:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b60:	50                   	push   %eax
  800b61:	e8 e1 01 00 00       	call   800d47 <vcprintf>
  800b66:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	6a 00                	push   $0x0
  800b6e:	68 19 2c 80 00       	push   $0x802c19
  800b73:	e8 cf 01 00 00       	call   800d47 <vcprintf>
  800b78:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b7b:	e8 82 ff ff ff       	call   800b02 <exit>

	// should not return here
	while (1) ;
  800b80:	eb fe                	jmp    800b80 <_panic+0x70>

00800b82 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b88:	a1 20 40 80 00       	mov    0x804020,%eax
  800b8d:	8b 50 74             	mov    0x74(%eax),%edx
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	39 c2                	cmp    %eax,%edx
  800b95:	74 14                	je     800bab <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b97:	83 ec 04             	sub    $0x4,%esp
  800b9a:	68 1c 2c 80 00       	push   $0x802c1c
  800b9f:	6a 26                	push   $0x26
  800ba1:	68 68 2c 80 00       	push   $0x802c68
  800ba6:	e8 65 ff ff ff       	call   800b10 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800bab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800bb2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bb9:	e9 b6 00 00 00       	jmp    800c74 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	01 d0                	add    %edx,%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	75 08                	jne    800bdb <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800bd6:	e9 96 00 00 00       	jmp    800c71 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800bdb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800be2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800be9:	eb 5d                	jmp    800c48 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800beb:	a1 20 40 80 00       	mov    0x804020,%eax
  800bf0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800bf6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bf9:	c1 e2 04             	shl    $0x4,%edx
  800bfc:	01 d0                	add    %edx,%eax
  800bfe:	8a 40 04             	mov    0x4(%eax),%al
  800c01:	84 c0                	test   %al,%al
  800c03:	75 40                	jne    800c45 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c05:	a1 20 40 80 00       	mov    0x804020,%eax
  800c0a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c13:	c1 e2 04             	shl    $0x4,%edx
  800c16:	01 d0                	add    %edx,%eax
  800c18:	8b 00                	mov    (%eax),%eax
  800c1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c25:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c2a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	01 c8                	add    %ecx,%eax
  800c36:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	75 09                	jne    800c45 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800c3c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800c43:	eb 12                	jmp    800c57 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c45:	ff 45 e8             	incl   -0x18(%ebp)
  800c48:	a1 20 40 80 00       	mov    0x804020,%eax
  800c4d:	8b 50 74             	mov    0x74(%eax),%edx
  800c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c53:	39 c2                	cmp    %eax,%edx
  800c55:	77 94                	ja     800beb <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c5b:	75 14                	jne    800c71 <CheckWSWithoutLastIndex+0xef>
			panic(
  800c5d:	83 ec 04             	sub    $0x4,%esp
  800c60:	68 74 2c 80 00       	push   $0x802c74
  800c65:	6a 3a                	push   $0x3a
  800c67:	68 68 2c 80 00       	push   $0x802c68
  800c6c:	e8 9f fe ff ff       	call   800b10 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c71:	ff 45 f0             	incl   -0x10(%ebp)
  800c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c77:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c7a:	0f 8c 3e ff ff ff    	jl     800bbe <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c87:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c8e:	eb 20                	jmp    800cb0 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c90:	a1 20 40 80 00       	mov    0x804020,%eax
  800c95:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800c9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9e:	c1 e2 04             	shl    $0x4,%edx
  800ca1:	01 d0                	add    %edx,%eax
  800ca3:	8a 40 04             	mov    0x4(%eax),%al
  800ca6:	3c 01                	cmp    $0x1,%al
  800ca8:	75 03                	jne    800cad <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800caa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cad:	ff 45 e0             	incl   -0x20(%ebp)
  800cb0:	a1 20 40 80 00       	mov    0x804020,%eax
  800cb5:	8b 50 74             	mov    0x74(%eax),%edx
  800cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cbb:	39 c2                	cmp    %eax,%edx
  800cbd:	77 d1                	ja     800c90 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800cc5:	74 14                	je     800cdb <CheckWSWithoutLastIndex+0x159>
		panic(
  800cc7:	83 ec 04             	sub    $0x4,%esp
  800cca:	68 c8 2c 80 00       	push   $0x802cc8
  800ccf:	6a 44                	push   $0x44
  800cd1:	68 68 2c 80 00       	push   $0x802c68
  800cd6:	e8 35 fe ff ff       	call   800b10 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800cdb:	90                   	nop
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8b 00                	mov    (%eax),%eax
  800ce9:	8d 48 01             	lea    0x1(%eax),%ecx
  800cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cef:	89 0a                	mov    %ecx,(%edx)
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	88 d1                	mov    %dl,%cl
  800cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	8b 00                	mov    (%eax),%eax
  800d02:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d07:	75 2c                	jne    800d35 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800d09:	a0 24 40 80 00       	mov    0x804024,%al
  800d0e:	0f b6 c0             	movzbl %al,%eax
  800d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d14:	8b 12                	mov    (%edx),%edx
  800d16:	89 d1                	mov    %edx,%ecx
  800d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1b:	83 c2 08             	add    $0x8,%edx
  800d1e:	83 ec 04             	sub    $0x4,%esp
  800d21:	50                   	push   %eax
  800d22:	51                   	push   %ecx
  800d23:	52                   	push   %edx
  800d24:	e8 a7 13 00 00       	call   8020d0 <sys_cputs>
  800d29:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8b 40 04             	mov    0x4(%eax),%eax
  800d3b:	8d 50 01             	lea    0x1(%eax),%edx
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d44:	90                   	nop
  800d45:	c9                   	leave  
  800d46:	c3                   	ret    

00800d47 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d50:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d57:	00 00 00 
	b.cnt = 0;
  800d5a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d61:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d64:	ff 75 0c             	pushl  0xc(%ebp)
  800d67:	ff 75 08             	pushl  0x8(%ebp)
  800d6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d70:	50                   	push   %eax
  800d71:	68 de 0c 80 00       	push   $0x800cde
  800d76:	e8 11 02 00 00       	call   800f8c <vprintfmt>
  800d7b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d7e:	a0 24 40 80 00       	mov    0x804024,%al
  800d83:	0f b6 c0             	movzbl %al,%eax
  800d86:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d8c:	83 ec 04             	sub    $0x4,%esp
  800d8f:	50                   	push   %eax
  800d90:	52                   	push   %edx
  800d91:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d97:	83 c0 08             	add    $0x8,%eax
  800d9a:	50                   	push   %eax
  800d9b:	e8 30 13 00 00       	call   8020d0 <sys_cputs>
  800da0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800da3:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800daa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <cprintf>:

int cprintf(const char *fmt, ...) {
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800db8:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800dbf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dce:	50                   	push   %eax
  800dcf:	e8 73 ff ff ff       	call   800d47 <vcprintf>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800de5:	e8 f7 14 00 00       	call   8022e1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800dea:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	83 ec 08             	sub    $0x8,%esp
  800df6:	ff 75 f4             	pushl  -0xc(%ebp)
  800df9:	50                   	push   %eax
  800dfa:	e8 48 ff ff ff       	call   800d47 <vcprintf>
  800dff:	83 c4 10             	add    $0x10,%esp
  800e02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800e05:	e8 f1 14 00 00       	call   8022fb <sys_enable_interrupt>
	return cnt;
  800e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	53                   	push   %ebx
  800e13:	83 ec 14             	sub    $0x14,%esp
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e22:	8b 45 18             	mov    0x18(%ebp),%eax
  800e25:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e2d:	77 55                	ja     800e84 <printnum+0x75>
  800e2f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e32:	72 05                	jb     800e39 <printnum+0x2a>
  800e34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e37:	77 4b                	ja     800e84 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e39:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e3c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	52                   	push   %edx
  800e48:	50                   	push   %eax
  800e49:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e4f:	e8 b0 18 00 00       	call   802704 <__udivdi3>
  800e54:	83 c4 10             	add    $0x10,%esp
  800e57:	83 ec 04             	sub    $0x4,%esp
  800e5a:	ff 75 20             	pushl  0x20(%ebp)
  800e5d:	53                   	push   %ebx
  800e5e:	ff 75 18             	pushl  0x18(%ebp)
  800e61:	52                   	push   %edx
  800e62:	50                   	push   %eax
  800e63:	ff 75 0c             	pushl  0xc(%ebp)
  800e66:	ff 75 08             	pushl  0x8(%ebp)
  800e69:	e8 a1 ff ff ff       	call   800e0f <printnum>
  800e6e:	83 c4 20             	add    $0x20,%esp
  800e71:	eb 1a                	jmp    800e8d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	ff 75 0c             	pushl  0xc(%ebp)
  800e79:	ff 75 20             	pushl  0x20(%ebp)
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	ff d0                	call   *%eax
  800e81:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e84:	ff 4d 1c             	decl   0x1c(%ebp)
  800e87:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e8b:	7f e6                	jg     800e73 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e8d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9b:	53                   	push   %ebx
  800e9c:	51                   	push   %ecx
  800e9d:	52                   	push   %edx
  800e9e:	50                   	push   %eax
  800e9f:	e8 70 19 00 00       	call   802814 <__umoddi3>
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	05 34 2f 80 00       	add    $0x802f34,%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f be c0             	movsbl %al,%eax
  800eb1:	83 ec 08             	sub    $0x8,%esp
  800eb4:	ff 75 0c             	pushl  0xc(%ebp)
  800eb7:	50                   	push   %eax
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	ff d0                	call   *%eax
  800ebd:	83 c4 10             	add    $0x10,%esp
}
  800ec0:	90                   	nop
  800ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ec9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ecd:	7e 1c                	jle    800eeb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8b 00                	mov    (%eax),%eax
  800ed4:	8d 50 08             	lea    0x8(%eax),%edx
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	89 10                	mov    %edx,(%eax)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8b 00                	mov    (%eax),%eax
  800ee1:	83 e8 08             	sub    $0x8,%eax
  800ee4:	8b 50 04             	mov    0x4(%eax),%edx
  800ee7:	8b 00                	mov    (%eax),%eax
  800ee9:	eb 40                	jmp    800f2b <getuint+0x65>
	else if (lflag)
  800eeb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eef:	74 1e                	je     800f0f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	8d 50 04             	lea    0x4(%eax),%edx
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 10                	mov    %edx,(%eax)
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8b 00                	mov    (%eax),%eax
  800f03:	83 e8 04             	sub    $0x4,%eax
  800f06:	8b 00                	mov    (%eax),%eax
  800f08:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0d:	eb 1c                	jmp    800f2b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f30:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f34:	7e 1c                	jle    800f52 <getint+0x25>
		return va_arg(*ap, long long);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	8d 50 08             	lea    0x8(%eax),%edx
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	89 10                	mov    %edx,(%eax)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8b 00                	mov    (%eax),%eax
  800f48:	83 e8 08             	sub    $0x8,%eax
  800f4b:	8b 50 04             	mov    0x4(%eax),%edx
  800f4e:	8b 00                	mov    (%eax),%eax
  800f50:	eb 38                	jmp    800f8a <getint+0x5d>
	else if (lflag)
  800f52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f56:	74 1a                	je     800f72 <getint+0x45>
		return va_arg(*ap, long);
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8b 00                	mov    (%eax),%eax
  800f5d:	8d 50 04             	lea    0x4(%eax),%edx
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	89 10                	mov    %edx,(%eax)
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8b 00                	mov    (%eax),%eax
  800f6a:	83 e8 04             	sub    $0x4,%eax
  800f6d:	8b 00                	mov    (%eax),%eax
  800f6f:	99                   	cltd   
  800f70:	eb 18                	jmp    800f8a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8b 00                	mov    (%eax),%eax
  800f77:	8d 50 04             	lea    0x4(%eax),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	89 10                	mov    %edx,(%eax)
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8b 00                	mov    (%eax),%eax
  800f84:	83 e8 04             	sub    $0x4,%eax
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	99                   	cltd   
}
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f94:	eb 17                	jmp    800fad <vprintfmt+0x21>
			if (ch == '\0')
  800f96:	85 db                	test   %ebx,%ebx
  800f98:	0f 84 af 03 00 00    	je     80134d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	53                   	push   %ebx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	8d 50 01             	lea    0x1(%eax),%edx
  800fb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 d8             	movzbl %al,%ebx
  800fbb:	83 fb 25             	cmp    $0x25,%ebx
  800fbe:	75 d6                	jne    800f96 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800fc0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800fc4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fcb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800fd2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800fd9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 d8             	movzbl %al,%ebx
  800fee:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ff1:	83 f8 55             	cmp    $0x55,%eax
  800ff4:	0f 87 2b 03 00 00    	ja     801325 <vprintfmt+0x399>
  800ffa:	8b 04 85 58 2f 80 00 	mov    0x802f58(,%eax,4),%eax
  801001:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801003:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801007:	eb d7                	jmp    800fe0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801009:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80100d:	eb d1                	jmp    800fe0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80100f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801016:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801019:	89 d0                	mov    %edx,%eax
  80101b:	c1 e0 02             	shl    $0x2,%eax
  80101e:	01 d0                	add    %edx,%eax
  801020:	01 c0                	add    %eax,%eax
  801022:	01 d8                	add    %ebx,%eax
  801024:	83 e8 30             	sub    $0x30,%eax
  801027:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801032:	83 fb 2f             	cmp    $0x2f,%ebx
  801035:	7e 3e                	jle    801075 <vprintfmt+0xe9>
  801037:	83 fb 39             	cmp    $0x39,%ebx
  80103a:	7f 39                	jg     801075 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80103c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80103f:	eb d5                	jmp    801016 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 00                	mov    (%eax),%eax
  801052:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801055:	eb 1f                	jmp    801076 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801057:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105b:	79 83                	jns    800fe0 <vprintfmt+0x54>
				width = 0;
  80105d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801064:	e9 77 ff ff ff       	jmp    800fe0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801069:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801070:	e9 6b ff ff ff       	jmp    800fe0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801075:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801076:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107a:	0f 89 60 ff ff ff    	jns    800fe0 <vprintfmt+0x54>
				width = precision, precision = -1;
  801080:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801086:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80108d:	e9 4e ff ff ff       	jmp    800fe0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801092:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801095:	e9 46 ff ff ff       	jmp    800fe0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80109a:	8b 45 14             	mov    0x14(%ebp),%eax
  80109d:	83 c0 04             	add    $0x4,%eax
  8010a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a6:	83 e8 04             	sub    $0x4,%eax
  8010a9:	8b 00                	mov    (%eax),%eax
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	50                   	push   %eax
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ba:	e9 89 02 00 00       	jmp    801348 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c2:	83 c0 04             	add    $0x4,%eax
  8010c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010cb:	83 e8 04             	sub    $0x4,%eax
  8010ce:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8010d0:	85 db                	test   %ebx,%ebx
  8010d2:	79 02                	jns    8010d6 <vprintfmt+0x14a>
				err = -err;
  8010d4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8010d6:	83 fb 64             	cmp    $0x64,%ebx
  8010d9:	7f 0b                	jg     8010e6 <vprintfmt+0x15a>
  8010db:	8b 34 9d a0 2d 80 00 	mov    0x802da0(,%ebx,4),%esi
  8010e2:	85 f6                	test   %esi,%esi
  8010e4:	75 19                	jne    8010ff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8010e6:	53                   	push   %ebx
  8010e7:	68 45 2f 80 00       	push   $0x802f45
  8010ec:	ff 75 0c             	pushl  0xc(%ebp)
  8010ef:	ff 75 08             	pushl  0x8(%ebp)
  8010f2:	e8 5e 02 00 00       	call   801355 <printfmt>
  8010f7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010fa:	e9 49 02 00 00       	jmp    801348 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010ff:	56                   	push   %esi
  801100:	68 4e 2f 80 00       	push   $0x802f4e
  801105:	ff 75 0c             	pushl  0xc(%ebp)
  801108:	ff 75 08             	pushl  0x8(%ebp)
  80110b:	e8 45 02 00 00       	call   801355 <printfmt>
  801110:	83 c4 10             	add    $0x10,%esp
			break;
  801113:	e9 30 02 00 00       	jmp    801348 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801118:	8b 45 14             	mov    0x14(%ebp),%eax
  80111b:	83 c0 04             	add    $0x4,%eax
  80111e:	89 45 14             	mov    %eax,0x14(%ebp)
  801121:	8b 45 14             	mov    0x14(%ebp),%eax
  801124:	83 e8 04             	sub    $0x4,%eax
  801127:	8b 30                	mov    (%eax),%esi
  801129:	85 f6                	test   %esi,%esi
  80112b:	75 05                	jne    801132 <vprintfmt+0x1a6>
				p = "(null)";
  80112d:	be 51 2f 80 00       	mov    $0x802f51,%esi
			if (width > 0 && padc != '-')
  801132:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801136:	7e 6d                	jle    8011a5 <vprintfmt+0x219>
  801138:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80113c:	74 67                	je     8011a5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80113e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	50                   	push   %eax
  801145:	56                   	push   %esi
  801146:	e8 0c 03 00 00       	call   801457 <strnlen>
  80114b:	83 c4 10             	add    $0x10,%esp
  80114e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801151:	eb 16                	jmp    801169 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801153:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	50                   	push   %eax
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	ff d0                	call   *%eax
  801163:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801166:	ff 4d e4             	decl   -0x1c(%ebp)
  801169:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80116d:	7f e4                	jg     801153 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80116f:	eb 34                	jmp    8011a5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801171:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801175:	74 1c                	je     801193 <vprintfmt+0x207>
  801177:	83 fb 1f             	cmp    $0x1f,%ebx
  80117a:	7e 05                	jle    801181 <vprintfmt+0x1f5>
  80117c:	83 fb 7e             	cmp    $0x7e,%ebx
  80117f:	7e 12                	jle    801193 <vprintfmt+0x207>
					putch('?', putdat);
  801181:	83 ec 08             	sub    $0x8,%esp
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	6a 3f                	push   $0x3f
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	ff d0                	call   *%eax
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	eb 0f                	jmp    8011a2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	ff 75 0c             	pushl  0xc(%ebp)
  801199:	53                   	push   %ebx
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	ff d0                	call   *%eax
  80119f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8011a5:	89 f0                	mov    %esi,%eax
  8011a7:	8d 70 01             	lea    0x1(%eax),%esi
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	0f be d8             	movsbl %al,%ebx
  8011af:	85 db                	test   %ebx,%ebx
  8011b1:	74 24                	je     8011d7 <vprintfmt+0x24b>
  8011b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011b7:	78 b8                	js     801171 <vprintfmt+0x1e5>
  8011b9:	ff 4d e0             	decl   -0x20(%ebp)
  8011bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011c0:	79 af                	jns    801171 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011c2:	eb 13                	jmp    8011d7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8011c4:	83 ec 08             	sub    $0x8,%esp
  8011c7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ca:	6a 20                	push   $0x20
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	ff d0                	call   *%eax
  8011d1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8011d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011db:	7f e7                	jg     8011c4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8011dd:	e9 66 01 00 00       	jmp    801348 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011e2:	83 ec 08             	sub    $0x8,%esp
  8011e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8011eb:	50                   	push   %eax
  8011ec:	e8 3c fd ff ff       	call   800f2d <getint>
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801200:	85 d2                	test   %edx,%edx
  801202:	79 23                	jns    801227 <vprintfmt+0x29b>
				putch('-', putdat);
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	ff 75 0c             	pushl  0xc(%ebp)
  80120a:	6a 2d                	push   $0x2d
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	ff d0                	call   *%eax
  801211:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121a:	f7 d8                	neg    %eax
  80121c:	83 d2 00             	adc    $0x0,%edx
  80121f:	f7 da                	neg    %edx
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801224:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801227:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80122e:	e9 bc 00 00 00       	jmp    8012ef <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801233:	83 ec 08             	sub    $0x8,%esp
  801236:	ff 75 e8             	pushl  -0x18(%ebp)
  801239:	8d 45 14             	lea    0x14(%ebp),%eax
  80123c:	50                   	push   %eax
  80123d:	e8 84 fc ff ff       	call   800ec6 <getuint>
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801248:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80124b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801252:	e9 98 00 00 00       	jmp    8012ef <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	6a 58                	push   $0x58
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	ff d0                	call   *%eax
  801264:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	6a 58                	push   $0x58
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	ff d0                	call   *%eax
  801274:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	ff 75 0c             	pushl  0xc(%ebp)
  80127d:	6a 58                	push   $0x58
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	ff d0                	call   *%eax
  801284:	83 c4 10             	add    $0x10,%esp
			break;
  801287:	e9 bc 00 00 00       	jmp    801348 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	6a 30                	push   $0x30
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	ff d0                	call   *%eax
  801299:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	ff 75 0c             	pushl  0xc(%ebp)
  8012a2:	6a 78                	push   $0x78
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8012af:	83 c0 04             	add    $0x4,%eax
  8012b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8012b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b8:	83 e8 04             	sub    $0x4,%eax
  8012bb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012c7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8012ce:	eb 1f                	jmp    8012ef <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8012d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	e8 e7 fb ff ff       	call   800ec6 <getuint>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8012e8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012ef:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012f6:	83 ec 04             	sub    $0x4,%esp
  8012f9:	52                   	push   %edx
  8012fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012fd:	50                   	push   %eax
  8012fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801301:	ff 75 f0             	pushl  -0x10(%ebp)
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	ff 75 08             	pushl  0x8(%ebp)
  80130a:	e8 00 fb ff ff       	call   800e0f <printnum>
  80130f:	83 c4 20             	add    $0x20,%esp
			break;
  801312:	eb 34                	jmp    801348 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	53                   	push   %ebx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	ff d0                	call   *%eax
  801320:	83 c4 10             	add    $0x10,%esp
			break;
  801323:	eb 23                	jmp    801348 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801325:	83 ec 08             	sub    $0x8,%esp
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	6a 25                	push   $0x25
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	ff d0                	call   *%eax
  801332:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801335:	ff 4d 10             	decl   0x10(%ebp)
  801338:	eb 03                	jmp    80133d <vprintfmt+0x3b1>
  80133a:	ff 4d 10             	decl   0x10(%ebp)
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	48                   	dec    %eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	3c 25                	cmp    $0x25,%al
  801345:	75 f3                	jne    80133a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801347:	90                   	nop
		}
	}
  801348:	e9 47 fc ff ff       	jmp    800f94 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80134d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80134e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    

00801355 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80135b:	8d 45 10             	lea    0x10(%ebp),%eax
  80135e:	83 c0 04             	add    $0x4,%eax
  801361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801364:	8b 45 10             	mov    0x10(%ebp),%eax
  801367:	ff 75 f4             	pushl  -0xc(%ebp)
  80136a:	50                   	push   %eax
  80136b:	ff 75 0c             	pushl  0xc(%ebp)
  80136e:	ff 75 08             	pushl  0x8(%ebp)
  801371:	e8 16 fc ff ff       	call   800f8c <vprintfmt>
  801376:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801379:	90                   	nop
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	8b 40 08             	mov    0x8(%eax),%eax
  801385:	8d 50 01             	lea    0x1(%eax),%edx
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	8b 10                	mov    (%eax),%edx
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	8b 40 04             	mov    0x4(%eax),%eax
  801399:	39 c2                	cmp    %eax,%edx
  80139b:	73 12                	jae    8013af <sprintputch+0x33>
		*b->buf++ = ch;
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	8b 00                	mov    (%eax),%eax
  8013a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a8:	89 0a                	mov    %ecx,(%edx)
  8013aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
}
  8013af:	90                   	nop
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    

008013b2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d7:	74 06                	je     8013df <vsnprintf+0x2d>
  8013d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013dd:	7f 07                	jg     8013e6 <vsnprintf+0x34>
		return -E_INVAL;
  8013df:	b8 03 00 00 00       	mov    $0x3,%eax
  8013e4:	eb 20                	jmp    801406 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013e6:	ff 75 14             	pushl  0x14(%ebp)
  8013e9:	ff 75 10             	pushl  0x10(%ebp)
  8013ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	68 7c 13 80 00       	push   $0x80137c
  8013f5:	e8 92 fb ff ff       	call   800f8c <vprintfmt>
  8013fa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801400:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801403:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80140e:	8d 45 10             	lea    0x10(%ebp),%eax
  801411:	83 c0 04             	add    $0x4,%eax
  801414:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	ff 75 f4             	pushl  -0xc(%ebp)
  80141d:	50                   	push   %eax
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	ff 75 08             	pushl  0x8(%ebp)
  801424:	e8 89 ff ff ff       	call   8013b2 <vsnprintf>
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80143a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801441:	eb 06                	jmp    801449 <strlen+0x15>
		n++;
  801443:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801446:	ff 45 08             	incl   0x8(%ebp)
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	84 c0                	test   %al,%al
  801450:	75 f1                	jne    801443 <strlen+0xf>
		n++;
	return n;
  801452:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801464:	eb 09                	jmp    80146f <strnlen+0x18>
		n++;
  801466:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801469:	ff 45 08             	incl   0x8(%ebp)
  80146c:	ff 4d 0c             	decl   0xc(%ebp)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 09                	je     80147e <strnlen+0x27>
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	84 c0                	test   %al,%al
  80147c:	75 e8                	jne    801466 <strnlen+0xf>
		n++;
	return n;
  80147e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80148f:	90                   	nop
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	8d 50 01             	lea    0x1(%eax),%edx
  801496:	89 55 08             	mov    %edx,0x8(%ebp)
  801499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80149f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014a2:	8a 12                	mov    (%edx),%dl
  8014a4:	88 10                	mov    %dl,(%eax)
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	75 e4                	jne    801490 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c4:	eb 1f                	jmp    8014e5 <strncpy+0x34>
		*dst++ = *src;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8d 50 01             	lea    0x1(%eax),%edx
  8014cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8014cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d2:	8a 12                	mov    (%edx),%dl
  8014d4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	74 03                	je     8014e2 <strncpy+0x31>
			src++;
  8014df:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014e2:	ff 45 fc             	incl   -0x4(%ebp)
  8014e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014eb:	72 d9                	jb     8014c6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 30                	je     801534 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801504:	eb 16                	jmp    80151c <strlcpy+0x2a>
			*dst++ = *src++;
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8d 50 01             	lea    0x1(%eax),%edx
  80150c:	89 55 08             	mov    %edx,0x8(%ebp)
  80150f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801512:	8d 4a 01             	lea    0x1(%edx),%ecx
  801515:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801518:	8a 12                	mov    (%edx),%dl
  80151a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80151c:	ff 4d 10             	decl   0x10(%ebp)
  80151f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801523:	74 09                	je     80152e <strlcpy+0x3c>
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	75 d8                	jne    801506 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801534:	8b 55 08             	mov    0x8(%ebp),%edx
  801537:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153a:	29 c2                	sub    %eax,%edx
  80153c:	89 d0                	mov    %edx,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801543:	eb 06                	jmp    80154b <strcmp+0xb>
		p++, q++;
  801545:	ff 45 08             	incl   0x8(%ebp)
  801548:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	84 c0                	test   %al,%al
  801552:	74 0e                	je     801562 <strcmp+0x22>
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 10                	mov    (%eax),%dl
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	38 c2                	cmp    %al,%dl
  801560:	74 e3                	je     801545 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 d0             	movzbl %al,%edx
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	29 c2                	sub    %eax,%edx
  801574:	89 d0                	mov    %edx,%eax
}
  801576:	5d                   	pop    %ebp
  801577:	c3                   	ret    

00801578 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80157b:	eb 09                	jmp    801586 <strncmp+0xe>
		n--, p++, q++;
  80157d:	ff 4d 10             	decl   0x10(%ebp)
  801580:	ff 45 08             	incl   0x8(%ebp)
  801583:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801586:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158a:	74 17                	je     8015a3 <strncmp+0x2b>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	84 c0                	test   %al,%al
  801593:	74 0e                	je     8015a3 <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 10                	mov    (%eax),%dl
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	38 c2                	cmp    %al,%dl
  8015a1:	74 da                	je     80157d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a7:	75 07                	jne    8015b0 <strncmp+0x38>
		return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ae:	eb 14                	jmp    8015c4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	0f b6 d0             	movzbl %al,%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8a 00                	mov    (%eax),%al
  8015bd:	0f b6 c0             	movzbl %al,%eax
  8015c0:	29 c2                	sub    %eax,%edx
  8015c2:	89 d0                	mov    %edx,%eax
}
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015d2:	eb 12                	jmp    8015e6 <strchr+0x20>
		if (*s == c)
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8a 00                	mov    (%eax),%al
  8015d9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015dc:	75 05                	jne    8015e3 <strchr+0x1d>
			return (char *) s;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	eb 11                	jmp    8015f4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015e3:	ff 45 08             	incl   0x8(%ebp)
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8a 00                	mov    (%eax),%al
  8015eb:	84 c0                	test   %al,%al
  8015ed:	75 e5                	jne    8015d4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801602:	eb 0d                	jmp    801611 <strfind+0x1b>
		if (*s == c)
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80160c:	74 0e                	je     80161c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80160e:	ff 45 08             	incl   0x8(%ebp)
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	84 c0                	test   %al,%al
  801618:	75 ea                	jne    801604 <strfind+0xe>
  80161a:	eb 01                	jmp    80161d <strfind+0x27>
		if (*s == c)
			break;
  80161c:	90                   	nop
	return (char *) s;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801634:	eb 0e                	jmp    801644 <memset+0x22>
		*p++ = c;
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8d 50 01             	lea    0x1(%eax),%edx
  80163c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801644:	ff 4d f8             	decl   -0x8(%ebp)
  801647:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80164b:	79 e9                	jns    801636 <memset+0x14>
		*p++ = c;

	return v;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801664:	eb 16                	jmp    80167c <memcpy+0x2a>
		*d++ = *s++;
  801666:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801669:	8d 50 01             	lea    0x1(%eax),%edx
  80166c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80166f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801672:	8d 4a 01             	lea    0x1(%edx),%ecx
  801675:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801678:	8a 12                	mov    (%edx),%dl
  80167a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80167c:	8b 45 10             	mov    0x10(%ebp),%eax
  80167f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801682:	89 55 10             	mov    %edx,0x10(%ebp)
  801685:	85 c0                	test   %eax,%eax
  801687:	75 dd                	jne    801666 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016a6:	73 50                	jae    8016f8 <memmove+0x6a>
  8016a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	01 d0                	add    %edx,%eax
  8016b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016b3:	76 43                	jbe    8016f8 <memmove+0x6a>
		s += n;
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016c1:	eb 10                	jmp    8016d3 <memmove+0x45>
			*--d = *--s;
  8016c3:	ff 4d f8             	decl   -0x8(%ebp)
  8016c6:	ff 4d fc             	decl   -0x4(%ebp)
  8016c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016cc:	8a 10                	mov    (%eax),%dl
  8016ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	75 e3                	jne    8016c3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e0:	eb 23                	jmp    801705 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e5:	8d 50 01             	lea    0x1(%eax),%edx
  8016e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016f1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016f4:	8a 12                	mov    (%edx),%dl
  8016f6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801701:	85 c0                	test   %eax,%eax
  801703:	75 dd                	jne    8016e2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80171c:	eb 2a                	jmp    801748 <memcmp+0x3e>
		if (*s1 != *s2)
  80171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 16                	je     801742 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	0f b6 d0             	movzbl %al,%edx
  801734:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	0f b6 c0             	movzbl %al,%eax
  80173c:	29 c2                	sub    %eax,%edx
  80173e:	89 d0                	mov    %edx,%eax
  801740:	eb 18                	jmp    80175a <memcmp+0x50>
		s1++, s2++;
  801742:	ff 45 fc             	incl   -0x4(%ebp)
  801745:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801748:	8b 45 10             	mov    0x10(%ebp),%eax
  80174b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80174e:	89 55 10             	mov    %edx,0x10(%ebp)
  801751:	85 c0                	test   %eax,%eax
  801753:	75 c9                	jne    80171e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801762:	8b 55 08             	mov    0x8(%ebp),%edx
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 d0                	add    %edx,%eax
  80176a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80176d:	eb 15                	jmp    801784 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f b6 d0             	movzbl %al,%edx
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	0f b6 c0             	movzbl %al,%eax
  80177d:	39 c2                	cmp    %eax,%edx
  80177f:	74 0d                	je     80178e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801781:	ff 45 08             	incl   0x8(%ebp)
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80178a:	72 e3                	jb     80176f <memfind+0x13>
  80178c:	eb 01                	jmp    80178f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80178e:	90                   	nop
	return (void *) s;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80179a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a8:	eb 03                	jmp    8017ad <strtol+0x19>
		s++;
  8017aa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 20                	cmp    $0x20,%al
  8017b4:	74 f4                	je     8017aa <strtol+0x16>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 09                	cmp    $0x9,%al
  8017bd:	74 eb                	je     8017aa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 2b                	cmp    $0x2b,%al
  8017c6:	75 05                	jne    8017cd <strtol+0x39>
		s++;
  8017c8:	ff 45 08             	incl   0x8(%ebp)
  8017cb:	eb 13                	jmp    8017e0 <strtol+0x4c>
	else if (*s == '-')
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	3c 2d                	cmp    $0x2d,%al
  8017d4:	75 0a                	jne    8017e0 <strtol+0x4c>
		s++, neg = 1;
  8017d6:	ff 45 08             	incl   0x8(%ebp)
  8017d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e4:	74 06                	je     8017ec <strtol+0x58>
  8017e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017ea:	75 20                	jne    80180c <strtol+0x78>
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	3c 30                	cmp    $0x30,%al
  8017f3:	75 17                	jne    80180c <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	40                   	inc    %eax
  8017f9:	8a 00                	mov    (%eax),%al
  8017fb:	3c 78                	cmp    $0x78,%al
  8017fd:	75 0d                	jne    80180c <strtol+0x78>
		s += 2, base = 16;
  8017ff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801803:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80180a:	eb 28                	jmp    801834 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80180c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801810:	75 15                	jne    801827 <strtol+0x93>
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	3c 30                	cmp    $0x30,%al
  801819:	75 0c                	jne    801827 <strtol+0x93>
		s++, base = 8;
  80181b:	ff 45 08             	incl   0x8(%ebp)
  80181e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801825:	eb 0d                	jmp    801834 <strtol+0xa0>
	else if (base == 0)
  801827:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182b:	75 07                	jne    801834 <strtol+0xa0>
		base = 10;
  80182d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8a 00                	mov    (%eax),%al
  801839:	3c 2f                	cmp    $0x2f,%al
  80183b:	7e 19                	jle    801856 <strtol+0xc2>
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 39                	cmp    $0x39,%al
  801844:	7f 10                	jg     801856 <strtol+0xc2>
			dig = *s - '0';
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	83 e8 30             	sub    $0x30,%eax
  801851:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801854:	eb 42                	jmp    801898 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	3c 60                	cmp    $0x60,%al
  80185d:	7e 19                	jle    801878 <strtol+0xe4>
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 7a                	cmp    $0x7a,%al
  801866:	7f 10                	jg     801878 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	0f be c0             	movsbl %al,%eax
  801870:	83 e8 57             	sub    $0x57,%eax
  801873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801876:	eb 20                	jmp    801898 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	8a 00                	mov    (%eax),%al
  80187d:	3c 40                	cmp    $0x40,%al
  80187f:	7e 39                	jle    8018ba <strtol+0x126>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 5a                	cmp    $0x5a,%al
  801888:	7f 30                	jg     8018ba <strtol+0x126>
			dig = *s - 'A' + 10;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	0f be c0             	movsbl %al,%eax
  801892:	83 e8 37             	sub    $0x37,%eax
  801895:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80189e:	7d 19                	jge    8018b9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a0:	ff 45 08             	incl   0x8(%ebp)
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018b4:	e9 7b ff ff ff       	jmp    801834 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018b9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018be:	74 08                	je     8018c8 <strtol+0x134>
		*endptr = (char *) s;
  8018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018cc:	74 07                	je     8018d5 <strtol+0x141>
  8018ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d1:	f7 d8                	neg    %eax
  8018d3:	eb 03                	jmp    8018d8 <strtol+0x144>
  8018d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <ltostr>:

void
ltostr(long value, char *str)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f2:	79 13                	jns    801907 <ltostr+0x2d>
	{
		neg = 1;
  8018f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801901:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801904:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80190f:	99                   	cltd   
  801910:	f7 f9                	idiv   %ecx
  801912:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801915:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80191e:	89 c2                	mov    %eax,%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801928:	83 c2 30             	add    $0x30,%edx
  80192b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80192d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801930:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801935:	f7 e9                	imul   %ecx
  801937:	c1 fa 02             	sar    $0x2,%edx
  80193a:	89 c8                	mov    %ecx,%eax
  80193c:	c1 f8 1f             	sar    $0x1f,%eax
  80193f:	29 c2                	sub    %eax,%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801946:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801949:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80194e:	f7 e9                	imul   %ecx
  801950:	c1 fa 02             	sar    $0x2,%edx
  801953:	89 c8                	mov    %ecx,%eax
  801955:	c1 f8 1f             	sar    $0x1f,%eax
  801958:	29 c2                	sub    %eax,%edx
  80195a:	89 d0                	mov    %edx,%eax
  80195c:	c1 e0 02             	shl    $0x2,%eax
  80195f:	01 d0                	add    %edx,%eax
  801961:	01 c0                	add    %eax,%eax
  801963:	29 c1                	sub    %eax,%ecx
  801965:	89 ca                	mov    %ecx,%edx
  801967:	85 d2                	test   %edx,%edx
  801969:	75 9c                	jne    801907 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80196b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801972:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801975:	48                   	dec    %eax
  801976:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801979:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80197d:	74 3d                	je     8019bc <ltostr+0xe2>
		start = 1 ;
  80197f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801986:	eb 34                	jmp    8019bc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 d0                	add    %edx,%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199b:	01 c2                	add    %eax,%edx
  80199d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a3:	01 c8                	add    %ecx,%eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019b4:	88 02                	mov    %al,(%edx)
		start++ ;
  8019b6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019b9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c2:	7c c4                	jl     801988 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	e8 54 fa ff ff       	call   801434 <strlen>
  8019e0:	83 c4 04             	add    $0x4,%esp
  8019e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	e8 46 fa ff ff       	call   801434 <strlen>
  8019ee:	83 c4 04             	add    $0x4,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a02:	eb 17                	jmp    801a1b <strcconcat+0x49>
		final[s] = str1[s] ;
  801a04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a07:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0a:	01 c2                	add    %eax,%edx
  801a0c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	01 c8                	add    %ecx,%eax
  801a14:	8a 00                	mov    (%eax),%al
  801a16:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a18:	ff 45 fc             	incl   -0x4(%ebp)
  801a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a21:	7c e1                	jl     801a04 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a31:	eb 1f                	jmp    801a52 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a36:	8d 50 01             	lea    0x1(%eax),%edx
  801a39:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a3c:	89 c2                	mov    %eax,%edx
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	01 c2                	add    %eax,%edx
  801a43:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	01 c8                	add    %ecx,%eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a4f:	ff 45 f8             	incl   -0x8(%ebp)
  801a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a58:	7c d9                	jl     801a33 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a60:	01 d0                	add    %edx,%eax
  801a62:	c6 00 00             	movb   $0x0,(%eax)
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	8b 00                	mov    (%eax),%eax
  801a79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a80:	8b 45 10             	mov    0x10(%ebp),%eax
  801a83:	01 d0                	add    %edx,%eax
  801a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a8b:	eb 0c                	jmp    801a99 <strsplit+0x31>
			*string++ = 0;
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	8d 50 01             	lea    0x1(%eax),%edx
  801a93:	89 55 08             	mov    %edx,0x8(%ebp)
  801a96:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 18                	je     801aba <strsplit+0x52>
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	0f be c0             	movsbl %al,%eax
  801aaa:	50                   	push   %eax
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	e8 13 fb ff ff       	call   8015c6 <strchr>
  801ab3:	83 c4 08             	add    $0x8,%esp
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	75 d3                	jne    801a8d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	8a 00                	mov    (%eax),%al
  801abf:	84 c0                	test   %al,%al
  801ac1:	74 5a                	je     801b1d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	83 f8 0f             	cmp    $0xf,%eax
  801acb:	75 07                	jne    801ad4 <strsplit+0x6c>
		{
			return 0;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad2:	eb 66                	jmp    801b3a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad7:	8b 00                	mov    (%eax),%eax
  801ad9:	8d 48 01             	lea    0x1(%eax),%ecx
  801adc:	8b 55 14             	mov    0x14(%ebp),%edx
  801adf:	89 0a                	mov    %ecx,(%edx)
  801ae1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801af2:	eb 03                	jmp    801af7 <strsplit+0x8f>
			string++;
  801af4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	8a 00                	mov    (%eax),%al
  801afc:	84 c0                	test   %al,%al
  801afe:	74 8b                	je     801a8b <strsplit+0x23>
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	0f be c0             	movsbl %al,%eax
  801b08:	50                   	push   %eax
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	e8 b5 fa ff ff       	call   8015c6 <strchr>
  801b11:	83 c4 08             	add    $0x8,%esp
  801b14:	85 c0                	test   %eax,%eax
  801b16:	74 dc                	je     801af4 <strsplit+0x8c>
			string++;
	}
  801b18:	e9 6e ff ff ff       	jmp    801a8b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b1d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b35:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801b42:	a1 28 40 80 00       	mov    0x804028,%eax
  801b47:	85 c0                	test   %eax,%eax
  801b49:	75 33                	jne    801b7e <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801b4b:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801b52:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801b55:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801b5c:	00 00 a0 
		spaces[0].pages = numPages;
  801b5f:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801b66:	00 02 00 
		spaces[0].isFree = 1;
  801b69:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801b70:	00 00 00 
		arraySize++;
  801b73:	a1 28 40 80 00       	mov    0x804028,%eax
  801b78:	40                   	inc    %eax
  801b79:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801b7e:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801b85:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801b8c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801b93:	8b 55 08             	mov    0x8(%ebp),%edx
  801b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b99:	01 d0                	add    %edx,%eax
  801b9b:	48                   	dec    %eax
  801b9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba7:	f7 75 e8             	divl   -0x18(%ebp)
  801baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bad:	29 d0                	sub    %edx,%eax
  801baf:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	c1 e8 0c             	shr    $0xc,%eax
  801bb8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801bbb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801bc2:	eb 57                	jmp    801c1b <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc7:	c1 e0 04             	shl    $0x4,%eax
  801bca:	05 2c 41 80 00       	add    $0x80412c,%eax
  801bcf:	8b 00                	mov    (%eax),%eax
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	74 42                	je     801c17 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd8:	c1 e0 04             	shl    $0x4,%eax
  801bdb:	05 28 41 80 00       	add    $0x804128,%eax
  801be0:	8b 00                	mov    (%eax),%eax
  801be2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801be5:	7c 31                	jl     801c18 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bea:	c1 e0 04             	shl    $0x4,%eax
  801bed:	05 28 41 80 00       	add    $0x804128,%eax
  801bf2:	8b 00                	mov    (%eax),%eax
  801bf4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801bf7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bfa:	7d 1c                	jge    801c18 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bff:	c1 e0 04             	shl    $0x4,%eax
  801c02:	05 28 41 80 00       	add    $0x804128,%eax
  801c07:	8b 00                	mov    (%eax),%eax
  801c09:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c15:	eb 01                	jmp    801c18 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801c17:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801c18:	ff 45 ec             	incl   -0x14(%ebp)
  801c1b:	a1 28 40 80 00       	mov    0x804028,%eax
  801c20:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801c23:	7c 9f                	jl     801bc4 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801c25:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c29:	75 0a                	jne    801c35 <malloc+0xf9>
	{
		return NULL;
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	e9 34 01 00 00       	jmp    801d69 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c38:	c1 e0 04             	shl    $0x4,%eax
  801c3b:	05 28 41 80 00       	add    $0x804128,%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801c45:	75 38                	jne    801c7f <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4a:	c1 e0 04             	shl    $0x4,%eax
  801c4d:	05 2c 41 80 00       	add    $0x80412c,%eax
  801c52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5b:	c1 e0 0c             	shl    $0xc,%eax
  801c5e:	89 c2                	mov    %eax,%edx
  801c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c63:	c1 e0 04             	shl    $0x4,%eax
  801c66:	05 20 41 80 00       	add    $0x804120,%eax
  801c6b:	8b 00                	mov    (%eax),%eax
  801c6d:	83 ec 08             	sub    $0x8,%esp
  801c70:	52                   	push   %edx
  801c71:	50                   	push   %eax
  801c72:	e8 01 06 00 00       	call   802278 <sys_allocateMem>
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	e9 dd 00 00 00       	jmp    801d5c <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c82:	c1 e0 04             	shl    $0x4,%eax
  801c85:	05 20 41 80 00       	add    $0x804120,%eax
  801c8a:	8b 00                	mov    (%eax),%eax
  801c8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8f:	c1 e2 0c             	shl    $0xc,%edx
  801c92:	01 d0                	add    %edx,%eax
  801c94:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801c97:	a1 28 40 80 00       	mov    0x804028,%eax
  801c9c:	c1 e0 04             	shl    $0x4,%eax
  801c9f:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  801ca5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ca8:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801caa:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb3:	c1 e0 04             	shl    $0x4,%eax
  801cb6:	05 24 41 80 00       	add    $0x804124,%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	c1 e2 04             	shl    $0x4,%edx
  801cc0:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801cc6:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801cc8:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd1:	c1 e0 04             	shl    $0x4,%eax
  801cd4:	05 28 41 80 00       	add    $0x804128,%eax
  801cd9:	8b 00                	mov    (%eax),%eax
  801cdb:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801cde:	c1 e2 04             	shl    $0x4,%edx
  801ce1:	81 c2 28 41 80 00    	add    $0x804128,%edx
  801ce7:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801ce9:	a1 28 40 80 00       	mov    0x804028,%eax
  801cee:	c1 e0 04             	shl    $0x4,%eax
  801cf1:	05 2c 41 80 00       	add    $0x80412c,%eax
  801cf6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801cfc:	a1 28 40 80 00       	mov    0x804028,%eax
  801d01:	40                   	inc    %eax
  801d02:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0a:	c1 e0 04             	shl    $0x4,%eax
  801d0d:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  801d13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d16:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	c1 e0 04             	shl    $0x4,%eax
  801d1e:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  801d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d27:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2c:	c1 e0 04             	shl    $0x4,%eax
  801d2f:	05 2c 41 80 00       	add    $0x80412c,%eax
  801d34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801d3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d3d:	c1 e0 0c             	shl    $0xc,%eax
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d45:	c1 e0 04             	shl    $0x4,%eax
  801d48:	05 20 41 80 00       	add    $0x804120,%eax
  801d4d:	8b 00                	mov    (%eax),%eax
  801d4f:	83 ec 08             	sub    $0x8,%esp
  801d52:	52                   	push   %edx
  801d53:	50                   	push   %eax
  801d54:	e8 1f 05 00 00       	call   802278 <sys_allocateMem>
  801d59:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	c1 e0 04             	shl    $0x4,%eax
  801d62:	05 20 41 80 00       	add    $0x804120,%eax
  801d67:	8b 00                	mov    (%eax),%eax
	}


}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801d71:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801d78:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801d7f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d86:	eb 3f                	jmp    801dc7 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8b:	c1 e0 04             	shl    $0x4,%eax
  801d8e:	05 20 41 80 00       	add    $0x804120,%eax
  801d93:	8b 00                	mov    (%eax),%eax
  801d95:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d98:	75 2a                	jne    801dc4 <free+0x59>
		{
			index=i;
  801d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da3:	c1 e0 04             	shl    $0x4,%eax
  801da6:	05 28 41 80 00       	add    $0x804128,%eax
  801dab:	8b 00                	mov    (%eax),%eax
  801dad:	c1 e0 0c             	shl    $0xc,%eax
  801db0:	89 c2                	mov    %eax,%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	83 ec 08             	sub    $0x8,%esp
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	e8 9d 04 00 00       	call   80225c <sys_freeMem>
  801dbf:	83 c4 10             	add    $0x10,%esp
			break;
  801dc2:	eb 0d                	jmp    801dd1 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801dc4:	ff 45 ec             	incl   -0x14(%ebp)
  801dc7:	a1 28 40 80 00       	mov    0x804028,%eax
  801dcc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801dcf:	7c b7                	jl     801d88 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801dd1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801dd5:	75 17                	jne    801dee <free+0x83>
	{
		panic("Error");
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	68 b0 30 80 00       	push   $0x8030b0
  801ddf:	68 81 00 00 00       	push   $0x81
  801de4:	68 b6 30 80 00       	push   $0x8030b6
  801de9:	e8 22 ed ff ff       	call   800b10 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801dee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801df5:	e9 cc 00 00 00       	jmp    801ec6 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dfd:	c1 e0 04             	shl    $0x4,%eax
  801e00:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e05:	8b 00                	mov    (%eax),%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	0f 84 b3 00 00 00    	je     801ec2 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	c1 e0 04             	shl    $0x4,%eax
  801e15:	05 20 41 80 00       	add    $0x804120,%eax
  801e1a:	8b 10                	mov    (%eax),%edx
  801e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e1f:	c1 e0 04             	shl    $0x4,%eax
  801e22:	05 24 41 80 00       	add    $0x804124,%eax
  801e27:	8b 00                	mov    (%eax),%eax
  801e29:	39 c2                	cmp    %eax,%edx
  801e2b:	0f 85 92 00 00 00    	jne    801ec3 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	c1 e0 04             	shl    $0x4,%eax
  801e37:	05 24 41 80 00       	add    $0x804124,%eax
  801e3c:	8b 00                	mov    (%eax),%eax
  801e3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e41:	c1 e2 04             	shl    $0x4,%edx
  801e44:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801e4a:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e4f:	c1 e0 04             	shl    $0x4,%eax
  801e52:	05 28 41 80 00       	add    $0x804128,%eax
  801e57:	8b 10                	mov    (%eax),%edx
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	c1 e0 04             	shl    $0x4,%eax
  801e5f:	05 28 41 80 00       	add    $0x804128,%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	01 c2                	add    %eax,%edx
  801e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e6b:	c1 e0 04             	shl    $0x4,%eax
  801e6e:	05 28 41 80 00       	add    $0x804128,%eax
  801e73:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e78:	c1 e0 04             	shl    $0x4,%eax
  801e7b:	05 20 41 80 00       	add    $0x804120,%eax
  801e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	c1 e0 04             	shl    $0x4,%eax
  801e8c:	05 24 41 80 00       	add    $0x804124,%eax
  801e91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9a:	c1 e0 04             	shl    $0x4,%eax
  801e9d:	05 28 41 80 00       	add    $0x804128,%eax
  801ea2:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	c1 e0 04             	shl    $0x4,%eax
  801eae:	05 2c 41 80 00       	add    $0x80412c,%eax
  801eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801eb9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801ec0:	eb 12                	jmp    801ed4 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801ec2:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ec3:	ff 45 e8             	incl   -0x18(%ebp)
  801ec6:	a1 28 40 80 00       	mov    0x804028,%eax
  801ecb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801ece:	0f 8c 26 ff ff ff    	jl     801dfa <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ed4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801edb:	e9 cc 00 00 00       	jmp    801fac <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ee3:	c1 e0 04             	shl    $0x4,%eax
  801ee6:	05 2c 41 80 00       	add    $0x80412c,%eax
  801eeb:	8b 00                	mov    (%eax),%eax
  801eed:	85 c0                	test   %eax,%eax
  801eef:	0f 84 b3 00 00 00    	je     801fa8 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	c1 e0 04             	shl    $0x4,%eax
  801efb:	05 24 41 80 00       	add    $0x804124,%eax
  801f00:	8b 10                	mov    (%eax),%edx
  801f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f05:	c1 e0 04             	shl    $0x4,%eax
  801f08:	05 20 41 80 00       	add    $0x804120,%eax
  801f0d:	8b 00                	mov    (%eax),%eax
  801f0f:	39 c2                	cmp    %eax,%edx
  801f11:	0f 85 92 00 00 00    	jne    801fa9 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1a:	c1 e0 04             	shl    $0x4,%eax
  801f1d:	05 20 41 80 00       	add    $0x804120,%eax
  801f22:	8b 00                	mov    (%eax),%eax
  801f24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f27:	c1 e2 04             	shl    $0x4,%edx
  801f2a:	81 c2 20 41 80 00    	add    $0x804120,%edx
  801f30:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f35:	c1 e0 04             	shl    $0x4,%eax
  801f38:	05 28 41 80 00       	add    $0x804128,%eax
  801f3d:	8b 10                	mov    (%eax),%edx
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	c1 e0 04             	shl    $0x4,%eax
  801f45:	05 28 41 80 00       	add    $0x804128,%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	01 c2                	add    %eax,%edx
  801f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f51:	c1 e0 04             	shl    $0x4,%eax
  801f54:	05 28 41 80 00       	add    $0x804128,%eax
  801f59:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	c1 e0 04             	shl    $0x4,%eax
  801f61:	05 20 41 80 00       	add    $0x804120,%eax
  801f66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	c1 e0 04             	shl    $0x4,%eax
  801f72:	05 24 41 80 00       	add    $0x804124,%eax
  801f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	c1 e0 04             	shl    $0x4,%eax
  801f83:	05 28 41 80 00       	add    $0x804128,%eax
  801f88:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	c1 e0 04             	shl    $0x4,%eax
  801f94:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801f9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801fa6:	eb 12                	jmp    801fba <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801fa8:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801fa9:	ff 45 e4             	incl   -0x1c(%ebp)
  801fac:	a1 28 40 80 00       	mov    0x804028,%eax
  801fb1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb4:	0f 8c 26 ff ff ff    	jl     801ee0 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801fba:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801fbe:	75 11                	jne    801fd1 <free+0x266>
	{
		spaces[index].isFree = 1;
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	c1 e0 04             	shl    $0x4,%eax
  801fc6:	05 2c 41 80 00       	add    $0x80412c,%eax
  801fcb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801fd1:	90                   	nop
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 18             	sub    $0x18,%esp
  801fda:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdd:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 c4 30 80 00       	push   $0x8030c4
  801fe8:	68 b9 00 00 00       	push   $0xb9
  801fed:	68 b6 30 80 00       	push   $0x8030b6
  801ff2:	e8 19 eb ff ff       	call   800b10 <_panic>

00801ff7 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 c4 30 80 00       	push   $0x8030c4
  802005:	68 bf 00 00 00       	push   $0xbf
  80200a:	68 b6 30 80 00       	push   $0x8030b6
  80200f:	e8 fc ea ff ff       	call   800b10 <_panic>

00802014 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	68 c4 30 80 00       	push   $0x8030c4
  802022:	68 c5 00 00 00       	push   $0xc5
  802027:	68 b6 30 80 00       	push   $0x8030b6
  80202c:	e8 df ea ff ff       	call   800b10 <_panic>

00802031 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	68 c4 30 80 00       	push   $0x8030c4
  80203f:	68 ca 00 00 00       	push   $0xca
  802044:	68 b6 30 80 00       	push   $0x8030b6
  802049:	e8 c2 ea ff ff       	call   800b10 <_panic>

0080204e <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	68 c4 30 80 00       	push   $0x8030c4
  80205c:	68 d0 00 00 00       	push   $0xd0
  802061:	68 b6 30 80 00       	push   $0x8030b6
  802066:	e8 a5 ea ff ff       	call   800b10 <_panic>

0080206b <shrink>:
}
void shrink(uint32 newSize)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	68 c4 30 80 00       	push   $0x8030c4
  802079:	68 d4 00 00 00       	push   $0xd4
  80207e:	68 b6 30 80 00       	push   $0x8030b6
  802083:	e8 88 ea ff ff       	call   800b10 <_panic>

00802088 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	68 c4 30 80 00       	push   $0x8030c4
  802096:	68 d9 00 00 00       	push   $0xd9
  80209b:	68 b6 30 80 00       	push   $0x8030b6
  8020a0:	e8 6b ea ff ff       	call   800b10 <_panic>

008020a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	57                   	push   %edi
  8020a9:	56                   	push   %esi
  8020aa:	53                   	push   %ebx
  8020ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020c0:	cd 30                	int    $0x30
  8020c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5f                   	pop    %edi
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    

008020d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 04             	sub    $0x4,%esp
  8020d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	52                   	push   %edx
  8020e8:	ff 75 0c             	pushl  0xc(%ebp)
  8020eb:	50                   	push   %eax
  8020ec:	6a 00                	push   $0x0
  8020ee:	e8 b2 ff ff ff       	call   8020a5 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	90                   	nop
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 01                	push   $0x1
  802108:	e8 98 ff ff ff       	call   8020a5 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	50                   	push   %eax
  802121:	6a 05                	push   $0x5
  802123:	e8 7d ff ff ff       	call   8020a5 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 02                	push   $0x2
  80213c:	e8 64 ff ff ff       	call   8020a5 <syscall>
  802141:	83 c4 18             	add    $0x18,%esp
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 03                	push   $0x3
  802155:	e8 4b ff ff ff       	call   8020a5 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 04                	push   $0x4
  80216e:	e8 32 ff ff ff       	call   8020a5 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_env_exit>:


void sys_env_exit(void)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 06                	push   $0x6
  802187:	e8 19 ff ff ff       	call   8020a5 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	90                   	nop
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	52                   	push   %edx
  8021a2:	50                   	push   %eax
  8021a3:	6a 07                	push   $0x7
  8021a5:	e8 fb fe ff ff       	call   8020a5 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b4:	8b 75 18             	mov    0x18(%ebp),%esi
  8021b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	56                   	push   %esi
  8021c4:	53                   	push   %ebx
  8021c5:	51                   	push   %ecx
  8021c6:	52                   	push   %edx
  8021c7:	50                   	push   %eax
  8021c8:	6a 08                	push   $0x8
  8021ca:	e8 d6 fe ff ff       	call   8020a5 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d5:	5b                   	pop    %ebx
  8021d6:	5e                   	pop    %esi
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 09                	push   $0x9
  8021ec:	e8 b4 fe ff ff       	call   8020a5 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	6a 0a                	push   $0xa
  802207:	e8 99 fe ff ff       	call   8020a5 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 0b                	push   $0xb
  802220:	e8 80 fe ff ff       	call   8020a5 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 0c                	push   $0xc
  802239:	e8 67 fe ff ff       	call   8020a5 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 0d                	push   $0xd
  802252:	e8 4e fe ff ff       	call   8020a5 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	ff 75 08             	pushl  0x8(%ebp)
  80226b:	6a 11                	push   $0x11
  80226d:	e8 33 fe ff ff       	call   8020a5 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
	return;
  802275:	90                   	nop
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	ff 75 0c             	pushl  0xc(%ebp)
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	6a 12                	push   $0x12
  802289:	e8 17 fe ff ff       	call   8020a5 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
	return ;
  802291:	90                   	nop
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 0e                	push   $0xe
  8022a3:	e8 fd fd ff ff       	call   8020a5 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	ff 75 08             	pushl  0x8(%ebp)
  8022bb:	6a 0f                	push   $0xf
  8022bd:	e8 e3 fd ff ff       	call   8020a5 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 10                	push   $0x10
  8022d6:	e8 ca fd ff ff       	call   8020a5 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	90                   	nop
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 14                	push   $0x14
  8022f0:	e8 b0 fd ff ff       	call   8020a5 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	90                   	nop
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 15                	push   $0x15
  80230a:	e8 96 fd ff ff       	call   8020a5 <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
}
  802312:	90                   	nop
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_cputc>:


void
sys_cputc(const char c)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802321:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	50                   	push   %eax
  80232e:	6a 16                	push   $0x16
  802330:	e8 70 fd ff ff       	call   8020a5 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	90                   	nop
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 17                	push   $0x17
  80234a:	e8 56 fd ff ff       	call   8020a5 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	90                   	nop
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	ff 75 0c             	pushl  0xc(%ebp)
  802364:	50                   	push   %eax
  802365:	6a 18                	push   $0x18
  802367:	e8 39 fd ff ff       	call   8020a5 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802374:	8b 55 0c             	mov    0xc(%ebp),%edx
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	52                   	push   %edx
  802381:	50                   	push   %eax
  802382:	6a 1b                	push   $0x1b
  802384:	e8 1c fd ff ff       	call   8020a5 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802391:	8b 55 0c             	mov    0xc(%ebp),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	52                   	push   %edx
  80239e:	50                   	push   %eax
  80239f:	6a 19                	push   $0x19
  8023a1:	e8 ff fc ff ff       	call   8020a5 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	90                   	nop
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	52                   	push   %edx
  8023bc:	50                   	push   %eax
  8023bd:	6a 1a                	push   $0x1a
  8023bf:	e8 e1 fc ff ff       	call   8020a5 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	90                   	nop
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023d6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	6a 00                	push   $0x0
  8023e2:	51                   	push   %ecx
  8023e3:	52                   	push   %edx
  8023e4:	ff 75 0c             	pushl  0xc(%ebp)
  8023e7:	50                   	push   %eax
  8023e8:	6a 1c                	push   $0x1c
  8023ea:	e8 b6 fc ff ff       	call   8020a5 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	52                   	push   %edx
  802404:	50                   	push   %eax
  802405:	6a 1d                	push   $0x1d
  802407:	e8 99 fc ff ff       	call   8020a5 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802414:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	51                   	push   %ecx
  802422:	52                   	push   %edx
  802423:	50                   	push   %eax
  802424:	6a 1e                	push   $0x1e
  802426:	e8 7a fc ff ff       	call   8020a5 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802433:	8b 55 0c             	mov    0xc(%ebp),%edx
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	52                   	push   %edx
  802440:	50                   	push   %eax
  802441:	6a 1f                	push   $0x1f
  802443:	e8 5d fc ff ff       	call   8020a5 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 20                	push   $0x20
  80245c:	e8 44 fc ff ff       	call   8020a5 <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	6a 00                	push   $0x0
  80246e:	ff 75 14             	pushl  0x14(%ebp)
  802471:	ff 75 10             	pushl  0x10(%ebp)
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	50                   	push   %eax
  802478:	6a 21                	push   $0x21
  80247a:	e8 26 fc ff ff       	call   8020a5 <syscall>
  80247f:	83 c4 18             	add    $0x18,%esp
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	50                   	push   %eax
  802493:	6a 22                	push   $0x22
  802495:	e8 0b fc ff ff       	call   8020a5 <syscall>
  80249a:	83 c4 18             	add    $0x18,%esp
}
  80249d:	90                   	nop
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	50                   	push   %eax
  8024af:	6a 23                	push   $0x23
  8024b1:	e8 ef fb ff ff       	call   8020a5 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
}
  8024b9:	90                   	nop
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024c2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024c5:	8d 50 04             	lea    0x4(%eax),%edx
  8024c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	52                   	push   %edx
  8024d2:	50                   	push   %eax
  8024d3:	6a 24                	push   $0x24
  8024d5:	e8 cb fb ff ff       	call   8020a5 <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
	return result;
  8024dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e6:	89 01                	mov    %eax,(%ecx)
  8024e8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	c9                   	leave  
  8024ef:	c2 04 00             	ret    $0x4

008024f2 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	ff 75 10             	pushl  0x10(%ebp)
  8024fc:	ff 75 0c             	pushl  0xc(%ebp)
  8024ff:	ff 75 08             	pushl  0x8(%ebp)
  802502:	6a 13                	push   $0x13
  802504:	e8 9c fb ff ff       	call   8020a5 <syscall>
  802509:	83 c4 18             	add    $0x18,%esp
	return ;
  80250c:	90                   	nop
}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

0080250f <sys_rcr2>:
uint32 sys_rcr2()
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 25                	push   $0x25
  80251e:	e8 82 fb ff ff       	call   8020a5 <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802534:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	50                   	push   %eax
  802541:	6a 26                	push   $0x26
  802543:	e8 5d fb ff ff       	call   8020a5 <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
	return ;
  80254b:	90                   	nop
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <rsttst>:
void rsttst()
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 28                	push   $0x28
  80255d:	e8 43 fb ff ff       	call   8020a5 <syscall>
  802562:	83 c4 18             	add    $0x18,%esp
	return ;
  802565:	90                   	nop
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	8b 45 14             	mov    0x14(%ebp),%eax
  802571:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802574:	8b 55 18             	mov    0x18(%ebp),%edx
  802577:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80257b:	52                   	push   %edx
  80257c:	50                   	push   %eax
  80257d:	ff 75 10             	pushl  0x10(%ebp)
  802580:	ff 75 0c             	pushl  0xc(%ebp)
  802583:	ff 75 08             	pushl  0x8(%ebp)
  802586:	6a 27                	push   $0x27
  802588:	e8 18 fb ff ff       	call   8020a5 <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
	return ;
  802590:	90                   	nop
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <chktst>:
void chktst(uint32 n)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	ff 75 08             	pushl  0x8(%ebp)
  8025a1:	6a 29                	push   $0x29
  8025a3:	e8 fd fa ff ff       	call   8020a5 <syscall>
  8025a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ab:	90                   	nop
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <inctst>:

void inctst()
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 2a                	push   $0x2a
  8025bd:	e8 e3 fa ff ff       	call   8020a5 <syscall>
  8025c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c5:	90                   	nop
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <gettst>:
uint32 gettst()
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 2b                	push   $0x2b
  8025d7:	e8 c9 fa ff ff       	call   8020a5 <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
}
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 2c                	push   $0x2c
  8025f3:	e8 ad fa ff ff       	call   8020a5 <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
  8025fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025fe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802602:	75 07                	jne    80260b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802604:	b8 01 00 00 00       	mov    $0x1,%eax
  802609:	eb 05                	jmp    802610 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80260b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802610:	c9                   	leave  
  802611:	c3                   	ret    

00802612 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 2c                	push   $0x2c
  802624:	e8 7c fa ff ff       	call   8020a5 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
  80262c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80262f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802633:	75 07                	jne    80263c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802635:	b8 01 00 00 00       	mov    $0x1,%eax
  80263a:	eb 05                	jmp    802641 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 2c                	push   $0x2c
  802655:	e8 4b fa ff ff       	call   8020a5 <syscall>
  80265a:	83 c4 18             	add    $0x18,%esp
  80265d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802660:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802664:	75 07                	jne    80266d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802666:	b8 01 00 00 00       	mov    $0x1,%eax
  80266b:	eb 05                	jmp    802672 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 2c                	push   $0x2c
  802686:	e8 1a fa ff ff       	call   8020a5 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
  80268e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802691:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802695:	75 07                	jne    80269e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802697:	b8 01 00 00 00       	mov    $0x1,%eax
  80269c:	eb 05                	jmp    8026a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80269e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	ff 75 08             	pushl  0x8(%ebp)
  8026b3:	6a 2d                	push   $0x2d
  8026b5:	e8 eb f9 ff ff       	call   8020a5 <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bd:	90                   	nop
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	6a 00                	push   $0x0
  8026d2:	53                   	push   %ebx
  8026d3:	51                   	push   %ecx
  8026d4:	52                   	push   %edx
  8026d5:	50                   	push   %eax
  8026d6:	6a 2e                	push   $0x2e
  8026d8:	e8 c8 f9 ff ff       	call   8020a5 <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
}
  8026e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	52                   	push   %edx
  8026f5:	50                   	push   %eax
  8026f6:	6a 2f                	push   $0x2f
  8026f8:	e8 a8 f9 ff ff       	call   8020a5 <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    
  802702:	66 90                	xchg   %ax,%ax

00802704 <__udivdi3>:
  802704:	55                   	push   %ebp
  802705:	57                   	push   %edi
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 1c             	sub    $0x1c,%esp
  80270b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80270f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80271b:	89 ca                	mov    %ecx,%edx
  80271d:	89 f8                	mov    %edi,%eax
  80271f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802723:	85 f6                	test   %esi,%esi
  802725:	75 2d                	jne    802754 <__udivdi3+0x50>
  802727:	39 cf                	cmp    %ecx,%edi
  802729:	77 65                	ja     802790 <__udivdi3+0x8c>
  80272b:	89 fd                	mov    %edi,%ebp
  80272d:	85 ff                	test   %edi,%edi
  80272f:	75 0b                	jne    80273c <__udivdi3+0x38>
  802731:	b8 01 00 00 00       	mov    $0x1,%eax
  802736:	31 d2                	xor    %edx,%edx
  802738:	f7 f7                	div    %edi
  80273a:	89 c5                	mov    %eax,%ebp
  80273c:	31 d2                	xor    %edx,%edx
  80273e:	89 c8                	mov    %ecx,%eax
  802740:	f7 f5                	div    %ebp
  802742:	89 c1                	mov    %eax,%ecx
  802744:	89 d8                	mov    %ebx,%eax
  802746:	f7 f5                	div    %ebp
  802748:	89 cf                	mov    %ecx,%edi
  80274a:	89 fa                	mov    %edi,%edx
  80274c:	83 c4 1c             	add    $0x1c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    
  802754:	39 ce                	cmp    %ecx,%esi
  802756:	77 28                	ja     802780 <__udivdi3+0x7c>
  802758:	0f bd fe             	bsr    %esi,%edi
  80275b:	83 f7 1f             	xor    $0x1f,%edi
  80275e:	75 40                	jne    8027a0 <__udivdi3+0x9c>
  802760:	39 ce                	cmp    %ecx,%esi
  802762:	72 0a                	jb     80276e <__udivdi3+0x6a>
  802764:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802768:	0f 87 9e 00 00 00    	ja     80280c <__udivdi3+0x108>
  80276e:	b8 01 00 00 00       	mov    $0x1,%eax
  802773:	89 fa                	mov    %edi,%edx
  802775:	83 c4 1c             	add    $0x1c,%esp
  802778:	5b                   	pop    %ebx
  802779:	5e                   	pop    %esi
  80277a:	5f                   	pop    %edi
  80277b:	5d                   	pop    %ebp
  80277c:	c3                   	ret    
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	31 ff                	xor    %edi,%edi
  802782:	31 c0                	xor    %eax,%eax
  802784:	89 fa                	mov    %edi,%edx
  802786:	83 c4 1c             	add    $0x1c,%esp
  802789:	5b                   	pop    %ebx
  80278a:	5e                   	pop    %esi
  80278b:	5f                   	pop    %edi
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    
  80278e:	66 90                	xchg   %ax,%ax
  802790:	89 d8                	mov    %ebx,%eax
  802792:	f7 f7                	div    %edi
  802794:	31 ff                	xor    %edi,%edi
  802796:	89 fa                	mov    %edi,%edx
  802798:	83 c4 1c             	add    $0x1c,%esp
  80279b:	5b                   	pop    %ebx
  80279c:	5e                   	pop    %esi
  80279d:	5f                   	pop    %edi
  80279e:	5d                   	pop    %ebp
  80279f:	c3                   	ret    
  8027a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027a5:	89 eb                	mov    %ebp,%ebx
  8027a7:	29 fb                	sub    %edi,%ebx
  8027a9:	89 f9                	mov    %edi,%ecx
  8027ab:	d3 e6                	shl    %cl,%esi
  8027ad:	89 c5                	mov    %eax,%ebp
  8027af:	88 d9                	mov    %bl,%cl
  8027b1:	d3 ed                	shr    %cl,%ebp
  8027b3:	89 e9                	mov    %ebp,%ecx
  8027b5:	09 f1                	or     %esi,%ecx
  8027b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027bb:	89 f9                	mov    %edi,%ecx
  8027bd:	d3 e0                	shl    %cl,%eax
  8027bf:	89 c5                	mov    %eax,%ebp
  8027c1:	89 d6                	mov    %edx,%esi
  8027c3:	88 d9                	mov    %bl,%cl
  8027c5:	d3 ee                	shr    %cl,%esi
  8027c7:	89 f9                	mov    %edi,%ecx
  8027c9:	d3 e2                	shl    %cl,%edx
  8027cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027cf:	88 d9                	mov    %bl,%cl
  8027d1:	d3 e8                	shr    %cl,%eax
  8027d3:	09 c2                	or     %eax,%edx
  8027d5:	89 d0                	mov    %edx,%eax
  8027d7:	89 f2                	mov    %esi,%edx
  8027d9:	f7 74 24 0c          	divl   0xc(%esp)
  8027dd:	89 d6                	mov    %edx,%esi
  8027df:	89 c3                	mov    %eax,%ebx
  8027e1:	f7 e5                	mul    %ebp
  8027e3:	39 d6                	cmp    %edx,%esi
  8027e5:	72 19                	jb     802800 <__udivdi3+0xfc>
  8027e7:	74 0b                	je     8027f4 <__udivdi3+0xf0>
  8027e9:	89 d8                	mov    %ebx,%eax
  8027eb:	31 ff                	xor    %edi,%edi
  8027ed:	e9 58 ff ff ff       	jmp    80274a <__udivdi3+0x46>
  8027f2:	66 90                	xchg   %ax,%ax
  8027f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8027f8:	89 f9                	mov    %edi,%ecx
  8027fa:	d3 e2                	shl    %cl,%edx
  8027fc:	39 c2                	cmp    %eax,%edx
  8027fe:	73 e9                	jae    8027e9 <__udivdi3+0xe5>
  802800:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802803:	31 ff                	xor    %edi,%edi
  802805:	e9 40 ff ff ff       	jmp    80274a <__udivdi3+0x46>
  80280a:	66 90                	xchg   %ax,%ax
  80280c:	31 c0                	xor    %eax,%eax
  80280e:	e9 37 ff ff ff       	jmp    80274a <__udivdi3+0x46>
  802813:	90                   	nop

00802814 <__umoddi3>:
  802814:	55                   	push   %ebp
  802815:	57                   	push   %edi
  802816:	56                   	push   %esi
  802817:	53                   	push   %ebx
  802818:	83 ec 1c             	sub    $0x1c,%esp
  80281b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80281f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802827:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80282b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80282f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802833:	89 f3                	mov    %esi,%ebx
  802835:	89 fa                	mov    %edi,%edx
  802837:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80283b:	89 34 24             	mov    %esi,(%esp)
  80283e:	85 c0                	test   %eax,%eax
  802840:	75 1a                	jne    80285c <__umoddi3+0x48>
  802842:	39 f7                	cmp    %esi,%edi
  802844:	0f 86 a2 00 00 00    	jbe    8028ec <__umoddi3+0xd8>
  80284a:	89 c8                	mov    %ecx,%eax
  80284c:	89 f2                	mov    %esi,%edx
  80284e:	f7 f7                	div    %edi
  802850:	89 d0                	mov    %edx,%eax
  802852:	31 d2                	xor    %edx,%edx
  802854:	83 c4 1c             	add    $0x1c,%esp
  802857:	5b                   	pop    %ebx
  802858:	5e                   	pop    %esi
  802859:	5f                   	pop    %edi
  80285a:	5d                   	pop    %ebp
  80285b:	c3                   	ret    
  80285c:	39 f0                	cmp    %esi,%eax
  80285e:	0f 87 ac 00 00 00    	ja     802910 <__umoddi3+0xfc>
  802864:	0f bd e8             	bsr    %eax,%ebp
  802867:	83 f5 1f             	xor    $0x1f,%ebp
  80286a:	0f 84 ac 00 00 00    	je     80291c <__umoddi3+0x108>
  802870:	bf 20 00 00 00       	mov    $0x20,%edi
  802875:	29 ef                	sub    %ebp,%edi
  802877:	89 fe                	mov    %edi,%esi
  802879:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80287d:	89 e9                	mov    %ebp,%ecx
  80287f:	d3 e0                	shl    %cl,%eax
  802881:	89 d7                	mov    %edx,%edi
  802883:	89 f1                	mov    %esi,%ecx
  802885:	d3 ef                	shr    %cl,%edi
  802887:	09 c7                	or     %eax,%edi
  802889:	89 e9                	mov    %ebp,%ecx
  80288b:	d3 e2                	shl    %cl,%edx
  80288d:	89 14 24             	mov    %edx,(%esp)
  802890:	89 d8                	mov    %ebx,%eax
  802892:	d3 e0                	shl    %cl,%eax
  802894:	89 c2                	mov    %eax,%edx
  802896:	8b 44 24 08          	mov    0x8(%esp),%eax
  80289a:	d3 e0                	shl    %cl,%eax
  80289c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028a4:	89 f1                	mov    %esi,%ecx
  8028a6:	d3 e8                	shr    %cl,%eax
  8028a8:	09 d0                	or     %edx,%eax
  8028aa:	d3 eb                	shr    %cl,%ebx
  8028ac:	89 da                	mov    %ebx,%edx
  8028ae:	f7 f7                	div    %edi
  8028b0:	89 d3                	mov    %edx,%ebx
  8028b2:	f7 24 24             	mull   (%esp)
  8028b5:	89 c6                	mov    %eax,%esi
  8028b7:	89 d1                	mov    %edx,%ecx
  8028b9:	39 d3                	cmp    %edx,%ebx
  8028bb:	0f 82 87 00 00 00    	jb     802948 <__umoddi3+0x134>
  8028c1:	0f 84 91 00 00 00    	je     802958 <__umoddi3+0x144>
  8028c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028cb:	29 f2                	sub    %esi,%edx
  8028cd:	19 cb                	sbb    %ecx,%ebx
  8028cf:	89 d8                	mov    %ebx,%eax
  8028d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028d5:	d3 e0                	shl    %cl,%eax
  8028d7:	89 e9                	mov    %ebp,%ecx
  8028d9:	d3 ea                	shr    %cl,%edx
  8028db:	09 d0                	or     %edx,%eax
  8028dd:	89 e9                	mov    %ebp,%ecx
  8028df:	d3 eb                	shr    %cl,%ebx
  8028e1:	89 da                	mov    %ebx,%edx
  8028e3:	83 c4 1c             	add    $0x1c,%esp
  8028e6:	5b                   	pop    %ebx
  8028e7:	5e                   	pop    %esi
  8028e8:	5f                   	pop    %edi
  8028e9:	5d                   	pop    %ebp
  8028ea:	c3                   	ret    
  8028eb:	90                   	nop
  8028ec:	89 fd                	mov    %edi,%ebp
  8028ee:	85 ff                	test   %edi,%edi
  8028f0:	75 0b                	jne    8028fd <__umoddi3+0xe9>
  8028f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f7:	31 d2                	xor    %edx,%edx
  8028f9:	f7 f7                	div    %edi
  8028fb:	89 c5                	mov    %eax,%ebp
  8028fd:	89 f0                	mov    %esi,%eax
  8028ff:	31 d2                	xor    %edx,%edx
  802901:	f7 f5                	div    %ebp
  802903:	89 c8                	mov    %ecx,%eax
  802905:	f7 f5                	div    %ebp
  802907:	89 d0                	mov    %edx,%eax
  802909:	e9 44 ff ff ff       	jmp    802852 <__umoddi3+0x3e>
  80290e:	66 90                	xchg   %ax,%ax
  802910:	89 c8                	mov    %ecx,%eax
  802912:	89 f2                	mov    %esi,%edx
  802914:	83 c4 1c             	add    $0x1c,%esp
  802917:	5b                   	pop    %ebx
  802918:	5e                   	pop    %esi
  802919:	5f                   	pop    %edi
  80291a:	5d                   	pop    %ebp
  80291b:	c3                   	ret    
  80291c:	3b 04 24             	cmp    (%esp),%eax
  80291f:	72 06                	jb     802927 <__umoddi3+0x113>
  802921:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802925:	77 0f                	ja     802936 <__umoddi3+0x122>
  802927:	89 f2                	mov    %esi,%edx
  802929:	29 f9                	sub    %edi,%ecx
  80292b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80292f:	89 14 24             	mov    %edx,(%esp)
  802932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802936:	8b 44 24 04          	mov    0x4(%esp),%eax
  80293a:	8b 14 24             	mov    (%esp),%edx
  80293d:	83 c4 1c             	add    $0x1c,%esp
  802940:	5b                   	pop    %ebx
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	2b 04 24             	sub    (%esp),%eax
  80294b:	19 fa                	sbb    %edi,%edx
  80294d:	89 d1                	mov    %edx,%ecx
  80294f:	89 c6                	mov    %eax,%esi
  802951:	e9 71 ff ff ff       	jmp    8028c7 <__umoddi3+0xb3>
  802956:	66 90                	xchg   %ax,%ax
  802958:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80295c:	72 ea                	jb     802948 <__umoddi3+0x134>
  80295e:	89 d9                	mov    %ebx,%ecx
  802960:	e9 62 ff ff ff       	jmp    8028c7 <__umoddi3+0xb3>
