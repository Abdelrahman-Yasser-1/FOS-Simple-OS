
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 d9 0d 00 00       	call   800e0f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 23                	jmp    800073 <_main+0x3b>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 40 80 00       	mov    0x804020,%eax
  800055:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	c1 e2 04             	shl    $0x4,%edx
  800061:	01 d0                	add    %edx,%eax
  800063:	8a 40 04             	mov    0x4(%eax),%al
  800066:	84 c0                	test   %al,%al
  800068:	74 06                	je     800070 <_main+0x38>
			{
				fullWS = 0;
  80006a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006e:	eb 12                	jmp    800082 <_main+0x4a>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800070:	ff 45 f0             	incl   -0x10(%ebp)
  800073:	a1 20 40 80 00       	mov    0x804020,%eax
  800078:	8b 50 74             	mov    0x74(%eax),%edx
  80007b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007e:	39 c2                	cmp    %eax,%edx
  800080:	77 ce                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800082:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800086:	74 14                	je     80009c <_main+0x64>
  800088:	83 ec 04             	sub    $0x4,%esp
  80008b:	68 c0 2d 80 00       	push   $0x802dc0
  800090:	6a 1a                	push   $0x1a
  800092:	68 dc 2d 80 00       	push   $0x802ddc
  800097:	e8 b8 0e 00 00       	call   800f54 <_panic>





	int Mega = 1024*1024;
  80009c:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000a3:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000aa:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000ae:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000b2:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000b8:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000be:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000c5:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 84 25 00 00       	call   802655 <sys_calculate_free_frames>
  8000d1:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000d4:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000da:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000df:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e4:	89 d7                	mov    %edx,%edi
  8000e6:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000e8:	e8 eb 25 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	50                   	push   %eax
  8000fc:	e8 7f 1e 00 00       	call   801f80 <malloc>
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80010a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800110:	85 c0                	test   %eax,%eax
  800112:	79 0d                	jns    800121 <_main+0xe9>
  800114:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80011a:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  80011f:	76 14                	jbe    800135 <_main+0xfd>
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	68 f0 2d 80 00       	push   $0x802df0
  800129:	6a 36                	push   $0x36
  80012b:	68 dc 2d 80 00       	push   $0x802ddc
  800130:	e8 1f 0e 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800135:	e8 9e 25 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  80013a:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80013d:	3d 00 02 00 00       	cmp    $0x200,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 58 2e 80 00       	push   $0x802e58
  80014c:	6a 37                	push   $0x37
  80014e:	68 dc 2d 80 00       	push   $0x802ddc
  800153:	e8 fc 0d 00 00       	call   800f54 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800158:	e8 f8 24 00 00       	call   802655 <sys_calculate_free_frames>
  80015d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800163:	01 c0                	add    %eax,%eax
  800165:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800168:	48                   	dec    %eax
  800169:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80016c:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800172:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800175:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800178:	8a 55 df             	mov    -0x21(%ebp),%dl
  80017b:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80017d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800180:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800183:	01 c2                	add    %eax,%edx
  800185:	8a 45 de             	mov    -0x22(%ebp),%al
  800188:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80018a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80018d:	e8 c3 24 00 00       	call   802655 <sys_calculate_free_frames>
  800192:	29 c3                	sub    %eax,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	83 f8 03             	cmp    $0x3,%eax
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 88 2e 80 00       	push   $0x802e88
  8001a3:	6a 3e                	push   $0x3e
  8001a5:	68 dc 2d 80 00       	push   $0x802ddc
  8001aa:	e8 a5 0d 00 00       	call   800f54 <_panic>
		int var;
		int found = 0;
  8001af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001bd:	eb 76                	jmp    800235 <_main+0x1fd>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001cd:	c1 e2 04             	shl    $0x4,%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	89 c2                	mov    %eax,%edx
  8001e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001e4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001e7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ef:	39 c2                	cmp    %eax,%edx
  8001f1:	75 03                	jne    8001f6 <_main+0x1be>
				found++;
  8001f3:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  8001f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fb:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800201:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800204:	c1 e2 04             	shl    $0x4,%edx
  800207:	01 d0                	add    %edx,%eax
  800209:	8b 00                	mov    (%eax),%eax
  80020b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80020e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800211:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800216:	89 c1                	mov    %eax,%ecx
  800218:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80021b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80021e:	01 d0                	add    %edx,%eax
  800220:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800223:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80022b:	39 c1                	cmp    %eax,%ecx
  80022d:	75 03                	jne    800232 <_main+0x1fa>
				found++;
  80022f:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800232:	ff 45 ec             	incl   -0x14(%ebp)
  800235:	a1 20 40 80 00       	mov    0x804020,%eax
  80023a:	8b 50 74             	mov    0x74(%eax),%edx
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	39 c2                	cmp    %eax,%edx
  800242:	0f 87 77 ff ff ff    	ja     8001bf <_main+0x187>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800248:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 cc 2e 80 00       	push   $0x802ecc
  800256:	6a 48                	push   $0x48
  800258:	68 dc 2d 80 00       	push   $0x802ddc
  80025d:	e8 f2 0c 00 00       	call   800f54 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800262:	e8 71 24 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  800267:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80026a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026d:	01 c0                	add    %eax,%eax
  80026f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	50                   	push   %eax
  800276:	e8 05 1d 00 00       	call   801f80 <malloc>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800284:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80028a:	89 c2                	mov    %eax,%edx
  80028c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	05 00 00 00 80       	add    $0x80000000,%eax
  800296:	39 c2                	cmp    %eax,%edx
  800298:	72 16                	jb     8002b0 <_main+0x278>
  80029a:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a0:	89 c2                	mov    %eax,%edx
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	01 c0                	add    %eax,%eax
  8002a7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002ac:	39 c2                	cmp    %eax,%edx
  8002ae:	76 14                	jbe    8002c4 <_main+0x28c>
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	68 f0 2d 80 00       	push   $0x802df0
  8002b8:	6a 4d                	push   $0x4d
  8002ba:	68 dc 2d 80 00       	push   $0x802ddc
  8002bf:	e8 90 0c 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8002c4:	e8 0f 24 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  8002c9:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8002cc:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 58 2e 80 00       	push   $0x802e58
  8002db:	6a 4e                	push   $0x4e
  8002dd:	68 dc 2d 80 00       	push   $0x802ddc
  8002e2:	e8 6d 0c 00 00       	call   800f54 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002e7:	e8 69 23 00 00       	call   802655 <sys_calculate_free_frames>
  8002ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  8002ef:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002f5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  8002f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fb:	01 c0                	add    %eax,%eax
  8002fd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800300:	d1 e8                	shr    %eax
  800302:	48                   	dec    %eax
  800303:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  800306:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800309:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80030c:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80030f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800312:	01 c0                	add    %eax,%eax
  800314:	89 c2                	mov    %eax,%edx
  800316:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800319:	01 c2                	add    %eax,%edx
  80031b:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  80031f:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800322:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800325:	e8 2b 23 00 00       	call   802655 <sys_calculate_free_frames>
  80032a:	29 c3                	sub    %eax,%ebx
  80032c:	89 d8                	mov    %ebx,%eax
  80032e:	83 f8 02             	cmp    $0x2,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 88 2e 80 00       	push   $0x802e88
  80033b:	6a 55                	push   $0x55
  80033d:	68 dc 2d 80 00       	push   $0x802ddc
  800342:	e8 0d 0c 00 00       	call   800f54 <_panic>
		found = 0;
  800347:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80034e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800355:	eb 7a                	jmp    8003d1 <_main+0x399>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800357:	a1 20 40 80 00       	mov    0x804020,%eax
  80035c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800362:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800365:	c1 e2 04             	shl    $0x4,%edx
  800368:	01 d0                	add    %edx,%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80036f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800372:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800377:	89 c2                	mov    %eax,%edx
  800379:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80037c:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80037f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800387:	39 c2                	cmp    %eax,%edx
  800389:	75 03                	jne    80038e <_main+0x356>
				found++;
  80038b:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80038e:	a1 20 40 80 00       	mov    0x804020,%eax
  800393:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800399:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80039c:	c1 e2 04             	shl    $0x4,%edx
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003a6:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b3:	01 c0                	add    %eax,%eax
  8003b5:	89 c1                	mov    %eax,%ecx
  8003b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003ba:	01 c8                	add    %ecx,%eax
  8003bc:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003bf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c7:	39 c2                	cmp    %eax,%edx
  8003c9:	75 03                	jne    8003ce <_main+0x396>
				found++;
  8003cb:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003ce:	ff 45 ec             	incl   -0x14(%ebp)
  8003d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d6:	8b 50 74             	mov    0x74(%eax),%edx
  8003d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003dc:	39 c2                	cmp    %eax,%edx
  8003de:	0f 87 73 ff ff ff    	ja     800357 <_main+0x31f>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8003e4:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8003e8:	74 14                	je     8003fe <_main+0x3c6>
  8003ea:	83 ec 04             	sub    $0x4,%esp
  8003ed:	68 cc 2e 80 00       	push   $0x802ecc
  8003f2:	6a 5e                	push   $0x5e
  8003f4:	68 dc 2d 80 00       	push   $0x802ddc
  8003f9:	e8 56 0b 00 00       	call   800f54 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fe:	e8 d5 22 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  800403:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800409:	89 c2                	mov    %eax,%edx
  80040b:	01 d2                	add    %edx,%edx
  80040d:	01 d0                	add    %edx,%eax
  80040f:	83 ec 0c             	sub    $0xc,%esp
  800412:	50                   	push   %eax
  800413:	e8 68 1b 00 00       	call   801f80 <malloc>
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800421:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80042c:	c1 e0 02             	shl    $0x2,%eax
  80042f:	05 00 00 00 80       	add    $0x80000000,%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	72 17                	jb     80044f <_main+0x417>
  800438:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80043e:	89 c2                	mov    %eax,%edx
  800440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800443:	c1 e0 02             	shl    $0x2,%eax
  800446:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80044b:	39 c2                	cmp    %eax,%edx
  80044d:	76 14                	jbe    800463 <_main+0x42b>
  80044f:	83 ec 04             	sub    $0x4,%esp
  800452:	68 f0 2d 80 00       	push   $0x802df0
  800457:	6a 63                	push   $0x63
  800459:	68 dc 2d 80 00       	push   $0x802ddc
  80045e:	e8 f1 0a 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800463:	e8 70 22 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  800468:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80046b:	83 f8 01             	cmp    $0x1,%eax
  80046e:	74 14                	je     800484 <_main+0x44c>
  800470:	83 ec 04             	sub    $0x4,%esp
  800473:	68 58 2e 80 00       	push   $0x802e58
  800478:	6a 64                	push   $0x64
  80047a:	68 dc 2d 80 00       	push   $0x802ddc
  80047f:	e8 d0 0a 00 00       	call   800f54 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800484:	e8 cc 21 00 00       	call   802655 <sys_calculate_free_frames>
  800489:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  80048c:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800492:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800495:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	c1 e8 02             	shr    $0x2,%eax
  80049d:	48                   	dec    %eax
  80049e:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004a1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004a7:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004a9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b3:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004b6:	01 c2                	add    %eax,%edx
  8004b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004bb:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004bd:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004c0:	e8 90 21 00 00       	call   802655 <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	83 f8 02             	cmp    $0x2,%eax
  8004cc:	74 14                	je     8004e2 <_main+0x4aa>
  8004ce:	83 ec 04             	sub    $0x4,%esp
  8004d1:	68 88 2e 80 00       	push   $0x802e88
  8004d6:	6a 6b                	push   $0x6b
  8004d8:	68 dc 2d 80 00       	push   $0x802ddc
  8004dd:	e8 72 0a 00 00       	call   800f54 <_panic>
		found = 0;
  8004e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8004e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8004f0:	e9 83 00 00 00       	jmp    800578 <_main+0x540>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  8004f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fa:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800500:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800503:	c1 e2 04             	shl    $0x4,%edx
  800506:	01 d0                	add    %edx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 88             	mov    %eax,-0x78(%ebp)
  80050d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
  800517:	8b 45 90             	mov    -0x70(%ebp),%eax
  80051a:	89 45 84             	mov    %eax,-0x7c(%ebp)
  80051d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800520:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800525:	39 c2                	cmp    %eax,%edx
  800527:	75 03                	jne    80052c <_main+0x4f4>
				found++;
  800529:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800537:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053a:	c1 e2 04             	shl    $0x4,%edx
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 80             	mov    %eax,-0x80(%ebp)
  800544:	8b 45 80             	mov    -0x80(%ebp),%eax
  800547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054c:	89 c2                	mov    %eax,%edx
  80054e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800551:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800558:	8b 45 90             	mov    -0x70(%ebp),%eax
  80055b:	01 c8                	add    %ecx,%eax
  80055d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800563:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800569:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80056e:	39 c2                	cmp    %eax,%edx
  800570:	75 03                	jne    800575 <_main+0x53d>
				found++;
  800572:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800575:	ff 45 ec             	incl   -0x14(%ebp)
  800578:	a1 20 40 80 00       	mov    0x804020,%eax
  80057d:	8b 50 74             	mov    0x74(%eax),%edx
  800580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800583:	39 c2                	cmp    %eax,%edx
  800585:	0f 87 6a ff ff ff    	ja     8004f5 <_main+0x4bd>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80058b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80058f:	74 14                	je     8005a5 <_main+0x56d>
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	68 cc 2e 80 00       	push   $0x802ecc
  800599:	6a 74                	push   $0x74
  80059b:	68 dc 2d 80 00       	push   $0x802ddc
  8005a0:	e8 af 09 00 00       	call   800f54 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005a5:	e8 ab 20 00 00       	call   802655 <sys_calculate_free_frames>
  8005aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005ad:	e8 26 21 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  8005b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	89 c2                	mov    %eax,%edx
  8005ba:	01 d2                	add    %edx,%edx
  8005bc:	01 d0                	add    %edx,%eax
  8005be:	83 ec 0c             	sub    $0xc,%esp
  8005c1:	50                   	push   %eax
  8005c2:	e8 b9 19 00 00       	call   801f80 <malloc>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005d0:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  8005d6:	89 c2                	mov    %eax,%edx
  8005d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005db:	c1 e0 02             	shl    $0x2,%eax
  8005de:	89 c1                	mov    %eax,%ecx
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	c1 e0 02             	shl    $0x2,%eax
  8005e6:	01 c8                	add    %ecx,%eax
  8005e8:	05 00 00 00 80       	add    $0x80000000,%eax
  8005ed:	39 c2                	cmp    %eax,%edx
  8005ef:	72 21                	jb     800612 <_main+0x5da>
  8005f1:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  8005f7:	89 c2                	mov    %eax,%edx
  8005f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005fc:	c1 e0 02             	shl    $0x2,%eax
  8005ff:	89 c1                	mov    %eax,%ecx
  800601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800604:	c1 e0 02             	shl    $0x2,%eax
  800607:	01 c8                	add    %ecx,%eax
  800609:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80060e:	39 c2                	cmp    %eax,%edx
  800610:	76 14                	jbe    800626 <_main+0x5ee>
  800612:	83 ec 04             	sub    $0x4,%esp
  800615:	68 f0 2d 80 00       	push   $0x802df0
  80061a:	6a 7a                	push   $0x7a
  80061c:	68 dc 2d 80 00       	push   $0x802ddc
  800621:	e8 2e 09 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800626:	e8 ad 20 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  80062b:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80062e:	83 f8 01             	cmp    $0x1,%eax
  800631:	74 14                	je     800647 <_main+0x60f>
  800633:	83 ec 04             	sub    $0x4,%esp
  800636:	68 58 2e 80 00       	push   $0x802e58
  80063b:	6a 7b                	push   $0x7b
  80063d:	68 dc 2d 80 00       	push   $0x802ddc
  800642:	e8 0d 09 00 00       	call   800f54 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800647:	e8 8c 20 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  80064c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80064f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800652:	89 d0                	mov    %edx,%eax
  800654:	01 c0                	add    %eax,%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	01 c0                	add    %eax,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 1b 19 00 00       	call   801f80 <malloc>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80066e:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800679:	c1 e0 02             	shl    $0x2,%eax
  80067c:	89 c1                	mov    %eax,%ecx
  80067e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800681:	c1 e0 03             	shl    $0x3,%eax
  800684:	01 c8                	add    %ecx,%eax
  800686:	05 00 00 00 80       	add    $0x80000000,%eax
  80068b:	39 c2                	cmp    %eax,%edx
  80068d:	72 21                	jb     8006b0 <_main+0x678>
  80068f:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800695:	89 c2                	mov    %eax,%edx
  800697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069a:	c1 e0 02             	shl    $0x2,%eax
  80069d:	89 c1                	mov    %eax,%ecx
  80069f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a2:	c1 e0 03             	shl    $0x3,%eax
  8006a5:	01 c8                	add    %ecx,%eax
  8006a7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006ac:	39 c2                	cmp    %eax,%edx
  8006ae:	76 17                	jbe    8006c7 <_main+0x68f>
  8006b0:	83 ec 04             	sub    $0x4,%esp
  8006b3:	68 f0 2d 80 00       	push   $0x802df0
  8006b8:	68 81 00 00 00       	push   $0x81
  8006bd:	68 dc 2d 80 00       	push   $0x802ddc
  8006c2:	e8 8d 08 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  8006c7:	e8 0c 20 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  8006cc:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8006cf:	83 f8 02             	cmp    $0x2,%eax
  8006d2:	74 17                	je     8006eb <_main+0x6b3>
  8006d4:	83 ec 04             	sub    $0x4,%esp
  8006d7:	68 58 2e 80 00       	push   $0x802e58
  8006dc:	68 82 00 00 00       	push   $0x82
  8006e1:	68 dc 2d 80 00       	push   $0x802ddc
  8006e6:	e8 69 08 00 00       	call   800f54 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8006eb:	e8 65 1f 00 00       	call   802655 <sys_calculate_free_frames>
  8006f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  8006f3:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006f9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8006ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800702:	89 d0                	mov    %edx,%eax
  800704:	01 c0                	add    %eax,%eax
  800706:	01 d0                	add    %edx,%eax
  800708:	01 c0                	add    %eax,%eax
  80070a:	01 d0                	add    %edx,%eax
  80070c:	c1 e8 03             	shr    $0x3,%eax
  80070f:	48                   	dec    %eax
  800710:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800716:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80071c:	8a 55 df             	mov    -0x21(%ebp),%dl
  80071f:	88 10                	mov    %dl,(%eax)
  800721:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800727:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80072a:	66 89 42 02          	mov    %ax,0x2(%edx)
  80072e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800737:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80073a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800740:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800747:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80074d:	01 c2                	add    %eax,%edx
  80074f:	8a 45 de             	mov    -0x22(%ebp),%al
  800752:	88 02                	mov    %al,(%edx)
  800754:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80075a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800761:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800767:	01 c2                	add    %eax,%edx
  800769:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  80076d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800771:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800777:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80077e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800784:	01 c2                	add    %eax,%edx
  800786:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800789:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80078c:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80078f:	e8 c1 1e 00 00       	call   802655 <sys_calculate_free_frames>
  800794:	29 c3                	sub    %eax,%ebx
  800796:	89 d8                	mov    %ebx,%eax
  800798:	83 f8 02             	cmp    $0x2,%eax
  80079b:	74 17                	je     8007b4 <_main+0x77c>
  80079d:	83 ec 04             	sub    $0x4,%esp
  8007a0:	68 88 2e 80 00       	push   $0x802e88
  8007a5:	68 89 00 00 00       	push   $0x89
  8007aa:	68 dc 2d 80 00       	push   $0x802ddc
  8007af:	e8 a0 07 00 00       	call   800f54 <_panic>
		found = 0;
  8007b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007c2:	e9 9e 00 00 00       	jmp    800865 <_main+0x82d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8007cc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007d5:	c1 e2 04             	shl    $0x4,%edx
  8007d8:	01 d0                	add    %edx,%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  8007e2:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8007e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007ed:	89 c2                	mov    %eax,%edx
  8007ef:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007f5:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8007fb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800801:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800806:	39 c2                	cmp    %eax,%edx
  800808:	75 03                	jne    80080d <_main+0x7d5>
				found++;
  80080a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80080d:	a1 20 40 80 00       	mov    0x804020,%eax
  800812:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800818:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80081b:	c1 e2 04             	shl    $0x4,%edx
  80081e:	01 d0                	add    %edx,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800828:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80082e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800833:	89 c2                	mov    %eax,%edx
  800835:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80083b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800842:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800848:	01 c8                	add    %ecx,%eax
  80084a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800850:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800856:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80085b:	39 c2                	cmp    %eax,%edx
  80085d:	75 03                	jne    800862 <_main+0x82a>
				found++;
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800862:	ff 45 ec             	incl   -0x14(%ebp)
  800865:	a1 20 40 80 00       	mov    0x804020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	0f 87 4f ff ff ff    	ja     8007c7 <_main+0x78f>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800878:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80087c:	74 17                	je     800895 <_main+0x85d>
  80087e:	83 ec 04             	sub    $0x4,%esp
  800881:	68 cc 2e 80 00       	push   $0x802ecc
  800886:	68 92 00 00 00       	push   $0x92
  80088b:	68 dc 2d 80 00       	push   $0x802ddc
  800890:	e8 bf 06 00 00       	call   800f54 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800895:	e8 bb 1d 00 00       	call   802655 <sys_calculate_free_frames>
  80089a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80089d:	e8 36 1e 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  8008a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a8:	89 c2                	mov    %eax,%edx
  8008aa:	01 d2                	add    %edx,%edx
  8008ac:	01 d0                	add    %edx,%eax
  8008ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008b1:	83 ec 0c             	sub    $0xc,%esp
  8008b4:	50                   	push   %eax
  8008b5:	e8 c6 16 00 00       	call   801f80 <malloc>
  8008ba:	83 c4 10             	add    $0x10,%esp
  8008bd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008c3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008c9:	89 c2                	mov    %eax,%edx
  8008cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ce:	c1 e0 02             	shl    $0x2,%eax
  8008d1:	89 c1                	mov    %eax,%ecx
  8008d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d6:	c1 e0 04             	shl    $0x4,%eax
  8008d9:	01 c8                	add    %ecx,%eax
  8008db:	05 00 00 00 80       	add    $0x80000000,%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	72 21                	jb     800905 <_main+0x8cd>
  8008e4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ea:	89 c2                	mov    %eax,%edx
  8008ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ef:	c1 e0 02             	shl    $0x2,%eax
  8008f2:	89 c1                	mov    %eax,%ecx
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	c1 e0 04             	shl    $0x4,%eax
  8008fa:	01 c8                	add    %ecx,%eax
  8008fc:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800901:	39 c2                	cmp    %eax,%edx
  800903:	76 17                	jbe    80091c <_main+0x8e4>
  800905:	83 ec 04             	sub    $0x4,%esp
  800908:	68 f0 2d 80 00       	push   $0x802df0
  80090d:	68 98 00 00 00       	push   $0x98
  800912:	68 dc 2d 80 00       	push   $0x802ddc
  800917:	e8 38 06 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80091c:	e8 b7 1d 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  800921:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800924:	89 c2                	mov    %eax,%edx
  800926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800929:	89 c1                	mov    %eax,%ecx
  80092b:	01 c9                	add    %ecx,%ecx
  80092d:	01 c8                	add    %ecx,%eax
  80092f:	85 c0                	test   %eax,%eax
  800931:	79 05                	jns    800938 <_main+0x900>
  800933:	05 ff 0f 00 00       	add    $0xfff,%eax
  800938:	c1 f8 0c             	sar    $0xc,%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 58 2e 80 00       	push   $0x802e58
  800947:	68 99 00 00 00       	push   $0x99
  80094c:	68 dc 2d 80 00       	push   $0x802ddc
  800951:	e8 fe 05 00 00       	call   800f54 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800956:	e8 7d 1d 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  80095b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80095e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800961:	89 d0                	mov    %edx,%eax
  800963:	01 c0                	add    %eax,%eax
  800965:	01 d0                	add    %edx,%eax
  800967:	01 c0                	add    %eax,%eax
  800969:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80096c:	83 ec 0c             	sub    $0xc,%esp
  80096f:	50                   	push   %eax
  800970:	e8 0b 16 00 00       	call   801f80 <malloc>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80097e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800984:	89 c1                	mov    %eax,%ecx
  800986:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800989:	89 d0                	mov    %edx,%eax
  80098b:	01 c0                	add    %eax,%eax
  80098d:	01 d0                	add    %edx,%eax
  80098f:	01 c0                	add    %eax,%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 c2                	mov    %eax,%edx
  800995:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800998:	c1 e0 04             	shl    $0x4,%eax
  80099b:	01 d0                	add    %edx,%eax
  80099d:	05 00 00 00 80       	add    $0x80000000,%eax
  8009a2:	39 c1                	cmp    %eax,%ecx
  8009a4:	72 28                	jb     8009ce <_main+0x996>
  8009a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009ac:	89 c1                	mov    %eax,%ecx
  8009ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009b1:	89 d0                	mov    %edx,%eax
  8009b3:	01 c0                	add    %eax,%eax
  8009b5:	01 d0                	add    %edx,%eax
  8009b7:	01 c0                	add    %eax,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	89 c2                	mov    %eax,%edx
  8009bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c0:	c1 e0 04             	shl    $0x4,%eax
  8009c3:	01 d0                	add    %edx,%eax
  8009c5:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009ca:	39 c1                	cmp    %eax,%ecx
  8009cc:	76 17                	jbe    8009e5 <_main+0x9ad>
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	68 f0 2d 80 00       	push   $0x802df0
  8009d6:	68 9f 00 00 00       	push   $0x9f
  8009db:	68 dc 2d 80 00       	push   $0x802ddc
  8009e0:	e8 6f 05 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8009e5:	e8 ee 1c 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  8009ea:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8009ed:	89 c1                	mov    %eax,%ecx
  8009ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	01 c0                	add    %eax,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	85 c0                	test   %eax,%eax
  8009fc:	79 05                	jns    800a03 <_main+0x9cb>
  8009fe:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a03:	c1 f8 0c             	sar    $0xc,%eax
  800a06:	39 c1                	cmp    %eax,%ecx
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 58 2e 80 00       	push   $0x802e58
  800a12:	68 a0 00 00 00       	push   $0xa0
  800a17:	68 dc 2d 80 00       	push   $0x802ddc
  800a1c:	e8 33 05 00 00       	call   800f54 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 2f 1c 00 00       	call   802655 <sys_calculate_free_frames>
  800a26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a37:	48                   	dec    %eax
  800a38:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a3e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a50:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a53:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a55:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	c1 ea 1f             	shr    $0x1f,%edx
  800a60:	01 d0                	add    %edx,%eax
  800a62:	d1 f8                	sar    %eax
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6c:	01 c2                	add    %eax,%edx
  800a6e:	8a 45 de             	mov    -0x22(%ebp),%al
  800a71:	88 c1                	mov    %al,%cl
  800a73:	c0 e9 07             	shr    $0x7,%cl
  800a76:	01 c8                	add    %ecx,%eax
  800a78:	d0 f8                	sar    %al
  800a7a:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7c:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a82:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a88:	01 c2                	add    %eax,%edx
  800a8a:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8d:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8f:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a92:	e8 be 1b 00 00       	call   802655 <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 88 2e 80 00       	push   $0x802e88
  800aa8:	68 a8 00 00 00       	push   $0xa8
  800aad:	68 dc 2d 80 00       	push   $0x802ddc
  800ab2:	e8 9d 04 00 00       	call   800f54 <_panic>
		found = 0;
  800ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac5:	e9 f0 00 00 00       	jmp    800bba <_main+0xb82>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aca:	a1 20 40 80 00       	mov    0x804020,%eax
  800acf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad8:	c1 e2 04             	shl    $0x4,%edx
  800adb:	01 d0                	add    %edx,%eax
  800add:	8b 00                	mov    (%eax),%eax
  800adf:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ae5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af0:	89 c2                	mov    %eax,%edx
  800af2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800af8:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800afe:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b09:	39 c2                	cmp    %eax,%edx
  800b0b:	75 03                	jne    800b10 <_main+0xad8>
				found++;
  800b0d:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b10:	a1 20 40 80 00       	mov    0x804020,%eax
  800b15:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1e:	c1 e2 04             	shl    $0x4,%edx
  800b21:	01 d0                	add    %edx,%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b2b:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b36:	89 c2                	mov    %eax,%edx
  800b38:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b3e:	89 c1                	mov    %eax,%ecx
  800b40:	c1 e9 1f             	shr    $0x1f,%ecx
  800b43:	01 c8                	add    %ecx,%eax
  800b45:	d1 f8                	sar    %eax
  800b47:	89 c1                	mov    %eax,%ecx
  800b49:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b4f:	01 c8                	add    %ecx,%eax
  800b51:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b57:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b62:	39 c2                	cmp    %eax,%edx
  800b64:	75 03                	jne    800b69 <_main+0xb31>
				found++;
  800b66:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b69:	a1 20 40 80 00       	mov    0x804020,%eax
  800b6e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b77:	c1 e2 04             	shl    $0x4,%edx
  800b7a:	01 d0                	add    %edx,%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b84:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b8f:	89 c1                	mov    %eax,%ecx
  800b91:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800b97:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b9d:	01 d0                	add    %edx,%eax
  800b9f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800ba5:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb0:	39 c1                	cmp    %eax,%ecx
  800bb2:	75 03                	jne    800bb7 <_main+0xb7f>
				found++;
  800bb4:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bb7:	ff 45 ec             	incl   -0x14(%ebp)
  800bba:	a1 20 40 80 00       	mov    0x804020,%eax
  800bbf:	8b 50 74             	mov    0x74(%eax),%edx
  800bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc5:	39 c2                	cmp    %eax,%edx
  800bc7:	0f 87 fd fe ff ff    	ja     800aca <_main+0xa92>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bcd:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 cc 2e 80 00       	push   $0x802ecc
  800bdb:	68 b3 00 00 00       	push   $0xb3
  800be0:	68 dc 2d 80 00       	push   $0x802ddc
  800be5:	e8 6a 03 00 00       	call   800f54 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bea:	e8 e9 1a 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  800bef:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bf5:	89 d0                	mov    %edx,%eax
  800bf7:	01 c0                	add    %eax,%eax
  800bf9:	01 d0                	add    %edx,%eax
  800bfb:	01 c0                	add    %eax,%eax
  800bfd:	01 d0                	add    %edx,%eax
  800bff:	01 c0                	add    %eax,%eax
  800c01:	83 ec 0c             	sub    $0xc,%esp
  800c04:	50                   	push   %eax
  800c05:	e8 76 13 00 00       	call   801f80 <malloc>
  800c0a:	83 c4 10             	add    $0x10,%esp
  800c0d:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c13:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c19:	89 c1                	mov    %eax,%ecx
  800c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c1e:	89 d0                	mov    %edx,%eax
  800c20:	01 c0                	add    %eax,%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	c1 e0 02             	shl    $0x2,%eax
  800c27:	01 d0                	add    %edx,%eax
  800c29:	89 c2                	mov    %eax,%edx
  800c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2e:	c1 e0 04             	shl    $0x4,%eax
  800c31:	01 d0                	add    %edx,%eax
  800c33:	05 00 00 00 80       	add    $0x80000000,%eax
  800c38:	39 c1                	cmp    %eax,%ecx
  800c3a:	72 29                	jb     800c65 <_main+0xc2d>
  800c3c:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c42:	89 c1                	mov    %eax,%ecx
  800c44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c47:	89 d0                	mov    %edx,%eax
  800c49:	01 c0                	add    %eax,%eax
  800c4b:	01 d0                	add    %edx,%eax
  800c4d:	c1 e0 02             	shl    $0x2,%eax
  800c50:	01 d0                	add    %edx,%eax
  800c52:	89 c2                	mov    %eax,%edx
  800c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c57:	c1 e0 04             	shl    $0x4,%eax
  800c5a:	01 d0                	add    %edx,%eax
  800c5c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c61:	39 c1                	cmp    %eax,%ecx
  800c63:	76 17                	jbe    800c7c <_main+0xc44>
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	68 f0 2d 80 00       	push   $0x802df0
  800c6d:	68 b8 00 00 00       	push   $0xb8
  800c72:	68 dc 2d 80 00       	push   $0x802ddc
  800c77:	e8 d8 02 00 00       	call   800f54 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800c7c:	e8 57 1a 00 00       	call   8026d8 <sys_pf_calculate_allocated_pages>
  800c81:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800c84:	83 f8 04             	cmp    $0x4,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 58 2e 80 00       	push   $0x802e58
  800c91:	68 b9 00 00 00       	push   $0xb9
  800c96:	68 dc 2d 80 00       	push   $0x802ddc
  800c9b:	e8 b4 02 00 00       	call   800f54 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800ca0:	e8 b0 19 00 00       	call   802655 <sys_calculate_free_frames>
  800ca5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800ca8:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cae:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb7:	89 d0                	mov    %edx,%eax
  800cb9:	01 c0                	add    %eax,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d0                	add    %edx,%eax
  800cc1:	01 c0                	add    %eax,%eax
  800cc3:	d1 e8                	shr    %eax
  800cc5:	48                   	dec    %eax
  800cc6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800ccc:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cd5:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800cd8:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	89 c2                	mov    %eax,%edx
  800ce2:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ce8:	01 c2                	add    %eax,%edx
  800cea:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cee:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800cf1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800cf4:	e8 5c 19 00 00       	call   802655 <sys_calculate_free_frames>
  800cf9:	29 c3                	sub    %eax,%ebx
  800cfb:	89 d8                	mov    %ebx,%eax
  800cfd:	83 f8 02             	cmp    $0x2,%eax
  800d00:	74 17                	je     800d19 <_main+0xce1>
  800d02:	83 ec 04             	sub    $0x4,%esp
  800d05:	68 88 2e 80 00       	push   $0x802e88
  800d0a:	68 c0 00 00 00       	push   $0xc0
  800d0f:	68 dc 2d 80 00       	push   $0x802ddc
  800d14:	e8 3b 02 00 00       	call   800f54 <_panic>
		found = 0;
  800d19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d27:	e9 9b 00 00 00       	jmp    800dc7 <_main+0xd8f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d2c:	a1 20 40 80 00       	mov    0x804020,%eax
  800d31:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d3a:	c1 e2 04             	shl    $0x4,%edx
  800d3d:	01 d0                	add    %edx,%eax
  800d3f:	8b 00                	mov    (%eax),%eax
  800d41:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d47:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d52:	89 c2                	mov    %eax,%edx
  800d54:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d5a:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d60:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d6b:	39 c2                	cmp    %eax,%edx
  800d6d:	75 03                	jne    800d72 <_main+0xd3a>
				found++;
  800d6f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d72:	a1 20 40 80 00       	mov    0x804020,%eax
  800d77:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d80:	c1 e2 04             	shl    $0x4,%edx
  800d83:	01 d0                	add    %edx,%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d8d:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d98:	89 c2                	mov    %eax,%edx
  800d9a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800da0:	01 c0                	add    %eax,%eax
  800da2:	89 c1                	mov    %eax,%ecx
  800da4:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800daa:	01 c8                	add    %ecx,%eax
  800dac:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800db2:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800db8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dbd:	39 c2                	cmp    %eax,%edx
  800dbf:	75 03                	jne    800dc4 <_main+0xd8c>
				found++;
  800dc1:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800dc4:	ff 45 ec             	incl   -0x14(%ebp)
  800dc7:	a1 20 40 80 00       	mov    0x804020,%eax
  800dcc:	8b 50 74             	mov    0x74(%eax),%edx
  800dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd2:	39 c2                	cmp    %eax,%edx
  800dd4:	0f 87 52 ff ff ff    	ja     800d2c <_main+0xcf4>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800dda:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dde:	74 17                	je     800df7 <_main+0xdbf>
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 cc 2e 80 00       	push   $0x802ecc
  800de8:	68 c9 00 00 00       	push   $0xc9
  800ded:	68 dc 2d 80 00       	push   $0x802ddc
  800df2:	e8 5d 01 00 00       	call   800f54 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	68 ec 2e 80 00       	push   $0x802eec
  800dff:	e8 f2 03 00 00       	call   8011f6 <cprintf>
  800e04:	83 c4 10             	add    $0x10,%esp

	return;
  800e07:	90                   	nop
}
  800e08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    

