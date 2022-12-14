
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 bd 06 00 00       	call   8006f3 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 83 23 00 00       	call   8023cd <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 23                	jmp    80007d <_main+0x45>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 30 80 00       	mov    0x803020,%eax
  80005f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	c1 e2 04             	shl    $0x4,%edx
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8a 40 04             	mov    0x4(%eax),%al
  800070:	84 c0                	test   %al,%al
  800072:	74 06                	je     80007a <_main+0x42>
			{
				fullWS = 0;
  800074:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800078:	eb 12                	jmp    80008c <_main+0x54>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 30 80 00       	mov    0x803020,%eax
  800082:	8b 50 74             	mov    0x74(%eax),%edx
  800085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800088:	39 c2                	cmp    %eax,%edx
  80008a:	77 ce                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800090:	74 14                	je     8000a6 <_main+0x6e>
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	68 a0 26 80 00       	push   $0x8026a0
  80009a:	6a 1b                	push   $0x1b
  80009c:	68 bc 26 80 00       	push   $0x8026bc
  8000a1:	e8 92 07 00 00       	call   800838 <_panic>
	}


	int Mega = 1024*1024;
  8000a6:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000ad:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000b4:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000b7:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	89 d7                	mov    %edx,%edi
  8000c3:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 01 00 00 20       	push   $0x20000001
  8000cd:	e8 92 17 00 00       	call   801864 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 d4 26 80 00       	push   $0x8026d4
  8000e7:	6a 26                	push   $0x26
  8000e9:	68 bc 26 80 00       	push   $0x8026bc
  8000ee:	e8 45 07 00 00       	call   800838 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000f3:	e8 41 1e 00 00       	call   801f39 <sys_calculate_free_frames>
  8000f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000fb:	e8 bc 1e 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800100:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 50 17 00 00       	call   801864 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80011a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80011d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 18 27 80 00       	push   $0x802718
  80012c:	6a 2f                	push   $0x2f
  80012e:	68 bc 26 80 00       	push   $0x8026bc
  800133:	e8 00 07 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800138:	e8 7f 1e 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 48 27 80 00       	push   $0x802748
  80014f:	6a 31                	push   $0x31
  800151:	68 bc 26 80 00       	push   $0x8026bc
  800156:	e8 dd 06 00 00       	call   800838 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 d9 1d 00 00       	call   801f39 <sys_calculate_free_frames>
  800160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800163:	e8 54 1e 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800168:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	01 c0                	add    %eax,%eax
  800170:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	50                   	push   %eax
  800177:	e8 e8 16 00 00       	call   801864 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800182:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800185:	89 c2                	mov    %eax,%edx
  800187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018a:	01 c0                	add    %eax,%eax
  80018c:	05 00 00 00 80       	add    $0x80000000,%eax
  800191:	39 c2                	cmp    %eax,%edx
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 18 27 80 00       	push   $0x802718
  80019d:	6a 37                	push   $0x37
  80019f:	68 bc 26 80 00       	push   $0x8026bc
  8001a4:	e8 8f 06 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001a9:	e8 0e 1e 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8001ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001b6:	74 14                	je     8001cc <_main+0x194>
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	68 48 27 80 00       	push   $0x802748
  8001c0:	6a 39                	push   $0x39
  8001c2:	68 bc 26 80 00       	push   $0x8026bc
  8001c7:	e8 6c 06 00 00       	call   800838 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001cc:	e8 68 1d 00 00       	call   801f39 <sys_calculate_free_frames>
  8001d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001d4:	e8 e3 1d 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	89 c2                	mov    %eax,%edx
  8001e1:	01 d2                	add    %edx,%edx
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	50                   	push   %eax
  8001e9:	e8 76 16 00 00       	call   801864 <malloc>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001f4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f7:	89 c2                	mov    %eax,%edx
  8001f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001fc:	c1 e0 02             	shl    $0x2,%eax
  8001ff:	05 00 00 00 80       	add    $0x80000000,%eax
  800204:	39 c2                	cmp    %eax,%edx
  800206:	74 14                	je     80021c <_main+0x1e4>
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	68 18 27 80 00       	push   $0x802718
  800210:	6a 3f                	push   $0x3f
  800212:	68 bc 26 80 00       	push   $0x8026bc
  800217:	e8 1c 06 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80021c:	e8 9b 1d 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800221:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800224:	83 f8 01             	cmp    $0x1,%eax
  800227:	74 14                	je     80023d <_main+0x205>
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	68 48 27 80 00       	push   $0x802748
  800231:	6a 41                	push   $0x41
  800233:	68 bc 26 80 00       	push   $0x8026bc
  800238:	e8 fb 05 00 00       	call   800838 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  80023d:	e8 f7 1c 00 00       	call   801f39 <sys_calculate_free_frames>
  800242:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800245:	e8 72 1d 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80024a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  80024d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800250:	89 c2                	mov    %eax,%edx
  800252:	01 d2                	add    %edx,%edx
  800254:	01 d0                	add    %edx,%eax
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	e8 05 16 00 00       	call   801864 <malloc>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800265:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800268:	89 c2                	mov    %eax,%edx
  80026a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026d:	c1 e0 02             	shl    $0x2,%eax
  800270:	89 c1                	mov    %eax,%ecx
  800272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800275:	c1 e0 02             	shl    $0x2,%eax
  800278:	01 c8                	add    %ecx,%eax
  80027a:	05 00 00 00 80       	add    $0x80000000,%eax
  80027f:	39 c2                	cmp    %eax,%edx
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 18 27 80 00       	push   $0x802718
  80028b:	6a 47                	push   $0x47
  80028d:	68 bc 26 80 00       	push   $0x8026bc
  800292:	e8 a1 05 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800297:	e8 20 1d 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80029c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80029f:	83 f8 01             	cmp    $0x1,%eax
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 48 27 80 00       	push   $0x802748
  8002ac:	6a 49                	push   $0x49
  8002ae:	68 bc 26 80 00       	push   $0x8026bc
  8002b3:	e8 80 05 00 00       	call   800838 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002b8:	e8 7c 1c 00 00       	call   801f39 <sys_calculate_free_frames>
  8002bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c0:	e8 f7 1c 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8002c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002c8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	e8 bf 17 00 00       	call   801a93 <free>
  8002d4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002d7:	e8 e0 1c 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8002dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002df:	29 c2                	sub    %eax,%edx
  8002e1:	89 d0                	mov    %edx,%eax
  8002e3:	83 f8 01             	cmp    $0x1,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 65 27 80 00       	push   $0x802765
  8002f0:	6a 50                	push   $0x50
  8002f2:	68 bc 26 80 00       	push   $0x8026bc
  8002f7:	e8 3c 05 00 00       	call   800838 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002fc:	e8 38 1c 00 00       	call   801f39 <sys_calculate_free_frames>
  800301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800304:	e8 b3 1c 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800309:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80030c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030f:	89 d0                	mov    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	01 c0                	add    %eax,%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	50                   	push   %eax
  80031d:	e8 42 15 00 00       	call   801864 <malloc>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800328:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032b:	89 c2                	mov    %eax,%edx
  80032d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800330:	c1 e0 02             	shl    $0x2,%eax
  800333:	89 c1                	mov    %eax,%ecx
  800335:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800338:	c1 e0 03             	shl    $0x3,%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	05 00 00 00 80       	add    $0x80000000,%eax
  800342:	39 c2                	cmp    %eax,%edx
  800344:	74 14                	je     80035a <_main+0x322>
  800346:	83 ec 04             	sub    $0x4,%esp
  800349:	68 18 27 80 00       	push   $0x802718
  80034e:	6a 56                	push   $0x56
  800350:	68 bc 26 80 00       	push   $0x8026bc
  800355:	e8 de 04 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80035a:	e8 5d 1c 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80035f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800362:	83 f8 02             	cmp    $0x2,%eax
  800365:	74 14                	je     80037b <_main+0x343>
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	68 48 27 80 00       	push   $0x802748
  80036f:	6a 58                	push   $0x58
  800371:	68 bc 26 80 00       	push   $0x8026bc
  800376:	e8 bd 04 00 00       	call   800838 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80037b:	e8 b9 1b 00 00       	call   801f39 <sys_calculate_free_frames>
  800380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800383:	e8 34 1c 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800388:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  80038b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	50                   	push   %eax
  800392:	e8 fc 16 00 00       	call   801a93 <free>
  800397:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  80039a:	e8 1d 1c 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80039f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a2:	29 c2                	sub    %eax,%edx
  8003a4:	89 d0                	mov    %edx,%eax
  8003a6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003ab:	74 14                	je     8003c1 <_main+0x389>
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 65 27 80 00       	push   $0x802765
  8003b5:	6a 5f                	push   $0x5f
  8003b7:	68 bc 26 80 00       	push   $0x8026bc
  8003bc:	e8 77 04 00 00       	call   800838 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003c1:	e8 73 1b 00 00       	call   801f39 <sys_calculate_free_frames>
  8003c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c9:	e8 ee 1b 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	01 d2                	add    %edx,%edx
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003dd:	83 ec 0c             	sub    $0xc,%esp
  8003e0:	50                   	push   %eax
  8003e1:	e8 7e 14 00 00       	call   801864 <malloc>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003ef:	89 c2                	mov    %eax,%edx
  8003f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003f4:	c1 e0 02             	shl    $0x2,%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003fc:	c1 e0 04             	shl    $0x4,%eax
  8003ff:	01 c8                	add    %ecx,%eax
  800401:	05 00 00 00 80       	add    $0x80000000,%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 18 27 80 00       	push   $0x802718
  800412:	6a 65                	push   $0x65
  800414:	68 bc 26 80 00       	push   $0x8026bc
  800419:	e8 1a 04 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80041e:	e8 99 1b 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800423:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80042b:	89 c1                	mov    %eax,%ecx
  80042d:	01 c9                	add    %ecx,%ecx
  80042f:	01 c8                	add    %ecx,%eax
  800431:	85 c0                	test   %eax,%eax
  800433:	79 05                	jns    80043a <_main+0x402>
  800435:	05 ff 0f 00 00       	add    $0xfff,%eax
  80043a:	c1 f8 0c             	sar    $0xc,%eax
  80043d:	39 c2                	cmp    %eax,%edx
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 48 27 80 00       	push   $0x802748
  800449:	6a 67                	push   $0x67
  80044b:	68 bc 26 80 00       	push   $0x8026bc
  800450:	e8 e3 03 00 00       	call   800838 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800455:	e8 df 1a 00 00       	call   801f39 <sys_calculate_free_frames>
  80045a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045d:	e8 5a 1b 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	89 c2                	mov    %eax,%edx
  80046a:	01 d2                	add    %edx,%edx
  80046c:	01 c2                	add    %eax,%edx
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	01 c0                	add    %eax,%eax
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	50                   	push   %eax
  800479:	e8 e6 13 00 00       	call   801864 <malloc>
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800484:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800487:	89 c1                	mov    %eax,%ecx
  800489:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80048c:	89 d0                	mov    %edx,%eax
  80048e:	01 c0                	add    %eax,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	89 c2                	mov    %eax,%edx
  800498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049b:	c1 e0 04             	shl    $0x4,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a5:	39 c1                	cmp    %eax,%ecx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 18 27 80 00       	push   $0x802718
  8004b1:	6a 6d                	push   $0x6d
  8004b3:	68 bc 26 80 00       	push   $0x8026bc
  8004b8:	e8 7b 03 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004bd:	e8 fa 1a 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8004c2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c5:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004ca:	74 14                	je     8004e0 <_main+0x4a8>
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	68 48 27 80 00       	push   $0x802748
  8004d4:	6a 6f                	push   $0x6f
  8004d6:	68 bc 26 80 00       	push   $0x8026bc
  8004db:	e8 58 03 00 00       	call   800838 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004e0:	e8 54 1a 00 00       	call   801f39 <sys_calculate_free_frames>
  8004e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e8:	e8 cf 1a 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8004ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	50                   	push   %eax
  8004f7:	e8 97 15 00 00       	call   801a93 <free>
  8004fc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  8004ff:	e8 b8 1a 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800507:	29 c2                	sub    %eax,%edx
  800509:	89 d0                	mov    %edx,%eax
  80050b:	3d 00 03 00 00       	cmp    $0x300,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 65 27 80 00       	push   $0x802765
  80051a:	6a 76                	push   $0x76
  80051c:	68 bc 26 80 00       	push   $0x8026bc
  800521:	e8 12 03 00 00       	call   800838 <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 0e 1a 00 00       	call   801f39 <sys_calculate_free_frames>
  80052b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80052e:	e8 89 1a 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 51 15 00 00       	call   801a93 <free>
  800542:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800545:	e8 72 1a 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	3d 00 02 00 00       	cmp    $0x200,%eax
  800556:	74 14                	je     80056c <_main+0x534>
  800558:	83 ec 04             	sub    $0x4,%esp
  80055b:	68 65 27 80 00       	push   $0x802765
  800560:	6a 7d                	push   $0x7d
  800562:	68 bc 26 80 00       	push   $0x8026bc
  800567:	e8 cc 02 00 00       	call   800838 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80056c:	e8 c8 19 00 00       	call   801f39 <sys_calculate_free_frames>
  800571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800574:	e8 43 1a 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800579:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80057c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	c1 e0 02             	shl    $0x2,%eax
  800584:	01 d0                	add    %edx,%eax
  800586:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	50                   	push   %eax
  80058d:	e8 d2 12 00 00       	call   801864 <malloc>
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800598:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005a0:	89 d0                	mov    %edx,%eax
  8005a2:	c1 e0 03             	shl    $0x3,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	89 c3                	mov    %eax,%ebx
  8005a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ac:	89 d0                	mov    %edx,%eax
  8005ae:	01 c0                	add    %eax,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	c1 e0 03             	shl    $0x3,%eax
  8005b5:	01 d8                	add    %ebx,%eax
  8005b7:	05 00 00 00 80       	add    $0x80000000,%eax
  8005bc:	39 c1                	cmp    %eax,%ecx
  8005be:	74 17                	je     8005d7 <_main+0x59f>
  8005c0:	83 ec 04             	sub    $0x4,%esp
  8005c3:	68 18 27 80 00       	push   $0x802718
  8005c8:	68 83 00 00 00       	push   $0x83
  8005cd:	68 bc 26 80 00       	push   $0x8026bc
  8005d2:	e8 61 02 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  8005d7:	e8 e0 19 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  8005dc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	c1 e0 02             	shl    $0x2,%eax
  8005e9:	01 d0                	add    %edx,%eax
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	79 05                	jns    8005f4 <_main+0x5bc>
  8005ef:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005f4:	c1 f8 0c             	sar    $0xc,%eax
  8005f7:	39 c1                	cmp    %eax,%ecx
  8005f9:	74 17                	je     800612 <_main+0x5da>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 48 27 80 00       	push   $0x802748
  800603:	68 85 00 00 00       	push   $0x85
  800608:	68 bc 26 80 00       	push   $0x8026bc
  80060d:	e8 26 02 00 00       	call   800838 <_panic>
