
obj/user/tst_mod_10:     file format elf32-i386


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
  800031:	e8 f7 0b 00 00       	call   800c2d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern void expand(uint32 newSize) ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 00 01 00 00    	sub    $0x100,%esp
	int Mega = 1024*1024;
  800043:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80004a:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)


	char minByte = 1<<7;
  800051:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  800073:	e8 fb 23 00 00       	call   802473 <sys_calculate_free_frames>
  800078:	89 45 cc             	mov    %eax,-0x34(%ebp)

	//malloc some spaces
	int i, freeFrames, usedDiskPages ;
	char* ptr;
	int lastIndices[20] = {0};
  80007b:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800081:	b9 14 00 00 00       	mov    $0x14,%ecx
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	89 d7                	mov    %edx,%edi
  80008d:	f3 ab                	rep stos %eax,%es:(%edi)

	uint32 *arr;
	int expectedNumOfFrames = 0;
  80008f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 lastAddr = 0;
  800096:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80009d:	8d 95 fc fe ff ff    	lea    -0x104(%ebp),%edx
  8000a3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	89 d7                	mov    %edx,%edi
  8000af:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  8000b1:	e8 bd 23 00 00       	call   802473 <sys_calculate_free_frames>
  8000b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000b9:	e8 38 24 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8000be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8000c9:	83 ec 0c             	sub    $0xc,%esp
  8000cc:	50                   	push   %eax
  8000cd:	e8 cc 1c 00 00       	call   801d9e <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8000db:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  8000e1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000e6:	74 14                	je     8000fc <_main+0xc4>
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	68 e0 2b 80 00       	push   $0x802be0
  8000f0:	6a 28                	push   $0x28
  8000f2:	68 45 2c 80 00       	push   $0x802c45
  8000f7:	e8 76 0c 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512 ) panic("Extra or less pages are allocated in PageFile");
  8000fc:	e8 f5 23 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800101:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800104:	3d 00 02 00 00       	cmp    $0x200,%eax
  800109:	74 14                	je     80011f <_main+0xe7>
  80010b:	83 ec 04             	sub    $0x4,%esp
  80010e:	68 58 2c 80 00       	push   $0x802c58
  800113:	6a 29                	push   $0x29
  800115:	68 45 2c 80 00       	push   $0x802c45
  80011a:	e8 53 0c 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80011f:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  800122:	e8 4c 23 00 00       	call   802473 <sys_calculate_free_frames>
  800127:	29 c3                	sub    %eax,%ebx
  800129:	89 d8                	mov    %ebx,%eax
  80012b:	83 f8 01             	cmp    $0x1,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 88 2c 80 00       	push   $0x802c88
  800138:	6a 2a                	push   $0x2a
  80013a:	68 45 2c 80 00       	push   $0x802c45
  80013f:	e8 2e 0c 00 00       	call   800d72 <_panic>
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800147:	01 c0                	add    %eax,%eax
  800149:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80014c:	48                   	dec    %eax
  80014d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800153:	e8 1b 23 00 00       	call   802473 <sys_calculate_free_frames>
  800158:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015b:	e8 96 23 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800160:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800166:	01 c0                	add    %eax,%eax
  800168:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	50                   	push   %eax
  80016f:	e8 2a 1c 00 00       	call   801d9e <malloc>
  800174:	83 c4 10             	add    $0x10,%esp
  800177:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80017d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  800183:	89 c2                	mov    %eax,%edx
  800185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800188:	01 c0                	add    %eax,%eax
  80018a:	05 00 00 00 80       	add    $0x80000000,%eax
  80018f:	39 c2                	cmp    %eax,%edx
  800191:	74 14                	je     8001a7 <_main+0x16f>
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	68 e0 2b 80 00       	push   $0x802be0
  80019b:	6a 31                	push   $0x31
  80019d:	68 45 2c 80 00       	push   $0x802c45
  8001a2:	e8 cb 0b 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512 ) panic("Extra or less pages are allocated in PageFile");
  8001a7:	e8 4a 23 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8001ac:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8001af:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001b4:	74 14                	je     8001ca <_main+0x192>
  8001b6:	83 ec 04             	sub    $0x4,%esp
  8001b9:	68 58 2c 80 00       	push   $0x802c58
  8001be:	6a 32                	push   $0x32
  8001c0:	68 45 2c 80 00       	push   $0x802c45
  8001c5:	e8 a8 0b 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001ca:	e8 a4 22 00 00       	call   802473 <sys_calculate_free_frames>
  8001cf:	89 c2                	mov    %eax,%edx
  8001d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001d4:	39 c2                	cmp    %eax,%edx
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 88 2c 80 00       	push   $0x802c88
  8001e0:	6a 33                	push   $0x33
  8001e2:	68 45 2c 80 00       	push   $0x802c45
  8001e7:	e8 86 0b 00 00       	call   800d72 <_panic>
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ef:	01 c0                	add    %eax,%eax
  8001f1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001f4:	48                   	dec    %eax
  8001f5:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001fb:	e8 73 22 00 00       	call   802473 <sys_calculate_free_frames>
  800200:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800203:	e8 ee 22 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800208:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80020b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020e:	01 c0                	add    %eax,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 85 1b 00 00       	call   801d9e <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800222:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022d:	c1 e0 02             	shl    $0x2,%eax
  800230:	05 00 00 00 80       	add    $0x80000000,%eax
  800235:	39 c2                	cmp    %eax,%edx
  800237:	74 14                	je     80024d <_main+0x215>
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	68 e0 2b 80 00       	push   $0x802be0
  800241:	6a 3a                	push   $0x3a
  800243:	68 45 2c 80 00       	push   $0x802c45
  800248:	e8 25 0b 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1 ) panic("Extra or less pages are allocated in PageFile");
  80024d:	e8 a4 22 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800252:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800255:	83 f8 01             	cmp    $0x1,%eax
  800258:	74 14                	je     80026e <_main+0x236>
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	68 58 2c 80 00       	push   $0x802c58
  800262:	6a 3b                	push   $0x3b
  800264:	68 45 2c 80 00       	push   $0x802c45
  800269:	e8 04 0b 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026e:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  800271:	e8 fd 21 00 00       	call   802473 <sys_calculate_free_frames>
  800276:	29 c3                	sub    %eax,%ebx
  800278:	89 d8                	mov    %ebx,%eax
  80027a:	83 f8 01             	cmp    $0x1,%eax
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 88 2c 80 00       	push   $0x802c88
  800287:	6a 3c                	push   $0x3c
  800289:	68 45 2c 80 00       	push   $0x802c45
  80028e:	e8 df 0a 00 00       	call   800d72 <_panic>
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  800293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800296:	01 c0                	add    %eax,%eax
  800298:	48                   	dec    %eax
  800299:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		ptr = (char*)ptr_allocations[2];
  80029f:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8002a5:	89 45 c0             	mov    %eax,-0x40(%ebp)
		for (i = 0; i < lastIndices[2]; ++i)
  8002a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002af:	eb 0e                	jmp    8002bf <_main+0x287>
		{
			ptr[i] = 2 ;
  8002b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002b7:	01 d0                	add    %edx,%eax
  8002b9:	c6 00 02             	movb   $0x2,(%eax)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1 ) panic("Extra or less pages are allocated in PageFile");
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
		ptr = (char*)ptr_allocations[2];
		for (i = 0; i < lastIndices[2]; ++i)
  8002bc:	ff 45 f4             	incl   -0xc(%ebp)
  8002bf:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8002c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8002c8:	7f e7                	jg     8002b1 <_main+0x279>
		{
			ptr[i] = 2 ;
		}

		cprintf("1/9\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 f2 2c 80 00       	push   $0x802cf2
  8002d2:	e8 3d 0d 00 00       	call   801014 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8002da:	e8 94 21 00 00       	call   802473 <sys_calculate_free_frames>
  8002df:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e2:	e8 0f 22 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8002e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	01 c0                	add    %eax,%eax
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	50                   	push   %eax
  8002f3:	e8 a6 1a 00 00       	call   801d9e <malloc>
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800301:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800307:	89 c2                	mov    %eax,%edx
  800309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80030c:	c1 e0 02             	shl    $0x2,%eax
  80030f:	89 c1                	mov    %eax,%ecx
  800311:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800314:	c1 e0 02             	shl    $0x2,%eax
  800317:	01 c8                	add    %ecx,%eax
  800319:	05 00 00 00 80       	add    $0x80000000,%eax
  80031e:	39 c2                	cmp    %eax,%edx
  800320:	74 14                	je     800336 <_main+0x2fe>
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	68 e0 2b 80 00       	push   $0x802be0
  80032a:	6a 49                	push   $0x49
  80032c:	68 45 2c 80 00       	push   $0x802c45
  800331:	e8 3c 0a 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1 ) panic("Extra or less pages are allocated in PageFile");
  800336:	e8 bb 21 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  80033b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80033e:	83 f8 01             	cmp    $0x1,%eax
  800341:	74 14                	je     800357 <_main+0x31f>
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	68 58 2c 80 00       	push   $0x802c58
  80034b:	6a 4a                	push   $0x4a
  80034d:	68 45 2c 80 00       	push   $0x802c45
  800352:	e8 1b 0a 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800357:	e8 17 21 00 00       	call   802473 <sys_calculate_free_frames>
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800361:	39 c2                	cmp    %eax,%edx
  800363:	74 14                	je     800379 <_main+0x341>
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	68 88 2c 80 00       	push   $0x802c88
  80036d:	6a 4b                	push   $0x4b
  80036f:	68 45 2c 80 00       	push   $0x802c45
  800374:	e8 f9 09 00 00       	call   800d72 <_panic>
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  800379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	48                   	dec    %eax
  80037f:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		ptr = (char*)ptr_allocations[3];
  800385:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80038b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		for (i = 0; i < lastIndices[3]; ++i)
  80038e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800395:	eb 0e                	jmp    8003a5 <_main+0x36d>
		{
			ptr[i] = 3 ;
  800397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80039a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c6 00 03             	movb   $0x3,(%eax)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1 ) panic("Extra or less pages are allocated in PageFile");
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
		ptr = (char*)ptr_allocations[3];
		for (i = 0; i < lastIndices[3]; ++i)
  8003a2:	ff 45 f4             	incl   -0xc(%ebp)
  8003a5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8003ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8003ae:	7f e7                	jg     800397 <_main+0x35f>
		{
			ptr[i] = 3 ;
		}

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8003b0:	e8 be 20 00 00       	call   802473 <sys_calculate_free_frames>
  8003b5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003b8:	e8 39 21 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8003bd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8003c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c3:	89 d0                	mov    %edx,%eax
  8003c5:	01 c0                	add    %eax,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	01 c0                	add    %eax,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 c8 19 00 00       	call   801d9e <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8003df:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8003e5:	89 c2                	mov    %eax,%edx
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	c1 e0 02             	shl    $0x2,%eax
  8003ed:	89 c1                	mov    %eax,%ecx
  8003ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f2:	c1 e0 03             	shl    $0x3,%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	05 00 00 00 80       	add    $0x80000000,%eax
  8003fc:	39 c2                	cmp    %eax,%edx
  8003fe:	74 14                	je     800414 <_main+0x3dc>
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	68 e0 2b 80 00       	push   $0x802be0
  800408:	6a 57                	push   $0x57
  80040a:	68 45 2c 80 00       	push   $0x802c45
  80040f:	e8 5e 09 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2 ) panic("Extra or less pages are allocated in PageFile");
  800414:	e8 dd 20 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800419:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80041c:	83 f8 02             	cmp    $0x2,%eax
  80041f:	74 14                	je     800435 <_main+0x3fd>
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	68 58 2c 80 00       	push   $0x802c58
  800429:	6a 58                	push   $0x58
  80042b:	68 45 2c 80 00       	push   $0x802c45
  800430:	e8 3d 09 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800435:	e8 39 20 00 00       	call   802473 <sys_calculate_free_frames>
  80043a:	89 c2                	mov    %eax,%edx
  80043c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 88 2c 80 00       	push   $0x802c88
  80044b:	6a 59                	push   $0x59
  80044d:	68 45 2c 80 00       	push   $0x802c45
  800452:	e8 1b 09 00 00       	call   800d72 <_panic>
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800457:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045a:	89 d0                	mov    %edx,%eax
  80045c:	01 c0                	add    %eax,%eax
  80045e:	01 d0                	add    %edx,%eax
  800460:	01 c0                	add    %eax,%eax
  800462:	01 d0                	add    %edx,%eax
  800464:	48                   	dec    %eax
  800465:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		ptr = (char*)ptr_allocations[4];
  80046b:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  800471:	89 45 c0             	mov    %eax,-0x40(%ebp)
		for (i = 0; i < lastIndices[4]; ++i)
  800474:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80047b:	eb 0e                	jmp    80048b <_main+0x453>
		{
			ptr[i] = 4 ;
  80047d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800480:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800483:	01 d0                	add    %edx,%eax
  800485:	c6 00 04             	movb   $0x4,(%eax)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2 ) panic("Extra or less pages are allocated in PageFile");
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
		ptr = (char*)ptr_allocations[4];
		for (i = 0; i < lastIndices[4]; ++i)
  800488:	ff 45 f4             	incl   -0xc(%ebp)
  80048b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800491:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800494:	7f e7                	jg     80047d <_main+0x445>
		{
			ptr[i] = 4 ;
		}

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800496:	e8 d8 1f 00 00       	call   802473 <sys_calculate_free_frames>
  80049b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80049e:	e8 53 20 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8004a3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8004a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a9:	89 c2                	mov    %eax,%edx
  8004ab:	01 d2                	add    %edx,%edx
  8004ad:	01 d0                	add    %edx,%eax
  8004af:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	50                   	push   %eax
  8004b6:	e8 e3 18 00 00       	call   801d9e <malloc>
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo) ) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004c4:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004cf:	c1 e0 02             	shl    $0x2,%eax
  8004d2:	89 c1                	mov    %eax,%ecx
  8004d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d7:	c1 e0 04             	shl    $0x4,%eax
  8004da:	01 c8                	add    %ecx,%eax
  8004dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8004e1:	39 c2                	cmp    %eax,%edx
  8004e3:	74 14                	je     8004f9 <_main+0x4c1>
  8004e5:	83 ec 04             	sub    $0x4,%esp
  8004e8:	68 e0 2b 80 00       	push   $0x802be0
  8004ed:	6a 65                	push   $0x65
  8004ef:	68 45 2c 80 00       	push   $0x802c45
  8004f4:	e8 79 08 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768 ) panic("Extra or less pages are allocated in PageFile");
  8004f9:	e8 f8 1f 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8004fe:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800501:	3d 00 03 00 00       	cmp    $0x300,%eax
  800506:	74 14                	je     80051c <_main+0x4e4>
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	68 58 2c 80 00       	push   $0x802c58
  800510:	6a 66                	push   $0x66
  800512:	68 45 2c 80 00       	push   $0x802c45
  800517:	e8 56 08 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80051c:	e8 52 1f 00 00       	call   802473 <sys_calculate_free_frames>
  800521:	89 c2                	mov    %eax,%edx
  800523:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800526:	39 c2                	cmp    %eax,%edx
  800528:	74 14                	je     80053e <_main+0x506>
  80052a:	83 ec 04             	sub    $0x4,%esp
  80052d:	68 88 2c 80 00       	push   $0x802c88
  800532:	6a 67                	push   $0x67
  800534:	68 45 2c 80 00       	push   $0x802c45
  800539:	e8 34 08 00 00       	call   800d72 <_panic>
		lastIndices[5] = (3*Mega-kilo)/sizeof(char) - 1;
  80053e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800541:	89 c2                	mov    %eax,%edx
  800543:	01 d2                	add    %edx,%edx
  800545:	01 d0                	add    %edx,%eax
  800547:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80054a:	48                   	dec    %eax
  80054b:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		ptr = (char*)ptr_allocations[5];
  800551:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800557:	89 45 c0             	mov    %eax,-0x40(%ebp)
		for (i = 0; i < lastIndices[5]; i+=PAGE_SIZE)
  80055a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800561:	eb 12                	jmp    800575 <_main+0x53d>
		{
			ptr[i] = 5 ;
  800563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800566:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800569:	01 d0                	add    %edx,%eax
  80056b:	c6 00 05             	movb   $0x5,(%eax)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo) ) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768 ) panic("Extra or less pages are allocated in PageFile");
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
		lastIndices[5] = (3*Mega-kilo)/sizeof(char) - 1;
		ptr = (char*)ptr_allocations[5];
		for (i = 0; i < lastIndices[5]; i+=PAGE_SIZE)
  80056e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800575:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80057b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057e:	7f e3                	jg     800563 <_main+0x52b>
		{
			ptr[i] = 5 ;
		}
		cprintf("2/9\n");
  800580:	83 ec 0c             	sub    $0xc,%esp
  800583:	68 f7 2c 80 00       	push   $0x802cf7
  800588:	e8 87 0a 00 00       	call   801014 <cprintf>
  80058d:	83 c4 10             	add    $0x10,%esp
		//6 MB
		freeFrames = sys_calculate_free_frames() ;
  800590:	e8 de 1e 00 00       	call   802473 <sys_calculate_free_frames>
  800595:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800598:	e8 59 1f 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  80059d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega);
  8005a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005a3:	89 d0                	mov    %edx,%eax
  8005a5:	01 c0                	add    %eax,%eax
  8005a7:	01 d0                	add    %edx,%eax
  8005a9:	01 c0                	add    %eax,%eax
  8005ab:	83 ec 0c             	sub    $0xc,%esp
  8005ae:	50                   	push   %eax
  8005af:	e8 ea 17 00 00       	call   801d9e <malloc>
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005bd:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8005c3:	89 c1                	mov    %eax,%ecx
  8005c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005c8:	89 d0                	mov    %edx,%eax
  8005ca:	01 c0                	add    %eax,%eax
  8005cc:	01 d0                	add    %edx,%eax
  8005ce:	01 c0                	add    %eax,%eax
  8005d0:	01 d0                	add    %edx,%eax
  8005d2:	89 c2                	mov    %eax,%edx
  8005d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d7:	c1 e0 04             	shl    $0x4,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8005e1:	39 c1                	cmp    %eax,%ecx
  8005e3:	74 14                	je     8005f9 <_main+0x5c1>
  8005e5:	83 ec 04             	sub    $0x4,%esp
  8005e8:	68 e0 2b 80 00       	push   $0x802be0
  8005ed:	6a 73                	push   $0x73
  8005ef:	68 45 2c 80 00       	push   $0x802c45
  8005f4:	e8 79 07 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1536 ) panic("Extra or less pages are allocated in PageFile");
  8005f9:	e8 f8 1e 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8005fe:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800601:	3d 00 06 00 00       	cmp    $0x600,%eax
  800606:	74 14                	je     80061c <_main+0x5e4>
  800608:	83 ec 04             	sub    $0x4,%esp
  80060b:	68 58 2c 80 00       	push   $0x802c58
  800610:	6a 74                	push   $0x74
  800612:	68 45 2c 80 00       	push   $0x802c45
  800617:	e8 56 07 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80061c:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  80061f:	e8 4f 1e 00 00       	call   802473 <sys_calculate_free_frames>
  800624:	29 c3                	sub    %eax,%ebx
  800626:	89 d8                	mov    %ebx,%eax
  800628:	83 f8 02             	cmp    $0x2,%eax
  80062b:	74 14                	je     800641 <_main+0x609>
  80062d:	83 ec 04             	sub    $0x4,%esp
  800630:	68 88 2c 80 00       	push   $0x802c88
  800635:	6a 75                	push   $0x75
  800637:	68 45 2c 80 00       	push   $0x802c45
  80063c:	e8 31 07 00 00       	call   800d72 <_panic>
		lastIndices[6] = (6*Mega)/sizeof(uint32) - 1;
  800641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800644:	89 d0                	mov    %edx,%eax
  800646:	01 c0                	add    %eax,%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	01 c0                	add    %eax,%eax
  80064c:	c1 e8 02             	shr    $0x2,%eax
  80064f:	48                   	dec    %eax
  800650:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		arr = (uint32*)ptr_allocations[6];
  800656:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80065c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		uint32 lastAddr = 0 ;
  80065f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  800666:	e8 08 1e 00 00       	call   802473 <sys_calculate_free_frames>
  80066b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		lastAddr = 0;
  80066e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (i = 0; i <= lastIndices[6]; i+=PAGE_SIZE)
  800675:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80067c:	eb 5a                	jmp    8006d8 <_main+0x6a0>
		{
			arr[i] = i ;
  80067e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800681:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800688:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80068b:	01 c2                	add    %eax,%edx
  80068d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800690:	89 02                	mov    %eax,(%edx)
			if (ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) != lastAddr)
  800692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800695:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80069f:	01 d0                	add    %edx,%eax
  8006a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8006a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8006a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006ac:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8006af:	74 20                	je     8006d1 <_main+0x699>
			{
				expectedNumOfFrames++ ;
  8006b1:	ff 45 f0             	incl   -0x10(%ebp)
				lastAddr = ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) ;
  8006b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8006c6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
		lastIndices[6] = (6*Mega)/sizeof(uint32) - 1;
		arr = (uint32*)ptr_allocations[6];
		uint32 lastAddr = 0 ;
		freeFrames = sys_calculate_free_frames() ;
		lastAddr = 0;
		for (i = 0; i <= lastIndices[6]; i+=PAGE_SIZE)
  8006d1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8006d8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8006e1:	7d 9b                	jge    80067e <_main+0x646>
			{
				expectedNumOfFrames++ ;
				lastAddr = ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) ;
			}
		}
		cprintf("3/9\n");
  8006e3:	83 ec 0c             	sub    $0xc,%esp
  8006e6:	68 fc 2c 80 00       	push   $0x802cfc
  8006eb:	e8 24 09 00 00       	call   801014 <cprintf>
  8006f0:	83 c4 10             	add    $0x10,%esp
	}

	//Expand last allocated variable to 7 MB instead of 6 MB
	int newLastIndex = (7*Mega)/sizeof(uint32) - 1;
  8006f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f6:	89 d0                	mov    %edx,%eax
  8006f8:	01 c0                	add    %eax,%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	01 c0                	add    %eax,%eax
  8006fe:	01 d0                	add    %edx,%eax
  800700:	c1 e8 02             	shr    $0x2,%eax
  800703:	48                   	dec    %eax
  800704:	89 45 b0             	mov    %eax,-0x50(%ebp)
	{
		freeFrames = sys_calculate_free_frames() ;
  800707:	e8 67 1d 00 00       	call   802473 <sys_calculate_free_frames>
  80070c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80070f:	e8 e2 1d 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800714:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		expand(7*Mega) ;
  800717:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80071a:	89 d0                	mov    %edx,%eax
  80071c:	01 c0                	add    %eax,%eax
  80071e:	01 d0                	add    %edx,%eax
  800720:	01 c0                	add    %eax,%eax
  800722:	01 d0                	add    %edx,%eax
  800724:	83 ec 0c             	sub    $0xc,%esp
  800727:	50                   	push   %eax
  800728:	e8 83 1b 00 00       	call   8022b0 <expand>
  80072d:	83 c4 10             	add    $0x10,%esp

		assert(sys_pf_calculate_allocated_pages() - usedDiskPages == 256) ;
  800730:	e8 c1 1d 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800735:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800738:	3d 00 01 00 00       	cmp    $0x100,%eax
  80073d:	74 19                	je     800758 <_main+0x720>
  80073f:	68 04 2d 80 00       	push   $0x802d04
  800744:	68 3e 2d 80 00       	push   $0x802d3e
  800749:	68 8f 00 00 00       	push   $0x8f
  80074e:	68 45 2c 80 00       	push   $0x802c45
  800753:	e8 1a 06 00 00       	call   800d72 <_panic>
		assert(freeFrames - sys_calculate_free_frames() == 0) ;
  800758:	e8 16 1d 00 00       	call   802473 <sys_calculate_free_frames>
  80075d:	89 c2                	mov    %eax,%edx
  80075f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800762:	39 c2                	cmp    %eax,%edx
  800764:	74 19                	je     80077f <_main+0x747>
  800766:	68 54 2d 80 00       	push   $0x802d54
  80076b:	68 3e 2d 80 00       	push   $0x802d3e
  800770:	68 90 00 00 00       	push   $0x90
  800775:	68 45 2c 80 00       	push   $0x802c45
  80077a:	e8 f3 05 00 00       	call   800d72 <_panic>

		lastAddr = 0;
  80077f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
  800786:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80078f:	eb 5a                	jmp    8007eb <_main+0x7b3>
		{
			arr[i] = i ;
  800791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800794:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80079e:	01 c2                	add    %eax,%edx
  8007a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a3:	89 02                	mov    %eax,(%edx)
			if (ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) != lastAddr)
  8007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007af:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007b2:	01 d0                	add    %edx,%eax
  8007b4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8007b7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8007ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8007c2:	74 20                	je     8007e4 <_main+0x7ac>
			{
				expectedNumOfFrames++ ;
  8007c4:	ff 45 f0             	incl   -0x10(%ebp)
				lastAddr = ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) ;
  8007c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007d4:	01 d0                	add    %edx,%eax
  8007d6:	89 45 a8             	mov    %eax,-0x58(%ebp)
  8007d9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8007dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

		assert(sys_pf_calculate_allocated_pages() - usedDiskPages == 256) ;
		assert(freeFrames - sys_calculate_free_frames() == 0) ;

		lastAddr = 0;
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
  8007e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ee:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8007f1:	7c 9e                	jl     800791 <_main+0x759>
				expectedNumOfFrames++ ;
				lastAddr = ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) ;
			}
		}
	}
	cprintf("4/9\n");
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	68 82 2d 80 00       	push   $0x802d82
  8007fb:	e8 14 08 00 00       	call   801014 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	//Access elements after expansion
	{
		for (i = 0; i < lastIndices[6] ; i+=PAGE_SIZE)
  800803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80080a:	eb 38                	jmp    800844 <_main+0x80c>
		{
			assert(arr[i] ==i);
  80080c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80080f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800816:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800819:	01 d0                	add    %edx,%eax
  80081b:	8b 10                	mov    (%eax),%edx
  80081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800820:	39 c2                	cmp    %eax,%edx
  800822:	74 19                	je     80083d <_main+0x805>
  800824:	68 87 2d 80 00       	push   $0x802d87
  800829:	68 3e 2d 80 00       	push   $0x802d3e
  80082e:	68 a2 00 00 00       	push   $0xa2
  800833:	68 45 2c 80 00       	push   $0x802c45
  800838:	e8 35 05 00 00       	call   800d72 <_panic>
		}
	}
	cprintf("4/9\n");
	//Access elements after expansion
	{
		for (i = 0; i < lastIndices[6] ; i+=PAGE_SIZE)
  80083d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800844:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80084a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80084d:	7f bd                	jg     80080c <_main+0x7d4>
		{
			assert(arr[i] ==i);
		}
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
  80084f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800858:	eb 1b                	jmp    800875 <_main+0x83d>
		{
			arr[i] = i ;
  80085a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800864:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800867:	01 c2                	add    %eax,%edx
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	89 02                	mov    %eax,(%edx)
	{
		for (i = 0; i < lastIndices[6] ; i+=PAGE_SIZE)
		{
			assert(arr[i] ==i);
		}
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
  80086e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800878:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  80087b:	7c dd                	jl     80085a <_main+0x822>
		{
			arr[i] = i ;
		}

	}
	cprintf("5/9\n");
  80087d:	83 ec 0c             	sub    $0xc,%esp
  800880:	68 92 2d 80 00       	push   $0x802d92
  800885:	e8 8a 07 00 00       	call   801014 <cprintf>
  80088a:	83 c4 10             	add    $0x10,%esp
	//Expand it again to 10 MB instead of 7 MB
	int newLastIndex2 = (10*Mega)/sizeof(uint32) - 1;
  80088d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800890:	89 d0                	mov    %edx,%eax
  800892:	c1 e0 02             	shl    $0x2,%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	01 c0                	add    %eax,%eax
  800899:	c1 e8 02             	shr    $0x2,%eax
  80089c:	48                   	dec    %eax
  80089d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	{
		freeFrames = sys_calculate_free_frames() ;
  8008a0:	e8 ce 1b 00 00       	call   802473 <sys_calculate_free_frames>
  8008a5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008a8:	e8 49 1c 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8008ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		expand(10*Mega) ;
  8008b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008b3:	89 d0                	mov    %edx,%eax
  8008b5:	c1 e0 02             	shl    $0x2,%eax
  8008b8:	01 d0                	add    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	83 ec 0c             	sub    $0xc,%esp
  8008bf:	50                   	push   %eax
  8008c0:	e8 eb 19 00 00       	call   8022b0 <expand>
  8008c5:	83 c4 10             	add    $0x10,%esp

		assert(sys_pf_calculate_allocated_pages() - usedDiskPages == 768) ;
  8008c8:	e8 29 1c 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  8008cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008d0:	3d 00 03 00 00       	cmp    $0x300,%eax
  8008d5:	74 19                	je     8008f0 <_main+0x8b8>
  8008d7:	68 98 2d 80 00       	push   $0x802d98
  8008dc:	68 3e 2d 80 00       	push   $0x802d3e
  8008e1:	68 b3 00 00 00       	push   $0xb3
  8008e6:	68 45 2c 80 00       	push   $0x802c45
  8008eb:	e8 82 04 00 00       	call   800d72 <_panic>
		assert(freeFrames - sys_calculate_free_frames() == 1) ;
  8008f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8008f3:	e8 7b 1b 00 00       	call   802473 <sys_calculate_free_frames>
  8008f8:	29 c3                	sub    %eax,%ebx
  8008fa:	89 d8                	mov    %ebx,%eax
  8008fc:	83 f8 01             	cmp    $0x1,%eax
  8008ff:	74 19                	je     80091a <_main+0x8e2>
  800901:	68 d4 2d 80 00       	push   $0x802dd4
  800906:	68 3e 2d 80 00       	push   $0x802d3e
  80090b:	68 b4 00 00 00       	push   $0xb4
  800910:	68 45 2c 80 00       	push   $0x802c45
  800915:	e8 58 04 00 00       	call   800d72 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80091a:	e8 54 1b 00 00       	call   802473 <sys_calculate_free_frames>
  80091f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		lastAddr = 0;
  800922:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (i = newLastIndex; i < newLastIndex2 ; i+=PAGE_SIZE)
  800929:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80092c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80092f:	eb 5a                	jmp    80098b <_main+0x953>
		{
			arr[i] = i ;
  800931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800934:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80093b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093e:	01 c2                	add    %eax,%edx
  800940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800943:	89 02                	mov    %eax,(%edx)
			if (ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) != lastAddr)
  800945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800948:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80094f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800952:	01 d0                	add    %edx,%eax
  800954:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800957:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80095a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80095f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800962:	74 20                	je     800984 <_main+0x94c>
			{
				expectedNumOfFrames++ ;
  800964:	ff 45 f0             	incl   -0x10(%ebp)
				lastAddr = ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) ;
  800967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80096a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800971:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800974:	01 d0                	add    %edx,%eax
  800976:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800979:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80097c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800981:	89 45 ec             	mov    %eax,-0x14(%ebp)
		assert(sys_pf_calculate_allocated_pages() - usedDiskPages == 768) ;
		assert(freeFrames - sys_calculate_free_frames() == 1) ;

		freeFrames = sys_calculate_free_frames() ;
		lastAddr = 0;
		for (i = newLastIndex; i < newLastIndex2 ; i+=PAGE_SIZE)
  800984:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  800991:	7c 9e                	jl     800931 <_main+0x8f9>
				expectedNumOfFrames++ ;
				lastAddr = ROUNDDOWN((uint32)(&(arr[i])), PAGE_SIZE) ;
			}
		}
	}
	cprintf("6/9\n");
  800993:	83 ec 0c             	sub    $0xc,%esp
  800996:	68 02 2e 80 00       	push   $0x802e02
  80099b:	e8 74 06 00 00       	call   801014 <cprintf>
  8009a0:	83 c4 10             	add    $0x10,%esp
	//Access elements after expansion
	{
		for (i = 0; i < lastIndices[6] ; i+=PAGE_SIZE)
  8009a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8009aa:	eb 38                	jmp    8009e4 <_main+0x9ac>
		{
			assert(arr[i] ==i);
  8009ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	8b 10                	mov    (%eax),%edx
  8009bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c0:	39 c2                	cmp    %eax,%edx
  8009c2:	74 19                	je     8009dd <_main+0x9a5>
  8009c4:	68 87 2d 80 00       	push   $0x802d87
  8009c9:	68 3e 2d 80 00       	push   $0x802d3e
  8009ce:	68 c7 00 00 00       	push   $0xc7
  8009d3:	68 45 2c 80 00       	push   $0x802c45
  8009d8:	e8 95 03 00 00       	call   800d72 <_panic>
		}
	}
	cprintf("6/9\n");
	//Access elements after expansion
	{
		for (i = 0; i < lastIndices[6] ; i+=PAGE_SIZE)
  8009dd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8009e4:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009ed:	7f bd                	jg     8009ac <_main+0x974>
		{
			assert(arr[i] ==i);
		}
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
  8009ef:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8009f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009f8:	eb 38                	jmp    800a32 <_main+0x9fa>
		{
			assert(arr[i] ==i);
  8009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a04:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800a07:	01 d0                	add    %edx,%eax
  800a09:	8b 10                	mov    (%eax),%edx
  800a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0e:	39 c2                	cmp    %eax,%edx
  800a10:	74 19                	je     800a2b <_main+0x9f3>
  800a12:	68 87 2d 80 00       	push   $0x802d87
  800a17:	68 3e 2d 80 00       	push   $0x802d3e
  800a1c:	68 cb 00 00 00       	push   $0xcb
  800a21:	68 45 2c 80 00       	push   $0x802c45
  800a26:	e8 47 03 00 00       	call   800d72 <_panic>
	{
		for (i = 0; i < lastIndices[6] ; i+=PAGE_SIZE)
		{
			assert(arr[i] ==i);
		}
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
  800a2b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a35:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  800a38:	7c c0                	jl     8009fa <_main+0x9c2>
		{
			assert(arr[i] ==i);
		}
		for (i = newLastIndex ; i < newLastIndex2 ; i+=PAGE_SIZE)
  800a3a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a40:	eb 38                	jmp    800a7a <_main+0xa42>
		{
			assert(arr[i] ==i);
  800a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a4c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800a4f:	01 d0                	add    %edx,%eax
  800a51:	8b 10                	mov    (%eax),%edx
  800a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a56:	39 c2                	cmp    %eax,%edx
  800a58:	74 19                	je     800a73 <_main+0xa3b>
  800a5a:	68 87 2d 80 00       	push   $0x802d87
  800a5f:	68 3e 2d 80 00       	push   $0x802d3e
  800a64:	68 cf 00 00 00       	push   $0xcf
  800a69:	68 45 2c 80 00       	push   $0x802c45
  800a6e:	e8 ff 02 00 00       	call   800d72 <_panic>
		}
		for (i = lastIndices[6]; i < newLastIndex ; i+=PAGE_SIZE)
		{
			assert(arr[i] ==i);
		}
		for (i = newLastIndex ; i < newLastIndex2 ; i+=PAGE_SIZE)
  800a73:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  800a80:	7c c0                	jl     800a42 <_main+0xa0a>
		{
			assert(arr[i] ==i);
		}
	}
	cprintf("7/9\n");
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	68 07 2e 80 00       	push   $0x802e07
  800a8a:	e8 85 05 00 00       	call   801014 <cprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	//Allocate after expanding last var
	{
		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800a92:	e8 dc 19 00 00       	call   802473 <sys_calculate_free_frames>
  800a97:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a9a:	e8 57 1a 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800a9f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(4*Mega);
  800aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aa5:	c1 e0 02             	shl    $0x2,%eax
  800aa8:	83 ec 0c             	sub    $0xc,%esp
  800aab:	50                   	push   %eax
  800aac:	e8 ed 12 00 00       	call   801d9e <malloc>
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 7*Mega + 16*kilo + 10*Mega)) panic("Wrong start address after expand()... ");
  800aba:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800ac0:	89 c1                	mov    %eax,%ecx
  800ac2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac5:	89 d0                	mov    %edx,%eax
  800ac7:	01 c0                	add    %eax,%eax
  800ac9:	01 d0                	add    %edx,%eax
  800acb:	01 c0                	add    %eax,%eax
  800acd:	01 d0                	add    %edx,%eax
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad4:	c1 e0 04             	shl    $0x4,%eax
  800ad7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800ada:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800add:	89 d0                	mov    %edx,%eax
  800adf:	c1 e0 02             	shl    $0x2,%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d8                	add    %ebx,%eax
  800ae8:	05 00 00 00 80       	add    $0x80000000,%eax
  800aed:	39 c1                	cmp    %eax,%ecx
  800aef:	74 17                	je     800b08 <_main+0xad0>
  800af1:	83 ec 04             	sub    $0x4,%esp
  800af4:	68 0c 2e 80 00       	push   $0x802e0c
  800af9:	68 d9 00 00 00       	push   $0xd9
  800afe:	68 45 2c 80 00       	push   $0x802c45
  800b03:	e8 6a 02 00 00       	call   800d72 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4*Mega/PAGE_SIZE ) panic("Extra or less pages are allocated in PageFile");
  800b08:	e8 e9 19 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800b0d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800b10:	89 c2                	mov    %eax,%edx
  800b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b15:	c1 e0 02             	shl    $0x2,%eax
  800b18:	85 c0                	test   %eax,%eax
  800b1a:	79 05                	jns    800b21 <_main+0xae9>
  800b1c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800b21:	c1 f8 0c             	sar    $0xc,%eax
  800b24:	39 c2                	cmp    %eax,%edx
  800b26:	74 17                	je     800b3f <_main+0xb07>
  800b28:	83 ec 04             	sub    $0x4,%esp
  800b2b:	68 58 2c 80 00       	push   $0x802c58
  800b30:	68 da 00 00 00       	push   $0xda
  800b35:	68 45 2c 80 00       	push   $0x802c45
  800b3a:	e8 33 02 00 00       	call   800d72 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b3f:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  800b42:	e8 2c 19 00 00       	call   802473 <sys_calculate_free_frames>
  800b47:	29 c3                	sub    %eax,%ebx
  800b49:	89 d8                	mov    %ebx,%eax
  800b4b:	83 f8 01             	cmp    $0x1,%eax
  800b4e:	74 17                	je     800b67 <_main+0xb2f>
  800b50:	83 ec 04             	sub    $0x4,%esp
  800b53:	68 88 2c 80 00       	push   $0x802c88
  800b58:	68 db 00 00 00       	push   $0xdb
  800b5d:	68 45 2c 80 00       	push   $0x802c45
  800b62:	e8 0b 02 00 00       	call   800d72 <_panic>
	}
	cprintf("8/9\n");
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	68 33 2e 80 00       	push   $0x802e33
  800b6f:	e8 a0 04 00 00       	call   801014 <cprintf>
  800b74:	83 c4 10             	add    $0x10,%esp
	//free the expanded variable
	{
		//kfree 10 MB (expanded)
		freeFrames = sys_calculate_free_frames() ;
  800b77:	e8 f7 18 00 00       	call   802473 <sys_calculate_free_frames>
  800b7c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b7f:	e8 72 19 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800b84:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		free(ptr_allocations[6]);
  800b87:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800b8d:	83 ec 0c             	sub    $0xc,%esp
  800b90:	50                   	push   %eax
  800b91:	e8 37 14 00 00       	call   801fcd <free>
  800b96:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*Mega/PAGE_SIZE) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800b99:	e8 58 19 00 00       	call   8024f6 <sys_pf_calculate_allocated_pages>
  800b9e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800ba1:	89 d1                	mov    %edx,%ecx
  800ba3:	29 c1                	sub    %eax,%ecx
  800ba5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ba8:	89 d0                	mov    %edx,%eax
  800baa:	c1 e0 02             	shl    $0x2,%eax
  800bad:	01 d0                	add    %edx,%eax
  800baf:	01 c0                	add    %eax,%eax
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	79 05                	jns    800bba <_main+0xb82>
  800bb5:	05 ff 0f 00 00       	add    $0xfff,%eax
  800bba:	c1 f8 0c             	sar    $0xc,%eax
  800bbd:	39 c1                	cmp    %eax,%ecx
  800bbf:	74 17                	je     800bd8 <_main+0xba0>
  800bc1:	83 ec 04             	sub    $0x4,%esp
  800bc4:	68 38 2e 80 00       	push   $0x802e38
  800bc9:	68 e4 00 00 00       	push   $0xe4
  800bce:	68 45 2c 80 00       	push   $0x802c45
  800bd3:	e8 9a 01 00 00       	call   800d72 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames + 3 /*tables*/) panic("Wrong kfree");
  800bd8:	e8 96 18 00 00       	call   802473 <sys_calculate_free_frames>
  800bdd:	89 c2                	mov    %eax,%edx
  800bdf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	83 c0 03             	add    $0x3,%eax
  800bea:	39 c2                	cmp    %eax,%edx
  800bec:	74 17                	je     800c05 <_main+0xbcd>
  800bee:	83 ec 04             	sub    $0x4,%esp
  800bf1:	68 a0 2e 80 00       	push   $0x802ea0
  800bf6:	68 e5 00 00 00       	push   $0xe5
  800bfb:	68 45 2c 80 00       	push   $0x802c45
  800c00:	e8 6d 01 00 00       	call   800d72 <_panic>
	}
	cprintf("9/9\n");
  800c05:	83 ec 0c             	sub    $0xc,%esp
  800c08:	68 ac 2e 80 00       	push   $0x802eac
  800c0d:	e8 02 04 00 00       	call   801014 <cprintf>
  800c12:	83 c4 10             	add    $0x10,%esp
	//
	//		assert(sys_pf_calculate_allocated_pages() - usedDiskPages == 5) ;
	//		assert(freeFrames - sys_calculate_free_frames()  == 0) ;
	//	}

	cprintf("\nCongratulations!! your modification is run successfully.\n");
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	68 b4 2e 80 00       	push   $0x802eb4
  800c1d:	e8 f2 03 00 00       	call   801014 <cprintf>
  800c22:	83 c4 10             	add    $0x10,%esp

	return;
  800c25:	90                   	nop
}
  800c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c29:	5b                   	pop    %ebx
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800c33:	e8 70 17 00 00       	call   8023a8 <sys_getenvindex>
  800c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3e:	89 d0                	mov    %edx,%eax
  800c40:	c1 e0 03             	shl    $0x3,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800c4c:	01 c8                	add    %ecx,%eax
  800c4e:	01 c0                	add    %eax,%eax
  800c50:	01 d0                	add    %edx,%eax
  800c52:	01 c0                	add    %eax,%eax
  800c54:	01 d0                	add    %edx,%eax
  800c56:	89 c2                	mov    %eax,%edx
  800c58:	c1 e2 05             	shl    $0x5,%edx
  800c5b:	29 c2                	sub    %eax,%edx
  800c5d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800c6c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c71:	a1 20 40 80 00       	mov    0x804020,%eax
  800c76:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800c7c:	84 c0                	test   %al,%al
  800c7e:	74 0f                	je     800c8f <libmain+0x62>
		binaryname = myEnv->prog_name;
  800c80:	a1 20 40 80 00       	mov    0x804020,%eax
  800c85:	05 40 3c 01 00       	add    $0x13c40,%eax
  800c8a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c93:	7e 0a                	jle    800c9f <libmain+0x72>
		binaryname = argv[0];
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	ff 75 08             	pushl  0x8(%ebp)
  800ca8:	e8 8b f3 ff ff       	call   800038 <_main>
  800cad:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800cb0:	e8 8e 18 00 00       	call   802543 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800cb5:	83 ec 0c             	sub    $0xc,%esp
  800cb8:	68 08 2f 80 00       	push   $0x802f08
  800cbd:	e8 52 03 00 00       	call   801014 <cprintf>
  800cc2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800cc5:	a1 20 40 80 00       	mov    0x804020,%eax
  800cca:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800cd0:	a1 20 40 80 00       	mov    0x804020,%eax
  800cd5:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800cdb:	83 ec 04             	sub    $0x4,%esp
  800cde:	52                   	push   %edx
  800cdf:	50                   	push   %eax
  800ce0:	68 30 2f 80 00       	push   $0x802f30
  800ce5:	e8 2a 03 00 00       	call   801014 <cprintf>
  800cea:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800ced:	a1 20 40 80 00       	mov    0x804020,%eax
  800cf2:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800cf8:	a1 20 40 80 00       	mov    0x804020,%eax
  800cfd:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800d03:	83 ec 04             	sub    $0x4,%esp
  800d06:	52                   	push   %edx
  800d07:	50                   	push   %eax
  800d08:	68 58 2f 80 00       	push   $0x802f58
  800d0d:	e8 02 03 00 00       	call   801014 <cprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d15:	a1 20 40 80 00       	mov    0x804020,%eax
  800d1a:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	50                   	push   %eax
  800d24:	68 99 2f 80 00       	push   $0x802f99
  800d29:	e8 e6 02 00 00       	call   801014 <cprintf>
  800d2e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	68 08 2f 80 00       	push   $0x802f08
  800d39:	e8 d6 02 00 00       	call   801014 <cprintf>
  800d3e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800d41:	e8 17 18 00 00       	call   80255d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800d46:	e8 19 00 00 00       	call   800d64 <exit>
}
  800d4b:	90                   	nop
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	6a 00                	push   $0x0
  800d59:	e8 16 16 00 00       	call   802374 <sys_env_destroy>
  800d5e:	83 c4 10             	add    $0x10,%esp
}
  800d61:	90                   	nop
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <exit>:

