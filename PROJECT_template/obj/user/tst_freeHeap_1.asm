
obj/user/tst_freeHeap_1:     file format elf32-i386


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
  800031:	e8 dd 08 00 00       	call   800913 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	
	//	cprintf("envID = %d\n",envID);

	
	
	int kilo = 1024;
  800042:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
	int Mega = 1024*1024;
  800049:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__ptr_tws[0].virtual_address,1024*PAGE_SIZE) !=  0x0)  		panic("INITIAL TABLE WS entry checking failed! Review sizes of the two WS's..!!");
  800050:	a1 20 40 80 00       	mov    0x804020,%eax
  800055:	8b 80 f8 38 01 00    	mov    0x138f8(%eax),%eax
  80005b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80005e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800061:	25 00 00 c0 ff       	and    $0xffc00000,%eax
  800066:	85 c0                	test   %eax,%eax
  800068:	74 14                	je     80007e <_main+0x46>
  80006a:	83 ec 04             	sub    $0x4,%esp
  80006d:	68 c0 28 80 00       	push   $0x8028c0
  800072:	6a 14                	push   $0x14
  800074:	68 09 29 80 00       	push   $0x802909
  800079:	e8 da 09 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__ptr_tws[1].virtual_address,1024*PAGE_SIZE) !=  0x800000)  	panic("INITIAL TABLE WS entry checking failed! Review sizes of the two WS's..!!");
  80007e:	a1 20 40 80 00       	mov    0x804020,%eax
  800083:	8b 80 08 39 01 00    	mov    0x13908(%eax),%eax
  800089:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80008c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80008f:	25 00 00 c0 ff       	and    $0xffc00000,%eax
  800094:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 c0 28 80 00       	push   $0x8028c0
  8000a3:	6a 15                	push   $0x15
  8000a5:	68 09 29 80 00       	push   $0x802909
  8000aa:	e8 a9 09 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__ptr_tws[2].virtual_address,1024*PAGE_SIZE) !=  0xee800000)	panic("INITIAL TABLE WS entry checking failed! Review sizes of the two WS's..!!");
  8000af:	a1 20 40 80 00       	mov    0x804020,%eax
  8000b4:	8b 80 18 39 01 00    	mov    0x13918(%eax),%eax
  8000ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c0:	25 00 00 c0 ff       	and    $0xffc00000,%eax
  8000c5:	3d 00 00 80 ee       	cmp    $0xee800000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 c0 28 80 00       	push   $0x8028c0
  8000d4:	6a 16                	push   $0x16
  8000d6:	68 09 29 80 00       	push   $0x802909
  8000db:	e8 78 09 00 00       	call   800a58 <_panic>
		if( myEnv->__ptr_tws[3].empty !=  1)  											panic("INITIAL TABLE WS entry checking failed! Review sizes of the two WS's..!!");
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8a 80 2c 39 01 00    	mov    0x1392c(%eax),%al
  8000eb:	3c 01                	cmp    $0x1,%al
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 c0 28 80 00       	push   $0x8028c0
  8000f7:	6a 17                	push   $0x17
  8000f9:	68 09 29 80 00       	push   $0x802909
  8000fe:	e8 55 09 00 00       	call   800a58 <_panic>

		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800103:	a1 20 40 80 00       	mov    0x804020,%eax
  800108:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80010e:	83 c0 10             	add    $0x10,%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800116:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80011e:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800123:	74 14                	je     800139 <_main+0x101>
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	68 20 29 80 00       	push   $0x802920
  80012d:	6a 19                	push   $0x19
  80012f:	68 09 29 80 00       	push   $0x802909
  800134:	e8 1f 09 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800139:	a1 20 40 80 00       	mov    0x804020,%eax
  80013e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800144:	83 c0 20             	add    $0x20,%eax
  800147:	8b 00                	mov    (%eax),%eax
  800149:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80014c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80014f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800154:	3d 00 20 20 00       	cmp    $0x202000,%eax
  800159:	74 14                	je     80016f <_main+0x137>
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 20 29 80 00       	push   $0x802920
  800163:	6a 1a                	push   $0x1a
  800165:	68 09 29 80 00       	push   $0x802909
  80016a:	e8 e9 08 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80016f:	a1 20 40 80 00       	mov    0x804020,%eax
  800174:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80017a:	83 c0 30             	add    $0x30,%eax
  80017d:	8b 00                	mov    (%eax),%eax
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800182:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800185:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80018a:	3d 00 30 20 00       	cmp    $0x203000,%eax
  80018f:	74 14                	je     8001a5 <_main+0x16d>
  800191:	83 ec 04             	sub    $0x4,%esp
  800194:	68 20 29 80 00       	push   $0x802920
  800199:	6a 1b                	push   $0x1b
  80019b:	68 09 29 80 00       	push   $0x802909
  8001a0:	e8 b3 08 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001b0:	83 c0 40             	add    $0x40,%eax
  8001b3:	8b 00                	mov    (%eax),%eax
  8001b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001c0:	3d 00 40 20 00       	cmp    $0x204000,%eax
  8001c5:	74 14                	je     8001db <_main+0x1a3>
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	68 20 29 80 00       	push   $0x802920
  8001cf:	6a 1c                	push   $0x1c
  8001d1:	68 09 29 80 00       	push   $0x802909
  8001d6:	e8 7d 08 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001db:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8001e6:	83 c0 50             	add    $0x50,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001fb:	74 14                	je     800211 <_main+0x1d9>
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	68 20 29 80 00       	push   $0x802920
  800205:	6a 1d                	push   $0x1d
  800207:	68 09 29 80 00       	push   $0x802909
  80020c:	e8 47 08 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800211:	a1 20 40 80 00       	mov    0x804020,%eax
  800216:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80021c:	83 c0 60             	add    $0x60,%eax
  80021f:	8b 00                	mov    (%eax),%eax
  800221:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800224:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800227:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80022c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800231:	74 14                	je     800247 <_main+0x20f>
  800233:	83 ec 04             	sub    $0x4,%esp
  800236:	68 20 29 80 00       	push   $0x802920
  80023b:	6a 1e                	push   $0x1e
  80023d:	68 09 29 80 00       	push   $0x802909
  800242:	e8 11 08 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800247:	a1 20 40 80 00       	mov    0x804020,%eax
  80024c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800252:	83 c0 70             	add    $0x70,%eax
  800255:	8b 00                	mov    (%eax),%eax
  800257:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80025a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80025d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800262:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 20 29 80 00       	push   $0x802920
  800271:	6a 1f                	push   $0x1f
  800273:	68 09 29 80 00       	push   $0x802909
  800278:	e8 db 07 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80027d:	a1 20 40 80 00       	mov    0x804020,%eax
  800282:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800288:	83 e8 80             	sub    $0xffffff80,%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800290:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800293:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800298:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80029d:	74 14                	je     8002b3 <_main+0x27b>
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	68 20 29 80 00       	push   $0x802920
  8002a7:	6a 20                	push   $0x20
  8002a9:	68 09 29 80 00       	push   $0x802909
  8002ae:	e8 a5 07 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8002b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8002be:	05 90 00 00 00       	add    $0x90,%eax
  8002c3:	8b 00                	mov    (%eax),%eax
  8002c5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8002c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002d0:	3d 00 30 80 00       	cmp    $0x803000,%eax
  8002d5:	74 14                	je     8002eb <_main+0x2b3>
  8002d7:	83 ec 04             	sub    $0x4,%esp
  8002da:	68 20 29 80 00       	push   $0x802920
  8002df:	6a 21                	push   $0x21
  8002e1:	68 09 29 80 00       	push   $0x802909
  8002e6:	e8 6d 07 00 00       	call   800a58 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8002eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f0:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8002f6:	05 a0 00 00 00       	add    $0xa0,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800300:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800303:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800308:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 20 29 80 00       	push   $0x802920
  800317:	6a 22                	push   $0x22
  800319:	68 09 29 80 00       	push   $0x802909
  80031e:	e8 35 07 00 00       	call   800a58 <_panic>

		if( myEnv->page_last_WS_index !=  11)  										panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800323:	a1 20 40 80 00       	mov    0x804020,%eax
  800328:	8b 80 18 3c 01 00    	mov    0x13c18(%eax),%eax
  80032e:	83 f8 0b             	cmp    $0xb,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 20 29 80 00       	push   $0x802920
  80033b:	6a 24                	push   $0x24
  80033d:	68 09 29 80 00       	push   $0x802909
  800342:	e8 11 07 00 00       	call   800a58 <_panic>
	}


	/// testing freeHeap()
	{
		int freeFrames = sys_calculate_free_frames() ;
  800347:	e8 0d 1e 00 00       	call   802159 <sys_calculate_free_frames>
  80034c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int origFreeFrames = freeFrames ;
  80034f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800352:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800355:	e8 82 1e 00 00       	call   8021dc <sys_pf_calculate_allocated_pages>
  80035a:	89 45 b0             	mov    %eax,-0x50(%ebp)

		uint32 size = 12*Mega;
  80035d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	89 45 ac             	mov    %eax,-0x54(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	ff 75 ac             	pushl  -0x54(%ebp)
  800372:	e8 0d 17 00 00       	call   801a84 <malloc>
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if(!(((uint32)x == USER_HEAP_START) && (freeFrames - sys_calculate_free_frames()) == 3))
  80037d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800380:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800385:	75 11                	jne    800398 <_main+0x360>
  800387:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  80038a:	e8 ca 1d 00 00       	call   802159 <sys_calculate_free_frames>
  80038f:	29 c3                	sub    %eax,%ebx
  800391:	89 d8                	mov    %ebx,%eax
  800393:	83 f8 03             	cmp    $0x3,%eax
  800396:	74 14                	je     8003ac <_main+0x374>
			panic("malloc() does not work correctly... check it before checking freeHeap") ;
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	68 68 29 80 00       	push   $0x802968
  8003a0:	6a 31                	push   $0x31
  8003a2:	68 09 29 80 00       	push   $0x802909
  8003a7:	e8 ac 06 00 00       	call   800a58 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8003ac:	e8 a8 1d 00 00       	call   802159 <sys_calculate_free_frames>
  8003b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		size = 2*kilo;
  8003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b7:	01 c0                	add    %eax,%eax
  8003b9:	89 45 ac             	mov    %eax,-0x54(%ebp)
		unsigned char *y = malloc(sizeof(unsigned char)*size) ;
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	ff 75 ac             	pushl  -0x54(%ebp)
  8003c2:	e8 bd 16 00 00       	call   801a84 <malloc>
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if(!(((uint32)y == USER_HEAP_START + 12*Mega) && (freeFrames - sys_calculate_free_frames()) == 1))
  8003cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8003d0:	89 d0                	mov    %edx,%eax
  8003d2:	01 c0                	add    %eax,%eax
  8003d4:	01 d0                	add    %edx,%eax
  8003d6:	c1 e0 02             	shl    $0x2,%eax
  8003d9:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
  8003df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e2:	39 c2                	cmp    %eax,%edx
  8003e4:	75 11                	jne    8003f7 <_main+0x3bf>
  8003e6:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  8003e9:	e8 6b 1d 00 00       	call   802159 <sys_calculate_free_frames>
  8003ee:	29 c3                	sub    %eax,%ebx
  8003f0:	89 d8                	mov    %ebx,%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	74 14                	je     80040b <_main+0x3d3>
			panic("malloc() does not work correctly... check it before checking freeHeap") ;
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	68 68 29 80 00       	push   $0x802968
  8003ff:	6a 37                	push   $0x37
  800401:	68 09 29 80 00       	push   $0x802909
  800406:	e8 4d 06 00 00       	call   800a58 <_panic>


		x[1]=-1;
  80040b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80040e:	40                   	inc    %eax
  80040f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	89 c2                	mov    %eax,%edx
  80041a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c6 00 ff             	movb   $0xff,(%eax)

		x[512*kilo]=-1;
  800422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800425:	c1 e0 09             	shl    $0x9,%eax
  800428:	89 c2                	mov    %eax,%edx
  80042a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042d:	01 d0                	add    %edx,%eax
  80042f:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	ff 75 a8             	pushl  -0x58(%ebp)
  800438:	e8 76 18 00 00       	call   801cb3 <free>
  80043d:	83 c4 10             	add    $0x10,%esp
		free(y);
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	ff 75 a4             	pushl  -0x5c(%ebp)
  800446:	e8 68 18 00 00       	call   801cb3 <free>
  80044b:	83 c4 10             	add    $0x10,%esp

		if((origFreeFrames - sys_calculate_free_frames()) != 4 ) panic("FreeHeap didn't correctly free the allocated memory (pages and/or tables)");
  80044e:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
  800451:	e8 03 1d 00 00       	call   802159 <sys_calculate_free_frames>
  800456:	29 c3                	sub    %eax,%ebx
  800458:	89 d8                	mov    %ebx,%eax
  80045a:	83 f8 04             	cmp    $0x4,%eax
  80045d:	74 14                	je     800473 <_main+0x43b>
  80045f:	83 ec 04             	sub    $0x4,%esp
  800462:	68 b0 29 80 00       	push   $0x8029b0
  800467:	6a 43                	push   $0x43
  800469:	68 09 29 80 00       	push   $0x802909
  80046e:	e8 e5 05 00 00       	call   800a58 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0 ) panic("FreeHeap didn't correctly free the allocated space (pages and/or tables) in PageFile");
  800473:	e8 64 1d 00 00       	call   8021dc <sys_pf_calculate_allocated_pages>
  800478:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  80047b:	74 14                	je     800491 <_main+0x459>
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	68 fc 29 80 00       	push   $0x8029fc
  800485:	6a 44                	push   $0x44
  800487:	68 09 29 80 00       	push   $0x802909
  80048c:	e8 c7 05 00 00       	call   800a58 <_panic>

		{
			if( ROUNDDOWN(myEnv->__ptr_tws[0].virtual_address,1024*PAGE_SIZE) !=  0x0)  panic("TABLE WS entry checking failed");
  800491:	a1 20 40 80 00       	mov    0x804020,%eax
  800496:	8b 80 f8 38 01 00    	mov    0x138f8(%eax),%eax
  80049c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80049f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004a2:	25 00 00 c0 ff       	and    $0xffc00000,%eax
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	74 14                	je     8004bf <_main+0x487>
  8004ab:	83 ec 04             	sub    $0x4,%esp
  8004ae:	68 54 2a 80 00       	push   $0x802a54
  8004b3:	6a 47                	push   $0x47
  8004b5:	68 09 29 80 00       	push   $0x802909
  8004ba:	e8 99 05 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__ptr_tws[1].virtual_address,1024*PAGE_SIZE) !=  0x800000)  panic("TABLE WS entry checking failed");
  8004bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c4:	8b 80 08 39 01 00    	mov    0x13908(%eax),%eax
  8004ca:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8004cd:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004d0:	25 00 00 c0 ff       	and    $0xffc00000,%eax
  8004d5:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8004da:	74 14                	je     8004f0 <_main+0x4b8>
  8004dc:	83 ec 04             	sub    $0x4,%esp
  8004df:	68 54 2a 80 00       	push   $0x802a54
  8004e4:	6a 48                	push   $0x48
  8004e6:	68 09 29 80 00       	push   $0x802909
  8004eb:	e8 68 05 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__ptr_tws[2].virtual_address,1024*PAGE_SIZE) !=  0xee800000)  panic("TABLE WS entry checking failed");
  8004f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f5:	8b 80 18 39 01 00    	mov    0x13918(%eax),%eax
  8004fb:	89 45 98             	mov    %eax,-0x68(%ebp)
  8004fe:	8b 45 98             	mov    -0x68(%ebp),%eax
  800501:	25 00 00 c0 ff       	and    $0xffc00000,%eax
  800506:	3d 00 00 80 ee       	cmp    $0xee800000,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 54 2a 80 00       	push   $0x802a54
  800515:	6a 49                	push   $0x49
  800517:	68 09 29 80 00       	push   $0x802909
  80051c:	e8 37 05 00 00       	call   800a58 <_panic>
			if( myEnv->__ptr_tws[3].empty != 1 )  panic("TABLE WS entry checking failed.. Expected to be EMPTY after FreeHeap");
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8a 80 2c 39 01 00    	mov    0x1392c(%eax),%al
  80052c:	3c 01                	cmp    $0x1,%al
  80052e:	74 14                	je     800544 <_main+0x50c>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 74 2a 80 00       	push   $0x802a74
  800538:	6a 4a                	push   $0x4a
  80053a:	68 09 29 80 00       	push   $0x802909
  80053f:	e8 14 05 00 00       	call   800a58 <_panic>
			if( myEnv->__ptr_tws[4].empty != 1 )  panic("TABLE WS entry checking failed.. Expected to be EMPTY after FreeHeap");
  800544:	a1 20 40 80 00       	mov    0x804020,%eax
  800549:	8a 80 3c 39 01 00    	mov    0x1393c(%eax),%al
  80054f:	3c 01                	cmp    $0x1,%al
  800551:	74 14                	je     800567 <_main+0x52f>
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	68 74 2a 80 00       	push   $0x802a74
  80055b:	6a 4b                	push   $0x4b
  80055d:	68 09 29 80 00       	push   $0x802909
  800562:	e8 f1 04 00 00       	call   800a58 <_panic>

			if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  panic("PAGE WS entry checking failed");
  800567:	a1 20 40 80 00       	mov    0x804020,%eax
  80056c:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800577:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80057a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057f:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800584:	74 14                	je     80059a <_main+0x562>
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	68 b9 2a 80 00       	push   $0x802ab9
  80058e:	6a 4d                	push   $0x4d
  800590:	68 09 29 80 00       	push   $0x802909
  800595:	e8 be 04 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("PAGE WS entry checking failed");
  80059a:	a1 20 40 80 00       	mov    0x804020,%eax
  80059f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005a5:	83 c0 10             	add    $0x10,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005ad:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b5:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 b9 2a 80 00       	push   $0x802ab9
  8005c4:	6a 4e                	push   $0x4e
  8005c6:	68 09 29 80 00       	push   $0x802909
  8005cb:	e8 88 04 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("PAGE WS entry checking failed");
  8005d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d5:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005db:	83 c0 20             	add    $0x20,%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005e3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005eb:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 b9 2a 80 00       	push   $0x802ab9
  8005fa:	6a 4f                	push   $0x4f
  8005fc:	68 09 29 80 00       	push   $0x802909
  800601:	e8 52 04 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("PAGE WS entry checking failed");
  800606:	a1 20 40 80 00       	mov    0x804020,%eax
  80060b:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800611:	83 c0 30             	add    $0x30,%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 88             	mov    %eax,-0x78(%ebp)
  800619:	8b 45 88             	mov    -0x78(%ebp),%eax
  80061c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800621:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800626:	74 14                	je     80063c <_main+0x604>
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	68 b9 2a 80 00       	push   $0x802ab9
  800630:	6a 50                	push   $0x50
  800632:	68 09 29 80 00       	push   $0x802909
  800637:	e8 1c 04 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("PAGE WS entry checking failed");
  80063c:	a1 20 40 80 00       	mov    0x804020,%eax
  800641:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800647:	83 c0 40             	add    $0x40,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  80064f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800652:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800657:	3d 00 40 20 00       	cmp    $0x204000,%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 b9 2a 80 00       	push   $0x802ab9
  800666:	6a 51                	push   $0x51
  800668:	68 09 29 80 00       	push   $0x802909
  80066d:	e8 e6 03 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("PAGE WS entry checking failed");
  800672:	a1 20 40 80 00       	mov    0x804020,%eax
  800677:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80067d:	83 c0 50             	add    $0x50,%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	89 45 80             	mov    %eax,-0x80(%ebp)
  800685:	8b 45 80             	mov    -0x80(%ebp),%eax
  800688:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80068d:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 b9 2a 80 00       	push   $0x802ab9
  80069c:	6a 52                	push   $0x52
  80069e:	68 09 29 80 00       	push   $0x802909
  8006a3:	e8 b0 03 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("PAGE WS entry checking failed");
  8006a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ad:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8006b3:	83 c0 60             	add    $0x60,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  8006be:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006c9:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8006ce:	74 14                	je     8006e4 <_main+0x6ac>
  8006d0:	83 ec 04             	sub    $0x4,%esp
  8006d3:	68 b9 2a 80 00       	push   $0x802ab9
  8006d8:	6a 53                	push   $0x53
  8006da:	68 09 29 80 00       	push   $0x802909
  8006df:	e8 74 03 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("PAGE WS entry checking failed");
  8006e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006e9:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8006ef:	83 c0 70             	add    $0x70,%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  8006fa:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800700:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800705:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80070a:	74 14                	je     800720 <_main+0x6e8>
  80070c:	83 ec 04             	sub    $0x4,%esp
  80070f:	68 b9 2a 80 00       	push   $0x802ab9
  800714:	6a 54                	push   $0x54
  800716:	68 09 29 80 00       	push   $0x802909
  80071b:	e8 38 03 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("PAGE WS entry checking failed");
  800720:	a1 20 40 80 00       	mov    0x804020,%eax
  800725:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80072b:	83 e8 80             	sub    $0xffffff80,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  800736:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80073c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800741:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800746:	74 14                	je     80075c <_main+0x724>
  800748:	83 ec 04             	sub    $0x4,%esp
  80074b:	68 b9 2a 80 00       	push   $0x802ab9
  800750:	6a 55                	push   $0x55
  800752:	68 09 29 80 00       	push   $0x802909
  800757:	e8 fc 02 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("PAGE WS entry checking failed");
  80075c:	a1 20 40 80 00       	mov    0x804020,%eax
  800761:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800767:	05 90 00 00 00       	add    $0x90,%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800774:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80077a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80077f:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800784:	74 14                	je     80079a <_main+0x762>
  800786:	83 ec 04             	sub    $0x4,%esp
  800789:	68 b9 2a 80 00       	push   $0x802ab9
  80078e:	6a 56                	push   $0x56
  800790:	68 09 29 80 00       	push   $0x802909
  800795:	e8 be 02 00 00       	call   800a58 <_panic>
			if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("PAGE WS entry checking failed");
  80079a:	a1 20 40 80 00       	mov    0x804020,%eax
  80079f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007a5:	05 a0 00 00 00       	add    $0xa0,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  8007b2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007bd:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8007c2:	74 14                	je     8007d8 <_main+0x7a0>
  8007c4:	83 ec 04             	sub    $0x4,%esp
  8007c7:	68 b9 2a 80 00       	push   $0x802ab9
  8007cc:	6a 57                	push   $0x57
  8007ce:	68 09 29 80 00       	push   $0x802909
  8007d3:	e8 80 02 00 00       	call   800a58 <_panic>
			if( myEnv->__uptr_pws[11].empty != 1)  panic("PAGE WS entry checking failed.. Expected to be EMPTY after FreeHeap");
  8007d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8007dd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007e3:	05 b0 00 00 00       	add    $0xb0,%eax
  8007e8:	8a 40 04             	mov    0x4(%eax),%al
  8007eb:	3c 01                	cmp    $0x1,%al
  8007ed:	74 14                	je     800803 <_main+0x7cb>
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	68 d8 2a 80 00       	push   $0x802ad8
  8007f7:	6a 58                	push   $0x58
  8007f9:	68 09 29 80 00       	push   $0x802909
  8007fe:	e8 55 02 00 00       	call   800a58 <_panic>
			if( myEnv->__uptr_pws[12].empty != 1)  panic("PAGE WS entry checking failed.. Expected to be EMPTY after FreeHeap");
  800803:	a1 20 40 80 00       	mov    0x804020,%eax
  800808:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80080e:	05 c0 00 00 00       	add    $0xc0,%eax
  800813:	8a 40 04             	mov    0x4(%eax),%al
  800816:	3c 01                	cmp    $0x1,%al
  800818:	74 14                	je     80082e <_main+0x7f6>
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	68 d8 2a 80 00       	push   $0x802ad8
  800822:	6a 59                	push   $0x59
  800824:	68 09 29 80 00       	push   $0x802909
  800829:	e8 2a 02 00 00       	call   800a58 <_panic>
			if( myEnv->__uptr_pws[13].empty != 1)  panic("PAGE WS entry checking failed.. Expected to be EMPTY after FreeHeap");
  80082e:	a1 20 40 80 00       	mov    0x804020,%eax
  800833:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800839:	05 d0 00 00 00       	add    $0xd0,%eax
  80083e:	8a 40 04             	mov    0x4(%eax),%al
  800841:	3c 01                	cmp    $0x1,%al
  800843:	74 14                	je     800859 <_main+0x821>
  800845:	83 ec 04             	sub    $0x4,%esp
  800848:	68 d8 2a 80 00       	push   $0x802ad8
  80084d:	6a 5a                	push   $0x5a
  80084f:	68 09 29 80 00       	push   $0x802909
  800854:	e8 ff 01 00 00       	call   800a58 <_panic>
			if( myEnv->__uptr_pws[14].empty != 1)  panic("PAGE WS entry checking failed.. Expected to be EMPTY after FreeHeap");
  800859:	a1 20 40 80 00       	mov    0x804020,%eax
  80085e:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800864:	05 e0 00 00 00       	add    $0xe0,%eax
  800869:	8a 40 04             	mov    0x4(%eax),%al
  80086c:	3c 01                	cmp    $0x1,%al
  80086e:	74 14                	je     800884 <_main+0x84c>
  800870:	83 ec 04             	sub    $0x4,%esp
  800873:	68 d8 2a 80 00       	push   $0x802ad8
  800878:	6a 5b                	push   $0x5b
  80087a:	68 09 29 80 00       	push   $0x802909
  80087f:	e8 d4 01 00 00       	call   800a58 <_panic>
		}

		//Checking if freeHeap RESET the HEAP POINTER or not
		{
			unsigned char *z = malloc(sizeof(unsigned char)*1) ;
  800884:	83 ec 0c             	sub    $0xc,%esp
  800887:	6a 01                	push   $0x1
  800889:	e8 f6 11 00 00       	call   801a84 <malloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

			if(!((uint32)z == USER_HEAP_START) )
  800897:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80089d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8008a2:	74 14                	je     8008b8 <_main+0x880>
				panic("ERROR: freeHeap didn't reset the HEAP POINTER after finishing... Kindly reset it!!") ;
  8008a4:	83 ec 04             	sub    $0x4,%esp
  8008a7:	68 1c 2b 80 00       	push   $0x802b1c
  8008ac:	6a 63                	push   $0x63
  8008ae:	68 09 29 80 00       	push   $0x802909
  8008b3:	e8 a0 01 00 00       	call   800a58 <_panic>
		}
		cprintf("Congratulations!! test freeHeap completed successfully.\n");
  8008b8:	83 ec 0c             	sub    $0xc,%esp
  8008bb:	68 70 2b 80 00       	push   $0x802b70
  8008c0:	e8 35 04 00 00       	call   800cfa <cprintf>
  8008c5:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed pages in the HEAP, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  8008c8:	83 ec 0c             	sub    $0xc,%esp
  8008cb:	68 ac 2b 80 00       	push   $0x802bac
  8008d0:	e8 25 04 00 00       	call   800cfa <cprintf>
  8008d5:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  8008d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8008db:	40                   	inc    %eax
  8008dc:	c6 00 ff             	movb   $0xff,(%eax)

			x[8*Mega] = -1;
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	c1 e0 03             	shl    $0x3,%eax
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8008ea:	01 d0                	add    %edx,%eax
  8008ec:	c6 00 ff             	movb   $0xff,(%eax)

			x[512*kilo]=-1;
  8008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f2:	c1 e0 09             	shl    $0x9,%eax
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8008fa:	01 d0                	add    %edx,%eax
  8008fc:	c6 00 ff             	movb   $0xff,(%eax)

		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8008ff:	83 ec 04             	sub    $0x4,%esp
  800902:	68 90 2c 80 00       	push   $0x802c90
  800907:	6a 72                	push   $0x72
  800909:	68 09 29 80 00       	push   $0x802909
  80090e:	e8 45 01 00 00       	call   800a58 <_panic>

