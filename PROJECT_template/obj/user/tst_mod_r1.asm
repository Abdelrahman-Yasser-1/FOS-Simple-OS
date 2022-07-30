
obj/user/tst_mod_r1:     file format elf32-i386


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
  800031:	e8 bf 05 00 00       	call   8005f5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 2000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	int envID = sys_getenvid();
  80003f:	e8 13 1d 00 00       	call   801d57 <sys_getenvid>
  800044:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("envID = %d\n",envID);
  800047:	83 ec 08             	sub    $0x8,%esp
  80004a:	ff 75 f4             	pushl  -0xc(%ebp)
  80004d:	68 a0 25 80 00       	push   $0x8025a0
  800052:	e8 85 09 00 00       	call   8009dc <cprintf>
  800057:	83 c4 10             	add    $0x10,%esp

	volatile struct Env* myEnv;
	myEnv = &(envs[envID]);
  80005a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80006b:	01 c8                	add    %ecx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	01 c0                	add    %eax,%eax
  800073:	01 d0                	add    %edx,%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	c1 e2 05             	shl    $0x5,%edx
  80007a:	29 c2                	sub    %eax,%edx
  80007c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800083:	89 c2                	mov    %eax,%edx
  800085:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int Mega = 1024*1024;
  80008e:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  800095:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)


	uint8 *x ;
	{
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80009c:	e8 1d 1e 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  8000a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000a4:	e8 92 1d 00 00       	call   801e3b <sys_calculate_free_frames>
  8000a9:	89 45 e0             	mov    %eax,-0x20(%ebp)

		//allocate 2 MB in the heap

		x = malloc(2*Mega) ;
  8000ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000af:	01 c0                	add    %eax,%eax
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	50                   	push   %eax
  8000b5:	e8 ac 16 00 00       	call   801766 <malloc>
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		assert((uint32) x == USER_HEAP_START);
  8000c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000c3:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000c8:	74 16                	je     8000e0 <_main+0xa8>
  8000ca:	68 ac 25 80 00       	push   $0x8025ac
  8000cf:	68 ca 25 80 00       	push   $0x8025ca
  8000d4:	6a 1a                	push   $0x1a
  8000d6:	68 df 25 80 00       	push   $0x8025df
  8000db:	e8 5a 06 00 00       	call   80073a <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1 + 1 + 2 * Mega / PAGE_SIZE));
  8000e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000e3:	e8 53 1d 00 00       	call   801e3b <sys_calculate_free_frames>
  8000e8:	29 c3                	sub    %eax,%ebx
  8000ea:	89 da                	mov    %ebx,%edx
  8000ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ef:	01 c0                	add    %eax,%eax
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	79 05                	jns    8000fa <_main+0xc2>
  8000f5:	05 ff 0f 00 00       	add    $0xfff,%eax
  8000fa:	c1 f8 0c             	sar    $0xc,%eax
  8000fd:	83 c0 02             	add    $0x2,%eax
  800100:	39 c2                	cmp    %eax,%edx
  800102:	74 16                	je     80011a <_main+0xe2>
  800104:	68 f4 25 80 00       	push   $0x8025f4
  800109:	68 ca 25 80 00       	push   $0x8025ca
  80010e:	6a 1b                	push   $0x1b
  800110:	68 df 25 80 00       	push   $0x8025df
  800115:	e8 20 06 00 00       	call   80073a <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2 * Mega / PAGE_SIZE);
  80011a:	e8 9f 1d 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  80011f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800127:	01 c0                	add    %eax,%eax
  800129:	85 c0                	test   %eax,%eax
  80012b:	79 05                	jns    800132 <_main+0xfa>
  80012d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800132:	c1 f8 0c             	sar    $0xc,%eax
  800135:	39 c2                	cmp    %eax,%edx
  800137:	74 16                	je     80014f <_main+0x117>
  800139:	68 44 26 80 00       	push   $0x802644
  80013e:	68 ca 25 80 00       	push   $0x8025ca
  800143:	6a 1d                	push   $0x1d
  800145:	68 df 25 80 00       	push   $0x8025df
  80014a:	e8 eb 05 00 00       	call   80073a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80014f:	e8 e7 1c 00 00       	call   801e3b <sys_calculate_free_frames>
  800154:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800157:	e8 62 1d 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  80015c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(2*Mega) == USER_HEAP_START + 2*Mega) ;
  80015f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800162:	01 c0                	add    %eax,%eax
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	e8 f9 15 00 00       	call   801766 <malloc>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	89 c2                	mov    %eax,%edx
  800172:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800175:	01 c0                	add    %eax,%eax
  800177:	05 00 00 00 80       	add    $0x80000000,%eax
  80017c:	39 c2                	cmp    %eax,%edx
  80017e:	74 16                	je     800196 <_main+0x15e>
  800180:	68 94 26 80 00       	push   $0x802694
  800185:	68 ca 25 80 00       	push   $0x8025ca
  80018a:	6a 21                	push   $0x21
  80018c:	68 df 25 80 00       	push   $0x8025df
  800191:	e8 a4 05 00 00       	call   80073a <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2 * Mega / PAGE_SIZE));
  800196:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800199:	e8 9d 1c 00 00       	call   801e3b <sys_calculate_free_frames>
  80019e:	29 c3                	sub    %eax,%ebx
  8001a0:	89 da                	mov    %ebx,%edx
  8001a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a5:	01 c0                	add    %eax,%eax
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 05                	jns    8001b0 <_main+0x178>
  8001ab:	05 ff 0f 00 00       	add    $0xfff,%eax
  8001b0:	c1 f8 0c             	sar    $0xc,%eax
  8001b3:	39 c2                	cmp    %eax,%edx
  8001b5:	74 16                	je     8001cd <_main+0x195>
  8001b7:	68 c8 26 80 00       	push   $0x8026c8
  8001bc:	68 ca 25 80 00       	push   $0x8025ca
  8001c1:	6a 22                	push   $0x22
  8001c3:	68 df 25 80 00       	push   $0x8025df
  8001c8:	e8 6d 05 00 00       	call   80073a <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2 * Mega / PAGE_SIZE);
  8001cd:	e8 ec 1c 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  8001d2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d5:	89 c2                	mov    %eax,%edx
  8001d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001da:	01 c0                	add    %eax,%eax
  8001dc:	85 c0                	test   %eax,%eax
  8001de:	79 05                	jns    8001e5 <_main+0x1ad>
  8001e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8001e5:	c1 f8 0c             	sar    $0xc,%eax
  8001e8:	39 c2                	cmp    %eax,%edx
  8001ea:	74 16                	je     800202 <_main+0x1ca>
  8001ec:	68 44 26 80 00       	push   $0x802644
  8001f1:	68 ca 25 80 00       	push   $0x8025ca
  8001f6:	6a 24                	push   $0x24
  8001f8:	68 df 25 80 00       	push   $0x8025df
  8001fd:	e8 38 05 00 00       	call   80073a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800202:	e8 34 1c 00 00       	call   801e3b <sys_calculate_free_frames>
  800207:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80020a:	e8 af 1c 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  80020f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(3*Mega) == USER_HEAP_START + 4*Mega) ;
  800212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800215:	89 c2                	mov    %eax,%edx
  800217:	01 d2                	add    %edx,%edx
  800219:	01 d0                	add    %edx,%eax
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	50                   	push   %eax
  80021f:	e8 42 15 00 00       	call   801766 <malloc>
  800224:	83 c4 10             	add    $0x10,%esp
  800227:	89 c2                	mov    %eax,%edx
  800229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022c:	c1 e0 02             	shl    $0x2,%eax
  80022f:	05 00 00 00 80       	add    $0x80000000,%eax
  800234:	39 c2                	cmp    %eax,%edx
  800236:	74 16                	je     80024e <_main+0x216>
  800238:	68 10 27 80 00       	push   $0x802710
  80023d:	68 ca 25 80 00       	push   $0x8025ca
  800242:	6a 28                	push   $0x28
  800244:	68 df 25 80 00       	push   $0x8025df
  800249:	e8 ec 04 00 00       	call   80073a <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1 +1 + 3 * Mega / PAGE_SIZE));
  80024e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800251:	e8 e5 1b 00 00       	call   801e3b <sys_calculate_free_frames>
  800256:	89 d9                	mov    %ebx,%ecx
  800258:	29 c1                	sub    %eax,%ecx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	89 c2                	mov    %eax,%edx
  80025f:	01 d2                	add    %edx,%edx
  800261:	01 d0                	add    %edx,%eax
  800263:	85 c0                	test   %eax,%eax
  800265:	79 05                	jns    80026c <_main+0x234>
  800267:	05 ff 0f 00 00       	add    $0xfff,%eax
  80026c:	c1 f8 0c             	sar    $0xc,%eax
  80026f:	83 c0 02             	add    $0x2,%eax
  800272:	39 c1                	cmp    %eax,%ecx
  800274:	74 16                	je     80028c <_main+0x254>
  800276:	68 44 27 80 00       	push   $0x802744
  80027b:	68 ca 25 80 00       	push   $0x8025ca
  800280:	6a 29                	push   $0x29
  800282:	68 df 25 80 00       	push   $0x8025df
  800287:	e8 ae 04 00 00       	call   80073a <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 3 * Mega / PAGE_SIZE);
  80028c:	e8 2d 1c 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	89 c2                	mov    %eax,%edx
  800296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800299:	89 c1                	mov    %eax,%ecx
  80029b:	01 c9                	add    %ecx,%ecx
  80029d:	01 c8                	add    %ecx,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	79 05                	jns    8002a8 <_main+0x270>
  8002a3:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002a8:	c1 f8 0c             	sar    $0xc,%eax
  8002ab:	39 c2                	cmp    %eax,%edx
  8002ad:	74 16                	je     8002c5 <_main+0x28d>
  8002af:	68 90 27 80 00       	push   $0x802790
  8002b4:	68 ca 25 80 00       	push   $0x8025ca
  8002b9:	6a 2b                	push   $0x2b
  8002bb:	68 df 25 80 00       	push   $0x8025df
  8002c0:	e8 75 04 00 00       	call   80073a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 71 1b 00 00       	call   801e3b <sys_calculate_free_frames>
  8002ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002cd:	e8 ec 1b 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  8002d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(2*kilo) == USER_HEAP_START + 7*Mega) ;
  8002d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	50                   	push   %eax
  8002de:	e8 83 14 00 00       	call   801766 <malloc>
  8002e3:	83 c4 10             	add    $0x10,%esp
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	01 c0                	add    %eax,%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	01 c0                	add    %eax,%eax
  8002f3:	01 d0                	add    %edx,%eax
  8002f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002fa:	39 c1                	cmp    %eax,%ecx
  8002fc:	74 16                	je     800314 <_main+0x2dc>
  8002fe:	68 e0 27 80 00       	push   $0x8027e0
  800303:	68 ca 25 80 00       	push   $0x8025ca
  800308:	6a 2f                	push   $0x2f
  80030a:	68 df 25 80 00       	push   $0x8025df
  80030f:	e8 26 04 00 00       	call   80073a <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  800314:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800317:	e8 1f 1b 00 00       	call   801e3b <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 01             	cmp    $0x1,%eax
  800323:	74 16                	je     80033b <_main+0x303>
  800325:	68 14 28 80 00       	push   $0x802814
  80032a:	68 ca 25 80 00       	push   $0x8025ca
  80032f:	6a 30                	push   $0x30
  800331:	68 df 25 80 00       	push   $0x8025df
  800336:	e8 ff 03 00 00       	call   80073a <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  80033b:	e8 7e 1b 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  800340:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800343:	83 f8 01             	cmp    $0x1,%eax
  800346:	74 16                	je     80035e <_main+0x326>
  800348:	68 48 28 80 00       	push   $0x802848
  80034d:	68 ca 25 80 00       	push   $0x8025ca
  800352:	6a 32                	push   $0x32
  800354:	68 df 25 80 00       	push   $0x8025df
  800359:	e8 dc 03 00 00       	call   80073a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80035e:	e8 d8 1a 00 00       	call   801e3b <sys_calculate_free_frames>
  800363:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800366:	e8 53 1b 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  80036b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(2*kilo) == USER_HEAP_START + 7*Mega + 4*kilo) ;
  80036e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800371:	01 c0                	add    %eax,%eax
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	50                   	push   %eax
  800377:	e8 ea 13 00 00       	call   801766 <malloc>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	89 c2                	mov    %eax,%edx
  800390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800393:	c1 e0 02             	shl    $0x2,%eax
  800396:	01 d0                	add    %edx,%eax
  800398:	05 00 00 00 80       	add    $0x80000000,%eax
  80039d:	39 c1                	cmp    %eax,%ecx
  80039f:	74 16                	je     8003b7 <_main+0x37f>
  8003a1:	68 84 28 80 00       	push   $0x802884
  8003a6:	68 ca 25 80 00       	push   $0x8025ca
  8003ab:	6a 36                	push   $0x36
  8003ad:	68 df 25 80 00       	push   $0x8025df
  8003b2:	e8 83 03 00 00       	call   80073a <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (1));
  8003b7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003ba:	e8 7c 1a 00 00       	call   801e3b <sys_calculate_free_frames>
  8003bf:	29 c3                	sub    %eax,%ebx
  8003c1:	89 d8                	mov    %ebx,%eax
  8003c3:	83 f8 01             	cmp    $0x1,%eax
  8003c6:	74 16                	je     8003de <_main+0x3a6>
  8003c8:	68 14 28 80 00       	push   $0x802814
  8003cd:	68 ca 25 80 00       	push   $0x8025ca
  8003d2:	6a 37                	push   $0x37
  8003d4:	68 df 25 80 00       	push   $0x8025df
  8003d9:	e8 5c 03 00 00       	call   80073a <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 1);
  8003de:	e8 db 1a 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  8003e3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003e6:	83 f8 01             	cmp    $0x1,%eax
  8003e9:	74 16                	je     800401 <_main+0x3c9>
  8003eb:	68 48 28 80 00       	push   $0x802848
  8003f0:	68 ca 25 80 00       	push   $0x8025ca
  8003f5:	6a 39                	push   $0x39
  8003f7:	68 df 25 80 00       	push   $0x8025df
  8003fc:	e8 39 03 00 00       	call   80073a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 35 1a 00 00       	call   801e3b <sys_calculate_free_frames>
  800406:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800409:	e8 b0 1a 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  80040e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		assert((uint32)malloc(7*kilo) == USER_HEAP_START + 7*Mega + 8*kilo) ;
  800411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800414:	89 d0                	mov    %edx,%eax
  800416:	01 c0                	add    %eax,%eax
  800418:	01 d0                	add    %edx,%eax
  80041a:	01 c0                	add    %eax,%eax
  80041c:	01 d0                	add    %edx,%eax
  80041e:	83 ec 0c             	sub    $0xc,%esp
  800421:	50                   	push   %eax
  800422:	e8 3f 13 00 00       	call   801766 <malloc>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	89 c1                	mov    %eax,%ecx
  80042c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	01 c0                	add    %eax,%eax
  800437:	01 d0                	add    %edx,%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043e:	c1 e0 03             	shl    $0x3,%eax
  800441:	01 d0                	add    %edx,%eax
  800443:	05 00 00 00 80       	add    $0x80000000,%eax
  800448:	39 c1                	cmp    %eax,%ecx
  80044a:	74 16                	je     800462 <_main+0x42a>
  80044c:	68 c0 28 80 00       	push   $0x8028c0
  800451:	68 ca 25 80 00       	push   $0x8025ca
  800456:	6a 3d                	push   $0x3d
  800458:	68 df 25 80 00       	push   $0x8025df
  80045d:	e8 d8 02 00 00       	call   80073a <_panic>
		assert((freeFrames - sys_calculate_free_frames()) == (2));
  800462:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800465:	e8 d1 19 00 00       	call   801e3b <sys_calculate_free_frames>
  80046a:	29 c3                	sub    %eax,%ebx
  80046c:	89 d8                	mov    %ebx,%eax
  80046e:	83 f8 02             	cmp    $0x2,%eax
  800471:	74 16                	je     800489 <_main+0x451>
  800473:	68 fc 28 80 00       	push   $0x8028fc
  800478:	68 ca 25 80 00       	push   $0x8025ca
  80047d:	6a 3e                	push   $0x3e
  80047f:	68 df 25 80 00       	push   $0x8025df
  800484:	e8 b1 02 00 00       	call   80073a <_panic>
		//assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
		assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 2);
  800489:	e8 30 1a 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 02             	cmp    $0x2,%eax
  800494:	74 16                	je     8004ac <_main+0x474>
  800496:	68 30 29 80 00       	push   $0x802930
  80049b:	68 ca 25 80 00       	push   $0x8025ca
  8004a0:	6a 40                	push   $0x40
  8004a2:	68 df 25 80 00       	push   $0x8025df
  8004a7:	e8 8e 02 00 00       	call   80073a <_panic>
	}

	///====================


	int freeFrames = sys_calculate_free_frames() ;
  8004ac:	e8 8a 19 00 00       	call   801e3b <sys_calculate_free_frames>
  8004b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004b4:	e8 05 1a 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	{
		x[0] = -1 ;
  8004bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bf:	c6 00 ff             	movb   $0xff,(%eax)
		x[2*Mega] = -1 ;
  8004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	89 c2                	mov    %eax,%edx
  8004c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004cc:	01 d0                	add    %edx,%eax
  8004ce:	c6 00 ff             	movb   $0xff,(%eax)
		x[3*Mega] = -1 ;
  8004d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004d4:	89 c2                	mov    %eax,%edx
  8004d6:	01 d2                	add    %edx,%edx
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	89 c2                	mov    %eax,%edx
  8004dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004df:	01 d0                	add    %edx,%eax
  8004e1:	c6 00 ff             	movb   $0xff,(%eax)
		x[4*Mega] = -1 ;
  8004e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004e7:	c1 e0 02             	shl    $0x2,%eax
  8004ea:	89 c2                	mov    %eax,%edx
  8004ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	c6 00 ff             	movb   $0xff,(%eax)
		x[5*Mega] = -1 ;
  8004f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f7:	89 d0                	mov    %edx,%eax
  8004f9:	c1 e0 02             	shl    $0x2,%eax
  8004fc:	01 d0                	add    %edx,%eax
  8004fe:	89 c2                	mov    %eax,%edx
  800500:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	c6 00 ff             	movb   $0xff,(%eax)
		x[6*Mega] = -1 ;
  800508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80050b:	89 d0                	mov    %edx,%eax
  80050d:	01 c0                	add    %eax,%eax
  80050f:	01 d0                	add    %edx,%eax
  800511:	01 c0                	add    %eax,%eax
  800513:	89 c2                	mov    %eax,%edx
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	01 d0                	add    %edx,%eax
  80051a:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega-1] = -1 ;
  80051d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	01 c0                	add    %eax,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	01 c0                	add    %eax,%eax
  800528:	01 d0                	add    %edx,%eax
  80052a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80052d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+1*kilo] = -1 ;
  800535:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800538:	89 d0                	mov    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 c2                	add    %eax,%edx
  800542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800545:	01 d0                	add    %edx,%eax
  800547:	89 c2                	mov    %eax,%edx
  800549:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+5*kilo] = -1 ;
  800551:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	01 c0                	add    %eax,%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	01 c0                	add    %eax,%eax
  80055c:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  80055f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800562:	89 d0                	mov    %edx,%eax
  800564:	c1 e0 02             	shl    $0x2,%eax
  800567:	01 d0                	add    %edx,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	89 c2                	mov    %eax,%edx
  80056d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c6 00 ff             	movb   $0xff,(%eax)
		x[7*Mega+10*kilo] = -1 ;
  800575:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800578:	89 d0                	mov    %edx,%eax
  80057a:	01 c0                	add    %eax,%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	01 c0                	add    %eax,%eax
  800580:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800586:	89 d0                	mov    %edx,%eax
  800588:	c1 e0 02             	shl    $0x2,%eax
  80058b:	01 d0                	add    %edx,%eax
  80058d:	01 c0                	add    %eax,%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	89 c2                	mov    %eax,%edx
  800593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	c6 00 ff             	movb   $0xff,(%eax)
	}

	assert((freeFrames - sys_calculate_free_frames()) == 0 );
  80059b:	e8 9b 18 00 00       	call   801e3b <sys_calculate_free_frames>
  8005a0:	89 c2                	mov    %eax,%edx
  8005a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a5:	39 c2                	cmp    %eax,%edx
  8005a7:	74 16                	je     8005bf <_main+0x587>
  8005a9:	68 6c 29 80 00       	push   $0x80296c
  8005ae:	68 ca 25 80 00       	push   $0x8025ca
  8005b3:	6a 55                	push   $0x55
  8005b5:	68 df 25 80 00       	push   $0x8025df
  8005ba:	e8 7b 01 00 00       	call   80073a <_panic>
	assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 0);
  8005bf:	e8 fa 18 00 00       	call   801ebe <sys_pf_calculate_allocated_pages>
  8005c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005c7:	74 16                	je     8005df <_main+0x5a7>
  8005c9:	68 9c 29 80 00       	push   $0x80299c
  8005ce:	68 ca 25 80 00       	push   $0x8025ca
  8005d3:	6a 56                	push   $0x56
  8005d5:	68 df 25 80 00       	push   $0x8025df
  8005da:	e8 5b 01 00 00       	call   80073a <_panic>

	cprintf("Congratulations!! your modification is completed successfully.\n");
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	68 d8 29 80 00       	push   $0x8029d8
  8005e7:	e8 f0 03 00 00       	call   8009dc <cprintf>
  8005ec:	83 c4 10             	add    $0x10,%esp

	return;
  8005ef:	90                   	nop
}
  8005f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005f3:	c9                   	leave  
  8005f4:	c3                   	ret    

