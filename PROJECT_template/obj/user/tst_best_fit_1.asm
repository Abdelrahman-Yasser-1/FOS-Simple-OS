
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 bc 0a 00 00       	call   800af2 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 82 27 00 00       	call   8027cc <sys_set_uheap_strategy>
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
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800095:	68 a0 2a 80 00       	push   $0x802aa0
  80009a:	6a 15                	push   $0x15
  80009c:	68 bc 2a 80 00       	push   $0x802abc
  8000a1:	e8 91 0b 00 00       	call   800c37 <_panic>
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
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c5:	e8 6e 22 00 00       	call   802338 <sys_calculate_free_frames>
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cd:	e8 e9 22 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8000d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d8:	89 c2                	mov    %eax,%edx
  8000da:	01 d2                	add    %edx,%edx
  8000dc:	01 d0                	add    %edx,%eax
  8000de:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	50                   	push   %eax
  8000e5:	e8 79 1b 00 00       	call   801c63 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f3:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 d4 2a 80 00       	push   $0x802ad4
  800102:	6a 23                	push   $0x23
  800104:	68 bc 2a 80 00       	push   $0x802abc
  800109:	e8 29 0b 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  80010e:	e8 a8 22 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800113:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800116:	3d 00 03 00 00       	cmp    $0x300,%eax
  80011b:	74 14                	je     800131 <_main+0xf9>
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	68 04 2b 80 00       	push   $0x802b04
  800125:	6a 25                	push   $0x25
  800127:	68 bc 2a 80 00       	push   $0x802abc
  80012c:	e8 06 0b 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800131:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800134:	e8 ff 21 00 00       	call   802338 <sys_calculate_free_frames>
  800139:	29 c3                	sub    %eax,%ebx
  80013b:	89 d8                	mov    %ebx,%eax
  80013d:	83 f8 01             	cmp    $0x1,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 21 2b 80 00       	push   $0x802b21
  80014a:	6a 26                	push   $0x26
  80014c:	68 bc 2a 80 00       	push   $0x802abc
  800151:	e8 e1 0a 00 00       	call   800c37 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 dd 21 00 00       	call   802338 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80015e:	e8 58 22 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	89 c2                	mov    %eax,%edx
  80016b:	01 d2                	add    %edx,%edx
  80016d:	01 d0                	add    %edx,%eax
  80016f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	50                   	push   %eax
  800176:	e8 e8 1a 00 00       	call   801c63 <malloc>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800181:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800184:	89 c1                	mov    %eax,%ecx
  800186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800189:	89 c2                	mov    %eax,%edx
  80018b:	01 d2                	add    %edx,%edx
  80018d:	01 d0                	add    %edx,%eax
  80018f:	05 00 00 00 80       	add    $0x80000000,%eax
  800194:	39 c1                	cmp    %eax,%ecx
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 d4 2a 80 00       	push   $0x802ad4
  8001a0:	6a 2c                	push   $0x2c
  8001a2:	68 bc 2a 80 00       	push   $0x802abc
  8001a7:	e8 8b 0a 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001ac:	e8 0a 22 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8001b1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b4:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001b9:	74 14                	je     8001cf <_main+0x197>
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	68 04 2b 80 00       	push   $0x802b04
  8001c3:	6a 2e                	push   $0x2e
  8001c5:	68 bc 2a 80 00       	push   $0x802abc
  8001ca:	e8 68 0a 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001d2:	e8 61 21 00 00       	call   802338 <sys_calculate_free_frames>
  8001d7:	29 c3                	sub    %eax,%ebx
  8001d9:	89 d8                	mov    %ebx,%eax
  8001db:	83 f8 01             	cmp    $0x1,%eax
  8001de:	74 14                	je     8001f4 <_main+0x1bc>
  8001e0:	83 ec 04             	sub    $0x4,%esp
  8001e3:	68 21 2b 80 00       	push   $0x802b21
  8001e8:	6a 2f                	push   $0x2f
  8001ea:	68 bc 2a 80 00       	push   $0x802abc
  8001ef:	e8 43 0a 00 00       	call   800c37 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f4:	e8 3f 21 00 00       	call   802338 <sys_calculate_free_frames>
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fc:	e8 ba 21 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800201:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800204:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 4e 1a 00 00       	call   801c63 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021e:	89 c1                	mov    %eax,%ecx
  800220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800223:	89 d0                	mov    %edx,%eax
  800225:	01 c0                	add    %eax,%eax
  800227:	01 d0                	add    %edx,%eax
  800229:	01 c0                	add    %eax,%eax
  80022b:	05 00 00 00 80       	add    $0x80000000,%eax
  800230:	39 c1                	cmp    %eax,%ecx
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 d4 2a 80 00       	push   $0x802ad4
  80023c:	6a 35                	push   $0x35
  80023e:	68 bc 2a 80 00       	push   $0x802abc
  800243:	e8 ef 09 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800248:	e8 6e 21 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80024d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800250:	3d 00 02 00 00       	cmp    $0x200,%eax
  800255:	74 14                	je     80026b <_main+0x233>
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	68 04 2b 80 00       	push   $0x802b04
  80025f:	6a 37                	push   $0x37
  800261:	68 bc 2a 80 00       	push   $0x802abc
  800266:	e8 cc 09 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80026b:	e8 c8 20 00 00       	call   802338 <sys_calculate_free_frames>
  800270:	89 c2                	mov    %eax,%edx
  800272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800275:	39 c2                	cmp    %eax,%edx
  800277:	74 14                	je     80028d <_main+0x255>
  800279:	83 ec 04             	sub    $0x4,%esp
  80027c:	68 21 2b 80 00       	push   $0x802b21
  800281:	6a 38                	push   $0x38
  800283:	68 bc 2a 80 00       	push   $0x802abc
  800288:	e8 aa 09 00 00       	call   800c37 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80028d:	e8 a6 20 00 00       	call   802338 <sys_calculate_free_frames>
  800292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800295:	e8 21 21 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  80029d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002a0:	01 c0                	add    %eax,%eax
  8002a2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	50                   	push   %eax
  8002a9:	e8 b5 19 00 00       	call   801c63 <malloc>
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002bc:	c1 e0 03             	shl    $0x3,%eax
  8002bf:	05 00 00 00 80       	add    $0x80000000,%eax
  8002c4:	39 c2                	cmp    %eax,%edx
  8002c6:	74 14                	je     8002dc <_main+0x2a4>
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	68 d4 2a 80 00       	push   $0x802ad4
  8002d0:	6a 3e                	push   $0x3e
  8002d2:	68 bc 2a 80 00       	push   $0x802abc
  8002d7:	e8 5b 09 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002dc:	e8 da 20 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8002e1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002e4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 04 2b 80 00       	push   $0x802b04
  8002f3:	6a 40                	push   $0x40
  8002f5:	68 bc 2a 80 00       	push   $0x802abc
  8002fa:	e8 38 09 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800302:	e8 31 20 00 00       	call   802338 <sys_calculate_free_frames>
  800307:	29 c3                	sub    %eax,%ebx
  800309:	89 d8                	mov    %ebx,%eax
  80030b:	83 f8 01             	cmp    $0x1,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 21 2b 80 00       	push   $0x802b21
  800318:	6a 41                	push   $0x41
  80031a:	68 bc 2a 80 00       	push   $0x802abc
  80031f:	e8 13 09 00 00       	call   800c37 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800324:	e8 0f 20 00 00       	call   802338 <sys_calculate_free_frames>
  800329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80032c:	e8 8a 20 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800331:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800337:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	50                   	push   %eax
  80033e:	e8 20 19 00 00       	call   801c63 <malloc>
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  800349:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80034c:	89 c1                	mov    %eax,%ecx
  80034e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800351:	89 d0                	mov    %edx,%eax
  800353:	c1 e0 02             	shl    $0x2,%eax
  800356:	01 d0                	add    %edx,%eax
  800358:	01 c0                	add    %eax,%eax
  80035a:	05 00 00 00 80       	add    $0x80000000,%eax
  80035f:	39 c1                	cmp    %eax,%ecx
  800361:	74 14                	je     800377 <_main+0x33f>
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 d4 2a 80 00       	push   $0x802ad4
  80036b:	6a 47                	push   $0x47
  80036d:	68 bc 2a 80 00       	push   $0x802abc
  800372:	e8 c0 08 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800377:	e8 3f 20 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80037c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80037f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 04 2b 80 00       	push   $0x802b04
  80038e:	6a 49                	push   $0x49
  800390:	68 bc 2a 80 00       	push   $0x802abc
  800395:	e8 9d 08 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80039a:	e8 99 1f 00 00       	call   802338 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 21 2b 80 00       	push   $0x802b21
  8003b0:	6a 4a                	push   $0x4a
  8003b2:	68 bc 2a 80 00       	push   $0x802abc
  8003b7:	e8 7b 08 00 00       	call   800c37 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003bc:	e8 77 1f 00 00       	call   802338 <sys_calculate_free_frames>
  8003c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c4:	e8 f2 1f 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8003c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	50                   	push   %eax
  8003d6:	e8 88 18 00 00       	call   801c63 <malloc>
  8003db:	83 c4 10             	add    $0x10,%esp
  8003de:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e4:	89 c1                	mov    %eax,%ecx
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	01 c0                	add    %eax,%eax
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f9:	39 c1                	cmp    %eax,%ecx
  8003fb:	74 14                	je     800411 <_main+0x3d9>
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	68 d4 2a 80 00       	push   $0x802ad4
  800405:	6a 50                	push   $0x50
  800407:	68 bc 2a 80 00       	push   $0x802abc
  80040c:	e8 26 08 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800411:	e8 a5 1f 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800416:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800419:	3d 00 01 00 00       	cmp    $0x100,%eax
  80041e:	74 14                	je     800434 <_main+0x3fc>
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	68 04 2b 80 00       	push   $0x802b04
  800428:	6a 52                	push   $0x52
  80042a:	68 bc 2a 80 00       	push   $0x802abc
  80042f:	e8 03 08 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800434:	e8 ff 1e 00 00       	call   802338 <sys_calculate_free_frames>
  800439:	89 c2                	mov    %eax,%edx
  80043b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043e:	39 c2                	cmp    %eax,%edx
  800440:	74 14                	je     800456 <_main+0x41e>
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 21 2b 80 00       	push   $0x802b21
  80044a:	6a 53                	push   $0x53
  80044c:	68 bc 2a 80 00       	push   $0x802abc
  800451:	e8 e1 07 00 00       	call   800c37 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800456:	e8 dd 1e 00 00       	call   802338 <sys_calculate_free_frames>
  80045b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045e:	e8 58 1f 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800469:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80046c:	83 ec 0c             	sub    $0xc,%esp
  80046f:	50                   	push   %eax
  800470:	e8 ee 17 00 00       	call   801c63 <malloc>
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80047b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047e:	89 c1                	mov    %eax,%ecx
  800480:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 02             	shl    $0x2,%eax
  80048c:	05 00 00 00 80       	add    $0x80000000,%eax
  800491:	39 c1                	cmp    %eax,%ecx
  800493:	74 14                	je     8004a9 <_main+0x471>
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	68 d4 2a 80 00       	push   $0x802ad4
  80049d:	6a 59                	push   $0x59
  80049f:	68 bc 2a 80 00       	push   $0x802abc
  8004a4:	e8 8e 07 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004a9:	e8 0d 1f 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8004ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004b1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004b6:	74 14                	je     8004cc <_main+0x494>
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	68 04 2b 80 00       	push   $0x802b04
  8004c0:	6a 5b                	push   $0x5b
  8004c2:	68 bc 2a 80 00       	push   $0x802abc
  8004c7:	e8 6b 07 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004cc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004cf:	e8 64 1e 00 00       	call   802338 <sys_calculate_free_frames>
  8004d4:	29 c3                	sub    %eax,%ebx
  8004d6:	89 d8                	mov    %ebx,%eax
  8004d8:	83 f8 01             	cmp    $0x1,%eax
  8004db:	74 14                	je     8004f1 <_main+0x4b9>
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	68 21 2b 80 00       	push   $0x802b21
  8004e5:	6a 5c                	push   $0x5c
  8004e7:	68 bc 2a 80 00       	push   $0x802abc
  8004ec:	e8 46 07 00 00       	call   800c37 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8004f1:	e8 42 1e 00 00       	call   802338 <sys_calculate_free_frames>
  8004f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f9:	e8 bd 1e 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8004fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800504:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800507:	83 ec 0c             	sub    $0xc,%esp
  80050a:	50                   	push   %eax
  80050b:	e8 53 17 00 00       	call   801c63 <malloc>
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800516:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	c1 e0 02             	shl    $0x2,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	05 00 00 00 80       	add    $0x80000000,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 d4 2a 80 00       	push   $0x802ad4
  80053a:	6a 62                	push   $0x62
  80053c:	68 bc 2a 80 00       	push   $0x802abc
  800541:	e8 f1 06 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800546:	e8 70 1e 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80054b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80054e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800553:	74 14                	je     800569 <_main+0x531>
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 04 2b 80 00       	push   $0x802b04
  80055d:	6a 64                	push   $0x64
  80055f:	68 bc 2a 80 00       	push   $0x802abc
  800564:	e8 ce 06 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800569:	e8 ca 1d 00 00       	call   802338 <sys_calculate_free_frames>
  80056e:	89 c2                	mov    %eax,%edx
  800570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800573:	39 c2                	cmp    %eax,%edx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 21 2b 80 00       	push   $0x802b21
  80057f:	6a 65                	push   $0x65
  800581:	68 bc 2a 80 00       	push   $0x802abc
  800586:	e8 ac 06 00 00       	call   800c37 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 a8 1d 00 00       	call   802338 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 23 1e 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  80059b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 eb 18 00 00       	call   801e92 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005aa:	e8 0c 1e 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005bb:	74 14                	je     8005d1 <_main+0x599>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 34 2b 80 00       	push   $0x802b34
  8005c5:	6a 6f                	push   $0x6f
  8005c7:	68 bc 2a 80 00       	push   $0x802abc
  8005cc:	e8 66 06 00 00       	call   800c37 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005d1:	e8 62 1d 00 00       	call   802338 <sys_calculate_free_frames>
  8005d6:	89 c2                	mov    %eax,%edx
  8005d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	74 14                	je     8005f3 <_main+0x5bb>
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	68 4b 2b 80 00       	push   $0x802b4b
  8005e7:	6a 70                	push   $0x70
  8005e9:	68 bc 2a 80 00       	push   $0x802abc
  8005ee:	e8 44 06 00 00       	call   800c37 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005f3:	e8 40 1d 00 00       	call   802338 <sys_calculate_free_frames>
  8005f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005fb:	e8 bb 1d 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800600:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800603:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800606:	83 ec 0c             	sub    $0xc,%esp
  800609:	50                   	push   %eax
  80060a:	e8 83 18 00 00       	call   801e92 <free>
  80060f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800612:	e8 a4 1d 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800617:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061a:	29 c2                	sub    %eax,%edx
  80061c:	89 d0                	mov    %edx,%eax
  80061e:	3d 00 02 00 00       	cmp    $0x200,%eax
  800623:	74 14                	je     800639 <_main+0x601>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 34 2b 80 00       	push   $0x802b34
  80062d:	6a 77                	push   $0x77
  80062f:	68 bc 2a 80 00       	push   $0x802abc
  800634:	e8 fe 05 00 00       	call   800c37 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800639:	e8 fa 1c 00 00       	call   802338 <sys_calculate_free_frames>
  80063e:	89 c2                	mov    %eax,%edx
  800640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800643:	39 c2                	cmp    %eax,%edx
  800645:	74 14                	je     80065b <_main+0x623>
  800647:	83 ec 04             	sub    $0x4,%esp
  80064a:	68 4b 2b 80 00       	push   $0x802b4b
  80064f:	6a 78                	push   $0x78
  800651:	68 bc 2a 80 00       	push   $0x802abc
  800656:	e8 dc 05 00 00       	call   800c37 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80065b:	e8 d8 1c 00 00       	call   802338 <sys_calculate_free_frames>
  800660:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800663:	e8 53 1d 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80066b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80066e:	83 ec 0c             	sub    $0xc,%esp
  800671:	50                   	push   %eax
  800672:	e8 1b 18 00 00       	call   801e92 <free>
  800677:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80067a:	e8 3c 1d 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80067f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800682:	29 c2                	sub    %eax,%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	3d 00 01 00 00       	cmp    $0x100,%eax
  80068b:	74 14                	je     8006a1 <_main+0x669>
  80068d:	83 ec 04             	sub    $0x4,%esp
  800690:	68 34 2b 80 00       	push   $0x802b34
  800695:	6a 7f                	push   $0x7f
  800697:	68 bc 2a 80 00       	push   $0x802abc
  80069c:	e8 96 05 00 00       	call   800c37 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006a1:	e8 92 1c 00 00       	call   802338 <sys_calculate_free_frames>
  8006a6:	89 c2                	mov    %eax,%edx
  8006a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ab:	39 c2                	cmp    %eax,%edx
  8006ad:	74 17                	je     8006c6 <_main+0x68e>
  8006af:	83 ec 04             	sub    $0x4,%esp
  8006b2:	68 4b 2b 80 00       	push   $0x802b4b
  8006b7:	68 80 00 00 00       	push   $0x80
  8006bc:	68 bc 2a 80 00       	push   $0x802abc
  8006c1:	e8 71 05 00 00       	call   800c37 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006c6:	e8 6d 1c 00 00       	call   802338 <sys_calculate_free_frames>
  8006cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ce:	e8 e8 1c 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d9:	c1 e0 09             	shl    $0x9,%eax
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	50                   	push   %eax
  8006e0:	e8 7e 15 00 00       	call   801c63 <malloc>
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8006eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006ee:	89 c1                	mov    %eax,%ecx
  8006f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006f3:	89 d0                	mov    %edx,%eax
  8006f5:	c1 e0 02             	shl    $0x2,%eax
  8006f8:	01 d0                	add    %edx,%eax
  8006fa:	01 c0                	add    %eax,%eax
  8006fc:	01 d0                	add    %edx,%eax
  8006fe:	05 00 00 00 80       	add    $0x80000000,%eax
  800703:	39 c1                	cmp    %eax,%ecx
  800705:	74 17                	je     80071e <_main+0x6e6>
  800707:	83 ec 04             	sub    $0x4,%esp
  80070a:	68 d4 2a 80 00       	push   $0x802ad4
  80070f:	68 89 00 00 00       	push   $0x89
  800714:	68 bc 2a 80 00       	push   $0x802abc
  800719:	e8 19 05 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  80071e:	e8 98 1c 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800723:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800726:	3d 80 00 00 00       	cmp    $0x80,%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	83 ec 04             	sub    $0x4,%esp
  800730:	68 04 2b 80 00       	push   $0x802b04
  800735:	68 8b 00 00 00       	push   $0x8b
  80073a:	68 bc 2a 80 00       	push   $0x802abc
  80073f:	e8 f3 04 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800744:	e8 ef 1b 00 00       	call   802338 <sys_calculate_free_frames>
  800749:	89 c2                	mov    %eax,%edx
  80074b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80074e:	39 c2                	cmp    %eax,%edx
  800750:	74 17                	je     800769 <_main+0x731>
  800752:	83 ec 04             	sub    $0x4,%esp
  800755:	68 21 2b 80 00       	push   $0x802b21
  80075a:	68 8c 00 00 00       	push   $0x8c
  80075f:	68 bc 2a 80 00       	push   $0x802abc
  800764:	e8 ce 04 00 00       	call   800c37 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800769:	e8 ca 1b 00 00       	call   802338 <sys_calculate_free_frames>
  80076e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800771:	e8 45 1c 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800776:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  800779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	50                   	push   %eax
  800783:	e8 db 14 00 00       	call   801c63 <malloc>
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80078e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800791:	89 c2                	mov    %eax,%edx
  800793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800796:	c1 e0 03             	shl    $0x3,%eax
  800799:	05 00 00 00 80       	add    $0x80000000,%eax
  80079e:	39 c2                	cmp    %eax,%edx
  8007a0:	74 17                	je     8007b9 <_main+0x781>
  8007a2:	83 ec 04             	sub    $0x4,%esp
  8007a5:	68 d4 2a 80 00       	push   $0x802ad4
  8007aa:	68 92 00 00 00       	push   $0x92
  8007af:	68 bc 2a 80 00       	push   $0x802abc
  8007b4:	e8 7e 04 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007b9:	e8 fd 1b 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8007be:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007c1:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007c6:	74 17                	je     8007df <_main+0x7a7>
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	68 04 2b 80 00       	push   $0x802b04
  8007d0:	68 94 00 00 00       	push   $0x94
  8007d5:	68 bc 2a 80 00       	push   $0x802abc
  8007da:	e8 58 04 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007df:	e8 54 1b 00 00       	call   802338 <sys_calculate_free_frames>
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007e9:	39 c2                	cmp    %eax,%edx
  8007eb:	74 17                	je     800804 <_main+0x7cc>
  8007ed:	83 ec 04             	sub    $0x4,%esp
  8007f0:	68 21 2b 80 00       	push   $0x802b21
  8007f5:	68 95 00 00 00       	push   $0x95
  8007fa:	68 bc 2a 80 00       	push   $0x802abc
  8007ff:	e8 33 04 00 00       	call   800c37 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800804:	e8 2f 1b 00 00       	call   802338 <sys_calculate_free_frames>
  800809:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80080c:	e8 aa 1b 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  800814:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800817:	89 d0                	mov    %edx,%eax
  800819:	c1 e0 08             	shl    $0x8,%eax
  80081c:	29 d0                	sub    %edx,%eax
  80081e:	83 ec 0c             	sub    $0xc,%esp
  800821:	50                   	push   %eax
  800822:	e8 3c 14 00 00       	call   801c63 <malloc>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  80082d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800830:	89 c1                	mov    %eax,%ecx
  800832:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800835:	89 d0                	mov    %edx,%eax
  800837:	c1 e0 02             	shl    $0x2,%eax
  80083a:	01 d0                	add    %edx,%eax
  80083c:	01 c0                	add    %eax,%eax
  80083e:	01 d0                	add    %edx,%eax
  800840:	89 c2                	mov    %eax,%edx
  800842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800845:	c1 e0 09             	shl    $0x9,%eax
  800848:	01 d0                	add    %edx,%eax
  80084a:	05 00 00 00 80       	add    $0x80000000,%eax
  80084f:	39 c1                	cmp    %eax,%ecx
  800851:	74 17                	je     80086a <_main+0x832>
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	68 d4 2a 80 00       	push   $0x802ad4
  80085b:	68 9b 00 00 00       	push   $0x9b
  800860:	68 bc 2a 80 00       	push   $0x802abc
  800865:	e8 cd 03 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  80086a:	e8 4c 1b 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80086f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800872:	83 f8 40             	cmp    $0x40,%eax
  800875:	74 17                	je     80088e <_main+0x856>
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 04 2b 80 00       	push   $0x802b04
  80087f:	68 9d 00 00 00       	push   $0x9d
  800884:	68 bc 2a 80 00       	push   $0x802abc
  800889:	e8 a9 03 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80088e:	e8 a5 1a 00 00       	call   802338 <sys_calculate_free_frames>
  800893:	89 c2                	mov    %eax,%edx
  800895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	74 17                	je     8008b3 <_main+0x87b>
  80089c:	83 ec 04             	sub    $0x4,%esp
  80089f:	68 21 2b 80 00       	push   $0x802b21
  8008a4:	68 9e 00 00 00       	push   $0x9e
  8008a9:	68 bc 2a 80 00       	push   $0x802abc
  8008ae:	e8 84 03 00 00       	call   800c37 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008b3:	e8 80 1a 00 00       	call   802338 <sys_calculate_free_frames>
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008bb:	e8 fb 1a 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8008c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c6:	c1 e0 02             	shl    $0x2,%eax
  8008c9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 8e 13 00 00       	call   801c63 <malloc>
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008de:	89 c1                	mov    %eax,%ecx
  8008e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008e3:	89 d0                	mov    %edx,%eax
  8008e5:	01 c0                	add    %eax,%eax
  8008e7:	01 d0                	add    %edx,%eax
  8008e9:	01 c0                	add    %eax,%eax
  8008eb:	01 d0                	add    %edx,%eax
  8008ed:	01 c0                	add    %eax,%eax
  8008ef:	05 00 00 00 80       	add    $0x80000000,%eax
  8008f4:	39 c1                	cmp    %eax,%ecx
  8008f6:	74 17                	je     80090f <_main+0x8d7>
  8008f8:	83 ec 04             	sub    $0x4,%esp
  8008fb:	68 d4 2a 80 00       	push   $0x802ad4
  800900:	68 a4 00 00 00       	push   $0xa4
  800905:	68 bc 2a 80 00       	push   $0x802abc
  80090a:	e8 28 03 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  80090f:	e8 a7 1a 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800914:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800917:	3d 00 04 00 00       	cmp    $0x400,%eax
  80091c:	74 17                	je     800935 <_main+0x8fd>
  80091e:	83 ec 04             	sub    $0x4,%esp
  800921:	68 04 2b 80 00       	push   $0x802b04
  800926:	68 a6 00 00 00       	push   $0xa6
  80092b:	68 bc 2a 80 00       	push   $0x802abc
  800930:	e8 02 03 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  800935:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800938:	e8 fb 19 00 00       	call   802338 <sys_calculate_free_frames>
  80093d:	29 c3                	sub    %eax,%ebx
  80093f:	89 d8                	mov    %ebx,%eax
  800941:	83 f8 01             	cmp    $0x1,%eax
  800944:	74 17                	je     80095d <_main+0x925>
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	68 21 2b 80 00       	push   $0x802b21
  80094e:	68 a7 00 00 00       	push   $0xa7
  800953:	68 bc 2a 80 00       	push   $0x802abc
  800958:	e8 da 02 00 00       	call   800c37 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  80095d:	e8 d6 19 00 00       	call   802338 <sys_calculate_free_frames>
  800962:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800965:	e8 51 1a 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  80096a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  80096d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	50                   	push   %eax
  800974:	e8 19 15 00 00       	call   801e92 <free>
  800979:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80097c:	e8 3a 1a 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800981:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800984:	29 c2                	sub    %eax,%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	3d 00 01 00 00       	cmp    $0x100,%eax
  80098d:	74 17                	je     8009a6 <_main+0x96e>
  80098f:	83 ec 04             	sub    $0x4,%esp
  800992:	68 34 2b 80 00       	push   $0x802b34
  800997:	68 b1 00 00 00       	push   $0xb1
  80099c:	68 bc 2a 80 00       	push   $0x802abc
  8009a1:	e8 91 02 00 00       	call   800c37 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009a6:	e8 8d 19 00 00       	call   802338 <sys_calculate_free_frames>
  8009ab:	89 c2                	mov    %eax,%edx
  8009ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	74 17                	je     8009cb <_main+0x993>
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	68 4b 2b 80 00       	push   $0x802b4b
  8009bc:	68 b2 00 00 00       	push   $0xb2
  8009c1:	68 bc 2a 80 00       	push   $0x802abc
  8009c6:	e8 6c 02 00 00       	call   800c37 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 68 19 00 00       	call   802338 <sys_calculate_free_frames>
  8009d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 e3 19 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009de:	83 ec 0c             	sub    $0xc,%esp
  8009e1:	50                   	push   %eax
  8009e2:	e8 ab 14 00 00       	call   801e92 <free>
  8009e7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  8009ea:	e8 cc 19 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  8009ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f2:	29 c2                	sub    %eax,%edx
  8009f4:	89 d0                	mov    %edx,%eax
  8009f6:	3d 80 00 00 00       	cmp    $0x80,%eax
  8009fb:	74 17                	je     800a14 <_main+0x9dc>
  8009fd:	83 ec 04             	sub    $0x4,%esp
  800a00:	68 34 2b 80 00       	push   $0x802b34
  800a05:	68 b9 00 00 00       	push   $0xb9
  800a0a:	68 bc 2a 80 00       	push   $0x802abc
  800a0f:	e8 23 02 00 00       	call   800c37 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a14:	e8 1f 19 00 00       	call   802338 <sys_calculate_free_frames>
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a1e:	39 c2                	cmp    %eax,%edx
  800a20:	74 17                	je     800a39 <_main+0xa01>
  800a22:	83 ec 04             	sub    $0x4,%esp
  800a25:	68 4b 2b 80 00       	push   $0x802b4b
  800a2a:	68 ba 00 00 00       	push   $0xba
  800a2f:	68 bc 2a 80 00       	push   $0x802abc
  800a34:	e8 fe 01 00 00       	call   800c37 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a39:	e8 fa 18 00 00       	call   802338 <sys_calculate_free_frames>
  800a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a41:	e8 75 19 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4c:	01 c0                	add    %eax,%eax
  800a4e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	50                   	push   %eax
  800a55:	e8 09 12 00 00       	call   801c63 <malloc>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a63:	89 c1                	mov    %eax,%ecx
  800a65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a68:	89 d0                	mov    %edx,%eax
  800a6a:	c1 e0 03             	shl    $0x3,%eax
  800a6d:	01 d0                	add    %edx,%eax
  800a6f:	05 00 00 00 80       	add    $0x80000000,%eax
  800a74:	39 c1                	cmp    %eax,%ecx
  800a76:	74 17                	je     800a8f <_main+0xa57>
  800a78:	83 ec 04             	sub    $0x4,%esp
  800a7b:	68 d4 2a 80 00       	push   $0x802ad4
  800a80:	68 c3 00 00 00       	push   $0xc3
  800a85:	68 bc 2a 80 00       	push   $0x802abc
  800a8a:	e8 a8 01 00 00       	call   800c37 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800a8f:	e8 27 19 00 00       	call   8023bb <sys_pf_calculate_allocated_pages>
  800a94:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a97:	3d 00 02 00 00       	cmp    $0x200,%eax
  800a9c:	74 17                	je     800ab5 <_main+0xa7d>
  800a9e:	83 ec 04             	sub    $0x4,%esp
  800aa1:	68 04 2b 80 00       	push   $0x802b04
  800aa6:	68 c5 00 00 00       	push   $0xc5
  800aab:	68 bc 2a 80 00       	push   $0x802abc
  800ab0:	e8 82 01 00 00       	call   800c37 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800ab5:	e8 7e 18 00 00       	call   802338 <sys_calculate_free_frames>
  800aba:	89 c2                	mov    %eax,%edx
  800abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800abf:	39 c2                	cmp    %eax,%edx
  800ac1:	74 17                	je     800ada <_main+0xaa2>
  800ac3:	83 ec 04             	sub    $0x4,%esp
  800ac6:	68 21 2b 80 00       	push   $0x802b21
  800acb:	68 c6 00 00 00       	push   $0xc6
  800ad0:	68 bc 2a 80 00       	push   $0x802abc
  800ad5:	e8 5d 01 00 00       	call   800c37 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800ada:	83 ec 0c             	sub    $0xc,%esp
  800add:	68 58 2b 80 00       	push   $0x802b58
  800ae2:	e8 f2 03 00 00       	call   800ed9 <cprintf>
  800ae7:	83 c4 10             	add    $0x10,%esp

	return;
  800aea:	90                   	nop
}
  800aeb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aee:	5b                   	pop    %ebx
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800af8:	e8 70 17 00 00       	call   80226d <sys_getenvindex>
  800afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	c1 e0 03             	shl    $0x3,%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b11:	01 c8                	add    %ecx,%eax
  800b13:	01 c0                	add    %eax,%eax
  800b15:	01 d0                	add    %edx,%eax
  800b17:	01 c0                	add    %eax,%eax
  800b19:	01 d0                	add    %edx,%eax
  800b1b:	89 c2                	mov    %eax,%edx
  800b1d:	c1 e2 05             	shl    $0x5,%edx
  800b20:	29 c2                	sub    %eax,%edx
  800b22:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800b31:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b36:	a1 20 40 80 00       	mov    0x804020,%eax
  800b3b:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800b41:	84 c0                	test   %al,%al
  800b43:	74 0f                	je     800b54 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800b45:	a1 20 40 80 00       	mov    0x804020,%eax
  800b4a:	05 40 3c 01 00       	add    $0x13c40,%eax
  800b4f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	7e 0a                	jle    800b64 <libmain+0x72>
		binaryname = argv[0];
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	e8 c6 f4 ff ff       	call   800038 <_main>
  800b72:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b75:	e8 8e 18 00 00       	call   802408 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7a:	83 ec 0c             	sub    $0xc,%esp
  800b7d:	68 b8 2b 80 00       	push   $0x802bb8
  800b82:	e8 52 03 00 00       	call   800ed9 <cprintf>
  800b87:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8a:	a1 20 40 80 00       	mov    0x804020,%eax
  800b8f:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800b95:	a1 20 40 80 00       	mov    0x804020,%eax
  800b9a:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800ba0:	83 ec 04             	sub    $0x4,%esp
  800ba3:	52                   	push   %edx
  800ba4:	50                   	push   %eax
  800ba5:	68 e0 2b 80 00       	push   $0x802be0
  800baa:	e8 2a 03 00 00       	call   800ed9 <cprintf>
  800baf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800bb2:	a1 20 40 80 00       	mov    0x804020,%eax
  800bb7:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  800bbd:	a1 20 40 80 00       	mov    0x804020,%eax
  800bc2:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800bc8:	83 ec 04             	sub    $0x4,%esp
  800bcb:	52                   	push   %edx
  800bcc:	50                   	push   %eax
  800bcd:	68 08 2c 80 00       	push   $0x802c08
  800bd2:	e8 02 03 00 00       	call   800ed9 <cprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bda:	a1 20 40 80 00       	mov    0x804020,%eax
  800bdf:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	50                   	push   %eax
  800be9:	68 49 2c 80 00       	push   $0x802c49
  800bee:	e8 e6 02 00 00       	call   800ed9 <cprintf>
  800bf3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800bf6:	83 ec 0c             	sub    $0xc,%esp
  800bf9:	68 b8 2b 80 00       	push   $0x802bb8
  800bfe:	e8 d6 02 00 00       	call   800ed9 <cprintf>
  800c03:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c06:	e8 17 18 00 00       	call   802422 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c0b:	e8 19 00 00 00       	call   800c29 <exit>
}
  800c10:	90                   	nop
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	6a 00                	push   $0x0
  800c1e:	e8 16 16 00 00       	call   802239 <sys_env_destroy>
  800c23:	83 c4 10             	add    $0x10,%esp
}
  800c26:	90                   	nop
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <exit>:

void
exit(void)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800c2f:	e8 6b 16 00 00       	call   80229f <sys_env_exit>
}
  800c34:	90                   	nop
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c3d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c40:	83 c0 04             	add    $0x4,%eax
  800c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c46:	a1 18 41 80 00       	mov    0x804118,%eax
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	74 16                	je     800c65 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c4f:	a1 18 41 80 00       	mov    0x804118,%eax
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	50                   	push   %eax
  800c58:	68 60 2c 80 00       	push   $0x802c60
  800c5d:	e8 77 02 00 00       	call   800ed9 <cprintf>
  800c62:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c65:	a1 00 40 80 00       	mov    0x804000,%eax
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	ff 75 08             	pushl  0x8(%ebp)
  800c70:	50                   	push   %eax
  800c71:	68 65 2c 80 00       	push   $0x802c65
  800c76:	e8 5e 02 00 00       	call   800ed9 <cprintf>
  800c7b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 f4             	pushl  -0xc(%ebp)
  800c87:	50                   	push   %eax
  800c88:	e8 e1 01 00 00       	call   800e6e <vcprintf>
  800c8d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	6a 00                	push   $0x0
  800c95:	68 81 2c 80 00       	push   $0x802c81
  800c9a:	e8 cf 01 00 00       	call   800e6e <vcprintf>
  800c9f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ca2:	e8 82 ff ff ff       	call   800c29 <exit>

	// should not return here
	while (1) ;
  800ca7:	eb fe                	jmp    800ca7 <_panic+0x70>