//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800612:	e8 22 19 00 00       	call   801f39 <sys_calculate_free_frames>
  800617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061a:	e8 9d 19 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  80061f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  800622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	01 d2                	add    %edx,%edx
  800629:	01 d0                	add    %edx,%eax
  80062b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80062e:	83 ec 0c             	sub    $0xc,%esp
  800631:	50                   	push   %eax
  800632:	e8 2d 12 00 00       	call   801864 <malloc>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80063d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800640:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800645:	74 17                	je     80065e <_main+0x626>
  800647:	83 ec 04             	sub    $0x4,%esp
  80064a:	68 18 27 80 00       	push   $0x802718
  80064f:	68 93 00 00 00       	push   $0x93
  800654:	68 bc 26 80 00       	push   $0x8026bc
  800659:	e8 da 01 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80065e:	e8 59 19 00 00       	call   801fbc <sys_pf_calculate_allocated_pages>
  800663:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80066b:	89 c1                	mov    %eax,%ecx
  80066d:	01 c9                	add    %ecx,%ecx
  80066f:	01 c8                	add    %ecx,%eax
  800671:	85 c0                	test   %eax,%eax
  800673:	79 05                	jns    80067a <_main+0x642>
  800675:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067a:	c1 f8 0c             	sar    $0xc,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x660>
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	68 48 27 80 00       	push   $0x802748
  800689:	68 95 00 00 00       	push   $0x95
  80068e:	68 bc 26 80 00       	push   $0x8026bc
  800693:	e8 a0 01 00 00       	call   800838 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800698:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80069b:	89 d0                	mov    %edx,%eax
  80069d:	01 c0                	add    %eax,%eax
  80069f:	01 d0                	add    %edx,%eax
  8006a1:	01 c0                	add    %eax,%eax
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	01 c0                	add    %eax,%eax
  8006a7:	f7 d8                	neg    %eax
  8006a9:	05 00 00 00 20       	add    $0x20000000,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 ad 11 00 00       	call   801864 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8006bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	74 17                	je     8006db <_main+0x6a3>
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	68 7c 27 80 00       	push   $0x80277c
  8006cc:	68 9e 00 00 00       	push   $0x9e
  8006d1:	68 bc 26 80 00       	push   $0x8026bc
  8006d6:	e8 5d 01 00 00       	call   800838 <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	68 e0 27 80 00       	push   $0x8027e0
  8006e3:	e8 f2 03 00 00       	call   800ada <cprintf>
  8006e8:	83 c4 10             	add    $0x10,%esp

		return;
  8006eb:	90                   	nop
	}
}
  8006ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006ef:	5b                   	pop    %ebx
  8006f0:	5f                   	pop    %edi
  8006f1:	5d                   	pop    %ebp
  8006f2:	c3                   	ret    

008006f3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006f9:	e8 70 17 00 00       	call   801e6e <sys_getenvindex>
  8006fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800704:	89 d0                	mov    %edx,%eax
  800706:	c1 e0 03             	shl    $0x3,%eax
  800709:	01 d0                	add    %edx,%eax
  80070b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800712:	01 c8                	add    %ecx,%eax
  800714:	01 c0                	add    %eax,%eax
  800716:	01 d0                	add    %edx,%eax
  800718:	01 c0                	add    %eax,%eax
  80071a:	01 d0                	add    %edx,%eax
  80071c:	89 c2                	mov    %eax,%edx
  80071e:	c1 e2 05             	shl    $0x5,%edx
  800721:	29 c2                	sub    %eax,%edx
  800723:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800732:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800737:	a1 20 30 80 00       	mov    0x803020,%eax
  80073c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800742:	84 c0                	test   %al,%al
  800744:	74 0f                	je     800755 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800746:	a1 20 30 80 00       	mov    0x803020,%eax
  80074b:	05 40 3c 01 00       	add    $0x13c40,%eax
  800750:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800755:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800759:	7e 0a                	jle    800765 <libmain+0x72>
		binaryname = argv[0];
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	ff 75 08             	pushl  0x8(%ebp)
  80076e:	e8 c5 f8 ff ff       	call   800038 <_main>
  800773:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800776:	e8 8e 18 00 00       	call   802009 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 44 28 80 00       	push   $0x802844
  800783:	e8 52 03 00 00       	call   800ada <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80078b:	a1 20 30 80 00       	mov    0x803020,%eax
  800790:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800796:	a1 20 30 80 00       	mov    0x803020,%eax
  80079b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8007a1:	83 ec 04             	sub    $0x4,%esp
  8007a4:	52                   	push   %edx
  8007a5:	50                   	push   %eax
  8007a6:	68 6c 28 80 00       	push   $0x80286c
  8007ab:	e8 2a 03 00 00       	call   800ada <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8007b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b8:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8007be:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c3:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	52                   	push   %edx
  8007cd:	50                   	push   %eax
  8007ce:	68 94 28 80 00       	push   $0x802894
  8007d3:	e8 02 03 00 00       	call   800ada <cprintf>
  8007d8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007db:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e0:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	50                   	push   %eax
  8007ea:	68 d5 28 80 00       	push   $0x8028d5
  8007ef:	e8 e6 02 00 00       	call   800ada <cprintf>
  8007f4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	68 44 28 80 00       	push   $0x802844
  8007ff:	e8 d6 02 00 00       	call   800ada <cprintf>
  800804:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800807:	e8 17 18 00 00       	call   802023 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80080c:	e8 19 00 00 00       	call   80082a <exit>
}
  800811:	90                   	nop
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80081a:	83 ec 0c             	sub    $0xc,%esp
  80081d:	6a 00                	push   $0x0
  80081f:	e8 16 16 00 00       	call   801e3a <sys_env_destroy>
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	90                   	nop
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <exit>:

void
exit(void)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800830:	e8 6b 16 00 00       	call   801ea0 <sys_env_exit>
}
  800835:	90                   	nop
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083e:	8d 45 10             	lea    0x10(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800847:	a1 18 31 80 00       	mov    0x803118,%eax
  80084c:	85 c0                	test   %eax,%eax
  80084e:	74 16                	je     800866 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800850:	a1 18 31 80 00       	mov    0x803118,%eax
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	50                   	push   %eax
  800859:	68 ec 28 80 00       	push   $0x8028ec
  80085e:	e8 77 02 00 00       	call   800ada <cprintf>
  800863:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800866:	a1 00 30 80 00       	mov    0x803000,%eax
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	50                   	push   %eax
  800872:	68 f1 28 80 00       	push   $0x8028f1
  800877:	e8 5e 02 00 00       	call   800ada <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 f4             	pushl  -0xc(%ebp)
  800888:	50                   	push   %eax
  800889:	e8 e1 01 00 00       	call   800a6f <vcprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	6a 00                	push   $0x0
  800896:	68 0d 29 80 00       	push   $0x80290d
  80089b:	e8 cf 01 00 00       	call   800a6f <vcprintf>
  8008a0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a3:	e8 82 ff ff ff       	call   80082a <exit>

	// should not return here
	while (1) ;
  8008a8:	eb fe                	jmp    8008a8 <_panic+0x70>

008008aa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	74 14                	je     8008d3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	68 10 29 80 00       	push   $0x802910
  8008c7:	6a 26                	push   $0x26
  8008c9:	68 5c 29 80 00       	push   $0x80295c
  8008ce:	e8 65 ff ff ff       	call   800838 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008e1:	e9 b6 00 00 00       	jmp    80099c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8008e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	75 08                	jne    800903 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8008fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008fe:	e9 96 00 00 00       	jmp    800999 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800911:	eb 5d                	jmp    800970 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800913:	a1 20 30 80 00       	mov    0x803020,%eax
  800918:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80091e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800921:	c1 e2 04             	shl    $0x4,%edx
  800924:	01 d0                	add    %edx,%eax
  800926:	8a 40 04             	mov    0x4(%eax),%al
  800929:	84 c0                	test   %al,%al
  80092b:	75 40                	jne    80096d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80092d:	a1 20 30 80 00       	mov    0x803020,%eax
  800932:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800938:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093b:	c1 e2 04             	shl    $0x4,%edx
  80093e:	01 d0                	add    %edx,%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80094d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80094f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800952:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	01 c8                	add    %ecx,%eax
  80095e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800960:	39 c2                	cmp    %eax,%edx
  800962:	75 09                	jne    80096d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800964:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80096b:	eb 12                	jmp    80097f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096d:	ff 45 e8             	incl   -0x18(%ebp)
  800970:	a1 20 30 80 00       	mov    0x803020,%eax
  800975:	8b 50 74             	mov    0x74(%eax),%edx
  800978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	77 94                	ja     800913 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80097f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800983:	75 14                	jne    800999 <CheckWSWithoutLastIndex+0xef>
			panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 68 29 80 00       	push   $0x802968
  80098d:	6a 3a                	push   $0x3a
  80098f:	68 5c 29 80 00       	push   $0x80295c
  800994:	e8 9f fe ff ff       	call   800838 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800999:	ff 45 f0             	incl   -0x10(%ebp)
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009a2:	0f 8c 3e ff ff ff    	jl     8008e6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b6:	eb 20                	jmp    8009d8 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8009bd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c6:	c1 e2 04             	shl    $0x4,%edx
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	3c 01                	cmp    $0x1,%al
  8009d0:	75 03                	jne    8009d5 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8009d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d5:	ff 45 e0             	incl   -0x20(%ebp)
  8009d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8009dd:	8b 50 74             	mov    0x74(%eax),%edx
  8009e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e3:	39 c2                	cmp    %eax,%edx
  8009e5:	77 d1                	ja     8009b8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ed:	74 14                	je     800a03 <CheckWSWithoutLastIndex+0x159>
		panic(
  8009ef:	83 ec 04             	sub    $0x4,%esp
  8009f2:	68 bc 29 80 00       	push   $0x8029bc
  8009f7:	6a 44                	push   $0x44
  8009f9:	68 5c 29 80 00       	push   $0x80295c
  8009fe:	e8 35 fe ff ff       	call   800838 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a03:	90                   	nop
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	8d 48 01             	lea    0x1(%eax),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a17:	89 0a                	mov    %ecx,(%edx)
  800a19:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1c:	88 d1                	mov    %dl,%cl
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a2f:	75 2c                	jne    800a5d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a31:	a0 24 30 80 00       	mov    0x803024,%al
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3c:	8b 12                	mov    (%edx),%edx
  800a3e:	89 d1                	mov    %edx,%ecx
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	83 c2 08             	add    $0x8,%edx
  800a46:	83 ec 04             	sub    $0x4,%esp
  800a49:	50                   	push   %eax
  800a4a:	51                   	push   %ecx
  800a4b:	52                   	push   %edx
  800a4c:	e8 a7 13 00 00       	call   801df8 <sys_cputs>
  800a51:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8b 40 04             	mov    0x4(%eax),%eax
  800a63:	8d 50 01             	lea    0x1(%eax),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a6c:	90                   	nop
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a78:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a7f:	00 00 00 
	b.cnt = 0;
  800a82:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a89:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	ff 75 08             	pushl  0x8(%ebp)
  800a92:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 06 0a 80 00       	push   $0x800a06
  800a9e:	e8 11 02 00 00       	call   800cb4 <vprintfmt>
  800aa3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800aa6:	a0 24 30 80 00       	mov    0x803024,%al
  800aab:	0f b6 c0             	movzbl %al,%eax
  800aae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	50                   	push   %eax
  800ab8:	52                   	push   %edx
  800ab9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800abf:	83 c0 08             	add    $0x8,%eax
  800ac2:	50                   	push   %eax
  800ac3:	e8 30 13 00 00       	call   801df8 <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800acb:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800ad2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <cprintf>:

int cprintf(const char *fmt, ...) {
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ae0:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800ae7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 f4             	pushl  -0xc(%ebp)
  800af6:	50                   	push   %eax
  800af7:	e8 73 ff ff ff       	call   800a6f <vcprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b0d:	e8 f7 14 00 00       	call   802009 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b21:	50                   	push   %eax
  800b22:	e8 48 ff ff ff       	call   800a6f <vcprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b2d:	e8 f1 14 00 00       	call   802023 <sys_enable_interrupt>
	return cnt;
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	83 ec 14             	sub    $0x14,%esp
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b55:	77 55                	ja     800bac <printnum+0x75>
  800b57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b5a:	72 05                	jb     800b61 <printnum+0x2a>
  800b5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b5f:	77 4b                	ja     800bac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b67:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	52                   	push   %edx
  800b70:	50                   	push   %eax
  800b71:	ff 75 f4             	pushl  -0xc(%ebp)
  800b74:	ff 75 f0             	pushl  -0x10(%ebp)
  800b77:	e8 b0 18 00 00       	call   80242c <__udivdi3>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	ff 75 20             	pushl  0x20(%ebp)
  800b85:	53                   	push   %ebx
  800b86:	ff 75 18             	pushl  0x18(%ebp)
  800b89:	52                   	push   %edx
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 a1 ff ff ff       	call   800b37 <printnum>
  800b96:	83 c4 20             	add    $0x20,%esp
  800b99:	eb 1a                	jmp    800bb5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	ff 75 20             	pushl  0x20(%ebp)
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bac:	ff 4d 1c             	decl   0x1c(%ebp)
  800baf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bb3:	7f e6                	jg     800b9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bb5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	53                   	push   %ebx
  800bc4:	51                   	push   %ecx
  800bc5:	52                   	push   %edx
  800bc6:	50                   	push   %eax
  800bc7:	e8 70 19 00 00       	call   80253c <__umoddi3>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	05 34 2c 80 00       	add    $0x802c34,%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	0f be c0             	movsbl %al,%eax
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	50                   	push   %eax
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
}
  800be8:	90                   	nop
  800be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf5:	7e 1c                	jle    800c13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	8d 50 08             	lea    0x8(%eax),%edx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 10                	mov    %edx,(%eax)
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	83 e8 08             	sub    $0x8,%eax
  800c0c:	8b 50 04             	mov    0x4(%eax),%edx
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	eb 40                	jmp    800c53 <getuint+0x65>
	else if (lflag)
  800c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c17:	74 1e                	je     800c37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	8d 50 04             	lea    0x4(%eax),%edx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 10                	mov    %edx,(%eax)
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	83 e8 04             	sub    $0x4,%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	eb 1c                	jmp    800c53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	8d 50 04             	lea    0x4(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 10                	mov    %edx,(%eax)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c5c:	7e 1c                	jle    800c7a <getint+0x25>
		return va_arg(*ap, long long);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	8d 50 08             	lea    0x8(%eax),%edx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 10                	mov    %edx,(%eax)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	83 e8 08             	sub    $0x8,%eax
  800c73:	8b 50 04             	mov    0x4(%eax),%edx
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	eb 38                	jmp    800cb2 <getint+0x5d>
	else if (lflag)
  800c7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7e:	74 1a                	je     800c9a <getint+0x45>
		return va_arg(*ap, long);
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	8d 50 04             	lea    0x4(%eax),%edx
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	89 10                	mov    %edx,(%eax)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8b 00                	mov    (%eax),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	99                   	cltd   
  800c98:	eb 18                	jmp    800cb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 10                	mov    %edx,(%eax)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax
  800cb1:	99                   	cltd   
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	eb 17                	jmp    800cd5 <vprintfmt+0x21>
			if (ch == '\0')
  800cbe:	85 db                	test   %ebx,%ebx
  800cc0:	0f 84 af 03 00 00    	je     801075 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800cc6:	83 ec 08             	sub    $0x8,%esp
  800cc9:	ff 75 0c             	pushl  0xc(%ebp)
  800ccc:	53                   	push   %ebx
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd8:	8d 50 01             	lea    0x1(%eax),%edx
  800cdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d8             	movzbl %al,%ebx
  800ce3:	83 fb 25             	cmp    $0x25,%ebx
  800ce6:	75 d6                	jne    800cbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ce8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	8d 50 01             	lea    0x1(%eax),%edx
  800d0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 d8             	movzbl %al,%ebx
  800d16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d19:	83 f8 55             	cmp    $0x55,%eax
  800d1c:	0f 87 2b 03 00 00    	ja     80104d <vprintfmt+0x399>
  800d22:	8b 04 85 58 2c 80 00 	mov    0x802c58(,%eax,4),%eax
  800d29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d2f:	eb d7                	jmp    800d08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d35:	eb d1                	jmp    800d08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d41:	89 d0                	mov    %edx,%eax
  800d43:	c1 e0 02             	shl    $0x2,%eax
  800d46:	01 d0                	add    %edx,%eax
  800d48:	01 c0                	add    %eax,%eax
  800d4a:	01 d8                	add    %ebx,%eax
  800d4c:	83 e8 30             	sub    $0x30,%eax
  800d4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d5d:	7e 3e                	jle    800d9d <vprintfmt+0xe9>
  800d5f:	83 fb 39             	cmp    $0x39,%ebx
  800d62:	7f 39                	jg     800d9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d67:	eb d5                	jmp    800d3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	83 c0 04             	add    $0x4,%eax
  800d6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	83 e8 04             	sub    $0x4,%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d7d:	eb 1f                	jmp    800d9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d83:	79 83                	jns    800d08 <vprintfmt+0x54>
				width = 0;
  800d85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d8c:	e9 77 ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d98:	e9 6b ff ff ff       	jmp    800d08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da2:	0f 89 60 ff ff ff    	jns    800d08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800db5:	e9 4e ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dbd:	e9 46 ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc5:	83 c0 04             	add    $0x4,%eax
  800dc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	83 e8 04             	sub    $0x4,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	50                   	push   %eax
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	ff d0                	call   *%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
			break;
  800de2:	e9 89 02 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	83 c0 04             	add    $0x4,%eax
  800ded:	89 45 14             	mov    %eax,0x14(%ebp)
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	83 e8 04             	sub    $0x4,%eax
  800df6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800df8:	85 db                	test   %ebx,%ebx
  800dfa:	79 02                	jns    800dfe <vprintfmt+0x14a>
				err = -err;
  800dfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dfe:	83 fb 64             	cmp    $0x64,%ebx
  800e01:	7f 0b                	jg     800e0e <vprintfmt+0x15a>
  800e03:	8b 34 9d a0 2a 80 00 	mov    0x802aa0(,%ebx,4),%esi
  800e0a:	85 f6                	test   %esi,%esi
  800e0c:	75 19                	jne    800e27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e0e:	53                   	push   %ebx
  800e0f:	68 45 2c 80 00       	push   $0x802c45
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	ff 75 08             	pushl  0x8(%ebp)
  800e1a:	e8 5e 02 00 00       	call   80107d <printfmt>
  800e1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e22:	e9 49 02 00 00       	jmp    801070 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e27:	56                   	push   %esi
  800e28:	68 4e 2c 80 00       	push   $0x802c4e
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 45 02 00 00       	call   80107d <printfmt>
  800e38:	83 c4 10             	add    $0x10,%esp
			break;
  800e3b:	e9 30 02 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e40:	8b 45 14             	mov    0x14(%ebp),%eax
  800e43:	83 c0 04             	add    $0x4,%eax
  800e46:	89 45 14             	mov    %eax,0x14(%ebp)
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	83 e8 04             	sub    $0x4,%eax
  800e4f:	8b 30                	mov    (%eax),%esi
  800e51:	85 f6                	test   %esi,%esi
  800e53:	75 05                	jne    800e5a <vprintfmt+0x1a6>
				p = "(null)";
  800e55:	be 51 2c 80 00       	mov    $0x802c51,%esi
			if (width > 0 && padc != '-')
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	7e 6d                	jle    800ecd <vprintfmt+0x219>
  800e60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e64:	74 67                	je     800ecd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	50                   	push   %eax
  800e6d:	56                   	push   %esi
  800e6e:	e8 0c 03 00 00       	call   80117f <strnlen>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e79:	eb 16                	jmp    800e91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	50                   	push   %eax
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	ff d0                	call   *%eax
  800e8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e95:	7f e4                	jg     800e7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e97:	eb 34                	jmp    800ecd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e9d:	74 1c                	je     800ebb <vprintfmt+0x207>
  800e9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800ea2:	7e 05                	jle    800ea9 <vprintfmt+0x1f5>
  800ea4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ea7:	7e 12                	jle    800ebb <vprintfmt+0x207>
					putch('?', putdat);
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	6a 3f                	push   $0x3f
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	eb 0f                	jmp    800eca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	53                   	push   %ebx
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	ff d0                	call   *%eax
  800ec7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eca:	ff 4d e4             	decl   -0x1c(%ebp)
  800ecd:	89 f0                	mov    %esi,%eax
  800ecf:	8d 70 01             	lea    0x1(%eax),%esi
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f be d8             	movsbl %al,%ebx
  800ed7:	85 db                	test   %ebx,%ebx
  800ed9:	74 24                	je     800eff <vprintfmt+0x24b>
  800edb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edf:	78 b8                	js     800e99 <vprintfmt+0x1e5>
  800ee1:	ff 4d e0             	decl   -0x20(%ebp)
  800ee4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee8:	79 af                	jns    800e99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eea:	eb 13                	jmp    800eff <vprintfmt+0x24b>
				putch(' ', putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	6a 20                	push   $0x20
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800efc:	ff 4d e4             	decl   -0x1c(%ebp)
  800eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f03:	7f e7                	jg     800eec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f05:	e9 66 01 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800f10:	8d 45 14             	lea    0x14(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	e8 3c fd ff ff       	call   800c55 <getint>
  800f19:	83 c4 10             	add    $0x10,%esp
  800f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f28:	85 d2                	test   %edx,%edx
  800f2a:	79 23                	jns    800f4f <vprintfmt+0x29b>
				putch('-', putdat);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 0c             	pushl  0xc(%ebp)
  800f32:	6a 2d                	push   $0x2d
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	ff d0                	call   *%eax
  800f39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f42:	f7 d8                	neg    %eax
  800f44:	83 d2 00             	adc    $0x0,%edx
  800f47:	f7 da                	neg    %edx
  800f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f56:	e9 bc 00 00 00       	jmp    801017 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f61:	8d 45 14             	lea    0x14(%ebp),%eax
  800f64:	50                   	push   %eax
  800f65:	e8 84 fc ff ff       	call   800bee <getuint>
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f7a:	e9 98 00 00 00       	jmp    801017 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	6a 58                	push   $0x58
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 58                	push   $0x58
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	6a 58                	push   $0x58
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff d0                	call   *%eax
  800fac:	83 c4 10             	add    $0x10,%esp
			break;
  800faf:	e9 bc 00 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	6a 30                	push   $0x30
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	ff 75 0c             	pushl  0xc(%ebp)
  800fca:	6a 78                	push   $0x78
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	ff d0                	call   *%eax
  800fd1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	83 c0 04             	add    $0x4,%eax
  800fda:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe0:	83 e8 04             	sub    $0x4,%eax
  800fe3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ff6:	eb 1f                	jmp    801017 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ffe:	8d 45 14             	lea    0x14(%ebp),%eax
  801001:	50                   	push   %eax
  801002:	e8 e7 fb ff ff       	call   800bee <getuint>
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801010:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801017:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80101b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	52                   	push   %edx
  801022:	ff 75 e4             	pushl  -0x1c(%ebp)
  801025:	50                   	push   %eax
  801026:	ff 75 f4             	pushl  -0xc(%ebp)
  801029:	ff 75 f0             	pushl  -0x10(%ebp)
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	ff 75 08             	pushl  0x8(%ebp)
  801032:	e8 00 fb ff ff       	call   800b37 <printnum>
  801037:	83 c4 20             	add    $0x20,%esp
			break;
  80103a:	eb 34                	jmp    801070 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80103c:	83 ec 08             	sub    $0x8,%esp
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	53                   	push   %ebx
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			break;
  80104b:	eb 23                	jmp    801070 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	6a 25                	push   $0x25
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	ff d0                	call   *%eax
  80105a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105d:	ff 4d 10             	decl   0x10(%ebp)
  801060:	eb 03                	jmp    801065 <vprintfmt+0x3b1>
  801062:	ff 4d 10             	decl   0x10(%ebp)
  801065:	8b 45 10             	mov    0x10(%ebp),%eax
  801068:	48                   	dec    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 25                	cmp    $0x25,%al
  80106d:	75 f3                	jne    801062 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80106f:	90                   	nop
		}
	}
  801070:	e9 47 fc ff ff       	jmp    800cbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801075:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801076:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801083:	8d 45 10             	lea    0x10(%ebp),%eax
  801086:	83 c0 04             	add    $0x4,%eax
  801089:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	ff 75 f4             	pushl  -0xc(%ebp)
  801092:	50                   	push   %eax
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	ff 75 08             	pushl  0x8(%ebp)
  801099:	e8 16 fc ff ff       	call   800cb4 <vprintfmt>
  80109e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a1:	90                   	nop
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8b 40 08             	mov    0x8(%eax),%eax
  8010ad:	8d 50 01             	lea    0x1(%eax),%edx
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	8b 10                	mov    (%eax),%edx
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	8b 40 04             	mov    0x4(%eax),%eax
  8010c1:	39 c2                	cmp    %eax,%edx
  8010c3:	73 12                	jae    8010d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8010cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d0:	89 0a                	mov    %ecx,(%edx)
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	88 10                	mov    %dl,(%eax)
}
  8010d7:	90                   	nop
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	01 d0                	add    %edx,%eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ff:	74 06                	je     801107 <vsnprintf+0x2d>
  801101:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801105:	7f 07                	jg     80110e <vsnprintf+0x34>
		return -E_INVAL;
  801107:	b8 03 00 00 00       	mov    $0x3,%eax
  80110c:	eb 20                	jmp    80112e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80110e:	ff 75 14             	pushl  0x14(%ebp)
  801111:	ff 75 10             	pushl  0x10(%ebp)
  801114:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801117:	50                   	push   %eax
  801118:	68 a4 10 80 00       	push   $0x8010a4
  80111d:	e8 92 fb ff ff       	call   800cb4 <vprintfmt>
  801122:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801128:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80112b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801136:	8d 45 10             	lea    0x10(%ebp),%eax
  801139:	83 c0 04             	add    $0x4,%eax
  80113c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	ff 75 f4             	pushl  -0xc(%ebp)
  801145:	50                   	push   %eax
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	e8 89 ff ff ff       	call   8010da <vsnprintf>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801157:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801169:	eb 06                	jmp    801171 <strlen+0x15>
		n++;
  80116b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	75 f1                	jne    80116b <strlen+0xf>
		n++;
	return n;
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118c:	eb 09                	jmp    801197 <strnlen+0x18>
		n++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801191:	ff 45 08             	incl   0x8(%ebp)
  801194:	ff 4d 0c             	decl   0xc(%ebp)
  801197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119b:	74 09                	je     8011a6 <strnlen+0x27>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	84 c0                	test   %al,%al
  8011a4:	75 e8                	jne    80118e <strnlen+0xf>
		n++;
	return n;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011b7:	90                   	nop
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8d 50 01             	lea    0x1(%eax),%edx
  8011be:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011ca:	8a 12                	mov    (%edx),%dl
  8011cc:	88 10                	mov    %dl,(%eax)
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	75 e4                	jne    8011b8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ec:	eb 1f                	jmp    80120d <strncpy+0x34>
		*dst++ = *src;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8d 50 01             	lea    0x1(%eax),%edx
  8011f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fa:	8a 12                	mov    (%edx),%dl
  8011fc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	74 03                	je     80120a <strncpy+0x31>
			src++;
  801207:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80120a:	ff 45 fc             	incl   -0x4(%ebp)
  80120d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801210:	3b 45 10             	cmp    0x10(%ebp),%eax
  801213:	72 d9                	jb     8011ee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801215:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122a:	74 30                	je     80125c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80122c:	eb 16                	jmp    801244 <strlcpy+0x2a>
			*dst++ = *src++;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8d 50 01             	lea    0x1(%eax),%edx
  801234:	89 55 08             	mov    %edx,0x8(%ebp)
  801237:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80123d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801240:	8a 12                	mov    (%edx),%dl
  801242:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801244:	ff 4d 10             	decl   0x10(%ebp)
  801247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124b:	74 09                	je     801256 <strlcpy+0x3c>
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	75 d8                	jne    80122e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80125c:	8b 55 08             	mov    0x8(%ebp),%edx
  80125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801262:	29 c2                	sub    %eax,%edx
  801264:	89 d0                	mov    %edx,%eax
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80126b:	eb 06                	jmp    801273 <strcmp+0xb>
		p++, q++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
  801270:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	84 c0                	test   %al,%al
  80127a:	74 0e                	je     80128a <strcmp+0x22>
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 10                	mov    (%eax),%dl
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	38 c2                	cmp    %al,%dl
  801288:	74 e3                	je     80126d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	0f b6 d0             	movzbl %al,%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f b6 c0             	movzbl %al,%eax
  80129a:	29 c2                	sub    %eax,%edx
  80129c:	89 d0                	mov    %edx,%eax
}
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012a3:	eb 09                	jmp    8012ae <strncmp+0xe>
		n--, p++, q++;
  8012a5:	ff 4d 10             	decl   0x10(%ebp)
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b2:	74 17                	je     8012cb <strncmp+0x2b>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	84 c0                	test   %al,%al
  8012bb:	74 0e                	je     8012cb <strncmp+0x2b>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 10                	mov    (%eax),%dl
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	38 c2                	cmp    %al,%dl
  8012c9:	74 da                	je     8012a5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 07                	jne    8012d8 <strncmp+0x38>
		return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb 14                	jmp    8012ec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	0f b6 d0             	movzbl %al,%edx
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	0f b6 c0             	movzbl %al,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
}
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012fa:	eb 12                	jmp    80130e <strchr+0x20>
		if (*s == c)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801304:	75 05                	jne    80130b <strchr+0x1d>
			return (char *) s;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	eb 11                	jmp    80131c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80130b:	ff 45 08             	incl   0x8(%ebp)
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e5                	jne    8012fc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80132a:	eb 0d                	jmp    801339 <strfind+0x1b>
		if (*s == c)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801334:	74 0e                	je     801344 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 ea                	jne    80132c <strfind+0xe>
  801342:	eb 01                	jmp    801345 <strfind+0x27>
		if (*s == c)
			break;
  801344:	90                   	nop
	return (char *) s;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80135c:	eb 0e                	jmp    80136c <memset+0x22>
		*p++ = c;
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80136c:	ff 4d f8             	decl   -0x8(%ebp)
  80136f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801373:	79 e9                	jns    80135e <memset+0x14>
		*p++ = c;

	return v;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80138c:	eb 16                	jmp    8013a4 <memcpy+0x2a>
		*d++ = *s++;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801397:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 dd                	jne    80138e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ce:	73 50                	jae    801420 <memmove+0x6a>
  8013d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013db:	76 43                	jbe    801420 <memmove+0x6a>
		s += n;
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013e9:	eb 10                	jmp    8013fb <memmove+0x45>
			*--d = *--s;
  8013eb:	ff 4d f8             	decl   -0x8(%ebp)
  8013ee:	ff 4d fc             	decl   -0x4(%ebp)
  8013f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f4:	8a 10                	mov    (%eax),%dl
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801401:	89 55 10             	mov    %edx,0x10(%ebp)
  801404:	85 c0                	test   %eax,%eax
  801406:	75 e3                	jne    8013eb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801408:	eb 23                	jmp    80142d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80140a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140d:	8d 50 01             	lea    0x1(%eax),%edx
  801410:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801413:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801416:	8d 4a 01             	lea    0x1(%edx),%ecx
  801419:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80141c:	8a 12                	mov    (%edx),%dl
  80141e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	8d 50 ff             	lea    -0x1(%eax),%edx
  801426:	89 55 10             	mov    %edx,0x10(%ebp)
  801429:	85 c0                	test   %eax,%eax
  80142b:	75 dd                	jne    80140a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801444:	eb 2a                	jmp    801470 <memcmp+0x3e>
		if (*s1 != *s2)
  801446:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801449:	8a 10                	mov    (%eax),%dl
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	38 c2                	cmp    %al,%dl
  801452:	74 16                	je     80146a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	0f b6 d0             	movzbl %al,%edx
  80145c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	0f b6 c0             	movzbl %al,%eax
  801464:	29 c2                	sub    %eax,%edx
  801466:	89 d0                	mov    %edx,%eax
  801468:	eb 18                	jmp    801482 <memcmp+0x50>
		s1++, s2++;
  80146a:	ff 45 fc             	incl   -0x4(%ebp)
  80146d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	8d 50 ff             	lea    -0x1(%eax),%edx
  801476:	89 55 10             	mov    %edx,0x10(%ebp)
  801479:	85 c0                	test   %eax,%eax
  80147b:	75 c9                	jne    801446 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80148a:	8b 55 08             	mov    0x8(%ebp),%edx
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	01 d0                	add    %edx,%eax
  801492:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801495:	eb 15                	jmp    8014ac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	0f b6 d0             	movzbl %al,%edx
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	0f b6 c0             	movzbl %al,%eax
  8014a5:	39 c2                	cmp    %eax,%edx
  8014a7:	74 0d                	je     8014b6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b2:	72 e3                	jb     801497 <memfind+0x13>
  8014b4:	eb 01                	jmp    8014b7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014b6:	90                   	nop
	return (void *) s;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d0:	eb 03                	jmp    8014d5 <strtol+0x19>
		s++;
  8014d2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 20                	cmp    $0x20,%al
  8014dc:	74 f4                	je     8014d2 <strtol+0x16>
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3c 09                	cmp    $0x9,%al
  8014e5:	74 eb                	je     8014d2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	3c 2b                	cmp    $0x2b,%al
  8014ee:	75 05                	jne    8014f5 <strtol+0x39>
		s++;
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	eb 13                	jmp    801508 <strtol+0x4c>
	else if (*s == '-')
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	3c 2d                	cmp    $0x2d,%al
  8014fc:	75 0a                	jne    801508 <strtol+0x4c>
		s++, neg = 1;
  8014fe:	ff 45 08             	incl   0x8(%ebp)
  801501:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801508:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150c:	74 06                	je     801514 <strtol+0x58>
  80150e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801512:	75 20                	jne    801534 <strtol+0x78>
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 30                	cmp    $0x30,%al
  80151b:	75 17                	jne    801534 <strtol+0x78>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	40                   	inc    %eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 78                	cmp    $0x78,%al
  801525:	75 0d                	jne    801534 <strtol+0x78>
		s += 2, base = 16;
  801527:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80152b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801532:	eb 28                	jmp    80155c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801534:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801538:	75 15                	jne    80154f <strtol+0x93>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	3c 30                	cmp    $0x30,%al
  801541:	75 0c                	jne    80154f <strtol+0x93>
		s++, base = 8;
  801543:	ff 45 08             	incl   0x8(%ebp)
  801546:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80154d:	eb 0d                	jmp    80155c <strtol+0xa0>
	else if (base == 0)
  80154f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801553:	75 07                	jne    80155c <strtol+0xa0>
		base = 10;
  801555:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	3c 2f                	cmp    $0x2f,%al
  801563:	7e 19                	jle    80157e <strtol+0xc2>
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	3c 39                	cmp    $0x39,%al
  80156c:	7f 10                	jg     80157e <strtol+0xc2>
			dig = *s - '0';
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	0f be c0             	movsbl %al,%eax
  801576:	83 e8 30             	sub    $0x30,%eax
  801579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157c:	eb 42                	jmp    8015c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	3c 60                	cmp    $0x60,%al
  801585:	7e 19                	jle    8015a0 <strtol+0xe4>
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	3c 7a                	cmp    $0x7a,%al
  80158e:	7f 10                	jg     8015a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f be c0             	movsbl %al,%eax
  801598:	83 e8 57             	sub    $0x57,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159e:	eb 20                	jmp    8015c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3c 40                	cmp    $0x40,%al
  8015a7:	7e 39                	jle    8015e2 <strtol+0x126>
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3c 5a                	cmp    $0x5a,%al
  8015b0:	7f 30                	jg     8015e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	0f be c0             	movsbl %al,%eax
  8015ba:	83 e8 37             	sub    $0x37,%eax
  8015bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015c6:	7d 19                	jge    8015e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015c8:	ff 45 08             	incl   0x8(%ebp)
  8015cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015dc:	e9 7b ff ff ff       	jmp    80155c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e6:	74 08                	je     8015f0 <strtol+0x134>
		*endptr = (char *) s;
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015f4:	74 07                	je     8015fd <strtol+0x141>
  8015f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f9:	f7 d8                	neg    %eax
  8015fb:	eb 03                	jmp    801600 <strtol+0x144>
  8015fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <ltostr>:

void
ltostr(long value, char *str)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801608:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80160f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161a:	79 13                	jns    80162f <ltostr+0x2d>
	{
		neg = 1;
  80161c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801629:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80162c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801637:	99                   	cltd   
  801638:	f7 f9                	idiv   %ecx
  80163a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80163d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801640:	8d 50 01             	lea    0x1(%eax),%edx
  801643:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801646:	89 c2                	mov    %eax,%edx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801650:	83 c2 30             	add    $0x30,%edx
  801653:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801655:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801658:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80165d:	f7 e9                	imul   %ecx
  80165f:	c1 fa 02             	sar    $0x2,%edx
  801662:	89 c8                	mov    %ecx,%eax
  801664:	c1 f8 1f             	sar    $0x1f,%eax
  801667:	29 c2                	sub    %eax,%edx
  801669:	89 d0                	mov    %edx,%eax
  80166b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80166e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801671:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801676:	f7 e9                	imul   %ecx
  801678:	c1 fa 02             	sar    $0x2,%edx
  80167b:	89 c8                	mov    %ecx,%eax
  80167d:	c1 f8 1f             	sar    $0x1f,%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
  801684:	c1 e0 02             	shl    $0x2,%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	29 c1                	sub    %eax,%ecx
  80168d:	89 ca                	mov    %ecx,%edx
  80168f:	85 d2                	test   %edx,%edx
  801691:	75 9c                	jne    80162f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80169a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169d:	48                   	dec    %eax
  80169e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016a5:	74 3d                	je     8016e4 <ltostr+0xe2>
		start = 1 ;
  8016a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016ae:	eb 34                	jmp    8016e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	01 c2                	add    %eax,%edx
  8016c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	01 c8                	add    %ecx,%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d7:	01 c2                	add    %eax,%edx
  8016d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8016de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ea:	7c c4                	jl     8016b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	e8 54 fa ff ff       	call   80115c <strlen>
  801708:	83 c4 04             	add    $0x4,%esp
  80170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	e8 46 fa ff ff       	call   80115c <strlen>
  801716:	83 c4 04             	add    $0x4,%esp
  801719:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80171c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801723:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80172a:	eb 17                	jmp    801743 <strcconcat+0x49>
		final[s] = str1[s] ;
  80172c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	01 c2                	add    %eax,%edx
  801734:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	01 c8                	add    %ecx,%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801740:	ff 45 fc             	incl   -0x4(%ebp)
  801743:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801746:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801749:	7c e1                	jl     80172c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80174b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801752:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801759:	eb 1f                	jmp    80177a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80175b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80175e:	8d 50 01             	lea    0x1(%eax),%edx
  801761:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801764:	89 c2                	mov    %eax,%edx
  801766:	8b 45 10             	mov    0x10(%ebp),%eax
  801769:	01 c2                	add    %eax,%edx
  80176b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	01 c8                	add    %ecx,%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801777:	ff 45 f8             	incl   -0x8(%ebp)
  80177a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801780:	7c d9                	jl     80175b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801782:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c6 00 00             	movb   $0x0,(%eax)
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801793:	8b 45 14             	mov    0x14(%ebp),%eax
  801796:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017b3:	eb 0c                	jmp    8017c1 <strsplit+0x31>
			*string++ = 0;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8d 50 01             	lea    0x1(%eax),%edx
  8017bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8017be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	84 c0                	test   %al,%al
  8017c8:	74 18                	je     8017e2 <strsplit+0x52>
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8a 00                	mov    (%eax),%al
  8017cf:	0f be c0             	movsbl %al,%eax
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	e8 13 fb ff ff       	call   8012ee <strchr>
  8017db:	83 c4 08             	add    $0x8,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	75 d3                	jne    8017b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	84 c0                	test   %al,%al
  8017e9:	74 5a                	je     801845 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ee:	8b 00                	mov    (%eax),%eax
  8017f0:	83 f8 0f             	cmp    $0xf,%eax
  8017f3:	75 07                	jne    8017fc <strsplit+0x6c>
		{
			return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	eb 66                	jmp    801862 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ff:	8b 00                	mov    (%eax),%eax
  801801:	8d 48 01             	lea    0x1(%eax),%ecx
  801804:	8b 55 14             	mov    0x14(%ebp),%edx
  801807:	89 0a                	mov    %ecx,(%edx)
  801809:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	01 c2                	add    %eax,%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80181a:	eb 03                	jmp    80181f <strsplit+0x8f>
			string++;
  80181c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	84 c0                	test   %al,%al
  801826:	74 8b                	je     8017b3 <strsplit+0x23>
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	0f be c0             	movsbl %al,%eax
  801830:	50                   	push   %eax
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	e8 b5 fa ff ff       	call   8012ee <strchr>
  801839:	83 c4 08             	add    $0x8,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 dc                	je     80181c <strsplit+0x8c>
			string++;
	}
  801840:	e9 6e ff ff ff       	jmp    8017b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801845:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80185d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  80186a:	a1 28 30 80 00       	mov    0x803028,%eax
  80186f:	85 c0                	test   %eax,%eax
  801871:	75 33                	jne    8018a6 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801873:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  80187a:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  80187d:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801884:	00 00 a0 
		spaces[0].pages = numPages;
  801887:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  80188e:	00 02 00 
		spaces[0].isFree = 1;
  801891:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801898:	00 00 00 
		arraySize++;
  80189b:	a1 28 30 80 00       	mov    0x803028,%eax
  8018a0:	40                   	inc    %eax
  8018a1:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  8018a6:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  8018ad:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  8018b4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8018bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c1:	01 d0                	add    %edx,%eax
  8018c3:	48                   	dec    %eax
  8018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cf:	f7 75 e8             	divl   -0x18(%ebp)
  8018d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d5:	29 d0                	sub    %edx,%eax
  8018d7:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	c1 e8 0c             	shr    $0xc,%eax
  8018e0:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8018e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8018ea:	eb 57                	jmp    801943 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8018ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ef:	c1 e0 04             	shl    $0x4,%eax
  8018f2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8018f7:	8b 00                	mov    (%eax),%eax
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	74 42                	je     80193f <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8018fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801900:	c1 e0 04             	shl    $0x4,%eax
  801903:	05 28 31 80 00       	add    $0x803128,%eax
  801908:	8b 00                	mov    (%eax),%eax
  80190a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80190d:	7c 31                	jl     801940 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  80190f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801912:	c1 e0 04             	shl    $0x4,%eax
  801915:	05 28 31 80 00       	add    $0x803128,%eax
  80191a:	8b 00                	mov    (%eax),%eax
  80191c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80191f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801922:	7d 1c                	jge    801940 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801927:	c1 e0 04             	shl    $0x4,%eax
  80192a:	05 28 31 80 00       	add    $0x803128,%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801934:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80193d:	eb 01                	jmp    801940 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80193f:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801940:	ff 45 ec             	incl   -0x14(%ebp)
  801943:	a1 28 30 80 00       	mov    0x803028,%eax
  801948:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80194b:	7c 9f                	jl     8018ec <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  80194d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801951:	75 0a                	jne    80195d <malloc+0xf9>
	{
		return NULL;
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
  801958:	e9 34 01 00 00       	jmp    801a91 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  80195d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801960:	c1 e0 04             	shl    $0x4,%eax
  801963:	05 28 31 80 00       	add    $0x803128,%eax
  801968:	8b 00                	mov    (%eax),%eax
  80196a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80196d:	75 38                	jne    8019a7 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	c1 e0 04             	shl    $0x4,%eax
  801975:	05 2c 31 80 00       	add    $0x80312c,%eax
  80197a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801983:	c1 e0 0c             	shl    $0xc,%eax
  801986:	89 c2                	mov    %eax,%edx
  801988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198b:	c1 e0 04             	shl    $0x4,%eax
  80198e:	05 20 31 80 00       	add    $0x803120,%eax
  801993:	8b 00                	mov    (%eax),%eax
  801995:	83 ec 08             	sub    $0x8,%esp
  801998:	52                   	push   %edx
  801999:	50                   	push   %eax
  80199a:	e8 01 06 00 00       	call   801fa0 <sys_allocateMem>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	e9 dd 00 00 00       	jmp    801a84 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019aa:	c1 e0 04             	shl    $0x4,%eax
  8019ad:	05 20 31 80 00       	add    $0x803120,%eax
  8019b2:	8b 00                	mov    (%eax),%eax
  8019b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b7:	c1 e2 0c             	shl    $0xc,%edx
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8019bf:	a1 28 30 80 00       	mov    0x803028,%eax
  8019c4:	c1 e0 04             	shl    $0x4,%eax
  8019c7:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  8019cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019d0:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8019d2:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	c1 e0 04             	shl    $0x4,%eax
  8019de:	05 24 31 80 00       	add    $0x803124,%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	c1 e2 04             	shl    $0x4,%edx
  8019e8:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8019ee:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8019f0:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8019f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f9:	c1 e0 04             	shl    $0x4,%eax
  8019fc:	05 28 31 80 00       	add    $0x803128,%eax
  801a01:	8b 00                	mov    (%eax),%eax
  801a03:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801a06:	c1 e2 04             	shl    $0x4,%edx
  801a09:	81 c2 28 31 80 00    	add    $0x803128,%edx
  801a0f:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801a11:	a1 28 30 80 00       	mov    0x803028,%eax
  801a16:	c1 e0 04             	shl    $0x4,%eax
  801a19:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a1e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801a24:	a1 28 30 80 00       	mov    0x803028,%eax
  801a29:	40                   	inc    %eax
  801a2a:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a32:	c1 e0 04             	shl    $0x4,%eax
  801a35:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  801a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a3e:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a43:	c1 e0 04             	shl    $0x4,%eax
  801a46:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  801a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a4f:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a54:	c1 e0 04             	shl    $0x4,%eax
  801a57:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a65:	c1 e0 0c             	shl    $0xc,%eax
  801a68:	89 c2                	mov    %eax,%edx
  801a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6d:	c1 e0 04             	shl    $0x4,%eax
  801a70:	05 20 31 80 00       	add    $0x803120,%eax
  801a75:	8b 00                	mov    (%eax),%eax
  801a77:	83 ec 08             	sub    $0x8,%esp
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	e8 1f 05 00 00       	call   801fa0 <sys_allocateMem>
  801a81:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	c1 e0 04             	shl    $0x4,%eax
  801a8a:	05 20 31 80 00       	add    $0x803120,%eax
  801a8f:	8b 00                	mov    (%eax),%eax
	}


}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801a99:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801aa0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801aa7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801aae:	eb 3f                	jmp    801aef <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab3:	c1 e0 04             	shl    $0x4,%eax
  801ab6:	05 20 31 80 00       	add    $0x803120,%eax
  801abb:	8b 00                	mov    (%eax),%eax
  801abd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ac0:	75 2a                	jne    801aec <free+0x59>
		{
			index=i;
  801ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acb:	c1 e0 04             	shl    $0x4,%eax
  801ace:	05 28 31 80 00       	add    $0x803128,%eax
  801ad3:	8b 00                	mov    (%eax),%eax
  801ad5:	c1 e0 0c             	shl    $0xc,%eax
  801ad8:	89 c2                	mov    %eax,%edx
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	e8 9d 04 00 00       	call   801f84 <sys_freeMem>
  801ae7:	83 c4 10             	add    $0x10,%esp
			break;
  801aea:	eb 0d                	jmp    801af9 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801aec:	ff 45 ec             	incl   -0x14(%ebp)
  801aef:	a1 28 30 80 00       	mov    0x803028,%eax
  801af4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801af7:	7c b7                	jl     801ab0 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801af9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801afd:	75 17                	jne    801b16 <free+0x83>
	{
		panic("Error");
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	68 b0 2d 80 00       	push   $0x802db0
  801b07:	68 81 00 00 00       	push   $0x81
  801b0c:	68 b6 2d 80 00       	push   $0x802db6
  801b11:	e8 22 ed ff ff       	call   800838 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801b16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b1d:	e9 cc 00 00 00       	jmp    801bee <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801b22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b25:	c1 e0 04             	shl    $0x4,%eax
  801b28:	05 2c 31 80 00       	add    $0x80312c,%eax
  801b2d:	8b 00                	mov    (%eax),%eax
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	0f 84 b3 00 00 00    	je     801bea <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	c1 e0 04             	shl    $0x4,%eax
  801b3d:	05 20 31 80 00       	add    $0x803120,%eax
  801b42:	8b 10                	mov    (%eax),%edx
  801b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b47:	c1 e0 04             	shl    $0x4,%eax
  801b4a:	05 24 31 80 00       	add    $0x803124,%eax
  801b4f:	8b 00                	mov    (%eax),%eax
  801b51:	39 c2                	cmp    %eax,%edx
  801b53:	0f 85 92 00 00 00    	jne    801beb <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5c:	c1 e0 04             	shl    $0x4,%eax
  801b5f:	05 24 31 80 00       	add    $0x803124,%eax
  801b64:	8b 00                	mov    (%eax),%eax
  801b66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b69:	c1 e2 04             	shl    $0x4,%edx
  801b6c:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801b72:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b77:	c1 e0 04             	shl    $0x4,%eax
  801b7a:	05 28 31 80 00       	add    $0x803128,%eax
  801b7f:	8b 10                	mov    (%eax),%edx
  801b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b84:	c1 e0 04             	shl    $0x4,%eax
  801b87:	05 28 31 80 00       	add    $0x803128,%eax
  801b8c:	8b 00                	mov    (%eax),%eax
  801b8e:	01 c2                	add    %eax,%edx
  801b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b93:	c1 e0 04             	shl    $0x4,%eax
  801b96:	05 28 31 80 00       	add    $0x803128,%eax
  801b9b:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	c1 e0 04             	shl    $0x4,%eax
  801ba3:	05 20 31 80 00       	add    $0x803120,%eax
  801ba8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	c1 e0 04             	shl    $0x4,%eax
  801bb4:	05 24 31 80 00       	add    $0x803124,%eax
  801bb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc2:	c1 e0 04             	shl    $0x4,%eax
  801bc5:	05 28 31 80 00       	add    $0x803128,%eax
  801bca:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	c1 e0 04             	shl    $0x4,%eax
  801bd6:	05 2c 31 80 00       	add    $0x80312c,%eax
  801bdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801be1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801be8:	eb 12                	jmp    801bfc <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801bea:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801beb:	ff 45 e8             	incl   -0x18(%ebp)
  801bee:	a1 28 30 80 00       	mov    0x803028,%eax
  801bf3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801bf6:	0f 8c 26 ff ff ff    	jl     801b22 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801bfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801c03:	e9 cc 00 00 00       	jmp    801cd4 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0b:	c1 e0 04             	shl    $0x4,%eax
  801c0e:	05 2c 31 80 00       	add    $0x80312c,%eax
  801c13:	8b 00                	mov    (%eax),%eax
  801c15:	85 c0                	test   %eax,%eax
  801c17:	0f 84 b3 00 00 00    	je     801cd0 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	c1 e0 04             	shl    $0x4,%eax
  801c23:	05 24 31 80 00       	add    $0x803124,%eax
  801c28:	8b 10                	mov    (%eax),%edx
  801c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c2d:	c1 e0 04             	shl    $0x4,%eax
  801c30:	05 20 31 80 00       	add    $0x803120,%eax
  801c35:	8b 00                	mov    (%eax),%eax
  801c37:	39 c2                	cmp    %eax,%edx
  801c39:	0f 85 92 00 00 00    	jne    801cd1 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	c1 e0 04             	shl    $0x4,%eax
  801c45:	05 20 31 80 00       	add    $0x803120,%eax
  801c4a:	8b 00                	mov    (%eax),%eax
  801c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c4f:	c1 e2 04             	shl    $0x4,%edx
  801c52:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801c58:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5d:	c1 e0 04             	shl    $0x4,%eax
  801c60:	05 28 31 80 00       	add    $0x803128,%eax
  801c65:	8b 10                	mov    (%eax),%edx
  801c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6a:	c1 e0 04             	shl    $0x4,%eax
  801c6d:	05 28 31 80 00       	add    $0x803128,%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c79:	c1 e0 04             	shl    $0x4,%eax
  801c7c:	05 28 31 80 00       	add    $0x803128,%eax
  801c81:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c86:	c1 e0 04             	shl    $0x4,%eax
  801c89:	05 20 31 80 00       	add    $0x803120,%eax
  801c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c97:	c1 e0 04             	shl    $0x4,%eax
  801c9a:	05 24 31 80 00       	add    $0x803124,%eax
  801c9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca8:	c1 e0 04             	shl    $0x4,%eax
  801cab:	05 28 31 80 00       	add    $0x803128,%eax
  801cb0:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb9:	c1 e0 04             	shl    $0x4,%eax
  801cbc:	05 2c 31 80 00       	add    $0x80312c,%eax
  801cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801cc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801cce:	eb 12                	jmp    801ce2 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801cd0:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801cd1:	ff 45 e4             	incl   -0x1c(%ebp)
  801cd4:	a1 28 30 80 00       	mov    0x803028,%eax
  801cd9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cdc:	0f 8c 26 ff ff ff    	jl     801c08 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801ce2:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801ce6:	75 11                	jne    801cf9 <free+0x266>
	{
		spaces[index].isFree = 1;
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	c1 e0 04             	shl    $0x4,%eax
  801cee:	05 2c 31 80 00       	add    $0x80312c,%eax
  801cf3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 18             	sub    $0x18,%esp
  801d02:	8b 45 10             	mov    0x10(%ebp),%eax
  801d05:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	68 c4 2d 80 00       	push   $0x802dc4
  801d10:	68 b9 00 00 00       	push   $0xb9
  801d15:	68 b6 2d 80 00       	push   $0x802db6
  801d1a:	e8 19 eb ff ff       	call   800838 <_panic>

00801d1f <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	68 c4 2d 80 00       	push   $0x802dc4
  801d2d:	68 bf 00 00 00       	push   $0xbf
  801d32:	68 b6 2d 80 00       	push   $0x802db6
  801d37:	e8 fc ea ff ff       	call   800838 <_panic>

00801d3c <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	68 c4 2d 80 00       	push   $0x802dc4
  801d4a:	68 c5 00 00 00       	push   $0xc5
  801d4f:	68 b6 2d 80 00       	push   $0x802db6
  801d54:	e8 df ea ff ff       	call   800838 <_panic>

00801d59 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	68 c4 2d 80 00       	push   $0x802dc4
  801d67:	68 ca 00 00 00       	push   $0xca
  801d6c:	68 b6 2d 80 00       	push   $0x802db6
  801d71:	e8 c2 ea ff ff       	call   800838 <_panic>

00801d76 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	68 c4 2d 80 00       	push   $0x802dc4
  801d84:	68 d0 00 00 00       	push   $0xd0
  801d89:	68 b6 2d 80 00       	push   $0x802db6
  801d8e:	e8 a5 ea ff ff       	call   800838 <_panic>

00801d93 <shrink>:
}
void shrink(uint32 newSize)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	68 c4 2d 80 00       	push   $0x802dc4
  801da1:	68 d4 00 00 00       	push   $0xd4
  801da6:	68 b6 2d 80 00       	push   $0x802db6
  801dab:	e8 88 ea ff ff       	call   800838 <_panic>

00801db0 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801db6:	83 ec 04             	sub    $0x4,%esp
  801db9:	68 c4 2d 80 00       	push   $0x802dc4
  801dbe:	68 d9 00 00 00       	push   $0xd9
  801dc3:	68 b6 2d 80 00       	push   $0x802db6
  801dc8:	e8 6b ea ff ff       	call   800838 <_panic>

00801dcd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	57                   	push   %edi
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ddf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801de5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801de8:	cd 30                	int    $0x30
  801dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    

00801df8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 04             	sub    $0x4,%esp
  801dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801e01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	50                   	push   %eax
  801e14:	6a 00                	push   $0x0
  801e16:	e8 b2 ff ff ff       	call   801dcd <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	90                   	nop
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 01                	push   $0x1
  801e30:	e8 98 ff ff ff       	call   801dcd <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	50                   	push   %eax
  801e49:	6a 05                	push   $0x5
  801e4b:	e8 7d ff ff ff       	call   801dcd <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 02                	push   $0x2
  801e64:	e8 64 ff ff ff       	call   801dcd <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 03                	push   $0x3
  801e7d:	e8 4b ff ff ff       	call   801dcd <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 04                	push   $0x4
  801e96:	e8 32 ff ff ff       	call   801dcd <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_env_exit>:


void sys_env_exit(void)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 06                	push   $0x6
  801eaf:	e8 19 ff ff ff       	call   801dcd <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	90                   	nop
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	6a 07                	push   $0x7
  801ecd:	e8 fb fe ff ff       	call   801dcd <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801edc:	8b 75 18             	mov    0x18(%ebp),%esi
  801edf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	51                   	push   %ecx
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	6a 08                	push   $0x8
  801ef2:	e8 d6 fe ff ff       	call   801dcd <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 09                	push   $0x9
  801f14:	e8 b4 fe ff ff       	call   801dcd <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	ff 75 0c             	pushl  0xc(%ebp)
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	6a 0a                	push   $0xa
  801f2f:	e8 99 fe ff ff       	call   801dcd <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 0b                	push   $0xb
  801f48:	e8 80 fe ff ff       	call   801dcd <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 0c                	push   $0xc
  801f61:	e8 67 fe ff ff       	call   801dcd <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 0d                	push   $0xd
  801f7a:	e8 4e fe ff ff       	call   801dcd <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	ff 75 0c             	pushl  0xc(%ebp)
  801f90:	ff 75 08             	pushl  0x8(%ebp)
  801f93:	6a 11                	push   $0x11
  801f95:	e8 33 fe ff ff       	call   801dcd <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
	return;
  801f9d:	90                   	nop
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	ff 75 08             	pushl  0x8(%ebp)
  801faf:	6a 12                	push   $0x12
  801fb1:	e8 17 fe ff ff       	call   801dcd <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb9:	90                   	nop
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 0e                	push   $0xe
  801fcb:	e8 fd fd ff ff       	call   801dcd <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	6a 0f                	push   $0xf
  801fe5:	e8 e3 fd ff ff       	call   801dcd <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 10                	push   $0x10
  801ffe:	e8 ca fd ff ff       	call   801dcd <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	90                   	nop
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 14                	push   $0x14
  802018:	e8 b0 fd ff ff       	call   801dcd <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
}
  802020:	90                   	nop
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 15                	push   $0x15
  802032:	e8 96 fd ff ff       	call   801dcd <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	90                   	nop
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_cputc>:


void
sys_cputc(const char c)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802049:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	50                   	push   %eax
  802056:	6a 16                	push   $0x16
  802058:	e8 70 fd ff ff       	call   801dcd <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	90                   	nop
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 17                	push   $0x17
  802072:	e8 56 fd ff ff       	call   801dcd <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	90                   	nop
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	ff 75 0c             	pushl  0xc(%ebp)
  80208c:	50                   	push   %eax
  80208d:	6a 18                	push   $0x18
  80208f:	e8 39 fd ff ff       	call   801dcd <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80209c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 1b                	push   $0x1b
  8020ac:	e8 1c fd ff ff       	call   801dcd <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	52                   	push   %edx
  8020c6:	50                   	push   %eax
  8020c7:	6a 19                	push   $0x19
  8020c9:	e8 ff fc ff ff       	call   801dcd <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	52                   	push   %edx
  8020e4:	50                   	push   %eax
  8020e5:	6a 1a                	push   $0x1a
  8020e7:	e8 e1 fc ff ff       	call   801dcd <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	90                   	nop
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020fe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802101:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	6a 00                	push   $0x0
  80210a:	51                   	push   %ecx
  80210b:	52                   	push   %edx
  80210c:	ff 75 0c             	pushl  0xc(%ebp)
  80210f:	50                   	push   %eax
  802110:	6a 1c                	push   $0x1c
  802112:	e8 b6 fc ff ff       	call   801dcd <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	6a 1d                	push   $0x1d
  80212f:	e8 99 fc ff ff       	call   801dcd <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80213c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	51                   	push   %ecx
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	6a 1e                	push   $0x1e
  80214e:	e8 7a fc ff ff       	call   801dcd <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80215b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	52                   	push   %edx
  802168:	50                   	push   %eax
  802169:	6a 1f                	push   $0x1f
  80216b:	e8 5d fc ff ff       	call   801dcd <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 20                	push   $0x20
  802184:	e8 44 fc ff ff       	call   801dcd <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	6a 00                	push   $0x0
  802196:	ff 75 14             	pushl  0x14(%ebp)
  802199:	ff 75 10             	pushl  0x10(%ebp)
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	50                   	push   %eax
  8021a0:	6a 21                	push   $0x21
  8021a2:	e8 26 fc ff ff       	call   801dcd <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	50                   	push   %eax
  8021bb:	6a 22                	push   $0x22
  8021bd:	e8 0b fc ff ff       	call   801dcd <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
}
  8021c5:	90                   	nop
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	50                   	push   %eax
  8021d7:	6a 23                	push   $0x23
  8021d9:	e8 ef fb ff ff       	call   801dcd <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	90                   	nop
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021ed:	8d 50 04             	lea    0x4(%eax),%edx
  8021f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	52                   	push   %edx
  8021fa:	50                   	push   %eax
  8021fb:	6a 24                	push   $0x24
  8021fd:	e8 cb fb ff ff       	call   801dcd <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
	return result;
  802205:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802208:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80220b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80220e:	89 01                	mov    %eax,(%ecx)
  802210:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	c9                   	leave  
  802217:	c2 04 00             	ret    $0x4