void
exit(void)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800d6a:	e8 6b 16 00 00       	call   8023da <sys_env_exit>
}
  800d6f:	90                   	nop
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d78:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7b:	83 c0 04             	add    $0x4,%eax
  800d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d81:	a1 18 41 80 00       	mov    0x804118,%eax
  800d86:	85 c0                	test   %eax,%eax
  800d88:	74 16                	je     800da0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d8a:	a1 18 41 80 00       	mov    0x804118,%eax
  800d8f:	83 ec 08             	sub    $0x8,%esp
  800d92:	50                   	push   %eax
  800d93:	68 b0 2f 80 00       	push   $0x802fb0
  800d98:	e8 77 02 00 00       	call   801014 <cprintf>
  800d9d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800da0:	a1 00 40 80 00       	mov    0x804000,%eax
  800da5:	ff 75 0c             	pushl  0xc(%ebp)
  800da8:	ff 75 08             	pushl  0x8(%ebp)
  800dab:	50                   	push   %eax
  800dac:	68 b5 2f 80 00       	push   $0x802fb5
  800db1:	e8 5e 02 00 00       	call   801014 <cprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc2:	50                   	push   %eax
  800dc3:	e8 e1 01 00 00       	call   800fa9 <vcprintf>
  800dc8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	6a 00                	push   $0x0
  800dd0:	68 d1 2f 80 00       	push   $0x802fd1
  800dd5:	e8 cf 01 00 00       	call   800fa9 <vcprintf>
  800dda:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ddd:	e8 82 ff ff ff       	call   800d64 <exit>

	// should not return here
	while (1) ;
  800de2:	eb fe                	jmp    800de2 <_panic+0x70>