00800ca9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800caf:	a1 20 40 80 00       	mov    0x804020,%eax
  800cb4:	8b 50 74             	mov    0x74(%eax),%edx
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	39 c2                	cmp    %eax,%edx
  800cbc:	74 14                	je     800cd2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	68 84 2c 80 00       	push   $0x802c84
  800cc6:	6a 26                	push   $0x26
  800cc8:	68 d0 2c 80 00       	push   $0x802cd0
  800ccd:	e8 65 ff ff ff       	call   800c37 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800cd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce0:	e9 b6 00 00 00       	jmp    800d9b <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	01 d0                	add    %edx,%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	75 08                	jne    800d02 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800cfa:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800cfd:	e9 96 00 00 00       	jmp    800d98 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800d02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d10:	eb 5d                	jmp    800d6f <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d12:	a1 20 40 80 00       	mov    0x804020,%eax
  800d17:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d20:	c1 e2 04             	shl    $0x4,%edx
  800d23:	01 d0                	add    %edx,%eax
  800d25:	8a 40 04             	mov    0x4(%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 40                	jne    800d6c <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d2c:	a1 20 40 80 00       	mov    0x804020,%eax
  800d31:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800d37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d3a:	c1 e2 04             	shl    $0x4,%edx
  800d3d:	01 d0                	add    %edx,%eax
  800d3f:	8b 00                	mov    (%eax),%eax
  800d41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d4c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d51:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	01 c8                	add    %ecx,%eax
  800d5d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d5f:	39 c2                	cmp    %eax,%edx
  800d61:	75 09                	jne    800d6c <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800d63:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d6a:	eb 12                	jmp    800d7e <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d6c:	ff 45 e8             	incl   -0x18(%ebp)
  800d6f:	a1 20 40 80 00       	mov    0x804020,%eax
  800d74:	8b 50 74             	mov    0x74(%eax),%edx
  800d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d7a:	39 c2                	cmp    %eax,%edx
  800d7c:	77 94                	ja     800d12 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d82:	75 14                	jne    800d98 <CheckWSWithoutLastIndex+0xef>
			panic(
  800d84:	83 ec 04             	sub    $0x4,%esp
  800d87:	68 dc 2c 80 00       	push   $0x802cdc
  800d8c:	6a 3a                	push   $0x3a
  800d8e:	68 d0 2c 80 00       	push   $0x802cd0
  800d93:	e8 9f fe ff ff       	call   800c37 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800d98:	ff 45 f0             	incl   -0x10(%ebp)
  800d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800da1:	0f 8c 3e ff ff ff    	jl     800ce5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800da7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800db5:	eb 20                	jmp    800dd7 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800db7:	a1 20 40 80 00       	mov    0x804020,%eax
  800dbc:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800dc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dc5:	c1 e2 04             	shl    $0x4,%edx
  800dc8:	01 d0                	add    %edx,%eax
  800dca:	8a 40 04             	mov    0x4(%eax),%al
  800dcd:	3c 01                	cmp    $0x1,%al
  800dcf:	75 03                	jne    800dd4 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800dd1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dd4:	ff 45 e0             	incl   -0x20(%ebp)
  800dd7:	a1 20 40 80 00       	mov    0x804020,%eax
  800ddc:	8b 50 74             	mov    0x74(%eax),%edx
  800ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800de2:	39 c2                	cmp    %eax,%edx
  800de4:	77 d1                	ja     800db7 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800dec:	74 14                	je     800e02 <CheckWSWithoutLastIndex+0x159>
		panic(
  800dee:	83 ec 04             	sub    $0x4,%esp
  800df1:	68 30 2d 80 00       	push   $0x802d30
  800df6:	6a 44                	push   $0x44
  800df8:	68 d0 2c 80 00       	push   $0x802cd0
  800dfd:	e8 35 fe ff ff       	call   800c37 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e02:	90                   	nop
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	8b 00                	mov    (%eax),%eax
  800e10:	8d 48 01             	lea    0x1(%eax),%ecx
  800e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e16:	89 0a                	mov    %ecx,(%edx)
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	88 d1                	mov    %dl,%cl
  800e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e20:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8b 00                	mov    (%eax),%eax
  800e29:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e2e:	75 2c                	jne    800e5c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e30:	a0 24 40 80 00       	mov    0x804024,%al
  800e35:	0f b6 c0             	movzbl %al,%eax
  800e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3b:	8b 12                	mov    (%edx),%edx
  800e3d:	89 d1                	mov    %edx,%ecx
  800e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e42:	83 c2 08             	add    $0x8,%edx
  800e45:	83 ec 04             	sub    $0x4,%esp
  800e48:	50                   	push   %eax
  800e49:	51                   	push   %ecx
  800e4a:	52                   	push   %edx
  800e4b:	e8 a7 13 00 00       	call   8021f7 <sys_cputs>
  800e50:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8b 40 04             	mov    0x4(%eax),%eax
  800e62:	8d 50 01             	lea    0x1(%eax),%edx
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e6b:	90                   	nop
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e77:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e7e:	00 00 00 
	b.cnt = 0;
  800e81:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800e88:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	68 05 0e 80 00       	push   $0x800e05
  800e9d:	e8 11 02 00 00       	call   8010b3 <vprintfmt>
  800ea2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ea5:	a0 24 40 80 00       	mov    0x804024,%al
  800eaa:	0f b6 c0             	movzbl %al,%eax
  800ead:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	50                   	push   %eax
  800eb7:	52                   	push   %edx
  800eb8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ebe:	83 c0 08             	add    $0x8,%eax
  800ec1:	50                   	push   %eax
  800ec2:	e8 30 13 00 00       	call   8021f7 <sys_cputs>
  800ec7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800eca:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800ed1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800edf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800ee6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	83 ec 08             	sub    $0x8,%esp
  800ef2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef5:	50                   	push   %eax
  800ef6:	e8 73 ff ff ff       	call   800e6e <vcprintf>
  800efb:	83 c4 10             	add    $0x10,%esp
  800efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f0c:	e8 f7 14 00 00       	call   802408 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f11:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f20:	50                   	push   %eax
  800f21:	e8 48 ff ff ff       	call   800e6e <vcprintf>
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f2c:	e8 f1 14 00 00       	call   802422 <sys_enable_interrupt>
	return cnt;
  800f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	53                   	push   %ebx
  800f3a:	83 ec 14             	sub    $0x14,%esp
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f43:	8b 45 14             	mov    0x14(%ebp),%eax
  800f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f49:	8b 45 18             	mov    0x18(%ebp),%eax
  800f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f51:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f54:	77 55                	ja     800fab <printnum+0x75>
  800f56:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f59:	72 05                	jb     800f60 <printnum+0x2a>
  800f5b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f5e:	77 4b                	ja     800fab <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f60:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f63:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f66:	8b 45 18             	mov    0x18(%ebp),%eax
  800f69:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6e:	52                   	push   %edx
  800f6f:	50                   	push   %eax
  800f70:	ff 75 f4             	pushl  -0xc(%ebp)
  800f73:	ff 75 f0             	pushl  -0x10(%ebp)
  800f76:	e8 b1 18 00 00       	call   80282c <__udivdi3>
  800f7b:	83 c4 10             	add    $0x10,%esp
  800f7e:	83 ec 04             	sub    $0x4,%esp
  800f81:	ff 75 20             	pushl  0x20(%ebp)
  800f84:	53                   	push   %ebx
  800f85:	ff 75 18             	pushl  0x18(%ebp)
  800f88:	52                   	push   %edx
  800f89:	50                   	push   %eax
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	ff 75 08             	pushl  0x8(%ebp)
  800f90:	e8 a1 ff ff ff       	call   800f36 <printnum>
  800f95:	83 c4 20             	add    $0x20,%esp
  800f98:	eb 1a                	jmp    800fb4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800f9a:	83 ec 08             	sub    $0x8,%esp
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fab:	ff 4d 1c             	decl   0x1c(%ebp)
  800fae:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fb2:	7f e6                	jg     800f9a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fb4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc2:	53                   	push   %ebx
  800fc3:	51                   	push   %ecx
  800fc4:	52                   	push   %edx
  800fc5:	50                   	push   %eax
  800fc6:	e8 71 19 00 00       	call   80293c <__umoddi3>
  800fcb:	83 c4 10             	add    $0x10,%esp
  800fce:	05 94 2f 80 00       	add    $0x802f94,%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	0f be c0             	movsbl %al,%eax
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 0c             	pushl  0xc(%ebp)
  800fde:	50                   	push   %eax
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	ff d0                	call   *%eax
  800fe4:	83 c4 10             	add    $0x10,%esp
}
  800fe7:	90                   	nop
  800fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ff0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ff4:	7e 1c                	jle    801012 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8b 00                	mov    (%eax),%eax
  800ffb:	8d 50 08             	lea    0x8(%eax),%edx
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 10                	mov    %edx,(%eax)
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8b 00                	mov    (%eax),%eax
  801008:	83 e8 08             	sub    $0x8,%eax
  80100b:	8b 50 04             	mov    0x4(%eax),%edx
  80100e:	8b 00                	mov    (%eax),%eax
  801010:	eb 40                	jmp    801052 <getuint+0x65>
	else if (lflag)
  801012:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801016:	74 1e                	je     801036 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8b 00                	mov    (%eax),%eax
  80101d:	8d 50 04             	lea    0x4(%eax),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	89 10                	mov    %edx,(%eax)
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8b 00                	mov    (%eax),%eax
  80102a:	83 e8 04             	sub    $0x4,%eax
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	ba 00 00 00 00       	mov    $0x0,%edx
  801034:	eb 1c                	jmp    801052 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8b 00                	mov    (%eax),%eax
  80103b:	8d 50 04             	lea    0x4(%eax),%edx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 10                	mov    %edx,(%eax)
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	83 e8 04             	sub    $0x4,%eax
  80104b:	8b 00                	mov    (%eax),%eax
  80104d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801057:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80105b:	7e 1c                	jle    801079 <getint+0x25>
		return va_arg(*ap, long long);
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	8d 50 08             	lea    0x8(%eax),%edx
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	89 10                	mov    %edx,(%eax)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	83 e8 08             	sub    $0x8,%eax
  801072:	8b 50 04             	mov    0x4(%eax),%edx
  801075:	8b 00                	mov    (%eax),%eax
  801077:	eb 38                	jmp    8010b1 <getint+0x5d>
	else if (lflag)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 1a                	je     801099 <getint+0x45>
		return va_arg(*ap, long);
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8b 00                	mov    (%eax),%eax
  801084:	8d 50 04             	lea    0x4(%eax),%edx
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	89 10                	mov    %edx,(%eax)
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax
  801096:	99                   	cltd   
  801097:	eb 18                	jmp    8010b1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8b 00                	mov    (%eax),%eax
  80109e:	8d 50 04             	lea    0x4(%eax),%edx
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 10                	mov    %edx,(%eax)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8b 00                	mov    (%eax),%eax
  8010ab:	83 e8 04             	sub    $0x4,%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	99                   	cltd   
}
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	56                   	push   %esi
  8010b7:	53                   	push   %ebx
  8010b8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010bb:	eb 17                	jmp    8010d4 <vprintfmt+0x21>
			if (ch == '\0')
  8010bd:	85 db                	test   %ebx,%ebx
  8010bf:	0f 84 af 03 00 00    	je     801474 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	53                   	push   %ebx
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	0f b6 d8             	movzbl %al,%ebx
  8010e2:	83 fb 25             	cmp    $0x25,%ebx
  8010e5:	75 d6                	jne    8010bd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8010e7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8010eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8010f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8010f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801100:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 10             	mov    %edx,0x10(%ebp)
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f b6 d8             	movzbl %al,%ebx
  801115:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801118:	83 f8 55             	cmp    $0x55,%eax
  80111b:	0f 87 2b 03 00 00    	ja     80144c <vprintfmt+0x399>
  801121:	8b 04 85 b8 2f 80 00 	mov    0x802fb8(,%eax,4),%eax
  801128:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80112a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80112e:	eb d7                	jmp    801107 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801130:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801134:	eb d1                	jmp    801107 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801136:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80113d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801140:	89 d0                	mov    %edx,%eax
  801142:	c1 e0 02             	shl    $0x2,%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	01 c0                	add    %eax,%eax
  801149:	01 d8                	add    %ebx,%eax
  80114b:	83 e8 30             	sub    $0x30,%eax
  80114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801151:	8b 45 10             	mov    0x10(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801159:	83 fb 2f             	cmp    $0x2f,%ebx
  80115c:	7e 3e                	jle    80119c <vprintfmt+0xe9>
  80115e:	83 fb 39             	cmp    $0x39,%ebx
  801161:	7f 39                	jg     80119c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801163:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801166:	eb d5                	jmp    80113d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	83 c0 04             	add    $0x4,%eax
  80116e:	89 45 14             	mov    %eax,0x14(%ebp)
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	83 e8 04             	sub    $0x4,%eax
  801177:	8b 00                	mov    (%eax),%eax
  801179:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80117c:	eb 1f                	jmp    80119d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80117e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801182:	79 83                	jns    801107 <vprintfmt+0x54>
				width = 0;
  801184:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80118b:	e9 77 ff ff ff       	jmp    801107 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801190:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801197:	e9 6b ff ff ff       	jmp    801107 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80119c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	0f 89 60 ff ff ff    	jns    801107 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011ad:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011b4:	e9 4e ff ff ff       	jmp    801107 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011b9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011bc:	e9 46 ff ff ff       	jmp    801107 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c4:	83 c0 04             	add    $0x4,%eax
  8011c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 e8 04             	sub    $0x4,%eax
  8011d0:	8b 00                	mov    (%eax),%eax
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	ff 75 0c             	pushl  0xc(%ebp)
  8011d8:	50                   	push   %eax
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	ff d0                	call   *%eax
  8011de:	83 c4 10             	add    $0x10,%esp
			break;
  8011e1:	e9 89 02 00 00       	jmp    80146f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	83 c0 04             	add    $0x4,%eax
  8011ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	83 e8 04             	sub    $0x4,%eax
  8011f5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8011f7:	85 db                	test   %ebx,%ebx
  8011f9:	79 02                	jns    8011fd <vprintfmt+0x14a>
				err = -err;
  8011fb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8011fd:	83 fb 64             	cmp    $0x64,%ebx
  801200:	7f 0b                	jg     80120d <vprintfmt+0x15a>
  801202:	8b 34 9d 00 2e 80 00 	mov    0x802e00(,%ebx,4),%esi
  801209:	85 f6                	test   %esi,%esi
  80120b:	75 19                	jne    801226 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80120d:	53                   	push   %ebx
  80120e:	68 a5 2f 80 00       	push   $0x802fa5
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 5e 02 00 00       	call   80147c <printfmt>
  80121e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801221:	e9 49 02 00 00       	jmp    80146f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801226:	56                   	push   %esi
  801227:	68 ae 2f 80 00       	push   $0x802fae
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 45 02 00 00       	call   80147c <printfmt>
  801237:	83 c4 10             	add    $0x10,%esp
			break;
  80123a:	e9 30 02 00 00       	jmp    80146f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	83 c0 04             	add    $0x4,%eax
  801245:	89 45 14             	mov    %eax,0x14(%ebp)
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 e8 04             	sub    $0x4,%eax
  80124e:	8b 30                	mov    (%eax),%esi
  801250:	85 f6                	test   %esi,%esi
  801252:	75 05                	jne    801259 <vprintfmt+0x1a6>
				p = "(null)";
  801254:	be b1 2f 80 00       	mov    $0x802fb1,%esi
			if (width > 0 && padc != '-')
  801259:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80125d:	7e 6d                	jle    8012cc <vprintfmt+0x219>
  80125f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801263:	74 67                	je     8012cc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	50                   	push   %eax
  80126c:	56                   	push   %esi
  80126d:	e8 0c 03 00 00       	call   80157e <strnlen>
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801278:	eb 16                	jmp    801290 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80127a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80127e:	83 ec 08             	sub    $0x8,%esp
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	50                   	push   %eax
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	ff d0                	call   *%eax
  80128a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80128d:	ff 4d e4             	decl   -0x1c(%ebp)
  801290:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801294:	7f e4                	jg     80127a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801296:	eb 34                	jmp    8012cc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801298:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80129c:	74 1c                	je     8012ba <vprintfmt+0x207>
  80129e:	83 fb 1f             	cmp    $0x1f,%ebx
  8012a1:	7e 05                	jle    8012a8 <vprintfmt+0x1f5>
  8012a3:	83 fb 7e             	cmp    $0x7e,%ebx
  8012a6:	7e 12                	jle    8012ba <vprintfmt+0x207>
					putch('?', putdat);
  8012a8:	83 ec 08             	sub    $0x8,%esp
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	6a 3f                	push   $0x3f
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	ff d0                	call   *%eax
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	eb 0f                	jmp    8012c9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	53                   	push   %ebx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	ff d0                	call   *%eax
  8012c6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8012cc:	89 f0                	mov    %esi,%eax
  8012ce:	8d 70 01             	lea    0x1(%eax),%esi
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	0f be d8             	movsbl %al,%ebx
  8012d6:	85 db                	test   %ebx,%ebx
  8012d8:	74 24                	je     8012fe <vprintfmt+0x24b>
  8012da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012de:	78 b8                	js     801298 <vprintfmt+0x1e5>
  8012e0:	ff 4d e0             	decl   -0x20(%ebp)
  8012e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012e7:	79 af                	jns    801298 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012e9:	eb 13                	jmp    8012fe <vprintfmt+0x24b>
				putch(' ', putdat);
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	6a 20                	push   $0x20
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	ff d0                	call   *%eax
  8012f8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012fb:	ff 4d e4             	decl   -0x1c(%ebp)
  8012fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801302:	7f e7                	jg     8012eb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801304:	e9 66 01 00 00       	jmp    80146f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	ff 75 e8             	pushl  -0x18(%ebp)
  80130f:	8d 45 14             	lea    0x14(%ebp),%eax
  801312:	50                   	push   %eax
  801313:	e8 3c fd ff ff       	call   801054 <getint>
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80131e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	85 d2                	test   %edx,%edx
  801329:	79 23                	jns    80134e <vprintfmt+0x29b>
				putch('-', putdat);
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	6a 2d                	push   $0x2d
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	ff d0                	call   *%eax
  801338:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80133b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	f7 d8                	neg    %eax
  801343:	83 d2 00             	adc    $0x0,%edx
  801346:	f7 da                	neg    %edx
  801348:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80134b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80134e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801355:	e9 bc 00 00 00       	jmp    801416 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 e8             	pushl  -0x18(%ebp)
  801360:	8d 45 14             	lea    0x14(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	e8 84 fc ff ff       	call   800fed <getuint>
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801372:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801379:	e9 98 00 00 00       	jmp    801416 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	6a 58                	push   $0x58
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	ff d0                	call   *%eax
  80138b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	6a 58                	push   $0x58
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	ff d0                	call   *%eax
  80139b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	6a 58                	push   $0x58
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	ff d0                	call   *%eax
  8013ab:	83 c4 10             	add    $0x10,%esp
			break;
  8013ae:	e9 bc 00 00 00       	jmp    80146f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	6a 30                	push   $0x30
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	ff d0                	call   *%eax
  8013c0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	6a 78                	push   $0x78
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	ff d0                	call   *%eax
  8013d0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d6:	83 c0 04             	add    $0x4,%eax
  8013d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8013dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013df:	83 e8 04             	sub    $0x4,%eax
  8013e2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8013ee:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8013f5:	eb 1f                	jmp    801416 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8013fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801400:	50                   	push   %eax
  801401:	e8 e7 fb ff ff       	call   800fed <getuint>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80140c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80140f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801416:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80141a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	52                   	push   %edx
  801421:	ff 75 e4             	pushl  -0x1c(%ebp)
  801424:	50                   	push   %eax
  801425:	ff 75 f4             	pushl  -0xc(%ebp)
  801428:	ff 75 f0             	pushl  -0x10(%ebp)
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	ff 75 08             	pushl  0x8(%ebp)
  801431:	e8 00 fb ff ff       	call   800f36 <printnum>
  801436:	83 c4 20             	add    $0x20,%esp
			break;
  801439:	eb 34                	jmp    80146f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	ff 75 0c             	pushl  0xc(%ebp)
  801441:	53                   	push   %ebx
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	ff d0                	call   *%eax
  801447:	83 c4 10             	add    $0x10,%esp
			break;
  80144a:	eb 23                	jmp    80146f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	6a 25                	push   $0x25
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	ff d0                	call   *%eax
  801459:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80145c:	ff 4d 10             	decl   0x10(%ebp)
  80145f:	eb 03                	jmp    801464 <vprintfmt+0x3b1>
  801461:	ff 4d 10             	decl   0x10(%ebp)
  801464:	8b 45 10             	mov    0x10(%ebp),%eax
  801467:	48                   	dec    %eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 25                	cmp    $0x25,%al
  80146c:	75 f3                	jne    801461 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80146e:	90                   	nop
		}
	}
  80146f:	e9 47 fc ff ff       	jmp    8010bb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801474:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801475:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801478:	5b                   	pop    %ebx
  801479:	5e                   	pop    %esi
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801482:	8d 45 10             	lea    0x10(%ebp),%eax
  801485:	83 c0 04             	add    $0x4,%eax
  801488:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	ff 75 f4             	pushl  -0xc(%ebp)
  801491:	50                   	push   %eax
  801492:	ff 75 0c             	pushl  0xc(%ebp)
  801495:	ff 75 08             	pushl  0x8(%ebp)
  801498:	e8 16 fc ff ff       	call   8010b3 <vprintfmt>
  80149d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014a0:	90                   	nop
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	8b 40 08             	mov    0x8(%eax),%eax
  8014ac:	8d 50 01             	lea    0x1(%eax),%edx
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8b 10                	mov    (%eax),%edx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	8b 40 04             	mov    0x4(%eax),%eax
  8014c0:	39 c2                	cmp    %eax,%edx
  8014c2:	73 12                	jae    8014d6 <sprintputch+0x33>
		*b->buf++ = ch;
  8014c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c7:	8b 00                	mov    (%eax),%eax
  8014c9:	8d 48 01             	lea    0x1(%eax),%ecx
  8014cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cf:	89 0a                	mov    %ecx,(%edx)
  8014d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d4:	88 10                	mov    %dl,(%eax)
}
  8014d6:	90                   	nop
  8014d7:	5d                   	pop    %ebp
  8014d8:	c3                   	ret    