0080221a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	ff 75 10             	pushl  0x10(%ebp)
  802224:	ff 75 0c             	pushl  0xc(%ebp)
  802227:	ff 75 08             	pushl  0x8(%ebp)
  80222a:	6a 13                	push   $0x13
  80222c:	e8 9c fb ff ff       	call   801dcd <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
	return ;
  802234:	90                   	nop
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_rcr2>:
uint32 sys_rcr2()
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 25                	push   $0x25
  802246:	e8 82 fb ff ff       	call   801dcd <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80225c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	50                   	push   %eax
  802269:	6a 26                	push   $0x26
  80226b:	e8 5d fb ff ff       	call   801dcd <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
	return ;
  802273:	90                   	nop
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <rsttst>:
void rsttst()
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 28                	push   $0x28
  802285:	e8 43 fb ff ff       	call   801dcd <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
	return ;
  80228d:	90                   	nop
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	8b 45 14             	mov    0x14(%ebp),%eax
  802299:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80229c:	8b 55 18             	mov    0x18(%ebp),%edx
  80229f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a3:	52                   	push   %edx
  8022a4:	50                   	push   %eax
  8022a5:	ff 75 10             	pushl  0x10(%ebp)
  8022a8:	ff 75 0c             	pushl  0xc(%ebp)
  8022ab:	ff 75 08             	pushl  0x8(%ebp)
  8022ae:	6a 27                	push   $0x27
  8022b0:	e8 18 fb ff ff       	call   801dcd <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b8:	90                   	nop
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <chktst>:
void chktst(uint32 n)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	ff 75 08             	pushl  0x8(%ebp)
  8022c9:	6a 29                	push   $0x29
  8022cb:	e8 fd fa ff ff       	call   801dcd <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d3:	90                   	nop
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <inctst>:

void inctst()
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 2a                	push   $0x2a
  8022e5:	e8 e3 fa ff ff       	call   801dcd <syscall>
  8022ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ed:	90                   	nop
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <gettst>:
uint32 gettst()
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 2b                	push   $0x2b
  8022ff:	e8 c9 fa ff ff       	call   801dcd <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 2c                	push   $0x2c
  80231b:	e8 ad fa ff ff       	call   801dcd <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
  802323:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802326:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80232a:	75 07                	jne    802333 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80232c:	b8 01 00 00 00       	mov    $0x1,%eax
  802331:	eb 05                	jmp    802338 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802333:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 2c                	push   $0x2c
  80234c:	e8 7c fa ff ff       	call   801dcd <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
  802354:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802357:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80235b:	75 07                	jne    802364 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80235d:	b8 01 00 00 00       	mov    $0x1,%eax
  802362:	eb 05                	jmp    802369 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 2c                	push   $0x2c
  80237d:	e8 4b fa ff ff       	call   801dcd <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
  802385:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802388:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80238c:	75 07                	jne    802395 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	eb 05                	jmp    80239a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 2c                	push   $0x2c
  8023ae:	e8 1a fa ff ff       	call   801dcd <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
  8023b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023bd:	75 07                	jne    8023c6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c4:	eb 05                	jmp    8023cb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	ff 75 08             	pushl  0x8(%ebp)
  8023db:	6a 2d                	push   $0x2d
  8023dd:	e8 eb f9 ff ff       	call   801dcd <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e5:	90                   	nop
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	6a 00                	push   $0x0
  8023fa:	53                   	push   %ebx
  8023fb:	51                   	push   %ecx
  8023fc:	52                   	push   %edx
  8023fd:	50                   	push   %eax
  8023fe:	6a 2e                	push   $0x2e
  802400:	e8 c8 f9 ff ff       	call   801dcd <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802410:	8b 55 0c             	mov    0xc(%ebp),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	52                   	push   %edx
  80241d:	50                   	push   %eax
  80241e:	6a 2f                	push   $0x2f
  802420:	e8 a8 f9 ff ff       	call   801dcd <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    
  80242a:	66 90                	xchg   %ax,%ax