00800de4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800dea:	a1 20 40 80 00       	mov    0x804020,%eax
  800def:	8b 50 74             	mov    0x74(%eax),%edx
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	39 c2                	cmp    %eax,%edx
  800df7:	74 14                	je     800e0d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	68 d4 2f 80 00       	push   $0x802fd4
  800e01:	6a 26                	push   $0x26
  800e03:	68 20 30 80 00       	push   $0x803020
  800e08:	e8 65 ff ff ff       	call   800d72 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e1b:	e9 b6 00 00 00       	jmp    800ed6 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	85 c0                	test   %eax,%eax
  800e33:	75 08                	jne    800e3d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800e35:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800e38:	e9 96 00 00 00       	jmp    800ed3 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800e3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e4b:	eb 5d                	jmp    800eaa <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e4d:	a1 20 40 80 00       	mov    0x804020,%eax
  800e52:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e5b:	c1 e2 04             	shl    $0x4,%edx
  800e5e:	01 d0                	add    %edx,%eax
  800e60:	8a 40 04             	mov    0x4(%eax),%al
  800e63:	84 c0                	test   %al,%al
  800e65:	75 40                	jne    800ea7 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e67:	a1 20 40 80 00       	mov    0x804020,%eax
  800e6c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800e72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e75:	c1 e2 04             	shl    $0x4,%edx
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	8b 00                	mov    (%eax),%eax
  800e7c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e87:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	01 c8                	add    %ecx,%eax
  800e98:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e9a:	39 c2                	cmp    %eax,%edx
  800e9c:	75 09                	jne    800ea7 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800e9e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ea5:	eb 12                	jmp    800eb9 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ea7:	ff 45 e8             	incl   -0x18(%ebp)
  800eaa:	a1 20 40 80 00       	mov    0x804020,%eax
  800eaf:	8b 50 74             	mov    0x74(%eax),%edx
  800eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800eb5:	39 c2                	cmp    %eax,%edx
  800eb7:	77 94                	ja     800e4d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800eb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ebd:	75 14                	jne    800ed3 <CheckWSWithoutLastIndex+0xef>
			panic(
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	68 2c 30 80 00       	push   $0x80302c
  800ec7:	6a 3a                	push   $0x3a
  800ec9:	68 20 30 80 00       	push   $0x803020
  800ece:	e8 9f fe ff ff       	call   800d72 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ed3:	ff 45 f0             	incl   -0x10(%ebp)
  800ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800edc:	0f 8c 3e ff ff ff    	jl     800e20 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ee2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ee9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ef0:	eb 20                	jmp    800f12 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ef2:	a1 20 40 80 00       	mov    0x804020,%eax
  800ef7:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800efd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f00:	c1 e2 04             	shl    $0x4,%edx
  800f03:	01 d0                	add    %edx,%eax
  800f05:	8a 40 04             	mov    0x4(%eax),%al
  800f08:	3c 01                	cmp    $0x1,%al
  800f0a:	75 03                	jne    800f0f <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800f0c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f0f:	ff 45 e0             	incl   -0x20(%ebp)
  800f12:	a1 20 40 80 00       	mov    0x804020,%eax
  800f17:	8b 50 74             	mov    0x74(%eax),%edx
  800f1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1d:	39 c2                	cmp    %eax,%edx
  800f1f:	77 d1                	ja     800ef2 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f24:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800f27:	74 14                	je     800f3d <CheckWSWithoutLastIndex+0x159>
		panic(
  800f29:	83 ec 04             	sub    $0x4,%esp
  800f2c:	68 80 30 80 00       	push   $0x803080
  800f31:	6a 44                	push   $0x44
  800f33:	68 20 30 80 00       	push   $0x803020
  800f38:	e8 35 fe ff ff       	call   800d72 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f3d:	90                   	nop
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	8b 00                	mov    (%eax),%eax
  800f4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f51:	89 0a                	mov    %ecx,(%edx)
  800f53:	8b 55 08             	mov    0x8(%ebp),%edx
  800f56:	88 d1                	mov    %dl,%cl
  800f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 00                	mov    (%eax),%eax
  800f64:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f69:	75 2c                	jne    800f97 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f6b:	a0 24 40 80 00       	mov    0x804024,%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f76:	8b 12                	mov    (%edx),%edx
  800f78:	89 d1                	mov    %edx,%ecx
  800f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7d:	83 c2 08             	add    $0x8,%edx
  800f80:	83 ec 04             	sub    $0x4,%esp
  800f83:	50                   	push   %eax
  800f84:	51                   	push   %ecx
  800f85:	52                   	push   %edx
  800f86:	e8 a7 13 00 00       	call   802332 <sys_cputs>
  800f8b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	8b 40 04             	mov    0x4(%eax),%eax
  800f9d:	8d 50 01             	lea    0x1(%eax),%edx
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	89 50 04             	mov    %edx,0x4(%eax)
}
  800fa6:	90                   	nop
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800fb2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800fb9:	00 00 00 
	b.cnt = 0;
  800fbc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800fc3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 40 0f 80 00       	push   $0x800f40
  800fd8:	e8 11 02 00 00       	call   8011ee <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fe0:	a0 24 40 80 00       	mov    0x804024,%al
  800fe5:	0f b6 c0             	movzbl %al,%eax
  800fe8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	50                   	push   %eax
  800ff2:	52                   	push   %edx
  800ff3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ff9:	83 c0 08             	add    $0x8,%eax
  800ffc:	50                   	push   %eax
  800ffd:	e8 30 13 00 00       	call   802332 <sys_cputs>
  801002:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801005:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80100c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <cprintf>:

int cprintf(const char *fmt, ...) {
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80101a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801021:	8d 45 0c             	lea    0xc(%ebp),%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	ff 75 f4             	pushl  -0xc(%ebp)
  801030:	50                   	push   %eax
  801031:	e8 73 ff ff ff       	call   800fa9 <vcprintf>
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80103c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801047:	e8 f7 14 00 00       	call   802543 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80104c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	ff 75 f4             	pushl  -0xc(%ebp)
  80105b:	50                   	push   %eax
  80105c:	e8 48 ff ff ff       	call   800fa9 <vcprintf>
  801061:	83 c4 10             	add    $0x10,%esp
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801067:	e8 f1 14 00 00       	call   80255d <sys_enable_interrupt>
	return cnt;
  80106c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	53                   	push   %ebx
  801075:	83 ec 14             	sub    $0x14,%esp
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107e:	8b 45 14             	mov    0x14(%ebp),%eax
  801081:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801084:	8b 45 18             	mov    0x18(%ebp),%eax
  801087:	ba 00 00 00 00       	mov    $0x0,%edx
  80108c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80108f:	77 55                	ja     8010e6 <printnum+0x75>
  801091:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801094:	72 05                	jb     80109b <printnum+0x2a>
  801096:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801099:	77 4b                	ja     8010e6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80109b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80109e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010a1:	8b 45 18             	mov    0x18(%ebp),%eax
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	52                   	push   %edx
  8010aa:	50                   	push   %eax
  8010ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8010b1:	e8 ae 18 00 00       	call   802964 <__udivdi3>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	ff 75 20             	pushl  0x20(%ebp)
  8010bf:	53                   	push   %ebx
  8010c0:	ff 75 18             	pushl  0x18(%ebp)
  8010c3:	52                   	push   %edx
  8010c4:	50                   	push   %eax
  8010c5:	ff 75 0c             	pushl  0xc(%ebp)
  8010c8:	ff 75 08             	pushl  0x8(%ebp)
  8010cb:	e8 a1 ff ff ff       	call   801071 <printnum>
  8010d0:	83 c4 20             	add    $0x20,%esp
  8010d3:	eb 1a                	jmp    8010ef <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010d5:	83 ec 08             	sub    $0x8,%esp
  8010d8:	ff 75 0c             	pushl  0xc(%ebp)
  8010db:	ff 75 20             	pushl  0x20(%ebp)
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	ff d0                	call   *%eax
  8010e3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010e6:	ff 4d 1c             	decl   0x1c(%ebp)
  8010e9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010ed:	7f e6                	jg     8010d5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010ef:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fd:	53                   	push   %ebx
  8010fe:	51                   	push   %ecx
  8010ff:	52                   	push   %edx
  801100:	50                   	push   %eax
  801101:	e8 6e 19 00 00       	call   802a74 <__umoddi3>
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	05 f4 32 80 00       	add    $0x8032f4,%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	0f be c0             	movsbl %al,%eax
  801113:	83 ec 08             	sub    $0x8,%esp
  801116:	ff 75 0c             	pushl  0xc(%ebp)
  801119:	50                   	push   %eax
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	ff d0                	call   *%eax
  80111f:	83 c4 10             	add    $0x10,%esp
}
  801122:	90                   	nop
  801123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80112b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80112f:	7e 1c                	jle    80114d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8b 00                	mov    (%eax),%eax
  801136:	8d 50 08             	lea    0x8(%eax),%edx
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	89 10                	mov    %edx,(%eax)
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8b 00                	mov    (%eax),%eax
  801143:	83 e8 08             	sub    $0x8,%eax
  801146:	8b 50 04             	mov    0x4(%eax),%edx
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	eb 40                	jmp    80118d <getuint+0x65>
	else if (lflag)
  80114d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801151:	74 1e                	je     801171 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8b 00                	mov    (%eax),%eax
  801158:	8d 50 04             	lea    0x4(%eax),%edx
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	89 10                	mov    %edx,(%eax)
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	83 e8 04             	sub    $0x4,%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	ba 00 00 00 00       	mov    $0x0,%edx
  80116f:	eb 1c                	jmp    80118d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 50 04             	lea    0x4(%eax),%edx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	89 10                	mov    %edx,(%eax)
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8b 00                	mov    (%eax),%eax
  801183:	83 e8 04             	sub    $0x4,%eax
  801186:	8b 00                	mov    (%eax),%eax
  801188:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801192:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801196:	7e 1c                	jle    8011b4 <getint+0x25>
		return va_arg(*ap, long long);
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8b 00                	mov    (%eax),%eax
  80119d:	8d 50 08             	lea    0x8(%eax),%edx
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	89 10                	mov    %edx,(%eax)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8b 00                	mov    (%eax),%eax
  8011aa:	83 e8 08             	sub    $0x8,%eax
  8011ad:	8b 50 04             	mov    0x4(%eax),%edx
  8011b0:	8b 00                	mov    (%eax),%eax
  8011b2:	eb 38                	jmp    8011ec <getint+0x5d>
	else if (lflag)
  8011b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b8:	74 1a                	je     8011d4 <getint+0x45>
		return va_arg(*ap, long);
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	8b 00                	mov    (%eax),%eax
  8011bf:	8d 50 04             	lea    0x4(%eax),%edx
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	89 10                	mov    %edx,(%eax)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8b 00                	mov    (%eax),%eax
  8011cc:	83 e8 04             	sub    $0x4,%eax
  8011cf:	8b 00                	mov    (%eax),%eax
  8011d1:	99                   	cltd   
  8011d2:	eb 18                	jmp    8011ec <getint+0x5d>
	else
		return va_arg(*ap, int);
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8b 00                	mov    (%eax),%eax
  8011d9:	8d 50 04             	lea    0x4(%eax),%edx
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	89 10                	mov    %edx,(%eax)
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8b 00                	mov    (%eax),%eax
  8011e6:	83 e8 04             	sub    $0x4,%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	99                   	cltd   
}
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	56                   	push   %esi
  8011f2:	53                   	push   %ebx
  8011f3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011f6:	eb 17                	jmp    80120f <vprintfmt+0x21>
			if (ch == '\0')
  8011f8:	85 db                	test   %ebx,%ebx
  8011fa:	0f 84 af 03 00 00    	je     8015af <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801200:	83 ec 08             	sub    $0x8,%esp
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	53                   	push   %ebx
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	ff d0                	call   *%eax
  80120c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80120f:	8b 45 10             	mov    0x10(%ebp),%eax
  801212:	8d 50 01             	lea    0x1(%eax),%edx
  801215:	89 55 10             	mov    %edx,0x10(%ebp)
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f b6 d8             	movzbl %al,%ebx
  80121d:	83 fb 25             	cmp    $0x25,%ebx
  801220:	75 d6                	jne    8011f8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801222:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801226:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80122d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801234:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80123b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801242:	8b 45 10             	mov    0x10(%ebp),%eax
  801245:	8d 50 01             	lea    0x1(%eax),%edx
  801248:	89 55 10             	mov    %edx,0x10(%ebp)
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	0f b6 d8             	movzbl %al,%ebx
  801250:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801253:	83 f8 55             	cmp    $0x55,%eax
  801256:	0f 87 2b 03 00 00    	ja     801587 <vprintfmt+0x399>
  80125c:	8b 04 85 18 33 80 00 	mov    0x803318(,%eax,4),%eax
  801263:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801265:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801269:	eb d7                	jmp    801242 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80126b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80126f:	eb d1                	jmp    801242 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801271:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801278:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80127b:	89 d0                	mov    %edx,%eax
  80127d:	c1 e0 02             	shl    $0x2,%eax
  801280:	01 d0                	add    %edx,%eax
  801282:	01 c0                	add    %eax,%eax
  801284:	01 d8                	add    %ebx,%eax
  801286:	83 e8 30             	sub    $0x30,%eax
  801289:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801294:	83 fb 2f             	cmp    $0x2f,%ebx
  801297:	7e 3e                	jle    8012d7 <vprintfmt+0xe9>
  801299:	83 fb 39             	cmp    $0x39,%ebx
  80129c:	7f 39                	jg     8012d7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80129e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012a1:	eb d5                	jmp    801278 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a6:	83 c0 04             	add    $0x4,%eax
  8012a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8012ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8012af:	83 e8 04             	sub    $0x4,%eax
  8012b2:	8b 00                	mov    (%eax),%eax
  8012b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8012b7:	eb 1f                	jmp    8012d8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8012b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bd:	79 83                	jns    801242 <vprintfmt+0x54>
				width = 0;
  8012bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8012c6:	e9 77 ff ff ff       	jmp    801242 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8012cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8012d2:	e9 6b ff ff ff       	jmp    801242 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8012d7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012dc:	0f 89 60 ff ff ff    	jns    801242 <vprintfmt+0x54>
				width = precision, precision = -1;
  8012e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012ef:	e9 4e ff ff ff       	jmp    801242 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012f4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012f7:	e9 46 ff ff ff       	jmp    801242 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	83 c0 04             	add    $0x4,%eax
  801302:	89 45 14             	mov    %eax,0x14(%ebp)
  801305:	8b 45 14             	mov    0x14(%ebp),%eax
  801308:	83 e8 04             	sub    $0x4,%eax
  80130b:	8b 00                	mov    (%eax),%eax
  80130d:	83 ec 08             	sub    $0x8,%esp
  801310:	ff 75 0c             	pushl  0xc(%ebp)
  801313:	50                   	push   %eax
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	ff d0                	call   *%eax
  801319:	83 c4 10             	add    $0x10,%esp
			break;
  80131c:	e9 89 02 00 00       	jmp    8015aa <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801321:	8b 45 14             	mov    0x14(%ebp),%eax
  801324:	83 c0 04             	add    $0x4,%eax
  801327:	89 45 14             	mov    %eax,0x14(%ebp)
  80132a:	8b 45 14             	mov    0x14(%ebp),%eax
  80132d:	83 e8 04             	sub    $0x4,%eax
  801330:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801332:	85 db                	test   %ebx,%ebx
  801334:	79 02                	jns    801338 <vprintfmt+0x14a>
				err = -err;
  801336:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801338:	83 fb 64             	cmp    $0x64,%ebx
  80133b:	7f 0b                	jg     801348 <vprintfmt+0x15a>
  80133d:	8b 34 9d 60 31 80 00 	mov    0x803160(,%ebx,4),%esi
  801344:	85 f6                	test   %esi,%esi
  801346:	75 19                	jne    801361 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801348:	53                   	push   %ebx
  801349:	68 05 33 80 00       	push   $0x803305
  80134e:	ff 75 0c             	pushl  0xc(%ebp)
  801351:	ff 75 08             	pushl  0x8(%ebp)
  801354:	e8 5e 02 00 00       	call   8015b7 <printfmt>
  801359:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80135c:	e9 49 02 00 00       	jmp    8015aa <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801361:	56                   	push   %esi
  801362:	68 0e 33 80 00       	push   $0x80330e
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	ff 75 08             	pushl  0x8(%ebp)
  80136d:	e8 45 02 00 00       	call   8015b7 <printfmt>
  801372:	83 c4 10             	add    $0x10,%esp
			break;
  801375:	e9 30 02 00 00       	jmp    8015aa <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80137a:	8b 45 14             	mov    0x14(%ebp),%eax
  80137d:	83 c0 04             	add    $0x4,%eax
  801380:	89 45 14             	mov    %eax,0x14(%ebp)
  801383:	8b 45 14             	mov    0x14(%ebp),%eax
  801386:	83 e8 04             	sub    $0x4,%eax
  801389:	8b 30                	mov    (%eax),%esi
  80138b:	85 f6                	test   %esi,%esi
  80138d:	75 05                	jne    801394 <vprintfmt+0x1a6>
				p = "(null)";
  80138f:	be 11 33 80 00       	mov    $0x803311,%esi
			if (width > 0 && padc != '-')
  801394:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801398:	7e 6d                	jle    801407 <vprintfmt+0x219>
  80139a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80139e:	74 67                	je     801407 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a3:	83 ec 08             	sub    $0x8,%esp
  8013a6:	50                   	push   %eax
  8013a7:	56                   	push   %esi
  8013a8:	e8 0c 03 00 00       	call   8016b9 <strnlen>
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8013b3:	eb 16                	jmp    8013cb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8013b5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	ff 75 0c             	pushl  0xc(%ebp)
  8013bf:	50                   	push   %eax
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	ff d0                	call   *%eax
  8013c5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c8:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013cf:	7f e4                	jg     8013b5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d1:	eb 34                	jmp    801407 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8013d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013d7:	74 1c                	je     8013f5 <vprintfmt+0x207>
  8013d9:	83 fb 1f             	cmp    $0x1f,%ebx
  8013dc:	7e 05                	jle    8013e3 <vprintfmt+0x1f5>
  8013de:	83 fb 7e             	cmp    $0x7e,%ebx
  8013e1:	7e 12                	jle    8013f5 <vprintfmt+0x207>
					putch('?', putdat);
  8013e3:	83 ec 08             	sub    $0x8,%esp
  8013e6:	ff 75 0c             	pushl  0xc(%ebp)
  8013e9:	6a 3f                	push   $0x3f
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	ff d0                	call   *%eax
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	eb 0f                	jmp    801404 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	53                   	push   %ebx
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	ff d0                	call   *%eax
  801401:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801404:	ff 4d e4             	decl   -0x1c(%ebp)
  801407:	89 f0                	mov    %esi,%eax
  801409:	8d 70 01             	lea    0x1(%eax),%esi
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	0f be d8             	movsbl %al,%ebx
  801411:	85 db                	test   %ebx,%ebx
  801413:	74 24                	je     801439 <vprintfmt+0x24b>
  801415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801419:	78 b8                	js     8013d3 <vprintfmt+0x1e5>
  80141b:	ff 4d e0             	decl   -0x20(%ebp)
  80141e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801422:	79 af                	jns    8013d3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801424:	eb 13                	jmp    801439 <vprintfmt+0x24b>
				putch(' ', putdat);
  801426:	83 ec 08             	sub    $0x8,%esp
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	6a 20                	push   $0x20
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	ff d0                	call   *%eax
  801433:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801436:	ff 4d e4             	decl   -0x1c(%ebp)
  801439:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143d:	7f e7                	jg     801426 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80143f:	e9 66 01 00 00       	jmp    8015aa <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801444:	83 ec 08             	sub    $0x8,%esp
  801447:	ff 75 e8             	pushl  -0x18(%ebp)
  80144a:	8d 45 14             	lea    0x14(%ebp),%eax
  80144d:	50                   	push   %eax
  80144e:	e8 3c fd ff ff       	call   80118f <getint>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801459:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801462:	85 d2                	test   %edx,%edx
  801464:	79 23                	jns    801489 <vprintfmt+0x29b>
				putch('-', putdat);
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	ff 75 0c             	pushl  0xc(%ebp)
  80146c:	6a 2d                	push   $0x2d
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	ff d0                	call   *%eax
  801473:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147c:	f7 d8                	neg    %eax
  80147e:	83 d2 00             	adc    $0x0,%edx
  801481:	f7 da                	neg    %edx
  801483:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801486:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801489:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801490:	e9 bc 00 00 00       	jmp    801551 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	ff 75 e8             	pushl  -0x18(%ebp)
  80149b:	8d 45 14             	lea    0x14(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	e8 84 fc ff ff       	call   801128 <getuint>
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8014ad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8014b4:	e9 98 00 00 00       	jmp    801551 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 58                	push   $0x58
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	6a 58                	push   $0x58
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	ff d0                	call   *%eax
  8014d6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014d9:	83 ec 08             	sub    $0x8,%esp
  8014dc:	ff 75 0c             	pushl  0xc(%ebp)
  8014df:	6a 58                	push   $0x58
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	ff d0                	call   *%eax
  8014e6:	83 c4 10             	add    $0x10,%esp
			break;
  8014e9:	e9 bc 00 00 00       	jmp    8015aa <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	6a 30                	push   $0x30
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	ff d0                	call   *%eax
  8014fb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014fe:	83 ec 08             	sub    $0x8,%esp
  801501:	ff 75 0c             	pushl  0xc(%ebp)
  801504:	6a 78                	push   $0x78
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	ff d0                	call   *%eax
  80150b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80150e:	8b 45 14             	mov    0x14(%ebp),%eax
  801511:	83 c0 04             	add    $0x4,%eax
  801514:	89 45 14             	mov    %eax,0x14(%ebp)
  801517:	8b 45 14             	mov    0x14(%ebp),%eax
  80151a:	83 e8 04             	sub    $0x4,%eax
  80151d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80151f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801529:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801530:	eb 1f                	jmp    801551 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	ff 75 e8             	pushl  -0x18(%ebp)
  801538:	8d 45 14             	lea    0x14(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	e8 e7 fb ff ff       	call   801128 <getuint>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801547:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80154a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801551:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	52                   	push   %edx
  80155c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155f:	50                   	push   %eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	ff 75 f0             	pushl  -0x10(%ebp)
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	e8 00 fb ff ff       	call   801071 <printnum>
  801571:	83 c4 20             	add    $0x20,%esp
			break;
  801574:	eb 34                	jmp    8015aa <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	53                   	push   %ebx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	ff d0                	call   *%eax
  801582:	83 c4 10             	add    $0x10,%esp
			break;
  801585:	eb 23                	jmp    8015aa <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	ff 75 0c             	pushl  0xc(%ebp)
  80158d:	6a 25                	push   $0x25
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	ff d0                	call   *%eax
  801594:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801597:	ff 4d 10             	decl   0x10(%ebp)
  80159a:	eb 03                	jmp    80159f <vprintfmt+0x3b1>
  80159c:	ff 4d 10             	decl   0x10(%ebp)
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	48                   	dec    %eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3c 25                	cmp    $0x25,%al
  8015a7:	75 f3                	jne    80159c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8015a9:	90                   	nop
		}
	}
  8015aa:	e9 47 fc ff ff       	jmp    8011f6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8015af:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8015b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5d                   	pop    %ebp
  8015b6:	c3                   	ret    