00800e0f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e15:	e8 70 17 00 00       	call   80258a <sys_getenvindex>
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	89 d0                	mov    %edx,%eax
  800e22:	c1 e0 03             	shl    $0x3,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800e2e:	01 c8                	add    %ecx,%eax
  800e30:	01 c0                	add    %eax,%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	01 c0                	add    %eax,%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	89 c2                	mov    %eax,%edx
  800e3a:	c1 e2 05             	shl    $0x5,%edx
  800e3d:	29 c2                	sub    %eax,%edx
  800e3f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800e46:	89 c2                	mov    %eax,%edx
  800e48:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800e4e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e53:	a1 20 40 80 00       	mov    0x804020,%eax
  800e58:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	74 0f                	je     800e71 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800e62:	a1 20 40 80 00       	mov    0x804020,%eax
  800e67:	05 40 3c 01 00       	add    $0x13c40,%eax
  800e6c:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e75:	7e 0a                	jle    800e81 <libmain+0x72>
		binaryname = argv[0];
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	8b 00                	mov    (%eax),%eax
  800e7c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	ff 75 08             	pushl  0x8(%ebp)
  800e8a:	e8 a9 f1 ff ff       	call   800038 <_main>
  800e8f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e92:	e8 8e 18 00 00       	call   802725 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	68 40 2f 80 00       	push   $0x802f40
  800e9f:	e8 52 03 00 00       	call   8011f6 <cprintf>
  800ea4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800ea7:	a1 20 40 80 00       	mov    0x804020,%eax
  800eac:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800eb2:	a1 20 40 80 00       	mov    0x804020,%eax
  800eb7:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800ebd:	83 ec 04             	sub    $0x4,%esp
  800ec0:	52                   	push   %edx
  800ec1:	50                   	push   %eax
  800ec2:	68 68 2f 80 00       	push   $0x802f68
  800ec7:	e8 2a 03 00 00       	call   8011f6 <cprintf>
  800ecc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800ecf:	a1 20 40 80 00       	mov    0x804020,%eax
  800ed4:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800eda:	a1 20 40 80 00       	mov    0x804020,%eax
  800edf:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	52                   	push   %edx
  800ee9:	50                   	push   %eax
  800eea:	68 90 2f 80 00       	push   $0x802f90
  800eef:	e8 02 03 00 00       	call   8011f6 <cprintf>
  800ef4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ef7:	a1 20 40 80 00       	mov    0x804020,%eax
  800efc:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800f02:	83 ec 08             	sub    $0x8,%esp
  800f05:	50                   	push   %eax
  800f06:	68 d1 2f 80 00       	push   $0x802fd1
  800f0b:	e8 e6 02 00 00       	call   8011f6 <cprintf>
  800f10:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	68 40 2f 80 00       	push   $0x802f40
  800f1b:	e8 d6 02 00 00       	call   8011f6 <cprintf>
  800f20:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f23:	e8 17 18 00 00       	call   80273f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f28:	e8 19 00 00 00       	call   800f46 <exit>
}
  800f2d:	90                   	nop
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800f36:	83 ec 0c             	sub    $0xc,%esp
  800f39:	6a 00                	push   $0x0
  800f3b:	e8 16 16 00 00       	call   802556 <sys_env_destroy>
  800f40:	83 c4 10             	add    $0x10,%esp
}
  800f43:	90                   	nop
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <exit>:

void
exit(void)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800f4c:	e8 6b 16 00 00       	call   8025bc <sys_env_exit>
}
  800f51:	90                   	nop
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    

00800f54 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800f5d:	83 c0 04             	add    $0x4,%eax
  800f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f63:	a1 18 41 80 00       	mov    0x804118,%eax
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	74 16                	je     800f82 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f6c:	a1 18 41 80 00       	mov    0x804118,%eax
  800f71:	83 ec 08             	sub    $0x8,%esp
  800f74:	50                   	push   %eax
  800f75:	68 e8 2f 80 00       	push   $0x802fe8
  800f7a:	e8 77 02 00 00       	call   8011f6 <cprintf>
  800f7f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f82:	a1 00 40 80 00       	mov    0x804000,%eax
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	ff 75 08             	pushl  0x8(%ebp)
  800f8d:	50                   	push   %eax
  800f8e:	68 ed 2f 80 00       	push   $0x802fed
  800f93:	e8 5e 02 00 00       	call   8011f6 <cprintf>
  800f98:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa4:	50                   	push   %eax
  800fa5:	e8 e1 01 00 00       	call   80118b <vcprintf>
  800faa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fad:	83 ec 08             	sub    $0x8,%esp
  800fb0:	6a 00                	push   $0x0
  800fb2:	68 09 30 80 00       	push   $0x803009
  800fb7:	e8 cf 01 00 00       	call   80118b <vcprintf>
  800fbc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fbf:	e8 82 ff ff ff       	call   800f46 <exit>

	// should not return here
	while (1) ;
  800fc4:	eb fe                	jmp    800fc4 <_panic+0x70>

00800fc6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fcc:	a1 20 40 80 00       	mov    0x804020,%eax
  800fd1:	8b 50 74             	mov    0x74(%eax),%edx
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	39 c2                	cmp    %eax,%edx
  800fd9:	74 14                	je     800fef <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fdb:	83 ec 04             	sub    $0x4,%esp
  800fde:	68 0c 30 80 00       	push   $0x80300c
  800fe3:	6a 26                	push   $0x26
  800fe5:	68 58 30 80 00       	push   $0x803058
  800fea:	e8 65 ff ff ff       	call   800f54 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ff6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffd:	e9 b6 00 00 00       	jmp    8010b8 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	01 d0                	add    %edx,%eax
  801011:	8b 00                	mov    (%eax),%eax
  801013:	85 c0                	test   %eax,%eax
  801015:	75 08                	jne    80101f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801017:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80101a:	e9 96 00 00 00       	jmp    8010b5 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80101f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801026:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80102d:	eb 5d                	jmp    80108c <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80102f:	a1 20 40 80 00       	mov    0x804020,%eax
  801034:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80103a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80103d:	c1 e2 04             	shl    $0x4,%edx
  801040:	01 d0                	add    %edx,%eax
  801042:	8a 40 04             	mov    0x4(%eax),%al
  801045:	84 c0                	test   %al,%al
  801047:	75 40                	jne    801089 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801049:	a1 20 40 80 00       	mov    0x804020,%eax
  80104e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  801054:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801057:	c1 e2 04             	shl    $0x4,%edx
  80105a:	01 d0                	add    %edx,%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801061:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801064:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801069:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80106b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	01 c8                	add    %ecx,%eax
  80107a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80107c:	39 c2                	cmp    %eax,%edx
  80107e:	75 09                	jne    801089 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  801080:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801087:	eb 12                	jmp    80109b <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801089:	ff 45 e8             	incl   -0x18(%ebp)
  80108c:	a1 20 40 80 00       	mov    0x804020,%eax
  801091:	8b 50 74             	mov    0x74(%eax),%edx
  801094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801097:	39 c2                	cmp    %eax,%edx
  801099:	77 94                	ja     80102f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80109b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109f:	75 14                	jne    8010b5 <CheckWSWithoutLastIndex+0xef>
			panic(
  8010a1:	83 ec 04             	sub    $0x4,%esp
  8010a4:	68 64 30 80 00       	push   $0x803064
  8010a9:	6a 3a                	push   $0x3a
  8010ab:	68 58 30 80 00       	push   $0x803058
  8010b0:	e8 9f fe ff ff       	call   800f54 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010b5:	ff 45 f0             	incl   -0x10(%ebp)
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010be:	0f 8c 3e ff ff ff    	jl     801002 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010d2:	eb 20                	jmp    8010f4 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8010d9:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8010df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8010e2:	c1 e2 04             	shl    $0x4,%edx
  8010e5:	01 d0                	add    %edx,%eax
  8010e7:	8a 40 04             	mov    0x4(%eax),%al
  8010ea:	3c 01                	cmp    $0x1,%al
  8010ec:	75 03                	jne    8010f1 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8010ee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010f1:	ff 45 e0             	incl   -0x20(%ebp)
  8010f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8010f9:	8b 50 74             	mov    0x74(%eax),%edx
  8010fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ff:	39 c2                	cmp    %eax,%edx
  801101:	77 d1                	ja     8010d4 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801106:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801109:	74 14                	je     80111f <CheckWSWithoutLastIndex+0x159>
		panic(
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	68 b8 30 80 00       	push   $0x8030b8
  801113:	6a 44                	push   $0x44
  801115:	68 58 30 80 00       	push   $0x803058
  80111a:	e8 35 fe ff ff       	call   800f54 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80111f:	90                   	nop
  801120:	c9                   	leave  
  801121:	c3                   	ret    

00801122 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	8d 48 01             	lea    0x1(%eax),%ecx
  801130:	8b 55 0c             	mov    0xc(%ebp),%edx
  801133:	89 0a                	mov    %ecx,(%edx)
  801135:	8b 55 08             	mov    0x8(%ebp),%edx
  801138:	88 d1                	mov    %dl,%cl
  80113a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	8b 00                	mov    (%eax),%eax
  801146:	3d ff 00 00 00       	cmp    $0xff,%eax
  80114b:	75 2c                	jne    801179 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80114d:	a0 24 40 80 00       	mov    0x804024,%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	8b 55 0c             	mov    0xc(%ebp),%edx
  801158:	8b 12                	mov    (%edx),%edx
  80115a:	89 d1                	mov    %edx,%ecx
  80115c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115f:	83 c2 08             	add    $0x8,%edx
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	50                   	push   %eax
  801166:	51                   	push   %ecx
  801167:	52                   	push   %edx
  801168:	e8 a7 13 00 00       	call   802514 <sys_cputs>
  80116d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8b 40 04             	mov    0x4(%eax),%eax
  80117f:	8d 50 01             	lea    0x1(%eax),%edx
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	89 50 04             	mov    %edx,0x4(%eax)
}
  801188:	90                   	nop
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801194:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80119b:	00 00 00 
	b.cnt = 0;
  80119e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011a5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011b4:	50                   	push   %eax
  8011b5:	68 22 11 80 00       	push   $0x801122
  8011ba:	e8 11 02 00 00       	call   8013d0 <vprintfmt>
  8011bf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011c2:	a0 24 40 80 00       	mov    0x804024,%al
  8011c7:	0f b6 c0             	movzbl %al,%eax
  8011ca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	50                   	push   %eax
  8011d4:	52                   	push   %edx
  8011d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011db:	83 c0 08             	add    $0x8,%eax
  8011de:	50                   	push   %eax
  8011df:	e8 30 13 00 00       	call   802514 <sys_cputs>
  8011e4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8011e7:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8011ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8011fc:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801203:	8d 45 0c             	lea    0xc(%ebp),%eax
  801206:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	e8 73 ff ff ff       	call   80118b <vcprintf>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801229:	e8 f7 14 00 00       	call   802725 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80122e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801231:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 f4             	pushl  -0xc(%ebp)
  80123d:	50                   	push   %eax
  80123e:	e8 48 ff ff ff       	call   80118b <vcprintf>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801249:	e8 f1 14 00 00       	call   80273f <sys_enable_interrupt>
	return cnt;
  80124e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	53                   	push   %ebx
  801257:	83 ec 14             	sub    $0x14,%esp
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801260:	8b 45 14             	mov    0x14(%ebp),%eax
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801266:	8b 45 18             	mov    0x18(%ebp),%eax
  801269:	ba 00 00 00 00       	mov    $0x0,%edx
  80126e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801271:	77 55                	ja     8012c8 <printnum+0x75>
  801273:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801276:	72 05                	jb     80127d <printnum+0x2a>
  801278:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127b:	77 4b                	ja     8012c8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80127d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801280:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801283:	8b 45 18             	mov    0x18(%ebp),%eax
  801286:	ba 00 00 00 00       	mov    $0x0,%edx
  80128b:	52                   	push   %edx
  80128c:	50                   	push   %eax
  80128d:	ff 75 f4             	pushl  -0xc(%ebp)
  801290:	ff 75 f0             	pushl  -0x10(%ebp)
  801293:	e8 b0 18 00 00       	call   802b48 <__udivdi3>
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	83 ec 04             	sub    $0x4,%esp
  80129e:	ff 75 20             	pushl  0x20(%ebp)
  8012a1:	53                   	push   %ebx
  8012a2:	ff 75 18             	pushl  0x18(%ebp)
  8012a5:	52                   	push   %edx
  8012a6:	50                   	push   %eax
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	ff 75 08             	pushl  0x8(%ebp)
  8012ad:	e8 a1 ff ff ff       	call   801253 <printnum>
  8012b2:	83 c4 20             	add    $0x20,%esp
  8012b5:	eb 1a                	jmp    8012d1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012b7:	83 ec 08             	sub    $0x8,%esp
  8012ba:	ff 75 0c             	pushl  0xc(%ebp)
  8012bd:	ff 75 20             	pushl  0x20(%ebp)
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	ff d0                	call   *%eax
  8012c5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012c8:	ff 4d 1c             	decl   0x1c(%ebp)
  8012cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012cf:	7f e6                	jg     8012b7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012d1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012df:	53                   	push   %ebx
  8012e0:	51                   	push   %ecx
  8012e1:	52                   	push   %edx
  8012e2:	50                   	push   %eax
  8012e3:	e8 70 19 00 00       	call   802c58 <__umoddi3>
  8012e8:	83 c4 10             	add    $0x10,%esp
  8012eb:	05 34 33 80 00       	add    $0x803334,%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be c0             	movsbl %al,%eax
  8012f5:	83 ec 08             	sub    $0x8,%esp
  8012f8:	ff 75 0c             	pushl  0xc(%ebp)
  8012fb:	50                   	push   %eax
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	ff d0                	call   *%eax
  801301:	83 c4 10             	add    $0x10,%esp
}
  801304:	90                   	nop
  801305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80130d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801311:	7e 1c                	jle    80132f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 50 08             	lea    0x8(%eax),%edx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	89 10                	mov    %edx,(%eax)
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8b 00                	mov    (%eax),%eax
  801325:	83 e8 08             	sub    $0x8,%eax
  801328:	8b 50 04             	mov    0x4(%eax),%edx
  80132b:	8b 00                	mov    (%eax),%eax
  80132d:	eb 40                	jmp    80136f <getuint+0x65>
	else if (lflag)
  80132f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801333:	74 1e                	je     801353 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 50 04             	lea    0x4(%eax),%edx
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	89 10                	mov    %edx,(%eax)
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	83 e8 04             	sub    $0x4,%eax
  80134a:	8b 00                	mov    (%eax),%eax
  80134c:	ba 00 00 00 00       	mov    $0x0,%edx
  801351:	eb 1c                	jmp    80136f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8b 00                	mov    (%eax),%eax
  801358:	8d 50 04             	lea    0x4(%eax),%edx
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	89 10                	mov    %edx,(%eax)
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	83 e8 04             	sub    $0x4,%eax
  801368:	8b 00                	mov    (%eax),%eax
  80136a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80136f:	5d                   	pop    %ebp
  801370:	c3                   	ret    

