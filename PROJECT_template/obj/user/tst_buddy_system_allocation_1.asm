
obj/user/tst_buddy_system_allocation_1:     file format elf32-i386


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
  800031:	e8 c4 04 00 00       	call   8004fa <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int GetPowOf2(int size);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	int freeFrames1 = sys_calculate_free_frames() ;
  800042:	e8 f9 1c 00 00       	call   801d40 <sys_calculate_free_frames>
  800047:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages1 = sys_pf_calculate_allocated_pages() ;
  80004a:	e8 74 1d 00 00       	call   801dc3 <sys_pf_calculate_allocated_pages>
  80004f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	char line[100];
	int N = 500;
  800052:	c7 45 d8 f4 01 00 00 	movl   $0x1f4,-0x28(%ebp)
	assert(N * sizeof(int) <= BUDDY_LIMIT);
  800059:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80005c:	c1 e0 02             	shl    $0x2,%eax
  80005f:	3d 00 08 00 00       	cmp    $0x800,%eax
  800064:	76 16                	jbe    80007c <_main+0x44>
  800066:	68 a0 24 80 00       	push   $0x8024a0
  80006b:	68 bf 24 80 00       	push   $0x8024bf
  800070:	6a 0d                	push   $0xd
  800072:	68 d4 24 80 00       	push   $0x8024d4
  800077:	e8 c3 05 00 00       	call   80063f <_panic>
	int M = 1;
  80007c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	assert(M * sizeof(uint8) <= BUDDY_LIMIT);
  800083:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800086:	3d 00 08 00 00       	cmp    $0x800,%eax
  80008b:	76 16                	jbe    8000a3 <_main+0x6b>
  80008d:	68 fc 24 80 00       	push   $0x8024fc
  800092:	68 bf 24 80 00       	push   $0x8024bf
  800097:	6a 0f                	push   $0xf
  800099:	68 d4 24 80 00       	push   $0x8024d4
  80009e:	e8 9c 05 00 00       	call   80063f <_panic>

	uint8 ** arr = malloc(N * sizeof(int)) ;
  8000a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a6:	c1 e0 02             	shl    $0x2,%eax
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	50                   	push   %eax
  8000ad:	e8 b9 15 00 00       	call   80166b <malloc>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int expectedNumOfAllocatedFrames = GetPowOf2(N * sizeof(int));
  8000b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000bb:	c1 e0 02             	shl    $0x2,%eax
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	50                   	push   %eax
  8000c2:	e8 f1 03 00 00       	call   8004b8 <GetPowOf2>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

	for (int i = 0; i < N; ++i)
  8000cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000d4:	eb 7a                	jmp    800150 <_main+0x118>
	{
		arr[i] = malloc(M + i) ;
  8000d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000e3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8000e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000ec:	01 d0                	add    %edx,%eax
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	50                   	push   %eax
  8000f2:	e8 74 15 00 00       	call   80166b <malloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 03                	mov    %eax,(%ebx)
		expectedNumOfAllocatedFrames += GetPowOf2(M + i);
  8000fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800102:	01 d0                	add    %edx,%eax
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	50                   	push   %eax
  800108:	e8 ab 03 00 00       	call   8004b8 <GetPowOf2>
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	01 45 f4             	add    %eax,-0xc(%ebp)
		for (int j = 0; j < M; ++j)
  800113:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80011a:	eb 29                	jmp    800145 <_main+0x10d>
		{
			arr[i][j] = i % 255;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800126:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800129:	01 d0                	add    %edx,%eax
  80012b:	8b 10                	mov    (%eax),%edx
  80012d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800130:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800136:	bb ff 00 00 00       	mov    $0xff,%ebx
  80013b:	99                   	cltd   
  80013c:	f7 fb                	idiv   %ebx
  80013e:	89 d0                	mov    %edx,%eax
  800140:	88 01                	mov    %al,(%ecx)

	for (int i = 0; i < N; ++i)
	{
		arr[i] = malloc(M + i) ;
		expectedNumOfAllocatedFrames += GetPowOf2(M + i);
		for (int j = 0; j < M; ++j)
  800142:	ff 45 ec             	incl   -0x14(%ebp)
  800145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800148:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80014b:	7c cf                	jl     80011c <_main+0xe4>
	assert(M * sizeof(uint8) <= BUDDY_LIMIT);

	uint8 ** arr = malloc(N * sizeof(int)) ;
	int expectedNumOfAllocatedFrames = GetPowOf2(N * sizeof(int));

	for (int i = 0; i < N; ++i)
  80014d:	ff 45 f0             	incl   -0x10(%ebp)
  800150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800153:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800156:	0f 8c 7a ff ff ff    	jl     8000d6 <_main+0x9e>
		}
	}

	//[1] Check the lists content of the BuddyLevels array
	{
	int L = BUDDY_LOWER_LEVEL;
  80015c:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=0)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  800163:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800166:	c1 e0 04             	shl    $0x4,%eax
  800169:	05 4c 30 80 00       	add    $0x80304c,%eax
  80016e:	8b 00                	mov    (%eax),%eax
  800170:	85 c0                	test   %eax,%eax
  800172:	74 21                	je     800195 <_main+0x15d>
  800174:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800177:	c1 e0 04             	shl    $0x4,%eax
  80017a:	05 4c 30 80 00       	add    $0x80304c,%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	50                   	push   %eax
  800185:	ff 75 cc             	pushl  -0x34(%ebp)
  800188:	68 20 25 80 00       	push   $0x802520
  80018d:	e8 4f 07 00 00       	call   8008e1 <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=1)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  800198:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80019b:	c1 e0 04             	shl    $0x4,%eax
  80019e:	05 4c 30 80 00       	add    $0x80304c,%eax
  8001a3:	8b 00                	mov    (%eax),%eax
  8001a5:	83 f8 01             	cmp    $0x1,%eax
  8001a8:	74 21                	je     8001cb <_main+0x193>
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	c1 e0 04             	shl    $0x4,%eax
  8001b0:	05 4c 30 80 00       	add    $0x80304c,%eax
  8001b5:	8b 00                	mov    (%eax),%eax
  8001b7:	83 ec 04             	sub    $0x4,%esp
  8001ba:	50                   	push   %eax
  8001bb:	ff 75 cc             	pushl  -0x34(%ebp)
  8001be:	68 20 25 80 00       	push   $0x802520
  8001c3:	e8 19 07 00 00       	call   8008e1 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
  8001cb:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=0)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  8001ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d1:	c1 e0 04             	shl    $0x4,%eax
  8001d4:	05 4c 30 80 00       	add    $0x80304c,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	74 21                	je     800200 <_main+0x1c8>
  8001df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e2:	c1 e0 04             	shl    $0x4,%eax
  8001e5:	05 4c 30 80 00       	add    $0x80304c,%eax
  8001ea:	8b 00                	mov    (%eax),%eax
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 cc             	pushl  -0x34(%ebp)
  8001f3:	68 20 25 80 00       	push   $0x802520
  8001f8:	e8 e4 06 00 00       	call   8008e1 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=1)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  800203:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800206:	c1 e0 04             	shl    $0x4,%eax
  800209:	05 4c 30 80 00       	add    $0x80304c,%eax
  80020e:	8b 00                	mov    (%eax),%eax
  800210:	83 f8 01             	cmp    $0x1,%eax
  800213:	74 21                	je     800236 <_main+0x1fe>
  800215:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800218:	c1 e0 04             	shl    $0x4,%eax
  80021b:	05 4c 30 80 00       	add    $0x80304c,%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	50                   	push   %eax
  800226:	ff 75 cc             	pushl  -0x34(%ebp)
  800229:	68 20 25 80 00       	push   $0x802520
  80022e:	e8 ae 06 00 00       	call   8008e1 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=0)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  800239:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80023c:	c1 e0 04             	shl    $0x4,%eax
  80023f:	05 4c 30 80 00       	add    $0x80304c,%eax
  800244:	8b 00                	mov    (%eax),%eax
  800246:	85 c0                	test   %eax,%eax
  800248:	74 21                	je     80026b <_main+0x233>
  80024a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80024d:	c1 e0 04             	shl    $0x4,%eax
  800250:	05 4c 30 80 00       	add    $0x80304c,%eax
  800255:	8b 00                	mov    (%eax),%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	50                   	push   %eax
  80025b:	ff 75 cc             	pushl  -0x34(%ebp)
  80025e:	68 20 25 80 00       	push   $0x802520
  800263:	e8 79 06 00 00       	call   8008e1 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=1)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  80026e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800271:	c1 e0 04             	shl    $0x4,%eax
  800274:	05 4c 30 80 00       	add    $0x80304c,%eax
  800279:	8b 00                	mov    (%eax),%eax
  80027b:	83 f8 01             	cmp    $0x1,%eax
  80027e:	74 21                	je     8002a1 <_main+0x269>
  800280:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800283:	c1 e0 04             	shl    $0x4,%eax
  800286:	05 4c 30 80 00       	add    $0x80304c,%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	50                   	push   %eax
  800291:	ff 75 cc             	pushl  -0x34(%ebp)
  800294:	68 20 25 80 00       	push   $0x802520
  800299:	e8 43 06 00 00       	call   8008e1 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=0)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  8002a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a7:	c1 e0 04             	shl    $0x4,%eax
  8002aa:	05 4c 30 80 00       	add    $0x80304c,%eax
  8002af:	8b 00                	mov    (%eax),%eax
  8002b1:	85 c0                	test   %eax,%eax
  8002b3:	74 21                	je     8002d6 <_main+0x29e>
  8002b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002b8:	c1 e0 04             	shl    $0x4,%eax
  8002bb:	05 4c 30 80 00       	add    $0x80304c,%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	50                   	push   %eax
  8002c6:	ff 75 cc             	pushl  -0x34(%ebp)
  8002c9:	68 20 25 80 00       	push   $0x802520
  8002ce:	e8 0e 06 00 00       	call   8008e1 <cprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=1)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  8002d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002dc:	c1 e0 04             	shl    $0x4,%eax
  8002df:	05 4c 30 80 00       	add    $0x80304c,%eax
  8002e4:	8b 00                	mov    (%eax),%eax
  8002e6:	83 f8 01             	cmp    $0x1,%eax
  8002e9:	74 21                	je     80030c <_main+0x2d4>
  8002eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002ee:	c1 e0 04             	shl    $0x4,%eax
  8002f1:	05 4c 30 80 00       	add    $0x80304c,%eax
  8002f6:	8b 00                	mov    (%eax),%eax
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8002ff:	68 20 25 80 00       	push   $0x802520
  800304:	e8 d8 05 00 00       	call   8008e1 <cprintf>
  800309:	83 c4 10             	add    $0x10,%esp
  80030c:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=0)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  80030f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800312:	c1 e0 04             	shl    $0x4,%eax
  800315:	05 4c 30 80 00       	add    $0x80304c,%eax
  80031a:	8b 00                	mov    (%eax),%eax
  80031c:	85 c0                	test   %eax,%eax
  80031e:	74 21                	je     800341 <_main+0x309>
  800320:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800323:	c1 e0 04             	shl    $0x4,%eax
  800326:	05 4c 30 80 00       	add    $0x80304c,%eax
  80032b:	8b 00                	mov    (%eax),%eax
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	50                   	push   %eax
  800331:	ff 75 cc             	pushl  -0x34(%ebp)
  800334:	68 20 25 80 00       	push   $0x802520
  800339:	e8 a3 05 00 00       	call   8008e1 <cprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=1)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  800344:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800347:	c1 e0 04             	shl    $0x4,%eax
  80034a:	05 4c 30 80 00       	add    $0x80304c,%eax
  80034f:	8b 00                	mov    (%eax),%eax
  800351:	83 f8 01             	cmp    $0x1,%eax
  800354:	74 21                	je     800377 <_main+0x33f>
  800356:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800359:	c1 e0 04             	shl    $0x4,%eax
  80035c:	05 4c 30 80 00       	add    $0x80304c,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	50                   	push   %eax
  800367:	ff 75 cc             	pushl  -0x34(%ebp)
  80036a:	68 20 25 80 00       	push   $0x802520
  80036f:	e8 6d 05 00 00       	call   8008e1 <cprintf>
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	ff 45 cc             	incl   -0x34(%ebp)
	if(LIST_SIZE(&BuddyLevels[L])!=0)	{cprintf("WRONG number of nodes at Level # %d - # of nodes = %d\n", L, LIST_SIZE(&BuddyLevels[L])); } L = L + 1;
  80037a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80037d:	c1 e0 04             	shl    $0x4,%eax
  800380:	05 4c 30 80 00       	add    $0x80304c,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	74 21                	je     8003ac <_main+0x374>
  80038b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80038e:	c1 e0 04             	shl    $0x4,%eax
  800391:	05 4c 30 80 00       	add    $0x80304c,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	50                   	push   %eax
  80039c:	ff 75 cc             	pushl  -0x34(%ebp)
  80039f:	68 20 25 80 00       	push   $0x802520
  8003a4:	e8 38 05 00 00       	call   8008e1 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	ff 45 cc             	incl   -0x34(%ebp)
	}

	//[2] Check the frames taken after the allocation
	expectedNumOfAllocatedFrames = ROUNDUP(expectedNumOfAllocatedFrames, PAGE_SIZE) / PAGE_SIZE;
  8003af:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8003b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8003bc:	01 d0                	add    %edx,%eax
  8003be:	48                   	dec    %eax
  8003bf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003c2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ca:	f7 75 c8             	divl   -0x38(%ebp)
  8003cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003d0:	29 d0                	sub    %edx,%eax
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	79 05                	jns    8003db <_main+0x3a3>
  8003d6:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003db:	c1 f8 0c             	sar    $0xc,%eax
  8003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int freeFrames2 = sys_calculate_free_frames() ;
  8003e1:	e8 5a 19 00 00       	call   801d40 <sys_calculate_free_frames>
  8003e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	int usedDiskPages2 = sys_pf_calculate_allocated_pages() ;
  8003e9:	e8 d5 19 00 00       	call   801dc3 <sys_pf_calculate_allocated_pages>
  8003ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
	assert(freeFrames1 - freeFrames2 == 1 + 1 + expectedNumOfAllocatedFrames); //2 for page table + 1 for disk table
  8003f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f4:	2b 45 c0             	sub    -0x40(%ebp),%eax
  8003f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003fa:	83 c2 02             	add    $0x2,%edx
  8003fd:	39 d0                	cmp    %edx,%eax
  8003ff:	74 16                	je     800417 <_main+0x3df>
  800401:	68 58 25 80 00       	push   $0x802558
  800406:	68 bf 24 80 00       	push   $0x8024bf
  80040b:	6a 32                	push   $0x32
  80040d:	68 d4 24 80 00       	push   $0x8024d4
  800412:	e8 28 02 00 00       	call   80063f <_panic>
	assert(usedDiskPages2 - usedDiskPages1 == expectedNumOfAllocatedFrames);
  800417:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80041a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80041d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800420:	74 16                	je     800438 <_main+0x400>
  800422:	68 9c 25 80 00       	push   $0x80259c
  800427:	68 bf 24 80 00       	push   $0x8024bf
  80042c:	6a 33                	push   $0x33
  80042e:	68 d4 24 80 00       	push   $0x8024d4
  800433:	e8 07 02 00 00       	call   80063f <_panic>

	//[3] Check the created arrays content
	for (int i = 0; i < N; ++i)
  800438:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80043f:	eb 59                	jmp    80049a <_main+0x462>
	{
		for (int j = 0; j < M; ++j)
  800441:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800448:	eb 45                	jmp    80048f <_main+0x457>
		{
			assert(arr[i][j] == i % 255);
  80044a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800454:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045e:	01 d0                	add    %edx,%eax
  800460:	8a 00                	mov    (%eax),%al
  800462:	0f b6 c8             	movzbl %al,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	bb ff 00 00 00       	mov    $0xff,%ebx
  80046d:	99                   	cltd   
  80046e:	f7 fb                	idiv   %ebx
  800470:	89 d0                	mov    %edx,%eax
  800472:	39 c1                	cmp    %eax,%ecx
  800474:	74 16                	je     80048c <_main+0x454>
  800476:	68 dc 25 80 00       	push   $0x8025dc
  80047b:	68 bf 24 80 00       	push   $0x8024bf
  800480:	6a 3a                	push   $0x3a
  800482:	68 d4 24 80 00       	push   $0x8024d4
  800487:	e8 b3 01 00 00       	call   80063f <_panic>
	assert(usedDiskPages2 - usedDiskPages1 == expectedNumOfAllocatedFrames);

	//[3] Check the created arrays content
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
  80048c:	ff 45 e4             	incl   -0x1c(%ebp)
  80048f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800492:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800495:	7c b3                	jl     80044a <_main+0x412>
	int usedDiskPages2 = sys_pf_calculate_allocated_pages() ;
	assert(freeFrames1 - freeFrames2 == 1 + 1 + expectedNumOfAllocatedFrames); //2 for page table + 1 for disk table
	assert(usedDiskPages2 - usedDiskPages1 == expectedNumOfAllocatedFrames);

	//[3] Check the created arrays content
	for (int i = 0; i < N; ++i)
  800497:	ff 45 e8             	incl   -0x18(%ebp)
  80049a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004a0:	7c 9f                	jl     800441 <_main+0x409>
		{
			assert(arr[i][j] == i % 255);
		}
	}

	cprintf("Congratulations!! test BUDDY SYSTEM allocation (1) completed successfully. Evaluation = 100%\n");
  8004a2:	83 ec 0c             	sub    $0xc,%esp
  8004a5:	68 f4 25 80 00       	push   $0x8025f4
  8004aa:	e8 32 04 00 00       	call   8008e1 <cprintf>
  8004af:	83 c4 10             	add    $0x10,%esp
}
  8004b2:	90                   	nop
  8004b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <GetPowOf2>:

int GetPowOf2(int size)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 10             	sub    $0x10,%esp
	int i;
	for(i = BUDDY_LOWER_LEVEL; i <= BUDDY_UPPER_LEVEL; i++)
  8004be:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
  8004c5:	eb 26                	jmp    8004ed <GetPowOf2+0x35>
	{
		if(BUDDY_NODE_SIZE(i) >= size)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	ba 01 00 00 00       	mov    $0x1,%edx
  8004cf:	88 c1                	mov    %al,%cl
  8004d1:	d3 e2                	shl    %cl,%edx
  8004d3:	89 d0                	mov    %edx,%eax
  8004d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8004d8:	7c 10                	jl     8004ea <GetPowOf2+0x32>
			return 1<<i;
  8004da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004dd:	ba 01 00 00 00       	mov    $0x1,%edx
  8004e2:	88 c1                	mov    %al,%cl
  8004e4:	d3 e2                	shl    %cl,%edx
  8004e6:	89 d0                	mov    %edx,%eax
  8004e8:	eb 0e                	jmp    8004f8 <GetPowOf2+0x40>
}

int GetPowOf2(int size)
{
	int i;
	for(i = BUDDY_LOWER_LEVEL; i <= BUDDY_UPPER_LEVEL; i++)
  8004ea:	ff 45 fc             	incl   -0x4(%ebp)
  8004ed:	83 7d fc 0b          	cmpl   $0xb,-0x4(%ebp)
  8004f1:	7e d4                	jle    8004c7 <GetPowOf2+0xf>
	{
		if(BUDDY_NODE_SIZE(i) >= size)
			return 1<<i;
	}
	return 0;
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800500:	e8 70 17 00 00       	call   801c75 <sys_getenvindex>
  800505:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80050b:	89 d0                	mov    %edx,%eax
  80050d:	c1 e0 03             	shl    $0x3,%eax
  800510:	01 d0                	add    %edx,%eax
  800512:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800519:	01 c8                	add    %ecx,%eax
  80051b:	01 c0                	add    %eax,%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	01 c0                	add    %eax,%eax
  800521:	01 d0                	add    %edx,%eax
  800523:	89 c2                	mov    %eax,%edx
  800525:	c1 e2 05             	shl    $0x5,%edx
  800528:	29 c2                	sub    %eax,%edx
  80052a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  800531:	89 c2                	mov    %eax,%edx
  800533:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800539:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80053e:	a1 20 30 80 00       	mov    0x803020,%eax
  800543:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800549:	84 c0                	test   %al,%al
  80054b:	74 0f                	je     80055c <libmain+0x62>
		binaryname = myEnv->prog_name;
  80054d:	a1 20 30 80 00       	mov    0x803020,%eax
  800552:	05 40 3c 01 00       	add    $0x13c40,%eax
  800557:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800560:	7e 0a                	jle    80056c <libmain+0x72>
		binaryname = argv[0];
  800562:	8b 45 0c             	mov    0xc(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	e8 be fa ff ff       	call   800038 <_main>
  80057a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80057d:	e8 8e 18 00 00       	call   801e10 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	68 6c 26 80 00       	push   $0x80266c
  80058a:	e8 52 03 00 00       	call   8008e1 <cprintf>
  80058f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800592:	a1 20 30 80 00       	mov    0x803020,%eax
  800597:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  80059d:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a2:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	52                   	push   %edx
  8005ac:	50                   	push   %eax
  8005ad:	68 94 26 80 00       	push   $0x802694
  8005b2:	e8 2a 03 00 00       	call   8008e1 <cprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8005ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bf:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8005c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ca:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	52                   	push   %edx
  8005d4:	50                   	push   %eax
  8005d5:	68 bc 26 80 00       	push   $0x8026bc
  8005da:	e8 02 03 00 00       	call   8008e1 <cprintf>
  8005df:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e7:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	50                   	push   %eax
  8005f1:	68 fd 26 80 00       	push   $0x8026fd
  8005f6:	e8 e6 02 00 00       	call   8008e1 <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8005fe:	83 ec 0c             	sub    $0xc,%esp
  800601:	68 6c 26 80 00       	push   $0x80266c
  800606:	e8 d6 02 00 00       	call   8008e1 <cprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80060e:	e8 17 18 00 00       	call   801e2a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800613:	e8 19 00 00 00       	call   800631 <exit>
}
  800618:	90                   	nop
  800619:	c9                   	leave  
  80061a:	c3                   	ret    

0080061b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80061b:	55                   	push   %ebp
  80061c:	89 e5                	mov    %esp,%ebp
  80061e:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	6a 00                	push   $0x0
  800626:	e8 16 16 00 00       	call   801c41 <sys_env_destroy>
  80062b:	83 c4 10             	add    $0x10,%esp
}
  80062e:	90                   	nop
  80062f:	c9                   	leave  
  800630:	c3                   	ret    

00800631 <exit>:

void
exit(void)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800637:	e8 6b 16 00 00       	call   801ca7 <sys_env_exit>
}
  80063c:	90                   	nop
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800645:	8d 45 10             	lea    0x10(%ebp),%eax
  800648:	83 c0 04             	add    $0x4,%eax
  80064b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80064e:	a1 18 31 80 00       	mov    0x803118,%eax
  800653:	85 c0                	test   %eax,%eax
  800655:	74 16                	je     80066d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800657:	a1 18 31 80 00       	mov    0x803118,%eax
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	50                   	push   %eax
  800660:	68 14 27 80 00       	push   $0x802714
  800665:	e8 77 02 00 00       	call   8008e1 <cprintf>
  80066a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80066d:	a1 00 30 80 00       	mov    0x803000,%eax
  800672:	ff 75 0c             	pushl  0xc(%ebp)
  800675:	ff 75 08             	pushl  0x8(%ebp)
  800678:	50                   	push   %eax
  800679:	68 19 27 80 00       	push   $0x802719
  80067e:	e8 5e 02 00 00       	call   8008e1 <cprintf>
  800683:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 f4             	pushl  -0xc(%ebp)
  80068f:	50                   	push   %eax
  800690:	e8 e1 01 00 00       	call   800876 <vcprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	6a 00                	push   $0x0
  80069d:	68 35 27 80 00       	push   $0x802735
  8006a2:	e8 cf 01 00 00       	call   800876 <vcprintf>
  8006a7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006aa:	e8 82 ff ff ff       	call   800631 <exit>

	// should not return here
	while (1) ;
  8006af:	eb fe                	jmp    8006af <_panic+0x70>