008015b7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8015bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8015c0:	83 c0 04             	add    $0x4,%eax
  8015c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8015c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	ff 75 08             	pushl  0x8(%ebp)
  8015d3:	e8 16 fc ff ff       	call   8011ee <vprintfmt>
  8015d8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015db:	90                   	nop
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	8b 40 08             	mov    0x8(%eax),%eax
  8015e7:	8d 50 01             	lea    0x1(%eax),%edx
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f3:	8b 10                	mov    (%eax),%edx
  8015f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f8:	8b 40 04             	mov    0x4(%eax),%eax
  8015fb:	39 c2                	cmp    %eax,%edx
  8015fd:	73 12                	jae    801611 <sprintputch+0x33>
		*b->buf++ = ch;
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	8b 00                	mov    (%eax),%eax
  801604:	8d 48 01             	lea    0x1(%eax),%ecx
  801607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160a:	89 0a                	mov    %ecx,(%edx)
  80160c:	8b 55 08             	mov    0x8(%ebp),%edx
  80160f:	88 10                	mov    %dl,(%eax)
}
  801611:	90                   	nop
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    

00801614 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	8d 50 ff             	lea    -0x1(%eax),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	01 d0                	add    %edx,%eax
  80162b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80162e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801635:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801639:	74 06                	je     801641 <vsnprintf+0x2d>
  80163b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80163f:	7f 07                	jg     801648 <vsnprintf+0x34>
		return -E_INVAL;
  801641:	b8 03 00 00 00       	mov    $0x3,%eax
  801646:	eb 20                	jmp    801668 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801648:	ff 75 14             	pushl  0x14(%ebp)
  80164b:	ff 75 10             	pushl  0x10(%ebp)
  80164e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801651:	50                   	push   %eax
  801652:	68 de 15 80 00       	push   $0x8015de
  801657:	e8 92 fb ff ff       	call   8011ee <vprintfmt>
  80165c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80165f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801662:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801670:	8d 45 10             	lea    0x10(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801679:	8b 45 10             	mov    0x10(%ebp),%eax
  80167c:	ff 75 f4             	pushl  -0xc(%ebp)
  80167f:	50                   	push   %eax
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	ff 75 08             	pushl  0x8(%ebp)
  801686:	e8 89 ff ff ff       	call   801614 <vsnprintf>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80169c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016a3:	eb 06                	jmp    8016ab <strlen+0x15>
		n++;
  8016a5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016a8:	ff 45 08             	incl   0x8(%ebp)
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	84 c0                	test   %al,%al
  8016b2:	75 f1                	jne    8016a5 <strlen+0xf>
		n++;
	return n;
  8016b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c6:	eb 09                	jmp    8016d1 <strnlen+0x18>
		n++;
  8016c8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016cb:	ff 45 08             	incl   0x8(%ebp)
  8016ce:	ff 4d 0c             	decl   0xc(%ebp)
  8016d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d5:	74 09                	je     8016e0 <strnlen+0x27>
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	84 c0                	test   %al,%al
  8016de:	75 e8                	jne    8016c8 <strnlen+0xf>
		n++;
	return n;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016f1:	90                   	nop
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8d 50 01             	lea    0x1(%eax),%edx
  8016f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801701:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801704:	8a 12                	mov    (%edx),%dl
  801706:	88 10                	mov    %dl,(%eax)
  801708:	8a 00                	mov    (%eax),%al
  80170a:	84 c0                	test   %al,%al
  80170c:	75 e4                	jne    8016f2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80170e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80171f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801726:	eb 1f                	jmp    801747 <strncpy+0x34>
		*dst++ = *src;
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	8d 50 01             	lea    0x1(%eax),%edx
  80172e:	89 55 08             	mov    %edx,0x8(%ebp)
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8a 12                	mov    (%edx),%dl
  801736:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 03                	je     801744 <strncpy+0x31>
			src++;
  801741:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801744:	ff 45 fc             	incl   -0x4(%ebp)
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80174d:	72 d9                	jb     801728 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801760:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801764:	74 30                	je     801796 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801766:	eb 16                	jmp    80177e <strlcpy+0x2a>
			*dst++ = *src++;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8d 50 01             	lea    0x1(%eax),%edx
  80176e:	89 55 08             	mov    %edx,0x8(%ebp)
  801771:	8b 55 0c             	mov    0xc(%ebp),%edx
  801774:	8d 4a 01             	lea    0x1(%edx),%ecx
  801777:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80177a:	8a 12                	mov    (%edx),%dl
  80177c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80177e:	ff 4d 10             	decl   0x10(%ebp)
  801781:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801785:	74 09                	je     801790 <strlcpy+0x3c>
  801787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178a:	8a 00                	mov    (%eax),%al
  80178c:	84 c0                	test   %al,%al
  80178e:	75 d8                	jne    801768 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801796:	8b 55 08             	mov    0x8(%ebp),%edx
  801799:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8017a5:	eb 06                	jmp    8017ad <strcmp+0xb>
		p++, q++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	84 c0                	test   %al,%al
  8017b4:	74 0e                	je     8017c4 <strcmp+0x22>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 10                	mov    (%eax),%dl
  8017bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	38 c2                	cmp    %al,%dl
  8017c2:	74 e3                	je     8017a7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	0f b6 d0             	movzbl %al,%edx
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	8a 00                	mov    (%eax),%al
  8017d1:	0f b6 c0             	movzbl %al,%eax
  8017d4:	29 c2                	sub    %eax,%edx
  8017d6:	89 d0                	mov    %edx,%eax
}
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017dd:	eb 09                	jmp    8017e8 <strncmp+0xe>
		n--, p++, q++;
  8017df:	ff 4d 10             	decl   0x10(%ebp)
  8017e2:	ff 45 08             	incl   0x8(%ebp)
  8017e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ec:	74 17                	je     801805 <strncmp+0x2b>
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	8a 00                	mov    (%eax),%al
  8017f3:	84 c0                	test   %al,%al
  8017f5:	74 0e                	je     801805 <strncmp+0x2b>
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	8a 10                	mov    (%eax),%dl
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	8a 00                	mov    (%eax),%al
  801801:	38 c2                	cmp    %al,%dl
  801803:	74 da                	je     8017df <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801805:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801809:	75 07                	jne    801812 <strncmp+0x38>
		return 0;
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	eb 14                	jmp    801826 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	0f b6 d0             	movzbl %al,%edx
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	0f b6 c0             	movzbl %al,%eax
  801822:	29 c2                	sub    %eax,%edx
  801824:	89 d0                	mov    %edx,%eax
}
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801831:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801834:	eb 12                	jmp    801848 <strchr+0x20>
		if (*s == c)
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	8a 00                	mov    (%eax),%al
  80183b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80183e:	75 05                	jne    801845 <strchr+0x1d>
			return (char *) s;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	eb 11                	jmp    801856 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	8a 00                	mov    (%eax),%al
  80184d:	84 c0                	test   %al,%al
  80184f:	75 e5                	jne    801836 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801864:	eb 0d                	jmp    801873 <strfind+0x1b>
		if (*s == c)
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8a 00                	mov    (%eax),%al
  80186b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80186e:	74 0e                	je     80187e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801870:	ff 45 08             	incl   0x8(%ebp)
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	8a 00                	mov    (%eax),%al
  801878:	84 c0                	test   %al,%al
  80187a:	75 ea                	jne    801866 <strfind+0xe>
  80187c:	eb 01                	jmp    80187f <strfind+0x27>
		if (*s == c)
			break;
  80187e:	90                   	nop
	return (char *) s;
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801890:	8b 45 10             	mov    0x10(%ebp),%eax
  801893:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801896:	eb 0e                	jmp    8018a6 <memset+0x22>
		*p++ = c;
  801898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80189b:	8d 50 01             	lea    0x1(%eax),%edx
  80189e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8018a6:	ff 4d f8             	decl   -0x8(%ebp)
  8018a9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8018ad:	79 e9                	jns    801898 <memset+0x14>
		*p++ = c;

	return v;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8018c6:	eb 16                	jmp    8018de <memcpy+0x2a>
		*d++ = *s++;
  8018c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cb:	8d 50 01             	lea    0x1(%eax),%edx
  8018ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018da:	8a 12                	mov    (%edx),%dl
  8018dc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018de:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	75 dd                	jne    8018c8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801905:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801908:	73 50                	jae    80195a <memmove+0x6a>
  80190a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80190d:	8b 45 10             	mov    0x10(%ebp),%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801915:	76 43                	jbe    80195a <memmove+0x6a>
		s += n;
  801917:	8b 45 10             	mov    0x10(%ebp),%eax
  80191a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80191d:	8b 45 10             	mov    0x10(%ebp),%eax
  801920:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801923:	eb 10                	jmp    801935 <memmove+0x45>
			*--d = *--s;
  801925:	ff 4d f8             	decl   -0x8(%ebp)
  801928:	ff 4d fc             	decl   -0x4(%ebp)
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8a 10                	mov    (%eax),%dl
  801930:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801933:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801935:	8b 45 10             	mov    0x10(%ebp),%eax
  801938:	8d 50 ff             	lea    -0x1(%eax),%edx
  80193b:	89 55 10             	mov    %edx,0x10(%ebp)
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 e3                	jne    801925 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801942:	eb 23                	jmp    801967 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801944:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801947:	8d 50 01             	lea    0x1(%eax),%edx
  80194a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80194d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801950:	8d 4a 01             	lea    0x1(%edx),%ecx
  801953:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801956:	8a 12                	mov    (%edx),%dl
  801958:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80195a:	8b 45 10             	mov    0x10(%ebp),%eax
  80195d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801960:	89 55 10             	mov    %edx,0x10(%ebp)
  801963:	85 c0                	test   %eax,%eax
  801965:	75 dd                	jne    801944 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80197e:	eb 2a                	jmp    8019aa <memcmp+0x3e>
		if (*s1 != *s2)
  801980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801983:	8a 10                	mov    (%eax),%dl
  801985:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	38 c2                	cmp    %al,%dl
  80198c:	74 16                	je     8019a4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801991:	8a 00                	mov    (%eax),%al
  801993:	0f b6 d0             	movzbl %al,%edx
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	0f b6 c0             	movzbl %al,%eax
  80199e:	29 c2                	sub    %eax,%edx
  8019a0:	89 d0                	mov    %edx,%eax
  8019a2:	eb 18                	jmp    8019bc <memcmp+0x50>
		s1++, s2++;
  8019a4:	ff 45 fc             	incl   -0x4(%ebp)
  8019a7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	75 c9                	jne    801980 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8019c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8019cf:	eb 15                	jmp    8019e6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8a 00                	mov    (%eax),%al
  8019d6:	0f b6 d0             	movzbl %al,%edx
  8019d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dc:	0f b6 c0             	movzbl %al,%eax
  8019df:	39 c2                	cmp    %eax,%edx
  8019e1:	74 0d                	je     8019f0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019e3:	ff 45 08             	incl   0x8(%ebp)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019ec:	72 e3                	jb     8019d1 <memfind+0x13>
  8019ee:	eb 01                	jmp    8019f1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019f0:	90                   	nop
	return (void *) s;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a0a:	eb 03                	jmp    801a0f <strtol+0x19>
		s++;
  801a0c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	3c 20                	cmp    $0x20,%al
  801a16:	74 f4                	je     801a0c <strtol+0x16>
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	3c 09                	cmp    $0x9,%al
  801a1f:	74 eb                	je     801a0c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	3c 2b                	cmp    $0x2b,%al
  801a28:	75 05                	jne    801a2f <strtol+0x39>
		s++;
  801a2a:	ff 45 08             	incl   0x8(%ebp)
  801a2d:	eb 13                	jmp    801a42 <strtol+0x4c>
	else if (*s == '-')
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	3c 2d                	cmp    $0x2d,%al
  801a36:	75 0a                	jne    801a42 <strtol+0x4c>
		s++, neg = 1;
  801a38:	ff 45 08             	incl   0x8(%ebp)
  801a3b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a46:	74 06                	je     801a4e <strtol+0x58>
  801a48:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a4c:	75 20                	jne    801a6e <strtol+0x78>
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8a 00                	mov    (%eax),%al
  801a53:	3c 30                	cmp    $0x30,%al
  801a55:	75 17                	jne    801a6e <strtol+0x78>
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	40                   	inc    %eax
  801a5b:	8a 00                	mov    (%eax),%al
  801a5d:	3c 78                	cmp    $0x78,%al
  801a5f:	75 0d                	jne    801a6e <strtol+0x78>
		s += 2, base = 16;
  801a61:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a65:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a6c:	eb 28                	jmp    801a96 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a72:	75 15                	jne    801a89 <strtol+0x93>
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	3c 30                	cmp    $0x30,%al
  801a7b:	75 0c                	jne    801a89 <strtol+0x93>
		s++, base = 8;
  801a7d:	ff 45 08             	incl   0x8(%ebp)
  801a80:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a87:	eb 0d                	jmp    801a96 <strtol+0xa0>
	else if (base == 0)
  801a89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a8d:	75 07                	jne    801a96 <strtol+0xa0>
		base = 10;
  801a8f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8a 00                	mov    (%eax),%al
  801a9b:	3c 2f                	cmp    $0x2f,%al
  801a9d:	7e 19                	jle    801ab8 <strtol+0xc2>
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8a 00                	mov    (%eax),%al
  801aa4:	3c 39                	cmp    $0x39,%al
  801aa6:	7f 10                	jg     801ab8 <strtol+0xc2>
			dig = *s - '0';
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	8a 00                	mov    (%eax),%al
  801aad:	0f be c0             	movsbl %al,%eax
  801ab0:	83 e8 30             	sub    $0x30,%eax
  801ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab6:	eb 42                	jmp    801afa <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	8a 00                	mov    (%eax),%al
  801abd:	3c 60                	cmp    $0x60,%al
  801abf:	7e 19                	jle    801ada <strtol+0xe4>
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	8a 00                	mov    (%eax),%al
  801ac6:	3c 7a                	cmp    $0x7a,%al
  801ac8:	7f 10                	jg     801ada <strtol+0xe4>
			dig = *s - 'a' + 10;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	8a 00                	mov    (%eax),%al
  801acf:	0f be c0             	movsbl %al,%eax
  801ad2:	83 e8 57             	sub    $0x57,%eax
  801ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ad8:	eb 20                	jmp    801afa <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8a 00                	mov    (%eax),%al
  801adf:	3c 40                	cmp    $0x40,%al
  801ae1:	7e 39                	jle    801b1c <strtol+0x126>
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	8a 00                	mov    (%eax),%al
  801ae8:	3c 5a                	cmp    $0x5a,%al
  801aea:	7f 30                	jg     801b1c <strtol+0x126>
			dig = *s - 'A' + 10;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8a 00                	mov    (%eax),%al
  801af1:	0f be c0             	movsbl %al,%eax
  801af4:	83 e8 37             	sub    $0x37,%eax
  801af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afd:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b00:	7d 19                	jge    801b1b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b02:	ff 45 08             	incl   0x8(%ebp)
  801b05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b08:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b0c:	89 c2                	mov    %eax,%edx
  801b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b11:	01 d0                	add    %edx,%eax
  801b13:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801b16:	e9 7b ff ff ff       	jmp    801a96 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801b1b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801b1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b20:	74 08                	je     801b2a <strtol+0x134>
		*endptr = (char *) s;
  801b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b25:	8b 55 08             	mov    0x8(%ebp),%edx
  801b28:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801b2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b2e:	74 07                	je     801b37 <strtol+0x141>
  801b30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b33:	f7 d8                	neg    %eax
  801b35:	eb 03                	jmp    801b3a <strtol+0x144>
  801b37:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <ltostr>:

void
ltostr(long value, char *str)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b54:	79 13                	jns    801b69 <ltostr+0x2d>
	{
		neg = 1;
  801b56:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b60:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b63:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b66:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b71:	99                   	cltd   
  801b72:	f7 f9                	idiv   %ecx
  801b74:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7a:	8d 50 01             	lea    0x1(%eax),%edx
  801b7d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b80:	89 c2                	mov    %eax,%edx
  801b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b85:	01 d0                	add    %edx,%eax
  801b87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b8a:	83 c2 30             	add    $0x30,%edx
  801b8d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b92:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b97:	f7 e9                	imul   %ecx
  801b99:	c1 fa 02             	sar    $0x2,%edx
  801b9c:	89 c8                	mov    %ecx,%eax
  801b9e:	c1 f8 1f             	sar    $0x1f,%eax
  801ba1:	29 c2                	sub    %eax,%edx
  801ba3:	89 d0                	mov    %edx,%eax
  801ba5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801ba8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bab:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801bb0:	f7 e9                	imul   %ecx
  801bb2:	c1 fa 02             	sar    $0x2,%edx
  801bb5:	89 c8                	mov    %ecx,%eax
  801bb7:	c1 f8 1f             	sar    $0x1f,%eax
  801bba:	29 c2                	sub    %eax,%edx
  801bbc:	89 d0                	mov    %edx,%eax
  801bbe:	c1 e0 02             	shl    $0x2,%eax
  801bc1:	01 d0                	add    %edx,%eax
  801bc3:	01 c0                	add    %eax,%eax
  801bc5:	29 c1                	sub    %eax,%ecx
  801bc7:	89 ca                	mov    %ecx,%edx
  801bc9:	85 d2                	test   %edx,%edx
  801bcb:	75 9c                	jne    801b69 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801bd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd7:	48                   	dec    %eax
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801bdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bdf:	74 3d                	je     801c1e <ltostr+0xe2>
		start = 1 ;
  801be1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801be8:	eb 34                	jmp    801c1e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf0:	01 d0                	add    %edx,%eax
  801bf2:	8a 00                	mov    (%eax),%al
  801bf4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfd:	01 c2                	add    %eax,%edx
  801bff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	01 c8                	add    %ecx,%eax
  801c07:	8a 00                	mov    (%eax),%al
  801c09:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c11:	01 c2                	add    %eax,%edx
  801c13:	8a 45 eb             	mov    -0x15(%ebp),%al
  801c16:	88 02                	mov    %al,(%edx)
		start++ ;
  801c18:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801c1b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c24:	7c c4                	jl     801bea <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801c26:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2c:	01 d0                	add    %edx,%eax
  801c2e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	e8 54 fa ff ff       	call   801696 <strlen>
  801c42:	83 c4 04             	add    $0x4,%esp
  801c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	e8 46 fa ff ff       	call   801696 <strlen>
  801c50:	83 c4 04             	add    $0x4,%esp
  801c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c64:	eb 17                	jmp    801c7d <strcconcat+0x49>
		final[s] = str1[s] ;
  801c66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	01 c2                	add    %eax,%edx
  801c6e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	01 c8                	add    %ecx,%eax
  801c76:	8a 00                	mov    (%eax),%al
  801c78:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c7a:	ff 45 fc             	incl   -0x4(%ebp)
  801c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c80:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c83:	7c e1                	jl     801c66 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c85:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c93:	eb 1f                	jmp    801cb4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c98:	8d 50 01             	lea    0x1(%eax),%edx
  801c9b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c9e:	89 c2                	mov    %eax,%edx
  801ca0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca3:	01 c2                	add    %eax,%edx
  801ca5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	01 c8                	add    %ecx,%eax
  801cad:	8a 00                	mov    (%eax),%al
  801caf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801cb1:	ff 45 f8             	incl   -0x8(%ebp)
  801cb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cba:	7c d9                	jl     801c95 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801cbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc2:	01 d0                	add    %edx,%eax
  801cc4:	c6 00 00             	movb   $0x0,(%eax)
}
  801cc7:	90                   	nop
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd9:	8b 00                	mov    (%eax),%eax
  801cdb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce5:	01 d0                	add    %edx,%eax
  801ce7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ced:	eb 0c                	jmp    801cfb <strsplit+0x31>
			*string++ = 0;
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	8d 50 01             	lea    0x1(%eax),%edx
  801cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  801cf8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8a 00                	mov    (%eax),%al
  801d00:	84 c0                	test   %al,%al
  801d02:	74 18                	je     801d1c <strsplit+0x52>
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	8a 00                	mov    (%eax),%al
  801d09:	0f be c0             	movsbl %al,%eax
  801d0c:	50                   	push   %eax
  801d0d:	ff 75 0c             	pushl  0xc(%ebp)
  801d10:	e8 13 fb ff ff       	call   801828 <strchr>
  801d15:	83 c4 08             	add    $0x8,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	75 d3                	jne    801cef <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	8a 00                	mov    (%eax),%al
  801d21:	84 c0                	test   %al,%al
  801d23:	74 5a                	je     801d7f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801d25:	8b 45 14             	mov    0x14(%ebp),%eax
  801d28:	8b 00                	mov    (%eax),%eax
  801d2a:	83 f8 0f             	cmp    $0xf,%eax
  801d2d:	75 07                	jne    801d36 <strsplit+0x6c>
		{
			return 0;
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d34:	eb 66                	jmp    801d9c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801d36:	8b 45 14             	mov    0x14(%ebp),%eax
  801d39:	8b 00                	mov    (%eax),%eax
  801d3b:	8d 48 01             	lea    0x1(%eax),%ecx
  801d3e:	8b 55 14             	mov    0x14(%ebp),%edx
  801d41:	89 0a                	mov    %ecx,(%edx)
  801d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4d:	01 c2                	add    %eax,%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d54:	eb 03                	jmp    801d59 <strsplit+0x8f>
			string++;
  801d56:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	8a 00                	mov    (%eax),%al
  801d5e:	84 c0                	test   %al,%al
  801d60:	74 8b                	je     801ced <strsplit+0x23>
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8a 00                	mov    (%eax),%al
  801d67:	0f be c0             	movsbl %al,%eax
  801d6a:	50                   	push   %eax
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	e8 b5 fa ff ff       	call   801828 <strchr>
  801d73:	83 c4 08             	add    $0x8,%esp
  801d76:	85 c0                	test   %eax,%eax
  801d78:	74 dc                	je     801d56 <strsplit+0x8c>
			string++;
	}
  801d7a:	e9 6e ff ff ff       	jmp    801ced <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d7f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d80:	8b 45 14             	mov    0x14(%ebp),%eax
  801d83:	8b 00                	mov    (%eax),%eax
  801d85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8f:	01 d0                	add    %edx,%eax
  801d91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801da4:	a1 28 40 80 00       	mov    0x804028,%eax
  801da9:	85 c0                	test   %eax,%eax
  801dab:	75 33                	jne    801de0 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801dad:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801db4:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801db7:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801dbe:	00 00 a0 
		spaces[0].pages = numPages;
  801dc1:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801dc8:	00 02 00 
		spaces[0].isFree = 1;
  801dcb:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801dd2:	00 00 00 
		arraySize++;
  801dd5:	a1 28 40 80 00       	mov    0x804028,%eax
  801dda:	40                   	inc    %eax
  801ddb:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801de0:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801de7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801dee:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801df5:	8b 55 08             	mov    0x8(%ebp),%edx
  801df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	48                   	dec    %eax
  801dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e04:	ba 00 00 00 00       	mov    $0x0,%edx
  801e09:	f7 75 e8             	divl   -0x18(%ebp)
  801e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e0f:	29 d0                	sub    %edx,%eax
  801e11:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	c1 e8 0c             	shr    $0xc,%eax
  801e1a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801e1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801e24:	eb 57                	jmp    801e7d <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e29:	c1 e0 04             	shl    $0x4,%eax
  801e2c:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	74 42                	je     801e79 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3a:	c1 e0 04             	shl    $0x4,%eax
  801e3d:	05 28 41 80 00       	add    $0x804128,%eax
  801e42:	8b 00                	mov    (%eax),%eax
  801e44:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801e47:	7c 31                	jl     801e7a <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4c:	c1 e0 04             	shl    $0x4,%eax
  801e4f:	05 28 41 80 00       	add    $0x804128,%eax
  801e54:	8b 00                	mov    (%eax),%eax
  801e56:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801e59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e5c:	7d 1c                	jge    801e7a <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e61:	c1 e0 04             	shl    $0x4,%eax
  801e64:	05 28 41 80 00       	add    $0x804128,%eax
  801e69:	8b 00                	mov    (%eax),%eax
  801e6b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e77:	eb 01                	jmp    801e7a <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801e79:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801e7a:	ff 45 ec             	incl   -0x14(%ebp)
  801e7d:	a1 28 40 80 00       	mov    0x804028,%eax
  801e82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801e85:	7c 9f                	jl     801e26 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801e87:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e8b:	75 0a                	jne    801e97 <malloc+0xf9>
	{
		return NULL;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	e9 34 01 00 00       	jmp    801fcb <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9a:	c1 e0 04             	shl    $0x4,%eax
  801e9d:	05 28 41 80 00       	add    $0x804128,%eax
  801ea2:	8b 00                	mov    (%eax),%eax
  801ea4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801ea7:	75 38                	jne    801ee1 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eac:	c1 e0 04             	shl    $0x4,%eax
  801eaf:	05 2c 41 80 00       	add    $0x80412c,%eax
  801eb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801eba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebd:	c1 e0 0c             	shl    $0xc,%eax
  801ec0:	89 c2                	mov    %eax,%edx
  801ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec5:	c1 e0 04             	shl    $0x4,%eax
  801ec8:	05 20 41 80 00       	add    $0x804120,%eax
  801ecd:	8b 00                	mov    (%eax),%eax
  801ecf:	83 ec 08             	sub    $0x8,%esp
  801ed2:	52                   	push   %edx
  801ed3:	50                   	push   %eax
  801ed4:	e8 01 06 00 00       	call   8024da <sys_allocateMem>
  801ed9:	83 c4 10             	add    $0x10,%esp
  801edc:	e9 dd 00 00 00       	jmp    801fbe <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee4:	c1 e0 04             	shl    $0x4,%eax
  801ee7:	05 20 41 80 00       	add    $0x804120,%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ef1:	c1 e2 0c             	shl    $0xc,%edx
  801ef4:	01 d0                	add    %edx,%eax
  801ef6:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801ef9:	a1 28 40 80 00       	mov    0x804028,%eax
  801efe:	c1 e0 04             	shl    $0x4,%eax
  801f01:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  801f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f0a:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801f0c:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f15:	c1 e0 04             	shl    $0x4,%eax
  801f18:	05 24 41 80 00       	add    $0x804124,%eax
  801f1d:	8b 00                	mov    (%eax),%eax
  801f1f:	c1 e2 04             	shl    $0x4,%edx
  801f22:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801f28:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801f2a:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	c1 e0 04             	shl    $0x4,%eax
  801f36:	05 28 41 80 00       	add    $0x804128,%eax
  801f3b:	8b 00                	mov    (%eax),%eax
  801f3d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801f40:	c1 e2 04             	shl    $0x4,%edx
  801f43:	81 c2 28 41 80 00    	add    $0x804128,%edx
  801f49:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801f4b:	a1 28 40 80 00       	mov    0x804028,%eax
  801f50:	c1 e0 04             	shl    $0x4,%eax
  801f53:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f58:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801f5e:	a1 28 40 80 00       	mov    0x804028,%eax
  801f63:	40                   	inc    %eax
  801f64:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6c:	c1 e0 04             	shl    $0x4,%eax
  801f6f:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  801f75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f78:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7d:	c1 e0 04             	shl    $0x4,%eax
  801f80:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  801f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f89:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	c1 e0 04             	shl    $0x4,%eax
  801f91:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f9f:	c1 e0 0c             	shl    $0xc,%eax
  801fa2:	89 c2                	mov    %eax,%edx
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	c1 e0 04             	shl    $0x4,%eax
  801faa:	05 20 41 80 00       	add    $0x804120,%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	83 ec 08             	sub    $0x8,%esp
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	e8 1f 05 00 00       	call   8024da <sys_allocateMem>
  801fbb:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	c1 e0 04             	shl    $0x4,%eax
  801fc4:	05 20 41 80 00       	add    $0x804120,%eax
  801fc9:	8b 00                	mov    (%eax),%eax
	}


}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801fd3:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801fda:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801fe1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fe8:	eb 3f                	jmp    802029 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fed:	c1 e0 04             	shl    $0x4,%eax
  801ff0:	05 20 41 80 00       	add    $0x804120,%eax
  801ff5:	8b 00                	mov    (%eax),%eax
  801ff7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ffa:	75 2a                	jne    802026 <free+0x59>
		{
			index=i;
  801ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  802002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802005:	c1 e0 04             	shl    $0x4,%eax
  802008:	05 28 41 80 00       	add    $0x804128,%eax
  80200d:	8b 00                	mov    (%eax),%eax
  80200f:	c1 e0 0c             	shl    $0xc,%eax
  802012:	89 c2                	mov    %eax,%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	83 ec 08             	sub    $0x8,%esp
  80201a:	52                   	push   %edx
  80201b:	50                   	push   %eax
  80201c:	e8 9d 04 00 00       	call   8024be <sys_freeMem>
  802021:	83 c4 10             	add    $0x10,%esp
			break;
  802024:	eb 0d                	jmp    802033 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  802026:	ff 45 ec             	incl   -0x14(%ebp)
  802029:	a1 28 40 80 00       	mov    0x804028,%eax
  80202e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802031:	7c b7                	jl     801fea <free+0x1d>
			break;
		}

	}

	if(index == -1)
  802033:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802037:	75 17                	jne    802050 <free+0x83>
	{
		panic("Error");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 70 34 80 00       	push   $0x803470
  802041:	68 81 00 00 00       	push   $0x81
  802046:	68 76 34 80 00       	push   $0x803476
  80204b:	e8 22 ed ff ff       	call   800d72 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  802050:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802057:	e9 cc 00 00 00       	jmp    802128 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  80205c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205f:	c1 e0 04             	shl    $0x4,%eax
  802062:	05 2c 41 80 00       	add    $0x80412c,%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	85 c0                	test   %eax,%eax
  80206b:	0f 84 b3 00 00 00    	je     802124 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	c1 e0 04             	shl    $0x4,%eax
  802077:	05 20 41 80 00       	add    $0x804120,%eax
  80207c:	8b 10                	mov    (%eax),%edx
  80207e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802081:	c1 e0 04             	shl    $0x4,%eax
  802084:	05 24 41 80 00       	add    $0x804124,%eax
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	39 c2                	cmp    %eax,%edx
  80208d:	0f 85 92 00 00 00    	jne    802125 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	c1 e0 04             	shl    $0x4,%eax
  802099:	05 24 41 80 00       	add    $0x804124,%eax
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020a3:	c1 e2 04             	shl    $0x4,%edx
  8020a6:	81 c2 24 41 80 00    	add    $0x804124,%edx
  8020ac:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  8020ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b1:	c1 e0 04             	shl    $0x4,%eax
  8020b4:	05 28 41 80 00       	add    $0x804128,%eax
  8020b9:	8b 10                	mov    (%eax),%edx
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	c1 e0 04             	shl    $0x4,%eax
  8020c1:	05 28 41 80 00       	add    $0x804128,%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	01 c2                	add    %eax,%edx
  8020ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020cd:	c1 e0 04             	shl    $0x4,%eax
  8020d0:	05 28 41 80 00       	add    $0x804128,%eax
  8020d5:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	c1 e0 04             	shl    $0x4,%eax
  8020dd:	05 20 41 80 00       	add    $0x804120,%eax
  8020e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	c1 e0 04             	shl    $0x4,%eax
  8020ee:	05 24 41 80 00       	add    $0x804124,%eax
  8020f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	c1 e0 04             	shl    $0x4,%eax
  8020ff:	05 28 41 80 00       	add    $0x804128,%eax
  802104:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	c1 e0 04             	shl    $0x4,%eax
  802110:	05 2c 41 80 00       	add    $0x80412c,%eax
  802115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  80211b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  802122:	eb 12                	jmp    802136 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  802124:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  802125:	ff 45 e8             	incl   -0x18(%ebp)
  802128:	a1 28 40 80 00       	mov    0x804028,%eax
  80212d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  802130:	0f 8c 26 ff ff ff    	jl     80205c <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  802136:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80213d:	e9 cc 00 00 00       	jmp    80220e <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  802142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802145:	c1 e0 04             	shl    $0x4,%eax
  802148:	05 2c 41 80 00       	add    $0x80412c,%eax
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	0f 84 b3 00 00 00    	je     80220a <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	c1 e0 04             	shl    $0x4,%eax
  80215d:	05 24 41 80 00       	add    $0x804124,%eax
  802162:	8b 10                	mov    (%eax),%edx
  802164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802167:	c1 e0 04             	shl    $0x4,%eax
  80216a:	05 20 41 80 00       	add    $0x804120,%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	39 c2                	cmp    %eax,%edx
  802173:	0f 85 92 00 00 00    	jne    80220b <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	c1 e0 04             	shl    $0x4,%eax
  80217f:	05 20 41 80 00       	add    $0x804120,%eax
  802184:	8b 00                	mov    (%eax),%eax
  802186:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802189:	c1 e2 04             	shl    $0x4,%edx
  80218c:	81 c2 20 41 80 00    	add    $0x804120,%edx
  802192:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  802194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802197:	c1 e0 04             	shl    $0x4,%eax
  80219a:	05 28 41 80 00       	add    $0x804128,%eax
  80219f:	8b 10                	mov    (%eax),%edx
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	c1 e0 04             	shl    $0x4,%eax
  8021a7:	05 28 41 80 00       	add    $0x804128,%eax
  8021ac:	8b 00                	mov    (%eax),%eax
  8021ae:	01 c2                	add    %eax,%edx
  8021b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b3:	c1 e0 04             	shl    $0x4,%eax
  8021b6:	05 28 41 80 00       	add    $0x804128,%eax
  8021bb:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	c1 e0 04             	shl    $0x4,%eax
  8021c3:	05 20 41 80 00       	add    $0x804120,%eax
  8021c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	c1 e0 04             	shl    $0x4,%eax
  8021d4:	05 24 41 80 00       	add    $0x804124,%eax
  8021d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	c1 e0 04             	shl    $0x4,%eax
  8021e5:	05 28 41 80 00       	add    $0x804128,%eax
  8021ea:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	c1 e0 04             	shl    $0x4,%eax
  8021f6:	05 2c 41 80 00       	add    $0x80412c,%eax
  8021fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  802201:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  802208:	eb 12                	jmp    80221c <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80220a:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  80220b:	ff 45 e4             	incl   -0x1c(%ebp)
  80220e:	a1 28 40 80 00       	mov    0x804028,%eax
  802213:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802216:	0f 8c 26 ff ff ff    	jl     802142 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  80221c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  802220:	75 11                	jne    802233 <free+0x266>
	{
		spaces[index].isFree = 1;
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	c1 e0 04             	shl    $0x4,%eax
  802228:	05 2c 41 80 00       	add    $0x80412c,%eax
  80222d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  802233:	90                   	nop
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 18             	sub    $0x18,%esp
  80223c:	8b 45 10             	mov    0x10(%ebp),%eax
  80223f:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	68 84 34 80 00       	push   $0x803484
  80224a:	68 b9 00 00 00       	push   $0xb9
  80224f:	68 76 34 80 00       	push   $0x803476
  802254:	e8 19 eb ff ff       	call   800d72 <_panic>

00802259 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80225f:	83 ec 04             	sub    $0x4,%esp
  802262:	68 84 34 80 00       	push   $0x803484
  802267:	68 bf 00 00 00       	push   $0xbf
  80226c:	68 76 34 80 00       	push   $0x803476
  802271:	e8 fc ea ff ff       	call   800d72 <_panic>

00802276 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 84 34 80 00       	push   $0x803484
  802284:	68 c5 00 00 00       	push   $0xc5
  802289:	68 76 34 80 00       	push   $0x803476
  80228e:	e8 df ea ff ff       	call   800d72 <_panic>

00802293 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	68 84 34 80 00       	push   $0x803484
  8022a1:	68 ca 00 00 00       	push   $0xca
  8022a6:	68 76 34 80 00       	push   $0x803476
  8022ab:	e8 c2 ea ff ff       	call   800d72 <_panic>

008022b0 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022b6:	83 ec 04             	sub    $0x4,%esp
  8022b9:	68 84 34 80 00       	push   $0x803484
  8022be:	68 d0 00 00 00       	push   $0xd0
  8022c3:	68 76 34 80 00       	push   $0x803476
  8022c8:	e8 a5 ea ff ff       	call   800d72 <_panic>

008022cd <shrink>:
}
void shrink(uint32 newSize)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 84 34 80 00       	push   $0x803484
  8022db:	68 d4 00 00 00       	push   $0xd4
  8022e0:	68 76 34 80 00       	push   $0x803476
  8022e5:	e8 88 ea ff ff       	call   800d72 <_panic>

008022ea <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	68 84 34 80 00       	push   $0x803484
  8022f8:	68 d9 00 00 00       	push   $0xd9
  8022fd:	68 76 34 80 00       	push   $0x803476
  802302:	e8 6b ea ff ff       	call   800d72 <_panic>

00802307 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	57                   	push   %edi
  80230b:	56                   	push   %esi
  80230c:	53                   	push   %ebx
  80230d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8b 55 0c             	mov    0xc(%ebp),%edx
  802316:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802319:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80231c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80231f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802322:	cd 30                	int    $0x30
  802324:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	5b                   	pop    %ebx
  80232e:	5e                   	pop    %esi
  80232f:	5f                   	pop    %edi
  802330:	5d                   	pop    %ebp
  802331:	c3                   	ret    

00802332 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	8b 45 10             	mov    0x10(%ebp),%eax
  80233b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80233e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	52                   	push   %edx
  80234a:	ff 75 0c             	pushl  0xc(%ebp)
  80234d:	50                   	push   %eax
  80234e:	6a 00                	push   $0x0
  802350:	e8 b2 ff ff ff       	call   802307 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	90                   	nop
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_cgetc>:

int
sys_cgetc(void)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 01                	push   $0x1
  80236a:	e8 98 ff ff ff       	call   802307 <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	50                   	push   %eax
  802383:	6a 05                	push   $0x5
  802385:	e8 7d ff ff ff       	call   802307 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    

0080238f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 02                	push   $0x2
  80239e:	e8 64 ff ff ff       	call   802307 <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 03                	push   $0x3
  8023b7:	e8 4b ff ff ff       	call   802307 <syscall>
  8023bc:	83 c4 18             	add    $0x18,%esp
}
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 04                	push   $0x4
  8023d0:	e8 32 ff ff ff       	call   802307 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <sys_env_exit>:


void sys_env_exit(void)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 06                	push   $0x6
  8023e9:	e8 19 ff ff ff       	call   802307 <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
}
  8023f1:	90                   	nop
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	52                   	push   %edx
  802404:	50                   	push   %eax
  802405:	6a 07                	push   $0x7
  802407:	e8 fb fe ff ff       	call   802307 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	56                   	push   %esi
  802415:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802416:	8b 75 18             	mov    0x18(%ebp),%esi
  802419:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80241c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	56                   	push   %esi
  802426:	53                   	push   %ebx
  802427:	51                   	push   %ecx
  802428:	52                   	push   %edx
  802429:	50                   	push   %eax
  80242a:	6a 08                	push   $0x8
  80242c:	e8 d6 fe ff ff       	call   802307 <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80243e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	52                   	push   %edx
  80244b:	50                   	push   %eax
  80244c:	6a 09                	push   $0x9
  80244e:	e8 b4 fe ff ff       	call   802307 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	ff 75 0c             	pushl  0xc(%ebp)
  802464:	ff 75 08             	pushl  0x8(%ebp)
  802467:	6a 0a                	push   $0xa
  802469:	e8 99 fe ff ff       	call   802307 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 0b                	push   $0xb
  802482:	e8 80 fe ff ff       	call   802307 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 0c                	push   $0xc
  80249b:	e8 67 fe ff ff       	call   802307 <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 0d                	push   $0xd
  8024b4:	e8 4e fe ff ff       	call   802307 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ca:	ff 75 08             	pushl  0x8(%ebp)
  8024cd:	6a 11                	push   $0x11
  8024cf:	e8 33 fe ff ff       	call   802307 <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
	return;
  8024d7:	90                   	nop
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	ff 75 0c             	pushl  0xc(%ebp)
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	6a 12                	push   $0x12
  8024eb:	e8 17 fe ff ff       	call   802307 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 0e                	push   $0xe
  802505:	e8 fd fd ff ff       	call   802307 <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