00800913 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800919:	e8 70 17 00 00       	call   80208e <sys_getenvindex>
  80091e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800924:	89 d0                	mov    %edx,%eax
  800926:	c1 e0 03             	shl    $0x3,%eax
  800929:	01 d0                	add    %edx,%eax
  80092b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800932:	01 c8                	add    %ecx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	01 c0                	add    %eax,%eax
  80093a:	01 d0                	add    %edx,%eax
  80093c:	89 c2                	mov    %eax,%edx
  80093e:	c1 e2 05             	shl    $0x5,%edx
  800941:	29 c2                	sub    %eax,%edx
  800943:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80094a:	89 c2                	mov    %eax,%edx
  80094c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800952:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800957:	a1 20 40 80 00       	mov    0x804020,%eax
  80095c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800962:	84 c0                	test   %al,%al
  800964:	74 0f                	je     800975 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800966:	a1 20 40 80 00       	mov    0x804020,%eax
  80096b:	05 40 3c 01 00       	add    $0x13c40,%eax
  800970:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800979:	7e 0a                	jle    800985 <libmain+0x72>
		binaryname = argv[0];
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	e8 a5 f6 ff ff       	call   800038 <_main>
  800993:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800996:	e8 8e 18 00 00       	call   802229 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80099b:	83 ec 0c             	sub    $0xc,%esp
  80099e:	68 b0 2d 80 00       	push   $0x802db0
  8009a3:	e8 52 03 00 00       	call   800cfa <cprintf>
  8009a8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ab:	a1 20 40 80 00       	mov    0x804020,%eax
  8009b0:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  8009b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8009bb:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8009c1:	83 ec 04             	sub    $0x4,%esp
  8009c4:	52                   	push   %edx
  8009c5:	50                   	push   %eax
  8009c6:	68 d8 2d 80 00       	push   $0x802dd8
  8009cb:	e8 2a 03 00 00       	call   800cfa <cprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8009d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8009d8:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8009de:	a1 20 40 80 00       	mov    0x804020,%eax
  8009e3:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	52                   	push   %edx
  8009ed:	50                   	push   %eax
  8009ee:	68 00 2e 80 00       	push   $0x802e00
  8009f3:	e8 02 03 00 00       	call   800cfa <cprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800a00:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	50                   	push   %eax
  800a0a:	68 41 2e 80 00       	push   $0x802e41
  800a0f:	e8 e6 02 00 00       	call   800cfa <cprintf>
  800a14:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a17:	83 ec 0c             	sub    $0xc,%esp
  800a1a:	68 b0 2d 80 00       	push   $0x802db0
  800a1f:	e8 d6 02 00 00       	call   800cfa <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a27:	e8 17 18 00 00       	call   802243 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a2c:	e8 19 00 00 00       	call   800a4a <exit>
}
  800a31:	90                   	nop
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800a3a:	83 ec 0c             	sub    $0xc,%esp
  800a3d:	6a 00                	push   $0x0
  800a3f:	e8 16 16 00 00       	call   80205a <sys_env_destroy>
  800a44:	83 c4 10             	add    $0x10,%esp
}
  800a47:	90                   	nop
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <exit>:

void
exit(void)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a50:	e8 6b 16 00 00       	call   8020c0 <sys_env_exit>
}
  800a55:	90                   	nop
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a5e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a61:	83 c0 04             	add    $0x4,%eax
  800a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a67:	a1 18 41 80 00       	mov    0x804118,%eax
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	74 16                	je     800a86 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a70:	a1 18 41 80 00       	mov    0x804118,%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	50                   	push   %eax
  800a79:	68 58 2e 80 00       	push   $0x802e58
  800a7e:	e8 77 02 00 00       	call   800cfa <cprintf>
  800a83:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a86:	a1 00 40 80 00       	mov    0x804000,%eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	50                   	push   %eax
  800a92:	68 5d 2e 80 00       	push   $0x802e5d
  800a97:	e8 5e 02 00 00       	call   800cfa <cprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa8:	50                   	push   %eax
  800aa9:	e8 e1 01 00 00       	call   800c8f <vcprintf>
  800aae:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	6a 00                	push   $0x0
  800ab6:	68 79 2e 80 00       	push   $0x802e79
  800abb:	e8 cf 01 00 00       	call   800c8f <vcprintf>
  800ac0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ac3:	e8 82 ff ff ff       	call   800a4a <exit>

	// should not return here
	while (1) ;
  800ac8:	eb fe                	jmp    800ac8 <_panic+0x70>