00801371 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801374:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801378:	7e 1c                	jle    801396 <getint+0x25>
		return va_arg(*ap, long long);
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8b 00                	mov    (%eax),%eax
  80137f:	8d 50 08             	lea    0x8(%eax),%edx
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	89 10                	mov    %edx,(%eax)
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8b 00                	mov    (%eax),%eax
  80138c:	83 e8 08             	sub    $0x8,%eax
  80138f:	8b 50 04             	mov    0x4(%eax),%edx
  801392:	8b 00                	mov    (%eax),%eax
  801394:	eb 38                	jmp    8013ce <getint+0x5d>
	else if (lflag)
  801396:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139a:	74 1a                	je     8013b6 <getint+0x45>
		return va_arg(*ap, long);
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8b 00                	mov    (%eax),%eax
  8013a1:	8d 50 04             	lea    0x4(%eax),%edx
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 10                	mov    %edx,(%eax)
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8b 00                	mov    (%eax),%eax
  8013ae:	83 e8 04             	sub    $0x4,%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	99                   	cltd   
  8013b4:	eb 18                	jmp    8013ce <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	8d 50 04             	lea    0x4(%eax),%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 10                	mov    %edx,(%eax)
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	83 e8 04             	sub    $0x4,%eax
  8013cb:	8b 00                	mov    (%eax),%eax
  8013cd:	99                   	cltd   
}
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	56                   	push   %esi
  8013d4:	53                   	push   %ebx
  8013d5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013d8:	eb 17                	jmp    8013f1 <vprintfmt+0x21>
			if (ch == '\0')
  8013da:	85 db                	test   %ebx,%ebx
  8013dc:	0f 84 af 03 00 00    	je     801791 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	53                   	push   %ebx
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	ff d0                	call   *%eax
  8013ee:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	8d 50 01             	lea    0x1(%eax),%edx
  8013f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	0f b6 d8             	movzbl %al,%ebx
  8013ff:	83 fb 25             	cmp    $0x25,%ebx
  801402:	75 d6                	jne    8013da <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801404:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801408:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80140f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801416:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80141d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801424:	8b 45 10             	mov    0x10(%ebp),%eax
  801427:	8d 50 01             	lea    0x1(%eax),%edx
  80142a:	89 55 10             	mov    %edx,0x10(%ebp)
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	0f b6 d8             	movzbl %al,%ebx
  801432:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801435:	83 f8 55             	cmp    $0x55,%eax
  801438:	0f 87 2b 03 00 00    	ja     801769 <vprintfmt+0x399>
  80143e:	8b 04 85 58 33 80 00 	mov    0x803358(,%eax,4),%eax
  801445:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801447:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80144b:	eb d7                	jmp    801424 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80144d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801451:	eb d1                	jmp    801424 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801453:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80145a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145d:	89 d0                	mov    %edx,%eax
  80145f:	c1 e0 02             	shl    $0x2,%eax
  801462:	01 d0                	add    %edx,%eax
  801464:	01 c0                	add    %eax,%eax
  801466:	01 d8                	add    %ebx,%eax
  801468:	83 e8 30             	sub    $0x30,%eax
  80146b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801476:	83 fb 2f             	cmp    $0x2f,%ebx
  801479:	7e 3e                	jle    8014b9 <vprintfmt+0xe9>
  80147b:	83 fb 39             	cmp    $0x39,%ebx
  80147e:	7f 39                	jg     8014b9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801480:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801483:	eb d5                	jmp    80145a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801485:	8b 45 14             	mov    0x14(%ebp),%eax
  801488:	83 c0 04             	add    $0x4,%eax
  80148b:	89 45 14             	mov    %eax,0x14(%ebp)
  80148e:	8b 45 14             	mov    0x14(%ebp),%eax
  801491:	83 e8 04             	sub    $0x4,%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801499:	eb 1f                	jmp    8014ba <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80149b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80149f:	79 83                	jns    801424 <vprintfmt+0x54>
				width = 0;
  8014a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014a8:	e9 77 ff ff ff       	jmp    801424 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014ad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014b4:	e9 6b ff ff ff       	jmp    801424 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014b9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014be:	0f 89 60 ff ff ff    	jns    801424 <vprintfmt+0x54>
				width = precision, precision = -1;
  8014c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014d1:	e9 4e ff ff ff       	jmp    801424 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014d6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014d9:	e9 46 ff ff ff       	jmp    801424 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8014de:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e1:	83 c0 04             	add    $0x4,%eax
  8014e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ea:	83 e8 04             	sub    $0x4,%eax
  8014ed:	8b 00                	mov    (%eax),%eax
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	ff 75 0c             	pushl  0xc(%ebp)
  8014f5:	50                   	push   %eax
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	ff d0                	call   *%eax
  8014fb:	83 c4 10             	add    $0x10,%esp
			break;
  8014fe:	e9 89 02 00 00       	jmp    80178c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801503:	8b 45 14             	mov    0x14(%ebp),%eax
  801506:	83 c0 04             	add    $0x4,%eax
  801509:	89 45 14             	mov    %eax,0x14(%ebp)
  80150c:	8b 45 14             	mov    0x14(%ebp),%eax
  80150f:	83 e8 04             	sub    $0x4,%eax
  801512:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801514:	85 db                	test   %ebx,%ebx
  801516:	79 02                	jns    80151a <vprintfmt+0x14a>
				err = -err;
  801518:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80151a:	83 fb 64             	cmp    $0x64,%ebx
  80151d:	7f 0b                	jg     80152a <vprintfmt+0x15a>
  80151f:	8b 34 9d a0 31 80 00 	mov    0x8031a0(,%ebx,4),%esi
  801526:	85 f6                	test   %esi,%esi
  801528:	75 19                	jne    801543 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80152a:	53                   	push   %ebx
  80152b:	68 45 33 80 00       	push   $0x803345
  801530:	ff 75 0c             	pushl  0xc(%ebp)
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 5e 02 00 00       	call   801799 <printfmt>
  80153b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80153e:	e9 49 02 00 00       	jmp    80178c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801543:	56                   	push   %esi
  801544:	68 4e 33 80 00       	push   $0x80334e
  801549:	ff 75 0c             	pushl  0xc(%ebp)
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	e8 45 02 00 00       	call   801799 <printfmt>
  801554:	83 c4 10             	add    $0x10,%esp
			break;
  801557:	e9 30 02 00 00       	jmp    80178c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80155c:	8b 45 14             	mov    0x14(%ebp),%eax
  80155f:	83 c0 04             	add    $0x4,%eax
  801562:	89 45 14             	mov    %eax,0x14(%ebp)
  801565:	8b 45 14             	mov    0x14(%ebp),%eax
  801568:	83 e8 04             	sub    $0x4,%eax
  80156b:	8b 30                	mov    (%eax),%esi
  80156d:	85 f6                	test   %esi,%esi
  80156f:	75 05                	jne    801576 <vprintfmt+0x1a6>
				p = "(null)";
  801571:	be 51 33 80 00       	mov    $0x803351,%esi
			if (width > 0 && padc != '-')
  801576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80157a:	7e 6d                	jle    8015e9 <vprintfmt+0x219>
  80157c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801580:	74 67                	je     8015e9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	50                   	push   %eax
  801589:	56                   	push   %esi
  80158a:	e8 0c 03 00 00       	call   80189b <strnlen>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801595:	eb 16                	jmp    8015ad <vprintfmt+0x1dd>
					putch(padc, putdat);
  801597:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	50                   	push   %eax
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	ff d0                	call   *%eax
  8015a7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8015ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015b1:	7f e4                	jg     801597 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015b3:	eb 34                	jmp    8015e9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015b5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015b9:	74 1c                	je     8015d7 <vprintfmt+0x207>
  8015bb:	83 fb 1f             	cmp    $0x1f,%ebx
  8015be:	7e 05                	jle    8015c5 <vprintfmt+0x1f5>
  8015c0:	83 fb 7e             	cmp    $0x7e,%ebx
  8015c3:	7e 12                	jle    8015d7 <vprintfmt+0x207>
					putch('?', putdat);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	6a 3f                	push   $0x3f
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	ff d0                	call   *%eax
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	eb 0f                	jmp    8015e6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015d7:	83 ec 08             	sub    $0x8,%esp
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	53                   	push   %ebx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	ff d0                	call   *%eax
  8015e3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8015e9:	89 f0                	mov    %esi,%eax
  8015eb:	8d 70 01             	lea    0x1(%eax),%esi
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	0f be d8             	movsbl %al,%ebx
  8015f3:	85 db                	test   %ebx,%ebx
  8015f5:	74 24                	je     80161b <vprintfmt+0x24b>
  8015f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015fb:	78 b8                	js     8015b5 <vprintfmt+0x1e5>
  8015fd:	ff 4d e0             	decl   -0x20(%ebp)
  801600:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801604:	79 af                	jns    8015b5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801606:	eb 13                	jmp    80161b <vprintfmt+0x24b>
				putch(' ', putdat);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	6a 20                	push   $0x20
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801618:	ff 4d e4             	decl   -0x1c(%ebp)
  80161b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80161f:	7f e7                	jg     801608 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801621:	e9 66 01 00 00       	jmp    80178c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	ff 75 e8             	pushl  -0x18(%ebp)
  80162c:	8d 45 14             	lea    0x14(%ebp),%eax
  80162f:	50                   	push   %eax
  801630:	e8 3c fd ff ff       	call   801371 <getint>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80163b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801644:	85 d2                	test   %edx,%edx
  801646:	79 23                	jns    80166b <vprintfmt+0x29b>
				putch('-', putdat);
  801648:	83 ec 08             	sub    $0x8,%esp
  80164b:	ff 75 0c             	pushl  0xc(%ebp)
  80164e:	6a 2d                	push   $0x2d
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	ff d0                	call   *%eax
  801655:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165e:	f7 d8                	neg    %eax
  801660:	83 d2 00             	adc    $0x0,%edx
  801663:	f7 da                	neg    %edx
  801665:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801668:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80166b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801672:	e9 bc 00 00 00       	jmp    801733 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	ff 75 e8             	pushl  -0x18(%ebp)
  80167d:	8d 45 14             	lea    0x14(%ebp),%eax
  801680:	50                   	push   %eax
  801681:	e8 84 fc ff ff       	call   80130a <getuint>
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80168f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801696:	e9 98 00 00 00       	jmp    801733 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	6a 58                	push   $0x58
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	ff d0                	call   *%eax
  8016a8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016ab:	83 ec 08             	sub    $0x8,%esp
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	6a 58                	push   $0x58
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	ff d0                	call   *%eax
  8016b8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	6a 58                	push   $0x58
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	ff d0                	call   *%eax
  8016c8:	83 c4 10             	add    $0x10,%esp
			break;
  8016cb:	e9 bc 00 00 00       	jmp    80178c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016d0:	83 ec 08             	sub    $0x8,%esp
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	6a 30                	push   $0x30
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	ff d0                	call   *%eax
  8016dd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	ff 75 0c             	pushl  0xc(%ebp)
  8016e6:	6a 78                	push   $0x78
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	ff d0                	call   *%eax
  8016ed:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8016f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f3:	83 c0 04             	add    $0x4,%eax
  8016f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8016f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fc:	83 e8 04             	sub    $0x4,%eax
  8016ff:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80170b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801712:	eb 1f                	jmp    801733 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801714:	83 ec 08             	sub    $0x8,%esp
  801717:	ff 75 e8             	pushl  -0x18(%ebp)
  80171a:	8d 45 14             	lea    0x14(%ebp),%eax
  80171d:	50                   	push   %eax
  80171e:	e8 e7 fb ff ff       	call   80130a <getuint>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801729:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80172c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801733:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	52                   	push   %edx
  80173e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801741:	50                   	push   %eax
  801742:	ff 75 f4             	pushl  -0xc(%ebp)
  801745:	ff 75 f0             	pushl  -0x10(%ebp)
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 00 fb ff ff       	call   801253 <printnum>
  801753:	83 c4 20             	add    $0x20,%esp
			break;
  801756:	eb 34                	jmp    80178c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	53                   	push   %ebx
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	ff d0                	call   *%eax
  801764:	83 c4 10             	add    $0x10,%esp
			break;
  801767:	eb 23                	jmp    80178c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	6a 25                	push   $0x25
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	ff d0                	call   *%eax
  801776:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801779:	ff 4d 10             	decl   0x10(%ebp)
  80177c:	eb 03                	jmp    801781 <vprintfmt+0x3b1>
  80177e:	ff 4d 10             	decl   0x10(%ebp)
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	48                   	dec    %eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3c 25                	cmp    $0x25,%al
  801789:	75 f3                	jne    80177e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80178b:	90                   	nop
		}
	}
  80178c:	e9 47 fc ff ff       	jmp    8013d8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801791:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801792:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801795:	5b                   	pop    %ebx
  801796:	5e                   	pop    %esi
  801797:	5d                   	pop    %ebp
  801798:	c3                   	ret    