0080250f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	ff 75 08             	pushl  0x8(%ebp)
  80251d:	6a 0f                	push   $0xf
  80251f:	e8 e3 fd ff ff       	call   802307 <syscall>
  802524:	83 c4 18             	add    $0x18,%esp
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 10                	push   $0x10
  802538:	e8 ca fd ff ff       	call   802307 <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	90                   	nop
  802541:	c9                   	leave  
  802542:	c3                   	ret    

00802543 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802543:	55                   	push   %ebp
  802544:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 14                	push   $0x14
  802552:	e8 b0 fd ff ff       	call   802307 <syscall>
  802557:	83 c4 18             	add    $0x18,%esp
}
  80255a:	90                   	nop
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 15                	push   $0x15
  80256c:	e8 96 fd ff ff       	call   802307 <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	90                   	nop
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_cputc>:


void
sys_cputc(const char c)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802583:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	50                   	push   %eax
  802590:	6a 16                	push   $0x16
  802592:	e8 70 fd ff ff       	call   802307 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
}
  80259a:	90                   	nop
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 17                	push   $0x17
  8025ac:	e8 56 fd ff ff       	call   802307 <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
}
  8025b4:	90                   	nop
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	ff 75 0c             	pushl  0xc(%ebp)
  8025c6:	50                   	push   %eax
  8025c7:	6a 18                	push   $0x18
  8025c9:	e8 39 fd ff ff       	call   802307 <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	52                   	push   %edx
  8025e3:	50                   	push   %eax
  8025e4:	6a 1b                	push   $0x1b
  8025e6:	e8 1c fd ff ff       	call   802307 <syscall>
  8025eb:	83 c4 18             	add    $0x18,%esp
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	52                   	push   %edx
  802600:	50                   	push   %eax
  802601:	6a 19                	push   $0x19
  802603:	e8 ff fc ff ff       	call   802307 <syscall>
  802608:	83 c4 18             	add    $0x18,%esp
}
  80260b:	90                   	nop
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802611:	8b 55 0c             	mov    0xc(%ebp),%edx
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	52                   	push   %edx
  80261e:	50                   	push   %eax
  80261f:	6a 1a                	push   $0x1a
  802621:	e8 e1 fc ff ff       	call   802307 <syscall>
  802626:	83 c4 18             	add    $0x18,%esp
}
  802629:	90                   	nop
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	8b 45 10             	mov    0x10(%ebp),%eax
  802635:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802638:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80263b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	6a 00                	push   $0x0
  802644:	51                   	push   %ecx
  802645:	52                   	push   %edx
  802646:	ff 75 0c             	pushl  0xc(%ebp)
  802649:	50                   	push   %eax
  80264a:	6a 1c                	push   $0x1c
  80264c:	e8 b6 fc ff ff       	call   802307 <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	52                   	push   %edx
  802666:	50                   	push   %eax
  802667:	6a 1d                	push   $0x1d
  802669:	e8 99 fc ff ff       	call   802307 <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802676:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267c:	8b 45 08             	mov    0x8(%ebp),%eax
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	51                   	push   %ecx
  802684:	52                   	push   %edx
  802685:	50                   	push   %eax
  802686:	6a 1e                	push   $0x1e
  802688:	e8 7a fc ff ff       	call   802307 <syscall>
  80268d:	83 c4 18             	add    $0x18,%esp
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802695:	8b 55 0c             	mov    0xc(%ebp),%edx
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	52                   	push   %edx
  8026a2:	50                   	push   %eax
  8026a3:	6a 1f                	push   $0x1f
  8026a5:	e8 5d fc ff ff       	call   802307 <syscall>
  8026aa:	83 c4 18             	add    $0x18,%esp
}
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    

008026af <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 20                	push   $0x20
  8026be:	e8 44 fc ff ff       	call   802307 <syscall>
  8026c3:	83 c4 18             	add    $0x18,%esp
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	6a 00                	push   $0x0
  8026d0:	ff 75 14             	pushl  0x14(%ebp)
  8026d3:	ff 75 10             	pushl  0x10(%ebp)
  8026d6:	ff 75 0c             	pushl  0xc(%ebp)
  8026d9:	50                   	push   %eax
  8026da:	6a 21                	push   $0x21
  8026dc:	e8 26 fc ff ff       	call   802307 <syscall>
  8026e1:	83 c4 18             	add    $0x18,%esp
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	50                   	push   %eax
  8026f5:	6a 22                	push   $0x22
  8026f7:	e8 0b fc ff ff       	call   802307 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
}
  8026ff:	90                   	nop
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	50                   	push   %eax
  802711:	6a 23                	push   $0x23
  802713:	e8 ef fb ff ff       	call   802307 <syscall>
  802718:	83 c4 18             	add    $0x18,%esp
}
  80271b:	90                   	nop
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802724:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802727:	8d 50 04             	lea    0x4(%eax),%edx
  80272a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	52                   	push   %edx
  802734:	50                   	push   %eax
  802735:	6a 24                	push   $0x24
  802737:	e8 cb fb ff ff       	call   802307 <syscall>
  80273c:	83 c4 18             	add    $0x18,%esp
	return result;
  80273f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802742:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802745:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802748:	89 01                	mov    %eax,(%ecx)
  80274a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	c9                   	leave  
  802751:	c2 04 00             	ret    $0x4

00802754 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	ff 75 10             	pushl  0x10(%ebp)
  80275e:	ff 75 0c             	pushl  0xc(%ebp)
  802761:	ff 75 08             	pushl  0x8(%ebp)
  802764:	6a 13                	push   $0x13
  802766:	e8 9c fb ff ff       	call   802307 <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
	return ;
  80276e:	90                   	nop
}
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_rcr2>:
uint32 sys_rcr2()
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 25                	push   $0x25
  802780:	e8 82 fb ff ff       	call   802307 <syscall>
  802785:	83 c4 18             	add    $0x18,%esp
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802796:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	50                   	push   %eax
  8027a3:	6a 26                	push   $0x26
  8027a5:	e8 5d fb ff ff       	call   802307 <syscall>
  8027aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ad:	90                   	nop
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <rsttst>:
void rsttst()
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 28                	push   $0x28
  8027bf:	e8 43 fb ff ff       	call   802307 <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c7:	90                   	nop
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8027d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027d6:	8b 55 18             	mov    0x18(%ebp),%edx
  8027d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027dd:	52                   	push   %edx
  8027de:	50                   	push   %eax
  8027df:	ff 75 10             	pushl  0x10(%ebp)
  8027e2:	ff 75 0c             	pushl  0xc(%ebp)
  8027e5:	ff 75 08             	pushl  0x8(%ebp)
  8027e8:	6a 27                	push   $0x27
  8027ea:	e8 18 fb ff ff       	call   802307 <syscall>
  8027ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f2:	90                   	nop
}
  8027f3:	c9                   	leave  
  8027f4:	c3                   	ret    