008005f5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005fb:	e8 70 17 00 00       	call   801d70 <sys_getenvindex>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800606:	89 d0                	mov    %edx,%eax
  800608:	c1 e0 03             	shl    $0x3,%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800614:	01 c8                	add    %ecx,%eax
  800616:	01 c0                	add    %eax,%eax
  800618:	01 d0                	add    %edx,%eax
  80061a:	01 c0                	add    %eax,%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	89 c2                	mov    %eax,%edx
  800620:	c1 e2 05             	shl    $0x5,%edx
  800623:	29 c2                	sub    %eax,%edx
  800625:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80062c:	89 c2                	mov    %eax,%edx
  80062e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800634:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800639:	a1 20 30 80 00       	mov    0x803020,%eax
  80063e:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800644:	84 c0                	test   %al,%al
  800646:	74 0f                	je     800657 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800648:	a1 20 30 80 00       	mov    0x803020,%eax
  80064d:	05 40 3c 01 00       	add    $0x13c40,%eax
  800652:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065b:	7e 0a                	jle    800667 <libmain+0x72>
		binaryname = argv[0];
  80065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	ff 75 08             	pushl  0x8(%ebp)
  800670:	e8 c3 f9 ff ff       	call   800038 <_main>
  800675:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800678:	e8 8e 18 00 00       	call   801f0b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80067d:	83 ec 0c             	sub    $0xc,%esp
  800680:	68 30 2a 80 00       	push   $0x802a30
  800685:	e8 52 03 00 00       	call   8009dc <cprintf>
  80068a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80068d:	a1 20 30 80 00       	mov    0x803020,%eax
  800692:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800698:	a1 20 30 80 00       	mov    0x803020,%eax
  80069d:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	52                   	push   %edx
  8006a7:	50                   	push   %eax
  8006a8:	68 58 2a 80 00       	push   $0x802a58
  8006ad:	e8 2a 03 00 00       	call   8009dc <cprintf>
  8006b2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8006b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ba:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8006c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c5:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8006cb:	83 ec 04             	sub    $0x4,%esp
  8006ce:	52                   	push   %edx
  8006cf:	50                   	push   %eax
  8006d0:	68 80 2a 80 00       	push   $0x802a80
  8006d5:	e8 02 03 00 00       	call   8009dc <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e2:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	50                   	push   %eax
  8006ec:	68 c1 2a 80 00       	push   $0x802ac1
  8006f1:	e8 e6 02 00 00       	call   8009dc <cprintf>
  8006f6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006f9:	83 ec 0c             	sub    $0xc,%esp
  8006fc:	68 30 2a 80 00       	push   $0x802a30
  800701:	e8 d6 02 00 00       	call   8009dc <cprintf>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800709:	e8 17 18 00 00       	call   801f25 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80070e:	e8 19 00 00 00       	call   80072c <exit>
}
  800713:	90                   	nop
  800714:	c9                   	leave  
  800715:	c3                   	ret    

00800716 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80071c:	83 ec 0c             	sub    $0xc,%esp
  80071f:	6a 00                	push   $0x0
  800721:	e8 16 16 00 00       	call   801d3c <sys_env_destroy>
  800726:	83 c4 10             	add    $0x10,%esp
}
  800729:	90                   	nop
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    

0080072c <exit>:

void
exit(void)
{
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800732:	e8 6b 16 00 00       	call   801da2 <sys_env_exit>
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800740:	8d 45 10             	lea    0x10(%ebp),%eax
  800743:	83 c0 04             	add    $0x4,%eax
  800746:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800749:	a1 18 31 80 00       	mov    0x803118,%eax
  80074e:	85 c0                	test   %eax,%eax
  800750:	74 16                	je     800768 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800752:	a1 18 31 80 00       	mov    0x803118,%eax
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	50                   	push   %eax
  80075b:	68 d8 2a 80 00       	push   $0x802ad8
  800760:	e8 77 02 00 00       	call   8009dc <cprintf>
  800765:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800768:	a1 00 30 80 00       	mov    0x803000,%eax
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 08             	pushl  0x8(%ebp)
  800773:	50                   	push   %eax
  800774:	68 dd 2a 80 00       	push   $0x802add
  800779:	e8 5e 02 00 00       	call   8009dc <cprintf>
  80077e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800781:	8b 45 10             	mov    0x10(%ebp),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 f4             	pushl  -0xc(%ebp)
  80078a:	50                   	push   %eax
  80078b:	e8 e1 01 00 00       	call   800971 <vcprintf>
  800790:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	6a 00                	push   $0x0
  800798:	68 f9 2a 80 00       	push   $0x802af9
  80079d:	e8 cf 01 00 00       	call   800971 <vcprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007a5:	e8 82 ff ff ff       	call   80072c <exit>

	// should not return here
	while (1) ;
  8007aa:	eb fe                	jmp    8007aa <_panic+0x70>

008007ac <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b7:	8b 50 74             	mov    0x74(%eax),%edx
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	39 c2                	cmp    %eax,%edx
  8007bf:	74 14                	je     8007d5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007c1:	83 ec 04             	sub    $0x4,%esp
  8007c4:	68 fc 2a 80 00       	push   $0x802afc
  8007c9:	6a 26                	push   $0x26
  8007cb:	68 48 2b 80 00       	push   $0x802b48
  8007d0:	e8 65 ff ff ff       	call   80073a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007e3:	e9 b6 00 00 00       	jmp    80089e <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8007e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	01 d0                	add    %edx,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	85 c0                	test   %eax,%eax
  8007fb:	75 08                	jne    800805 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007fd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800800:	e9 96 00 00 00       	jmp    80089b <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800805:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80080c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800813:	eb 5d                	jmp    800872 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800815:	a1 20 30 80 00       	mov    0x803020,%eax
  80081a:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800820:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800823:	c1 e2 04             	shl    $0x4,%edx
  800826:	01 d0                	add    %edx,%eax
  800828:	8a 40 04             	mov    0x4(%eax),%al
  80082b:	84 c0                	test   %al,%al
  80082d:	75 40                	jne    80086f <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80082f:	a1 20 30 80 00       	mov    0x803020,%eax
  800834:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80083a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80083d:	c1 e2 04             	shl    $0x4,%edx
  800840:	01 d0                	add    %edx,%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800847:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80084a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	01 c8                	add    %ecx,%eax
  800860:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800862:	39 c2                	cmp    %eax,%edx
  800864:	75 09                	jne    80086f <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800866:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80086d:	eb 12                	jmp    800881 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086f:	ff 45 e8             	incl   -0x18(%ebp)
  800872:	a1 20 30 80 00       	mov    0x803020,%eax
  800877:	8b 50 74             	mov    0x74(%eax),%edx
  80087a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087d:	39 c2                	cmp    %eax,%edx
  80087f:	77 94                	ja     800815 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800881:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800885:	75 14                	jne    80089b <CheckWSWithoutLastIndex+0xef>
			panic(
  800887:	83 ec 04             	sub    $0x4,%esp
  80088a:	68 54 2b 80 00       	push   $0x802b54
  80088f:	6a 3a                	push   $0x3a
  800891:	68 48 2b 80 00       	push   $0x802b48
  800896:	e8 9f fe ff ff       	call   80073a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80089b:	ff 45 f0             	incl   -0x10(%ebp)
  80089e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008a4:	0f 8c 3e ff ff ff    	jl     8007e8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b8:	eb 20                	jmp    8008da <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8008bf:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8008c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c8:	c1 e2 04             	shl    $0x4,%edx
  8008cb:	01 d0                	add    %edx,%eax
  8008cd:	8a 40 04             	mov    0x4(%eax),%al
  8008d0:	3c 01                	cmp    $0x1,%al
  8008d2:	75 03                	jne    8008d7 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8008d4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d7:	ff 45 e0             	incl   -0x20(%ebp)
  8008da:	a1 20 30 80 00       	mov    0x803020,%eax
  8008df:	8b 50 74             	mov    0x74(%eax),%edx
  8008e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e5:	39 c2                	cmp    %eax,%edx
  8008e7:	77 d1                	ja     8008ba <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ef:	74 14                	je     800905 <CheckWSWithoutLastIndex+0x159>
		panic(
  8008f1:	83 ec 04             	sub    $0x4,%esp
  8008f4:	68 a8 2b 80 00       	push   $0x802ba8
  8008f9:	6a 44                	push   $0x44
  8008fb:	68 48 2b 80 00       	push   $0x802b48
  800900:	e8 35 fe ff ff       	call   80073a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800905:	90                   	nop
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 48 01             	lea    0x1(%eax),%ecx
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	89 0a                	mov    %ecx,(%edx)
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
  80091e:	88 d1                	mov    %dl,%cl
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
  800923:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800931:	75 2c                	jne    80095f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800933:	a0 24 30 80 00       	mov    0x803024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	8b 12                	mov    (%edx),%edx
  800940:	89 d1                	mov    %edx,%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	83 c2 08             	add    $0x8,%edx
  800948:	83 ec 04             	sub    $0x4,%esp
  80094b:	50                   	push   %eax
  80094c:	51                   	push   %ecx
  80094d:	52                   	push   %edx
  80094e:	e8 a7 13 00 00       	call   801cfa <sys_cputs>
  800953:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800962:	8b 40 04             	mov    0x4(%eax),%eax
  800965:	8d 50 01             	lea    0x1(%eax),%edx
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80097a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800981:	00 00 00 
	b.cnt = 0;
  800984:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80098b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098e:	ff 75 0c             	pushl  0xc(%ebp)
  800991:	ff 75 08             	pushl  0x8(%ebp)
  800994:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099a:	50                   	push   %eax
  80099b:	68 08 09 80 00       	push   $0x800908
  8009a0:	e8 11 02 00 00       	call   800bb6 <vprintfmt>
  8009a5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a8:	a0 24 30 80 00       	mov    0x803024,%al
  8009ad:	0f b6 c0             	movzbl %al,%eax
  8009b0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	50                   	push   %eax
  8009ba:	52                   	push   %edx
  8009bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c1:	83 c0 08             	add    $0x8,%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 30 13 00 00       	call   801cfa <sys_cputs>
  8009ca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cd:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <cprintf>:

int cprintf(const char *fmt, ...) {
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f8:	50                   	push   %eax
  8009f9:	e8 73 ff ff ff       	call   800971 <vcprintf>
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0f:	e8 f7 14 00 00       	call   801f0b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a14:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 f4             	pushl  -0xc(%ebp)
  800a23:	50                   	push   %eax
  800a24:	e8 48 ff ff ff       	call   800971 <vcprintf>
  800a29:	83 c4 10             	add    $0x10,%esp
  800a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2f:	e8 f1 14 00 00       	call   801f25 <sys_enable_interrupt>
	return cnt;
  800a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	53                   	push   %ebx
  800a3d:	83 ec 14             	sub    $0x14,%esp
  800a40:	8b 45 10             	mov    0x10(%ebp),%eax
  800a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a46:	8b 45 14             	mov    0x14(%ebp),%eax
  800a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a54:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a57:	77 55                	ja     800aae <printnum+0x75>
  800a59:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5c:	72 05                	jb     800a63 <printnum+0x2a>
  800a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a61:	77 4b                	ja     800aae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a63:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a66:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a69:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a71:	52                   	push   %edx
  800a72:	50                   	push   %eax
  800a73:	ff 75 f4             	pushl  -0xc(%ebp)
  800a76:	ff 75 f0             	pushl  -0x10(%ebp)
  800a79:	e8 ae 18 00 00       	call   80232c <__udivdi3>
  800a7e:	83 c4 10             	add    $0x10,%esp
  800a81:	83 ec 04             	sub    $0x4,%esp
  800a84:	ff 75 20             	pushl  0x20(%ebp)
  800a87:	53                   	push   %ebx
  800a88:	ff 75 18             	pushl  0x18(%ebp)
  800a8b:	52                   	push   %edx
  800a8c:	50                   	push   %eax
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	ff 75 08             	pushl  0x8(%ebp)
  800a93:	e8 a1 ff ff ff       	call   800a39 <printnum>
  800a98:	83 c4 20             	add    $0x20,%esp
  800a9b:	eb 1a                	jmp    800ab7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 20             	pushl  0x20(%ebp)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aae:	ff 4d 1c             	decl   0x1c(%ebp)
  800ab1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab5:	7f e6                	jg     800a9d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac5:	53                   	push   %ebx
  800ac6:	51                   	push   %ecx
  800ac7:	52                   	push   %edx
  800ac8:	50                   	push   %eax
  800ac9:	e8 6e 19 00 00       	call   80243c <__umoddi3>
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	05 14 2e 80 00       	add    $0x802e14,%eax
  800ad6:	8a 00                	mov    (%eax),%al
  800ad8:	0f be c0             	movsbl %al,%eax
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	50                   	push   %eax
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
}
  800aea:	90                   	nop
  800aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af7:	7e 1c                	jle    800b15 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 00                	mov    (%eax),%eax
  800afe:	8d 50 08             	lea    0x8(%eax),%edx
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	89 10                	mov    %edx,(%eax)
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	83 e8 08             	sub    $0x8,%eax
  800b0e:	8b 50 04             	mov    0x4(%eax),%edx
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	eb 40                	jmp    800b55 <getuint+0x65>
	else if (lflag)
  800b15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b19:	74 1e                	je     800b39 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 00                	mov    (%eax),%eax
  800b20:	8d 50 04             	lea    0x4(%eax),%edx
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	89 10                	mov    %edx,(%eax)
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	83 e8 04             	sub    $0x4,%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	eb 1c                	jmp    800b55 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	8d 50 04             	lea    0x4(%eax),%edx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	89 10                	mov    %edx,(%eax)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	83 e8 04             	sub    $0x4,%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5e:	7e 1c                	jle    800b7c <getint+0x25>
		return va_arg(*ap, long long);
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	8d 50 08             	lea    0x8(%eax),%edx
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	89 10                	mov    %edx,(%eax)
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	83 e8 08             	sub    $0x8,%eax
  800b75:	8b 50 04             	mov    0x4(%eax),%edx
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	eb 38                	jmp    800bb4 <getint+0x5d>
	else if (lflag)
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	74 1a                	je     800b9c <getint+0x45>
		return va_arg(*ap, long);
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	8d 50 04             	lea    0x4(%eax),%edx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 10                	mov    %edx,(%eax)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	83 e8 04             	sub    $0x4,%eax
  800b97:	8b 00                	mov    (%eax),%eax
  800b99:	99                   	cltd   
  800b9a:	eb 18                	jmp    800bb4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	8d 50 04             	lea    0x4(%eax),%edx
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	89 10                	mov    %edx,(%eax)
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax
  800bb3:	99                   	cltd   
}
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
  800bbb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbe:	eb 17                	jmp    800bd7 <vprintfmt+0x21>
			if (ch == '\0')
  800bc0:	85 db                	test   %ebx,%ebx
  800bc2:	0f 84 af 03 00 00    	je     800f77 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	ff 75 0c             	pushl  0xc(%ebp)
  800bce:	53                   	push   %ebx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	8d 50 01             	lea    0x1(%eax),%edx
  800bdd:	89 55 10             	mov    %edx,0x10(%ebp)
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	0f b6 d8             	movzbl %al,%ebx
  800be5:	83 fb 25             	cmp    $0x25,%ebx
  800be8:	75 d6                	jne    800bc0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c03:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0d:	8d 50 01             	lea    0x1(%eax),%edx
  800c10:	89 55 10             	mov    %edx,0x10(%ebp)
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	0f b6 d8             	movzbl %al,%ebx
  800c18:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c1b:	83 f8 55             	cmp    $0x55,%eax
  800c1e:	0f 87 2b 03 00 00    	ja     800f4f <vprintfmt+0x399>
  800c24:	8b 04 85 38 2e 80 00 	mov    0x802e38(,%eax,4),%eax
  800c2b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c31:	eb d7                	jmp    800c0a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c33:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c37:	eb d1                	jmp    800c0a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c39:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c43:	89 d0                	mov    %edx,%eax
  800c45:	c1 e0 02             	shl    $0x2,%eax
  800c48:	01 d0                	add    %edx,%eax
  800c4a:	01 c0                	add    %eax,%eax
  800c4c:	01 d8                	add    %ebx,%eax
  800c4e:	83 e8 30             	sub    $0x30,%eax
  800c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c54:	8b 45 10             	mov    0x10(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5c:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5f:	7e 3e                	jle    800c9f <vprintfmt+0xe9>
  800c61:	83 fb 39             	cmp    $0x39,%ebx
  800c64:	7f 39                	jg     800c9f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c66:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c69:	eb d5                	jmp    800c40 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7f:	eb 1f                	jmp    800ca0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c85:	79 83                	jns    800c0a <vprintfmt+0x54>
				width = 0;
  800c87:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8e:	e9 77 ff ff ff       	jmp    800c0a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c93:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c9a:	e9 6b ff ff ff       	jmp    800c0a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ca0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca4:	0f 89 60 ff ff ff    	jns    800c0a <vprintfmt+0x54>
				width = precision, precision = -1;
  800caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb7:	e9 4e ff ff ff       	jmp    800c0a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cbc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbf:	e9 46 ff ff ff       	jmp    800c0a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc7:	83 c0 04             	add    $0x4,%eax
  800cca:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 e8 04             	sub    $0x4,%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	50                   	push   %eax
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	ff d0                	call   *%eax
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 89 02 00 00       	jmp    800f72 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cfa:	85 db                	test   %ebx,%ebx
  800cfc:	79 02                	jns    800d00 <vprintfmt+0x14a>
				err = -err;
  800cfe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d00:	83 fb 64             	cmp    $0x64,%ebx
  800d03:	7f 0b                	jg     800d10 <vprintfmt+0x15a>
  800d05:	8b 34 9d 80 2c 80 00 	mov    0x802c80(,%ebx,4),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 19                	jne    800d29 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d10:	53                   	push   %ebx
  800d11:	68 25 2e 80 00       	push   $0x802e25
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	ff 75 08             	pushl  0x8(%ebp)
  800d1c:	e8 5e 02 00 00       	call   800f7f <printfmt>
  800d21:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d24:	e9 49 02 00 00       	jmp    800f72 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d29:	56                   	push   %esi
  800d2a:	68 2e 2e 80 00       	push   $0x802e2e
  800d2f:	ff 75 0c             	pushl  0xc(%ebp)
  800d32:	ff 75 08             	pushl  0x8(%ebp)
  800d35:	e8 45 02 00 00       	call   800f7f <printfmt>
  800d3a:	83 c4 10             	add    $0x10,%esp
			break;
  800d3d:	e9 30 02 00 00       	jmp    800f72 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d42:	8b 45 14             	mov    0x14(%ebp),%eax
  800d45:	83 c0 04             	add    $0x4,%eax
  800d48:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4e:	83 e8 04             	sub    $0x4,%eax
  800d51:	8b 30                	mov    (%eax),%esi
  800d53:	85 f6                	test   %esi,%esi
  800d55:	75 05                	jne    800d5c <vprintfmt+0x1a6>
				p = "(null)";
  800d57:	be 31 2e 80 00       	mov    $0x802e31,%esi
			if (width > 0 && padc != '-')
  800d5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d60:	7e 6d                	jle    800dcf <vprintfmt+0x219>
  800d62:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d66:	74 67                	je     800dcf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	50                   	push   %eax
  800d6f:	56                   	push   %esi
  800d70:	e8 0c 03 00 00       	call   801081 <strnlen>
  800d75:	83 c4 10             	add    $0x10,%esp
  800d78:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d7b:	eb 16                	jmp    800d93 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	50                   	push   %eax
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	ff d0                	call   *%eax
  800d8d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d90:	ff 4d e4             	decl   -0x1c(%ebp)
  800d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d97:	7f e4                	jg     800d7d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d99:	eb 34                	jmp    800dcf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9f:	74 1c                	je     800dbd <vprintfmt+0x207>
  800da1:	83 fb 1f             	cmp    $0x1f,%ebx
  800da4:	7e 05                	jle    800dab <vprintfmt+0x1f5>
  800da6:	83 fb 7e             	cmp    $0x7e,%ebx
  800da9:	7e 12                	jle    800dbd <vprintfmt+0x207>
					putch('?', putdat);
  800dab:	83 ec 08             	sub    $0x8,%esp
  800dae:	ff 75 0c             	pushl  0xc(%ebp)
  800db1:	6a 3f                	push   $0x3f
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
  800dbb:	eb 0f                	jmp    800dcc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbd:	83 ec 08             	sub    $0x8,%esp
  800dc0:	ff 75 0c             	pushl  0xc(%ebp)
  800dc3:	53                   	push   %ebx
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	ff d0                	call   *%eax
  800dc9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dcc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcf:	89 f0                	mov    %esi,%eax
  800dd1:	8d 70 01             	lea    0x1(%eax),%esi
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f be d8             	movsbl %al,%ebx
  800dd9:	85 db                	test   %ebx,%ebx
  800ddb:	74 24                	je     800e01 <vprintfmt+0x24b>
  800ddd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de1:	78 b8                	js     800d9b <vprintfmt+0x1e5>
  800de3:	ff 4d e0             	decl   -0x20(%ebp)
  800de6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dea:	79 af                	jns    800d9b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dec:	eb 13                	jmp    800e01 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	6a 20                	push   $0x20
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	ff d0                	call   *%eax
  800dfb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfe:	ff 4d e4             	decl   -0x1c(%ebp)
  800e01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e05:	7f e7                	jg     800dee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e07:	e9 66 01 00 00       	jmp    800f72 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 e8             	pushl  -0x18(%ebp)
  800e12:	8d 45 14             	lea    0x14(%ebp),%eax
  800e15:	50                   	push   %eax
  800e16:	e8 3c fd ff ff       	call   800b57 <getint>
  800e1b:	83 c4 10             	add    $0x10,%esp
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2a:	85 d2                	test   %edx,%edx
  800e2c:	79 23                	jns    800e51 <vprintfmt+0x29b>
				putch('-', putdat);
  800e2e:	83 ec 08             	sub    $0x8,%esp
  800e31:	ff 75 0c             	pushl  0xc(%ebp)
  800e34:	6a 2d                	push   $0x2d
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	ff d0                	call   *%eax
  800e3b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e44:	f7 d8                	neg    %eax
  800e46:	83 d2 00             	adc    $0x0,%edx
  800e49:	f7 da                	neg    %edx
  800e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e51:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 e8             	pushl  -0x18(%ebp)
  800e63:	8d 45 14             	lea    0x14(%ebp),%eax
  800e66:	50                   	push   %eax
  800e67:	e8 84 fc ff ff       	call   800af0 <getuint>
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e75:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7c:	e9 98 00 00 00       	jmp    800f19 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 0c             	pushl  0xc(%ebp)
  800e87:	6a 58                	push   $0x58
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	ff d0                	call   *%eax
  800e8e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	6a 58                	push   $0x58
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	ff d0                	call   *%eax
  800e9e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 58                	push   $0x58
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
			break;
  800eb1:	e9 bc 00 00 00       	jmp    800f72 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb6:	83 ec 08             	sub    $0x8,%esp
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	6a 30                	push   $0x30
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	ff d0                	call   *%eax
  800ec3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 0c             	pushl  0xc(%ebp)
  800ecc:	6a 78                	push   $0x78
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 c0 04             	add    $0x4,%eax
  800edc:	89 45 14             	mov    %eax,0x14(%ebp)
  800edf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee2:	83 e8 04             	sub    $0x4,%eax
  800ee5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ef1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef8:	eb 1f                	jmp    800f19 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 e8             	pushl  -0x18(%ebp)
  800f00:	8d 45 14             	lea    0x14(%ebp),%eax
  800f03:	50                   	push   %eax
  800f04:	e8 e7 fb ff ff       	call   800af0 <getuint>
  800f09:	83 c4 10             	add    $0x10,%esp
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f12:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f19:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f20:	83 ec 04             	sub    $0x4,%esp
  800f23:	52                   	push   %edx
  800f24:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f27:	50                   	push   %eax
  800f28:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2b:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2e:	ff 75 0c             	pushl  0xc(%ebp)
  800f31:	ff 75 08             	pushl  0x8(%ebp)
  800f34:	e8 00 fb ff ff       	call   800a39 <printnum>
  800f39:	83 c4 20             	add    $0x20,%esp
			break;
  800f3c:	eb 34                	jmp    800f72 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3e:	83 ec 08             	sub    $0x8,%esp
  800f41:	ff 75 0c             	pushl  0xc(%ebp)
  800f44:	53                   	push   %ebx
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	ff d0                	call   *%eax
  800f4a:	83 c4 10             	add    $0x10,%esp
			break;
  800f4d:	eb 23                	jmp    800f72 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	6a 25                	push   $0x25
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	ff d0                	call   *%eax
  800f5c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5f:	ff 4d 10             	decl   0x10(%ebp)
  800f62:	eb 03                	jmp    800f67 <vprintfmt+0x3b1>
  800f64:	ff 4d 10             	decl   0x10(%ebp)
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	48                   	dec    %eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3c 25                	cmp    $0x25,%al
  800f6f:	75 f3                	jne    800f64 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f71:	90                   	nop
		}
	}
  800f72:	e9 47 fc ff ff       	jmp    800bbe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f77:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f85:	8d 45 10             	lea    0x10(%ebp),%eax
  800f88:	83 c0 04             	add    $0x4,%eax
  800f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	50                   	push   %eax
  800f95:	ff 75 0c             	pushl  0xc(%ebp)
  800f98:	ff 75 08             	pushl  0x8(%ebp)
  800f9b:	e8 16 fc ff ff       	call   800bb6 <vprintfmt>
  800fa0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa3:	90                   	nop
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    

00800fa6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	8b 40 08             	mov    0x8(%eax),%eax
  800faf:	8d 50 01             	lea    0x1(%eax),%edx
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbb:	8b 10                	mov    (%eax),%edx
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 40 04             	mov    0x4(%eax),%eax
  800fc3:	39 c2                	cmp    %eax,%edx
  800fc5:	73 12                	jae    800fd9 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	8b 00                	mov    (%eax),%eax
  800fcc:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd2:	89 0a                	mov    %ecx,(%edx)
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	88 10                	mov    %dl,(%eax)
}
  800fd9:	90                   	nop
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	01 d0                	add    %edx,%eax
  800ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801001:	74 06                	je     801009 <vsnprintf+0x2d>
  801003:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801007:	7f 07                	jg     801010 <vsnprintf+0x34>
		return -E_INVAL;
  801009:	b8 03 00 00 00       	mov    $0x3,%eax
  80100e:	eb 20                	jmp    801030 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801010:	ff 75 14             	pushl  0x14(%ebp)
  801013:	ff 75 10             	pushl  0x10(%ebp)
  801016:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801019:	50                   	push   %eax
  80101a:	68 a6 0f 80 00       	push   $0x800fa6
  80101f:	e8 92 fb ff ff       	call   800bb6 <vprintfmt>
  801024:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80102a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801038:	8d 45 10             	lea    0x10(%ebp),%eax
  80103b:	83 c0 04             	add    $0x4,%eax
  80103e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801041:	8b 45 10             	mov    0x10(%ebp),%eax
  801044:	ff 75 f4             	pushl  -0xc(%ebp)
  801047:	50                   	push   %eax
  801048:	ff 75 0c             	pushl  0xc(%ebp)
  80104b:	ff 75 08             	pushl  0x8(%ebp)
  80104e:	e8 89 ff ff ff       	call   800fdc <vsnprintf>
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801059:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106b:	eb 06                	jmp    801073 <strlen+0x15>
		n++;
  80106d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	84 c0                	test   %al,%al
  80107a:	75 f1                	jne    80106d <strlen+0xf>
		n++;
	return n;
  80107c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801087:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80108e:	eb 09                	jmp    801099 <strnlen+0x18>
		n++;
  801090:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	ff 4d 0c             	decl   0xc(%ebp)
  801099:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109d:	74 09                	je     8010a8 <strnlen+0x27>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	84 c0                	test   %al,%al
  8010a6:	75 e8                	jne    801090 <strnlen+0xf>
		n++;
	return n;
  8010a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010b9:	90                   	nop
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	84 c0                	test   %al,%al
  8010d4:	75 e4                	jne    8010ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ee:	eb 1f                	jmp    80110f <strncpy+0x34>
		*dst++ = *src;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8d 50 01             	lea    0x1(%eax),%edx
  8010f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fc:	8a 12                	mov    (%edx),%dl
  8010fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 03                	je     80110c <strncpy+0x31>
			src++;
  801109:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80110c:	ff 45 fc             	incl   -0x4(%ebp)
  80110f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801112:	3b 45 10             	cmp    0x10(%ebp),%eax
  801115:	72 d9                	jb     8010f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801128:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112c:	74 30                	je     80115e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80112e:	eb 16                	jmp    801146 <strlcpy+0x2a>
			*dst++ = *src++;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 08             	mov    %edx,0x8(%ebp)
  801139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801142:	8a 12                	mov    (%edx),%dl
  801144:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801146:	ff 4d 10             	decl   0x10(%ebp)
  801149:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114d:	74 09                	je     801158 <strlcpy+0x3c>
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	84 c0                	test   %al,%al
  801156:	75 d8                	jne    801130 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801164:	29 c2                	sub    %eax,%edx
  801166:	89 d0                	mov    %edx,%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80116d:	eb 06                	jmp    801175 <strcmp+0xb>
		p++, q++;
  80116f:	ff 45 08             	incl   0x8(%ebp)
  801172:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	84 c0                	test   %al,%al
  80117c:	74 0e                	je     80118c <strcmp+0x22>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	38 c2                	cmp    %al,%dl
  80118a:	74 e3                	je     80116f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 d0             	movzbl %al,%edx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f b6 c0             	movzbl %al,%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
}
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011a5:	eb 09                	jmp    8011b0 <strncmp+0xe>
		n--, p++, q++;
  8011a7:	ff 4d 10             	decl   0x10(%ebp)
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b4:	74 17                	je     8011cd <strncmp+0x2b>
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	84 c0                	test   %al,%al
  8011bd:	74 0e                	je     8011cd <strncmp+0x2b>
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 10                	mov    (%eax),%dl
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	38 c2                	cmp    %al,%dl
  8011cb:	74 da                	je     8011a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d1:	75 07                	jne    8011da <strncmp+0x38>
		return 0;
  8011d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d8:	eb 14                	jmp    8011ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	0f b6 d0             	movzbl %al,%edx
  8011e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	0f b6 c0             	movzbl %al,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
}
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    