00801799 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80179f:	8d 45 10             	lea    0x10(%ebp),%eax
  8017a2:	83 c0 04             	add    $0x4,%eax
  8017a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ae:	50                   	push   %eax
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	ff 75 08             	pushl  0x8(%ebp)
  8017b5:	e8 16 fc ff ff       	call   8013d0 <vprintfmt>
  8017ba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c6:	8b 40 08             	mov    0x8(%eax),%eax
  8017c9:	8d 50 01             	lea    0x1(%eax),%edx
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d5:	8b 10                	mov    (%eax),%edx
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	8b 40 04             	mov    0x4(%eax),%eax
  8017dd:	39 c2                	cmp    %eax,%edx
  8017df:	73 12                	jae    8017f3 <sprintputch+0x33>
		*b->buf++ = ch;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	8b 00                	mov    (%eax),%eax
  8017e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	89 0a                	mov    %ecx,(%edx)
  8017ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f1:	88 10                	mov    %dl,(%eax)
}
  8017f3:	90                   	nop
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801802:	8b 45 0c             	mov    0xc(%ebp),%eax
  801805:	8d 50 ff             	lea    -0x1(%eax),%edx
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	01 d0                	add    %edx,%eax
  80180d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	74 06                	je     801823 <vsnprintf+0x2d>
  80181d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801821:	7f 07                	jg     80182a <vsnprintf+0x34>
		return -E_INVAL;
  801823:	b8 03 00 00 00       	mov    $0x3,%eax
  801828:	eb 20                	jmp    80184a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80182a:	ff 75 14             	pushl  0x14(%ebp)
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801833:	50                   	push   %eax
  801834:	68 c0 17 80 00       	push   $0x8017c0
  801839:	e8 92 fb ff ff       	call   8013d0 <vprintfmt>
  80183e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801844:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801852:	8d 45 10             	lea    0x10(%ebp),%eax
  801855:	83 c0 04             	add    $0x4,%eax
  801858:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	ff 75 f4             	pushl  -0xc(%ebp)
  801861:	50                   	push   %eax
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	e8 89 ff ff ff       	call   8017f6 <vsnprintf>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801873:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80187e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801885:	eb 06                	jmp    80188d <strlen+0x15>
		n++;
  801887:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80188a:	ff 45 08             	incl   0x8(%ebp)
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	8a 00                	mov    (%eax),%al
  801892:	84 c0                	test   %al,%al
  801894:	75 f1                	jne    801887 <strlen+0xf>
		n++;
	return n;
  801896:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018a8:	eb 09                	jmp    8018b3 <strnlen+0x18>
		n++;
  8018aa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ad:	ff 45 08             	incl   0x8(%ebp)
  8018b0:	ff 4d 0c             	decl   0xc(%ebp)
  8018b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018b7:	74 09                	je     8018c2 <strnlen+0x27>
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	8a 00                	mov    (%eax),%al
  8018be:	84 c0                	test   %al,%al
  8018c0:	75 e8                	jne    8018aa <strnlen+0xf>
		n++;
	return n;
  8018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018d3:	90                   	nop
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8d 50 01             	lea    0x1(%eax),%edx
  8018da:	89 55 08             	mov    %edx,0x8(%ebp)
  8018dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018e6:	8a 12                	mov    (%edx),%dl
  8018e8:	88 10                	mov    %dl,(%eax)
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	84 c0                	test   %al,%al
  8018ee:	75 e4                	jne    8018d4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8018f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801901:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801908:	eb 1f                	jmp    801929 <strncpy+0x34>
		*dst++ = *src;
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8d 50 01             	lea    0x1(%eax),%edx
  801910:	89 55 08             	mov    %edx,0x8(%ebp)
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	8a 12                	mov    (%edx),%dl
  801918:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	8a 00                	mov    (%eax),%al
  80191f:	84 c0                	test   %al,%al
  801921:	74 03                	je     801926 <strncpy+0x31>
			src++;
  801923:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801926:	ff 45 fc             	incl   -0x4(%ebp)
  801929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80192f:	72 d9                	jb     80190a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801931:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801942:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801946:	74 30                	je     801978 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801948:	eb 16                	jmp    801960 <strlcpy+0x2a>
			*dst++ = *src++;
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	8d 50 01             	lea    0x1(%eax),%edx
  801950:	89 55 08             	mov    %edx,0x8(%ebp)
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8d 4a 01             	lea    0x1(%edx),%ecx
  801959:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80195c:	8a 12                	mov    (%edx),%dl
  80195e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801960:	ff 4d 10             	decl   0x10(%ebp)
  801963:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801967:	74 09                	je     801972 <strlcpy+0x3c>
  801969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196c:	8a 00                	mov    (%eax),%al
  80196e:	84 c0                	test   %al,%al
  801970:	75 d8                	jne    80194a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801978:	8b 55 08             	mov    0x8(%ebp),%edx
  80197b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197e:	29 c2                	sub    %eax,%edx
  801980:	89 d0                	mov    %edx,%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801987:	eb 06                	jmp    80198f <strcmp+0xb>
		p++, q++;
  801989:	ff 45 08             	incl   0x8(%ebp)
  80198c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	74 0e                	je     8019a6 <strcmp+0x22>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 10                	mov    (%eax),%dl
  80199d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a0:	8a 00                	mov    (%eax),%al
  8019a2:	38 c2                	cmp    %al,%dl
  8019a4:	74 e3                	je     801989 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	8a 00                	mov    (%eax),%al
  8019ab:	0f b6 d0             	movzbl %al,%edx
  8019ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f b6 c0             	movzbl %al,%eax
  8019b6:	29 c2                	sub    %eax,%edx
  8019b8:	89 d0                	mov    %edx,%eax
}
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    

008019bc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019bf:	eb 09                	jmp    8019ca <strncmp+0xe>
		n--, p++, q++;
  8019c1:	ff 4d 10             	decl   0x10(%ebp)
  8019c4:	ff 45 08             	incl   0x8(%ebp)
  8019c7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ce:	74 17                	je     8019e7 <strncmp+0x2b>
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	84 c0                	test   %al,%al
  8019d7:	74 0e                	je     8019e7 <strncmp+0x2b>
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	8a 10                	mov    (%eax),%dl
  8019de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e1:	8a 00                	mov    (%eax),%al
  8019e3:	38 c2                	cmp    %al,%dl
  8019e5:	74 da                	je     8019c1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8019e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019eb:	75 07                	jne    8019f4 <strncmp+0x38>
		return 0;
  8019ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f2:	eb 14                	jmp    801a08 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8a 00                	mov    (%eax),%al
  8019f9:	0f b6 d0             	movzbl %al,%edx
  8019fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ff:	8a 00                	mov    (%eax),%al
  801a01:	0f b6 c0             	movzbl %al,%eax
  801a04:	29 c2                	sub    %eax,%edx
  801a06:	89 d0                	mov    %edx,%eax
}
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    

00801a0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a16:	eb 12                	jmp    801a2a <strchr+0x20>
		if (*s == c)
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a20:	75 05                	jne    801a27 <strchr+0x1d>
			return (char *) s;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	eb 11                	jmp    801a38 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a27:	ff 45 08             	incl   0x8(%ebp)
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	8a 00                	mov    (%eax),%al
  801a2f:	84 c0                	test   %al,%al
  801a31:	75 e5                	jne    801a18 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a46:	eb 0d                	jmp    801a55 <strfind+0x1b>
		if (*s == c)
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a50:	74 0e                	je     801a60 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a52:	ff 45 08             	incl   0x8(%ebp)
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	8a 00                	mov    (%eax),%al
  801a5a:	84 c0                	test   %al,%al
  801a5c:	75 ea                	jne    801a48 <strfind+0xe>
  801a5e:	eb 01                	jmp    801a61 <strfind+0x27>
		if (*s == c)
			break;
  801a60:	90                   	nop
	return (char *) s;
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a78:	eb 0e                	jmp    801a88 <memset+0x22>
		*p++ = c;
  801a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a7d:	8d 50 01             	lea    0x1(%eax),%edx
  801a80:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a86:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a88:	ff 4d f8             	decl   -0x8(%ebp)
  801a8b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a8f:	79 e9                	jns    801a7a <memset+0x14>
		*p++ = c;

	return v;
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801aa8:	eb 16                	jmp    801ac0 <memcpy+0x2a>
		*d++ = *s++;
  801aaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aad:	8d 50 01             	lea    0x1(%eax),%edx
  801ab0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ab3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab6:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801abc:	8a 12                	mov    (%edx),%dl
  801abe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac3:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac6:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	75 dd                	jne    801aaa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801aea:	73 50                	jae    801b3c <memmove+0x6a>
  801aec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aef:	8b 45 10             	mov    0x10(%ebp),%eax
  801af2:	01 d0                	add    %edx,%eax
  801af4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801af7:	76 43                	jbe    801b3c <memmove+0x6a>
		s += n;
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801aff:	8b 45 10             	mov    0x10(%ebp),%eax
  801b02:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b05:	eb 10                	jmp    801b17 <memmove+0x45>
			*--d = *--s;
  801b07:	ff 4d f8             	decl   -0x8(%ebp)
  801b0a:	ff 4d fc             	decl   -0x4(%ebp)
  801b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b10:	8a 10                	mov    (%eax),%dl
  801b12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b15:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b17:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b1d:	89 55 10             	mov    %edx,0x10(%ebp)
  801b20:	85 c0                	test   %eax,%eax
  801b22:	75 e3                	jne    801b07 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b24:	eb 23                	jmp    801b49 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b29:	8d 50 01             	lea    0x1(%eax),%edx
  801b2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b32:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b38:	8a 12                	mov    (%edx),%dl
  801b3a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b42:	89 55 10             	mov    %edx,0x10(%ebp)
  801b45:	85 c0                	test   %eax,%eax
  801b47:	75 dd                	jne    801b26 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b60:	eb 2a                	jmp    801b8c <memcmp+0x3e>
		if (*s1 != *s2)
  801b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b65:	8a 10                	mov    (%eax),%dl
  801b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6a:	8a 00                	mov    (%eax),%al
  801b6c:	38 c2                	cmp    %al,%dl
  801b6e:	74 16                	je     801b86 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b73:	8a 00                	mov    (%eax),%al
  801b75:	0f b6 d0             	movzbl %al,%edx
  801b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7b:	8a 00                	mov    (%eax),%al
  801b7d:	0f b6 c0             	movzbl %al,%eax
  801b80:	29 c2                	sub    %eax,%edx
  801b82:	89 d0                	mov    %edx,%eax
  801b84:	eb 18                	jmp    801b9e <memcmp+0x50>
		s1++, s2++;
  801b86:	ff 45 fc             	incl   -0x4(%ebp)
  801b89:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b92:	89 55 10             	mov    %edx,0x10(%ebp)
  801b95:	85 c0                	test   %eax,%eax
  801b97:	75 c9                	jne    801b62 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bac:	01 d0                	add    %edx,%eax
  801bae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bb1:	eb 15                	jmp    801bc8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	8a 00                	mov    (%eax),%al
  801bb8:	0f b6 d0             	movzbl %al,%edx
  801bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbe:	0f b6 c0             	movzbl %al,%eax
  801bc1:	39 c2                	cmp    %eax,%edx
  801bc3:	74 0d                	je     801bd2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801bc5:	ff 45 08             	incl   0x8(%ebp)
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bce:	72 e3                	jb     801bb3 <memfind+0x13>
  801bd0:	eb 01                	jmp    801bd3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bd2:	90                   	nop
	return (void *) s;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801be5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bec:	eb 03                	jmp    801bf1 <strtol+0x19>
		s++;
  801bee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	8a 00                	mov    (%eax),%al
  801bf6:	3c 20                	cmp    $0x20,%al
  801bf8:	74 f4                	je     801bee <strtol+0x16>
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	8a 00                	mov    (%eax),%al
  801bff:	3c 09                	cmp    $0x9,%al
  801c01:	74 eb                	je     801bee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	8a 00                	mov    (%eax),%al
  801c08:	3c 2b                	cmp    $0x2b,%al
  801c0a:	75 05                	jne    801c11 <strtol+0x39>
		s++;
  801c0c:	ff 45 08             	incl   0x8(%ebp)
  801c0f:	eb 13                	jmp    801c24 <strtol+0x4c>
	else if (*s == '-')
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	8a 00                	mov    (%eax),%al
  801c16:	3c 2d                	cmp    $0x2d,%al
  801c18:	75 0a                	jne    801c24 <strtol+0x4c>
		s++, neg = 1;
  801c1a:	ff 45 08             	incl   0x8(%ebp)
  801c1d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c28:	74 06                	je     801c30 <strtol+0x58>
  801c2a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c2e:	75 20                	jne    801c50 <strtol+0x78>
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	8a 00                	mov    (%eax),%al
  801c35:	3c 30                	cmp    $0x30,%al
  801c37:	75 17                	jne    801c50 <strtol+0x78>
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	40                   	inc    %eax
  801c3d:	8a 00                	mov    (%eax),%al
  801c3f:	3c 78                	cmp    $0x78,%al
  801c41:	75 0d                	jne    801c50 <strtol+0x78>
		s += 2, base = 16;
  801c43:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c47:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c4e:	eb 28                	jmp    801c78 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c54:	75 15                	jne    801c6b <strtol+0x93>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 0c                	jne    801c6b <strtol+0x93>
		s++, base = 8;
  801c5f:	ff 45 08             	incl   0x8(%ebp)
  801c62:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c69:	eb 0d                	jmp    801c78 <strtol+0xa0>
	else if (base == 0)
  801c6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c6f:	75 07                	jne    801c78 <strtol+0xa0>
		base = 10;
  801c71:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	8a 00                	mov    (%eax),%al
  801c7d:	3c 2f                	cmp    $0x2f,%al
  801c7f:	7e 19                	jle    801c9a <strtol+0xc2>
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8a 00                	mov    (%eax),%al
  801c86:	3c 39                	cmp    $0x39,%al
  801c88:	7f 10                	jg     801c9a <strtol+0xc2>
			dig = *s - '0';
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	8a 00                	mov    (%eax),%al
  801c8f:	0f be c0             	movsbl %al,%eax
  801c92:	83 e8 30             	sub    $0x30,%eax
  801c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c98:	eb 42                	jmp    801cdc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8a 00                	mov    (%eax),%al
  801c9f:	3c 60                	cmp    $0x60,%al
  801ca1:	7e 19                	jle    801cbc <strtol+0xe4>
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	3c 7a                	cmp    $0x7a,%al
  801caa:	7f 10                	jg     801cbc <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	83 e8 57             	sub    $0x57,%eax
  801cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cba:	eb 20                	jmp    801cdc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	8a 00                	mov    (%eax),%al
  801cc1:	3c 40                	cmp    $0x40,%al
  801cc3:	7e 39                	jle    801cfe <strtol+0x126>
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8a 00                	mov    (%eax),%al
  801cca:	3c 5a                	cmp    $0x5a,%al
  801ccc:	7f 30                	jg     801cfe <strtol+0x126>
			dig = *s - 'A' + 10;
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	8a 00                	mov    (%eax),%al
  801cd3:	0f be c0             	movsbl %al,%eax
  801cd6:	83 e8 37             	sub    $0x37,%eax
  801cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdf:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ce2:	7d 19                	jge    801cfd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ce4:	ff 45 08             	incl   0x8(%ebp)
  801ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cea:	0f af 45 10          	imul   0x10(%ebp),%eax
  801cee:	89 c2                	mov    %eax,%edx
  801cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf3:	01 d0                	add    %edx,%eax
  801cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801cf8:	e9 7b ff ff ff       	jmp    801c78 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801cfd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801cfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d02:	74 08                	je     801d0c <strtol+0x134>
		*endptr = (char *) s;
  801d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d07:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d10:	74 07                	je     801d19 <strtol+0x141>
  801d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d15:	f7 d8                	neg    %eax
  801d17:	eb 03                	jmp    801d1c <strtol+0x144>
  801d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <ltostr>:

void
ltostr(long value, char *str)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d36:	79 13                	jns    801d4b <ltostr+0x2d>
	{
		neg = 1;
  801d38:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d42:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d45:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d48:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d53:	99                   	cltd   
  801d54:	f7 f9                	idiv   %ecx
  801d56:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5c:	8d 50 01             	lea    0x1(%eax),%edx
  801d5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d62:	89 c2                	mov    %eax,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d6c:	83 c2 30             	add    $0x30,%edx
  801d6f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d74:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d79:	f7 e9                	imul   %ecx
  801d7b:	c1 fa 02             	sar    $0x2,%edx
  801d7e:	89 c8                	mov    %ecx,%eax
  801d80:	c1 f8 1f             	sar    $0x1f,%eax
  801d83:	29 c2                	sub    %eax,%edx
  801d85:	89 d0                	mov    %edx,%eax
  801d87:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d92:	f7 e9                	imul   %ecx
  801d94:	c1 fa 02             	sar    $0x2,%edx
  801d97:	89 c8                	mov    %ecx,%eax
  801d99:	c1 f8 1f             	sar    $0x1f,%eax
  801d9c:	29 c2                	sub    %eax,%edx
  801d9e:	89 d0                	mov    %edx,%eax
  801da0:	c1 e0 02             	shl    $0x2,%eax
  801da3:	01 d0                	add    %edx,%eax
  801da5:	01 c0                	add    %eax,%eax
  801da7:	29 c1                	sub    %eax,%ecx
  801da9:	89 ca                	mov    %ecx,%edx
  801dab:	85 d2                	test   %edx,%edx
  801dad:	75 9c                	jne    801d4b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801db6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db9:	48                   	dec    %eax
  801dba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801dbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dc1:	74 3d                	je     801e00 <ltostr+0xe2>
		start = 1 ;
  801dc3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801dca:	eb 34                	jmp    801e00 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd2:	01 d0                	add    %edx,%eax
  801dd4:	8a 00                	mov    (%eax),%al
  801dd6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddf:	01 c2                	add    %eax,%edx
  801de1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de7:	01 c8                	add    %ecx,%eax
  801de9:	8a 00                	mov    (%eax),%al
  801deb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ded:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df3:	01 c2                	add    %eax,%edx
  801df5:	8a 45 eb             	mov    -0x15(%ebp),%al
  801df8:	88 02                	mov    %al,(%edx)
		start++ ;
  801dfa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801dfd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e06:	7c c4                	jl     801dcc <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e08:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0e:	01 d0                	add    %edx,%eax
  801e10:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e13:	90                   	nop
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	e8 54 fa ff ff       	call   801878 <strlen>
  801e24:	83 c4 04             	add    $0x4,%esp
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e2a:	ff 75 0c             	pushl  0xc(%ebp)
  801e2d:	e8 46 fa ff ff       	call   801878 <strlen>
  801e32:	83 c4 04             	add    $0x4,%esp
  801e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e46:	eb 17                	jmp    801e5f <strcconcat+0x49>
		final[s] = str1[s] ;
  801e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4e:	01 c2                	add    %eax,%edx
  801e50:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	01 c8                	add    %ecx,%eax
  801e58:	8a 00                	mov    (%eax),%al
  801e5a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e5c:	ff 45 fc             	incl   -0x4(%ebp)
  801e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e65:	7c e1                	jl     801e48 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e6e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e75:	eb 1f                	jmp    801e96 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e7a:	8d 50 01             	lea    0x1(%eax),%edx
  801e7d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	8b 45 10             	mov    0x10(%ebp),%eax
  801e85:	01 c2                	add    %eax,%edx
  801e87:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	01 c8                	add    %ecx,%eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e93:	ff 45 f8             	incl   -0x8(%ebp)
  801e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e9c:	7c d9                	jl     801e77 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	c6 00 00             	movb   $0x0,(%eax)
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801eb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebb:	8b 00                	mov    (%eax),%eax
  801ebd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ec4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec7:	01 d0                	add    %edx,%eax
  801ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ecf:	eb 0c                	jmp    801edd <strsplit+0x31>
			*string++ = 0;
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	8d 50 01             	lea    0x1(%eax),%edx
  801ed7:	89 55 08             	mov    %edx,0x8(%ebp)
  801eda:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	8a 00                	mov    (%eax),%al
  801ee2:	84 c0                	test   %al,%al
  801ee4:	74 18                	je     801efe <strsplit+0x52>
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8a 00                	mov    (%eax),%al
  801eeb:	0f be c0             	movsbl %al,%eax
  801eee:	50                   	push   %eax
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	e8 13 fb ff ff       	call   801a0a <strchr>
  801ef7:	83 c4 08             	add    $0x8,%esp
  801efa:	85 c0                	test   %eax,%eax
  801efc:	75 d3                	jne    801ed1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	8a 00                	mov    (%eax),%al
  801f03:	84 c0                	test   %al,%al
  801f05:	74 5a                	je     801f61 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f07:	8b 45 14             	mov    0x14(%ebp),%eax
  801f0a:	8b 00                	mov    (%eax),%eax
  801f0c:	83 f8 0f             	cmp    $0xf,%eax
  801f0f:	75 07                	jne    801f18 <strsplit+0x6c>
		{
			return 0;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	eb 66                	jmp    801f7e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f18:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	8d 48 01             	lea    0x1(%eax),%ecx
  801f20:	8b 55 14             	mov    0x14(%ebp),%edx
  801f23:	89 0a                	mov    %ecx,(%edx)
  801f25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2f:	01 c2                	add    %eax,%edx
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f36:	eb 03                	jmp    801f3b <strsplit+0x8f>
			string++;
  801f38:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8a 00                	mov    (%eax),%al
  801f40:	84 c0                	test   %al,%al
  801f42:	74 8b                	je     801ecf <strsplit+0x23>
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	8a 00                	mov    (%eax),%al
  801f49:	0f be c0             	movsbl %al,%eax
  801f4c:	50                   	push   %eax
  801f4d:	ff 75 0c             	pushl  0xc(%ebp)
  801f50:	e8 b5 fa ff ff       	call   801a0a <strchr>
  801f55:	83 c4 08             	add    $0x8,%esp
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	74 dc                	je     801f38 <strsplit+0x8c>
			string++;
	}
  801f5c:	e9 6e ff ff ff       	jmp    801ecf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f61:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f62:	8b 45 14             	mov    0x14(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f71:	01 d0                	add    %edx,%eax
  801f73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f79:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801f86:	a1 28 40 80 00       	mov    0x804028,%eax
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	75 33                	jne    801fc2 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801f8f:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801f96:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801f99:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801fa0:	00 00 a0 
		spaces[0].pages = numPages;
  801fa3:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801faa:	00 02 00 
		spaces[0].isFree = 1;
  801fad:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801fb4:	00 00 00 
		arraySize++;
  801fb7:	a1 28 40 80 00       	mov    0x804028,%eax
  801fbc:	40                   	inc    %eax
  801fbd:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801fc2:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801fc9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801fd0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fdd:	01 d0                	add    %edx,%eax
  801fdf:	48                   	dec    %eax
  801fe0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe6:	ba 00 00 00 00       	mov    $0x0,%edx
  801feb:	f7 75 e8             	divl   -0x18(%ebp)
  801fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff1:	29 d0                	sub    %edx,%eax
  801ff3:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	c1 e8 0c             	shr    $0xc,%eax
  801ffc:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801fff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802006:	eb 57                	jmp    80205f <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  802008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200b:	c1 e0 04             	shl    $0x4,%eax
  80200e:	05 2c 41 80 00       	add    $0x80412c,%eax
  802013:	8b 00                	mov    (%eax),%eax
  802015:	85 c0                	test   %eax,%eax
  802017:	74 42                	je     80205b <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  802019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201c:	c1 e0 04             	shl    $0x4,%eax
  80201f:	05 28 41 80 00       	add    $0x804128,%eax
  802024:	8b 00                	mov    (%eax),%eax
  802026:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802029:	7c 31                	jl     80205c <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  80202b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202e:	c1 e0 04             	shl    $0x4,%eax
  802031:	05 28 41 80 00       	add    $0x804128,%eax
  802036:	8b 00                	mov    (%eax),%eax
  802038:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80203b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80203e:	7d 1c                	jge    80205c <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  802040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802043:	c1 e0 04             	shl    $0x4,%eax
  802046:	05 28 41 80 00       	add    $0x804128,%eax
  80204b:	8b 00                	mov    (%eax),%eax
  80204d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  802050:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  802053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802056:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802059:	eb 01                	jmp    80205c <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80205b:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  80205c:	ff 45 ec             	incl   -0x14(%ebp)
  80205f:	a1 28 40 80 00       	mov    0x804028,%eax
  802064:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802067:	7c 9f                	jl     802008 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  802069:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80206d:	75 0a                	jne    802079 <malloc+0xf9>
	{
		return NULL;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	e9 34 01 00 00       	jmp    8021ad <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	c1 e0 04             	shl    $0x4,%eax
  80207f:	05 28 41 80 00       	add    $0x804128,%eax
  802084:	8b 00                	mov    (%eax),%eax
  802086:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802089:	75 38                	jne    8020c3 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  80208b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208e:	c1 e0 04             	shl    $0x4,%eax
  802091:	05 2c 41 80 00       	add    $0x80412c,%eax
  802096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  80209c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209f:	c1 e0 0c             	shl    $0xc,%eax
  8020a2:	89 c2                	mov    %eax,%edx
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	c1 e0 04             	shl    $0x4,%eax
  8020aa:	05 20 41 80 00       	add    $0x804120,%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	83 ec 08             	sub    $0x8,%esp
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	e8 01 06 00 00       	call   8026bc <sys_allocateMem>
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	e9 dd 00 00 00       	jmp    8021a0 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8020c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c6:	c1 e0 04             	shl    $0x4,%eax
  8020c9:	05 20 41 80 00       	add    $0x804120,%eax
  8020ce:	8b 00                	mov    (%eax),%eax
  8020d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020d3:	c1 e2 0c             	shl    $0xc,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8020db:	a1 28 40 80 00       	mov    0x804028,%eax
  8020e0:	c1 e0 04             	shl    $0x4,%eax
  8020e3:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  8020e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020ec:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8020ee:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	c1 e0 04             	shl    $0x4,%eax
  8020fa:	05 24 41 80 00       	add    $0x804124,%eax
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	c1 e2 04             	shl    $0x4,%edx
  802104:	81 c2 24 41 80 00    	add    $0x804124,%edx
  80210a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  80210c:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802115:	c1 e0 04             	shl    $0x4,%eax
  802118:	05 28 41 80 00       	add    $0x804128,%eax
  80211d:	8b 00                	mov    (%eax),%eax
  80211f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  802122:	c1 e2 04             	shl    $0x4,%edx
  802125:	81 c2 28 41 80 00    	add    $0x804128,%edx
  80212b:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  80212d:	a1 28 40 80 00       	mov    0x804028,%eax
  802132:	c1 e0 04             	shl    $0x4,%eax
  802135:	05 2c 41 80 00       	add    $0x80412c,%eax
  80213a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  802140:	a1 28 40 80 00       	mov    0x804028,%eax
  802145:	40                   	inc    %eax
  802146:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	c1 e0 04             	shl    $0x4,%eax
  802151:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  802157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80215a:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  80215c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215f:	c1 e0 04             	shl    $0x4,%eax
  802162:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  802168:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216b:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  80216d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802170:	c1 e0 04             	shl    $0x4,%eax
  802173:	05 2c 41 80 00       	add    $0x80412c,%eax
  802178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  80217e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802181:	c1 e0 0c             	shl    $0xc,%eax
  802184:	89 c2                	mov    %eax,%edx
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	c1 e0 04             	shl    $0x4,%eax
  80218c:	05 20 41 80 00       	add    $0x804120,%eax
  802191:	8b 00                	mov    (%eax),%eax
  802193:	83 ec 08             	sub    $0x8,%esp
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	e8 1f 05 00 00       	call   8026bc <sys_allocateMem>
  80219d:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  8021a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a3:	c1 e0 04             	shl    $0x4,%eax
  8021a6:	05 20 41 80 00       	add    $0x804120,%eax
  8021ab:	8b 00                	mov    (%eax),%eax
	}


}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  8021b5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  8021bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  8021c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8021ca:	eb 3f                	jmp    80220b <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  8021cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cf:	c1 e0 04             	shl    $0x4,%eax
  8021d2:	05 20 41 80 00       	add    $0x804120,%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021dc:	75 2a                	jne    802208 <free+0x59>
		{
			index=i;
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  8021e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e7:	c1 e0 04             	shl    $0x4,%eax
  8021ea:	05 28 41 80 00       	add    $0x804128,%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	c1 e0 0c             	shl    $0xc,%eax
  8021f4:	89 c2                	mov    %eax,%edx
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	83 ec 08             	sub    $0x8,%esp
  8021fc:	52                   	push   %edx
  8021fd:	50                   	push   %eax
  8021fe:	e8 9d 04 00 00       	call   8026a0 <sys_freeMem>
  802203:	83 c4 10             	add    $0x10,%esp
			break;
  802206:	eb 0d                	jmp    802215 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  802208:	ff 45 ec             	incl   -0x14(%ebp)
  80220b:	a1 28 40 80 00       	mov    0x804028,%eax
  802210:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802213:	7c b7                	jl     8021cc <free+0x1d>
			break;
		}

	}

	if(index == -1)
  802215:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802219:	75 17                	jne    802232 <free+0x83>
	{
		panic("Error");
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	68 b0 34 80 00       	push   $0x8034b0
  802223:	68 81 00 00 00       	push   $0x81
  802228:	68 b6 34 80 00       	push   $0x8034b6
  80222d:	e8 22 ed ff ff       	call   800f54 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  802232:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802239:	e9 cc 00 00 00       	jmp    80230a <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80223e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802241:	c1 e0 04             	shl    $0x4,%eax
  802244:	05 2c 41 80 00       	add    $0x80412c,%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	0f 84 b3 00 00 00    	je     802306 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	c1 e0 04             	shl    $0x4,%eax
  802259:	05 20 41 80 00       	add    $0x804120,%eax
  80225e:	8b 10                	mov    (%eax),%edx
  802260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802263:	c1 e0 04             	shl    $0x4,%eax
  802266:	05 24 41 80 00       	add    $0x804124,%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	39 c2                	cmp    %eax,%edx
  80226f:	0f 85 92 00 00 00    	jne    802307 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	c1 e0 04             	shl    $0x4,%eax
  80227b:	05 24 41 80 00       	add    $0x804124,%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802285:	c1 e2 04             	shl    $0x4,%edx
  802288:	81 c2 24 41 80 00    	add    $0x804124,%edx
  80228e:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  802290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802293:	c1 e0 04             	shl    $0x4,%eax
  802296:	05 28 41 80 00       	add    $0x804128,%eax
  80229b:	8b 10                	mov    (%eax),%edx
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	c1 e0 04             	shl    $0x4,%eax
  8022a3:	05 28 41 80 00       	add    $0x804128,%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	01 c2                	add    %eax,%edx
  8022ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022af:	c1 e0 04             	shl    $0x4,%eax
  8022b2:	05 28 41 80 00       	add    $0x804128,%eax
  8022b7:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	c1 e0 04             	shl    $0x4,%eax
  8022bf:	05 20 41 80 00       	add    $0x804120,%eax
  8022c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	c1 e0 04             	shl    $0x4,%eax
  8022d0:	05 24 41 80 00       	add    $0x804124,%eax
  8022d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	c1 e0 04             	shl    $0x4,%eax
  8022e1:	05 28 41 80 00       	add    $0x804128,%eax
  8022e6:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	c1 e0 04             	shl    $0x4,%eax
  8022f2:	05 2c 41 80 00       	add    $0x80412c,%eax
  8022f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8022fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  802304:	eb 12                	jmp    802318 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  802306:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  802307:	ff 45 e8             	incl   -0x18(%ebp)
  80230a:	a1 28 40 80 00       	mov    0x804028,%eax
  80230f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  802312:	0f 8c 26 ff ff ff    	jl     80223e <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  802318:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80231f:	e9 cc 00 00 00       	jmp    8023f0 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  802324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802327:	c1 e0 04             	shl    $0x4,%eax
  80232a:	05 2c 41 80 00       	add    $0x80412c,%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	85 c0                	test   %eax,%eax
  802333:	0f 84 b3 00 00 00    	je     8023ec <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	c1 e0 04             	shl    $0x4,%eax
  80233f:	05 24 41 80 00       	add    $0x804124,%eax
  802344:	8b 10                	mov    (%eax),%edx
  802346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802349:	c1 e0 04             	shl    $0x4,%eax
  80234c:	05 20 41 80 00       	add    $0x804120,%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	39 c2                	cmp    %eax,%edx
  802355:	0f 85 92 00 00 00    	jne    8023ed <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	c1 e0 04             	shl    $0x4,%eax
  802361:	05 20 41 80 00       	add    $0x804120,%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80236b:	c1 e2 04             	shl    $0x4,%edx
  80236e:	81 c2 20 41 80 00    	add    $0x804120,%edx
  802374:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  802376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802379:	c1 e0 04             	shl    $0x4,%eax
  80237c:	05 28 41 80 00       	add    $0x804128,%eax
  802381:	8b 10                	mov    (%eax),%edx
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	c1 e0 04             	shl    $0x4,%eax
  802389:	05 28 41 80 00       	add    $0x804128,%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	01 c2                	add    %eax,%edx
  802392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802395:	c1 e0 04             	shl    $0x4,%eax
  802398:	05 28 41 80 00       	add    $0x804128,%eax
  80239d:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	c1 e0 04             	shl    $0x4,%eax
  8023a5:	05 20 41 80 00       	add    $0x804120,%eax
  8023aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	c1 e0 04             	shl    $0x4,%eax
  8023b6:	05 24 41 80 00       	add    $0x804124,%eax
  8023bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	c1 e0 04             	shl    $0x4,%eax
  8023c7:	05 28 41 80 00       	add    $0x804128,%eax
  8023cc:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	c1 e0 04             	shl    $0x4,%eax
  8023d8:	05 2c 41 80 00       	add    $0x80412c,%eax
  8023dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8023e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8023ea:	eb 12                	jmp    8023fe <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8023ec:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8023ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8023f0:	a1 28 40 80 00       	mov    0x804028,%eax
  8023f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f8:	0f 8c 26 ff ff ff    	jl     802324 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  8023fe:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  802402:	75 11                	jne    802415 <free+0x266>
	{
		spaces[index].isFree = 1;
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	c1 e0 04             	shl    $0x4,%eax
  80240a:	05 2c 41 80 00       	add    $0x80412c,%eax
  80240f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  802415:	90                   	nop
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 18             	sub    $0x18,%esp
  80241e:	8b 45 10             	mov    0x10(%ebp),%eax
  802421:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	68 c4 34 80 00       	push   $0x8034c4
  80242c:	68 b9 00 00 00       	push   $0xb9
  802431:	68 b6 34 80 00       	push   $0x8034b6
  802436:	e8 19 eb ff ff       	call   800f54 <_panic>

0080243b <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 c4 34 80 00       	push   $0x8034c4
  802449:	68 bf 00 00 00       	push   $0xbf
  80244e:	68 b6 34 80 00       	push   $0x8034b6
  802453:	e8 fc ea ff ff       	call   800f54 <_panic>

00802458 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 c4 34 80 00       	push   $0x8034c4
  802466:	68 c5 00 00 00       	push   $0xc5
  80246b:	68 b6 34 80 00       	push   $0x8034b6
  802470:	e8 df ea ff ff       	call   800f54 <_panic>

00802475 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	68 c4 34 80 00       	push   $0x8034c4
  802483:	68 ca 00 00 00       	push   $0xca
  802488:	68 b6 34 80 00       	push   $0x8034b6
  80248d:	e8 c2 ea ff ff       	call   800f54 <_panic>

00802492 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 c4 34 80 00       	push   $0x8034c4
  8024a0:	68 d0 00 00 00       	push   $0xd0
  8024a5:	68 b6 34 80 00       	push   $0x8034b6
  8024aa:	e8 a5 ea ff ff       	call   800f54 <_panic>

008024af <shrink>:
}
void shrink(uint32 newSize)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 c4 34 80 00       	push   $0x8034c4
  8024bd:	68 d4 00 00 00       	push   $0xd4
  8024c2:	68 b6 34 80 00       	push   $0x8034b6
  8024c7:	e8 88 ea ff ff       	call   800f54 <_panic>

008024cc <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8024d2:	83 ec 04             	sub    $0x4,%esp
  8024d5:	68 c4 34 80 00       	push   $0x8034c4
  8024da:	68 d9 00 00 00       	push   $0xd9
  8024df:	68 b6 34 80 00       	push   $0x8034b6
  8024e4:	e8 6b ea ff ff       	call   800f54 <_panic>

008024e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	57                   	push   %edi
  8024ed:	56                   	push   %esi
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  802501:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802504:	cd 30                	int    $0x30
  802506:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802509:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    

00802514 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 04             	sub    $0x4,%esp
  80251a:	8b 45 10             	mov    0x10(%ebp),%eax
  80251d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802520:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	52                   	push   %edx
  80252c:	ff 75 0c             	pushl  0xc(%ebp)
  80252f:	50                   	push   %eax
  802530:	6a 00                	push   $0x0
  802532:	e8 b2 ff ff ff       	call   8024e9 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	90                   	nop
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_cgetc>:

int
sys_cgetc(void)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 01                	push   $0x1
  80254c:	e8 98 ff ff ff       	call   8024e9 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	50                   	push   %eax
  802565:	6a 05                	push   $0x5
  802567:	e8 7d ff ff ff       	call   8024e9 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 02                	push   $0x2
  802580:	e8 64 ff ff ff       	call   8024e9 <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 03                	push   $0x3
  802599:	e8 4b ff ff ff       	call   8024e9 <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 04                	push   $0x4
  8025b2:	e8 32 ff ff ff       	call   8024e9 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
}
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <sys_env_exit>:


void sys_env_exit(void)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 06                	push   $0x6
  8025cb:	e8 19 ff ff ff       	call   8024e9 <syscall>
  8025d0:	83 c4 18             	add    $0x18,%esp
}
  8025d3:	90                   	nop
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8025d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	52                   	push   %edx
  8025e6:	50                   	push   %eax
  8025e7:	6a 07                	push   $0x7
  8025e9:	e8 fb fe ff ff       	call   8024e9 <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	56                   	push   %esi
  8025f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8025f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8025fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802601:	8b 55 0c             	mov    0xc(%ebp),%edx
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	56                   	push   %esi
  802608:	53                   	push   %ebx
  802609:	51                   	push   %ecx
  80260a:	52                   	push   %edx
  80260b:	50                   	push   %eax
  80260c:	6a 08                	push   $0x8
  80260e:	e8 d6 fe ff ff       	call   8024e9 <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
}
  802616:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802619:	5b                   	pop    %ebx
  80261a:	5e                   	pop    %esi
  80261b:	5d                   	pop    %ebp
  80261c:	c3                   	ret    

0080261d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802620:	8b 55 0c             	mov    0xc(%ebp),%edx
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	52                   	push   %edx
  80262d:	50                   	push   %eax
  80262e:	6a 09                	push   $0x9
  802630:	e8 b4 fe ff ff       	call   8024e9 <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
}
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	ff 75 0c             	pushl  0xc(%ebp)
  802646:	ff 75 08             	pushl  0x8(%ebp)
  802649:	6a 0a                	push   $0xa
  80264b:	e8 99 fe ff ff       	call   8024e9 <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 0b                	push   $0xb
  802664:	e8 80 fe ff ff       	call   8024e9 <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 0c                	push   $0xc
  80267d:	e8 67 fe ff ff       	call   8024e9 <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 0d                	push   $0xd
  802696:	e8 4e fe ff ff       	call   8024e9 <syscall>
  80269b:	83 c4 18             	add    $0x18,%esp
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	ff 75 0c             	pushl  0xc(%ebp)
  8026ac:	ff 75 08             	pushl  0x8(%ebp)
  8026af:	6a 11                	push   $0x11
  8026b1:	e8 33 fe ff ff       	call   8024e9 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
	return;
  8026b9:	90                   	nop
}
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	ff 75 0c             	pushl  0xc(%ebp)
  8026c8:	ff 75 08             	pushl  0x8(%ebp)
  8026cb:	6a 12                	push   $0x12
  8026cd:	e8 17 fe ff ff       	call   8024e9 <syscall>
  8026d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d5:	90                   	nop
}
  8026d6:	c9                   	leave  
  8026d7:	c3                   	ret    

008026d8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 0e                	push   $0xe
  8026e7:	e8 fd fd ff ff       	call   8024e9 <syscall>
  8026ec:	83 c4 18             	add    $0x18,%esp
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	ff 75 08             	pushl  0x8(%ebp)
  8026ff:	6a 0f                	push   $0xf
  802701:	e8 e3 fd ff ff       	call   8024e9 <syscall>
  802706:	83 c4 18             	add    $0x18,%esp
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 10                	push   $0x10
  80271a:	e8 ca fd ff ff       	call   8024e9 <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
}
  802722:	90                   	nop
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 14                	push   $0x14
  802734:	e8 b0 fd ff ff       	call   8024e9 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	90                   	nop
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 15                	push   $0x15
  80274e:	e8 96 fd ff ff       	call   8024e9 <syscall>
  802753:	83 c4 18             	add    $0x18,%esp
}
  802756:	90                   	nop
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_cputc>:


void
sys_cputc(const char c)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 04             	sub    $0x4,%esp
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802765:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	50                   	push   %eax
  802772:	6a 16                	push   $0x16
  802774:	e8 70 fd ff ff       	call   8024e9 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
}
  80277c:	90                   	nop
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 17                	push   $0x17
  80278e:	e8 56 fd ff ff       	call   8024e9 <syscall>
  802793:	83 c4 18             	add    $0x18,%esp
}
  802796:	90                   	nop
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	ff 75 0c             	pushl  0xc(%ebp)
  8027a8:	50                   	push   %eax
  8027a9:	6a 18                	push   $0x18
  8027ab:	e8 39 fd ff ff       	call   8024e9 <syscall>
  8027b0:	83 c4 18             	add    $0x18,%esp
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8027b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	52                   	push   %edx
  8027c5:	50                   	push   %eax
  8027c6:	6a 1b                	push   $0x1b
  8027c8:	e8 1c fd ff ff       	call   8024e9 <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8027d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	52                   	push   %edx
  8027e2:	50                   	push   %eax
  8027e3:	6a 19                	push   $0x19
  8027e5:	e8 ff fc ff ff       	call   8024e9 <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
}
  8027ed:	90                   	nop
  8027ee:	c9                   	leave  
  8027ef:	c3                   	ret    

008027f0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8027f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	52                   	push   %edx
  802800:	50                   	push   %eax
  802801:	6a 1a                	push   $0x1a
  802803:	e8 e1 fc ff ff       	call   8024e9 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
}
  80280b:	90                   	nop
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	8b 45 10             	mov    0x10(%ebp),%eax
  802817:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80281a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80281d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	6a 00                	push   $0x0
  802826:	51                   	push   %ecx
  802827:	52                   	push   %edx
  802828:	ff 75 0c             	pushl  0xc(%ebp)
  80282b:	50                   	push   %eax
  80282c:	6a 1c                	push   $0x1c
  80282e:	e8 b6 fc ff ff       	call   8024e9 <syscall>
  802833:	83 c4 18             	add    $0x18,%esp
}
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80283b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	6a 00                	push   $0x0
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	52                   	push   %edx
  802848:	50                   	push   %eax
  802849:	6a 1d                	push   $0x1d
  80284b:	e8 99 fc ff ff       	call   8024e9 <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
}
  802853:	c9                   	leave  
  802854:	c3                   	ret    

00802855 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802858:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80285b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	51                   	push   %ecx
  802866:	52                   	push   %edx
  802867:	50                   	push   %eax
  802868:	6a 1e                	push   $0x1e
  80286a:	e8 7a fc ff ff       	call   8024e9 <syscall>
  80286f:	83 c4 18             	add    $0x18,%esp
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	52                   	push   %edx
  802884:	50                   	push   %eax
  802885:	6a 1f                	push   $0x1f
  802887:	e8 5d fc ff ff       	call   8024e9 <syscall>
  80288c:	83 c4 18             	add    $0x18,%esp
}
  80288f:	c9                   	leave  
  802890:	c3                   	ret    

00802891 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 20                	push   $0x20
  8028a0:	e8 44 fc ff ff       	call   8024e9 <syscall>
  8028a5:	83 c4 18             	add    $0x18,%esp
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	6a 00                	push   $0x0
  8028b2:	ff 75 14             	pushl  0x14(%ebp)
  8028b5:	ff 75 10             	pushl  0x10(%ebp)
  8028b8:	ff 75 0c             	pushl  0xc(%ebp)
  8028bb:	50                   	push   %eax
  8028bc:	6a 21                	push   $0x21
  8028be:	e8 26 fc ff ff       	call   8024e9 <syscall>
  8028c3:	83 c4 18             	add    $0x18,%esp
}
  8028c6:	c9                   	leave  
  8028c7:	c3                   	ret    

008028c8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	50                   	push   %eax
  8028d7:	6a 22                	push   $0x22
  8028d9:	e8 0b fc ff ff       	call   8024e9 <syscall>
  8028de:	83 c4 18             	add    $0x18,%esp
}
  8028e1:	90                   	nop
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    

008028e4 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	50                   	push   %eax
  8028f3:	6a 23                	push   $0x23
  8028f5:	e8 ef fb ff ff       	call   8024e9 <syscall>
  8028fa:	83 c4 18             	add    $0x18,%esp
}
  8028fd:	90                   	nop
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802906:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802909:	8d 50 04             	lea    0x4(%eax),%edx
  80290c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	52                   	push   %edx
  802916:	50                   	push   %eax
  802917:	6a 24                	push   $0x24
  802919:	e8 cb fb ff ff       	call   8024e9 <syscall>
  80291e:	83 c4 18             	add    $0x18,%esp
	return result;
  802921:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802924:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802927:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80292a:	89 01                	mov    %eax,(%ecx)
  80292c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	c9                   	leave  
  802933:	c2 04 00             	ret    $0x4

00802936 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	ff 75 10             	pushl  0x10(%ebp)
  802940:	ff 75 0c             	pushl  0xc(%ebp)
  802943:	ff 75 08             	pushl  0x8(%ebp)
  802946:	6a 13                	push   $0x13
  802948:	e8 9c fb ff ff       	call   8024e9 <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
	return ;
  802950:	90                   	nop
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <sys_rcr2>:
uint32 sys_rcr2()
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 25                	push   $0x25
  802962:	e8 82 fb ff ff       	call   8024e9 <syscall>
  802967:	83 c4 18             	add    $0x18,%esp
}
  80296a:	c9                   	leave  
  80296b:	c3                   	ret    

0080296c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802978:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	50                   	push   %eax
  802985:	6a 26                	push   $0x26
  802987:	e8 5d fb ff ff       	call   8024e9 <syscall>
  80298c:	83 c4 18             	add    $0x18,%esp
	return ;
  80298f:	90                   	nop
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <rsttst>:
void rsttst()
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 28                	push   $0x28
  8029a1:	e8 43 fb ff ff       	call   8024e9 <syscall>
  8029a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8029a9:	90                   	nop
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8029b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8029b8:	8b 55 18             	mov    0x18(%ebp),%edx
  8029bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029bf:	52                   	push   %edx
  8029c0:	50                   	push   %eax
  8029c1:	ff 75 10             	pushl  0x10(%ebp)
  8029c4:	ff 75 0c             	pushl  0xc(%ebp)
  8029c7:	ff 75 08             	pushl  0x8(%ebp)
  8029ca:	6a 27                	push   $0x27
  8029cc:	e8 18 fb ff ff       	call   8024e9 <syscall>
  8029d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d4:	90                   	nop
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <chktst>:
void chktst(uint32 n)
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	ff 75 08             	pushl  0x8(%ebp)
  8029e5:	6a 29                	push   $0x29
  8029e7:	e8 fd fa ff ff       	call   8024e9 <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ef:	90                   	nop
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <inctst>:

void inctst()
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 2a                	push   $0x2a
  802a01:	e8 e3 fa ff ff       	call   8024e9 <syscall>
  802a06:	83 c4 18             	add    $0x18,%esp
	return ;
  802a09:	90                   	nop
}
  802a0a:	c9                   	leave  
  802a0b:	c3                   	ret    

00802a0c <gettst>:
uint32 gettst()
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 2b                	push   $0x2b
  802a1b:	e8 c9 fa ff ff       	call   8024e9 <syscall>
  802a20:	83 c4 18             	add    $0x18,%esp
}
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    