008027f5 <chktst>:
void chktst(uint32 n)
{
  8027f5:	55                   	push   %ebp
  8027f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	ff 75 08             	pushl  0x8(%ebp)
  802803:	6a 29                	push   $0x29
  802805:	e8 fd fa ff ff       	call   802307 <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
	return ;
  80280d:	90                   	nop
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <inctst>:

void inctst()
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 2a                	push   $0x2a
  80281f:	e8 e3 fa ff ff       	call   802307 <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
	return ;
  802827:	90                   	nop
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <gettst>:
uint32 gettst()
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 2b                	push   $0x2b
  802839:	e8 c9 fa ff ff       	call   802307 <syscall>
  80283e:	83 c4 18             	add    $0x18,%esp
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 2c                	push   $0x2c
  802855:	e8 ad fa ff ff       	call   802307 <syscall>
  80285a:	83 c4 18             	add    $0x18,%esp
  80285d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802860:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802864:	75 07                	jne    80286d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802866:	b8 01 00 00 00       	mov    $0x1,%eax
  80286b:	eb 05                	jmp    802872 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802872:	c9                   	leave  
  802873:	c3                   	ret    

00802874 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80287a:	6a 00                	push   $0x0
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 2c                	push   $0x2c
  802886:	e8 7c fa ff ff       	call   802307 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
  80288e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802891:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802895:	75 07                	jne    80289e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802897:	b8 01 00 00 00       	mov    $0x1,%eax
  80289c:	eb 05                	jmp    8028a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 2c                	push   $0x2c
  8028b7:	e8 4b fa ff ff       	call   802307 <syscall>
  8028bc:	83 c4 18             	add    $0x18,%esp
  8028bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028c2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028c6:	75 07                	jne    8028cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028cd:	eb 05                	jmp    8028d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 2c                	push   $0x2c
  8028e8:	e8 1a fa ff ff       	call   802307 <syscall>
  8028ed:	83 c4 18             	add    $0x18,%esp
  8028f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8028f3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8028f7:	75 07                	jne    802900 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8028f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fe:	eb 05                	jmp    802905 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	ff 75 08             	pushl  0x8(%ebp)
  802915:	6a 2d                	push   $0x2d
  802917:	e8 eb f9 ff ff       	call   802307 <syscall>
  80291c:	83 c4 18             	add    $0x18,%esp
	return ;
  80291f:	90                   	nop
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802926:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802929:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80292c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	6a 00                	push   $0x0
  802934:	53                   	push   %ebx
  802935:	51                   	push   %ecx
  802936:	52                   	push   %edx
  802937:	50                   	push   %eax
  802938:	6a 2e                	push   $0x2e
  80293a:	e8 c8 f9 ff ff       	call   802307 <syscall>
  80293f:	83 c4 18             	add    $0x18,%esp
}
  802942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80294a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	52                   	push   %edx
  802957:	50                   	push   %eax
  802958:	6a 2f                	push   $0x2f
  80295a:	e8 a8 f9 ff ff       	call   802307 <syscall>
  80295f:	83 c4 18             	add    $0x18,%esp
}
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <__udivdi3>:
  802964:	55                   	push   %ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80296f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802977:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80297b:	89 ca                	mov    %ecx,%edx
  80297d:	89 f8                	mov    %edi,%eax
  80297f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802983:	85 f6                	test   %esi,%esi
  802985:	75 2d                	jne    8029b4 <__udivdi3+0x50>
  802987:	39 cf                	cmp    %ecx,%edi
  802989:	77 65                	ja     8029f0 <__udivdi3+0x8c>
  80298b:	89 fd                	mov    %edi,%ebp
  80298d:	85 ff                	test   %edi,%edi
  80298f:	75 0b                	jne    80299c <__udivdi3+0x38>
  802991:	b8 01 00 00 00       	mov    $0x1,%eax
  802996:	31 d2                	xor    %edx,%edx
  802998:	f7 f7                	div    %edi
  80299a:	89 c5                	mov    %eax,%ebp
  80299c:	31 d2                	xor    %edx,%edx
  80299e:	89 c8                	mov    %ecx,%eax
  8029a0:	f7 f5                	div    %ebp
  8029a2:	89 c1                	mov    %eax,%ecx
  8029a4:	89 d8                	mov    %ebx,%eax
  8029a6:	f7 f5                	div    %ebp
  8029a8:	89 cf                	mov    %ecx,%edi
  8029aa:	89 fa                	mov    %edi,%edx
  8029ac:	83 c4 1c             	add    $0x1c,%esp
  8029af:	5b                   	pop    %ebx
  8029b0:	5e                   	pop    %esi
  8029b1:	5f                   	pop    %edi
  8029b2:	5d                   	pop    %ebp
  8029b3:	c3                   	ret    
  8029b4:	39 ce                	cmp    %ecx,%esi
  8029b6:	77 28                	ja     8029e0 <__udivdi3+0x7c>
  8029b8:	0f bd fe             	bsr    %esi,%edi
  8029bb:	83 f7 1f             	xor    $0x1f,%edi
  8029be:	75 40                	jne    802a00 <__udivdi3+0x9c>
  8029c0:	39 ce                	cmp    %ecx,%esi
  8029c2:	72 0a                	jb     8029ce <__udivdi3+0x6a>
  8029c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8029c8:	0f 87 9e 00 00 00    	ja     802a6c <__udivdi3+0x108>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	89 fa                	mov    %edi,%edx
  8029d5:	83 c4 1c             	add    $0x1c,%esp
  8029d8:	5b                   	pop    %ebx
  8029d9:	5e                   	pop    %esi
  8029da:	5f                   	pop    %edi
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	31 ff                	xor    %edi,%edi
  8029e2:	31 c0                	xor    %eax,%eax
  8029e4:	89 fa                	mov    %edi,%edx
  8029e6:	83 c4 1c             	add    $0x1c,%esp
  8029e9:	5b                   	pop    %ebx
  8029ea:	5e                   	pop    %esi
  8029eb:	5f                   	pop    %edi
  8029ec:	5d                   	pop    %ebp
  8029ed:	c3                   	ret    
  8029ee:	66 90                	xchg   %ax,%ax
  8029f0:	89 d8                	mov    %ebx,%eax
  8029f2:	f7 f7                	div    %edi
  8029f4:	31 ff                	xor    %edi,%edi
  8029f6:	89 fa                	mov    %edi,%edx
  8029f8:	83 c4 1c             	add    $0x1c,%esp
  8029fb:	5b                   	pop    %ebx
  8029fc:	5e                   	pop    %esi
  8029fd:	5f                   	pop    %edi
  8029fe:	5d                   	pop    %ebp
  8029ff:	c3                   	ret    
  802a00:	bd 20 00 00 00       	mov    $0x20,%ebp
  802a05:	89 eb                	mov    %ebp,%ebx
  802a07:	29 fb                	sub    %edi,%ebx
  802a09:	89 f9                	mov    %edi,%ecx
  802a0b:	d3 e6                	shl    %cl,%esi
  802a0d:	89 c5                	mov    %eax,%ebp
  802a0f:	88 d9                	mov    %bl,%cl
  802a11:	d3 ed                	shr    %cl,%ebp
  802a13:	89 e9                	mov    %ebp,%ecx
  802a15:	09 f1                	or     %esi,%ecx
  802a17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802a1b:	89 f9                	mov    %edi,%ecx
  802a1d:	d3 e0                	shl    %cl,%eax
  802a1f:	89 c5                	mov    %eax,%ebp
  802a21:	89 d6                	mov    %edx,%esi
  802a23:	88 d9                	mov    %bl,%cl
  802a25:	d3 ee                	shr    %cl,%esi
  802a27:	89 f9                	mov    %edi,%ecx
  802a29:	d3 e2                	shl    %cl,%edx
  802a2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a2f:	88 d9                	mov    %bl,%cl
  802a31:	d3 e8                	shr    %cl,%eax
  802a33:	09 c2                	or     %eax,%edx
  802a35:	89 d0                	mov    %edx,%eax
  802a37:	89 f2                	mov    %esi,%edx
  802a39:	f7 74 24 0c          	divl   0xc(%esp)
  802a3d:	89 d6                	mov    %edx,%esi
  802a3f:	89 c3                	mov    %eax,%ebx
  802a41:	f7 e5                	mul    %ebp
  802a43:	39 d6                	cmp    %edx,%esi
  802a45:	72 19                	jb     802a60 <__udivdi3+0xfc>
  802a47:	74 0b                	je     802a54 <__udivdi3+0xf0>
  802a49:	89 d8                	mov    %ebx,%eax
  802a4b:	31 ff                	xor    %edi,%edi
  802a4d:	e9 58 ff ff ff       	jmp    8029aa <__udivdi3+0x46>
  802a52:	66 90                	xchg   %ax,%ax
  802a54:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a58:	89 f9                	mov    %edi,%ecx
  802a5a:	d3 e2                	shl    %cl,%edx
  802a5c:	39 c2                	cmp    %eax,%edx
  802a5e:	73 e9                	jae    802a49 <__udivdi3+0xe5>
  802a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a63:	31 ff                	xor    %edi,%edi
  802a65:	e9 40 ff ff ff       	jmp    8029aa <__udivdi3+0x46>
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	31 c0                	xor    %eax,%eax
  802a6e:	e9 37 ff ff ff       	jmp    8029aa <__udivdi3+0x46>
  802a73:	90                   	nop

00802a74 <__umoddi3>:
  802a74:	55                   	push   %ebp
  802a75:	57                   	push   %edi
  802a76:	56                   	push   %esi
  802a77:	53                   	push   %ebx
  802a78:	83 ec 1c             	sub    $0x1c,%esp
  802a7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a93:	89 f3                	mov    %esi,%ebx
  802a95:	89 fa                	mov    %edi,%edx
  802a97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a9b:	89 34 24             	mov    %esi,(%esp)
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	75 1a                	jne    802abc <__umoddi3+0x48>
  802aa2:	39 f7                	cmp    %esi,%edi
  802aa4:	0f 86 a2 00 00 00    	jbe    802b4c <__umoddi3+0xd8>
  802aaa:	89 c8                	mov    %ecx,%eax
  802aac:	89 f2                	mov    %esi,%edx
  802aae:	f7 f7                	div    %edi
  802ab0:	89 d0                	mov    %edx,%eax
  802ab2:	31 d2                	xor    %edx,%edx
  802ab4:	83 c4 1c             	add    $0x1c,%esp
  802ab7:	5b                   	pop    %ebx
  802ab8:	5e                   	pop    %esi
  802ab9:	5f                   	pop    %edi
  802aba:	5d                   	pop    %ebp
  802abb:	c3                   	ret    
  802abc:	39 f0                	cmp    %esi,%eax
  802abe:	0f 87 ac 00 00 00    	ja     802b70 <__umoddi3+0xfc>
  802ac4:	0f bd e8             	bsr    %eax,%ebp
  802ac7:	83 f5 1f             	xor    $0x1f,%ebp
  802aca:	0f 84 ac 00 00 00    	je     802b7c <__umoddi3+0x108>
  802ad0:	bf 20 00 00 00       	mov    $0x20,%edi
  802ad5:	29 ef                	sub    %ebp,%edi
  802ad7:	89 fe                	mov    %edi,%esi
  802ad9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802add:	89 e9                	mov    %ebp,%ecx
  802adf:	d3 e0                	shl    %cl,%eax
  802ae1:	89 d7                	mov    %edx,%edi
  802ae3:	89 f1                	mov    %esi,%ecx
  802ae5:	d3 ef                	shr    %cl,%edi
  802ae7:	09 c7                	or     %eax,%edi
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	d3 e2                	shl    %cl,%edx
  802aed:	89 14 24             	mov    %edx,(%esp)
  802af0:	89 d8                	mov    %ebx,%eax
  802af2:	d3 e0                	shl    %cl,%eax
  802af4:	89 c2                	mov    %eax,%edx
  802af6:	8b 44 24 08          	mov    0x8(%esp),%eax
  802afa:	d3 e0                	shl    %cl,%eax
  802afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b00:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b04:	89 f1                	mov    %esi,%ecx
  802b06:	d3 e8                	shr    %cl,%eax
  802b08:	09 d0                	or     %edx,%eax
  802b0a:	d3 eb                	shr    %cl,%ebx
  802b0c:	89 da                	mov    %ebx,%edx
  802b0e:	f7 f7                	div    %edi
  802b10:	89 d3                	mov    %edx,%ebx
  802b12:	f7 24 24             	mull   (%esp)
  802b15:	89 c6                	mov    %eax,%esi
  802b17:	89 d1                	mov    %edx,%ecx
  802b19:	39 d3                	cmp    %edx,%ebx
  802b1b:	0f 82 87 00 00 00    	jb     802ba8 <__umoddi3+0x134>
  802b21:	0f 84 91 00 00 00    	je     802bb8 <__umoddi3+0x144>
  802b27:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b2b:	29 f2                	sub    %esi,%edx
  802b2d:	19 cb                	sbb    %ecx,%ebx
  802b2f:	89 d8                	mov    %ebx,%eax
  802b31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802b35:	d3 e0                	shl    %cl,%eax
  802b37:	89 e9                	mov    %ebp,%ecx
  802b39:	d3 ea                	shr    %cl,%edx
  802b3b:	09 d0                	or     %edx,%eax
  802b3d:	89 e9                	mov    %ebp,%ecx
  802b3f:	d3 eb                	shr    %cl,%ebx
  802b41:	89 da                	mov    %ebx,%edx
  802b43:	83 c4 1c             	add    $0x1c,%esp
  802b46:	5b                   	pop    %ebx
  802b47:	5e                   	pop    %esi
  802b48:	5f                   	pop    %edi
  802b49:	5d                   	pop    %ebp
  802b4a:	c3                   	ret    
  802b4b:	90                   	nop
  802b4c:	89 fd                	mov    %edi,%ebp
  802b4e:	85 ff                	test   %edi,%edi
  802b50:	75 0b                	jne    802b5d <__umoddi3+0xe9>
  802b52:	b8 01 00 00 00       	mov    $0x1,%eax
  802b57:	31 d2                	xor    %edx,%edx
  802b59:	f7 f7                	div    %edi
  802b5b:	89 c5                	mov    %eax,%ebp
  802b5d:	89 f0                	mov    %esi,%eax
  802b5f:	31 d2                	xor    %edx,%edx
  802b61:	f7 f5                	div    %ebp
  802b63:	89 c8                	mov    %ecx,%eax
  802b65:	f7 f5                	div    %ebp
  802b67:	89 d0                	mov    %edx,%eax
  802b69:	e9 44 ff ff ff       	jmp    802ab2 <__umoddi3+0x3e>
  802b6e:	66 90                	xchg   %ax,%ax
  802b70:	89 c8                	mov    %ecx,%eax
  802b72:	89 f2                	mov    %esi,%edx
  802b74:	83 c4 1c             	add    $0x1c,%esp
  802b77:	5b                   	pop    %ebx
  802b78:	5e                   	pop    %esi
  802b79:	5f                   	pop    %edi
  802b7a:	5d                   	pop    %ebp
  802b7b:	c3                   	ret    
  802b7c:	3b 04 24             	cmp    (%esp),%eax
  802b7f:	72 06                	jb     802b87 <__umoddi3+0x113>
  802b81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b85:	77 0f                	ja     802b96 <__umoddi3+0x122>
  802b87:	89 f2                	mov    %esi,%edx
  802b89:	29 f9                	sub    %edi,%ecx
  802b8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b8f:	89 14 24             	mov    %edx,(%esp)
  802b92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b96:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b9a:	8b 14 24             	mov    (%esp),%edx
  802b9d:	83 c4 1c             	add    $0x1c,%esp
  802ba0:	5b                   	pop    %ebx
  802ba1:	5e                   	pop    %esi
  802ba2:	5f                   	pop    %edi
  802ba3:	5d                   	pop    %ebp
  802ba4:	c3                   	ret    
  802ba5:	8d 76 00             	lea    0x0(%esi),%esi
  802ba8:	2b 04 24             	sub    (%esp),%eax
  802bab:	19 fa                	sbb    %edi,%edx
  802bad:	89 d1                	mov    %edx,%ecx
  802baf:	89 c6                	mov    %eax,%esi
  802bb1:	e9 71 ff ff ff       	jmp    802b27 <__umoddi3+0xb3>
  802bb6:	66 90                	xchg   %ax,%ax
  802bb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802bbc:	72 ea                	jb     802ba8 <__umoddi3+0x134>
  802bbe:	89 d9                	mov    %ebx,%ecx
  802bc0:	e9 62 ff ff ff       	jmp    802b27 <__umoddi3+0xb3>