0080242c <__udivdi3>:
  80242c:	55                   	push   %ebp
  80242d:	57                   	push   %edi
  80242e:	56                   	push   %esi
  80242f:	53                   	push   %ebx
  802430:	83 ec 1c             	sub    $0x1c,%esp
  802433:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802437:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80243b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80243f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802443:	89 ca                	mov    %ecx,%edx
  802445:	89 f8                	mov    %edi,%eax
  802447:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80244b:	85 f6                	test   %esi,%esi
  80244d:	75 2d                	jne    80247c <__udivdi3+0x50>
  80244f:	39 cf                	cmp    %ecx,%edi
  802451:	77 65                	ja     8024b8 <__udivdi3+0x8c>
  802453:	89 fd                	mov    %edi,%ebp
  802455:	85 ff                	test   %edi,%edi
  802457:	75 0b                	jne    802464 <__udivdi3+0x38>
  802459:	b8 01 00 00 00       	mov    $0x1,%eax
  80245e:	31 d2                	xor    %edx,%edx
  802460:	f7 f7                	div    %edi
  802462:	89 c5                	mov    %eax,%ebp
  802464:	31 d2                	xor    %edx,%edx
  802466:	89 c8                	mov    %ecx,%eax
  802468:	f7 f5                	div    %ebp
  80246a:	89 c1                	mov    %eax,%ecx
  80246c:	89 d8                	mov    %ebx,%eax
  80246e:	f7 f5                	div    %ebp
  802470:	89 cf                	mov    %ecx,%edi
  802472:	89 fa                	mov    %edi,%edx
  802474:	83 c4 1c             	add    $0x1c,%esp
  802477:	5b                   	pop    %ebx
  802478:	5e                   	pop    %esi
  802479:	5f                   	pop    %edi
  80247a:	5d                   	pop    %ebp
  80247b:	c3                   	ret    
  80247c:	39 ce                	cmp    %ecx,%esi
  80247e:	77 28                	ja     8024a8 <__udivdi3+0x7c>
  802480:	0f bd fe             	bsr    %esi,%edi
  802483:	83 f7 1f             	xor    $0x1f,%edi
  802486:	75 40                	jne    8024c8 <__udivdi3+0x9c>
  802488:	39 ce                	cmp    %ecx,%esi
  80248a:	72 0a                	jb     802496 <__udivdi3+0x6a>
  80248c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802490:	0f 87 9e 00 00 00    	ja     802534 <__udivdi3+0x108>
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	83 c4 1c             	add    $0x1c,%esp
  8024a0:	5b                   	pop    %ebx
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	31 ff                	xor    %edi,%edi
  8024aa:	31 c0                	xor    %eax,%eax
  8024ac:	89 fa                	mov    %edi,%edx
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	89 d8                	mov    %ebx,%eax
  8024ba:	f7 f7                	div    %edi
  8024bc:	31 ff                	xor    %edi,%edi
  8024be:	89 fa                	mov    %edi,%edx
  8024c0:	83 c4 1c             	add    $0x1c,%esp
  8024c3:	5b                   	pop    %ebx
  8024c4:	5e                   	pop    %esi
  8024c5:	5f                   	pop    %edi
  8024c6:	5d                   	pop    %ebp
  8024c7:	c3                   	ret    
  8024c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8024cd:	89 eb                	mov    %ebp,%ebx
  8024cf:	29 fb                	sub    %edi,%ebx
  8024d1:	89 f9                	mov    %edi,%ecx
  8024d3:	d3 e6                	shl    %cl,%esi
  8024d5:	89 c5                	mov    %eax,%ebp
  8024d7:	88 d9                	mov    %bl,%cl
  8024d9:	d3 ed                	shr    %cl,%ebp
  8024db:	89 e9                	mov    %ebp,%ecx
  8024dd:	09 f1                	or     %esi,%ecx
  8024df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8024e3:	89 f9                	mov    %edi,%ecx
  8024e5:	d3 e0                	shl    %cl,%eax
  8024e7:	89 c5                	mov    %eax,%ebp
  8024e9:	89 d6                	mov    %edx,%esi
  8024eb:	88 d9                	mov    %bl,%cl
  8024ed:	d3 ee                	shr    %cl,%esi
  8024ef:	89 f9                	mov    %edi,%ecx
  8024f1:	d3 e2                	shl    %cl,%edx
  8024f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024f7:	88 d9                	mov    %bl,%cl
  8024f9:	d3 e8                	shr    %cl,%eax
  8024fb:	09 c2                	or     %eax,%edx
  8024fd:	89 d0                	mov    %edx,%eax
  8024ff:	89 f2                	mov    %esi,%edx
  802501:	f7 74 24 0c          	divl   0xc(%esp)
  802505:	89 d6                	mov    %edx,%esi
  802507:	89 c3                	mov    %eax,%ebx
  802509:	f7 e5                	mul    %ebp
  80250b:	39 d6                	cmp    %edx,%esi
  80250d:	72 19                	jb     802528 <__udivdi3+0xfc>
  80250f:	74 0b                	je     80251c <__udivdi3+0xf0>
  802511:	89 d8                	mov    %ebx,%eax
  802513:	31 ff                	xor    %edi,%edi
  802515:	e9 58 ff ff ff       	jmp    802472 <__udivdi3+0x46>
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802520:	89 f9                	mov    %edi,%ecx
  802522:	d3 e2                	shl    %cl,%edx
  802524:	39 c2                	cmp    %eax,%edx
  802526:	73 e9                	jae    802511 <__udivdi3+0xe5>
  802528:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80252b:	31 ff                	xor    %edi,%edi
  80252d:	e9 40 ff ff ff       	jmp    802472 <__udivdi3+0x46>
  802532:	66 90                	xchg   %ax,%ax
  802534:	31 c0                	xor    %eax,%eax
  802536:	e9 37 ff ff ff       	jmp    802472 <__udivdi3+0x46>
  80253b:	90                   	nop