008014d9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	01 d0                	add    %edx,%eax
  8014f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8014fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014fe:	74 06                	je     801506 <vsnprintf+0x2d>
  801500:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801504:	7f 07                	jg     80150d <vsnprintf+0x34>
		return -E_INVAL;
  801506:	b8 03 00 00 00       	mov    $0x3,%eax
  80150b:	eb 20                	jmp    80152d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80150d:	ff 75 14             	pushl  0x14(%ebp)
  801510:	ff 75 10             	pushl  0x10(%ebp)
  801513:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801516:	50                   	push   %eax
  801517:	68 a3 14 80 00       	push   $0x8014a3
  80151c:	e8 92 fb ff ff       	call   8010b3 <vprintfmt>
  801521:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801527:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80152a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801535:	8d 45 10             	lea    0x10(%ebp),%eax
  801538:	83 c0 04             	add    $0x4,%eax
  80153b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80153e:	8b 45 10             	mov    0x10(%ebp),%eax
  801541:	ff 75 f4             	pushl  -0xc(%ebp)
  801544:	50                   	push   %eax
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	e8 89 ff ff ff       	call   8014d9 <vsnprintf>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801568:	eb 06                	jmp    801570 <strlen+0x15>
		n++;
  80156a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80156d:	ff 45 08             	incl   0x8(%ebp)
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	84 c0                	test   %al,%al
  801577:	75 f1                	jne    80156a <strlen+0xf>
		n++;
	return n;
  801579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80158b:	eb 09                	jmp    801596 <strnlen+0x18>
		n++;
  80158d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801590:	ff 45 08             	incl   0x8(%ebp)
  801593:	ff 4d 0c             	decl   0xc(%ebp)
  801596:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80159a:	74 09                	je     8015a5 <strnlen+0x27>
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	84 c0                	test   %al,%al
  8015a3:	75 e8                	jne    80158d <strnlen+0xf>
		n++;
	return n;
  8015a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015b6:	90                   	nop
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8d 50 01             	lea    0x1(%eax),%edx
  8015bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8015c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015c6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c9:	8a 12                	mov    (%edx),%dl
  8015cb:	88 10                	mov    %dl,(%eax)
  8015cd:	8a 00                	mov    (%eax),%al
  8015cf:	84 c0                	test   %al,%al
  8015d1:	75 e4                	jne    8015b7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8015e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015eb:	eb 1f                	jmp    80160c <strncpy+0x34>
		*dst++ = *src;
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 08             	mov    %edx,0x8(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	8a 12                	mov    (%edx),%dl
  8015fb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	84 c0                	test   %al,%al
  801604:	74 03                	je     801609 <strncpy+0x31>
			src++;
  801606:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801609:	ff 45 fc             	incl   -0x4(%ebp)
  80160c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801612:	72 d9                	jb     8015ed <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801614:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801625:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801629:	74 30                	je     80165b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80162b:	eb 16                	jmp    801643 <strlcpy+0x2a>
			*dst++ = *src++;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8d 50 01             	lea    0x1(%eax),%edx
  801633:	89 55 08             	mov    %edx,0x8(%ebp)
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8d 4a 01             	lea    0x1(%edx),%ecx
  80163c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80163f:	8a 12                	mov    (%edx),%dl
  801641:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801643:	ff 4d 10             	decl   0x10(%ebp)
  801646:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164a:	74 09                	je     801655 <strlcpy+0x3c>
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	84 c0                	test   %al,%al
  801653:	75 d8                	jne    80162d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80165b:	8b 55 08             	mov    0x8(%ebp),%edx
  80165e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801661:	29 c2                	sub    %eax,%edx
  801663:	89 d0                	mov    %edx,%eax
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80166a:	eb 06                	jmp    801672 <strcmp+0xb>
		p++, q++;
  80166c:	ff 45 08             	incl   0x8(%ebp)
  80166f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8a 00                	mov    (%eax),%al
  801677:	84 c0                	test   %al,%al
  801679:	74 0e                	je     801689 <strcmp+0x22>
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8a 10                	mov    (%eax),%dl
  801680:	8b 45 0c             	mov    0xc(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	38 c2                	cmp    %al,%dl
  801687:	74 e3                	je     80166c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	0f b6 d0             	movzbl %al,%edx
  801691:	8b 45 0c             	mov    0xc(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	0f b6 c0             	movzbl %al,%eax
  801699:	29 c2                	sub    %eax,%edx
  80169b:	89 d0                	mov    %edx,%eax
}
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016a2:	eb 09                	jmp    8016ad <strncmp+0xe>
		n--, p++, q++;
  8016a4:	ff 4d 10             	decl   0x10(%ebp)
  8016a7:	ff 45 08             	incl   0x8(%ebp)
  8016aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b1:	74 17                	je     8016ca <strncmp+0x2b>
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	84 c0                	test   %al,%al
  8016ba:	74 0e                	je     8016ca <strncmp+0x2b>
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 10                	mov    (%eax),%dl
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	38 c2                	cmp    %al,%dl
  8016c8:	74 da                	je     8016a4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ce:	75 07                	jne    8016d7 <strncmp+0x38>
		return 0;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d5:	eb 14                	jmp    8016eb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	0f b6 d0             	movzbl %al,%edx
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f b6 c0             	movzbl %al,%eax
  8016e7:	29 c2                	sub    %eax,%edx
  8016e9:	89 d0                	mov    %edx,%eax
}
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016f9:	eb 12                	jmp    80170d <strchr+0x20>
		if (*s == c)
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801703:	75 05                	jne    80170a <strchr+0x1d>
			return (char *) s;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	eb 11                	jmp    80171b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80170a:	ff 45 08             	incl   0x8(%ebp)
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	8a 00                	mov    (%eax),%al
  801712:	84 c0                	test   %al,%al
  801714:	75 e5                	jne    8016fb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801729:	eb 0d                	jmp    801738 <strfind+0x1b>
		if (*s == c)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8a 00                	mov    (%eax),%al
  801730:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801733:	74 0e                	je     801743 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801735:	ff 45 08             	incl   0x8(%ebp)
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	75 ea                	jne    80172b <strfind+0xe>
  801741:	eb 01                	jmp    801744 <strfind+0x27>
		if (*s == c)
			break;
  801743:	90                   	nop
	return (char *) s;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80175b:	eb 0e                	jmp    80176b <memset+0x22>
		*p++ = c;
  80175d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801760:	8d 50 01             	lea    0x1(%eax),%edx
  801763:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80176b:	ff 4d f8             	decl   -0x8(%ebp)
  80176e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801772:	79 e9                	jns    80175d <memset+0x14>
		*p++ = c;

	return v;
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80177f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801782:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80178b:	eb 16                	jmp    8017a3 <memcpy+0x2a>
		*d++ = *s++;
  80178d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801790:	8d 50 01             	lea    0x1(%eax),%edx
  801793:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801796:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801799:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179f:	8a 12                	mov    (%edx),%dl
  8017a1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	75 dd                	jne    80178d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017cd:	73 50                	jae    80181f <memmove+0x6a>
  8017cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017da:	76 43                	jbe    80181f <memmove+0x6a>
		s += n;
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017e8:	eb 10                	jmp    8017fa <memmove+0x45>
			*--d = *--s;
  8017ea:	ff 4d f8             	decl   -0x8(%ebp)
  8017ed:	ff 4d fc             	decl   -0x4(%ebp)
  8017f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f3:	8a 10                	mov    (%eax),%dl
  8017f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8017fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801800:	89 55 10             	mov    %edx,0x10(%ebp)
  801803:	85 c0                	test   %eax,%eax
  801805:	75 e3                	jne    8017ea <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801807:	eb 23                	jmp    80182c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801809:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180c:	8d 50 01             	lea    0x1(%eax),%edx
  80180f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8d 4a 01             	lea    0x1(%edx),%ecx
  801818:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80181b:	8a 12                	mov    (%edx),%dl
  80181d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80181f:	8b 45 10             	mov    0x10(%ebp),%eax
  801822:	8d 50 ff             	lea    -0x1(%eax),%edx
  801825:	89 55 10             	mov    %edx,0x10(%ebp)
  801828:	85 c0                	test   %eax,%eax
  80182a:	75 dd                	jne    801809 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80183d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801840:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801843:	eb 2a                	jmp    80186f <memcmp+0x3e>
		if (*s1 != *s2)
  801845:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801848:	8a 10                	mov    (%eax),%dl
  80184a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184d:	8a 00                	mov    (%eax),%al
  80184f:	38 c2                	cmp    %al,%dl
  801851:	74 16                	je     801869 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801853:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801856:	8a 00                	mov    (%eax),%al
  801858:	0f b6 d0             	movzbl %al,%edx
  80185b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185e:	8a 00                	mov    (%eax),%al
  801860:	0f b6 c0             	movzbl %al,%eax
  801863:	29 c2                	sub    %eax,%edx
  801865:	89 d0                	mov    %edx,%eax
  801867:	eb 18                	jmp    801881 <memcmp+0x50>
		s1++, s2++;
  801869:	ff 45 fc             	incl   -0x4(%ebp)
  80186c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80186f:	8b 45 10             	mov    0x10(%ebp),%eax
  801872:	8d 50 ff             	lea    -0x1(%eax),%edx
  801875:	89 55 10             	mov    %edx,0x10(%ebp)
  801878:	85 c0                	test   %eax,%eax
  80187a:	75 c9                	jne    801845 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80187c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801889:	8b 55 08             	mov    0x8(%ebp),%edx
  80188c:	8b 45 10             	mov    0x10(%ebp),%eax
  80188f:	01 d0                	add    %edx,%eax
  801891:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801894:	eb 15                	jmp    8018ab <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	0f b6 d0             	movzbl %al,%edx
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	0f b6 c0             	movzbl %al,%eax
  8018a4:	39 c2                	cmp    %eax,%edx
  8018a6:	74 0d                	je     8018b5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018a8:	ff 45 08             	incl   0x8(%ebp)
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018b1:	72 e3                	jb     801896 <memfind+0x13>
  8018b3:	eb 01                	jmp    8018b6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018b5:	90                   	nop
	return (void *) s;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018cf:	eb 03                	jmp    8018d4 <strtol+0x19>
		s++;
  8018d1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8a 00                	mov    (%eax),%al
  8018d9:	3c 20                	cmp    $0x20,%al
  8018db:	74 f4                	je     8018d1 <strtol+0x16>
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8a 00                	mov    (%eax),%al
  8018e2:	3c 09                	cmp    $0x9,%al
  8018e4:	74 eb                	je     8018d1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8a 00                	mov    (%eax),%al
  8018eb:	3c 2b                	cmp    $0x2b,%al
  8018ed:	75 05                	jne    8018f4 <strtol+0x39>
		s++;
  8018ef:	ff 45 08             	incl   0x8(%ebp)
  8018f2:	eb 13                	jmp    801907 <strtol+0x4c>
	else if (*s == '-')
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	3c 2d                	cmp    $0x2d,%al
  8018fb:	75 0a                	jne    801907 <strtol+0x4c>
		s++, neg = 1;
  8018fd:	ff 45 08             	incl   0x8(%ebp)
  801900:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801907:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80190b:	74 06                	je     801913 <strtol+0x58>
  80190d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801911:	75 20                	jne    801933 <strtol+0x78>
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 30                	cmp    $0x30,%al
  80191a:	75 17                	jne    801933 <strtol+0x78>
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	40                   	inc    %eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	3c 78                	cmp    $0x78,%al
  801924:	75 0d                	jne    801933 <strtol+0x78>
		s += 2, base = 16;
  801926:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80192a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801931:	eb 28                	jmp    80195b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801933:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801937:	75 15                	jne    80194e <strtol+0x93>
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8a 00                	mov    (%eax),%al
  80193e:	3c 30                	cmp    $0x30,%al
  801940:	75 0c                	jne    80194e <strtol+0x93>
		s++, base = 8;
  801942:	ff 45 08             	incl   0x8(%ebp)
  801945:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80194c:	eb 0d                	jmp    80195b <strtol+0xa0>
	else if (base == 0)
  80194e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801952:	75 07                	jne    80195b <strtol+0xa0>
		base = 10;
  801954:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	3c 2f                	cmp    $0x2f,%al
  801962:	7e 19                	jle    80197d <strtol+0xc2>
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8a 00                	mov    (%eax),%al
  801969:	3c 39                	cmp    $0x39,%al
  80196b:	7f 10                	jg     80197d <strtol+0xc2>
			dig = *s - '0';
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8a 00                	mov    (%eax),%al
  801972:	0f be c0             	movsbl %al,%eax
  801975:	83 e8 30             	sub    $0x30,%eax
  801978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80197b:	eb 42                	jmp    8019bf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8a 00                	mov    (%eax),%al
  801982:	3c 60                	cmp    $0x60,%al
  801984:	7e 19                	jle    80199f <strtol+0xe4>
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	8a 00                	mov    (%eax),%al
  80198b:	3c 7a                	cmp    $0x7a,%al
  80198d:	7f 10                	jg     80199f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	0f be c0             	movsbl %al,%eax
  801997:	83 e8 57             	sub    $0x57,%eax
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199d:	eb 20                	jmp    8019bf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8a 00                	mov    (%eax),%al
  8019a4:	3c 40                	cmp    $0x40,%al
  8019a6:	7e 39                	jle    8019e1 <strtol+0x126>
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8a 00                	mov    (%eax),%al
  8019ad:	3c 5a                	cmp    $0x5a,%al
  8019af:	7f 30                	jg     8019e1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	8a 00                	mov    (%eax),%al
  8019b6:	0f be c0             	movsbl %al,%eax
  8019b9:	83 e8 37             	sub    $0x37,%eax
  8019bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019c5:	7d 19                	jge    8019e0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019cd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019d1:	89 c2                	mov    %eax,%edx
  8019d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d6:	01 d0                	add    %edx,%eax
  8019d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019db:	e9 7b ff ff ff       	jmp    80195b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019e0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e5:	74 08                	je     8019ef <strtol+0x134>
		*endptr = (char *) s;
  8019e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ed:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8019ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019f3:	74 07                	je     8019fc <strtol+0x141>
  8019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f8:	f7 d8                	neg    %eax
  8019fa:	eb 03                	jmp    8019ff <strtol+0x144>
  8019fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <ltostr>:

void
ltostr(long value, char *str)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a0e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a19:	79 13                	jns    801a2e <ltostr+0x2d>
	{
		neg = 1;
  801a1b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a28:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a2b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a36:	99                   	cltd   
  801a37:	f7 f9                	idiv   %ecx
  801a39:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4a:	01 d0                	add    %edx,%eax
  801a4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a4f:	83 c2 30             	add    $0x30,%edx
  801a52:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a57:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a5c:	f7 e9                	imul   %ecx
  801a5e:	c1 fa 02             	sar    $0x2,%edx
  801a61:	89 c8                	mov    %ecx,%eax
  801a63:	c1 f8 1f             	sar    $0x1f,%eax
  801a66:	29 c2                	sub    %eax,%edx
  801a68:	89 d0                	mov    %edx,%eax
  801a6a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a70:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a75:	f7 e9                	imul   %ecx
  801a77:	c1 fa 02             	sar    $0x2,%edx
  801a7a:	89 c8                	mov    %ecx,%eax
  801a7c:	c1 f8 1f             	sar    $0x1f,%eax
  801a7f:	29 c2                	sub    %eax,%edx
  801a81:	89 d0                	mov    %edx,%eax
  801a83:	c1 e0 02             	shl    $0x2,%eax
  801a86:	01 d0                	add    %edx,%eax
  801a88:	01 c0                	add    %eax,%eax
  801a8a:	29 c1                	sub    %eax,%ecx
  801a8c:	89 ca                	mov    %ecx,%edx
  801a8e:	85 d2                	test   %edx,%edx
  801a90:	75 9c                	jne    801a2e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9c:	48                   	dec    %eax
  801a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801aa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aa4:	74 3d                	je     801ae3 <ltostr+0xe2>
		start = 1 ;
  801aa6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801aad:	eb 34                	jmp    801ae3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	01 d0                	add    %edx,%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac2:	01 c2                	add    %eax,%edx
  801ac4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aca:	01 c8                	add    %ecx,%eax
  801acc:	8a 00                	mov    (%eax),%al
  801ace:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ad0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad6:	01 c2                	add    %eax,%edx
  801ad8:	8a 45 eb             	mov    -0x15(%ebp),%al
  801adb:	88 02                	mov    %al,(%edx)
		start++ ;
  801add:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ae0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ae9:	7c c4                	jl     801aaf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801aeb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af1:	01 d0                	add    %edx,%eax
  801af3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801af6:	90                   	nop
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	e8 54 fa ff ff       	call   80155b <strlen>
  801b07:	83 c4 04             	add    $0x4,%esp
  801b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	e8 46 fa ff ff       	call   80155b <strlen>
  801b15:	83 c4 04             	add    $0x4,%esp
  801b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b29:	eb 17                	jmp    801b42 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b31:	01 c2                	add    %eax,%edx
  801b33:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	01 c8                	add    %ecx,%eax
  801b3b:	8a 00                	mov    (%eax),%al
  801b3d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b3f:	ff 45 fc             	incl   -0x4(%ebp)
  801b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b45:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b48:	7c e1                	jl     801b2b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b58:	eb 1f                	jmp    801b79 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5d:	8d 50 01             	lea    0x1(%eax),%edx
  801b60:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b63:	89 c2                	mov    %eax,%edx
  801b65:	8b 45 10             	mov    0x10(%ebp),%eax
  801b68:	01 c2                	add    %eax,%edx
  801b6a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b70:	01 c8                	add    %ecx,%eax
  801b72:	8a 00                	mov    (%eax),%al
  801b74:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b76:	ff 45 f8             	incl   -0x8(%ebp)
  801b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b7f:	7c d9                	jl     801b5a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 d0                	add    %edx,%eax
  801b89:	c6 00 00             	movb   $0x0,(%eax)
}
  801b8c:	90                   	nop
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b92:	8b 45 14             	mov    0x14(%ebp),%eax
  801b95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9e:	8b 00                	mov    (%eax),%eax
  801ba0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  801baa:	01 d0                	add    %edx,%eax
  801bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bb2:	eb 0c                	jmp    801bc0 <strsplit+0x31>
			*string++ = 0;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	8d 50 01             	lea    0x1(%eax),%edx
  801bba:	89 55 08             	mov    %edx,0x8(%ebp)
  801bbd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	8a 00                	mov    (%eax),%al
  801bc5:	84 c0                	test   %al,%al
  801bc7:	74 18                	je     801be1 <strsplit+0x52>
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8a 00                	mov    (%eax),%al
  801bce:	0f be c0             	movsbl %al,%eax
  801bd1:	50                   	push   %eax
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	e8 13 fb ff ff       	call   8016ed <strchr>
  801bda:	83 c4 08             	add    $0x8,%esp
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	75 d3                	jne    801bb4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	8a 00                	mov    (%eax),%al
  801be6:	84 c0                	test   %al,%al
  801be8:	74 5a                	je     801c44 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bea:	8b 45 14             	mov    0x14(%ebp),%eax
  801bed:	8b 00                	mov    (%eax),%eax
  801bef:	83 f8 0f             	cmp    $0xf,%eax
  801bf2:	75 07                	jne    801bfb <strsplit+0x6c>
		{
			return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	eb 66                	jmp    801c61 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfe:	8b 00                	mov    (%eax),%eax
  801c00:	8d 48 01             	lea    0x1(%eax),%ecx
  801c03:	8b 55 14             	mov    0x14(%ebp),%edx
  801c06:	89 0a                	mov    %ecx,(%edx)
  801c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c12:	01 c2                	add    %eax,%edx
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c19:	eb 03                	jmp    801c1e <strsplit+0x8f>
			string++;
  801c1b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	8a 00                	mov    (%eax),%al
  801c23:	84 c0                	test   %al,%al
  801c25:	74 8b                	je     801bb2 <strsplit+0x23>
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	8a 00                	mov    (%eax),%al
  801c2c:	0f be c0             	movsbl %al,%eax
  801c2f:	50                   	push   %eax
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	e8 b5 fa ff ff       	call   8016ed <strchr>
  801c38:	83 c4 08             	add    $0x8,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	74 dc                	je     801c1b <strsplit+0x8c>
			string++;
	}
  801c3f:	e9 6e ff ff ff       	jmp    801bb2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c44:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c45:	8b 45 14             	mov    0x14(%ebp),%eax
  801c48:	8b 00                	mov    (%eax),%eax
  801c4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c5c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801c69:	a1 28 40 80 00       	mov    0x804028,%eax
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	75 33                	jne    801ca5 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801c72:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801c79:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801c7c:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801c83:	00 00 a0 
		spaces[0].pages = numPages;
  801c86:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801c8d:	00 02 00 
		spaces[0].isFree = 1;
  801c90:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801c97:	00 00 00 
		arraySize++;
  801c9a:	a1 28 40 80 00       	mov    0x804028,%eax
  801c9f:	40                   	inc    %eax
  801ca0:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801ca5:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801cac:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801cb3:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801cba:	8b 55 08             	mov    0x8(%ebp),%edx
  801cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	48                   	dec    %eax
  801cc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cce:	f7 75 e8             	divl   -0x18(%ebp)
  801cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd4:	29 d0                	sub    %edx,%eax
  801cd6:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	c1 e8 0c             	shr    $0xc,%eax
  801cdf:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801ce2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ce9:	eb 57                	jmp    801d42 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cee:	c1 e0 04             	shl    $0x4,%eax
  801cf1:	05 2c 41 80 00       	add    $0x80412c,%eax
  801cf6:	8b 00                	mov    (%eax),%eax
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	74 42                	je     801d3e <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801cfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cff:	c1 e0 04             	shl    $0x4,%eax
  801d02:	05 28 41 80 00       	add    $0x804128,%eax
  801d07:	8b 00                	mov    (%eax),%eax
  801d09:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d0c:	7c 31                	jl     801d3f <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d11:	c1 e0 04             	shl    $0x4,%eax
  801d14:	05 28 41 80 00       	add    $0x804128,%eax
  801d19:	8b 00                	mov    (%eax),%eax
  801d1b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801d1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d21:	7d 1c                	jge    801d3f <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d26:	c1 e0 04             	shl    $0x4,%eax
  801d29:	05 28 41 80 00       	add    $0x804128,%eax
  801d2e:	8b 00                	mov    (%eax),%eax
  801d30:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d3c:	eb 01                	jmp    801d3f <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801d3e:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801d3f:	ff 45 ec             	incl   -0x14(%ebp)
  801d42:	a1 28 40 80 00       	mov    0x804028,%eax
  801d47:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801d4a:	7c 9f                	jl     801ceb <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801d4c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d50:	75 0a                	jne    801d5c <malloc+0xf9>
	{
		return NULL;
  801d52:	b8 00 00 00 00       	mov    $0x0,%eax
  801d57:	e9 34 01 00 00       	jmp    801e90 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	c1 e0 04             	shl    $0x4,%eax
  801d62:	05 28 41 80 00       	add    $0x804128,%eax
  801d67:	8b 00                	mov    (%eax),%eax
  801d69:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d6c:	75 38                	jne    801da6 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d71:	c1 e0 04             	shl    $0x4,%eax
  801d74:	05 2c 41 80 00       	add    $0x80412c,%eax
  801d79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d82:	c1 e0 0c             	shl    $0xc,%eax
  801d85:	89 c2                	mov    %eax,%edx
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8a:	c1 e0 04             	shl    $0x4,%eax
  801d8d:	05 20 41 80 00       	add    $0x804120,%eax
  801d92:	8b 00                	mov    (%eax),%eax
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	e8 01 06 00 00       	call   80239f <sys_allocateMem>
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	e9 dd 00 00 00       	jmp    801e83 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da9:	c1 e0 04             	shl    $0x4,%eax
  801dac:	05 20 41 80 00       	add    $0x804120,%eax
  801db1:	8b 00                	mov    (%eax),%eax
  801db3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db6:	c1 e2 0c             	shl    $0xc,%edx
  801db9:	01 d0                	add    %edx,%eax
  801dbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801dbe:	a1 28 40 80 00       	mov    0x804028,%eax
  801dc3:	c1 e0 04             	shl    $0x4,%eax
  801dc6:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  801dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dcf:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801dd1:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dda:	c1 e0 04             	shl    $0x4,%eax
  801ddd:	05 24 41 80 00       	add    $0x804124,%eax
  801de2:	8b 00                	mov    (%eax),%eax
  801de4:	c1 e2 04             	shl    $0x4,%edx
  801de7:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801ded:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801def:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df8:	c1 e0 04             	shl    $0x4,%eax
  801dfb:	05 28 41 80 00       	add    $0x804128,%eax
  801e00:	8b 00                	mov    (%eax),%eax
  801e02:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801e05:	c1 e2 04             	shl    $0x4,%edx
  801e08:	81 c2 28 41 80 00    	add    $0x804128,%edx
  801e0e:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801e10:	a1 28 40 80 00       	mov    0x804028,%eax
  801e15:	c1 e0 04             	shl    $0x4,%eax
  801e18:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e1d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801e23:	a1 28 40 80 00       	mov    0x804028,%eax
  801e28:	40                   	inc    %eax
  801e29:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e31:	c1 e0 04             	shl    $0x4,%eax
  801e34:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  801e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e3d:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	c1 e0 04             	shl    $0x4,%eax
  801e45:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  801e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4e:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	c1 e0 04             	shl    $0x4,%eax
  801e56:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e64:	c1 e0 0c             	shl    $0xc,%eax
  801e67:	89 c2                	mov    %eax,%edx
  801e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6c:	c1 e0 04             	shl    $0x4,%eax
  801e6f:	05 20 41 80 00       	add    $0x804120,%eax
  801e74:	8b 00                	mov    (%eax),%eax
  801e76:	83 ec 08             	sub    $0x8,%esp
  801e79:	52                   	push   %edx
  801e7a:	50                   	push   %eax
  801e7b:	e8 1f 05 00 00       	call   80239f <sys_allocateMem>
  801e80:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e86:	c1 e0 04             	shl    $0x4,%eax
  801e89:	05 20 41 80 00       	add    $0x804120,%eax
  801e8e:	8b 00                	mov    (%eax),%eax
	}


}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801e98:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801e9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801ea6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801ead:	eb 3f                	jmp    801eee <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb2:	c1 e0 04             	shl    $0x4,%eax
  801eb5:	05 20 41 80 00       	add    $0x804120,%eax
  801eba:	8b 00                	mov    (%eax),%eax
  801ebc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ebf:	75 2a                	jne    801eeb <free+0x59>
		{
			index=i;
  801ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eca:	c1 e0 04             	shl    $0x4,%eax
  801ecd:	05 28 41 80 00       	add    $0x804128,%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	c1 e0 0c             	shl    $0xc,%eax
  801ed7:	89 c2                	mov    %eax,%edx
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	83 ec 08             	sub    $0x8,%esp
  801edf:	52                   	push   %edx
  801ee0:	50                   	push   %eax
  801ee1:	e8 9d 04 00 00       	call   802383 <sys_freeMem>
  801ee6:	83 c4 10             	add    $0x10,%esp
			break;
  801ee9:	eb 0d                	jmp    801ef8 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801eeb:	ff 45 ec             	incl   -0x14(%ebp)
  801eee:	a1 28 40 80 00       	mov    0x804028,%eax
  801ef3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801ef6:	7c b7                	jl     801eaf <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801ef8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801efc:	75 17                	jne    801f15 <free+0x83>
	{
		panic("Error");
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 10 31 80 00       	push   $0x803110
  801f06:	68 81 00 00 00       	push   $0x81
  801f0b:	68 16 31 80 00       	push   $0x803116
  801f10:	e8 22 ed ff ff       	call   800c37 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801f15:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801f1c:	e9 cc 00 00 00       	jmp    801fed <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f24:	c1 e0 04             	shl    $0x4,%eax
  801f27:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f2c:	8b 00                	mov    (%eax),%eax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	0f 84 b3 00 00 00    	je     801fe9 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f39:	c1 e0 04             	shl    $0x4,%eax
  801f3c:	05 20 41 80 00       	add    $0x804120,%eax
  801f41:	8b 10                	mov    (%eax),%edx
  801f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f46:	c1 e0 04             	shl    $0x4,%eax
  801f49:	05 24 41 80 00       	add    $0x804124,%eax
  801f4e:	8b 00                	mov    (%eax),%eax
  801f50:	39 c2                	cmp    %eax,%edx
  801f52:	0f 85 92 00 00 00    	jne    801fea <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	c1 e0 04             	shl    $0x4,%eax
  801f5e:	05 24 41 80 00       	add    $0x804124,%eax
  801f63:	8b 00                	mov    (%eax),%eax
  801f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f68:	c1 e2 04             	shl    $0x4,%edx
  801f6b:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801f71:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801f73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f76:	c1 e0 04             	shl    $0x4,%eax
  801f79:	05 28 41 80 00       	add    $0x804128,%eax
  801f7e:	8b 10                	mov    (%eax),%edx
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	c1 e0 04             	shl    $0x4,%eax
  801f86:	05 28 41 80 00       	add    $0x804128,%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	01 c2                	add    %eax,%edx
  801f8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f92:	c1 e0 04             	shl    $0x4,%eax
  801f95:	05 28 41 80 00       	add    $0x804128,%eax
  801f9a:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	c1 e0 04             	shl    $0x4,%eax
  801fa2:	05 20 41 80 00       	add    $0x804120,%eax
  801fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	c1 e0 04             	shl    $0x4,%eax
  801fb3:	05 24 41 80 00       	add    $0x804124,%eax
  801fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	c1 e0 04             	shl    $0x4,%eax
  801fc4:	05 28 41 80 00       	add    $0x804128,%eax
  801fc9:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	c1 e0 04             	shl    $0x4,%eax
  801fd5:	05 2c 41 80 00       	add    $0x80412c,%eax
  801fda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801fe0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801fe7:	eb 12                	jmp    801ffb <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801fe9:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801fea:	ff 45 e8             	incl   -0x18(%ebp)
  801fed:	a1 28 40 80 00       	mov    0x804028,%eax
  801ff2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801ff5:	0f 8c 26 ff ff ff    	jl     801f21 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ffb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802002:	e9 cc 00 00 00       	jmp    8020d3 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  802007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80200a:	c1 e0 04             	shl    $0x4,%eax
  80200d:	05 2c 41 80 00       	add    $0x80412c,%eax
  802012:	8b 00                	mov    (%eax),%eax
  802014:	85 c0                	test   %eax,%eax
  802016:	0f 84 b3 00 00 00    	je     8020cf <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	c1 e0 04             	shl    $0x4,%eax
  802022:	05 24 41 80 00       	add    $0x804124,%eax
  802027:	8b 10                	mov    (%eax),%edx
  802029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80202c:	c1 e0 04             	shl    $0x4,%eax
  80202f:	05 20 41 80 00       	add    $0x804120,%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	39 c2                	cmp    %eax,%edx
  802038:	0f 85 92 00 00 00    	jne    8020d0 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	c1 e0 04             	shl    $0x4,%eax
  802044:	05 20 41 80 00       	add    $0x804120,%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204e:	c1 e2 04             	shl    $0x4,%edx
  802051:	81 c2 20 41 80 00    	add    $0x804120,%edx
  802057:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  802059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80205c:	c1 e0 04             	shl    $0x4,%eax
  80205f:	05 28 41 80 00       	add    $0x804128,%eax
  802064:	8b 10                	mov    (%eax),%edx
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	c1 e0 04             	shl    $0x4,%eax
  80206c:	05 28 41 80 00       	add    $0x804128,%eax
  802071:	8b 00                	mov    (%eax),%eax
  802073:	01 c2                	add    %eax,%edx
  802075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802078:	c1 e0 04             	shl    $0x4,%eax
  80207b:	05 28 41 80 00       	add    $0x804128,%eax
  802080:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	c1 e0 04             	shl    $0x4,%eax
  802088:	05 20 41 80 00       	add    $0x804120,%eax
  80208d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	c1 e0 04             	shl    $0x4,%eax
  802099:	05 24 41 80 00       	add    $0x804124,%eax
  80209e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	c1 e0 04             	shl    $0x4,%eax
  8020aa:	05 28 41 80 00       	add    $0x804128,%eax
  8020af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	c1 e0 04             	shl    $0x4,%eax
  8020bb:	05 2c 41 80 00       	add    $0x80412c,%eax
  8020c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8020c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8020cd:	eb 12                	jmp    8020e1 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8020cf:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8020d0:	ff 45 e4             	incl   -0x1c(%ebp)
  8020d3:	a1 28 40 80 00       	mov    0x804028,%eax
  8020d8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020db:	0f 8c 26 ff ff ff    	jl     802007 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  8020e1:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8020e5:	75 11                	jne    8020f8 <free+0x266>
	{
		spaces[index].isFree = 1;
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	c1 e0 04             	shl    $0x4,%eax
  8020ed:	05 2c 41 80 00       	add    $0x80412c,%eax
  8020f2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  8020f8:	90                   	nop
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 18             	sub    $0x18,%esp
  802101:	8b 45 10             	mov    0x10(%ebp),%eax
  802104:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  802107:	83 ec 04             	sub    $0x4,%esp
  80210a:	68 24 31 80 00       	push   $0x803124
  80210f:	68 b9 00 00 00       	push   $0xb9
  802114:	68 16 31 80 00       	push   $0x803116
  802119:	e8 19 eb ff ff       	call   800c37 <_panic>

0080211e <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 24 31 80 00       	push   $0x803124
  80212c:	68 bf 00 00 00       	push   $0xbf
  802131:	68 16 31 80 00       	push   $0x803116
  802136:	e8 fc ea ff ff       	call   800c37 <_panic>

0080213b <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	68 24 31 80 00       	push   $0x803124
  802149:	68 c5 00 00 00       	push   $0xc5
  80214e:	68 16 31 80 00       	push   $0x803116
  802153:	e8 df ea ff ff       	call   800c37 <_panic>

00802158 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	68 24 31 80 00       	push   $0x803124
  802166:	68 ca 00 00 00       	push   $0xca
  80216b:	68 16 31 80 00       	push   $0x803116
  802170:	e8 c2 ea ff ff       	call   800c37 <_panic>

00802175 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	68 24 31 80 00       	push   $0x803124
  802183:	68 d0 00 00 00       	push   $0xd0
  802188:	68 16 31 80 00       	push   $0x803116
  80218d:	e8 a5 ea ff ff       	call   800c37 <_panic>

00802192 <shrink>:
}
void shrink(uint32 newSize)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	68 24 31 80 00       	push   $0x803124
  8021a0:	68 d4 00 00 00       	push   $0xd4
  8021a5:	68 16 31 80 00       	push   $0x803116
  8021aa:	e8 88 ea ff ff       	call   800c37 <_panic>

008021af <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	68 24 31 80 00       	push   $0x803124
  8021bd:	68 d9 00 00 00       	push   $0xd9
  8021c2:	68 16 31 80 00       	push   $0x803116
  8021c7:	e8 6b ea ff ff       	call   800c37 <_panic>

008021cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	57                   	push   %edi
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021e7:	cd 30                	int    $0x30
  8021e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5f                   	pop    %edi
  8021f5:	5d                   	pop    %ebp
  8021f6:	c3                   	ret    

008021f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802200:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802203:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	52                   	push   %edx
  80220f:	ff 75 0c             	pushl  0xc(%ebp)
  802212:	50                   	push   %eax
  802213:	6a 00                	push   $0x0
  802215:	e8 b2 ff ff ff       	call   8021cc <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	90                   	nop
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_cgetc>:

int
sys_cgetc(void)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 01                	push   $0x1
  80222f:	e8 98 ff ff ff       	call   8021cc <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	50                   	push   %eax
  802248:	6a 05                	push   $0x5
  80224a:	e8 7d ff ff ff       	call   8021cc <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 02                	push   $0x2
  802263:	e8 64 ff ff ff       	call   8021cc <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 03                	push   $0x3
  80227c:	e8 4b ff ff ff       	call   8021cc <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 04                	push   $0x4
  802295:	e8 32 ff ff ff       	call   8021cc <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_env_exit>:


void sys_env_exit(void)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 06                	push   $0x6
  8022ae:	e8 19 ff ff ff       	call   8021cc <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	90                   	nop
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	52                   	push   %edx
  8022c9:	50                   	push   %eax
  8022ca:	6a 07                	push   $0x7
  8022cc:	e8 fb fe ff ff       	call   8021cc <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	56                   	push   %esi
  8022da:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022db:	8b 75 18             	mov    0x18(%ebp),%esi
  8022de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	56                   	push   %esi
  8022eb:	53                   	push   %ebx
  8022ec:	51                   	push   %ecx
  8022ed:	52                   	push   %edx
  8022ee:	50                   	push   %eax
  8022ef:	6a 08                	push   $0x8
  8022f1:	e8 d6 fe ff ff       	call   8021cc <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

00802300 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802303:	8b 55 0c             	mov    0xc(%ebp),%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	52                   	push   %edx
  802310:	50                   	push   %eax
  802311:	6a 09                	push   $0x9
  802313:	e8 b4 fe ff ff       	call   8021cc <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	ff 75 0c             	pushl  0xc(%ebp)
  802329:	ff 75 08             	pushl  0x8(%ebp)
  80232c:	6a 0a                	push   $0xa
  80232e:	e8 99 fe ff ff       	call   8021cc <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 0b                	push   $0xb
  802347:	e8 80 fe ff ff       	call   8021cc <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 0c                	push   $0xc
  802360:	e8 67 fe ff ff       	call   8021cc <syscall>
  802365:	83 c4 18             	add    $0x18,%esp
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 0d                	push   $0xd
  802379:	e8 4e fe ff ff       	call   8021cc <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	ff 75 0c             	pushl  0xc(%ebp)
  80238f:	ff 75 08             	pushl  0x8(%ebp)
  802392:	6a 11                	push   $0x11
  802394:	e8 33 fe ff ff       	call   8021cc <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
	return;
  80239c:	90                   	nop
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	ff 75 0c             	pushl  0xc(%ebp)
  8023ab:	ff 75 08             	pushl  0x8(%ebp)
  8023ae:	6a 12                	push   $0x12
  8023b0:	e8 17 fe ff ff       	call   8021cc <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b8:	90                   	nop
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 0e                	push   $0xe
  8023ca:	e8 fd fd ff ff       	call   8021cc <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	ff 75 08             	pushl  0x8(%ebp)
  8023e2:	6a 0f                	push   $0xf
  8023e4:	e8 e3 fd ff ff       	call   8021cc <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 10                	push   $0x10
  8023fd:	e8 ca fd ff ff       	call   8021cc <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
}
  802405:	90                   	nop
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 14                	push   $0x14
  802417:	e8 b0 fd ff ff       	call   8021cc <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
}
  80241f:	90                   	nop
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 15                	push   $0x15
  802431:	e8 96 fd ff ff       	call   8021cc <syscall>
  802436:	83 c4 18             	add    $0x18,%esp
}
  802439:	90                   	nop
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_cputc>:


void
sys_cputc(const char c)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802448:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	50                   	push   %eax
  802455:	6a 16                	push   $0x16
  802457:	e8 70 fd ff ff       	call   8021cc <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
}
  80245f:	90                   	nop
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 17                	push   $0x17
  802471:	e8 56 fd ff ff       	call   8021cc <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
}
  802479:	90                   	nop
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	ff 75 0c             	pushl  0xc(%ebp)
  80248b:	50                   	push   %eax
  80248c:	6a 18                	push   $0x18
  80248e:	e8 39 fd ff ff       	call   8021cc <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
}
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80249b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	52                   	push   %edx
  8024a8:	50                   	push   %eax
  8024a9:	6a 1b                	push   $0x1b
  8024ab:	e8 1c fd ff ff       	call   8021cc <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	52                   	push   %edx
  8024c5:	50                   	push   %eax
  8024c6:	6a 19                	push   $0x19
  8024c8:	e8 ff fc ff ff       	call   8021cc <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
}
  8024d0:	90                   	nop
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	52                   	push   %edx
  8024e3:	50                   	push   %eax
  8024e4:	6a 1a                	push   $0x1a
  8024e6:	e8 e1 fc ff ff       	call   8021cc <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	90                   	nop
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802500:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	6a 00                	push   $0x0
  802509:	51                   	push   %ecx
  80250a:	52                   	push   %edx
  80250b:	ff 75 0c             	pushl  0xc(%ebp)
  80250e:	50                   	push   %eax
  80250f:	6a 1c                	push   $0x1c
  802511:	e8 b6 fc ff ff       	call   8021cc <syscall>
  802516:	83 c4 18             	add    $0x18,%esp
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80251e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	6a 1d                	push   $0x1d
  80252e:	e8 99 fc ff ff       	call   8021cc <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80253b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80253e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	51                   	push   %ecx
  802549:	52                   	push   %edx
  80254a:	50                   	push   %eax
  80254b:	6a 1e                	push   $0x1e
  80254d:	e8 7a fc ff ff       	call   8021cc <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80255a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	52                   	push   %edx
  802567:	50                   	push   %eax
  802568:	6a 1f                	push   $0x1f
  80256a:	e8 5d fc ff ff       	call   8021cc <syscall>
  80256f:	83 c4 18             	add    $0x18,%esp
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 20                	push   $0x20
  802583:	e8 44 fc ff ff       	call   8021cc <syscall>
  802588:	83 c4 18             	add    $0x18,%esp
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	6a 00                	push   $0x0
  802595:	ff 75 14             	pushl  0x14(%ebp)
  802598:	ff 75 10             	pushl  0x10(%ebp)
  80259b:	ff 75 0c             	pushl  0xc(%ebp)
  80259e:	50                   	push   %eax
  80259f:	6a 21                	push   $0x21
  8025a1:	e8 26 fc ff ff       	call   8021cc <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	50                   	push   %eax
  8025ba:	6a 22                	push   $0x22
  8025bc:	e8 0b fc ff ff       	call   8021cc <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
}
  8025c4:	90                   	nop
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	50                   	push   %eax
  8025d6:	6a 23                	push   $0x23
  8025d8:	e8 ef fb ff ff       	call   8021cc <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
}
  8025e0:	90                   	nop
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ec:	8d 50 04             	lea    0x4(%eax),%edx
  8025ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	52                   	push   %edx
  8025f9:	50                   	push   %eax
  8025fa:	6a 24                	push   $0x24
  8025fc:	e8 cb fb ff ff       	call   8021cc <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
	return result;
  802604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80260a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80260d:	89 01                	mov    %eax,(%ecx)
  80260f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	c9                   	leave  
  802616:	c2 04 00             	ret    $0x4