008006b1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
  8006b4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8006b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bc:	8b 50 74             	mov    0x74(%eax),%edx
  8006bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c2:	39 c2                	cmp    %eax,%edx
  8006c4:	74 14                	je     8006da <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8006c6:	83 ec 04             	sub    $0x4,%esp
  8006c9:	68 38 27 80 00       	push   $0x802738
  8006ce:	6a 26                	push   $0x26
  8006d0:	68 84 27 80 00       	push   $0x802784
  8006d5:	e8 65 ff ff ff       	call   80063f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8006da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8006e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006e8:	e9 b6 00 00 00       	jmp    8007a3 <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8006ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	01 d0                	add    %edx,%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	75 08                	jne    80070a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800702:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800705:	e9 96 00 00 00       	jmp    8007a0 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  80070a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800711:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800718:	eb 5d                	jmp    800777 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80071a:	a1 20 30 80 00       	mov    0x803020,%eax
  80071f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800725:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800728:	c1 e2 04             	shl    $0x4,%edx
  80072b:	01 d0                	add    %edx,%eax
  80072d:	8a 40 04             	mov    0x4(%eax),%al
  800730:	84 c0                	test   %al,%al
  800732:	75 40                	jne    800774 <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800734:	a1 20 30 80 00       	mov    0x803020,%eax
  800739:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80073f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800742:	c1 e2 04             	shl    $0x4,%edx
  800745:	01 d0                	add    %edx,%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80074c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80074f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800754:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800759:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	01 c8                	add    %ecx,%eax
  800765:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800767:	39 c2                	cmp    %eax,%edx
  800769:	75 09                	jne    800774 <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  80076b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800772:	eb 12                	jmp    800786 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800774:	ff 45 e8             	incl   -0x18(%ebp)
  800777:	a1 20 30 80 00       	mov    0x803020,%eax
  80077c:	8b 50 74             	mov    0x74(%eax),%edx
  80077f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800782:	39 c2                	cmp    %eax,%edx
  800784:	77 94                	ja     80071a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800786:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80078a:	75 14                	jne    8007a0 <CheckWSWithoutLastIndex+0xef>
			panic(
  80078c:	83 ec 04             	sub    $0x4,%esp
  80078f:	68 90 27 80 00       	push   $0x802790
  800794:	6a 3a                	push   $0x3a
  800796:	68 84 27 80 00       	push   $0x802784
  80079b:	e8 9f fe ff ff       	call   80063f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8007a0:	ff 45 f0             	incl   -0x10(%ebp)
  8007a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007a9:	0f 8c 3e ff ff ff    	jl     8006ed <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8007af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007bd:	eb 20                	jmp    8007df <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8007bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c4:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	c1 e2 04             	shl    $0x4,%edx
  8007d0:	01 d0                	add    %edx,%eax
  8007d2:	8a 40 04             	mov    0x4(%eax),%al
  8007d5:	3c 01                	cmp    $0x1,%al
  8007d7:	75 03                	jne    8007dc <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8007d9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007dc:	ff 45 e0             	incl   -0x20(%ebp)
  8007df:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e4:	8b 50 74             	mov    0x74(%eax),%edx
  8007e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ea:	39 c2                	cmp    %eax,%edx
  8007ec:	77 d1                	ja     8007bf <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007f4:	74 14                	je     80080a <CheckWSWithoutLastIndex+0x159>
		panic(
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	68 e4 27 80 00       	push   $0x8027e4
  8007fe:	6a 44                	push   $0x44
  800800:	68 84 27 80 00       	push   $0x802784
  800805:	e8 35 fe ff ff       	call   80063f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80080a:	90                   	nop
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    

0080080d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800813:	8b 45 0c             	mov    0xc(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	8d 48 01             	lea    0x1(%eax),%ecx
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081e:	89 0a                	mov    %ecx,(%edx)
  800820:	8b 55 08             	mov    0x8(%ebp),%edx
  800823:	88 d1                	mov    %dl,%cl
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
  800828:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80082c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	3d ff 00 00 00       	cmp    $0xff,%eax
  800836:	75 2c                	jne    800864 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800838:	a0 24 30 80 00       	mov    0x803024,%al
  80083d:	0f b6 c0             	movzbl %al,%eax
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
  800843:	8b 12                	mov    (%edx),%edx
  800845:	89 d1                	mov    %edx,%ecx
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	83 c2 08             	add    $0x8,%edx
  80084d:	83 ec 04             	sub    $0x4,%esp
  800850:	50                   	push   %eax
  800851:	51                   	push   %ecx
  800852:	52                   	push   %edx
  800853:	e8 a7 13 00 00       	call   801bff <sys_cputs>
  800858:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80085b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
  800867:	8b 40 04             	mov    0x4(%eax),%eax
  80086a:	8d 50 01             	lea    0x1(%eax),%edx
  80086d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800870:	89 50 04             	mov    %edx,0x4(%eax)
}
  800873:	90                   	nop
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80087f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800886:	00 00 00 
	b.cnt = 0;
  800889:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800890:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800893:	ff 75 0c             	pushl  0xc(%ebp)
  800896:	ff 75 08             	pushl  0x8(%ebp)
  800899:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80089f:	50                   	push   %eax
  8008a0:	68 0d 08 80 00       	push   $0x80080d
  8008a5:	e8 11 02 00 00       	call   800abb <vprintfmt>
  8008aa:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8008ad:	a0 24 30 80 00       	mov    0x803024,%al
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8008bb:	83 ec 04             	sub    $0x4,%esp
  8008be:	50                   	push   %eax
  8008bf:	52                   	push   %edx
  8008c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008c6:	83 c0 08             	add    $0x8,%eax
  8008c9:	50                   	push   %eax
  8008ca:	e8 30 13 00 00       	call   801bff <sys_cputs>
  8008cf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008d2:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8008d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008e7:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8008ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	50                   	push   %eax
  8008fe:	e8 73 ff ff ff       	call   800876 <vcprintf>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800909:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800914:	e8 f7 14 00 00       	call   801e10 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800919:	8d 45 0c             	lea    0xc(%ebp),%eax
  80091c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 f4             	pushl  -0xc(%ebp)
  800928:	50                   	push   %eax
  800929:	e8 48 ff ff ff       	call   800876 <vcprintf>
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800934:	e8 f1 14 00 00       	call   801e2a <sys_enable_interrupt>
	return cnt;
  800939:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	53                   	push   %ebx
  800942:	83 ec 14             	sub    $0x14,%esp
  800945:	8b 45 10             	mov    0x10(%ebp),%eax
  800948:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800951:	8b 45 18             	mov    0x18(%ebp),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80095c:	77 55                	ja     8009b3 <printnum+0x75>
  80095e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800961:	72 05                	jb     800968 <printnum+0x2a>
  800963:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800966:	77 4b                	ja     8009b3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800968:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80096b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80096e:	8b 45 18             	mov    0x18(%ebp),%eax
  800971:	ba 00 00 00 00       	mov    $0x0,%edx
  800976:	52                   	push   %edx
  800977:	50                   	push   %eax
  800978:	ff 75 f4             	pushl  -0xc(%ebp)
  80097b:	ff 75 f0             	pushl  -0x10(%ebp)
  80097e:	e8 b1 18 00 00       	call   802234 <__udivdi3>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	ff 75 20             	pushl  0x20(%ebp)
  80098c:	53                   	push   %ebx
  80098d:	ff 75 18             	pushl  0x18(%ebp)
  800990:	52                   	push   %edx
  800991:	50                   	push   %eax
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	e8 a1 ff ff ff       	call   80093e <printnum>
  80099d:	83 c4 20             	add    $0x20,%esp
  8009a0:	eb 1a                	jmp    8009bc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	ff 75 20             	pushl  0x20(%ebp)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	ff d0                	call   *%eax
  8009b0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009b3:	ff 4d 1c             	decl   0x1c(%ebp)
  8009b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009ba:	7f e6                	jg     8009a2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009bc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ca:	53                   	push   %ebx
  8009cb:	51                   	push   %ecx
  8009cc:	52                   	push   %edx
  8009cd:	50                   	push   %eax
  8009ce:	e8 71 19 00 00       	call   802344 <__umoddi3>
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	05 54 2a 80 00       	add    $0x802a54,%eax
  8009db:	8a 00                	mov    (%eax),%al
  8009dd:	0f be c0             	movsbl %al,%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
}
  8009ef:	90                   	nop
  8009f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009fc:	7e 1c                	jle    800a1a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 00                	mov    (%eax),%eax
  800a03:	8d 50 08             	lea    0x8(%eax),%edx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	89 10                	mov    %edx,(%eax)
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	83 e8 08             	sub    $0x8,%eax
  800a13:	8b 50 04             	mov    0x4(%eax),%edx
  800a16:	8b 00                	mov    (%eax),%eax
  800a18:	eb 40                	jmp    800a5a <getuint+0x65>
	else if (lflag)
  800a1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1e:	74 1e                	je     800a3e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	8d 50 04             	lea    0x4(%eax),%edx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 10                	mov    %edx,(%eax)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	83 e8 04             	sub    $0x4,%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3c:	eb 1c                	jmp    800a5a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 00                	mov    (%eax),%eax
  800a43:	8d 50 04             	lea    0x4(%eax),%edx
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	89 10                	mov    %edx,(%eax)
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	83 e8 04             	sub    $0x4,%eax
  800a53:	8b 00                	mov    (%eax),%eax
  800a55:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a63:	7e 1c                	jle    800a81 <getint+0x25>
		return va_arg(*ap, long long);
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	8d 50 08             	lea    0x8(%eax),%edx
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	89 10                	mov    %edx,(%eax)
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 00                	mov    (%eax),%eax
  800a77:	83 e8 08             	sub    $0x8,%eax
  800a7a:	8b 50 04             	mov    0x4(%eax),%edx
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	eb 38                	jmp    800ab9 <getint+0x5d>
	else if (lflag)
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	74 1a                	je     800aa1 <getint+0x45>
		return va_arg(*ap, long);
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	8d 50 04             	lea    0x4(%eax),%edx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	89 10                	mov    %edx,(%eax)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	99                   	cltd   
  800a9f:	eb 18                	jmp    800ab9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 00                	mov    (%eax),%eax
  800aa6:	8d 50 04             	lea    0x4(%eax),%edx
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	89 10                	mov    %edx,(%eax)
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8b 00                	mov    (%eax),%eax
  800ab3:	83 e8 04             	sub    $0x4,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	99                   	cltd   
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
  800ac0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ac3:	eb 17                	jmp    800adc <vprintfmt+0x21>
			if (ch == '\0')
  800ac5:	85 db                	test   %ebx,%ebx
  800ac7:	0f 84 af 03 00 00    	je     800e7c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	53                   	push   %ebx
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
  800ad9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	8d 50 01             	lea    0x1(%eax),%edx
  800ae2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	0f b6 d8             	movzbl %al,%ebx
  800aea:	83 fb 25             	cmp    $0x25,%ebx
  800aed:	75 d6                	jne    800ac5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800aef:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800af3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800afa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b01:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b08:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b12:	8d 50 01             	lea    0x1(%eax),%edx
  800b15:	89 55 10             	mov    %edx,0x10(%ebp)
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	0f b6 d8             	movzbl %al,%ebx
  800b1d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b20:	83 f8 55             	cmp    $0x55,%eax
  800b23:	0f 87 2b 03 00 00    	ja     800e54 <vprintfmt+0x399>
  800b29:	8b 04 85 78 2a 80 00 	mov    0x802a78(,%eax,4),%eax
  800b30:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b32:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b36:	eb d7                	jmp    800b0f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b38:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b3c:	eb d1                	jmp    800b0f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b48:	89 d0                	mov    %edx,%eax
  800b4a:	c1 e0 02             	shl    $0x2,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	01 d8                	add    %ebx,%eax
  800b53:	83 e8 30             	sub    $0x30,%eax
  800b56:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b59:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b61:	83 fb 2f             	cmp    $0x2f,%ebx
  800b64:	7e 3e                	jle    800ba4 <vprintfmt+0xe9>
  800b66:	83 fb 39             	cmp    $0x39,%ebx
  800b69:	7f 39                	jg     800ba4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b6b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b6e:	eb d5                	jmp    800b45 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b84:	eb 1f                	jmp    800ba5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8a:	79 83                	jns    800b0f <vprintfmt+0x54>
				width = 0;
  800b8c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b93:	e9 77 ff ff ff       	jmp    800b0f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b98:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b9f:	e9 6b ff ff ff       	jmp    800b0f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ba4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ba5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba9:	0f 89 60 ff ff ff    	jns    800b0f <vprintfmt+0x54>
				width = precision, precision = -1;
  800baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bb5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bbc:	e9 4e ff ff ff       	jmp    800b0f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bc1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bc4:	e9 46 ff ff ff       	jmp    800b0f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	50                   	push   %eax
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	ff d0                	call   *%eax
  800be6:	83 c4 10             	add    $0x10,%esp
			break;
  800be9:	e9 89 02 00 00       	jmp    800e77 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bee:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf1:	83 c0 04             	add    $0x4,%eax
  800bf4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfa:	83 e8 04             	sub    $0x4,%eax
  800bfd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800bff:	85 db                	test   %ebx,%ebx
  800c01:	79 02                	jns    800c05 <vprintfmt+0x14a>
				err = -err;
  800c03:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c05:	83 fb 64             	cmp    $0x64,%ebx
  800c08:	7f 0b                	jg     800c15 <vprintfmt+0x15a>
  800c0a:	8b 34 9d c0 28 80 00 	mov    0x8028c0(,%ebx,4),%esi
  800c11:	85 f6                	test   %esi,%esi
  800c13:	75 19                	jne    800c2e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c15:	53                   	push   %ebx
  800c16:	68 65 2a 80 00       	push   $0x802a65
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	ff 75 08             	pushl  0x8(%ebp)
  800c21:	e8 5e 02 00 00       	call   800e84 <printfmt>
  800c26:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c29:	e9 49 02 00 00       	jmp    800e77 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c2e:	56                   	push   %esi
  800c2f:	68 6e 2a 80 00       	push   $0x802a6e
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	ff 75 08             	pushl  0x8(%ebp)
  800c3a:	e8 45 02 00 00       	call   800e84 <printfmt>
  800c3f:	83 c4 10             	add    $0x10,%esp
			break;
  800c42:	e9 30 02 00 00       	jmp    800e77 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 30                	mov    (%eax),%esi
  800c58:	85 f6                	test   %esi,%esi
  800c5a:	75 05                	jne    800c61 <vprintfmt+0x1a6>
				p = "(null)";
  800c5c:	be 71 2a 80 00       	mov    $0x802a71,%esi
			if (width > 0 && padc != '-')
  800c61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c65:	7e 6d                	jle    800cd4 <vprintfmt+0x219>
  800c67:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c6b:	74 67                	je     800cd4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	50                   	push   %eax
  800c74:	56                   	push   %esi
  800c75:	e8 0c 03 00 00       	call   800f86 <strnlen>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c80:	eb 16                	jmp    800c98 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c82:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	50                   	push   %eax
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	ff d0                	call   *%eax
  800c92:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c95:	ff 4d e4             	decl   -0x1c(%ebp)
  800c98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9c:	7f e4                	jg     800c82 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c9e:	eb 34                	jmp    800cd4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ca0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ca4:	74 1c                	je     800cc2 <vprintfmt+0x207>
  800ca6:	83 fb 1f             	cmp    $0x1f,%ebx
  800ca9:	7e 05                	jle    800cb0 <vprintfmt+0x1f5>
  800cab:	83 fb 7e             	cmp    $0x7e,%ebx
  800cae:	7e 12                	jle    800cc2 <vprintfmt+0x207>
					putch('?', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 3f                	push   $0x3f
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
  800cc0:	eb 0f                	jmp    800cd1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cc2:	83 ec 08             	sub    $0x8,%esp
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	53                   	push   %ebx
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd1:	ff 4d e4             	decl   -0x1c(%ebp)
  800cd4:	89 f0                	mov    %esi,%eax
  800cd6:	8d 70 01             	lea    0x1(%eax),%esi
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	0f be d8             	movsbl %al,%ebx
  800cde:	85 db                	test   %ebx,%ebx
  800ce0:	74 24                	je     800d06 <vprintfmt+0x24b>
  800ce2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ce6:	78 b8                	js     800ca0 <vprintfmt+0x1e5>
  800ce8:	ff 4d e0             	decl   -0x20(%ebp)
  800ceb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cef:	79 af                	jns    800ca0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf1:	eb 13                	jmp    800d06 <vprintfmt+0x24b>
				putch(' ', putdat);
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	6a 20                	push   $0x20
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	ff d0                	call   *%eax
  800d00:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d03:	ff 4d e4             	decl   -0x1c(%ebp)
  800d06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0a:	7f e7                	jg     800cf3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d0c:	e9 66 01 00 00       	jmp    800e77 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 e8             	pushl  -0x18(%ebp)
  800d17:	8d 45 14             	lea    0x14(%ebp),%eax
  800d1a:	50                   	push   %eax
  800d1b:	e8 3c fd ff ff       	call   800a5c <getint>
  800d20:	83 c4 10             	add    $0x10,%esp
  800d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2f:	85 d2                	test   %edx,%edx
  800d31:	79 23                	jns    800d56 <vprintfmt+0x29b>
				putch('-', putdat);
  800d33:	83 ec 08             	sub    $0x8,%esp
  800d36:	ff 75 0c             	pushl  0xc(%ebp)
  800d39:	6a 2d                	push   $0x2d
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	ff d0                	call   *%eax
  800d40:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d49:	f7 d8                	neg    %eax
  800d4b:	83 d2 00             	adc    $0x0,%edx
  800d4e:	f7 da                	neg    %edx
  800d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d5d:	e9 bc 00 00 00       	jmp    800e1e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 e8             	pushl  -0x18(%ebp)
  800d68:	8d 45 14             	lea    0x14(%ebp),%eax
  800d6b:	50                   	push   %eax
  800d6c:	e8 84 fc ff ff       	call   8009f5 <getuint>
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d81:	e9 98 00 00 00       	jmp    800e1e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 58                	push   $0x58
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d96:	83 ec 08             	sub    $0x8,%esp
  800d99:	ff 75 0c             	pushl  0xc(%ebp)
  800d9c:	6a 58                	push   $0x58
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	ff d0                	call   *%eax
  800da3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800da6:	83 ec 08             	sub    $0x8,%esp
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	6a 58                	push   $0x58
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	ff d0                	call   *%eax
  800db3:	83 c4 10             	add    $0x10,%esp
			break;
  800db6:	e9 bc 00 00 00       	jmp    800e77 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	6a 30                	push   $0x30
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dcb:	83 ec 08             	sub    $0x8,%esp
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	6a 78                	push   $0x78
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	ff d0                	call   *%eax
  800dd8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ddb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dde:	83 c0 04             	add    $0x4,%eax
  800de1:	89 45 14             	mov    %eax,0x14(%ebp)
  800de4:	8b 45 14             	mov    0x14(%ebp),%eax
  800de7:	83 e8 04             	sub    $0x4,%eax
  800dea:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800def:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800df6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800dfd:	eb 1f                	jmp    800e1e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 e8             	pushl  -0x18(%ebp)
  800e05:	8d 45 14             	lea    0x14(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 e7 fb ff ff       	call   8009f5 <getuint>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e17:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e1e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e25:	83 ec 04             	sub    $0x4,%esp
  800e28:	52                   	push   %edx
  800e29:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e30:	ff 75 f0             	pushl  -0x10(%ebp)
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	ff 75 08             	pushl  0x8(%ebp)
  800e39:	e8 00 fb ff ff       	call   80093e <printnum>
  800e3e:	83 c4 20             	add    $0x20,%esp
			break;
  800e41:	eb 34                	jmp    800e77 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e43:	83 ec 08             	sub    $0x8,%esp
  800e46:	ff 75 0c             	pushl  0xc(%ebp)
  800e49:	53                   	push   %ebx
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	ff d0                	call   *%eax
  800e4f:	83 c4 10             	add    $0x10,%esp
			break;
  800e52:	eb 23                	jmp    800e77 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e54:	83 ec 08             	sub    $0x8,%esp
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	6a 25                	push   $0x25
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	ff d0                	call   *%eax
  800e61:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e64:	ff 4d 10             	decl   0x10(%ebp)
  800e67:	eb 03                	jmp    800e6c <vprintfmt+0x3b1>
  800e69:	ff 4d 10             	decl   0x10(%ebp)
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	48                   	dec    %eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	3c 25                	cmp    $0x25,%al
  800e74:	75 f3                	jne    800e69 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e76:	90                   	nop
		}
	}
  800e77:	e9 47 fc ff ff       	jmp    800ac3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e7c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e8d:	83 c0 04             	add    $0x4,%eax
  800e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	ff 75 f4             	pushl  -0xc(%ebp)
  800e99:	50                   	push   %eax
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	ff 75 08             	pushl  0x8(%ebp)
  800ea0:	e8 16 fc ff ff       	call   800abb <vprintfmt>
  800ea5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ea8:	90                   	nop
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8b 40 08             	mov    0x8(%eax),%eax
  800eb4:	8d 50 01             	lea    0x1(%eax),%edx
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	8b 10                	mov    (%eax),%edx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	8b 40 04             	mov    0x4(%eax),%eax
  800ec8:	39 c2                	cmp    %eax,%edx
  800eca:	73 12                	jae    800ede <sprintputch+0x33>
		*b->buf++ = ch;
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	8d 48 01             	lea    0x1(%eax),%ecx
  800ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed7:	89 0a                	mov    %ecx,(%edx)
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	88 10                	mov    %dl,(%eax)
}
  800ede:	90                   	nop
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	01 d0                	add    %edx,%eax
  800ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f06:	74 06                	je     800f0e <vsnprintf+0x2d>
  800f08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0c:	7f 07                	jg     800f15 <vsnprintf+0x34>
		return -E_INVAL;
  800f0e:	b8 03 00 00 00       	mov    $0x3,%eax
  800f13:	eb 20                	jmp    800f35 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f15:	ff 75 14             	pushl  0x14(%ebp)
  800f18:	ff 75 10             	pushl  0x10(%ebp)
  800f1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f1e:	50                   	push   %eax
  800f1f:	68 ab 0e 80 00       	push   $0x800eab
  800f24:	e8 92 fb ff ff       	call   800abb <vprintfmt>
  800f29:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f2f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f3d:	8d 45 10             	lea    0x10(%ebp),%eax
  800f40:	83 c0 04             	add    $0x4,%eax
  800f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f46:	8b 45 10             	mov    0x10(%ebp),%eax
  800f49:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4c:	50                   	push   %eax
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	ff 75 08             	pushl  0x8(%ebp)
  800f53:	e8 89 ff ff ff       	call   800ee1 <vsnprintf>
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f70:	eb 06                	jmp    800f78 <strlen+0x15>
		n++;
  800f72:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f75:	ff 45 08             	incl   0x8(%ebp)
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	84 c0                	test   %al,%al
  800f7f:	75 f1                	jne    800f72 <strlen+0xf>
		n++;
	return n;
  800f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f93:	eb 09                	jmp    800f9e <strnlen+0x18>
		n++;
  800f95:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	ff 4d 0c             	decl   0xc(%ebp)
  800f9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa2:	74 09                	je     800fad <strnlen+0x27>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	84 c0                	test   %al,%al
  800fab:	75 e8                	jne    800f95 <strnlen+0xf>
		n++;
	return n;
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