00800aca <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ad0:	a1 20 40 80 00       	mov    0x804020,%eax
  800ad5:	8b 50 74             	mov    0x74(%eax),%edx
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	39 c2                	cmp    %eax,%edx
  800add:	74 14                	je     800af3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800adf:	83 ec 04             	sub    $0x4,%esp
  800ae2:	68 7c 2e 80 00       	push   $0x802e7c
  800ae7:	6a 26                	push   $0x26
  800ae9:	68 c8 2e 80 00       	push   $0x802ec8
  800aee:	e8 65 ff ff ff       	call   800a58 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800afa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b01:	e9 b6 00 00 00       	jmp    800bbc <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	01 d0                	add    %edx,%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	85 c0                	test   %eax,%eax
  800b19:	75 08                	jne    800b23 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b1b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b1e:	e9 96 00 00 00       	jmp    800bb9 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800b23:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b31:	eb 5d                	jmp    800b90 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b33:	a1 20 40 80 00       	mov    0x804020,%eax
  800b38:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b41:	c1 e2 04             	shl    $0x4,%edx
  800b44:	01 d0                	add    %edx,%eax
  800b46:	8a 40 04             	mov    0x4(%eax),%al
  800b49:	84 c0                	test   %al,%al
  800b4b:	75 40                	jne    800b8d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b4d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b52:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b5b:	c1 e2 04             	shl    $0x4,%edx
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	8b 00                	mov    (%eax),%eax
  800b62:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b6d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b72:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	01 c8                	add    %ecx,%eax
  800b7e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	75 09                	jne    800b8d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800b84:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b8b:	eb 12                	jmp    800b9f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b8d:	ff 45 e8             	incl   -0x18(%ebp)
  800b90:	a1 20 40 80 00       	mov    0x804020,%eax
  800b95:	8b 50 74             	mov    0x74(%eax),%edx
  800b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b9b:	39 c2                	cmp    %eax,%edx
  800b9d:	77 94                	ja     800b33 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ba3:	75 14                	jne    800bb9 <CheckWSWithoutLastIndex+0xef>
			panic(
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 d4 2e 80 00       	push   $0x802ed4
  800bad:	6a 3a                	push   $0x3a
  800baf:	68 c8 2e 80 00       	push   $0x802ec8
  800bb4:	e8 9f fe ff ff       	call   800a58 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800bb9:	ff 45 f0             	incl   -0x10(%ebp)
  800bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800bc2:	0f 8c 3e ff ff ff    	jl     800b06 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800bc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bcf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bd6:	eb 20                	jmp    800bf8 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bd8:	a1 20 40 80 00       	mov    0x804020,%eax
  800bdd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800be3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800be6:	c1 e2 04             	shl    $0x4,%edx
  800be9:	01 d0                	add    %edx,%eax
  800beb:	8a 40 04             	mov    0x4(%eax),%al
  800bee:	3c 01                	cmp    $0x1,%al
  800bf0:	75 03                	jne    800bf5 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800bf2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf5:	ff 45 e0             	incl   -0x20(%ebp)
  800bf8:	a1 20 40 80 00       	mov    0x804020,%eax
  800bfd:	8b 50 74             	mov    0x74(%eax),%edx
  800c00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c03:	39 c2                	cmp    %eax,%edx
  800c05:	77 d1                	ja     800bd8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c0d:	74 14                	je     800c23 <CheckWSWithoutLastIndex+0x159>
		panic(
  800c0f:	83 ec 04             	sub    $0x4,%esp
  800c12:	68 28 2f 80 00       	push   $0x802f28
  800c17:	6a 44                	push   $0x44
  800c19:	68 c8 2e 80 00       	push   $0x802ec8
  800c1e:	e8 35 fe ff ff       	call   800a58 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c23:	90                   	nop
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	8d 48 01             	lea    0x1(%eax),%ecx
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	89 0a                	mov    %ecx,(%edx)
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	88 d1                	mov    %dl,%cl
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c4f:	75 2c                	jne    800c7d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c51:	a0 24 40 80 00       	mov    0x804024,%al
  800c56:	0f b6 c0             	movzbl %al,%eax
  800c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5c:	8b 12                	mov    (%edx),%edx
  800c5e:	89 d1                	mov    %edx,%ecx
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	83 c2 08             	add    $0x8,%edx
  800c66:	83 ec 04             	sub    $0x4,%esp
  800c69:	50                   	push   %eax
  800c6a:	51                   	push   %ecx
  800c6b:	52                   	push   %edx
  800c6c:	e8 a7 13 00 00       	call   802018 <sys_cputs>
  800c71:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 04             	mov    0x4(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c8c:	90                   	nop
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c98:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c9f:	00 00 00 
	b.cnt = 0;
  800ca2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ca9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800cac:	ff 75 0c             	pushl  0xc(%ebp)
  800caf:	ff 75 08             	pushl  0x8(%ebp)
  800cb2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cb8:	50                   	push   %eax
  800cb9:	68 26 0c 80 00       	push   $0x800c26
  800cbe:	e8 11 02 00 00       	call   800ed4 <vprintfmt>
  800cc3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cc6:	a0 24 40 80 00       	mov    0x804024,%al
  800ccb:	0f b6 c0             	movzbl %al,%eax
  800cce:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cd4:	83 ec 04             	sub    $0x4,%esp
  800cd7:	50                   	push   %eax
  800cd8:	52                   	push   %edx
  800cd9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cdf:	83 c0 08             	add    $0x8,%eax
  800ce2:	50                   	push   %eax
  800ce3:	e8 30 13 00 00       	call   802018 <sys_cputs>
  800ce8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ceb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800cf2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <cprintf>:

int cprintf(const char *fmt, ...) {
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d00:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800d07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 f4             	pushl  -0xc(%ebp)
  800d16:	50                   	push   %eax
  800d17:	e8 73 ff ff ff       	call   800c8f <vcprintf>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d2d:	e8 f7 14 00 00       	call   802229 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d41:	50                   	push   %eax
  800d42:	e8 48 ff ff ff       	call   800c8f <vcprintf>
  800d47:	83 c4 10             	add    $0x10,%esp
  800d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d4d:	e8 f1 14 00 00       	call   802243 <sys_enable_interrupt>
	return cnt;
  800d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 14             	sub    $0x14,%esp
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d64:	8b 45 14             	mov    0x14(%ebp),%eax
  800d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d72:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d75:	77 55                	ja     800dcc <printnum+0x75>
  800d77:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d7a:	72 05                	jb     800d81 <printnum+0x2a>
  800d7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d7f:	77 4b                	ja     800dcc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d81:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d84:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d87:	8b 45 18             	mov    0x18(%ebp),%eax
  800d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8f:	52                   	push   %edx
  800d90:	50                   	push   %eax
  800d91:	ff 75 f4             	pushl  -0xc(%ebp)
  800d94:	ff 75 f0             	pushl  -0x10(%ebp)
  800d97:	e8 b0 18 00 00       	call   80264c <__udivdi3>
  800d9c:	83 c4 10             	add    $0x10,%esp
  800d9f:	83 ec 04             	sub    $0x4,%esp
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	53                   	push   %ebx
  800da6:	ff 75 18             	pushl  0x18(%ebp)
  800da9:	52                   	push   %edx
  800daa:	50                   	push   %eax
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	ff 75 08             	pushl  0x8(%ebp)
  800db1:	e8 a1 ff ff ff       	call   800d57 <printnum>
  800db6:	83 c4 20             	add    $0x20,%esp
  800db9:	eb 1a                	jmp    800dd5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	ff 75 20             	pushl  0x20(%ebp)
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	ff d0                	call   *%eax
  800dc9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dcc:	ff 4d 1c             	decl   0x1c(%ebp)
  800dcf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dd3:	7f e6                	jg     800dbb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dd5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	53                   	push   %ebx
  800de4:	51                   	push   %ecx
  800de5:	52                   	push   %edx
  800de6:	50                   	push   %eax
  800de7:	e8 70 19 00 00       	call   80275c <__umoddi3>
  800dec:	83 c4 10             	add    $0x10,%esp
  800def:	05 94 31 80 00       	add    $0x803194,%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	0f be c0             	movsbl %al,%eax
  800df9:	83 ec 08             	sub    $0x8,%esp
  800dfc:	ff 75 0c             	pushl  0xc(%ebp)
  800dff:	50                   	push   %eax
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	ff d0                	call   *%eax
  800e05:	83 c4 10             	add    $0x10,%esp
}
  800e08:	90                   	nop
  800e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e15:	7e 1c                	jle    800e33 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8b 00                	mov    (%eax),%eax
  800e1c:	8d 50 08             	lea    0x8(%eax),%edx
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	89 10                	mov    %edx,(%eax)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8b 00                	mov    (%eax),%eax
  800e29:	83 e8 08             	sub    $0x8,%eax
  800e2c:	8b 50 04             	mov    0x4(%eax),%edx
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	eb 40                	jmp    800e73 <getuint+0x65>
	else if (lflag)
  800e33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e37:	74 1e                	je     800e57 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	8d 50 04             	lea    0x4(%eax),%edx
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 10                	mov    %edx,(%eax)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 00                	mov    (%eax),%eax
  800e4b:	83 e8 04             	sub    $0x4,%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	ba 00 00 00 00       	mov    $0x0,%edx
  800e55:	eb 1c                	jmp    800e73 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8b 00                	mov    (%eax),%eax
  800e5c:	8d 50 04             	lea    0x4(%eax),%edx
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 10                	mov    %edx,(%eax)
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8b 00                	mov    (%eax),%eax
  800e69:	83 e8 04             	sub    $0x4,%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e7c:	7e 1c                	jle    800e9a <getint+0x25>
		return va_arg(*ap, long long);
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8b 00                	mov    (%eax),%eax
  800e83:	8d 50 08             	lea    0x8(%eax),%edx
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 10                	mov    %edx,(%eax)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8b 00                	mov    (%eax),%eax
  800e90:	83 e8 08             	sub    $0x8,%eax
  800e93:	8b 50 04             	mov    0x4(%eax),%edx
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	eb 38                	jmp    800ed2 <getint+0x5d>
	else if (lflag)
  800e9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e9e:	74 1a                	je     800eba <getint+0x45>
		return va_arg(*ap, long);
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8b 00                	mov    (%eax),%eax
  800ea5:	8d 50 04             	lea    0x4(%eax),%edx
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 10                	mov    %edx,(%eax)
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	83 e8 04             	sub    $0x4,%eax
  800eb5:	8b 00                	mov    (%eax),%eax
  800eb7:	99                   	cltd   
  800eb8:	eb 18                	jmp    800ed2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	8d 50 04             	lea    0x4(%eax),%edx
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 10                	mov    %edx,(%eax)
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8b 00                	mov    (%eax),%eax
  800ecc:	83 e8 04             	sub    $0x4,%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	99                   	cltd   
}
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    

00800ed4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800edc:	eb 17                	jmp    800ef5 <vprintfmt+0x21>
			if (ch == '\0')
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	0f 84 af 03 00 00    	je     801295 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	53                   	push   %ebx
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	ff d0                	call   *%eax
  800ef2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef8:	8d 50 01             	lea    0x1(%eax),%edx
  800efb:	89 55 10             	mov    %edx,0x10(%ebp)
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	0f b6 d8             	movzbl %al,%ebx
  800f03:	83 fb 25             	cmp    $0x25,%ebx
  800f06:	75 d6                	jne    800ede <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f08:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	8d 50 01             	lea    0x1(%eax),%edx
  800f2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d8             	movzbl %al,%ebx
  800f36:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f39:	83 f8 55             	cmp    $0x55,%eax
  800f3c:	0f 87 2b 03 00 00    	ja     80126d <vprintfmt+0x399>
  800f42:	8b 04 85 b8 31 80 00 	mov    0x8031b8(,%eax,4),%eax
  800f49:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f4b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f4f:	eb d7                	jmp    800f28 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f51:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f55:	eb d1                	jmp    800f28 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f61:	89 d0                	mov    %edx,%eax
  800f63:	c1 e0 02             	shl    $0x2,%eax
  800f66:	01 d0                	add    %edx,%eax
  800f68:	01 c0                	add    %eax,%eax
  800f6a:	01 d8                	add    %ebx,%eax
  800f6c:	83 e8 30             	sub    $0x30,%eax
  800f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f7a:	83 fb 2f             	cmp    $0x2f,%ebx
  800f7d:	7e 3e                	jle    800fbd <vprintfmt+0xe9>
  800f7f:	83 fb 39             	cmp    $0x39,%ebx
  800f82:	7f 39                	jg     800fbd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f84:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f87:	eb d5                	jmp    800f5e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	83 c0 04             	add    $0x4,%eax
  800f8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f92:	8b 45 14             	mov    0x14(%ebp),%eax
  800f95:	83 e8 04             	sub    $0x4,%eax
  800f98:	8b 00                	mov    (%eax),%eax
  800f9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f9d:	eb 1f                	jmp    800fbe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	79 83                	jns    800f28 <vprintfmt+0x54>
				width = 0;
  800fa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fac:	e9 77 ff ff ff       	jmp    800f28 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fb1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fb8:	e9 6b ff ff ff       	jmp    800f28 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fbd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc2:	0f 89 60 ff ff ff    	jns    800f28 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fd5:	e9 4e ff ff ff       	jmp    800f28 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fda:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fdd:	e9 46 ff ff ff       	jmp    800f28 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fe2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe5:	83 c0 04             	add    $0x4,%eax
  800fe8:	89 45 14             	mov    %eax,0x14(%ebp)
  800feb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fee:	83 e8 04             	sub    $0x4,%eax
  800ff1:	8b 00                	mov    (%eax),%eax
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	50                   	push   %eax
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	ff d0                	call   *%eax
  800fff:	83 c4 10             	add    $0x10,%esp
			break;
  801002:	e9 89 02 00 00       	jmp    801290 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	83 c0 04             	add    $0x4,%eax
  80100d:	89 45 14             	mov    %eax,0x14(%ebp)
  801010:	8b 45 14             	mov    0x14(%ebp),%eax
  801013:	83 e8 04             	sub    $0x4,%eax
  801016:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801018:	85 db                	test   %ebx,%ebx
  80101a:	79 02                	jns    80101e <vprintfmt+0x14a>
				err = -err;
  80101c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80101e:	83 fb 64             	cmp    $0x64,%ebx
  801021:	7f 0b                	jg     80102e <vprintfmt+0x15a>
  801023:	8b 34 9d 00 30 80 00 	mov    0x803000(,%ebx,4),%esi
  80102a:	85 f6                	test   %esi,%esi
  80102c:	75 19                	jne    801047 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80102e:	53                   	push   %ebx
  80102f:	68 a5 31 80 00       	push   $0x8031a5
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	ff 75 08             	pushl  0x8(%ebp)
  80103a:	e8 5e 02 00 00       	call   80129d <printfmt>
  80103f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801042:	e9 49 02 00 00       	jmp    801290 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801047:	56                   	push   %esi
  801048:	68 ae 31 80 00       	push   $0x8031ae
  80104d:	ff 75 0c             	pushl  0xc(%ebp)
  801050:	ff 75 08             	pushl  0x8(%ebp)
  801053:	e8 45 02 00 00       	call   80129d <printfmt>
  801058:	83 c4 10             	add    $0x10,%esp
			break;
  80105b:	e9 30 02 00 00       	jmp    801290 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	83 c0 04             	add    $0x4,%eax
  801066:	89 45 14             	mov    %eax,0x14(%ebp)
  801069:	8b 45 14             	mov    0x14(%ebp),%eax
  80106c:	83 e8 04             	sub    $0x4,%eax
  80106f:	8b 30                	mov    (%eax),%esi
  801071:	85 f6                	test   %esi,%esi
  801073:	75 05                	jne    80107a <vprintfmt+0x1a6>
				p = "(null)";
  801075:	be b1 31 80 00       	mov    $0x8031b1,%esi
			if (width > 0 && padc != '-')
  80107a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107e:	7e 6d                	jle    8010ed <vprintfmt+0x219>
  801080:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801084:	74 67                	je     8010ed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801086:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	50                   	push   %eax
  80108d:	56                   	push   %esi
  80108e:	e8 0c 03 00 00       	call   80139f <strnlen>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801099:	eb 16                	jmp    8010b1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80109b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	50                   	push   %eax
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010ae:	ff 4d e4             	decl   -0x1c(%ebp)
  8010b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010b5:	7f e4                	jg     80109b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010b7:	eb 34                	jmp    8010ed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010bd:	74 1c                	je     8010db <vprintfmt+0x207>
  8010bf:	83 fb 1f             	cmp    $0x1f,%ebx
  8010c2:	7e 05                	jle    8010c9 <vprintfmt+0x1f5>
  8010c4:	83 fb 7e             	cmp    $0x7e,%ebx
  8010c7:	7e 12                	jle    8010db <vprintfmt+0x207>
					putch('?', putdat);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	ff 75 0c             	pushl  0xc(%ebp)
  8010cf:	6a 3f                	push   $0x3f
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	ff d0                	call   *%eax
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	eb 0f                	jmp    8010ea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	53                   	push   %ebx
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ed:	89 f0                	mov    %esi,%eax
  8010ef:	8d 70 01             	lea    0x1(%eax),%esi
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	0f be d8             	movsbl %al,%ebx
  8010f7:	85 db                	test   %ebx,%ebx
  8010f9:	74 24                	je     80111f <vprintfmt+0x24b>
  8010fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010ff:	78 b8                	js     8010b9 <vprintfmt+0x1e5>
  801101:	ff 4d e0             	decl   -0x20(%ebp)
  801104:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801108:	79 af                	jns    8010b9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80110a:	eb 13                	jmp    80111f <vprintfmt+0x24b>
				putch(' ', putdat);
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	ff 75 0c             	pushl  0xc(%ebp)
  801112:	6a 20                	push   $0x20
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	ff d0                	call   *%eax
  801119:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80111c:	ff 4d e4             	decl   -0x1c(%ebp)
  80111f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801123:	7f e7                	jg     80110c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801125:	e9 66 01 00 00       	jmp    801290 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80112a:	83 ec 08             	sub    $0x8,%esp
  80112d:	ff 75 e8             	pushl  -0x18(%ebp)
  801130:	8d 45 14             	lea    0x14(%ebp),%eax
  801133:	50                   	push   %eax
  801134:	e8 3c fd ff ff       	call   800e75 <getint>
  801139:	83 c4 10             	add    $0x10,%esp
  80113c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	85 d2                	test   %edx,%edx
  80114a:	79 23                	jns    80116f <vprintfmt+0x29b>
				putch('-', putdat);
  80114c:	83 ec 08             	sub    $0x8,%esp
  80114f:	ff 75 0c             	pushl  0xc(%ebp)
  801152:	6a 2d                	push   $0x2d
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	ff d0                	call   *%eax
  801159:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80115c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801162:	f7 d8                	neg    %eax
  801164:	83 d2 00             	adc    $0x0,%edx
  801167:	f7 da                	neg    %edx
  801169:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80116f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801176:	e9 bc 00 00 00       	jmp    801237 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 e8             	pushl  -0x18(%ebp)
  801181:	8d 45 14             	lea    0x14(%ebp),%eax
  801184:	50                   	push   %eax
  801185:	e8 84 fc ff ff       	call   800e0e <getuint>
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801190:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801193:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80119a:	e9 98 00 00 00       	jmp    801237 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80119f:	83 ec 08             	sub    $0x8,%esp
  8011a2:	ff 75 0c             	pushl  0xc(%ebp)
  8011a5:	6a 58                	push   $0x58
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	ff d0                	call   *%eax
  8011ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011af:	83 ec 08             	sub    $0x8,%esp
  8011b2:	ff 75 0c             	pushl  0xc(%ebp)
  8011b5:	6a 58                	push   $0x58
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	ff d0                	call   *%eax
  8011bc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	6a 58                	push   $0x58
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	ff d0                	call   *%eax
  8011cc:	83 c4 10             	add    $0x10,%esp
			break;
  8011cf:	e9 bc 00 00 00       	jmp    801290 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	6a 30                	push   $0x30
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	ff d0                	call   *%eax
  8011e1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ea:	6a 78                	push   $0x78
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	ff d0                	call   *%eax
  8011f1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f7:	83 c0 04             	add    $0x4,%eax
  8011fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	83 e8 04             	sub    $0x4,%eax
  801203:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801208:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80120f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801216:	eb 1f                	jmp    801237 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801218:	83 ec 08             	sub    $0x8,%esp
  80121b:	ff 75 e8             	pushl  -0x18(%ebp)
  80121e:	8d 45 14             	lea    0x14(%ebp),%eax
  801221:	50                   	push   %eax
  801222:	e8 e7 fb ff ff       	call   800e0e <getuint>
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801230:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801237:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80123b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	52                   	push   %edx
  801242:	ff 75 e4             	pushl  -0x1c(%ebp)
  801245:	50                   	push   %eax
  801246:	ff 75 f4             	pushl  -0xc(%ebp)
  801249:	ff 75 f0             	pushl  -0x10(%ebp)
  80124c:	ff 75 0c             	pushl  0xc(%ebp)
  80124f:	ff 75 08             	pushl  0x8(%ebp)
  801252:	e8 00 fb ff ff       	call   800d57 <printnum>
  801257:	83 c4 20             	add    $0x20,%esp
			break;
  80125a:	eb 34                	jmp    801290 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	53                   	push   %ebx
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	ff d0                	call   *%eax
  801268:	83 c4 10             	add    $0x10,%esp
			break;
  80126b:	eb 23                	jmp    801290 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	ff 75 0c             	pushl  0xc(%ebp)
  801273:	6a 25                	push   $0x25
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	ff d0                	call   *%eax
  80127a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80127d:	ff 4d 10             	decl   0x10(%ebp)
  801280:	eb 03                	jmp    801285 <vprintfmt+0x3b1>
  801282:	ff 4d 10             	decl   0x10(%ebp)
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	48                   	dec    %eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	3c 25                	cmp    $0x25,%al
  80128d:	75 f3                	jne    801282 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80128f:	90                   	nop
		}
	}
  801290:	e9 47 fc ff ff       	jmp    800edc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801295:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801296:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801299:	5b                   	pop    %ebx
  80129a:	5e                   	pop    %esi
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    