00802619 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	ff 75 10             	pushl  0x10(%ebp)
  802623:	ff 75 0c             	pushl  0xc(%ebp)
  802626:	ff 75 08             	pushl  0x8(%ebp)
  802629:	6a 13                	push   $0x13
  80262b:	e8 9c fb ff ff       	call   8021cc <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
	return ;
  802633:	90                   	nop
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_rcr2>:
uint32 sys_rcr2()
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 25                	push   $0x25
  802645:	e8 82 fb ff ff       	call   8021cc <syscall>
  80264a:	83 c4 18             	add    $0x18,%esp
}
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 04             	sub    $0x4,%esp
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80265b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	50                   	push   %eax
  802668:	6a 26                	push   $0x26
  80266a:	e8 5d fb ff ff       	call   8021cc <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
	return ;
  802672:	90                   	nop
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <rsttst>:
void rsttst()
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 28                	push   $0x28
  802684:	e8 43 fb ff ff       	call   8021cc <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
	return ;
  80268c:	90                   	nop
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	8b 45 14             	mov    0x14(%ebp),%eax
  802698:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80269b:	8b 55 18             	mov    0x18(%ebp),%edx
  80269e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026a2:	52                   	push   %edx
  8026a3:	50                   	push   %eax
  8026a4:	ff 75 10             	pushl  0x10(%ebp)
  8026a7:	ff 75 0c             	pushl  0xc(%ebp)
  8026aa:	ff 75 08             	pushl  0x8(%ebp)
  8026ad:	6a 27                	push   $0x27
  8026af:	e8 18 fb ff ff       	call   8021cc <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b7:	90                   	nop
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <chktst>:
void chktst(uint32 n)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	ff 75 08             	pushl  0x8(%ebp)
  8026c8:	6a 29                	push   $0x29
  8026ca:	e8 fd fa ff ff       	call   8021cc <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d2:	90                   	nop
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <inctst>:

void inctst()
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 2a                	push   $0x2a
  8026e4:	e8 e3 fa ff ff       	call   8021cc <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ec:	90                   	nop
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <gettst>:
uint32 gettst()
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 2b                	push   $0x2b
  8026fe:	e8 c9 fa ff ff       	call   8021cc <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 2c                	push   $0x2c
  80271a:	e8 ad fa ff ff       	call   8021cc <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
  802722:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802725:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802729:	75 07                	jne    802732 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80272b:	b8 01 00 00 00       	mov    $0x1,%eax
  802730:	eb 05                	jmp    802737 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 2c                	push   $0x2c
  80274b:	e8 7c fa ff ff       	call   8021cc <syscall>
  802750:	83 c4 18             	add    $0x18,%esp
  802753:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802756:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80275a:	75 07                	jne    802763 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80275c:	b8 01 00 00 00       	mov    $0x1,%eax
  802761:	eb 05                	jmp    802768 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 2c                	push   $0x2c
  80277c:	e8 4b fa ff ff       	call   8021cc <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
  802784:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802787:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80278b:	75 07                	jne    802794 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80278d:	b8 01 00 00 00       	mov    $0x1,%eax
  802792:	eb 05                	jmp    802799 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 2c                	push   $0x2c
  8027ad:	e8 1a fa ff ff       	call   8021cc <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
  8027b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027b8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027bc:	75 07                	jne    8027c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	eb 05                	jmp    8027ca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	ff 75 08             	pushl  0x8(%ebp)
  8027da:	6a 2d                	push   $0x2d
  8027dc:	e8 eb f9 ff ff       	call   8021cc <syscall>
  8027e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e4:	90                   	nop
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	6a 00                	push   $0x0
  8027f9:	53                   	push   %ebx
  8027fa:	51                   	push   %ecx
  8027fb:	52                   	push   %edx
  8027fc:	50                   	push   %eax
  8027fd:	6a 2e                	push   $0x2e
  8027ff:	e8 c8 f9 ff ff       	call   8021cc <syscall>
  802804:	83 c4 18             	add    $0x18,%esp
}
  802807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80280f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	52                   	push   %edx
  80281c:	50                   	push   %eax
  80281d:	6a 2f                	push   $0x2f
  80281f:	e8 a8 f9 ff ff       	call   8021cc <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    
  802829:	66 90                	xchg   %ax,%ax
  80282b:	90                   	nop