00800fb2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fbe:	90                   	nop
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fd1:	8a 12                	mov    (%edx),%dl
  800fd3:	88 10                	mov    %dl,(%eax)
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	84 c0                	test   %al,%al
  800fd9:	75 e4                	jne    800fbf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff3:	eb 1f                	jmp    801014 <strncpy+0x34>
		*dst++ = *src;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8d 50 01             	lea    0x1(%eax),%edx
  800ffb:	89 55 08             	mov    %edx,0x8(%ebp)
  800ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801001:	8a 12                	mov    (%edx),%dl
  801003:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	74 03                	je     801011 <strncpy+0x31>
			src++;
  80100e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801011:	ff 45 fc             	incl   -0x4(%ebp)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101a:	72 d9                	jb     800ff5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80102d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801031:	74 30                	je     801063 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801033:	eb 16                	jmp    80104b <strlcpy+0x2a>
			*dst++ = *src++;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8d 50 01             	lea    0x1(%eax),%edx
  80103b:	89 55 08             	mov    %edx,0x8(%ebp)
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801041:	8d 4a 01             	lea    0x1(%edx),%ecx
  801044:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801047:	8a 12                	mov    (%edx),%dl
  801049:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80104b:	ff 4d 10             	decl   0x10(%ebp)
  80104e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801052:	74 09                	je     80105d <strlcpy+0x3c>
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	84 c0                	test   %al,%al
  80105b:	75 d8                	jne    801035 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801069:	29 c2                	sub    %eax,%edx
  80106b:	89 d0                	mov    %edx,%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801072:	eb 06                	jmp    80107a <strcmp+0xb>
		p++, q++;
  801074:	ff 45 08             	incl   0x8(%ebp)
  801077:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	84 c0                	test   %al,%al
  801081:	74 0e                	je     801091 <strcmp+0x22>
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 10                	mov    (%eax),%dl
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	38 c2                	cmp    %al,%dl
  80108f:	74 e3                	je     801074 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f b6 d0             	movzbl %al,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 c0             	movzbl %al,%eax
  8010a1:	29 c2                	sub    %eax,%edx
  8010a3:	89 d0                	mov    %edx,%eax
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010aa:	eb 09                	jmp    8010b5 <strncmp+0xe>
		n--, p++, q++;
  8010ac:	ff 4d 10             	decl   0x10(%ebp)
  8010af:	ff 45 08             	incl   0x8(%ebp)
  8010b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b9:	74 17                	je     8010d2 <strncmp+0x2b>
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	84 c0                	test   %al,%al
  8010c2:	74 0e                	je     8010d2 <strncmp+0x2b>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 10                	mov    (%eax),%dl
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	38 c2                	cmp    %al,%dl
  8010d0:	74 da                	je     8010ac <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d6:	75 07                	jne    8010df <strncmp+0x38>
		return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dd:	eb 14                	jmp    8010f3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f b6 d0             	movzbl %al,%edx
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	0f b6 c0             	movzbl %al,%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801101:	eb 12                	jmp    801115 <strchr+0x20>
		if (*s == c)
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80110b:	75 05                	jne    801112 <strchr+0x1d>
			return (char *) s;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	eb 11                	jmp    801123 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801112:	ff 45 08             	incl   0x8(%ebp)
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	84 c0                	test   %al,%al
  80111c:	75 e5                	jne    801103 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80111e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 04             	sub    $0x4,%esp
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801131:	eb 0d                	jmp    801140 <strfind+0x1b>
		if (*s == c)
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80113b:	74 0e                	je     80114b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80113d:	ff 45 08             	incl   0x8(%ebp)
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 ea                	jne    801133 <strfind+0xe>
  801149:	eb 01                	jmp    80114c <strfind+0x27>
		if (*s == c)
			break;
  80114b:	90                   	nop
	return (char *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801163:	eb 0e                	jmp    801173 <memset+0x22>
		*p++ = c;
  801165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801168:	8d 50 01             	lea    0x1(%eax),%edx
  80116b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80116e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801171:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801173:	ff 4d f8             	decl   -0x8(%ebp)
  801176:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80117a:	79 e9                	jns    801165 <memset+0x14>
		*p++ = c;

	return v;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117f:	c9                   	leave  
  801180:	c3                   	ret    

00801181 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801193:	eb 16                	jmp    8011ab <memcpy+0x2a>
		*d++ = *s++;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a7:	8a 12                	mov    (%edx),%dl
  8011a9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8011ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	75 dd                	jne    801195 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011d5:	73 50                	jae    801227 <memmove+0x6a>
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 d0                	add    %edx,%eax
  8011df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011e2:	76 43                	jbe    801227 <memmove+0x6a>
		s += n;
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ed:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011f0:	eb 10                	jmp    801202 <memmove+0x45>
			*--d = *--s;
  8011f2:	ff 4d f8             	decl   -0x8(%ebp)
  8011f5:	ff 4d fc             	decl   -0x4(%ebp)
  8011f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011fb:	8a 10                	mov    (%eax),%dl
  8011fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801200:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801202:	8b 45 10             	mov    0x10(%ebp),%eax
  801205:	8d 50 ff             	lea    -0x1(%eax),%edx
  801208:	89 55 10             	mov    %edx,0x10(%ebp)
  80120b:	85 c0                	test   %eax,%eax
  80120d:	75 e3                	jne    8011f2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80120f:	eb 23                	jmp    801234 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801220:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801223:	8a 12                	mov    (%edx),%dl
  801225:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122d:	89 55 10             	mov    %edx,0x10(%ebp)
  801230:	85 c0                	test   %eax,%eax
  801232:	75 dd                	jne    801211 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80124b:	eb 2a                	jmp    801277 <memcmp+0x3e>
		if (*s1 != *s2)
  80124d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801250:	8a 10                	mov    (%eax),%dl
  801252:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	38 c2                	cmp    %al,%dl
  801259:	74 16                	je     801271 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	0f b6 d0             	movzbl %al,%edx
  801263:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	0f b6 c0             	movzbl %al,%eax
  80126b:	29 c2                	sub    %eax,%edx
  80126d:	89 d0                	mov    %edx,%eax
  80126f:	eb 18                	jmp    801289 <memcmp+0x50>
		s1++, s2++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
  801274:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80127d:	89 55 10             	mov    %edx,0x10(%ebp)
  801280:	85 c0                	test   %eax,%eax
  801282:	75 c9                	jne    80124d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801284:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801291:	8b 55 08             	mov    0x8(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80129c:	eb 15                	jmp    8012b3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	0f b6 d0             	movzbl %al,%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	0f b6 c0             	movzbl %al,%eax
  8012ac:	39 c2                	cmp    %eax,%edx
  8012ae:	74 0d                	je     8012bd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012b0:	ff 45 08             	incl   0x8(%ebp)
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012b9:	72 e3                	jb     80129e <memfind+0x13>
  8012bb:	eb 01                	jmp    8012be <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012bd:	90                   	nop
	return (void *) s;
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012d7:	eb 03                	jmp    8012dc <strtol+0x19>
		s++;
  8012d9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	3c 20                	cmp    $0x20,%al
  8012e3:	74 f4                	je     8012d9 <strtol+0x16>
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 09                	cmp    $0x9,%al
  8012ec:	74 eb                	je     8012d9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 2b                	cmp    $0x2b,%al
  8012f5:	75 05                	jne    8012fc <strtol+0x39>
		s++;
  8012f7:	ff 45 08             	incl   0x8(%ebp)
  8012fa:	eb 13                	jmp    80130f <strtol+0x4c>
	else if (*s == '-')
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3c 2d                	cmp    $0x2d,%al
  801303:	75 0a                	jne    80130f <strtol+0x4c>
		s++, neg = 1;
  801305:	ff 45 08             	incl   0x8(%ebp)
  801308:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80130f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801313:	74 06                	je     80131b <strtol+0x58>
  801315:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801319:	75 20                	jne    80133b <strtol+0x78>
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	3c 30                	cmp    $0x30,%al
  801322:	75 17                	jne    80133b <strtol+0x78>
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	40                   	inc    %eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	3c 78                	cmp    $0x78,%al
  80132c:	75 0d                	jne    80133b <strtol+0x78>
		s += 2, base = 16;
  80132e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801332:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801339:	eb 28                	jmp    801363 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80133b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133f:	75 15                	jne    801356 <strtol+0x93>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	3c 30                	cmp    $0x30,%al
  801348:	75 0c                	jne    801356 <strtol+0x93>
		s++, base = 8;
  80134a:	ff 45 08             	incl   0x8(%ebp)
  80134d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801354:	eb 0d                	jmp    801363 <strtol+0xa0>
	else if (base == 0)
  801356:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135a:	75 07                	jne    801363 <strtol+0xa0>
		base = 10;
  80135c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	3c 2f                	cmp    $0x2f,%al
  80136a:	7e 19                	jle    801385 <strtol+0xc2>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	3c 39                	cmp    $0x39,%al
  801373:	7f 10                	jg     801385 <strtol+0xc2>
			dig = *s - '0';
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	0f be c0             	movsbl %al,%eax
  80137d:	83 e8 30             	sub    $0x30,%eax
  801380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801383:	eb 42                	jmp    8013c7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	3c 60                	cmp    $0x60,%al
  80138c:	7e 19                	jle    8013a7 <strtol+0xe4>
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	3c 7a                	cmp    $0x7a,%al
  801395:	7f 10                	jg     8013a7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f be c0             	movsbl %al,%eax
  80139f:	83 e8 57             	sub    $0x57,%eax
  8013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013a5:	eb 20                	jmp    8013c7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	3c 40                	cmp    $0x40,%al
  8013ae:	7e 39                	jle    8013e9 <strtol+0x126>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 5a                	cmp    $0x5a,%al
  8013b7:	7f 30                	jg     8013e9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	0f be c0             	movsbl %al,%eax
  8013c1:	83 e8 37             	sub    $0x37,%eax
  8013c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ca:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013cd:	7d 19                	jge    8013e8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013cf:	ff 45 08             	incl   0x8(%ebp)
  8013d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013de:	01 d0                	add    %edx,%eax
  8013e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013e3:	e9 7b ff ff ff       	jmp    801363 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013e8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ed:	74 08                	je     8013f7 <strtol+0x134>
		*endptr = (char *) s;
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013fb:	74 07                	je     801404 <strtol+0x141>
  8013fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801400:	f7 d8                	neg    %eax
  801402:	eb 03                	jmp    801407 <strtol+0x144>
  801404:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <ltostr>:

void
ltostr(long value, char *str)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80140f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801416:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80141d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801421:	79 13                	jns    801436 <ltostr+0x2d>
	{
		neg = 1;
  801423:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801430:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801433:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80143e:	99                   	cltd   
  80143f:	f7 f9                	idiv   %ecx
  801441:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80144d:	89 c2                	mov    %eax,%edx
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801457:	83 c2 30             	add    $0x30,%edx
  80145a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80145c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80145f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801464:	f7 e9                	imul   %ecx
  801466:	c1 fa 02             	sar    $0x2,%edx
  801469:	89 c8                	mov    %ecx,%eax
  80146b:	c1 f8 1f             	sar    $0x1f,%eax
  80146e:	29 c2                	sub    %eax,%edx
  801470:	89 d0                	mov    %edx,%eax
  801472:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801475:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801478:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80147d:	f7 e9                	imul   %ecx
  80147f:	c1 fa 02             	sar    $0x2,%edx
  801482:	89 c8                	mov    %ecx,%eax
  801484:	c1 f8 1f             	sar    $0x1f,%eax
  801487:	29 c2                	sub    %eax,%edx
  801489:	89 d0                	mov    %edx,%eax
  80148b:	c1 e0 02             	shl    $0x2,%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	01 c0                	add    %eax,%eax
  801492:	29 c1                	sub    %eax,%ecx
  801494:	89 ca                	mov    %ecx,%edx
  801496:	85 d2                	test   %edx,%edx
  801498:	75 9c                	jne    801436 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80149a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a4:	48                   	dec    %eax
  8014a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ac:	74 3d                	je     8014eb <ltostr+0xe2>
		start = 1 ;
  8014ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014b5:	eb 34                	jmp    8014eb <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8014b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	01 d0                	add    %edx,%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ca:	01 c2                	add    %eax,%edx
  8014cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d2:	01 c8                	add    %ecx,%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	01 c2                	add    %eax,%edx
  8014e0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014e3:	88 02                	mov    %al,(%edx)
		start++ ;
  8014e5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014e8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f1:	7c c4                	jl     8014b7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	01 d0                	add    %edx,%eax
  8014fb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014fe:	90                   	nop
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801507:	ff 75 08             	pushl  0x8(%ebp)
  80150a:	e8 54 fa ff ff       	call   800f63 <strlen>
  80150f:	83 c4 04             	add    $0x4,%esp
  801512:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	e8 46 fa ff ff       	call   800f63 <strlen>
  80151d:	83 c4 04             	add    $0x4,%esp
  801520:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801523:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80152a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801531:	eb 17                	jmp    80154a <strcconcat+0x49>
		final[s] = str1[s] ;
  801533:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801536:	8b 45 10             	mov    0x10(%ebp),%eax
  801539:	01 c2                	add    %eax,%edx
  80153b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	01 c8                	add    %ecx,%eax
  801543:	8a 00                	mov    (%eax),%al
  801545:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801547:	ff 45 fc             	incl   -0x4(%ebp)
  80154a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801550:	7c e1                	jl     801533 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801552:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801559:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801560:	eb 1f                	jmp    801581 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8d 50 01             	lea    0x1(%eax),%edx
  801568:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80156b:	89 c2                	mov    %eax,%edx
  80156d:	8b 45 10             	mov    0x10(%ebp),%eax
  801570:	01 c2                	add    %eax,%edx
  801572:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	01 c8                	add    %ecx,%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80157e:	ff 45 f8             	incl   -0x8(%ebp)
  801581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801584:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801587:	7c d9                	jl     801562 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801589:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158c:	8b 45 10             	mov    0x10(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	c6 00 00             	movb   $0x0,(%eax)
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80159a:	8b 45 14             	mov    0x14(%ebp),%eax
  80159d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a6:	8b 00                	mov    (%eax),%eax
  8015a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	01 d0                	add    %edx,%eax
  8015b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015ba:	eb 0c                	jmp    8015c8 <strsplit+0x31>
			*string++ = 0;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8d 50 01             	lea    0x1(%eax),%edx
  8015c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8015c5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	74 18                	je     8015e9 <strsplit+0x52>
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	0f be c0             	movsbl %al,%eax
  8015d9:	50                   	push   %eax
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	e8 13 fb ff ff       	call   8010f5 <strchr>
  8015e2:	83 c4 08             	add    $0x8,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	75 d3                	jne    8015bc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	74 5a                	je     80164c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	83 f8 0f             	cmp    $0xf,%eax
  8015fa:	75 07                	jne    801603 <strsplit+0x6c>
		{
			return 0;
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801601:	eb 66                	jmp    801669 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801603:	8b 45 14             	mov    0x14(%ebp),%eax
  801606:	8b 00                	mov    (%eax),%eax
  801608:	8d 48 01             	lea    0x1(%eax),%ecx
  80160b:	8b 55 14             	mov    0x14(%ebp),%edx
  80160e:	89 0a                	mov    %ecx,(%edx)
  801610:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	01 c2                	add    %eax,%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801621:	eb 03                	jmp    801626 <strsplit+0x8f>
			string++;
  801623:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	84 c0                	test   %al,%al
  80162d:	74 8b                	je     8015ba <strsplit+0x23>
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	0f be c0             	movsbl %al,%eax
  801637:	50                   	push   %eax
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	e8 b5 fa ff ff       	call   8010f5 <strchr>
  801640:	83 c4 08             	add    $0x8,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	74 dc                	je     801623 <strsplit+0x8c>
			string++;
	}
  801647:	e9 6e ff ff ff       	jmp    8015ba <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80164c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80164d:	8b 45 14             	mov    0x14(%ebp),%eax
  801650:	8b 00                	mov    (%eax),%eax
  801652:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	01 d0                	add    %edx,%eax
  80165e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801664:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  801671:	a1 28 30 80 00       	mov    0x803028,%eax
  801676:	85 c0                	test   %eax,%eax
  801678:	75 33                	jne    8016ad <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  80167a:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  801681:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  801684:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  80168b:	00 00 a0 
		spaces[0].pages = numPages;
  80168e:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  801695:	00 02 00 
		spaces[0].isFree = 1;
  801698:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  80169f:	00 00 00 
		arraySize++;
  8016a2:	a1 28 30 80 00       	mov    0x803028,%eax
  8016a7:	40                   	inc    %eax
  8016a8:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  8016ad:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  8016b4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  8016bb:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8016c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c8:	01 d0                	add    %edx,%eax
  8016ca:	48                   	dec    %eax
  8016cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d6:	f7 75 e8             	divl   -0x18(%ebp)
  8016d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016dc:	29 d0                	sub    %edx,%eax
  8016de:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	c1 e8 0c             	shr    $0xc,%eax
  8016e7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  8016ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8016f1:	eb 57                	jmp    80174a <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  8016f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f6:	c1 e0 04             	shl    $0x4,%eax
  8016f9:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016fe:	8b 00                	mov    (%eax),%eax
  801700:	85 c0                	test   %eax,%eax
  801702:	74 42                	je     801746 <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  801704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801707:	c1 e0 04             	shl    $0x4,%eax
  80170a:	05 28 31 80 00       	add    $0x803128,%eax
  80170f:	8b 00                	mov    (%eax),%eax
  801711:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801714:	7c 31                	jl     801747 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  801716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801719:	c1 e0 04             	shl    $0x4,%eax
  80171c:	05 28 31 80 00       	add    $0x803128,%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	2b 45 e0             	sub    -0x20(%ebp),%eax
  801726:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801729:	7d 1c                	jge    801747 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  80172b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172e:	c1 e0 04             	shl    $0x4,%eax
  801731:	05 28 31 80 00       	add    $0x803128,%eax
  801736:	8b 00                	mov    (%eax),%eax
  801738:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80173b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  80173e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801741:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801744:	eb 01                	jmp    801747 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801746:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  801747:	ff 45 ec             	incl   -0x14(%ebp)
  80174a:	a1 28 30 80 00       	mov    0x803028,%eax
  80174f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801752:	7c 9f                	jl     8016f3 <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  801754:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801758:	75 0a                	jne    801764 <malloc+0xf9>
	{
		return NULL;
  80175a:	b8 00 00 00 00       	mov    $0x0,%eax
  80175f:	e9 34 01 00 00       	jmp    801898 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  801764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801767:	c1 e0 04             	shl    $0x4,%eax
  80176a:	05 28 31 80 00       	add    $0x803128,%eax
  80176f:	8b 00                	mov    (%eax),%eax
  801771:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801774:	75 38                	jne    8017ae <malloc+0x143>
		{
			spaces[index].isFree = 0;
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801779:	c1 e0 04             	shl    $0x4,%eax
  80177c:	05 2c 31 80 00       	add    $0x80312c,%eax
  801781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178a:	c1 e0 0c             	shl    $0xc,%eax
  80178d:	89 c2                	mov    %eax,%edx
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	c1 e0 04             	shl    $0x4,%eax
  801795:	05 20 31 80 00       	add    $0x803120,%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	e8 01 06 00 00       	call   801da7 <sys_allocateMem>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	e9 dd 00 00 00       	jmp    80188b <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	c1 e0 04             	shl    $0x4,%eax
  8017b4:	05 20 31 80 00       	add    $0x803120,%eax
  8017b9:	8b 00                	mov    (%eax),%eax
  8017bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017be:	c1 e2 0c             	shl    $0xc,%edx
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  8017c6:	a1 28 30 80 00       	mov    0x803028,%eax
  8017cb:	c1 e0 04             	shl    $0x4,%eax
  8017ce:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  8017d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d7:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  8017d9:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e2:	c1 e0 04             	shl    $0x4,%eax
  8017e5:	05 24 31 80 00       	add    $0x803124,%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	c1 e2 04             	shl    $0x4,%edx
  8017ef:	81 c2 24 31 80 00    	add    $0x803124,%edx
  8017f5:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8017f7:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801800:	c1 e0 04             	shl    $0x4,%eax
  801803:	05 28 31 80 00       	add    $0x803128,%eax
  801808:	8b 00                	mov    (%eax),%eax
  80180a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80180d:	c1 e2 04             	shl    $0x4,%edx
  801810:	81 c2 28 31 80 00    	add    $0x803128,%edx
  801816:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  801818:	a1 28 30 80 00       	mov    0x803028,%eax
  80181d:	c1 e0 04             	shl    $0x4,%eax
  801820:	05 2c 31 80 00       	add    $0x80312c,%eax
  801825:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  80182b:	a1 28 30 80 00       	mov    0x803028,%eax
  801830:	40                   	inc    %eax
  801831:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  801836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801839:	c1 e0 04             	shl    $0x4,%eax
  80183c:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  801842:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801845:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  801847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184a:	c1 e0 04             	shl    $0x4,%eax
  80184d:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  801853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801856:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	c1 e0 04             	shl    $0x4,%eax
  80185e:	05 2c 31 80 00       	add    $0x80312c,%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801869:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186c:	c1 e0 0c             	shl    $0xc,%eax
  80186f:	89 c2                	mov    %eax,%edx
  801871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801874:	c1 e0 04             	shl    $0x4,%eax
  801877:	05 20 31 80 00       	add    $0x803120,%eax
  80187c:	8b 00                	mov    (%eax),%eax
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	52                   	push   %edx
  801882:	50                   	push   %eax
  801883:	e8 1f 05 00 00       	call   801da7 <sys_allocateMem>
  801888:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  80188b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188e:	c1 e0 04             	shl    $0x4,%eax
  801891:	05 20 31 80 00       	add    $0x803120,%eax
  801896:	8b 00                	mov    (%eax),%eax
	}


}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  8018a0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  8018a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  8018ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8018b5:	eb 3f                	jmp    8018f6 <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  8018b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ba:	c1 e0 04             	shl    $0x4,%eax
  8018bd:	05 20 31 80 00       	add    $0x803120,%eax
  8018c2:	8b 00                	mov    (%eax),%eax
  8018c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018c7:	75 2a                	jne    8018f3 <free+0x59>
		{
			index=i;
  8018c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  8018cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d2:	c1 e0 04             	shl    $0x4,%eax
  8018d5:	05 28 31 80 00       	add    $0x803128,%eax
  8018da:	8b 00                	mov    (%eax),%eax
  8018dc:	c1 e0 0c             	shl    $0xc,%eax
  8018df:	89 c2                	mov    %eax,%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	83 ec 08             	sub    $0x8,%esp
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	e8 9d 04 00 00       	call   801d8b <sys_freeMem>
  8018ee:	83 c4 10             	add    $0x10,%esp
			break;
  8018f1:	eb 0d                	jmp    801900 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  8018f3:	ff 45 ec             	incl   -0x14(%ebp)
  8018f6:	a1 28 30 80 00       	mov    0x803028,%eax
  8018fb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8018fe:	7c b7                	jl     8018b7 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  801900:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801904:	75 17                	jne    80191d <free+0x83>
	{
		panic("Error");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 d0 2b 80 00       	push   $0x802bd0
  80190e:	68 81 00 00 00       	push   $0x81
  801913:	68 d6 2b 80 00       	push   $0x802bd6
  801918:	e8 22 ed ff ff       	call   80063f <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  80191d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801924:	e9 cc 00 00 00       	jmp    8019f5 <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  801929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80192c:	c1 e0 04             	shl    $0x4,%eax
  80192f:	05 2c 31 80 00       	add    $0x80312c,%eax
  801934:	8b 00                	mov    (%eax),%eax
  801936:	85 c0                	test   %eax,%eax
  801938:	0f 84 b3 00 00 00    	je     8019f1 <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  80193e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801941:	c1 e0 04             	shl    $0x4,%eax
  801944:	05 20 31 80 00       	add    $0x803120,%eax
  801949:	8b 10                	mov    (%eax),%edx
  80194b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194e:	c1 e0 04             	shl    $0x4,%eax
  801951:	05 24 31 80 00       	add    $0x803124,%eax
  801956:	8b 00                	mov    (%eax),%eax
  801958:	39 c2                	cmp    %eax,%edx
  80195a:	0f 85 92 00 00 00    	jne    8019f2 <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	c1 e0 04             	shl    $0x4,%eax
  801966:	05 24 31 80 00       	add    $0x803124,%eax
  80196b:	8b 00                	mov    (%eax),%eax
  80196d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801970:	c1 e2 04             	shl    $0x4,%edx
  801973:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801979:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  80197b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80197e:	c1 e0 04             	shl    $0x4,%eax
  801981:	05 28 31 80 00       	add    $0x803128,%eax
  801986:	8b 10                	mov    (%eax),%edx
  801988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198b:	c1 e0 04             	shl    $0x4,%eax
  80198e:	05 28 31 80 00       	add    $0x803128,%eax
  801993:	8b 00                	mov    (%eax),%eax
  801995:	01 c2                	add    %eax,%edx
  801997:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80199a:	c1 e0 04             	shl    $0x4,%eax
  80199d:	05 28 31 80 00       	add    $0x803128,%eax
  8019a2:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  8019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a7:	c1 e0 04             	shl    $0x4,%eax
  8019aa:	05 20 31 80 00       	add    $0x803120,%eax
  8019af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	c1 e0 04             	shl    $0x4,%eax
  8019bb:	05 24 31 80 00       	add    $0x803124,%eax
  8019c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	c1 e0 04             	shl    $0x4,%eax
  8019cc:	05 28 31 80 00       	add    $0x803128,%eax
  8019d1:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	c1 e0 04             	shl    $0x4,%eax
  8019dd:	05 2c 31 80 00       	add    $0x80312c,%eax
  8019e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  8019e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  8019ef:	eb 12                	jmp    801a03 <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8019f1:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  8019f2:	ff 45 e8             	incl   -0x18(%ebp)
  8019f5:	a1 28 30 80 00       	mov    0x803028,%eax
  8019fa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8019fd:	0f 8c 26 ff ff ff    	jl     801929 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801a03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a0a:	e9 cc 00 00 00       	jmp    801adb <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  801a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a12:	c1 e0 04             	shl    $0x4,%eax
  801a15:	05 2c 31 80 00       	add    $0x80312c,%eax
  801a1a:	8b 00                	mov    (%eax),%eax
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	0f 84 b3 00 00 00    	je     801ad7 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a27:	c1 e0 04             	shl    $0x4,%eax
  801a2a:	05 24 31 80 00       	add    $0x803124,%eax
  801a2f:	8b 10                	mov    (%eax),%edx
  801a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a34:	c1 e0 04             	shl    $0x4,%eax
  801a37:	05 20 31 80 00       	add    $0x803120,%eax
  801a3c:	8b 00                	mov    (%eax),%eax
  801a3e:	39 c2                	cmp    %eax,%edx
  801a40:	0f 85 92 00 00 00    	jne    801ad8 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  801a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a49:	c1 e0 04             	shl    $0x4,%eax
  801a4c:	05 20 31 80 00       	add    $0x803120,%eax
  801a51:	8b 00                	mov    (%eax),%eax
  801a53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a56:	c1 e2 04             	shl    $0x4,%edx
  801a59:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801a5f:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a64:	c1 e0 04             	shl    $0x4,%eax
  801a67:	05 28 31 80 00       	add    $0x803128,%eax
  801a6c:	8b 10                	mov    (%eax),%edx
  801a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a71:	c1 e0 04             	shl    $0x4,%eax
  801a74:	05 28 31 80 00       	add    $0x803128,%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	01 c2                	add    %eax,%edx
  801a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a80:	c1 e0 04             	shl    $0x4,%eax
  801a83:	05 28 31 80 00       	add    $0x803128,%eax
  801a88:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8d:	c1 e0 04             	shl    $0x4,%eax
  801a90:	05 20 31 80 00       	add    $0x803120,%eax
  801a95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9e:	c1 e0 04             	shl    $0x4,%eax
  801aa1:	05 24 31 80 00       	add    $0x803124,%eax
  801aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	c1 e0 04             	shl    $0x4,%eax
  801ab2:	05 28 31 80 00       	add    $0x803128,%eax
  801ab7:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac0:	c1 e0 04             	shl    $0x4,%eax
  801ac3:	05 2c 31 80 00       	add    $0x80312c,%eax
  801ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801ace:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801ad5:	eb 12                	jmp    801ae9 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801ad7:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801ad8:	ff 45 e4             	incl   -0x1c(%ebp)
  801adb:	a1 28 30 80 00       	mov    0x803028,%eax
  801ae0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ae3:	0f 8c 26 ff ff ff    	jl     801a0f <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801ae9:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801aed:	75 11                	jne    801b00 <free+0x266>
	{
		spaces[index].isFree = 1;
  801aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af2:	c1 e0 04             	shl    $0x4,%eax
  801af5:	05 2c 31 80 00       	add    $0x80312c,%eax
  801afa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 18             	sub    $0x18,%esp
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	68 e4 2b 80 00       	push   $0x802be4
  801b17:	68 b9 00 00 00       	push   $0xb9
  801b1c:	68 d6 2b 80 00       	push   $0x802bd6
  801b21:	e8 19 eb ff ff       	call   80063f <_panic>

00801b26 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	68 e4 2b 80 00       	push   $0x802be4
  801b34:	68 bf 00 00 00       	push   $0xbf
  801b39:	68 d6 2b 80 00       	push   $0x802bd6
  801b3e:	e8 fc ea ff ff       	call   80063f <_panic>

00801b43 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	68 e4 2b 80 00       	push   $0x802be4
  801b51:	68 c5 00 00 00       	push   $0xc5
  801b56:	68 d6 2b 80 00       	push   $0x802bd6
  801b5b:	e8 df ea ff ff       	call   80063f <_panic>

00801b60 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	68 e4 2b 80 00       	push   $0x802be4
  801b6e:	68 ca 00 00 00       	push   $0xca
  801b73:	68 d6 2b 80 00       	push   $0x802bd6
  801b78:	e8 c2 ea ff ff       	call   80063f <_panic>

00801b7d <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	68 e4 2b 80 00       	push   $0x802be4
  801b8b:	68 d0 00 00 00       	push   $0xd0
  801b90:	68 d6 2b 80 00       	push   $0x802bd6
  801b95:	e8 a5 ea ff ff       	call   80063f <_panic>

00801b9a <shrink>:
}
void shrink(uint32 newSize)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	68 e4 2b 80 00       	push   $0x802be4
  801ba8:	68 d4 00 00 00       	push   $0xd4
  801bad:	68 d6 2b 80 00       	push   $0x802bd6
  801bb2:	e8 88 ea ff ff       	call   80063f <_panic>

00801bb7 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	68 e4 2b 80 00       	push   $0x802be4
  801bc5:	68 d9 00 00 00       	push   $0xd9
  801bca:	68 d6 2b 80 00       	push   $0x802bd6
  801bcf:	e8 6b ea ff ff       	call   80063f <_panic>

00801bd4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	57                   	push   %edi
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bef:	cd 30                	int    $0x30
  801bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5f                   	pop    %edi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	8b 45 10             	mov    0x10(%ebp),%eax
  801c08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	52                   	push   %edx
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	50                   	push   %eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	e8 b2 ff ff ff       	call   801bd4 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	90                   	nop
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 01                	push   $0x1
  801c37:	e8 98 ff ff ff       	call   801bd4 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	50                   	push   %eax
  801c50:	6a 05                	push   $0x5
  801c52:	e8 7d ff ff ff       	call   801bd4 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 02                	push   $0x2
  801c6b:	e8 64 ff ff ff       	call   801bd4 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 03                	push   $0x3
  801c84:	e8 4b ff ff ff       	call   801bd4 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 04                	push   $0x4
  801c9d:	e8 32 ff ff ff       	call   801bd4 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_env_exit>:


void sys_env_exit(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 06                	push   $0x6
  801cb6:	e8 19 ff ff ff       	call   801bd4 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 07                	push   $0x7
  801cd4:	e8 fb fe ff ff       	call   801bd4 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	56                   	push   %esi
  801ce2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ce3:	8b 75 18             	mov    0x18(%ebp),%esi
  801ce6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	51                   	push   %ecx
  801cf5:	52                   	push   %edx
  801cf6:	50                   	push   %eax
  801cf7:	6a 08                	push   $0x8
  801cf9:	e8 d6 fe ff ff       	call   801bd4 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    

00801d08 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	52                   	push   %edx
  801d18:	50                   	push   %eax
  801d19:	6a 09                	push   $0x9
  801d1b:	e8 b4 fe ff ff       	call   801bd4 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	6a 0a                	push   $0xa
  801d36:	e8 99 fe ff ff       	call   801bd4 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 0b                	push   $0xb
  801d4f:	e8 80 fe ff ff       	call   801bd4 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 0c                	push   $0xc
  801d68:	e8 67 fe ff ff       	call   801bd4 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 0d                	push   $0xd
  801d81:	e8 4e fe ff ff       	call   801bd4 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	6a 11                	push   $0x11
  801d9c:	e8 33 fe ff ff       	call   801bd4 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
	return;
  801da4:	90                   	nop
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 12                	push   $0x12
  801db8:	e8 17 fe ff ff       	call   801bd4 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 0e                	push   $0xe
  801dd2:	e8 fd fd ff ff       	call   801bd4 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	ff 75 08             	pushl  0x8(%ebp)
  801dea:	6a 0f                	push   $0xf
  801dec:	e8 e3 fd ff ff       	call   801bd4 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 10                	push   $0x10
  801e05:	e8 ca fd ff ff       	call   801bd4 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	90                   	nop
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 14                	push   $0x14
  801e1f:	e8 b0 fd ff ff       	call   801bd4 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	90                   	nop
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 15                	push   $0x15
  801e39:	e8 96 fd ff ff       	call   801bd4 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	90                   	nop
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	50                   	push   %eax
  801e5d:	6a 16                	push   $0x16
  801e5f:	e8 70 fd ff ff       	call   801bd4 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	90                   	nop
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 17                	push   $0x17
  801e79:	e8 56 fd ff ff       	call   801bd4 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	90                   	nop
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	50                   	push   %eax
  801e94:	6a 18                	push   $0x18
  801e96:	e8 39 fd ff ff       	call   801bd4 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 1b                	push   $0x1b
  801eb3:	e8 1c fd ff ff       	call   801bd4 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	6a 19                	push   $0x19
  801ed0:	e8 ff fc ff ff       	call   801bd4 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	90                   	nop
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	6a 1a                	push   $0x1a
  801eee:	e8 e1 fc ff ff       	call   801bd4 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	90                   	nop
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	8b 45 10             	mov    0x10(%ebp),%eax
  801f02:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	6a 00                	push   $0x0
  801f11:	51                   	push   %ecx
  801f12:	52                   	push   %edx
  801f13:	ff 75 0c             	pushl  0xc(%ebp)
  801f16:	50                   	push   %eax
  801f17:	6a 1c                	push   $0x1c
  801f19:	e8 b6 fc ff ff       	call   801bd4 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	6a 1d                	push   $0x1d
  801f36:	e8 99 fc ff ff       	call   801bd4 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	51                   	push   %ecx
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	6a 1e                	push   $0x1e
  801f55:	e8 7a fc ff ff       	call   801bd4 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 1f                	push   $0x1f
  801f72:	e8 5d fc ff ff       	call   801bd4 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 20                	push   $0x20
  801f8b:	e8 44 fc ff ff       	call   801bd4 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	ff 75 14             	pushl  0x14(%ebp)
  801fa0:	ff 75 10             	pushl  0x10(%ebp)
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	50                   	push   %eax
  801fa7:	6a 21                	push   $0x21
  801fa9:	e8 26 fc ff ff       	call   801bd4 <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	50                   	push   %eax
  801fc2:	6a 22                	push   $0x22
  801fc4:	e8 0b fc ff ff       	call   801bd4 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
}
  801fcc:	90                   	nop
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	50                   	push   %eax
  801fde:	6a 23                	push   $0x23
  801fe0:	e8 ef fb ff ff       	call   801bd4 <syscall>
  801fe5:	83 c4 18             	add    $0x18,%esp
}
  801fe8:	90                   	nop
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ff1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff4:	8d 50 04             	lea    0x4(%eax),%edx
  801ff7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	52                   	push   %edx
  802001:	50                   	push   %eax
  802002:	6a 24                	push   $0x24
  802004:	e8 cb fb ff ff       	call   801bd4 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
	return result;
  80200c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802012:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802015:	89 01                	mov    %eax,(%ecx)
  802017:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	c9                   	leave  
  80201e:	c2 04 00             	ret    $0x4

00802021 <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	ff 75 10             	pushl  0x10(%ebp)
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	6a 13                	push   $0x13
  802033:	e8 9c fb ff ff       	call   801bd4 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return ;
  80203b:	90                   	nop
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_rcr2>:
uint32 sys_rcr2()
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 25                	push   $0x25
  80204d:	e8 82 fb ff ff       	call   801bd4 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802063:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	50                   	push   %eax
  802070:	6a 26                	push   $0x26
  802072:	e8 5d fb ff ff       	call   801bd4 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return ;
  80207a:	90                   	nop
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <rsttst>:
void rsttst()
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 28                	push   $0x28
  80208c:	e8 43 fb ff ff       	call   801bd4 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
	return ;
  802094:	90                   	nop
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020a3:	8b 55 18             	mov    0x18(%ebp),%edx
  8020a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020aa:	52                   	push   %edx
  8020ab:	50                   	push   %eax
  8020ac:	ff 75 10             	pushl  0x10(%ebp)
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	6a 27                	push   $0x27
  8020b7:	e8 18 fb ff ff       	call   801bd4 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bf:	90                   	nop
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <chktst>:
void chktst(uint32 n)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	6a 29                	push   $0x29
  8020d2:	e8 fd fa ff ff       	call   801bd4 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020da:	90                   	nop
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <inctst>:

void inctst()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 2a                	push   $0x2a
  8020ec:	e8 e3 fa ff ff       	call   801bd4 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f4:	90                   	nop
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <gettst>:
uint32 gettst()
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 2b                	push   $0x2b
  802106:	e8 c9 fa ff ff       	call   801bd4 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 2c                	push   $0x2c
  802122:	e8 ad fa ff ff       	call   801bd4 <syscall>
  802127:	83 c4 18             	add    $0x18,%esp
  80212a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80212d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802131:	75 07                	jne    80213a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802133:	b8 01 00 00 00       	mov    $0x1,%eax
  802138:	eb 05                	jmp    80213f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 2c                	push   $0x2c
  802153:	e8 7c fa ff ff       	call   801bd4 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
  80215b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80215e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802162:	75 07                	jne    80216b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802164:	b8 01 00 00 00       	mov    $0x1,%eax
  802169:	eb 05                	jmp    802170 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80216b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 2c                	push   $0x2c
  802184:	e8 4b fa ff ff       	call   801bd4 <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
  80218c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80218f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802193:	75 07                	jne    80219c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802195:	b8 01 00 00 00       	mov    $0x1,%eax
  80219a:	eb 05                	jmp    8021a1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 2c                	push   $0x2c
  8021b5:	e8 1a fa ff ff       	call   801bd4 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
  8021bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021c0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021c4:	75 07                	jne    8021cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cb:	eb 05                	jmp    8021d2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 08             	pushl  0x8(%ebp)
  8021e2:	6a 2d                	push   $0x2d
  8021e4:	e8 eb f9 ff ff       	call   801bd4 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ec:	90                   	nop
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	6a 00                	push   $0x0
  802201:	53                   	push   %ebx
  802202:	51                   	push   %ecx
  802203:	52                   	push   %edx
  802204:	50                   	push   %eax
  802205:	6a 2e                	push   $0x2e
  802207:	e8 c8 f9 ff ff       	call   801bd4 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	52                   	push   %edx
  802224:	50                   	push   %eax
  802225:	6a 2f                	push   $0x2f
  802227:	e8 a8 f9 ff ff       	call   801bd4 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    
  802231:	66 90                	xchg   %ax,%ax
  802233:	90                   	nop

00802234 <__udivdi3>:
  802234:	55                   	push   %ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 1c             	sub    $0x1c,%esp
  80223b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80223f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802247:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80224b:	89 ca                	mov    %ecx,%edx
  80224d:	89 f8                	mov    %edi,%eax
  80224f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802253:	85 f6                	test   %esi,%esi
  802255:	75 2d                	jne    802284 <__udivdi3+0x50>
  802257:	39 cf                	cmp    %ecx,%edi
  802259:	77 65                	ja     8022c0 <__udivdi3+0x8c>
  80225b:	89 fd                	mov    %edi,%ebp
  80225d:	85 ff                	test   %edi,%edi
  80225f:	75 0b                	jne    80226c <__udivdi3+0x38>
  802261:	b8 01 00 00 00       	mov    $0x1,%eax
  802266:	31 d2                	xor    %edx,%edx
  802268:	f7 f7                	div    %edi
  80226a:	89 c5                	mov    %eax,%ebp
  80226c:	31 d2                	xor    %edx,%edx
  80226e:	89 c8                	mov    %ecx,%eax
  802270:	f7 f5                	div    %ebp
  802272:	89 c1                	mov    %eax,%ecx
  802274:	89 d8                	mov    %ebx,%eax
  802276:	f7 f5                	div    %ebp
  802278:	89 cf                	mov    %ecx,%edi
  80227a:	89 fa                	mov    %edi,%edx
  80227c:	83 c4 1c             	add    $0x1c,%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
  802284:	39 ce                	cmp    %ecx,%esi
  802286:	77 28                	ja     8022b0 <__udivdi3+0x7c>
  802288:	0f bd fe             	bsr    %esi,%edi
  80228b:	83 f7 1f             	xor    $0x1f,%edi
  80228e:	75 40                	jne    8022d0 <__udivdi3+0x9c>
  802290:	39 ce                	cmp    %ecx,%esi
  802292:	72 0a                	jb     80229e <__udivdi3+0x6a>
  802294:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802298:	0f 87 9e 00 00 00    	ja     80233c <__udivdi3+0x108>
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	89 fa                	mov    %edi,%edx
  8022a5:	83 c4 1c             	add    $0x1c,%esp
  8022a8:	5b                   	pop    %ebx
  8022a9:	5e                   	pop    %esi
  8022aa:	5f                   	pop    %edi
  8022ab:	5d                   	pop    %ebp
  8022ac:	c3                   	ret    
  8022ad:	8d 76 00             	lea    0x0(%esi),%esi
  8022b0:	31 ff                	xor    %edi,%edi
  8022b2:	31 c0                	xor    %eax,%eax
  8022b4:	89 fa                	mov    %edi,%edx
  8022b6:	83 c4 1c             	add    $0x1c,%esp
  8022b9:	5b                   	pop    %ebx
  8022ba:	5e                   	pop    %esi
  8022bb:	5f                   	pop    %edi
  8022bc:	5d                   	pop    %ebp
  8022bd:	c3                   	ret    
  8022be:	66 90                	xchg   %ax,%ax
  8022c0:	89 d8                	mov    %ebx,%eax
  8022c2:	f7 f7                	div    %edi
  8022c4:	31 ff                	xor    %edi,%edi
  8022c6:	89 fa                	mov    %edi,%edx
  8022c8:	83 c4 1c             	add    $0x1c,%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5e                   	pop    %esi
  8022cd:	5f                   	pop    %edi
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    
  8022d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022d5:	89 eb                	mov    %ebp,%ebx
  8022d7:	29 fb                	sub    %edi,%ebx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	d3 e6                	shl    %cl,%esi
  8022dd:	89 c5                	mov    %eax,%ebp
  8022df:	88 d9                	mov    %bl,%cl
  8022e1:	d3 ed                	shr    %cl,%ebp
  8022e3:	89 e9                	mov    %ebp,%ecx
  8022e5:	09 f1                	or     %esi,%ecx
  8022e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022eb:	89 f9                	mov    %edi,%ecx
  8022ed:	d3 e0                	shl    %cl,%eax
  8022ef:	89 c5                	mov    %eax,%ebp
  8022f1:	89 d6                	mov    %edx,%esi
  8022f3:	88 d9                	mov    %bl,%cl
  8022f5:	d3 ee                	shr    %cl,%esi
  8022f7:	89 f9                	mov    %edi,%ecx
  8022f9:	d3 e2                	shl    %cl,%edx
  8022fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022ff:	88 d9                	mov    %bl,%cl
  802301:	d3 e8                	shr    %cl,%eax
  802303:	09 c2                	or     %eax,%edx
  802305:	89 d0                	mov    %edx,%eax
  802307:	89 f2                	mov    %esi,%edx
  802309:	f7 74 24 0c          	divl   0xc(%esp)
  80230d:	89 d6                	mov    %edx,%esi
  80230f:	89 c3                	mov    %eax,%ebx
  802311:	f7 e5                	mul    %ebp
  802313:	39 d6                	cmp    %edx,%esi
  802315:	72 19                	jb     802330 <__udivdi3+0xfc>
  802317:	74 0b                	je     802324 <__udivdi3+0xf0>
  802319:	89 d8                	mov    %ebx,%eax
  80231b:	31 ff                	xor    %edi,%edi
  80231d:	e9 58 ff ff ff       	jmp    80227a <__udivdi3+0x46>
  802322:	66 90                	xchg   %ax,%ax
  802324:	8b 54 24 08          	mov    0x8(%esp),%edx
  802328:	89 f9                	mov    %edi,%ecx
  80232a:	d3 e2                	shl    %cl,%edx
  80232c:	39 c2                	cmp    %eax,%edx
  80232e:	73 e9                	jae    802319 <__udivdi3+0xe5>
  802330:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802333:	31 ff                	xor    %edi,%edi
  802335:	e9 40 ff ff ff       	jmp    80227a <__udivdi3+0x46>
  80233a:	66 90                	xchg   %ax,%ax
  80233c:	31 c0                	xor    %eax,%eax
  80233e:	e9 37 ff ff ff       	jmp    80227a <__udivdi3+0x46>
  802343:	90                   	nop

00802344 <__umoddi3>:
  802344:	55                   	push   %ebp
  802345:	57                   	push   %edi
  802346:	56                   	push   %esi
  802347:	53                   	push   %ebx
  802348:	83 ec 1c             	sub    $0x1c,%esp
  80234b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80234f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802353:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802357:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80235b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80235f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802363:	89 f3                	mov    %esi,%ebx
  802365:	89 fa                	mov    %edi,%edx
  802367:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80236b:	89 34 24             	mov    %esi,(%esp)
  80236e:	85 c0                	test   %eax,%eax
  802370:	75 1a                	jne    80238c <__umoddi3+0x48>
  802372:	39 f7                	cmp    %esi,%edi
  802374:	0f 86 a2 00 00 00    	jbe    80241c <__umoddi3+0xd8>
  80237a:	89 c8                	mov    %ecx,%eax
  80237c:	89 f2                	mov    %esi,%edx
  80237e:	f7 f7                	div    %edi
  802380:	89 d0                	mov    %edx,%eax
  802382:	31 d2                	xor    %edx,%edx
  802384:	83 c4 1c             	add    $0x1c,%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    
  80238c:	39 f0                	cmp    %esi,%eax
  80238e:	0f 87 ac 00 00 00    	ja     802440 <__umoddi3+0xfc>
  802394:	0f bd e8             	bsr    %eax,%ebp
  802397:	83 f5 1f             	xor    $0x1f,%ebp
  80239a:	0f 84 ac 00 00 00    	je     80244c <__umoddi3+0x108>
  8023a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8023a5:	29 ef                	sub    %ebp,%edi
  8023a7:	89 fe                	mov    %edi,%esi
  8023a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ad:	89 e9                	mov    %ebp,%ecx
  8023af:	d3 e0                	shl    %cl,%eax
  8023b1:	89 d7                	mov    %edx,%edi
  8023b3:	89 f1                	mov    %esi,%ecx
  8023b5:	d3 ef                	shr    %cl,%edi
  8023b7:	09 c7                	or     %eax,%edi
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	d3 e2                	shl    %cl,%edx
  8023bd:	89 14 24             	mov    %edx,(%esp)
  8023c0:	89 d8                	mov    %ebx,%eax
  8023c2:	d3 e0                	shl    %cl,%eax
  8023c4:	89 c2                	mov    %eax,%edx
  8023c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023ca:	d3 e0                	shl    %cl,%eax
  8023cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023d4:	89 f1                	mov    %esi,%ecx
  8023d6:	d3 e8                	shr    %cl,%eax
  8023d8:	09 d0                	or     %edx,%eax
  8023da:	d3 eb                	shr    %cl,%ebx
  8023dc:	89 da                	mov    %ebx,%edx
  8023de:	f7 f7                	div    %edi
  8023e0:	89 d3                	mov    %edx,%ebx
  8023e2:	f7 24 24             	mull   (%esp)
  8023e5:	89 c6                	mov    %eax,%esi
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	39 d3                	cmp    %edx,%ebx
  8023eb:	0f 82 87 00 00 00    	jb     802478 <__umoddi3+0x134>
  8023f1:	0f 84 91 00 00 00    	je     802488 <__umoddi3+0x144>
  8023f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023fb:	29 f2                	sub    %esi,%edx
  8023fd:	19 cb                	sbb    %ecx,%ebx
  8023ff:	89 d8                	mov    %ebx,%eax
  802401:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802405:	d3 e0                	shl    %cl,%eax
  802407:	89 e9                	mov    %ebp,%ecx
  802409:	d3 ea                	shr    %cl,%edx
  80240b:	09 d0                	or     %edx,%eax
  80240d:	89 e9                	mov    %ebp,%ecx
  80240f:	d3 eb                	shr    %cl,%ebx
  802411:	89 da                	mov    %ebx,%edx
  802413:	83 c4 1c             	add    $0x1c,%esp
  802416:	5b                   	pop    %ebx
  802417:	5e                   	pop    %esi
  802418:	5f                   	pop    %edi
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    
  80241b:	90                   	nop
  80241c:	89 fd                	mov    %edi,%ebp
  80241e:	85 ff                	test   %edi,%edi
  802420:	75 0b                	jne    80242d <__umoddi3+0xe9>
  802422:	b8 01 00 00 00       	mov    $0x1,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	f7 f7                	div    %edi
  80242b:	89 c5                	mov    %eax,%ebp
  80242d:	89 f0                	mov    %esi,%eax
  80242f:	31 d2                	xor    %edx,%edx
  802431:	f7 f5                	div    %ebp
  802433:	89 c8                	mov    %ecx,%eax
  802435:	f7 f5                	div    %ebp
  802437:	89 d0                	mov    %edx,%eax
  802439:	e9 44 ff ff ff       	jmp    802382 <__umoddi3+0x3e>
  80243e:	66 90                	xchg   %ax,%ax
  802440:	89 c8                	mov    %ecx,%eax
  802442:	89 f2                	mov    %esi,%edx
  802444:	83 c4 1c             	add    $0x1c,%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5f                   	pop    %edi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    
  80244c:	3b 04 24             	cmp    (%esp),%eax
  80244f:	72 06                	jb     802457 <__umoddi3+0x113>
  802451:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802455:	77 0f                	ja     802466 <__umoddi3+0x122>
  802457:	89 f2                	mov    %esi,%edx
  802459:	29 f9                	sub    %edi,%ecx
  80245b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80245f:	89 14 24             	mov    %edx,(%esp)
  802462:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802466:	8b 44 24 04          	mov    0x4(%esp),%eax
  80246a:	8b 14 24             	mov    (%esp),%edx
  80246d:	83 c4 1c             	add    $0x1c,%esp
  802470:	5b                   	pop    %ebx
  802471:	5e                   	pop    %esi
  802472:	5f                   	pop    %edi
  802473:	5d                   	pop    %ebp
  802474:	c3                   	ret    
  802475:	8d 76 00             	lea    0x0(%esi),%esi
  802478:	2b 04 24             	sub    (%esp),%eax
  80247b:	19 fa                	sbb    %edi,%edx
  80247d:	89 d1                	mov    %edx,%ecx
  80247f:	89 c6                	mov    %eax,%esi
  802481:	e9 71 ff ff ff       	jmp    8023f7 <__umoddi3+0xb3>
  802486:	66 90                	xchg   %ax,%ax
  802488:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80248c:	72 ea                	jb     802478 <__umoddi3+0x134>
  80248e:	89 d9                	mov    %ebx,%ecx
  802490:	e9 62 ff ff ff       	jmp    8023f7 <__umoddi3+0xb3>