0080253c <__umoddi3>:
  80253c:	55                   	push   %ebp
  80253d:	57                   	push   %edi
  80253e:	56                   	push   %esi
  80253f:	53                   	push   %ebx
  802540:	83 ec 1c             	sub    $0x1c,%esp
  802543:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802547:	8b 74 24 34          	mov    0x34(%esp),%esi
  80254b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80254f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802553:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802557:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80255b:	89 f3                	mov    %esi,%ebx
  80255d:	89 fa                	mov    %edi,%edx
  80255f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802563:	89 34 24             	mov    %esi,(%esp)
  802566:	85 c0                	test   %eax,%eax
  802568:	75 1a                	jne    802584 <__umoddi3+0x48>
  80256a:	39 f7                	cmp    %esi,%edi
  80256c:	0f 86 a2 00 00 00    	jbe    802614 <__umoddi3+0xd8>
  802572:	89 c8                	mov    %ecx,%eax
  802574:	89 f2                	mov    %esi,%edx
  802576:	f7 f7                	div    %edi
  802578:	89 d0                	mov    %edx,%eax
  80257a:	31 d2                	xor    %edx,%edx
  80257c:	83 c4 1c             	add    $0x1c,%esp
  80257f:	5b                   	pop    %ebx
  802580:	5e                   	pop    %esi
  802581:	5f                   	pop    %edi
  802582:	5d                   	pop    %ebp
  802583:	c3                   	ret    
  802584:	39 f0                	cmp    %esi,%eax
  802586:	0f 87 ac 00 00 00    	ja     802638 <__umoddi3+0xfc>
  80258c:	0f bd e8             	bsr    %eax,%ebp
  80258f:	83 f5 1f             	xor    $0x1f,%ebp
  802592:	0f 84 ac 00 00 00    	je     802644 <__umoddi3+0x108>
  802598:	bf 20 00 00 00       	mov    $0x20,%edi
  80259d:	29 ef                	sub    %ebp,%edi
  80259f:	89 fe                	mov    %edi,%esi
  8025a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025a5:	89 e9                	mov    %ebp,%ecx
  8025a7:	d3 e0                	shl    %cl,%eax
  8025a9:	89 d7                	mov    %edx,%edi
  8025ab:	89 f1                	mov    %esi,%ecx
  8025ad:	d3 ef                	shr    %cl,%edi
  8025af:	09 c7                	or     %eax,%edi
  8025b1:	89 e9                	mov    %ebp,%ecx
  8025b3:	d3 e2                	shl    %cl,%edx
  8025b5:	89 14 24             	mov    %edx,(%esp)
  8025b8:	89 d8                	mov    %ebx,%eax
  8025ba:	d3 e0                	shl    %cl,%eax
  8025bc:	89 c2                	mov    %eax,%edx
  8025be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c2:	d3 e0                	shl    %cl,%eax
  8025c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025cc:	89 f1                	mov    %esi,%ecx
  8025ce:	d3 e8                	shr    %cl,%eax
  8025d0:	09 d0                	or     %edx,%eax
  8025d2:	d3 eb                	shr    %cl,%ebx
  8025d4:	89 da                	mov    %ebx,%edx
  8025d6:	f7 f7                	div    %edi
  8025d8:	89 d3                	mov    %edx,%ebx
  8025da:	f7 24 24             	mull   (%esp)
  8025dd:	89 c6                	mov    %eax,%esi
  8025df:	89 d1                	mov    %edx,%ecx
  8025e1:	39 d3                	cmp    %edx,%ebx
  8025e3:	0f 82 87 00 00 00    	jb     802670 <__umoddi3+0x134>
  8025e9:	0f 84 91 00 00 00    	je     802680 <__umoddi3+0x144>
  8025ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025f3:	29 f2                	sub    %esi,%edx
  8025f5:	19 cb                	sbb    %ecx,%ebx
  8025f7:	89 d8                	mov    %ebx,%eax
  8025f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8025fd:	d3 e0                	shl    %cl,%eax
  8025ff:	89 e9                	mov    %ebp,%ecx
  802601:	d3 ea                	shr    %cl,%edx
  802603:	09 d0                	or     %edx,%eax
  802605:	89 e9                	mov    %ebp,%ecx
  802607:	d3 eb                	shr    %cl,%ebx
  802609:	89 da                	mov    %ebx,%edx
  80260b:	83 c4 1c             	add    $0x1c,%esp
  80260e:	5b                   	pop    %ebx
  80260f:	5e                   	pop    %esi
  802610:	5f                   	pop    %edi
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    
  802613:	90                   	nop
  802614:	89 fd                	mov    %edi,%ebp
  802616:	85 ff                	test   %edi,%edi
  802618:	75 0b                	jne    802625 <__umoddi3+0xe9>
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	31 d2                	xor    %edx,%edx
  802621:	f7 f7                	div    %edi
  802623:	89 c5                	mov    %eax,%ebp
  802625:	89 f0                	mov    %esi,%eax
  802627:	31 d2                	xor    %edx,%edx
  802629:	f7 f5                	div    %ebp
  80262b:	89 c8                	mov    %ecx,%eax
  80262d:	f7 f5                	div    %ebp
  80262f:	89 d0                	mov    %edx,%eax
  802631:	e9 44 ff ff ff       	jmp    80257a <__umoddi3+0x3e>
  802636:	66 90                	xchg   %ax,%ax
  802638:	89 c8                	mov    %ecx,%eax
  80263a:	89 f2                	mov    %esi,%edx
  80263c:	83 c4 1c             	add    $0x1c,%esp
  80263f:	5b                   	pop    %ebx
  802640:	5e                   	pop    %esi
  802641:	5f                   	pop    %edi
  802642:	5d                   	pop    %ebp
  802643:	c3                   	ret    
  802644:	3b 04 24             	cmp    (%esp),%eax
  802647:	72 06                	jb     80264f <__umoddi3+0x113>
  802649:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80264d:	77 0f                	ja     80265e <__umoddi3+0x122>
  80264f:	89 f2                	mov    %esi,%edx
  802651:	29 f9                	sub    %edi,%ecx
  802653:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802657:	89 14 24             	mov    %edx,(%esp)
  80265a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80265e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802662:	8b 14 24             	mov    (%esp),%edx
  802665:	83 c4 1c             	add    $0x1c,%esp
  802668:	5b                   	pop    %ebx
  802669:	5e                   	pop    %esi
  80266a:	5f                   	pop    %edi
  80266b:	5d                   	pop    %ebp
  80266c:	c3                   	ret    
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	2b 04 24             	sub    (%esp),%eax
  802673:	19 fa                	sbb    %edi,%edx
  802675:	89 d1                	mov    %edx,%ecx
  802677:	89 c6                	mov    %eax,%esi
  802679:	e9 71 ff ff ff       	jmp    8025ef <__umoddi3+0xb3>
  80267e:	66 90                	xchg   %ax,%ax
  802680:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802684:	72 ea                	jb     802670 <__umoddi3+0x134>
  802686:	89 d9                	mov    %ebx,%ecx
  802688:	e9 62 ff ff ff       	jmp    8025ef <__umoddi3+0xb3>