0080129d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8012a6:	83 c0 04             	add    $0x4,%eax
  8012a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	ff 75 08             	pushl  0x8(%ebp)
  8012b9:	e8 16 fc ff ff       	call   800ed4 <vprintfmt>
  8012be:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012c1:	90                   	nop
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	8b 40 08             	mov    0x8(%eax),%eax
  8012cd:	8d 50 01             	lea    0x1(%eax),%edx
  8012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	8b 10                	mov    (%eax),%edx
  8012db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012de:	8b 40 04             	mov    0x4(%eax),%eax
  8012e1:	39 c2                	cmp    %eax,%edx
  8012e3:	73 12                	jae    8012f7 <sprintputch+0x33>
		*b->buf++ = ch;
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f0:	89 0a                	mov    %ecx,(%edx)
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	88 10                	mov    %dl,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	8d 50 ff             	lea    -0x1(%eax),%edx
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80131b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131f:	74 06                	je     801327 <vsnprintf+0x2d>
  801321:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801325:	7f 07                	jg     80132e <vsnprintf+0x34>
		return -E_INVAL;
  801327:	b8 03 00 00 00       	mov    $0x3,%eax
  80132c:	eb 20                	jmp    80134e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80132e:	ff 75 14             	pushl  0x14(%ebp)
  801331:	ff 75 10             	pushl  0x10(%ebp)
  801334:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	68 c4 12 80 00       	push   $0x8012c4
  80133d:	e8 92 fb ff ff       	call   800ed4 <vprintfmt>
  801342:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801348:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801356:	8d 45 10             	lea    0x10(%ebp),%eax
  801359:	83 c0 04             	add    $0x4,%eax
  80135c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80135f:	8b 45 10             	mov    0x10(%ebp),%eax
  801362:	ff 75 f4             	pushl  -0xc(%ebp)
  801365:	50                   	push   %eax
  801366:	ff 75 0c             	pushl  0xc(%ebp)
  801369:	ff 75 08             	pushl  0x8(%ebp)
  80136c:	e8 89 ff ff ff       	call   8012fa <vsnprintf>
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801377:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801389:	eb 06                	jmp    801391 <strlen+0x15>
		n++;
  80138b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	75 f1                	jne    80138b <strlen+0xf>
		n++;
	return n;
  80139a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ac:	eb 09                	jmp    8013b7 <strnlen+0x18>
		n++;
  8013ae:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013b1:	ff 45 08             	incl   0x8(%ebp)
  8013b4:	ff 4d 0c             	decl   0xc(%ebp)
  8013b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013bb:	74 09                	je     8013c6 <strnlen+0x27>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	84 c0                	test   %al,%al
  8013c4:	75 e8                	jne    8013ae <strnlen+0xf>
		n++;
	return n;
  8013c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013d7:	90                   	nop
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8d 50 01             	lea    0x1(%eax),%edx
  8013de:	89 55 08             	mov    %edx,0x8(%ebp)
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ea:	8a 12                	mov    (%edx),%dl
  8013ec:	88 10                	mov    %dl,(%eax)
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	84 c0                	test   %al,%al
  8013f2:	75 e4                	jne    8013d8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801405:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140c:	eb 1f                	jmp    80142d <strncpy+0x34>
		*dst++ = *src;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8d 50 01             	lea    0x1(%eax),%edx
  801414:	89 55 08             	mov    %edx,0x8(%ebp)
  801417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141a:	8a 12                	mov    (%edx),%dl
  80141c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	84 c0                	test   %al,%al
  801425:	74 03                	je     80142a <strncpy+0x31>
			src++;
  801427:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80142a:	ff 45 fc             	incl   -0x4(%ebp)
  80142d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801430:	3b 45 10             	cmp    0x10(%ebp),%eax
  801433:	72 d9                	jb     80140e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801435:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801446:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144a:	74 30                	je     80147c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80144c:	eb 16                	jmp    801464 <strlcpy+0x2a>
			*dst++ = *src++;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8d 50 01             	lea    0x1(%eax),%edx
  801454:	89 55 08             	mov    %edx,0x8(%ebp)
  801457:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80145d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801460:	8a 12                	mov    (%edx),%dl
  801462:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801464:	ff 4d 10             	decl   0x10(%ebp)
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	74 09                	je     801476 <strlcpy+0x3c>
  80146d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	84 c0                	test   %al,%al
  801474:	75 d8                	jne    80144e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80147c:	8b 55 08             	mov    0x8(%ebp),%edx
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
}
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80148b:	eb 06                	jmp    801493 <strcmp+0xb>
		p++, q++;
  80148d:	ff 45 08             	incl   0x8(%ebp)
  801490:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	84 c0                	test   %al,%al
  80149a:	74 0e                	je     8014aa <strcmp+0x22>
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8a 10                	mov    (%eax),%dl
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	38 c2                	cmp    %al,%dl
  8014a8:	74 e3                	je     80148d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f b6 d0             	movzbl %al,%edx
  8014b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	0f b6 c0             	movzbl %al,%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
}
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014c3:	eb 09                	jmp    8014ce <strncmp+0xe>
		n--, p++, q++;
  8014c5:	ff 4d 10             	decl   0x10(%ebp)
  8014c8:	ff 45 08             	incl   0x8(%ebp)
  8014cb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d2:	74 17                	je     8014eb <strncmp+0x2b>
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	84 c0                	test   %al,%al
  8014db:	74 0e                	je     8014eb <strncmp+0x2b>
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8a 10                	mov    (%eax),%dl
  8014e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	38 c2                	cmp    %al,%dl
  8014e9:	74 da                	je     8014c5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ef:	75 07                	jne    8014f8 <strncmp+0x38>
		return 0;
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f6:	eb 14                	jmp    80150c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	0f b6 d0             	movzbl %al,%edx
  801500:	8b 45 0c             	mov    0xc(%ebp),%eax
  801503:	8a 00                	mov    (%eax),%al
  801505:	0f b6 c0             	movzbl %al,%eax
  801508:	29 c2                	sub    %eax,%edx
  80150a:	89 d0                	mov    %edx,%eax
}
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80151a:	eb 12                	jmp    80152e <strchr+0x20>
		if (*s == c)
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801524:	75 05                	jne    80152b <strchr+0x1d>
			return (char *) s;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	eb 11                	jmp    80153c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80152b:	ff 45 08             	incl   0x8(%ebp)
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 e5                	jne    80151c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80154a:	eb 0d                	jmp    801559 <strfind+0x1b>
		if (*s == c)
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801554:	74 0e                	je     801564 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801556:	ff 45 08             	incl   0x8(%ebp)
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	84 c0                	test   %al,%al
  801560:	75 ea                	jne    80154c <strfind+0xe>
  801562:	eb 01                	jmp    801565 <strfind+0x27>
		if (*s == c)
			break;
  801564:	90                   	nop
	return (char *) s;
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80157c:	eb 0e                	jmp    80158c <memset+0x22>
		*p++ = c;
  80157e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801581:	8d 50 01             	lea    0x1(%eax),%edx
  801584:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80158c:	ff 4d f8             	decl   -0x8(%ebp)
  80158f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801593:	79 e9                	jns    80157e <memset+0x14>
		*p++ = c;

	return v;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015ac:	eb 16                	jmp    8015c4 <memcpy+0x2a>
		*d++ = *s++;
  8015ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b1:	8d 50 01             	lea    0x1(%eax),%edx
  8015b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015c0:	8a 12                	mov    (%edx),%dl
  8015c2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	75 dd                	jne    8015ae <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015ee:	73 50                	jae    801640 <memmove+0x6a>
  8015f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015fb:	76 43                	jbe    801640 <memmove+0x6a>
		s += n;
  8015fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801600:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801603:	8b 45 10             	mov    0x10(%ebp),%eax
  801606:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801609:	eb 10                	jmp    80161b <memmove+0x45>
			*--d = *--s;
  80160b:	ff 4d f8             	decl   -0x8(%ebp)
  80160e:	ff 4d fc             	decl   -0x4(%ebp)
  801611:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801614:	8a 10                	mov    (%eax),%dl
  801616:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801619:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801621:	89 55 10             	mov    %edx,0x10(%ebp)
  801624:	85 c0                	test   %eax,%eax
  801626:	75 e3                	jne    80160b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801628:	eb 23                	jmp    80164d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80162a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162d:	8d 50 01             	lea    0x1(%eax),%edx
  801630:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801633:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801636:	8d 4a 01             	lea    0x1(%edx),%ecx
  801639:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80163c:	8a 12                	mov    (%edx),%dl
  80163e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	8d 50 ff             	lea    -0x1(%eax),%edx
  801646:	89 55 10             	mov    %edx,0x10(%ebp)
  801649:	85 c0                	test   %eax,%eax
  80164b:	75 dd                	jne    80162a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801664:	eb 2a                	jmp    801690 <memcmp+0x3e>
		if (*s1 != *s2)
  801666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801669:	8a 10                	mov    (%eax),%dl
  80166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	38 c2                	cmp    %al,%dl
  801672:	74 16                	je     80168a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f b6 d0             	movzbl %al,%edx
  80167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	0f b6 c0             	movzbl %al,%eax
  801684:	29 c2                	sub    %eax,%edx
  801686:	89 d0                	mov    %edx,%eax
  801688:	eb 18                	jmp    8016a2 <memcmp+0x50>
		s1++, s2++;
  80168a:	ff 45 fc             	incl   -0x4(%ebp)
  80168d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	8d 50 ff             	lea    -0x1(%eax),%edx
  801696:	89 55 10             	mov    %edx,0x10(%ebp)
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 c9                	jne    801666 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80169d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	01 d0                	add    %edx,%eax
  8016b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016b5:	eb 15                	jmp    8016cc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	0f b6 d0             	movzbl %al,%edx
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	0f b6 c0             	movzbl %al,%eax
  8016c5:	39 c2                	cmp    %eax,%edx
  8016c7:	74 0d                	je     8016d6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016c9:	ff 45 08             	incl   0x8(%ebp)
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016d2:	72 e3                	jb     8016b7 <memfind+0x13>
  8016d4:	eb 01                	jmp    8016d7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016d6:	90                   	nop
	return (void *) s;
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f0:	eb 03                	jmp    8016f5 <strtol+0x19>
		s++;
  8016f2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	3c 20                	cmp    $0x20,%al
  8016fc:	74 f4                	je     8016f2 <strtol+0x16>
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	3c 09                	cmp    $0x9,%al
  801705:	74 eb                	je     8016f2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	3c 2b                	cmp    $0x2b,%al
  80170e:	75 05                	jne    801715 <strtol+0x39>
		s++;
  801710:	ff 45 08             	incl   0x8(%ebp)
  801713:	eb 13                	jmp    801728 <strtol+0x4c>
	else if (*s == '-')
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 2d                	cmp    $0x2d,%al
  80171c:	75 0a                	jne    801728 <strtol+0x4c>
		s++, neg = 1;
  80171e:	ff 45 08             	incl   0x8(%ebp)
  801721:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 06                	je     801734 <strtol+0x58>
  80172e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801732:	75 20                	jne    801754 <strtol+0x78>
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	3c 30                	cmp    $0x30,%al
  80173b:	75 17                	jne    801754 <strtol+0x78>
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	40                   	inc    %eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	3c 78                	cmp    $0x78,%al
  801745:	75 0d                	jne    801754 <strtol+0x78>
		s += 2, base = 16;
  801747:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80174b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801752:	eb 28                	jmp    80177c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801754:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801758:	75 15                	jne    80176f <strtol+0x93>
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	3c 30                	cmp    $0x30,%al
  801761:	75 0c                	jne    80176f <strtol+0x93>
		s++, base = 8;
  801763:	ff 45 08             	incl   0x8(%ebp)
  801766:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80176d:	eb 0d                	jmp    80177c <strtol+0xa0>
	else if (base == 0)
  80176f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801773:	75 07                	jne    80177c <strtol+0xa0>
		base = 10;
  801775:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	3c 2f                	cmp    $0x2f,%al
  801783:	7e 19                	jle    80179e <strtol+0xc2>
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8a 00                	mov    (%eax),%al
  80178a:	3c 39                	cmp    $0x39,%al
  80178c:	7f 10                	jg     80179e <strtol+0xc2>
			dig = *s - '0';
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	0f be c0             	movsbl %al,%eax
  801796:	83 e8 30             	sub    $0x30,%eax
  801799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179c:	eb 42                	jmp    8017e0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 60                	cmp    $0x60,%al
  8017a5:	7e 19                	jle    8017c0 <strtol+0xe4>
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	3c 7a                	cmp    $0x7a,%al
  8017ae:	7f 10                	jg     8017c0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	0f be c0             	movsbl %al,%eax
  8017b8:	83 e8 57             	sub    $0x57,%eax
  8017bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017be:	eb 20                	jmp    8017e0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8a 00                	mov    (%eax),%al
  8017c5:	3c 40                	cmp    $0x40,%al
  8017c7:	7e 39                	jle    801802 <strtol+0x126>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 5a                	cmp    $0x5a,%al
  8017d0:	7f 30                	jg     801802 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	0f be c0             	movsbl %al,%eax
  8017da:	83 e8 37             	sub    $0x37,%eax
  8017dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e6:	7d 19                	jge    801801 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017e8:	ff 45 08             	incl   0x8(%ebp)
  8017eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ee:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017f2:	89 c2                	mov    %eax,%edx
  8017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017fc:	e9 7b ff ff ff       	jmp    80177c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801801:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801802:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801806:	74 08                	je     801810 <strtol+0x134>
		*endptr = (char *) s;
  801808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180b:	8b 55 08             	mov    0x8(%ebp),%edx
  80180e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801810:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801814:	74 07                	je     80181d <strtol+0x141>
  801816:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801819:	f7 d8                	neg    %eax
  80181b:	eb 03                	jmp    801820 <strtol+0x144>
  80181d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <ltostr>:

void
ltostr(long value, char *str)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801828:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80182f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801836:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80183a:	79 13                	jns    80184f <ltostr+0x2d>
	{
		neg = 1;
  80183c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801843:	8b 45 0c             	mov    0xc(%ebp),%eax
  801846:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801849:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80184c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801857:	99                   	cltd   
  801858:	f7 f9                	idiv   %ecx
  80185a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80185d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801860:	8d 50 01             	lea    0x1(%eax),%edx
  801863:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801866:	89 c2                	mov    %eax,%edx
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	01 d0                	add    %edx,%eax
  80186d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801870:	83 c2 30             	add    $0x30,%edx
  801873:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801875:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801878:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80187d:	f7 e9                	imul   %ecx
  80187f:	c1 fa 02             	sar    $0x2,%edx
  801882:	89 c8                	mov    %ecx,%eax
  801884:	c1 f8 1f             	sar    $0x1f,%eax
  801887:	29 c2                	sub    %eax,%edx
  801889:	89 d0                	mov    %edx,%eax
  80188b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80188e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801891:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801896:	f7 e9                	imul   %ecx
  801898:	c1 fa 02             	sar    $0x2,%edx
  80189b:	89 c8                	mov    %ecx,%eax
  80189d:	c1 f8 1f             	sar    $0x1f,%eax
  8018a0:	29 c2                	sub    %eax,%edx
  8018a2:	89 d0                	mov    %edx,%eax
  8018a4:	c1 e0 02             	shl    $0x2,%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	01 c0                	add    %eax,%eax
  8018ab:	29 c1                	sub    %eax,%ecx
  8018ad:	89 ca                	mov    %ecx,%edx
  8018af:	85 d2                	test   %edx,%edx
  8018b1:	75 9c                	jne    80184f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	48                   	dec    %eax
  8018be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c5:	74 3d                	je     801904 <ltostr+0xe2>
		start = 1 ;
  8018c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018ce:	eb 34                	jmp    801904 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d6:	01 d0                	add    %edx,%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e3:	01 c2                	add    %eax,%edx
  8018e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018eb:	01 c8                	add    %ecx,%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	01 c2                	add    %eax,%edx
  8018f9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018fc:	88 02                	mov    %al,(%edx)
		start++ ;
  8018fe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801901:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80190a:	7c c4                	jl     8018d0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80190c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	01 d0                	add    %edx,%eax
  801914:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	e8 54 fa ff ff       	call   80137c <strlen>
  801928:	83 c4 04             	add    $0x4,%esp
  80192b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	e8 46 fa ff ff       	call   80137c <strlen>
  801936:	83 c4 04             	add    $0x4,%esp
  801939:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80193c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80194a:	eb 17                	jmp    801963 <strcconcat+0x49>
		final[s] = str1[s] ;
  80194c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194f:	8b 45 10             	mov    0x10(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801960:	ff 45 fc             	incl   -0x4(%ebp)
  801963:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801966:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801969:	7c e1                	jl     80194c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80196b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801972:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801979:	eb 1f                	jmp    80199a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80197b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197e:	8d 50 01             	lea    0x1(%eax),%edx
  801981:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801984:	89 c2                	mov    %eax,%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 c2                	add    %eax,%edx
  80198b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	01 c8                	add    %ecx,%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801997:	ff 45 f8             	incl   -0x8(%ebp)
  80199a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80199d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a0:	7c d9                	jl     80197b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a8:	01 d0                	add    %edx,%eax
  8019aa:	c6 00 00             	movb   $0x0,(%eax)
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bf:	8b 00                	mov    (%eax),%eax
  8019c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	01 d0                	add    %edx,%eax
  8019cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d3:	eb 0c                	jmp    8019e1 <strsplit+0x31>
			*string++ = 0;
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8d 50 01             	lea    0x1(%eax),%edx
  8019db:	89 55 08             	mov    %edx,0x8(%ebp)
  8019de:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	8a 00                	mov    (%eax),%al
  8019e6:	84 c0                	test   %al,%al
  8019e8:	74 18                	je     801a02 <strsplit+0x52>
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	0f be c0             	movsbl %al,%eax
  8019f2:	50                   	push   %eax
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	e8 13 fb ff ff       	call   80150e <strchr>
  8019fb:	83 c4 08             	add    $0x8,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	75 d3                	jne    8019d5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	84 c0                	test   %al,%al
  801a09:	74 5a                	je     801a65 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0e:	8b 00                	mov    (%eax),%eax
  801a10:	83 f8 0f             	cmp    $0xf,%eax
  801a13:	75 07                	jne    801a1c <strsplit+0x6c>
		{
			return 0;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	eb 66                	jmp    801a82 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1f:	8b 00                	mov    (%eax),%eax
  801a21:	8d 48 01             	lea    0x1(%eax),%ecx
  801a24:	8b 55 14             	mov    0x14(%ebp),%edx
  801a27:	89 0a                	mov    %ecx,(%edx)
  801a29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	01 c2                	add    %eax,%edx
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3a:	eb 03                	jmp    801a3f <strsplit+0x8f>
			string++;
  801a3c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8a 00                	mov    (%eax),%al
  801a44:	84 c0                	test   %al,%al
  801a46:	74 8b                	je     8019d3 <strsplit+0x23>
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	8a 00                	mov    (%eax),%al
  801a4d:	0f be c0             	movsbl %al,%eax
  801a50:	50                   	push   %eax
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	e8 b5 fa ff ff       	call   80150e <strchr>
  801a59:	83 c4 08             	add    $0x8,%esp
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	74 dc                	je     801a3c <strsplit+0x8c>
			string++;
	}
  801a60:	e9 6e ff ff ff       	jmp    8019d3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a65:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a66:	8b 45 14             	mov    0x14(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	01 d0                	add    %edx,%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a7d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801a8a:	a1 28 40 80 00       	mov    0x804028,%eax
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	75 33                	jne    801ac6 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801a93:	c7 05 20 41 80 00 00 	movl   $0x80000000,0x804120
  801a9a:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801a9d:	c7 05 24 41 80 00 00 	movl   $0xa0000000,0x804124
  801aa4:	00 00 a0 
		spaces[0].pages = numPages;
  801aa7:	c7 05 28 41 80 00 00 	movl   $0x20000,0x804128
  801aae:	00 02 00 
		spaces[0].isFree = 1;
  801ab1:	c7 05 2c 41 80 00 01 	movl   $0x1,0x80412c
  801ab8:	00 00 00 
		arraySize++;
  801abb:	a1 28 40 80 00       	mov    0x804028,%eax
  801ac0:	40                   	inc    %eax
  801ac1:	a3 28 40 80 00       	mov    %eax,0x804028
	}
	int min_diff = numPages + 1;
  801ac6:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  801acd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801ad4:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801adb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae1:	01 d0                	add    %edx,%eax
  801ae3:	48                   	dec    %eax
  801ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aea:	ba 00 00 00 00       	mov    $0x0,%edx
  801aef:	f7 75 e8             	divl   -0x18(%ebp)
  801af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af5:	29 d0                	sub    %edx,%eax
  801af7:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	c1 e8 0c             	shr    $0xc,%eax
  801b00:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801b03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801b0a:	eb 57                	jmp    801b63 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  801b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0f:	c1 e0 04             	shl    $0x4,%eax
  801b12:	05 2c 41 80 00       	add    $0x80412c,%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	74 42                	je     801b5f <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b20:	c1 e0 04             	shl    $0x4,%eax
  801b23:	05 28 41 80 00       	add    $0x804128,%eax
  801b28:	8b 00                	mov    (%eax),%eax
  801b2a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b2d:	7c 31                	jl     801b60 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b32:	c1 e0 04             	shl    $0x4,%eax
  801b35:	05 28 41 80 00       	add    $0x804128,%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801b3f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b42:	7d 1c                	jge    801b60 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b47:	c1 e0 04             	shl    $0x4,%eax
  801b4a:	05 28 41 80 00       	add    $0x804128,%eax
  801b4f:	8b 00                	mov    (%eax),%eax
  801b51:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b5d:	eb 01                	jmp    801b60 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801b5f:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801b60:	ff 45 ec             	incl   -0x14(%ebp)
  801b63:	a1 28 40 80 00       	mov    0x804028,%eax
  801b68:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801b6b:	7c 9f                	jl     801b0c <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801b6d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b71:	75 0a                	jne    801b7d <malloc+0xf9>
	{
		return NULL;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	e9 34 01 00 00       	jmp    801cb1 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b80:	c1 e0 04             	shl    $0x4,%eax
  801b83:	05 28 41 80 00       	add    $0x804128,%eax
  801b88:	8b 00                	mov    (%eax),%eax
  801b8a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801b8d:	75 38                	jne    801bc7 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b92:	c1 e0 04             	shl    $0x4,%eax
  801b95:	05 2c 41 80 00       	add    $0x80412c,%eax
  801b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba3:	c1 e0 0c             	shl    $0xc,%eax
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bab:	c1 e0 04             	shl    $0x4,%eax
  801bae:	05 20 41 80 00       	add    $0x804120,%eax
  801bb3:	8b 00                	mov    (%eax),%eax
  801bb5:	83 ec 08             	sub    $0x8,%esp
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	e8 01 06 00 00       	call   8021c0 <sys_allocateMem>
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	e9 dd 00 00 00       	jmp    801ca4 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bca:	c1 e0 04             	shl    $0x4,%eax
  801bcd:	05 20 41 80 00       	add    $0x804120,%eax
  801bd2:	8b 00                	mov    (%eax),%eax
  801bd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bd7:	c1 e2 0c             	shl    $0xc,%edx
  801bda:	01 d0                	add    %edx,%eax
  801bdc:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  801bdf:	a1 28 40 80 00       	mov    0x804028,%eax
  801be4:	c1 e0 04             	shl    $0x4,%eax
  801be7:	8d 90 20 41 80 00    	lea    0x804120(%eax),%edx
  801bed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bf0:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801bf2:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfb:	c1 e0 04             	shl    $0x4,%eax
  801bfe:	05 24 41 80 00       	add    $0x804124,%eax
  801c03:	8b 00                	mov    (%eax),%eax
  801c05:	c1 e2 04             	shl    $0x4,%edx
  801c08:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801c0e:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  801c10:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c19:	c1 e0 04             	shl    $0x4,%eax
  801c1c:	05 28 41 80 00       	add    $0x804128,%eax
  801c21:	8b 00                	mov    (%eax),%eax
  801c23:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801c26:	c1 e2 04             	shl    $0x4,%edx
  801c29:	81 c2 28 41 80 00    	add    $0x804128,%edx
  801c2f:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801c31:	a1 28 40 80 00       	mov    0x804028,%eax
  801c36:	c1 e0 04             	shl    $0x4,%eax
  801c39:	05 2c 41 80 00       	add    $0x80412c,%eax
  801c3e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801c44:	a1 28 40 80 00       	mov    0x804028,%eax
  801c49:	40                   	inc    %eax
  801c4a:	a3 28 40 80 00       	mov    %eax,0x804028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c52:	c1 e0 04             	shl    $0x4,%eax
  801c55:	8d 90 24 41 80 00    	lea    0x804124(%eax),%edx
  801c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c5e:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c63:	c1 e0 04             	shl    $0x4,%eax
  801c66:	8d 90 28 41 80 00    	lea    0x804128(%eax),%edx
  801c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6f:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c74:	c1 e0 04             	shl    $0x4,%eax
  801c77:	05 2c 41 80 00       	add    $0x80412c,%eax
  801c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801c82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c85:	c1 e0 0c             	shl    $0xc,%eax
  801c88:	89 c2                	mov    %eax,%edx
  801c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8d:	c1 e0 04             	shl    $0x4,%eax
  801c90:	05 20 41 80 00       	add    $0x804120,%eax
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	52                   	push   %edx
  801c9b:	50                   	push   %eax
  801c9c:	e8 1f 05 00 00       	call   8021c0 <sys_allocateMem>
  801ca1:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca7:	c1 e0 04             	shl    $0x4,%eax
  801caa:	05 20 41 80 00       	add    $0x804120,%eax
  801caf:	8b 00                	mov    (%eax),%eax
	}


}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801cb9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801cc0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801cc7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801cce:	eb 3f                	jmp    801d0f <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd3:	c1 e0 04             	shl    $0x4,%eax
  801cd6:	05 20 41 80 00       	add    $0x804120,%eax
  801cdb:	8b 00                	mov    (%eax),%eax
  801cdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce0:	75 2a                	jne    801d0c <free+0x59>
		{
			index=i;
  801ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ceb:	c1 e0 04             	shl    $0x4,%eax
  801cee:	05 28 41 80 00       	add    $0x804128,%eax
  801cf3:	8b 00                	mov    (%eax),%eax
  801cf5:	c1 e0 0c             	shl    $0xc,%eax
  801cf8:	89 c2                	mov    %eax,%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	83 ec 08             	sub    $0x8,%esp
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	e8 9d 04 00 00       	call   8021a4 <sys_freeMem>
  801d07:	83 c4 10             	add    $0x10,%esp
			break;
  801d0a:	eb 0d                	jmp    801d19 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  801d0c:	ff 45 ec             	incl   -0x14(%ebp)
  801d0f:	a1 28 40 80 00       	mov    0x804028,%eax
  801d14:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801d17:	7c b7                	jl     801cd0 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801d19:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d1d:	75 17                	jne    801d36 <free+0x83>
	{
		panic("Error");
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	68 10 33 80 00       	push   $0x803310
  801d27:	68 81 00 00 00       	push   $0x81
  801d2c:	68 16 33 80 00       	push   $0x803316
  801d31:	e8 22 ed ff ff       	call   800a58 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801d36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d3d:	e9 cc 00 00 00       	jmp    801e0e <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d45:	c1 e0 04             	shl    $0x4,%eax
  801d48:	05 2c 41 80 00       	add    $0x80412c,%eax
  801d4d:	8b 00                	mov    (%eax),%eax
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	0f 84 b3 00 00 00    	je     801e0a <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	c1 e0 04             	shl    $0x4,%eax
  801d5d:	05 20 41 80 00       	add    $0x804120,%eax
  801d62:	8b 10                	mov    (%eax),%edx
  801d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d67:	c1 e0 04             	shl    $0x4,%eax
  801d6a:	05 24 41 80 00       	add    $0x804124,%eax
  801d6f:	8b 00                	mov    (%eax),%eax
  801d71:	39 c2                	cmp    %eax,%edx
  801d73:	0f 85 92 00 00 00    	jne    801e0b <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	c1 e0 04             	shl    $0x4,%eax
  801d7f:	05 24 41 80 00       	add    $0x804124,%eax
  801d84:	8b 00                	mov    (%eax),%eax
  801d86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d89:	c1 e2 04             	shl    $0x4,%edx
  801d8c:	81 c2 24 41 80 00    	add    $0x804124,%edx
  801d92:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d97:	c1 e0 04             	shl    $0x4,%eax
  801d9a:	05 28 41 80 00       	add    $0x804128,%eax
  801d9f:	8b 10                	mov    (%eax),%edx
  801da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da4:	c1 e0 04             	shl    $0x4,%eax
  801da7:	05 28 41 80 00       	add    $0x804128,%eax
  801dac:	8b 00                	mov    (%eax),%eax
  801dae:	01 c2                	add    %eax,%edx
  801db0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db3:	c1 e0 04             	shl    $0x4,%eax
  801db6:	05 28 41 80 00       	add    $0x804128,%eax
  801dbb:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	c1 e0 04             	shl    $0x4,%eax
  801dc3:	05 20 41 80 00       	add    $0x804120,%eax
  801dc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	c1 e0 04             	shl    $0x4,%eax
  801dd4:	05 24 41 80 00       	add    $0x804124,%eax
  801dd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	c1 e0 04             	shl    $0x4,%eax
  801de5:	05 28 41 80 00       	add    $0x804128,%eax
  801dea:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df3:	c1 e0 04             	shl    $0x4,%eax
  801df6:	05 2c 41 80 00       	add    $0x80412c,%eax
  801dfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801e01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801e08:	eb 12                	jmp    801e1c <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801e0a:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801e0b:	ff 45 e8             	incl   -0x18(%ebp)
  801e0e:	a1 28 40 80 00       	mov    0x804028,%eax
  801e13:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801e16:	0f 8c 26 ff ff ff    	jl     801d42 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801e1c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801e23:	e9 cc 00 00 00       	jmp    801ef4 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e2b:	c1 e0 04             	shl    $0x4,%eax
  801e2e:	05 2c 41 80 00       	add    $0x80412c,%eax
  801e33:	8b 00                	mov    (%eax),%eax
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 84 b3 00 00 00    	je     801ef0 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	c1 e0 04             	shl    $0x4,%eax
  801e43:	05 24 41 80 00       	add    $0x804124,%eax
  801e48:	8b 10                	mov    (%eax),%edx
  801e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e4d:	c1 e0 04             	shl    $0x4,%eax
  801e50:	05 20 41 80 00       	add    $0x804120,%eax
  801e55:	8b 00                	mov    (%eax),%eax
  801e57:	39 c2                	cmp    %eax,%edx
  801e59:	0f 85 92 00 00 00    	jne    801ef1 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	c1 e0 04             	shl    $0x4,%eax
  801e65:	05 20 41 80 00       	add    $0x804120,%eax
  801e6a:	8b 00                	mov    (%eax),%eax
  801e6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e6f:	c1 e2 04             	shl    $0x4,%edx
  801e72:	81 c2 20 41 80 00    	add    $0x804120,%edx
  801e78:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e7d:	c1 e0 04             	shl    $0x4,%eax
  801e80:	05 28 41 80 00       	add    $0x804128,%eax
  801e85:	8b 10                	mov    (%eax),%edx
  801e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8a:	c1 e0 04             	shl    $0x4,%eax
  801e8d:	05 28 41 80 00       	add    $0x804128,%eax
  801e92:	8b 00                	mov    (%eax),%eax
  801e94:	01 c2                	add    %eax,%edx
  801e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e99:	c1 e0 04             	shl    $0x4,%eax
  801e9c:	05 28 41 80 00       	add    $0x804128,%eax
  801ea1:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	c1 e0 04             	shl    $0x4,%eax
  801ea9:	05 20 41 80 00       	add    $0x804120,%eax
  801eae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	c1 e0 04             	shl    $0x4,%eax
  801eba:	05 24 41 80 00       	add    $0x804124,%eax
  801ebf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec8:	c1 e0 04             	shl    $0x4,%eax
  801ecb:	05 28 41 80 00       	add    $0x804128,%eax
  801ed0:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	c1 e0 04             	shl    $0x4,%eax
  801edc:	05 2c 41 80 00       	add    $0x80412c,%eax
  801ee1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801ee7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801eee:	eb 12                	jmp    801f02 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801ef0:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ef1:	ff 45 e4             	incl   -0x1c(%ebp)
  801ef4:	a1 28 40 80 00       	mov    0x804028,%eax
  801ef9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801efc:	0f 8c 26 ff ff ff    	jl     801e28 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801f02:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801f06:	75 11                	jne    801f19 <free+0x266>
	{
		spaces[index].isFree = 1;
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	c1 e0 04             	shl    $0x4,%eax
  801f0e:	05 2c 41 80 00       	add    $0x80412c,%eax
  801f13:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 18             	sub    $0x18,%esp
  801f22:	8b 45 10             	mov    0x10(%ebp),%eax
  801f25:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801f28:	83 ec 04             	sub    $0x4,%esp
  801f2b:	68 24 33 80 00       	push   $0x803324
  801f30:	68 b9 00 00 00       	push   $0xb9
  801f35:	68 16 33 80 00       	push   $0x803316
  801f3a:	e8 19 eb ff ff       	call   800a58 <_panic>

00801f3f <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	68 24 33 80 00       	push   $0x803324
  801f4d:	68 bf 00 00 00       	push   $0xbf
  801f52:	68 16 33 80 00       	push   $0x803316
  801f57:	e8 fc ea ff ff       	call   800a58 <_panic>

00801f5c <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	68 24 33 80 00       	push   $0x803324
  801f6a:	68 c5 00 00 00       	push   $0xc5
  801f6f:	68 16 33 80 00       	push   $0x803316
  801f74:	e8 df ea ff ff       	call   800a58 <_panic>

00801f79 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	68 24 33 80 00       	push   $0x803324
  801f87:	68 ca 00 00 00       	push   $0xca
  801f8c:	68 16 33 80 00       	push   $0x803316
  801f91:	e8 c2 ea ff ff       	call   800a58 <_panic>

00801f96 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	68 24 33 80 00       	push   $0x803324
  801fa4:	68 d0 00 00 00       	push   $0xd0
  801fa9:	68 16 33 80 00       	push   $0x803316
  801fae:	e8 a5 ea ff ff       	call   800a58 <_panic>

00801fb3 <shrink>:
}
void shrink(uint32 newSize)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 24 33 80 00       	push   $0x803324
  801fc1:	68 d4 00 00 00       	push   $0xd4
  801fc6:	68 16 33 80 00       	push   $0x803316
  801fcb:	e8 88 ea ff ff       	call   800a58 <_panic>

00801fd0 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 24 33 80 00       	push   $0x803324
  801fde:	68 d9 00 00 00       	push   $0xd9
  801fe3:	68 16 33 80 00       	push   $0x803316
  801fe8:	e8 6b ea ff ff       	call   800a58 <_panic>

00801fed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	57                   	push   %edi
  801ff1:	56                   	push   %esi
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802002:	8b 7d 18             	mov    0x18(%ebp),%edi
  802005:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802008:	cd 30                	int    $0x30
  80200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    

00802018 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	8b 45 10             	mov    0x10(%ebp),%eax
  802021:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802024:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	52                   	push   %edx
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	6a 00                	push   $0x0
  802036:	e8 b2 ff ff ff       	call   801fed <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	90                   	nop
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_cgetc>:

int
sys_cgetc(void)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 01                	push   $0x1
  802050:	e8 98 ff ff ff       	call   801fed <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	50                   	push   %eax
  802069:	6a 05                	push   $0x5
  80206b:	e8 7d ff ff ff       	call   801fed <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 02                	push   $0x2
  802084:	e8 64 ff ff ff       	call   801fed <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 03                	push   $0x3
  80209d:	e8 4b ff ff ff       	call   801fed <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 04                	push   $0x4
  8020b6:	e8 32 ff ff ff       	call   801fed <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_env_exit>:


void sys_env_exit(void)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 06                	push   $0x6
  8020cf:	e8 19 ff ff ff       	call   801fed <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	90                   	nop
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	52                   	push   %edx
  8020ea:	50                   	push   %eax
  8020eb:	6a 07                	push   $0x7
  8020ed:	e8 fb fe ff ff       	call   801fed <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802102:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	51                   	push   %ecx
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 08                	push   $0x8
  802112:	e8 d6 fe ff ff       	call   801fed <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211d:	5b                   	pop    %ebx
  80211e:	5e                   	pop    %esi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802124:	8b 55 0c             	mov    0xc(%ebp),%edx
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	52                   	push   %edx
  802131:	50                   	push   %eax
  802132:	6a 09                	push   $0x9
  802134:	e8 b4 fe ff ff       	call   801fed <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	6a 0a                	push   $0xa
  80214f:	e8 99 fe ff ff       	call   801fed <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 0b                	push   $0xb
  802168:	e8 80 fe ff ff       	call   801fed <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 0c                	push   $0xc
  802181:	e8 67 fe ff ff       	call   801fed <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 0d                	push   $0xd
  80219a:	e8 4e fe ff ff       	call   801fed <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	ff 75 0c             	pushl  0xc(%ebp)
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	6a 11                	push   $0x11
  8021b5:	e8 33 fe ff ff       	call   801fed <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
	return;
  8021bd:	90                   	nop
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	6a 12                	push   $0x12
  8021d1:	e8 17 fe ff ff       	call   801fed <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d9:	90                   	nop
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 0e                	push   $0xe
  8021eb:	e8 fd fd ff ff       	call   801fed <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	ff 75 08             	pushl  0x8(%ebp)
  802203:	6a 0f                	push   $0xf
  802205:	e8 e3 fd ff ff       	call   801fed <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 10                	push   $0x10
  80221e:	e8 ca fd ff ff       	call   801fed <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	90                   	nop
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 14                	push   $0x14
  802238:	e8 b0 fd ff ff       	call   801fed <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	90                   	nop
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 15                	push   $0x15
  802252:	e8 96 fd ff ff       	call   801fed <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	90                   	nop
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_cputc>:


void
sys_cputc(const char c)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802269:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	50                   	push   %eax
  802276:	6a 16                	push   $0x16
  802278:	e8 70 fd ff ff       	call   801fed <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	90                   	nop
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 17                	push   $0x17
  802292:	e8 56 fd ff ff       	call   801fed <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
}
  80229a:	90                   	nop
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	ff 75 0c             	pushl  0xc(%ebp)
  8022ac:	50                   	push   %eax
  8022ad:	6a 18                	push   $0x18
  8022af:	e8 39 fd ff ff       	call   801fed <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	52                   	push   %edx
  8022c9:	50                   	push   %eax
  8022ca:	6a 1b                	push   $0x1b
  8022cc:	e8 1c fd ff ff       	call   801fed <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	52                   	push   %edx
  8022e6:	50                   	push   %eax
  8022e7:	6a 19                	push   $0x19
  8022e9:	e8 ff fc ff ff       	call   801fed <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	90                   	nop
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	52                   	push   %edx
  802304:	50                   	push   %eax
  802305:	6a 1a                	push   $0x1a
  802307:	e8 e1 fc ff ff       	call   801fed <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	90                   	nop
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	8b 45 10             	mov    0x10(%ebp),%eax
  80231b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80231e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802321:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	6a 00                	push   $0x0
  80232a:	51                   	push   %ecx
  80232b:	52                   	push   %edx
  80232c:	ff 75 0c             	pushl  0xc(%ebp)
  80232f:	50                   	push   %eax
  802330:	6a 1c                	push   $0x1c
  802332:	e8 b6 fc ff ff       	call   801fed <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80233f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	52                   	push   %edx
  80234c:	50                   	push   %eax
  80234d:	6a 1d                	push   $0x1d
  80234f:	e8 99 fc ff ff       	call   801fed <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80235c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80235f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	51                   	push   %ecx
  80236a:	52                   	push   %edx
  80236b:	50                   	push   %eax
  80236c:	6a 1e                	push   $0x1e
  80236e:	e8 7a fc ff ff       	call   801fed <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80237b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	52                   	push   %edx
  802388:	50                   	push   %eax
  802389:	6a 1f                	push   $0x1f
  80238b:	e8 5d fc ff ff       	call   801fed <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 20                	push   $0x20
  8023a4:	e8 44 fc ff ff       	call   801fed <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	ff 75 14             	pushl  0x14(%ebp)
  8023b9:	ff 75 10             	pushl  0x10(%ebp)
  8023bc:	ff 75 0c             	pushl  0xc(%ebp)
  8023bf:	50                   	push   %eax
  8023c0:	6a 21                	push   $0x21
  8023c2:	e8 26 fc ff ff       	call   801fed <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	50                   	push   %eax
  8023db:	6a 22                	push   $0x22
  8023dd:	e8 0b fc ff ff       	call   801fed <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	90                   	nop
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	50                   	push   %eax
  8023f7:	6a 23                	push   $0x23
  8023f9:	e8 ef fb ff ff       	call   801fed <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
}
  802401:	90                   	nop
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80240a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80240d:	8d 50 04             	lea    0x4(%eax),%edx
  802410:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	52                   	push   %edx
  80241a:	50                   	push   %eax
  80241b:	6a 24                	push   $0x24
  80241d:	e8 cb fb ff ff       	call   801fed <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
	return result;
  802425:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802428:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80242e:	89 01                	mov    %eax,(%ecx)
  802430:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	c9                   	leave  
  802437:	c2 04 00             	ret    $0x4

0080243a <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	ff 75 10             	pushl  0x10(%ebp)
  802444:	ff 75 0c             	pushl  0xc(%ebp)
  802447:	ff 75 08             	pushl  0x8(%ebp)
  80244a:	6a 13                	push   $0x13
  80244c:	e8 9c fb ff ff       	call   801fed <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
	return ;
  802454:	90                   	nop
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <sys_rcr2>:
uint32 sys_rcr2()
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 25                	push   $0x25
  802466:	e8 82 fb ff ff       	call   801fed <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80247c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	50                   	push   %eax
  802489:	6a 26                	push   $0x26
  80248b:	e8 5d fb ff ff       	call   801fed <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
	return ;
  802493:	90                   	nop
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <rsttst>:
void rsttst()
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 28                	push   $0x28
  8024a5:	e8 43 fb ff ff       	call   801fed <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ad:	90                   	nop
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8024b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8024bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024c3:	52                   	push   %edx
  8024c4:	50                   	push   %eax
  8024c5:	ff 75 10             	pushl  0x10(%ebp)
  8024c8:	ff 75 0c             	pushl  0xc(%ebp)
  8024cb:	ff 75 08             	pushl  0x8(%ebp)
  8024ce:	6a 27                	push   $0x27
  8024d0:	e8 18 fb ff ff       	call   801fed <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d8:	90                   	nop
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <chktst>:
void chktst(uint32 n)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	6a 29                	push   $0x29
  8024eb:	e8 fd fa ff ff       	call   801fed <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <inctst>:

void inctst()
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 2a                	push   $0x2a
  802505:	e8 e3 fa ff ff       	call   801fed <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
	return ;
  80250d:	90                   	nop
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <gettst>:
uint32 gettst()
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 2b                	push   $0x2b
  80251f:	e8 c9 fa ff ff       	call   801fed <syscall>
  802524:	83 c4 18             	add    $0x18,%esp
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 2c                	push   $0x2c
  80253b:	e8 ad fa ff ff       	call   801fed <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
  802543:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802546:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80254a:	75 07                	jne    802553 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80254c:	b8 01 00 00 00       	mov    $0x1,%eax
  802551:	eb 05                	jmp    802558 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 2c                	push   $0x2c
  80256c:	e8 7c fa ff ff       	call   801fed <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
  802574:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802577:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80257b:	75 07                	jne    802584 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80257d:	b8 01 00 00 00       	mov    $0x1,%eax
  802582:	eb 05                	jmp    802589 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 2c                	push   $0x2c
  80259d:	e8 4b fa ff ff       	call   801fed <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
  8025a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025a8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025ac:	75 07                	jne    8025b5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b3:	eb 05                	jmp    8025ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
  8025bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 2c                	push   $0x2c
  8025ce:	e8 1a fa ff ff       	call   801fed <syscall>
  8025d3:	83 c4 18             	add    $0x18,%esp
  8025d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025dd:	75 07                	jne    8025e6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025df:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e4:	eb 05                	jmp    8025eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	ff 75 08             	pushl  0x8(%ebp)
  8025fb:	6a 2d                	push   $0x2d
  8025fd:	e8 eb f9 ff ff       	call   801fed <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
	return ;
  802605:	90                   	nop
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80260c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80260f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802612:	8b 55 0c             	mov    0xc(%ebp),%edx
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	6a 00                	push   $0x0
  80261a:	53                   	push   %ebx
  80261b:	51                   	push   %ecx
  80261c:	52                   	push   %edx
  80261d:	50                   	push   %eax
  80261e:	6a 2e                	push   $0x2e
  802620:	e8 c8 f9 ff ff       	call   801fed <syscall>
  802625:	83 c4 18             	add    $0x18,%esp
}
  802628:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802630:	8b 55 0c             	mov    0xc(%ebp),%edx
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	52                   	push   %edx
  80263d:	50                   	push   %eax
  80263e:	6a 2f                	push   $0x2f
  802640:	e8 a8 f9 ff ff       	call   801fed <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    
  80264a:	66 90                	xchg   %ax,%ax