008011f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 04             	sub    $0x4,%esp
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011fc:	eb 12                	jmp    801210 <strchr+0x20>
		if (*s == c)
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801206:	75 05                	jne    80120d <strchr+0x1d>
			return (char *) s;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	eb 11                	jmp    80121e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80120d:	ff 45 08             	incl   0x8(%ebp)
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	84 c0                	test   %al,%al
  801217:	75 e5                	jne    8011fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122c:	eb 0d                	jmp    80123b <strfind+0x1b>
		if (*s == c)
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801236:	74 0e                	je     801246 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801238:	ff 45 08             	incl   0x8(%ebp)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	75 ea                	jne    80122e <strfind+0xe>
  801244:	eb 01                	jmp    801247 <strfind+0x27>
		if (*s == c)
			break;
  801246:	90                   	nop
	return (char *) s;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80125e:	eb 0e                	jmp    80126e <memset+0x22>
		*p++ = c;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80126e:	ff 4d f8             	decl   -0x8(%ebp)
  801271:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801275:	79 e9                	jns    801260 <memset+0x14>
		*p++ = c;

	return v;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80128e:	eb 16                	jmp    8012a6 <memcpy+0x2a>
		*d++ = *s++;
  801290:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801293:	8d 50 01             	lea    0x1(%eax),%edx
  801296:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801299:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80129f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a2:	8a 12                	mov    (%edx),%dl
  8012a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	75 dd                	jne    801290 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d0:	73 50                	jae    801322 <memmove+0x6a>
  8012d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 d0                	add    %edx,%eax
  8012da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012dd:	76 43                	jbe    801322 <memmove+0x6a>
		s += n;
  8012df:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012eb:	eb 10                	jmp    8012fd <memmove+0x45>
			*--d = *--s;
  8012ed:	ff 4d f8             	decl   -0x8(%ebp)
  8012f0:	ff 4d fc             	decl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	8a 10                	mov    (%eax),%dl
  8012f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 e3                	jne    8012ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80130a:	eb 23                	jmp    80132f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80130c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130f:	8d 50 01             	lea    0x1(%eax),%edx
  801312:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801315:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801318:	8d 4a 01             	lea    0x1(%edx),%ecx
  80131b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80131e:	8a 12                	mov    (%edx),%dl
  801320:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	8d 50 ff             	lea    -0x1(%eax),%edx
  801328:	89 55 10             	mov    %edx,0x10(%ebp)
  80132b:	85 c0                	test   %eax,%eax
  80132d:	75 dd                	jne    80130c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801346:	eb 2a                	jmp    801372 <memcmp+0x3e>
		if (*s1 != *s2)
  801348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134b:	8a 10                	mov    (%eax),%dl
  80134d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801350:	8a 00                	mov    (%eax),%al
  801352:	38 c2                	cmp    %al,%dl
  801354:	74 16                	je     80136c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801356:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	0f b6 d0             	movzbl %al,%edx
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	0f b6 c0             	movzbl %al,%eax
  801366:	29 c2                	sub    %eax,%edx
  801368:	89 d0                	mov    %edx,%eax
  80136a:	eb 18                	jmp    801384 <memcmp+0x50>
		s1++, s2++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
  80136f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	8d 50 ff             	lea    -0x1(%eax),%edx
  801378:	89 55 10             	mov    %edx,0x10(%ebp)
  80137b:	85 c0                	test   %eax,%eax
  80137d:	75 c9                	jne    801348 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	8b 45 10             	mov    0x10(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801397:	eb 15                	jmp    8013ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	0f b6 d0             	movzbl %al,%edx
  8013a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a4:	0f b6 c0             	movzbl %al,%eax
  8013a7:	39 c2                	cmp    %eax,%edx
  8013a9:	74 0d                	je     8013b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013b4:	72 e3                	jb     801399 <memfind+0x13>
  8013b6:	eb 01                	jmp    8013b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013b8:	90                   	nop
	return (void *) s;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d2:	eb 03                	jmp    8013d7 <strtol+0x19>
		s++;
  8013d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	3c 20                	cmp    $0x20,%al
  8013de:	74 f4                	je     8013d4 <strtol+0x16>
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	3c 09                	cmp    $0x9,%al
  8013e7:	74 eb                	je     8013d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2b                	cmp    $0x2b,%al
  8013f0:	75 05                	jne    8013f7 <strtol+0x39>
		s++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
  8013f5:	eb 13                	jmp    80140a <strtol+0x4c>
	else if (*s == '-')
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	3c 2d                	cmp    $0x2d,%al
  8013fe:	75 0a                	jne    80140a <strtol+0x4c>
		s++, neg = 1;
  801400:	ff 45 08             	incl   0x8(%ebp)
  801403:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	74 06                	je     801416 <strtol+0x58>
  801410:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801414:	75 20                	jne    801436 <strtol+0x78>
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 30                	cmp    $0x30,%al
  80141d:	75 17                	jne    801436 <strtol+0x78>
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	40                   	inc    %eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 78                	cmp    $0x78,%al
  801427:	75 0d                	jne    801436 <strtol+0x78>
		s += 2, base = 16;
  801429:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80142d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801434:	eb 28                	jmp    80145e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801436:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143a:	75 15                	jne    801451 <strtol+0x93>
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3c 30                	cmp    $0x30,%al
  801443:	75 0c                	jne    801451 <strtol+0x93>
		s++, base = 8;
  801445:	ff 45 08             	incl   0x8(%ebp)
  801448:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80144f:	eb 0d                	jmp    80145e <strtol+0xa0>
	else if (base == 0)
  801451:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801455:	75 07                	jne    80145e <strtol+0xa0>
		base = 10;
  801457:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3c 2f                	cmp    $0x2f,%al
  801465:	7e 19                	jle    801480 <strtol+0xc2>
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	3c 39                	cmp    $0x39,%al
  80146e:	7f 10                	jg     801480 <strtol+0xc2>
			dig = *s - '0';
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	0f be c0             	movsbl %al,%eax
  801478:	83 e8 30             	sub    $0x30,%eax
  80147b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147e:	eb 42                	jmp    8014c2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	3c 60                	cmp    $0x60,%al
  801487:	7e 19                	jle    8014a2 <strtol+0xe4>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 7a                	cmp    $0x7a,%al
  801490:	7f 10                	jg     8014a2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	0f be c0             	movsbl %al,%eax
  80149a:	83 e8 57             	sub    $0x57,%eax
  80149d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a0:	eb 20                	jmp    8014c2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	3c 40                	cmp    $0x40,%al
  8014a9:	7e 39                	jle    8014e4 <strtol+0x126>
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 5a                	cmp    $0x5a,%al
  8014b2:	7f 30                	jg     8014e4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	0f be c0             	movsbl %al,%eax
  8014bc:	83 e8 37             	sub    $0x37,%eax
  8014bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014c8:	7d 19                	jge    8014e3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014ca:	ff 45 08             	incl   0x8(%ebp)
  8014cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014d4:	89 c2                	mov    %eax,%edx
  8014d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014de:	e9 7b ff ff ff       	jmp    80145e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014e3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e8:	74 08                	je     8014f2 <strtol+0x134>
		*endptr = (char *) s;
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014f6:	74 07                	je     8014ff <strtol+0x141>
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	f7 d8                	neg    %eax
  8014fd:	eb 03                	jmp    801502 <strtol+0x144>
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <ltostr>:

void
ltostr(long value, char *str)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80150a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801511:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151c:	79 13                	jns    801531 <ltostr+0x2d>
	{
		neg = 1;
  80151e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80152b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80152e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801539:	99                   	cltd   
  80153a:	f7 f9                	idiv   %ecx
  80153c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80153f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801542:	8d 50 01             	lea    0x1(%eax),%edx
  801545:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801548:	89 c2                	mov    %eax,%edx
  80154a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154d:	01 d0                	add    %edx,%eax
  80154f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801552:	83 c2 30             	add    $0x30,%edx
  801555:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801557:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80155f:	f7 e9                	imul   %ecx
  801561:	c1 fa 02             	sar    $0x2,%edx
  801564:	89 c8                	mov    %ecx,%eax
  801566:	c1 f8 1f             	sar    $0x1f,%eax
  801569:	29 c2                	sub    %eax,%edx
  80156b:	89 d0                	mov    %edx,%eax
  80156d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801570:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801573:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801578:	f7 e9                	imul   %ecx
  80157a:	c1 fa 02             	sar    $0x2,%edx
  80157d:	89 c8                	mov    %ecx,%eax
  80157f:	c1 f8 1f             	sar    $0x1f,%eax
  801582:	29 c2                	sub    %eax,%edx
  801584:	89 d0                	mov    %edx,%eax
  801586:	c1 e0 02             	shl    $0x2,%eax
  801589:	01 d0                	add    %edx,%eax
  80158b:	01 c0                	add    %eax,%eax
  80158d:	29 c1                	sub    %eax,%ecx
  80158f:	89 ca                	mov    %ecx,%edx
  801591:	85 d2                	test   %edx,%edx
  801593:	75 9c                	jne    801531 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801595:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80159c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159f:	48                   	dec    %eax
  8015a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015a7:	74 3d                	je     8015e6 <ltostr+0xe2>
		start = 1 ;
  8015a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015b0:	eb 34                	jmp    8015e6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b8:	01 d0                	add    %edx,%eax
  8015ba:	8a 00                	mov    (%eax),%al
  8015bc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	01 c2                	add    %eax,%edx
  8015c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cd:	01 c8                	add    %ecx,%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d9:	01 c2                	add    %eax,%edx
  8015db:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015de:	88 02                	mov    %al,(%edx)
		start++ ;
  8015e0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015e3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ec:	7c c4                	jl     8015b2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	e8 54 fa ff ff       	call   80105e <strlen>
  80160a:	83 c4 04             	add    $0x4,%esp
  80160d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801610:	ff 75 0c             	pushl  0xc(%ebp)
  801613:	e8 46 fa ff ff       	call   80105e <strlen>
  801618:	83 c4 04             	add    $0x4,%esp
  80161b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80161e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801625:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162c:	eb 17                	jmp    801645 <strcconcat+0x49>
		final[s] = str1[s] ;
  80162e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801631:	8b 45 10             	mov    0x10(%ebp),%eax
  801634:	01 c2                	add    %eax,%edx
  801636:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	01 c8                	add    %ecx,%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801642:	ff 45 fc             	incl   -0x4(%ebp)
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80164b:	7c e1                	jl     80162e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80164d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801654:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80165b:	eb 1f                	jmp    80167c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80165d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801660:	8d 50 01             	lea    0x1(%eax),%edx
  801663:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801666:	89 c2                	mov    %eax,%edx
  801668:	8b 45 10             	mov    0x10(%ebp),%eax
  80166b:	01 c2                	add    %eax,%edx
  80166d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801670:	8b 45 0c             	mov    0xc(%ebp),%eax
  801673:	01 c8                	add    %ecx,%eax
  801675:	8a 00                	mov    (%eax),%al
  801677:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801679:	ff 45 f8             	incl   -0x8(%ebp)
  80167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801682:	7c d9                	jl     80165d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801684:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801687:	8b 45 10             	mov    0x10(%ebp),%eax
  80168a:	01 d0                	add    %edx,%eax
  80168c:	c6 00 00             	movb   $0x0,(%eax)
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801695:	8b 45 14             	mov    0x14(%ebp),%eax
  801698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	8b 00                	mov    (%eax),%eax
  8016a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ad:	01 d0                	add    %edx,%eax
  8016af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b5:	eb 0c                	jmp    8016c3 <strsplit+0x31>
			*string++ = 0;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8d 50 01             	lea    0x1(%eax),%edx
  8016bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	84 c0                	test   %al,%al
  8016ca:	74 18                	je     8016e4 <strsplit+0x52>
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	0f be c0             	movsbl %al,%eax
  8016d4:	50                   	push   %eax
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	e8 13 fb ff ff       	call   8011f0 <strchr>
  8016dd:	83 c4 08             	add    $0x8,%esp
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 d3                	jne    8016b7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	84 c0                	test   %al,%al
  8016eb:	74 5a                	je     801747 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f0:	8b 00                	mov    (%eax),%eax
  8016f2:	83 f8 0f             	cmp    $0xf,%eax
  8016f5:	75 07                	jne    8016fe <strsplit+0x6c>
		{
			return 0;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fc:	eb 66                	jmp    801764 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801701:	8b 00                	mov    (%eax),%eax
  801703:	8d 48 01             	lea    0x1(%eax),%ecx
  801706:	8b 55 14             	mov    0x14(%ebp),%edx
  801709:	89 0a                	mov    %ecx,(%edx)
  80170b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801712:	8b 45 10             	mov    0x10(%ebp),%eax
  801715:	01 c2                	add    %eax,%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80171c:	eb 03                	jmp    801721 <strsplit+0x8f>
			string++;
  80171e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	84 c0                	test   %al,%al
  801728:	74 8b                	je     8016b5 <strsplit+0x23>
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	0f be c0             	movsbl %al,%eax
  801732:	50                   	push   %eax
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	e8 b5 fa ff ff       	call   8011f0 <strchr>
  80173b:	83 c4 08             	add    $0x8,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 dc                	je     80171e <strsplit+0x8c>
			string++;
	}
  801742:	e9 6e ff ff ff       	jmp    8016b5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801747:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801748:	8b 45 14             	mov    0x14(%ebp),%eax
  80174b:	8b 00                	mov    (%eax),%eax
  80174d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80175f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  80176c:	a1 28 30 80 00       	mov    0x803028,%eax
  801771:	85 c0                	test   %eax,%eax
  801773:	75 33                	jne    8017a8 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801775:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  80177c:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  80177f:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801786:	00 00 a0 
		spaces[0].pages = numPages;
  801789:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801790:	00 02 00 
		spaces[0].isFree = 1;
  801793:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  80179a:	00 00 00 
		arraySize++;
  80179d:	a1 28 30 80 00       	mov    0x803028,%eax
  8017a2:	40                   	inc    %eax
  8017a3:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  8017a8:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  8017af:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  8017b6:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c3:	01 d0                	add    %edx,%eax
  8017c5:	48                   	dec    %eax
  8017c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	f7 75 e8             	divl   -0x18(%ebp)
  8017d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d7:	29 d0                	sub    %edx,%eax
  8017d9:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	c1 e8 0c             	shr    $0xc,%eax
  8017e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8017e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8017ec:	eb 57                	jmp    801845 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8017ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f1:	c1 e0 04             	shl    $0x4,%eax
  8017f4:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017f9:	8b 00                	mov    (%eax),%eax
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	74 42                	je     801841 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8017ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801802:	c1 e0 04             	shl    $0x4,%eax
  801805:	05 28 31 80 00       	add    $0x803128,%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80180f:	7c 31                	jl     801842 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801814:	c1 e0 04             	shl    $0x4,%eax
  801817:	05 28 31 80 00       	add    $0x803128,%eax
  80181c:	8b 00                	mov    (%eax),%eax
  80181e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801821:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801824:	7d 1c                	jge    801842 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  801826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801829:	c1 e0 04             	shl    $0x4,%eax
  80182c:	05 28 31 80 00       	add    $0x803128,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801836:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  801839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80183f:	eb 01                	jmp    801842 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801841:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801842:	ff 45 ec             	incl   -0x14(%ebp)
  801845:	a1 28 30 80 00       	mov    0x803028,%eax
  80184a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80184d:	7c 9f                	jl     8017ee <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  80184f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801853:	75 0a                	jne    80185f <malloc+0xf9>
	{
		return NULL;
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	e9 34 01 00 00       	jmp    801993 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801862:	c1 e0 04             	shl    $0x4,%eax
  801865:	05 28 31 80 00       	add    $0x803128,%eax
  80186a:	8b 00                	mov    (%eax),%eax
  80186c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80186f:	75 38                	jne    8018a9 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801874:	c1 e0 04             	shl    $0x4,%eax
  801877:	05 2c 31 80 00       	add    $0x80312c,%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801885:	c1 e0 0c             	shl    $0xc,%eax
  801888:	89 c2                	mov    %eax,%edx
  80188a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188d:	c1 e0 04             	shl    $0x4,%eax
  801890:	05 20 31 80 00       	add    $0x803120,%eax
  801895:	8b 00                	mov    (%eax),%eax
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	e8 01 06 00 00       	call   801ea2 <sys_allocateMem>
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	e9 dd 00 00 00       	jmp    801986 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8018a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ac:	c1 e0 04             	shl    $0x4,%eax
  8018af:	05 20 31 80 00       	add    $0x803120,%eax
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b9:	c1 e2 0c             	shl    $0xc,%edx
  8018bc:	01 d0                	add    %edx,%eax
  8018be:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8018c1:	a1 28 30 80 00       	mov    0x803028,%eax
  8018c6:	c1 e0 04             	shl    $0x4,%eax
  8018c9:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  8018cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d2:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8018d4:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018dd:	c1 e0 04             	shl    $0x4,%eax
  8018e0:	05 24 31 80 00       	add    $0x803124,%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	c1 e2 04             	shl    $0x4,%edx
  8018ea:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8018f0:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8018f2:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8018f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fb:	c1 e0 04             	shl    $0x4,%eax
  8018fe:	05 28 31 80 00       	add    $0x803128,%eax
  801903:	8b 00                	mov    (%eax),%eax
  801905:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801908:	c1 e2 04             	shl    $0x4,%edx
  80190b:	81 c2 28 31 80 00    	add    $0x803128,%edx
  801911:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801913:	a1 28 30 80 00       	mov    0x803028,%eax
  801918:	c1 e0 04             	shl    $0x4,%eax
  80191b:	05 2c 31 80 00       	add    $0x80312c,%eax
  801920:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  801926:	a1 28 30 80 00       	mov    0x803028,%eax
  80192b:	40                   	inc    %eax
  80192c:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801934:	c1 e0 04             	shl    $0x4,%eax
  801937:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  80193d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801940:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801945:	c1 e0 04             	shl    $0x4,%eax
  801948:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  80194e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801951:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	c1 e0 04             	shl    $0x4,%eax
  801959:	05 2c 31 80 00       	add    $0x80312c,%eax
  80195e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801964:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801967:	c1 e0 0c             	shl    $0xc,%eax
  80196a:	89 c2                	mov    %eax,%edx
  80196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196f:	c1 e0 04             	shl    $0x4,%eax
  801972:	05 20 31 80 00       	add    $0x803120,%eax
  801977:	8b 00                	mov    (%eax),%eax
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	e8 1f 05 00 00       	call   801ea2 <sys_allocateMem>
  801983:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801989:	c1 e0 04             	shl    $0x4,%eax
  80198c:	05 20 31 80 00       	add    $0x803120,%eax
  801991:	8b 00                	mov    (%eax),%eax
	}


}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  80199b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  8019a2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  8019a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8019b0:	eb 3f                	jmp    8019f1 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  8019b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b5:	c1 e0 04             	shl    $0x4,%eax
  8019b8:	05 20 31 80 00       	add    $0x803120,%eax
  8019bd:	8b 00                	mov    (%eax),%eax
  8019bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019c2:	75 2a                	jne    8019ee <free+0x59>
		{
			index=i;
  8019c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  8019ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cd:	c1 e0 04             	shl    $0x4,%eax
  8019d0:	05 28 31 80 00       	add    $0x803128,%eax
  8019d5:	8b 00                	mov    (%eax),%eax
  8019d7:	c1 e0 0c             	shl    $0xc,%eax
  8019da:	89 c2                	mov    %eax,%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	e8 9d 04 00 00       	call   801e86 <sys_freeMem>
  8019e9:	83 c4 10             	add    $0x10,%esp
			break;
  8019ec:	eb 0d                	jmp    8019fb <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8019ee:	ff 45 ec             	incl   -0x14(%ebp)
  8019f1:	a1 28 30 80 00       	mov    0x803028,%eax
  8019f6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8019f9:	7c b7                	jl     8019b2 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8019fb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8019ff:	75 17                	jne    801a18 <free+0x83>
	{
		panic("Error");
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	68 90 2f 80 00       	push   $0x802f90
  801a09:	68 81 00 00 00       	push   $0x81
  801a0e:	68 96 2f 80 00       	push   $0x802f96
  801a13:	e8 22 ed ff ff       	call   80073a <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  801a18:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a1f:	e9 cc 00 00 00       	jmp    801af0 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a27:	c1 e0 04             	shl    $0x4,%eax
  801a2a:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a2f:	8b 00                	mov    (%eax),%eax
  801a31:	85 c0                	test   %eax,%eax
  801a33:	0f 84 b3 00 00 00    	je     801aec <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  801a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3c:	c1 e0 04             	shl    $0x4,%eax
  801a3f:	05 20 31 80 00       	add    $0x803120,%eax
  801a44:	8b 10                	mov    (%eax),%edx
  801a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a49:	c1 e0 04             	shl    $0x4,%eax
  801a4c:	05 24 31 80 00       	add    $0x803124,%eax
  801a51:	8b 00                	mov    (%eax),%eax
  801a53:	39 c2                	cmp    %eax,%edx
  801a55:	0f 85 92 00 00 00    	jne    801aed <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5e:	c1 e0 04             	shl    $0x4,%eax
  801a61:	05 24 31 80 00       	add    $0x803124,%eax
  801a66:	8b 00                	mov    (%eax),%eax
  801a68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a6b:	c1 e2 04             	shl    $0x4,%edx
  801a6e:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801a74:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a79:	c1 e0 04             	shl    $0x4,%eax
  801a7c:	05 28 31 80 00       	add    $0x803128,%eax
  801a81:	8b 10                	mov    (%eax),%edx
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	c1 e0 04             	shl    $0x4,%eax
  801a89:	05 28 31 80 00       	add    $0x803128,%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a95:	c1 e0 04             	shl    $0x4,%eax
  801a98:	05 28 31 80 00       	add    $0x803128,%eax
  801a9d:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa2:	c1 e0 04             	shl    $0x4,%eax
  801aa5:	05 20 31 80 00       	add    $0x803120,%eax
  801aaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab3:	c1 e0 04             	shl    $0x4,%eax
  801ab6:	05 24 31 80 00       	add    $0x803124,%eax
  801abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	c1 e0 04             	shl    $0x4,%eax
  801ac7:	05 28 31 80 00       	add    $0x803128,%eax
  801acc:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad5:	c1 e0 04             	shl    $0x4,%eax
  801ad8:	05 2c 31 80 00       	add    $0x80312c,%eax
  801add:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801ae3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801aea:	eb 12                	jmp    801afe <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801aec:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  801aed:	ff 45 e8             	incl   -0x18(%ebp)
  801af0:	a1 28 30 80 00       	mov    0x803028,%eax
  801af5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801af8:	0f 8c 26 ff ff ff    	jl     801a24 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801afe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b05:	e9 cc 00 00 00       	jmp    801bd6 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b0d:	c1 e0 04             	shl    $0x4,%eax
  801b10:	05 2c 31 80 00       	add    $0x80312c,%eax
  801b15:	8b 00                	mov    (%eax),%eax
  801b17:	85 c0                	test   %eax,%eax
  801b19:	0f 84 b3 00 00 00    	je     801bd2 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b22:	c1 e0 04             	shl    $0x4,%eax
  801b25:	05 24 31 80 00       	add    $0x803124,%eax
  801b2a:	8b 10                	mov    (%eax),%edx
  801b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2f:	c1 e0 04             	shl    $0x4,%eax
  801b32:	05 20 31 80 00       	add    $0x803120,%eax
  801b37:	8b 00                	mov    (%eax),%eax
  801b39:	39 c2                	cmp    %eax,%edx
  801b3b:	0f 85 92 00 00 00    	jne    801bd3 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b44:	c1 e0 04             	shl    $0x4,%eax
  801b47:	05 20 31 80 00       	add    $0x803120,%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b51:	c1 e2 04             	shl    $0x4,%edx
  801b54:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801b5a:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5f:	c1 e0 04             	shl    $0x4,%eax
  801b62:	05 28 31 80 00       	add    $0x803128,%eax
  801b67:	8b 10                	mov    (%eax),%edx
  801b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6c:	c1 e0 04             	shl    $0x4,%eax
  801b6f:	05 28 31 80 00       	add    $0x803128,%eax
  801b74:	8b 00                	mov    (%eax),%eax
  801b76:	01 c2                	add    %eax,%edx
  801b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b7b:	c1 e0 04             	shl    $0x4,%eax
  801b7e:	05 28 31 80 00       	add    $0x803128,%eax
  801b83:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b88:	c1 e0 04             	shl    $0x4,%eax
  801b8b:	05 20 31 80 00       	add    $0x803120,%eax
  801b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b99:	c1 e0 04             	shl    $0x4,%eax
  801b9c:	05 24 31 80 00       	add    $0x803124,%eax
  801ba1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	c1 e0 04             	shl    $0x4,%eax
  801bad:	05 28 31 80 00       	add    $0x803128,%eax
  801bb2:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbb:	c1 e0 04             	shl    $0x4,%eax
  801bbe:	05 2c 31 80 00       	add    $0x80312c,%eax
  801bc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801bc9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801bd0:	eb 12                	jmp    801be4 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801bd2:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801bd3:	ff 45 e4             	incl   -0x1c(%ebp)
  801bd6:	a1 28 30 80 00       	mov    0x803028,%eax
  801bdb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bde:	0f 8c 26 ff ff ff    	jl     801b0a <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801be4:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801be8:	75 11                	jne    801bfb <free+0x266>
	{
		spaces[index].isFree = 1;
  801bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bed:	c1 e0 04             	shl    $0x4,%eax
  801bf0:	05 2c 31 80 00       	add    $0x80312c,%eax
  801bf5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 18             	sub    $0x18,%esp
  801c04:	8b 45 10             	mov    0x10(%ebp),%eax
  801c07:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	68 a4 2f 80 00       	push   $0x802fa4
  801c12:	68 b9 00 00 00       	push   $0xb9
  801c17:	68 96 2f 80 00       	push   $0x802f96
  801c1c:	e8 19 eb ff ff       	call   80073a <_panic>

00801c21 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	68 a4 2f 80 00       	push   $0x802fa4
  801c2f:	68 bf 00 00 00       	push   $0xbf
  801c34:	68 96 2f 80 00       	push   $0x802f96
  801c39:	e8 fc ea ff ff       	call   80073a <_panic>

00801c3e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	68 a4 2f 80 00       	push   $0x802fa4
  801c4c:	68 c5 00 00 00       	push   $0xc5
  801c51:	68 96 2f 80 00       	push   $0x802f96
  801c56:	e8 df ea ff ff       	call   80073a <_panic>

00801c5b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	68 a4 2f 80 00       	push   $0x802fa4
  801c69:	68 ca 00 00 00       	push   $0xca
  801c6e:	68 96 2f 80 00       	push   $0x802f96
  801c73:	e8 c2 ea ff ff       	call   80073a <_panic>

00801c78 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	68 a4 2f 80 00       	push   $0x802fa4
  801c86:	68 d0 00 00 00       	push   $0xd0
  801c8b:	68 96 2f 80 00       	push   $0x802f96
  801c90:	e8 a5 ea ff ff       	call   80073a <_panic>

00801c95 <shrink>:
}
void shrink(uint32 newSize)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	68 a4 2f 80 00       	push   $0x802fa4
  801ca3:	68 d4 00 00 00       	push   $0xd4
  801ca8:	68 96 2f 80 00       	push   $0x802f96
  801cad:	e8 88 ea ff ff       	call   80073a <_panic>

00801cb2 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 a4 2f 80 00       	push   $0x802fa4
  801cc0:	68 d9 00 00 00       	push   $0xd9
  801cc5:	68 96 2f 80 00       	push   $0x802f96
  801cca:	e8 6b ea ff ff       	call   80073a <_panic>

00801ccf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	57                   	push   %edi
  801cd3:	56                   	push   %esi
  801cd4:	53                   	push   %ebx
  801cd5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ce7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cea:	cd 30                	int    $0x30
  801cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5f                   	pop    %edi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    

00801cfa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	8b 45 10             	mov    0x10(%ebp),%eax
  801d03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	50                   	push   %eax
  801d16:	6a 00                	push   $0x0
  801d18:	e8 b2 ff ff ff       	call   801ccf <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	90                   	nop
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 01                	push   $0x1
  801d32:	e8 98 ff ff ff       	call   801ccf <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	50                   	push   %eax
  801d4b:	6a 05                	push   $0x5
  801d4d:	e8 7d ff ff ff       	call   801ccf <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 02                	push   $0x2
  801d66:	e8 64 ff ff ff       	call   801ccf <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 03                	push   $0x3
  801d7f:	e8 4b ff ff ff       	call   801ccf <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 04                	push   $0x4
  801d98:	e8 32 ff ff ff       	call   801ccf <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_env_exit>:


void sys_env_exit(void)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 06                	push   $0x6
  801db1:	e8 19 ff ff ff       	call   801ccf <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	90                   	nop
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	6a 07                	push   $0x7
  801dcf:	e8 fb fe ff ff       	call   801ccf <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	56                   	push   %esi
  801ddd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dde:	8b 75 18             	mov    0x18(%ebp),%esi
  801de1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	56                   	push   %esi
  801dee:	53                   	push   %ebx
  801def:	51                   	push   %ecx
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	6a 08                	push   $0x8
  801df4:	e8 d6 fe ff ff       	call   801ccf <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	52                   	push   %edx
  801e13:	50                   	push   %eax
  801e14:	6a 09                	push   $0x9
  801e16:	e8 b4 fe ff ff       	call   801ccf <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	ff 75 0c             	pushl  0xc(%ebp)
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	6a 0a                	push   $0xa
  801e31:	e8 99 fe ff ff       	call   801ccf <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 0b                	push   $0xb
  801e4a:	e8 80 fe ff ff       	call   801ccf <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 0c                	push   $0xc
  801e63:	e8 67 fe ff ff       	call   801ccf <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 0d                	push   $0xd
  801e7c:	e8 4e fe ff ff       	call   801ccf <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	6a 11                	push   $0x11
  801e97:	e8 33 fe ff ff       	call   801ccf <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	ff 75 0c             	pushl  0xc(%ebp)
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	6a 12                	push   $0x12
  801eb3:	e8 17 fe ff ff       	call   801ccf <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 0e                	push   $0xe
  801ecd:	e8 fd fd ff ff       	call   801ccf <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	ff 75 08             	pushl  0x8(%ebp)
  801ee5:	6a 0f                	push   $0xf
  801ee7:	e8 e3 fd ff ff       	call   801ccf <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 10                	push   $0x10
  801f00:	e8 ca fd ff ff       	call   801ccf <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	90                   	nop
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 14                	push   $0x14
  801f1a:	e8 b0 fd ff ff       	call   801ccf <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	90                   	nop
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 15                	push   $0x15
  801f34:	e8 96 fd ff ff       	call   801ccf <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	90                   	nop
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_cputc>:


void
sys_cputc(const char c)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	50                   	push   %eax
  801f58:	6a 16                	push   $0x16
  801f5a:	e8 70 fd ff ff       	call   801ccf <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	90                   	nop
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 17                	push   $0x17
  801f74:	e8 56 fd ff ff       	call   801ccf <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	50                   	push   %eax
  801f8f:	6a 18                	push   $0x18
  801f91:	e8 39 fd ff ff       	call   801ccf <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	6a 1b                	push   $0x1b
  801fae:	e8 1c fd ff ff       	call   801ccf <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	52                   	push   %edx
  801fc8:	50                   	push   %eax
  801fc9:	6a 19                	push   $0x19
  801fcb:	e8 ff fc ff ff       	call   801ccf <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	90                   	nop
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	52                   	push   %edx
  801fe6:	50                   	push   %eax
  801fe7:	6a 1a                	push   $0x1a
  801fe9:	e8 e1 fc ff ff       	call   801ccf <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	90                   	nop
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802000:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802003:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	6a 00                	push   $0x0
  80200c:	51                   	push   %ecx
  80200d:	52                   	push   %edx
  80200e:	ff 75 0c             	pushl  0xc(%ebp)
  802011:	50                   	push   %eax
  802012:	6a 1c                	push   $0x1c
  802014:	e8 b6 fc ff ff       	call   801ccf <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 1d                	push   $0x1d
  802031:	e8 99 fc ff ff       	call   801ccf <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80203e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	51                   	push   %ecx
  80204c:	52                   	push   %edx
  80204d:	50                   	push   %eax
  80204e:	6a 1e                	push   $0x1e
  802050:	e8 7a fc ff ff       	call   801ccf <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	52                   	push   %edx
  80206a:	50                   	push   %eax
  80206b:	6a 1f                	push   $0x1f
  80206d:	e8 5d fc ff ff       	call   801ccf <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 20                	push   $0x20
  802086:	e8 44 fc ff ff       	call   801ccf <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	6a 00                	push   $0x0
  802098:	ff 75 14             	pushl  0x14(%ebp)
  80209b:	ff 75 10             	pushl  0x10(%ebp)
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	50                   	push   %eax
  8020a2:	6a 21                	push   $0x21
  8020a4:	e8 26 fc ff ff       	call   801ccf <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	50                   	push   %eax
  8020bd:	6a 22                	push   $0x22
  8020bf:	e8 0b fc ff ff       	call   801ccf <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	90                   	nop
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	50                   	push   %eax
  8020d9:	6a 23                	push   $0x23
  8020db:	e8 ef fb ff ff       	call   801ccf <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	90                   	nop
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ef:	8d 50 04             	lea    0x4(%eax),%edx
  8020f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	52                   	push   %edx
  8020fc:	50                   	push   %eax
  8020fd:	6a 24                	push   $0x24
  8020ff:	e8 cb fb ff ff       	call   801ccf <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
	return result;
  802107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80210a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80210d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802110:	89 01                	mov    %eax,(%ecx)
  802112:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	c9                   	leave  
  802119:	c2 04 00             	ret    $0x4

0080211c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	ff 75 10             	pushl  0x10(%ebp)
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	ff 75 08             	pushl  0x8(%ebp)
  80212c:	6a 13                	push   $0x13
  80212e:	e8 9c fb ff ff       	call   801ccf <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
	return ;
  802136:	90                   	nop
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_rcr2>:
uint32 sys_rcr2()
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 25                	push   $0x25
  802148:	e8 82 fb ff ff       	call   801ccf <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80215e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	50                   	push   %eax
  80216b:	6a 26                	push   $0x26
  80216d:	e8 5d fb ff ff       	call   801ccf <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
	return ;
  802175:	90                   	nop
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <rsttst>:
void rsttst()
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 28                	push   $0x28
  802187:	e8 43 fb ff ff       	call   801ccf <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
	return ;
  80218f:	90                   	nop
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	8b 45 14             	mov    0x14(%ebp),%eax
  80219b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80219e:	8b 55 18             	mov    0x18(%ebp),%edx
  8021a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021a5:	52                   	push   %edx
  8021a6:	50                   	push   %eax
  8021a7:	ff 75 10             	pushl  0x10(%ebp)
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	ff 75 08             	pushl  0x8(%ebp)
  8021b0:	6a 27                	push   $0x27
  8021b2:	e8 18 fb ff ff       	call   801ccf <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ba:	90                   	nop
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <chktst>:
void chktst(uint32 n)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	6a 29                	push   $0x29
  8021cd:	e8 fd fa ff ff       	call   801ccf <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d5:	90                   	nop
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <inctst>:

void inctst()
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 2a                	push   $0x2a
  8021e7:	e8 e3 fa ff ff       	call   801ccf <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ef:	90                   	nop
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <gettst>:
uint32 gettst()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 2b                	push   $0x2b
  802201:	e8 c9 fa ff ff       	call   801ccf <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 2c                	push   $0x2c
  80221d:	e8 ad fa ff ff       	call   801ccf <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
  802225:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802228:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80222c:	75 07                	jne    802235 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	eb 05                	jmp    80223a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 2c                	push   $0x2c
  80224e:	e8 7c fa ff ff       	call   801ccf <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
  802256:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802259:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80225d:	75 07                	jne    802266 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80225f:	b8 01 00 00 00       	mov    $0x1,%eax
  802264:	eb 05                	jmp    80226b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 2c                	push   $0x2c
  80227f:	e8 4b fa ff ff       	call   801ccf <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
  802287:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80228a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80228e:	75 07                	jne    802297 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802290:	b8 01 00 00 00       	mov    $0x1,%eax
  802295:	eb 05                	jmp    80229c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 2c                	push   $0x2c
  8022b0:	e8 1a fa ff ff       	call   801ccf <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022bb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022bf:	75 07                	jne    8022c8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c6:	eb 05                	jmp    8022cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	ff 75 08             	pushl  0x8(%ebp)
  8022dd:	6a 2d                	push   $0x2d
  8022df:	e8 eb f9 ff ff       	call   801ccf <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e7:	90                   	nop
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	53                   	push   %ebx
  8022fd:	51                   	push   %ecx
  8022fe:	52                   	push   %edx
  8022ff:	50                   	push   %eax
  802300:	6a 2e                	push   $0x2e
  802302:	e8 c8 f9 ff ff       	call   801ccf <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802312:	8b 55 0c             	mov    0xc(%ebp),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	52                   	push   %edx
  80231f:	50                   	push   %eax
  802320:	6a 2f                	push   $0x2f
  802322:	e8 a8 f9 ff ff       	call   801ccf <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <__udivdi3>:
  80232c:	55                   	push   %ebp
  80232d:	57                   	push   %edi
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	83 ec 1c             	sub    $0x1c,%esp
  802333:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802337:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80233b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802343:	89 ca                	mov    %ecx,%edx
  802345:	89 f8                	mov    %edi,%eax
  802347:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80234b:	85 f6                	test   %esi,%esi
  80234d:	75 2d                	jne    80237c <__udivdi3+0x50>
  80234f:	39 cf                	cmp    %ecx,%edi
  802351:	77 65                	ja     8023b8 <__udivdi3+0x8c>
  802353:	89 fd                	mov    %edi,%ebp
  802355:	85 ff                	test   %edi,%edi
  802357:	75 0b                	jne    802364 <__udivdi3+0x38>
  802359:	b8 01 00 00 00       	mov    $0x1,%eax
  80235e:	31 d2                	xor    %edx,%edx
  802360:	f7 f7                	div    %edi
  802362:	89 c5                	mov    %eax,%ebp
  802364:	31 d2                	xor    %edx,%edx
  802366:	89 c8                	mov    %ecx,%eax
  802368:	f7 f5                	div    %ebp
  80236a:	89 c1                	mov    %eax,%ecx
  80236c:	89 d8                	mov    %ebx,%eax
  80236e:	f7 f5                	div    %ebp
  802370:	89 cf                	mov    %ecx,%edi
  802372:	89 fa                	mov    %edi,%edx
  802374:	83 c4 1c             	add    $0x1c,%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5f                   	pop    %edi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    
  80237c:	39 ce                	cmp    %ecx,%esi
  80237e:	77 28                	ja     8023a8 <__udivdi3+0x7c>
  802380:	0f bd fe             	bsr    %esi,%edi
  802383:	83 f7 1f             	xor    $0x1f,%edi
  802386:	75 40                	jne    8023c8 <__udivdi3+0x9c>
  802388:	39 ce                	cmp    %ecx,%esi
  80238a:	72 0a                	jb     802396 <__udivdi3+0x6a>
  80238c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802390:	0f 87 9e 00 00 00    	ja     802434 <__udivdi3+0x108>
  802396:	b8 01 00 00 00       	mov    $0x1,%eax
  80239b:	89 fa                	mov    %edi,%edx
  80239d:	83 c4 1c             	add    $0x1c,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	31 ff                	xor    %edi,%edi
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	89 fa                	mov    %edi,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	66 90                	xchg   %ax,%ax
  8023b8:	89 d8                	mov    %ebx,%eax
  8023ba:	f7 f7                	div    %edi
  8023bc:	31 ff                	xor    %edi,%edi
  8023be:	89 fa                	mov    %edi,%edx
  8023c0:	83 c4 1c             	add    $0x1c,%esp
  8023c3:	5b                   	pop    %ebx
  8023c4:	5e                   	pop    %esi
  8023c5:	5f                   	pop    %edi
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    
  8023c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023cd:	89 eb                	mov    %ebp,%ebx
  8023cf:	29 fb                	sub    %edi,%ebx
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e6                	shl    %cl,%esi
  8023d5:	89 c5                	mov    %eax,%ebp
  8023d7:	88 d9                	mov    %bl,%cl
  8023d9:	d3 ed                	shr    %cl,%ebp
  8023db:	89 e9                	mov    %ebp,%ecx
  8023dd:	09 f1                	or     %esi,%ecx
  8023df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023e3:	89 f9                	mov    %edi,%ecx
  8023e5:	d3 e0                	shl    %cl,%eax
  8023e7:	89 c5                	mov    %eax,%ebp
  8023e9:	89 d6                	mov    %edx,%esi
  8023eb:	88 d9                	mov    %bl,%cl
  8023ed:	d3 ee                	shr    %cl,%esi
  8023ef:	89 f9                	mov    %edi,%ecx
  8023f1:	d3 e2                	shl    %cl,%edx
  8023f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023f7:	88 d9                	mov    %bl,%cl
  8023f9:	d3 e8                	shr    %cl,%eax
  8023fb:	09 c2                	or     %eax,%edx
  8023fd:	89 d0                	mov    %edx,%eax
  8023ff:	89 f2                	mov    %esi,%edx
  802401:	f7 74 24 0c          	divl   0xc(%esp)
  802405:	89 d6                	mov    %edx,%esi
  802407:	89 c3                	mov    %eax,%ebx
  802409:	f7 e5                	mul    %ebp
  80240b:	39 d6                	cmp    %edx,%esi
  80240d:	72 19                	jb     802428 <__udivdi3+0xfc>
  80240f:	74 0b                	je     80241c <__udivdi3+0xf0>
  802411:	89 d8                	mov    %ebx,%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 58 ff ff ff       	jmp    802372 <__udivdi3+0x46>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802420:	89 f9                	mov    %edi,%ecx
  802422:	d3 e2                	shl    %cl,%edx
  802424:	39 c2                	cmp    %eax,%edx
  802426:	73 e9                	jae    802411 <__udivdi3+0xe5>
  802428:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80242b:	31 ff                	xor    %edi,%edi
  80242d:	e9 40 ff ff ff       	jmp    802372 <__udivdi3+0x46>
  802432:	66 90                	xchg   %ax,%ax
  802434:	31 c0                	xor    %eax,%eax
  802436:	e9 37 ff ff ff       	jmp    802372 <__udivdi3+0x46>
  80243b:	90                   	nop

0080243c <__umoddi3>:
  80243c:	55                   	push   %ebp
  80243d:	57                   	push   %edi
  80243e:	56                   	push   %esi
  80243f:	53                   	push   %ebx
  802440:	83 ec 1c             	sub    $0x1c,%esp
  802443:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802447:	8b 74 24 34          	mov    0x34(%esp),%esi
  80244b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80244f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802453:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802457:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80245b:	89 f3                	mov    %esi,%ebx
  80245d:	89 fa                	mov    %edi,%edx
  80245f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802463:	89 34 24             	mov    %esi,(%esp)
  802466:	85 c0                	test   %eax,%eax
  802468:	75 1a                	jne    802484 <__umoddi3+0x48>
  80246a:	39 f7                	cmp    %esi,%edi
  80246c:	0f 86 a2 00 00 00    	jbe    802514 <__umoddi3+0xd8>
  802472:	89 c8                	mov    %ecx,%eax
  802474:	89 f2                	mov    %esi,%edx
  802476:	f7 f7                	div    %edi
  802478:	89 d0                	mov    %edx,%eax
  80247a:	31 d2                	xor    %edx,%edx
  80247c:	83 c4 1c             	add    $0x1c,%esp
  80247f:	5b                   	pop    %ebx
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    
  802484:	39 f0                	cmp    %esi,%eax
  802486:	0f 87 ac 00 00 00    	ja     802538 <__umoddi3+0xfc>
  80248c:	0f bd e8             	bsr    %eax,%ebp
  80248f:	83 f5 1f             	xor    $0x1f,%ebp
  802492:	0f 84 ac 00 00 00    	je     802544 <__umoddi3+0x108>
  802498:	bf 20 00 00 00       	mov    $0x20,%edi
  80249d:	29 ef                	sub    %ebp,%edi
  80249f:	89 fe                	mov    %edi,%esi
  8024a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024a5:	89 e9                	mov    %ebp,%ecx
  8024a7:	d3 e0                	shl    %cl,%eax
  8024a9:	89 d7                	mov    %edx,%edi
  8024ab:	89 f1                	mov    %esi,%ecx
  8024ad:	d3 ef                	shr    %cl,%edi
  8024af:	09 c7                	or     %eax,%edi
  8024b1:	89 e9                	mov    %ebp,%ecx
  8024b3:	d3 e2                	shl    %cl,%edx
  8024b5:	89 14 24             	mov    %edx,(%esp)
  8024b8:	89 d8                	mov    %ebx,%eax
  8024ba:	d3 e0                	shl    %cl,%eax
  8024bc:	89 c2                	mov    %eax,%edx
  8024be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024c2:	d3 e0                	shl    %cl,%eax
  8024c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024cc:	89 f1                	mov    %esi,%ecx
  8024ce:	d3 e8                	shr    %cl,%eax
  8024d0:	09 d0                	or     %edx,%eax
  8024d2:	d3 eb                	shr    %cl,%ebx
  8024d4:	89 da                	mov    %ebx,%edx
  8024d6:	f7 f7                	div    %edi
  8024d8:	89 d3                	mov    %edx,%ebx
  8024da:	f7 24 24             	mull   (%esp)
  8024dd:	89 c6                	mov    %eax,%esi
  8024df:	89 d1                	mov    %edx,%ecx
  8024e1:	39 d3                	cmp    %edx,%ebx
  8024e3:	0f 82 87 00 00 00    	jb     802570 <__umoddi3+0x134>
  8024e9:	0f 84 91 00 00 00    	je     802580 <__umoddi3+0x144>
  8024ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f3:	29 f2                	sub    %esi,%edx
  8024f5:	19 cb                	sbb    %ecx,%ebx
  8024f7:	89 d8                	mov    %ebx,%eax
  8024f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024fd:	d3 e0                	shl    %cl,%eax
  8024ff:	89 e9                	mov    %ebp,%ecx
  802501:	d3 ea                	shr    %cl,%edx
  802503:	09 d0                	or     %edx,%eax
  802505:	89 e9                	mov    %ebp,%ecx
  802507:	d3 eb                	shr    %cl,%ebx
  802509:	89 da                	mov    %ebx,%edx
  80250b:	83 c4 1c             	add    $0x1c,%esp
  80250e:	5b                   	pop    %ebx
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    
  802513:	90                   	nop
  802514:	89 fd                	mov    %edi,%ebp
  802516:	85 ff                	test   %edi,%edi
  802518:	75 0b                	jne    802525 <__umoddi3+0xe9>
  80251a:	b8 01 00 00 00       	mov    $0x1,%eax
  80251f:	31 d2                	xor    %edx,%edx
  802521:	f7 f7                	div    %edi
  802523:	89 c5                	mov    %eax,%ebp
  802525:	89 f0                	mov    %esi,%eax
  802527:	31 d2                	xor    %edx,%edx
  802529:	f7 f5                	div    %ebp
  80252b:	89 c8                	mov    %ecx,%eax
  80252d:	f7 f5                	div    %ebp
  80252f:	89 d0                	mov    %edx,%eax
  802531:	e9 44 ff ff ff       	jmp    80247a <__umoddi3+0x3e>
  802536:	66 90                	xchg   %ax,%ax
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	89 f2                	mov    %esi,%edx
  80253c:	83 c4 1c             	add    $0x1c,%esp
  80253f:	5b                   	pop    %ebx
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
  802544:	3b 04 24             	cmp    (%esp),%eax
  802547:	72 06                	jb     80254f <__umoddi3+0x113>
  802549:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80254d:	77 0f                	ja     80255e <__umoddi3+0x122>
  80254f:	89 f2                	mov    %esi,%edx
  802551:	29 f9                	sub    %edi,%ecx
  802553:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802557:	89 14 24             	mov    %edx,(%esp)
  80255a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80255e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802562:	8b 14 24             	mov    (%esp),%edx
  802565:	83 c4 1c             	add    $0x1c,%esp
  802568:	5b                   	pop    %ebx
  802569:	5e                   	pop    %esi
  80256a:	5f                   	pop    %edi
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	2b 04 24             	sub    (%esp),%eax
  802573:	19 fa                	sbb    %edi,%edx
  802575:	89 d1                	mov    %edx,%ecx
  802577:	89 c6                	mov    %eax,%esi
  802579:	e9 71 ff ff ff       	jmp    8024ef <__umoddi3+0xb3>
  80257e:	66 90                	xchg   %ax,%ax
  802580:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802584:	72 ea                	jb     802570 <__umoddi3+0x134>
  802586:	89 d9                	mov    %ebx,%ecx
  802588:	e9 62 ff ff ff       	jmp    8024ef <__umoddi3+0xb3>