00802a25 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
  802a28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 2c                	push   $0x2c
  802a37:	e8 ad fa ff ff       	call   8024e9 <syscall>
  802a3c:	83 c4 18             	add    $0x18,%esp
  802a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a42:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a46:	75 07                	jne    802a4f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a48:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4d:	eb 05                	jmp    802a54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 2c                	push   $0x2c
  802a68:	e8 7c fa ff ff       	call   8024e9 <syscall>
  802a6d:	83 c4 18             	add    $0x18,%esp
  802a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a73:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a77:	75 07                	jne    802a80 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a79:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7e:	eb 05                	jmp    802a85 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 00                	push   $0x0
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 2c                	push   $0x2c
  802a99:	e8 4b fa ff ff       	call   8024e9 <syscall>
  802a9e:	83 c4 18             	add    $0x18,%esp
  802aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802aa4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802aa8:	75 07                	jne    802ab1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  802aaf:	eb 05                	jmp    802ab6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 2c                	push   $0x2c
  802aca:	e8 1a fa ff ff       	call   8024e9 <syscall>
  802acf:	83 c4 18             	add    $0x18,%esp
  802ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ad5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ad9:	75 07                	jne    802ae2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802adb:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae0:	eb 05                	jmp    802ae7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802aec:	6a 00                	push   $0x0
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	ff 75 08             	pushl  0x8(%ebp)
  802af7:	6a 2d                	push   $0x2d
  802af9:	e8 eb f9 ff ff       	call   8024e9 <syscall>
  802afe:	83 c4 18             	add    $0x18,%esp
	return ;
  802b01:	90                   	nop
}
  802b02:	c9                   	leave  
  802b03:	c3                   	ret    

00802b04 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b04:	55                   	push   %ebp
  802b05:	89 e5                	mov    %esp,%ebp
  802b07:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b08:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	6a 00                	push   $0x0
  802b16:	53                   	push   %ebx
  802b17:	51                   	push   %ecx
  802b18:	52                   	push   %edx
  802b19:	50                   	push   %eax
  802b1a:	6a 2e                	push   $0x2e
  802b1c:	e8 c8 f9 ff ff       	call   8024e9 <syscall>
  802b21:	83 c4 18             	add    $0x18,%esp
}
  802b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b27:	c9                   	leave  
  802b28:	c3                   	ret    

00802b29 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	6a 00                	push   $0x0
  802b34:	6a 00                	push   $0x0
  802b36:	6a 00                	push   $0x0
  802b38:	52                   	push   %edx
  802b39:	50                   	push   %eax
  802b3a:	6a 2f                	push   $0x2f
  802b3c:	e8 a8 f9 ff ff       	call   8024e9 <syscall>
  802b41:	83 c4 18             	add    $0x18,%esp
}
  802b44:	c9                   	leave  
  802b45:	c3                   	ret    
  802b46:	66 90                	xchg   %ax,%ax

00802b48 <__udivdi3>:
  802b48:	55                   	push   %ebp
  802b49:	57                   	push   %edi
  802b4a:	56                   	push   %esi
  802b4b:	53                   	push   %ebx
  802b4c:	83 ec 1c             	sub    $0x1c,%esp
  802b4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802b53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b5f:	89 ca                	mov    %ecx,%edx
  802b61:	89 f8                	mov    %edi,%eax
  802b63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802b67:	85 f6                	test   %esi,%esi
  802b69:	75 2d                	jne    802b98 <__udivdi3+0x50>
  802b6b:	39 cf                	cmp    %ecx,%edi
  802b6d:	77 65                	ja     802bd4 <__udivdi3+0x8c>
  802b6f:	89 fd                	mov    %edi,%ebp
  802b71:	85 ff                	test   %edi,%edi
  802b73:	75 0b                	jne    802b80 <__udivdi3+0x38>
  802b75:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7a:	31 d2                	xor    %edx,%edx
  802b7c:	f7 f7                	div    %edi
  802b7e:	89 c5                	mov    %eax,%ebp
  802b80:	31 d2                	xor    %edx,%edx
  802b82:	89 c8                	mov    %ecx,%eax
  802b84:	f7 f5                	div    %ebp
  802b86:	89 c1                	mov    %eax,%ecx
  802b88:	89 d8                	mov    %ebx,%eax
  802b8a:	f7 f5                	div    %ebp
  802b8c:	89 cf                	mov    %ecx,%edi
  802b8e:	89 fa                	mov    %edi,%edx
  802b90:	83 c4 1c             	add    $0x1c,%esp
  802b93:	5b                   	pop    %ebx
  802b94:	5e                   	pop    %esi
  802b95:	5f                   	pop    %edi
  802b96:	5d                   	pop    %ebp
  802b97:	c3                   	ret    
  802b98:	39 ce                	cmp    %ecx,%esi
  802b9a:	77 28                	ja     802bc4 <__udivdi3+0x7c>
  802b9c:	0f bd fe             	bsr    %esi,%edi
  802b9f:	83 f7 1f             	xor    $0x1f,%edi
  802ba2:	75 40                	jne    802be4 <__udivdi3+0x9c>
  802ba4:	39 ce                	cmp    %ecx,%esi
  802ba6:	72 0a                	jb     802bb2 <__udivdi3+0x6a>
  802ba8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802bac:	0f 87 9e 00 00 00    	ja     802c50 <__udivdi3+0x108>
  802bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb7:	89 fa                	mov    %edi,%edx
  802bb9:	83 c4 1c             	add    $0x1c,%esp
  802bbc:	5b                   	pop    %ebx
  802bbd:	5e                   	pop    %esi
  802bbe:	5f                   	pop    %edi
  802bbf:	5d                   	pop    %ebp
  802bc0:	c3                   	ret    
  802bc1:	8d 76 00             	lea    0x0(%esi),%esi
  802bc4:	31 ff                	xor    %edi,%edi
  802bc6:	31 c0                	xor    %eax,%eax
  802bc8:	89 fa                	mov    %edi,%edx
  802bca:	83 c4 1c             	add    $0x1c,%esp
  802bcd:	5b                   	pop    %ebx
  802bce:	5e                   	pop    %esi
  802bcf:	5f                   	pop    %edi
  802bd0:	5d                   	pop    %ebp
  802bd1:	c3                   	ret    
  802bd2:	66 90                	xchg   %ax,%ax
  802bd4:	89 d8                	mov    %ebx,%eax
  802bd6:	f7 f7                	div    %edi
  802bd8:	31 ff                	xor    %edi,%edi
  802bda:	89 fa                	mov    %edi,%edx
  802bdc:	83 c4 1c             	add    $0x1c,%esp
  802bdf:	5b                   	pop    %ebx
  802be0:	5e                   	pop    %esi
  802be1:	5f                   	pop    %edi
  802be2:	5d                   	pop    %ebp
  802be3:	c3                   	ret    
  802be4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802be9:	89 eb                	mov    %ebp,%ebx
  802beb:	29 fb                	sub    %edi,%ebx
  802bed:	89 f9                	mov    %edi,%ecx
  802bef:	d3 e6                	shl    %cl,%esi
  802bf1:	89 c5                	mov    %eax,%ebp
  802bf3:	88 d9                	mov    %bl,%cl
  802bf5:	d3 ed                	shr    %cl,%ebp
  802bf7:	89 e9                	mov    %ebp,%ecx
  802bf9:	09 f1                	or     %esi,%ecx
  802bfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802bff:	89 f9                	mov    %edi,%ecx
  802c01:	d3 e0                	shl    %cl,%eax
  802c03:	89 c5                	mov    %eax,%ebp
  802c05:	89 d6                	mov    %edx,%esi
  802c07:	88 d9                	mov    %bl,%cl
  802c09:	d3 ee                	shr    %cl,%esi
  802c0b:	89 f9                	mov    %edi,%ecx
  802c0d:	d3 e2                	shl    %cl,%edx
  802c0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c13:	88 d9                	mov    %bl,%cl
  802c15:	d3 e8                	shr    %cl,%eax
  802c17:	09 c2                	or     %eax,%edx
  802c19:	89 d0                	mov    %edx,%eax
  802c1b:	89 f2                	mov    %esi,%edx
  802c1d:	f7 74 24 0c          	divl   0xc(%esp)
  802c21:	89 d6                	mov    %edx,%esi
  802c23:	89 c3                	mov    %eax,%ebx
  802c25:	f7 e5                	mul    %ebp
  802c27:	39 d6                	cmp    %edx,%esi
  802c29:	72 19                	jb     802c44 <__udivdi3+0xfc>
  802c2b:	74 0b                	je     802c38 <__udivdi3+0xf0>
  802c2d:	89 d8                	mov    %ebx,%eax
  802c2f:	31 ff                	xor    %edi,%edi
  802c31:	e9 58 ff ff ff       	jmp    802b8e <__udivdi3+0x46>
  802c36:	66 90                	xchg   %ax,%ax
  802c38:	8b 54 24 08          	mov    0x8(%esp),%edx
  802c3c:	89 f9                	mov    %edi,%ecx
  802c3e:	d3 e2                	shl    %cl,%edx
  802c40:	39 c2                	cmp    %eax,%edx
  802c42:	73 e9                	jae    802c2d <__udivdi3+0xe5>
  802c44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802c47:	31 ff                	xor    %edi,%edi
  802c49:	e9 40 ff ff ff       	jmp    802b8e <__udivdi3+0x46>
  802c4e:	66 90                	xchg   %ax,%ax
  802c50:	31 c0                	xor    %eax,%eax
  802c52:	e9 37 ff ff ff       	jmp    802b8e <__udivdi3+0x46>
  802c57:	90                   	nop

00802c58 <__umoddi3>:
  802c58:	55                   	push   %ebp
  802c59:	57                   	push   %edi
  802c5a:	56                   	push   %esi
  802c5b:	53                   	push   %ebx
  802c5c:	83 ec 1c             	sub    $0x1c,%esp
  802c5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802c63:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802c6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802c6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c77:	89 f3                	mov    %esi,%ebx
  802c79:	89 fa                	mov    %edi,%edx
  802c7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c7f:	89 34 24             	mov    %esi,(%esp)
  802c82:	85 c0                	test   %eax,%eax
  802c84:	75 1a                	jne    802ca0 <__umoddi3+0x48>
  802c86:	39 f7                	cmp    %esi,%edi
  802c88:	0f 86 a2 00 00 00    	jbe    802d30 <__umoddi3+0xd8>
  802c8e:	89 c8                	mov    %ecx,%eax
  802c90:	89 f2                	mov    %esi,%edx
  802c92:	f7 f7                	div    %edi
  802c94:	89 d0                	mov    %edx,%eax
  802c96:	31 d2                	xor    %edx,%edx
  802c98:	83 c4 1c             	add    $0x1c,%esp
  802c9b:	5b                   	pop    %ebx
  802c9c:	5e                   	pop    %esi
  802c9d:	5f                   	pop    %edi
  802c9e:	5d                   	pop    %ebp
  802c9f:	c3                   	ret    
  802ca0:	39 f0                	cmp    %esi,%eax
  802ca2:	0f 87 ac 00 00 00    	ja     802d54 <__umoddi3+0xfc>
  802ca8:	0f bd e8             	bsr    %eax,%ebp
  802cab:	83 f5 1f             	xor    $0x1f,%ebp
  802cae:	0f 84 ac 00 00 00    	je     802d60 <__umoddi3+0x108>
  802cb4:	bf 20 00 00 00       	mov    $0x20,%edi
  802cb9:	29 ef                	sub    %ebp,%edi
  802cbb:	89 fe                	mov    %edi,%esi
  802cbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cc1:	89 e9                	mov    %ebp,%ecx
  802cc3:	d3 e0                	shl    %cl,%eax
  802cc5:	89 d7                	mov    %edx,%edi
  802cc7:	89 f1                	mov    %esi,%ecx
  802cc9:	d3 ef                	shr    %cl,%edi
  802ccb:	09 c7                	or     %eax,%edi
  802ccd:	89 e9                	mov    %ebp,%ecx
  802ccf:	d3 e2                	shl    %cl,%edx
  802cd1:	89 14 24             	mov    %edx,(%esp)
  802cd4:	89 d8                	mov    %ebx,%eax
  802cd6:	d3 e0                	shl    %cl,%eax
  802cd8:	89 c2                	mov    %eax,%edx
  802cda:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cde:	d3 e0                	shl    %cl,%eax
  802ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ce8:	89 f1                	mov    %esi,%ecx
  802cea:	d3 e8                	shr    %cl,%eax
  802cec:	09 d0                	or     %edx,%eax
  802cee:	d3 eb                	shr    %cl,%ebx
  802cf0:	89 da                	mov    %ebx,%edx
  802cf2:	f7 f7                	div    %edi
  802cf4:	89 d3                	mov    %edx,%ebx
  802cf6:	f7 24 24             	mull   (%esp)
  802cf9:	89 c6                	mov    %eax,%esi
  802cfb:	89 d1                	mov    %edx,%ecx
  802cfd:	39 d3                	cmp    %edx,%ebx
  802cff:	0f 82 87 00 00 00    	jb     802d8c <__umoddi3+0x134>
  802d05:	0f 84 91 00 00 00    	je     802d9c <__umoddi3+0x144>
  802d0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802d0f:	29 f2                	sub    %esi,%edx
  802d11:	19 cb                	sbb    %ecx,%ebx
  802d13:	89 d8                	mov    %ebx,%eax
  802d15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802d19:	d3 e0                	shl    %cl,%eax
  802d1b:	89 e9                	mov    %ebp,%ecx
  802d1d:	d3 ea                	shr    %cl,%edx
  802d1f:	09 d0                	or     %edx,%eax
  802d21:	89 e9                	mov    %ebp,%ecx
  802d23:	d3 eb                	shr    %cl,%ebx
  802d25:	89 da                	mov    %ebx,%edx
  802d27:	83 c4 1c             	add    $0x1c,%esp
  802d2a:	5b                   	pop    %ebx
  802d2b:	5e                   	pop    %esi
  802d2c:	5f                   	pop    %edi
  802d2d:	5d                   	pop    %ebp
  802d2e:	c3                   	ret    
  802d2f:	90                   	nop
  802d30:	89 fd                	mov    %edi,%ebp
  802d32:	85 ff                	test   %edi,%edi
  802d34:	75 0b                	jne    802d41 <__umoddi3+0xe9>
  802d36:	b8 01 00 00 00       	mov    $0x1,%eax
  802d3b:	31 d2                	xor    %edx,%edx
  802d3d:	f7 f7                	div    %edi
  802d3f:	89 c5                	mov    %eax,%ebp
  802d41:	89 f0                	mov    %esi,%eax
  802d43:	31 d2                	xor    %edx,%edx
  802d45:	f7 f5                	div    %ebp
  802d47:	89 c8                	mov    %ecx,%eax
  802d49:	f7 f5                	div    %ebp
  802d4b:	89 d0                	mov    %edx,%eax
  802d4d:	e9 44 ff ff ff       	jmp    802c96 <__umoddi3+0x3e>
  802d52:	66 90                	xchg   %ax,%ax
  802d54:	89 c8                	mov    %ecx,%eax
  802d56:	89 f2                	mov    %esi,%edx
  802d58:	83 c4 1c             	add    $0x1c,%esp
  802d5b:	5b                   	pop    %ebx
  802d5c:	5e                   	pop    %esi
  802d5d:	5f                   	pop    %edi
  802d5e:	5d                   	pop    %ebp
  802d5f:	c3                   	ret    
  802d60:	3b 04 24             	cmp    (%esp),%eax
  802d63:	72 06                	jb     802d6b <__umoddi3+0x113>
  802d65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802d69:	77 0f                	ja     802d7a <__umoddi3+0x122>
  802d6b:	89 f2                	mov    %esi,%edx
  802d6d:	29 f9                	sub    %edi,%ecx
  802d6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802d73:	89 14 24             	mov    %edx,(%esp)
  802d76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d7e:	8b 14 24             	mov    (%esp),%edx
  802d81:	83 c4 1c             	add    $0x1c,%esp
  802d84:	5b                   	pop    %ebx
  802d85:	5e                   	pop    %esi
  802d86:	5f                   	pop    %edi
  802d87:	5d                   	pop    %ebp
  802d88:	c3                   	ret    
  802d89:	8d 76 00             	lea    0x0(%esi),%esi
  802d8c:	2b 04 24             	sub    (%esp),%eax
  802d8f:	19 fa                	sbb    %edi,%edx
  802d91:	89 d1                	mov    %edx,%ecx
  802d93:	89 c6                	mov    %eax,%esi
  802d95:	e9 71 ff ff ff       	jmp    802d0b <__umoddi3+0xb3>
  802d9a:	66 90                	xchg   %ax,%ax
  802d9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802da0:	72 ea                	jb     802d8c <__umoddi3+0x134>
  802da2:	89 d9                	mov    %ebx,%ecx
  802da4:	e9 62 ff ff ff       	jmp    802d0b <__umoddi3+0xb3>