0080264c <__udivdi3>:
  80264c:	55                   	push   %ebp
  80264d:	57                   	push   %edi
  80264e:	56                   	push   %esi
  80264f:	53                   	push   %ebx
  802650:	83 ec 1c             	sub    $0x1c,%esp
  802653:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802657:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80265b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80265f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802663:	89 ca                	mov    %ecx,%edx
  802665:	89 f8                	mov    %edi,%eax
  802667:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80266b:	85 f6                	test   %esi,%esi
  80266d:	75 2d                	jne    80269c <__udivdi3+0x50>
  80266f:	39 cf                	cmp    %ecx,%edi
  802671:	77 65                	ja     8026d8 <__udivdi3+0x8c>
  802673:	89 fd                	mov    %edi,%ebp
  802675:	85 ff                	test   %edi,%edi
  802677:	75 0b                	jne    802684 <__udivdi3+0x38>
  802679:	b8 01 00 00 00       	mov    $0x1,%eax
  80267e:	31 d2                	xor    %edx,%edx
  802680:	f7 f7                	div    %edi
  802682:	89 c5                	mov    %eax,%ebp
  802684:	31 d2                	xor    %edx,%edx
  802686:	89 c8                	mov    %ecx,%eax
  802688:	f7 f5                	div    %ebp
  80268a:	89 c1                	mov    %eax,%ecx
  80268c:	89 d8                	mov    %ebx,%eax
  80268e:	f7 f5                	div    %ebp
  802690:	89 cf                	mov    %ecx,%edi
  802692:	89 fa                	mov    %edi,%edx
  802694:	83 c4 1c             	add    $0x1c,%esp
  802697:	5b                   	pop    %ebx
  802698:	5e                   	pop    %esi
  802699:	5f                   	pop    %edi
  80269a:	5d                   	pop    %ebp
  80269b:	c3                   	ret    
  80269c:	39 ce                	cmp    %ecx,%esi
  80269e:	77 28                	ja     8026c8 <__udivdi3+0x7c>
  8026a0:	0f bd fe             	bsr    %esi,%edi
  8026a3:	83 f7 1f             	xor    $0x1f,%edi
  8026a6:	75 40                	jne    8026e8 <__udivdi3+0x9c>
  8026a8:	39 ce                	cmp    %ecx,%esi
  8026aa:	72 0a                	jb     8026b6 <__udivdi3+0x6a>
  8026ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8026b0:	0f 87 9e 00 00 00    	ja     802754 <__udivdi3+0x108>
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	89 fa                	mov    %edi,%edx
  8026bd:	83 c4 1c             	add    $0x1c,%esp
  8026c0:	5b                   	pop    %ebx
  8026c1:	5e                   	pop    %esi
  8026c2:	5f                   	pop    %edi
  8026c3:	5d                   	pop    %ebp
  8026c4:	c3                   	ret    
  8026c5:	8d 76 00             	lea    0x0(%esi),%esi
  8026c8:	31 ff                	xor    %edi,%edi
  8026ca:	31 c0                	xor    %eax,%eax
  8026cc:	89 fa                	mov    %edi,%edx
  8026ce:	83 c4 1c             	add    $0x1c,%esp
  8026d1:	5b                   	pop    %ebx
  8026d2:	5e                   	pop    %esi
  8026d3:	5f                   	pop    %edi
  8026d4:	5d                   	pop    %ebp
  8026d5:	c3                   	ret    
  8026d6:	66 90                	xchg   %ax,%ax
  8026d8:	89 d8                	mov    %ebx,%eax
  8026da:	f7 f7                	div    %edi
  8026dc:	31 ff                	xor    %edi,%edi
  8026de:	89 fa                	mov    %edi,%edx
  8026e0:	83 c4 1c             	add    $0x1c,%esp
  8026e3:	5b                   	pop    %ebx
  8026e4:	5e                   	pop    %esi
  8026e5:	5f                   	pop    %edi
  8026e6:	5d                   	pop    %ebp
  8026e7:	c3                   	ret    
  8026e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8026ed:	89 eb                	mov    %ebp,%ebx
  8026ef:	29 fb                	sub    %edi,%ebx
  8026f1:	89 f9                	mov    %edi,%ecx
  8026f3:	d3 e6                	shl    %cl,%esi
  8026f5:	89 c5                	mov    %eax,%ebp
  8026f7:	88 d9                	mov    %bl,%cl
  8026f9:	d3 ed                	shr    %cl,%ebp
  8026fb:	89 e9                	mov    %ebp,%ecx
  8026fd:	09 f1                	or     %esi,%ecx
  8026ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802703:	89 f9                	mov    %edi,%ecx
  802705:	d3 e0                	shl    %cl,%eax
  802707:	89 c5                	mov    %eax,%ebp
  802709:	89 d6                	mov    %edx,%esi
  80270b:	88 d9                	mov    %bl,%cl
  80270d:	d3 ee                	shr    %cl,%esi
  80270f:	89 f9                	mov    %edi,%ecx
  802711:	d3 e2                	shl    %cl,%edx
  802713:	8b 44 24 08          	mov    0x8(%esp),%eax
  802717:	88 d9                	mov    %bl,%cl
  802719:	d3 e8                	shr    %cl,%eax
  80271b:	09 c2                	or     %eax,%edx
  80271d:	89 d0                	mov    %edx,%eax
  80271f:	89 f2                	mov    %esi,%edx
  802721:	f7 74 24 0c          	divl   0xc(%esp)
  802725:	89 d6                	mov    %edx,%esi
  802727:	89 c3                	mov    %eax,%ebx
  802729:	f7 e5                	mul    %ebp
  80272b:	39 d6                	cmp    %edx,%esi
  80272d:	72 19                	jb     802748 <__udivdi3+0xfc>
  80272f:	74 0b                	je     80273c <__udivdi3+0xf0>
  802731:	89 d8                	mov    %ebx,%eax
  802733:	31 ff                	xor    %edi,%edi
  802735:	e9 58 ff ff ff       	jmp    802692 <__udivdi3+0x46>
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802740:	89 f9                	mov    %edi,%ecx
  802742:	d3 e2                	shl    %cl,%edx
  802744:	39 c2                	cmp    %eax,%edx
  802746:	73 e9                	jae    802731 <__udivdi3+0xe5>
  802748:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80274b:	31 ff                	xor    %edi,%edi
  80274d:	e9 40 ff ff ff       	jmp    802692 <__udivdi3+0x46>
  802752:	66 90                	xchg   %ax,%ax
  802754:	31 c0                	xor    %eax,%eax
  802756:	e9 37 ff ff ff       	jmp    802692 <__udivdi3+0x46>
  80275b:	90                   	nop