0080282c <__udivdi3>:
  80282c:	55                   	push   %ebp
  80282d:	57                   	push   %edi
  80282e:	56                   	push   %esi
  80282f:	53                   	push   %ebx
  802830:	83 ec 1c             	sub    $0x1c,%esp
  802833:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802837:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80283b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80283f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802843:	89 ca                	mov    %ecx,%edx
  802845:	89 f8                	mov    %edi,%eax
  802847:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80284b:	85 f6                	test   %esi,%esi
  80284d:	75 2d                	jne    80287c <__udivdi3+0x50>
  80284f:	39 cf                	cmp    %ecx,%edi
  802851:	77 65                	ja     8028b8 <__udivdi3+0x8c>
  802853:	89 fd                	mov    %edi,%ebp
  802855:	85 ff                	test   %edi,%edi
  802857:	75 0b                	jne    802864 <__udivdi3+0x38>
  802859:	b8 01 00 00 00       	mov    $0x1,%eax
  80285e:	31 d2                	xor    %edx,%edx
  802860:	f7 f7                	div    %edi
  802862:	89 c5                	mov    %eax,%ebp
  802864:	31 d2                	xor    %edx,%edx
  802866:	89 c8                	mov    %ecx,%eax
  802868:	f7 f5                	div    %ebp
  80286a:	89 c1                	mov    %eax,%ecx
  80286c:	89 d8                	mov    %ebx,%eax
  80286e:	f7 f5                	div    %ebp
  802870:	89 cf                	mov    %ecx,%edi
  802872:	89 fa                	mov    %edi,%edx
  802874:	83 c4 1c             	add    $0x1c,%esp
  802877:	5b                   	pop    %ebx
  802878:	5e                   	pop    %esi
  802879:	5f                   	pop    %edi
  80287a:	5d                   	pop    %ebp
  80287b:	c3                   	ret    
  80287c:	39 ce                	cmp    %ecx,%esi
  80287e:	77 28                	ja     8028a8 <__udivdi3+0x7c>
  802880:	0f bd fe             	bsr    %esi,%edi
  802883:	83 f7 1f             	xor    $0x1f,%edi
  802886:	75 40                	jne    8028c8 <__udivdi3+0x9c>
  802888:	39 ce                	cmp    %ecx,%esi
  80288a:	72 0a                	jb     802896 <__udivdi3+0x6a>
  80288c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802890:	0f 87 9e 00 00 00    	ja     802934 <__udivdi3+0x108>
  802896:	b8 01 00 00 00       	mov    $0x1,%eax
  80289b:	89 fa                	mov    %edi,%edx
  80289d:	83 c4 1c             	add    $0x1c,%esp
  8028a0:	5b                   	pop    %ebx
  8028a1:	5e                   	pop    %esi
  8028a2:	5f                   	pop    %edi
  8028a3:	5d                   	pop    %ebp
  8028a4:	c3                   	ret    
  8028a5:	8d 76 00             	lea    0x0(%esi),%esi
  8028a8:	31 ff                	xor    %edi,%edi
  8028aa:	31 c0                	xor    %eax,%eax
  8028ac:	89 fa                	mov    %edi,%edx
  8028ae:	83 c4 1c             	add    $0x1c,%esp
  8028b1:	5b                   	pop    %ebx
  8028b2:	5e                   	pop    %esi
  8028b3:	5f                   	pop    %edi
  8028b4:	5d                   	pop    %ebp
  8028b5:	c3                   	ret    
  8028b6:	66 90                	xchg   %ax,%ax
  8028b8:	89 d8                	mov    %ebx,%eax
  8028ba:	f7 f7                	div    %edi
  8028bc:	31 ff                	xor    %edi,%edi
  8028be:	89 fa                	mov    %edi,%edx
  8028c0:	83 c4 1c             	add    $0x1c,%esp
  8028c3:	5b                   	pop    %ebx
  8028c4:	5e                   	pop    %esi
  8028c5:	5f                   	pop    %edi
  8028c6:	5d                   	pop    %ebp
  8028c7:	c3                   	ret    
  8028c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028cd:	89 eb                	mov    %ebp,%ebx
  8028cf:	29 fb                	sub    %edi,%ebx
  8028d1:	89 f9                	mov    %edi,%ecx
  8028d3:	d3 e6                	shl    %cl,%esi
  8028d5:	89 c5                	mov    %eax,%ebp
  8028d7:	88 d9                	mov    %bl,%cl
  8028d9:	d3 ed                	shr    %cl,%ebp
  8028db:	89 e9                	mov    %ebp,%ecx
  8028dd:	09 f1                	or     %esi,%ecx
  8028df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028e3:	89 f9                	mov    %edi,%ecx
  8028e5:	d3 e0                	shl    %cl,%eax
  8028e7:	89 c5                	mov    %eax,%ebp
  8028e9:	89 d6                	mov    %edx,%esi
  8028eb:	88 d9                	mov    %bl,%cl
  8028ed:	d3 ee                	shr    %cl,%esi
  8028ef:	89 f9                	mov    %edi,%ecx
  8028f1:	d3 e2                	shl    %cl,%edx
  8028f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028f7:	88 d9                	mov    %bl,%cl
  8028f9:	d3 e8                	shr    %cl,%eax
  8028fb:	09 c2                	or     %eax,%edx
  8028fd:	89 d0                	mov    %edx,%eax
  8028ff:	89 f2                	mov    %esi,%edx
  802901:	f7 74 24 0c          	divl   0xc(%esp)
  802905:	89 d6                	mov    %edx,%esi
  802907:	89 c3                	mov    %eax,%ebx
  802909:	f7 e5                	mul    %ebp
  80290b:	39 d6                	cmp    %edx,%esi
  80290d:	72 19                	jb     802928 <__udivdi3+0xfc>
  80290f:	74 0b                	je     80291c <__udivdi3+0xf0>
  802911:	89 d8                	mov    %ebx,%eax
  802913:	31 ff                	xor    %edi,%edi
  802915:	e9 58 ff ff ff       	jmp    802872 <__udivdi3+0x46>
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802920:	89 f9                	mov    %edi,%ecx
  802922:	d3 e2                	shl    %cl,%edx
  802924:	39 c2                	cmp    %eax,%edx
  802926:	73 e9                	jae    802911 <__udivdi3+0xe5>
  802928:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80292b:	31 ff                	xor    %edi,%edi
  80292d:	e9 40 ff ff ff       	jmp    802872 <__udivdi3+0x46>
  802932:	66 90                	xchg   %ax,%ax
  802934:	31 c0                	xor    %eax,%eax
  802936:	e9 37 ff ff ff       	jmp    802872 <__udivdi3+0x46>
  80293b:	90                   	nop

0080293c <__umoddi3>:
  80293c:	55                   	push   %ebp
  80293d:	57                   	push   %edi
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	83 ec 1c             	sub    $0x1c,%esp
  802943:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802947:	8b 74 24 34          	mov    0x34(%esp),%esi
  80294b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80294f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802953:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802957:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80295b:	89 f3                	mov    %esi,%ebx
  80295d:	89 fa                	mov    %edi,%edx
  80295f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802963:	89 34 24             	mov    %esi,(%esp)
  802966:	85 c0                	test   %eax,%eax
  802968:	75 1a                	jne    802984 <__umoddi3+0x48>
  80296a:	39 f7                	cmp    %esi,%edi
  80296c:	0f 86 a2 00 00 00    	jbe    802a14 <__umoddi3+0xd8>
  802972:	89 c8                	mov    %ecx,%eax
  802974:	89 f2                	mov    %esi,%edx
  802976:	f7 f7                	div    %edi
  802978:	89 d0                	mov    %edx,%eax
  80297a:	31 d2                	xor    %edx,%edx
  80297c:	83 c4 1c             	add    $0x1c,%esp
  80297f:	5b                   	pop    %ebx
  802980:	5e                   	pop    %esi
  802981:	5f                   	pop    %edi
  802982:	5d                   	pop    %ebp
  802983:	c3                   	ret    
  802984:	39 f0                	cmp    %esi,%eax
  802986:	0f 87 ac 00 00 00    	ja     802a38 <__umoddi3+0xfc>
  80298c:	0f bd e8             	bsr    %eax,%ebp
  80298f:	83 f5 1f             	xor    $0x1f,%ebp
  802992:	0f 84 ac 00 00 00    	je     802a44 <__umoddi3+0x108>
  802998:	bf 20 00 00 00       	mov    $0x20,%edi
  80299d:	29 ef                	sub    %ebp,%edi
  80299f:	89 fe                	mov    %edi,%esi
  8029a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a5:	89 e9                	mov    %ebp,%ecx
  8029a7:	d3 e0                	shl    %cl,%eax
  8029a9:	89 d7                	mov    %edx,%edi
  8029ab:	89 f1                	mov    %esi,%ecx
  8029ad:	d3 ef                	shr    %cl,%edi
  8029af:	09 c7                	or     %eax,%edi
  8029b1:	89 e9                	mov    %ebp,%ecx
  8029b3:	d3 e2                	shl    %cl,%edx
  8029b5:	89 14 24             	mov    %edx,(%esp)
  8029b8:	89 d8                	mov    %ebx,%eax
  8029ba:	d3 e0                	shl    %cl,%eax
  8029bc:	89 c2                	mov    %eax,%edx
  8029be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029c2:	d3 e0                	shl    %cl,%eax
  8029c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029cc:	89 f1                	mov    %esi,%ecx
  8029ce:	d3 e8                	shr    %cl,%eax
  8029d0:	09 d0                	or     %edx,%eax
  8029d2:	d3 eb                	shr    %cl,%ebx
  8029d4:	89 da                	mov    %ebx,%edx
  8029d6:	f7 f7                	div    %edi
  8029d8:	89 d3                	mov    %edx,%ebx
  8029da:	f7 24 24             	mull   (%esp)
  8029dd:	89 c6                	mov    %eax,%esi
  8029df:	89 d1                	mov    %edx,%ecx
  8029e1:	39 d3                	cmp    %edx,%ebx
  8029e3:	0f 82 87 00 00 00    	jb     802a70 <__umoddi3+0x134>
  8029e9:	0f 84 91 00 00 00    	je     802a80 <__umoddi3+0x144>
  8029ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029f3:	29 f2                	sub    %esi,%edx
  8029f5:	19 cb                	sbb    %ecx,%ebx
  8029f7:	89 d8                	mov    %ebx,%eax
  8029f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8029fd:	d3 e0                	shl    %cl,%eax
  8029ff:	89 e9                	mov    %ebp,%ecx
  802a01:	d3 ea                	shr    %cl,%edx
  802a03:	09 d0                	or     %edx,%eax
  802a05:	89 e9                	mov    %ebp,%ecx
  802a07:	d3 eb                	shr    %cl,%ebx
  802a09:	89 da                	mov    %ebx,%edx
  802a0b:	83 c4 1c             	add    $0x1c,%esp
  802a0e:	5b                   	pop    %ebx
  802a0f:	5e                   	pop    %esi
  802a10:	5f                   	pop    %edi
  802a11:	5d                   	pop    %ebp
  802a12:	c3                   	ret    
  802a13:	90                   	nop
  802a14:	89 fd                	mov    %edi,%ebp
  802a16:	85 ff                	test   %edi,%edi
  802a18:	75 0b                	jne    802a25 <__umoddi3+0xe9>
  802a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1f:	31 d2                	xor    %edx,%edx
  802a21:	f7 f7                	div    %edi
  802a23:	89 c5                	mov    %eax,%ebp
  802a25:	89 f0                	mov    %esi,%eax
  802a27:	31 d2                	xor    %edx,%edx
  802a29:	f7 f5                	div    %ebp
  802a2b:	89 c8                	mov    %ecx,%eax
  802a2d:	f7 f5                	div    %ebp
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	e9 44 ff ff ff       	jmp    80297a <__umoddi3+0x3e>
  802a36:	66 90                	xchg   %ax,%ax
  802a38:	89 c8                	mov    %ecx,%eax
  802a3a:	89 f2                	mov    %esi,%edx
  802a3c:	83 c4 1c             	add    $0x1c,%esp
  802a3f:	5b                   	pop    %ebx
  802a40:	5e                   	pop    %esi
  802a41:	5f                   	pop    %edi
  802a42:	5d                   	pop    %ebp
  802a43:	c3                   	ret    
  802a44:	3b 04 24             	cmp    (%esp),%eax
  802a47:	72 06                	jb     802a4f <__umoddi3+0x113>
  802a49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a4d:	77 0f                	ja     802a5e <__umoddi3+0x122>
  802a4f:	89 f2                	mov    %esi,%edx
  802a51:	29 f9                	sub    %edi,%ecx
  802a53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a57:	89 14 24             	mov    %edx,(%esp)
  802a5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a62:	8b 14 24             	mov    (%esp),%edx
  802a65:	83 c4 1c             	add    $0x1c,%esp
  802a68:	5b                   	pop    %ebx
  802a69:	5e                   	pop    %esi
  802a6a:	5f                   	pop    %edi
  802a6b:	5d                   	pop    %ebp
  802a6c:	c3                   	ret    
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	2b 04 24             	sub    (%esp),%eax
  802a73:	19 fa                	sbb    %edi,%edx
  802a75:	89 d1                	mov    %edx,%ecx
  802a77:	89 c6                	mov    %eax,%esi
  802a79:	e9 71 ff ff ff       	jmp    8029ef <__umoddi3+0xb3>
  802a7e:	66 90                	xchg   %ax,%ax
  802a80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a84:	72 ea                	jb     802a70 <__umoddi3+0x134>
  802a86:	89 d9                	mov    %ebx,%ecx
  802a88:	e9 62 ff ff ff       	jmp    8029ef <__umoddi3+0xb3>