0080275c <__umoddi3>:
  80275c:	55                   	push   %ebp
  80275d:	57                   	push   %edi
  80275e:	56                   	push   %esi
  80275f:	53                   	push   %ebx
  802760:	83 ec 1c             	sub    $0x1c,%esp
  802763:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802767:	8b 74 24 34          	mov    0x34(%esp),%esi
  80276b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80276f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802773:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802777:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80277b:	89 f3                	mov    %esi,%ebx
  80277d:	89 fa                	mov    %edi,%edx
  80277f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802783:	89 34 24             	mov    %esi,(%esp)
  802786:	85 c0                	test   %eax,%eax
  802788:	75 1a                	jne    8027a4 <__umoddi3+0x48>
  80278a:	39 f7                	cmp    %esi,%edi
  80278c:	0f 86 a2 00 00 00    	jbe    802834 <__umoddi3+0xd8>
  802792:	89 c8                	mov    %ecx,%eax
  802794:	89 f2                	mov    %esi,%edx
  802796:	f7 f7                	div    %edi
  802798:	89 d0                	mov    %edx,%eax
  80279a:	31 d2                	xor    %edx,%edx
  80279c:	83 c4 1c             	add    $0x1c,%esp
  80279f:	5b                   	pop    %ebx
  8027a0:	5e                   	pop    %esi
  8027a1:	5f                   	pop    %edi
  8027a2:	5d                   	pop    %ebp
  8027a3:	c3                   	ret    
  8027a4:	39 f0                	cmp    %esi,%eax
  8027a6:	0f 87 ac 00 00 00    	ja     802858 <__umoddi3+0xfc>
  8027ac:	0f bd e8             	bsr    %eax,%ebp
  8027af:	83 f5 1f             	xor    $0x1f,%ebp
  8027b2:	0f 84 ac 00 00 00    	je     802864 <__umoddi3+0x108>
  8027b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8027bd:	29 ef                	sub    %ebp,%edi
  8027bf:	89 fe                	mov    %edi,%esi
  8027c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027c5:	89 e9                	mov    %ebp,%ecx
  8027c7:	d3 e0                	shl    %cl,%eax
  8027c9:	89 d7                	mov    %edx,%edi
  8027cb:	89 f1                	mov    %esi,%ecx
  8027cd:	d3 ef                	shr    %cl,%edi
  8027cf:	09 c7                	or     %eax,%edi
  8027d1:	89 e9                	mov    %ebp,%ecx
  8027d3:	d3 e2                	shl    %cl,%edx
  8027d5:	89 14 24             	mov    %edx,(%esp)
  8027d8:	89 d8                	mov    %ebx,%eax
  8027da:	d3 e0                	shl    %cl,%eax
  8027dc:	89 c2                	mov    %eax,%edx
  8027de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027e2:	d3 e0                	shl    %cl,%eax
  8027e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027ec:	89 f1                	mov    %esi,%ecx
  8027ee:	d3 e8                	shr    %cl,%eax
  8027f0:	09 d0                	or     %edx,%eax
  8027f2:	d3 eb                	shr    %cl,%ebx
  8027f4:	89 da                	mov    %ebx,%edx
  8027f6:	f7 f7                	div    %edi
  8027f8:	89 d3                	mov    %edx,%ebx
  8027fa:	f7 24 24             	mull   (%esp)
  8027fd:	89 c6                	mov    %eax,%esi
  8027ff:	89 d1                	mov    %edx,%ecx
  802801:	39 d3                	cmp    %edx,%ebx
  802803:	0f 82 87 00 00 00    	jb     802890 <__umoddi3+0x134>
  802809:	0f 84 91 00 00 00    	je     8028a0 <__umoddi3+0x144>
  80280f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802813:	29 f2                	sub    %esi,%edx
  802815:	19 cb                	sbb    %ecx,%ebx
  802817:	89 d8                	mov    %ebx,%eax
  802819:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80281d:	d3 e0                	shl    %cl,%eax
  80281f:	89 e9                	mov    %ebp,%ecx
  802821:	d3 ea                	shr    %cl,%edx
  802823:	09 d0                	or     %edx,%eax
  802825:	89 e9                	mov    %ebp,%ecx
  802827:	d3 eb                	shr    %cl,%ebx
  802829:	89 da                	mov    %ebx,%edx
  80282b:	83 c4 1c             	add    $0x1c,%esp
  80282e:	5b                   	pop    %ebx
  80282f:	5e                   	pop    %esi
  802830:	5f                   	pop    %edi
  802831:	5d                   	pop    %ebp
  802832:	c3                   	ret    
  802833:	90                   	nop
  802834:	89 fd                	mov    %edi,%ebp
  802836:	85 ff                	test   %edi,%edi
  802838:	75 0b                	jne    802845 <__umoddi3+0xe9>
  80283a:	b8 01 00 00 00       	mov    $0x1,%eax
  80283f:	31 d2                	xor    %edx,%edx
  802841:	f7 f7                	div    %edi
  802843:	89 c5                	mov    %eax,%ebp
  802845:	89 f0                	mov    %esi,%eax
  802847:	31 d2                	xor    %edx,%edx
  802849:	f7 f5                	div    %ebp
  80284b:	89 c8                	mov    %ecx,%eax
  80284d:	f7 f5                	div    %ebp
  80284f:	89 d0                	mov    %edx,%eax
  802851:	e9 44 ff ff ff       	jmp    80279a <__umoddi3+0x3e>
  802856:	66 90                	xchg   %ax,%ax
  802858:	89 c8                	mov    %ecx,%eax
  80285a:	89 f2                	mov    %esi,%edx
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    
  802864:	3b 04 24             	cmp    (%esp),%eax
  802867:	72 06                	jb     80286f <__umoddi3+0x113>
  802869:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80286d:	77 0f                	ja     80287e <__umoddi3+0x122>
  80286f:	89 f2                	mov    %esi,%edx
  802871:	29 f9                	sub    %edi,%ecx
  802873:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802877:	89 14 24             	mov    %edx,(%esp)
  80287a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80287e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802882:	8b 14 24             	mov    (%esp),%edx
  802885:	83 c4 1c             	add    $0x1c,%esp
  802888:	5b                   	pop    %ebx
  802889:	5e                   	pop    %esi
  80288a:	5f                   	pop    %edi
  80288b:	5d                   	pop    %ebp
  80288c:	c3                   	ret    
  80288d:	8d 76 00             	lea    0x0(%esi),%esi
  802890:	2b 04 24             	sub    (%esp),%eax
  802893:	19 fa                	sbb    %edi,%edx
  802895:	89 d1                	mov    %edx,%ecx
  802897:	89 c6                	mov    %eax,%esi
  802899:	e9 71 ff ff ff       	jmp    80280f <__umoddi3+0xb3>
  80289e:	66 90                	xchg   %ax,%ax
  8028a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8028a4:	72 ea                	jb     802890 <__umoddi3+0x134>
  8028a6:	89 d9                	mov    %ebx,%ecx
  8028a8:	e9 62 ff ff ff       	jmp    80280f <__umoddi3+0xb3>
