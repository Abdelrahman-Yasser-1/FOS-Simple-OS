
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 6d 03 00 00       	call   8003a3 <libmain>
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
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 23                	jmp    800072 <_main+0x3a>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 30 80 00       	mov    0x803020,%eax
  800054:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	c1 e2 04             	shl    $0x4,%edx
  800060:	01 d0                	add    %edx,%eax
  800062:	8a 40 04             	mov    0x4(%eax),%al
  800065:	84 c0                	test   %al,%al
  800067:	74 06                	je     80006f <_main+0x37>
			{
				fullWS = 0;
  800069:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006d:	eb 12                	jmp    800081 <_main+0x49>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80006f:	ff 45 f0             	incl   -0x10(%ebp)
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 50 74             	mov    0x74(%eax),%edx
  80007a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007d:	39 c2                	cmp    %eax,%edx
  80007f:	77 ce                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800081:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800085:	74 14                	je     80009b <_main+0x63>
  800087:	83 ec 04             	sub    $0x4,%esp
  80008a:	68 40 23 80 00       	push   $0x802340
  80008f:	6a 1a                	push   $0x1a
  800091:	68 5c 23 80 00       	push   $0x80235c
  800096:	e8 4d 04 00 00       	call   8004e8 <_panic>
	}


	int Mega = 1024*1024;
  80009b:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000a2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000a9:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000ad:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000b1:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000b7:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000bd:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000c4:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000cb:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000d1:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	01 c0                	add    %eax,%eax
  8000e4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	50                   	push   %eax
  8000eb:	e8 24 14 00 00       	call   801514 <malloc>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8000f9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8000ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800105:	01 c0                	add    %eax,%eax
  800107:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010a:	48                   	dec    %eax
  80010b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  80010e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800111:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800114:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800116:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800119:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80011c:	01 c2                	add    %eax,%edx
  80011e:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800121:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800126:	01 c0                	add    %eax,%eax
  800128:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	e8 e0 13 00 00       	call   801514 <malloc>
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  80013d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800143:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800149:	01 c0                	add    %eax,%eax
  80014b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80014e:	d1 e8                	shr    %eax
  800150:	48                   	dec    %eax
  800151:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800154:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015a:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  80015d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800160:	01 c0                	add    %eax,%eax
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800167:	01 c2                	add    %eax,%edx
  800169:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80016d:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800173:	89 c2                	mov    %eax,%edx
  800175:	01 d2                	add    %edx,%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	e8 92 13 00 00       	call   801514 <malloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80018b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800191:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	c1 e8 02             	shr    $0x2,%eax
  80019c:	48                   	dec    %eax
  80019d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001a6:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b5:	01 c2                	add    %eax,%edx
  8001b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ba:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001bf:	89 d0                	mov    %edx,%eax
  8001c1:	01 c0                	add    %eax,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	50                   	push   %eax
  8001cd:	e8 42 13 00 00       	call   801514 <malloc>
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001db:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001e1:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001e7:	89 d0                	mov    %edx,%eax
  8001e9:	01 c0                	add    %eax,%eax
  8001eb:	01 d0                	add    %edx,%eax
  8001ed:	01 c0                	add    %eax,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	c1 e8 03             	shr    $0x3,%eax
  8001f4:	48                   	dec    %eax
  8001f5:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	8a 55 e7             	mov    -0x19(%ebp),%dl
  8001fe:	88 10                	mov    %dl,(%eax)
  800200:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800206:	66 89 42 02          	mov    %ax,0x2(%edx)
  80020a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800210:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800213:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800216:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	01 c2                	add    %eax,%edx
  800222:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800225:	88 02                	mov    %al,(%edx)
  800227:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80022a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800231:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800234:	01 c2                	add    %eax,%edx
  800236:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80023a:	66 89 42 02          	mov    %ax,0x2(%edx)
  80023e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800241:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800248:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024b:	01 c2                	add    %eax,%edx
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800253:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800256:	8a 00                	mov    (%eax),%al
  800258:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80025b:	75 0f                	jne    80026c <_main+0x234>
  80025d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800260:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800263:	01 d0                	add    %edx,%eax
  800265:	8a 00                	mov    (%eax),%al
  800267:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80026a:	74 14                	je     800280 <_main+0x248>
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	68 70 23 80 00       	push   $0x802370
  800274:	6a 42                	push   $0x42
  800276:	68 5c 23 80 00       	push   $0x80235c
  80027b:	e8 68 02 00 00       	call   8004e8 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800280:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800283:	66 8b 00             	mov    (%eax),%ax
  800286:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80028a:	75 15                	jne    8002a1 <_main+0x269>
  80028c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	89 c2                	mov    %eax,%edx
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	01 d0                	add    %edx,%eax
  800298:	66 8b 00             	mov    (%eax),%ax
  80029b:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  80029f:	74 14                	je     8002b5 <_main+0x27d>
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	68 70 23 80 00       	push   $0x802370
  8002a9:	6a 43                	push   $0x43
  8002ab:	68 5c 23 80 00       	push   $0x80235c
  8002b0:	e8 33 02 00 00       	call   8004e8 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002b8:	8b 00                	mov    (%eax),%eax
  8002ba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002bd:	75 16                	jne    8002d5 <_main+0x29d>
  8002bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cc:	01 d0                	add    %edx,%eax
  8002ce:	8b 00                	mov    (%eax),%eax
  8002d0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002d3:	74 14                	je     8002e9 <_main+0x2b1>
  8002d5:	83 ec 04             	sub    $0x4,%esp
  8002d8:	68 70 23 80 00       	push   $0x802370
  8002dd:	6a 44                	push   $0x44
  8002df:	68 5c 23 80 00       	push   $0x80235c
  8002e4:	e8 ff 01 00 00       	call   8004e8 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002e9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ec:	8a 00                	mov    (%eax),%al
  8002ee:	3a 45 e7             	cmp    -0x19(%ebp),%al
  8002f1:	75 16                	jne    800309 <_main+0x2d1>
  8002f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800300:	01 d0                	add    %edx,%eax
  800302:	8a 00                	mov    (%eax),%al
  800304:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 70 23 80 00       	push   $0x802370
  800311:	6a 46                	push   $0x46
  800313:	68 5c 23 80 00       	push   $0x80235c
  800318:	e8 cb 01 00 00       	call   8004e8 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80031d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800320:	66 8b 40 02          	mov    0x2(%eax),%ax
  800324:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  800328:	75 19                	jne    800343 <_main+0x30b>
  80032a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80032d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800334:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800337:	01 d0                	add    %edx,%eax
  800339:	66 8b 40 02          	mov    0x2(%eax),%ax
  80033d:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800341:	74 14                	je     800357 <_main+0x31f>
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	68 70 23 80 00       	push   $0x802370
  80034b:	6a 47                	push   $0x47
  80034d:	68 5c 23 80 00       	push   $0x80235c
  800352:	e8 91 01 00 00       	call   8004e8 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800357:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80035a:	8b 40 04             	mov    0x4(%eax),%eax
  80035d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800360:	75 17                	jne    800379 <_main+0x341>
  800362:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800365:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80036c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	8b 40 04             	mov    0x4(%eax),%eax
  800374:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800377:	74 14                	je     80038d <_main+0x355>
  800379:	83 ec 04             	sub    $0x4,%esp
  80037c:	68 70 23 80 00       	push   $0x802370
  800381:	6a 48                	push   $0x48
  800383:	68 5c 23 80 00       	push   $0x80235c
  800388:	e8 5b 01 00 00       	call   8004e8 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	68 a8 23 80 00       	push   $0x8023a8
  800395:	e8 f0 03 00 00       	call   80078a <cprintf>
  80039a:	83 c4 10             	add    $0x10,%esp

	return;
  80039d:	90                   	nop
}
  80039e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a9:	e8 70 17 00 00       	call   801b1e <sys_getenvindex>
  8003ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b4:	89 d0                	mov    %edx,%eax
  8003b6:	c1 e0 03             	shl    $0x3,%eax
  8003b9:	01 d0                	add    %edx,%eax
  8003bb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	01 d0                	add    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	89 c2                	mov    %eax,%edx
  8003ce:	c1 e2 05             	shl    $0x5,%edx
  8003d1:	29 c2                	sub    %eax,%edx
  8003d3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  8003da:	89 c2                	mov    %eax,%edx
  8003dc:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003e2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  8003f2:	84 c0                	test   %al,%al
  8003f4:	74 0f                	je     800405 <libmain+0x62>
		binaryname = myEnv->prog_name;
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	05 40 3c 01 00       	add    $0x13c40,%eax
  800400:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800405:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800409:	7e 0a                	jle    800415 <libmain+0x72>
		binaryname = argv[0];
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 15 fc ff ff       	call   800038 <_main>
  800423:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800426:	e8 8e 18 00 00       	call   801cb9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	68 fc 23 80 00       	push   $0x8023fc
  800433:	e8 52 03 00 00       	call   80078a <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043b:	a1 20 30 80 00       	mov    0x803020,%eax
  800440:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800446:	a1 20 30 80 00       	mov    0x803020,%eax
  80044b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800451:	83 ec 04             	sub    $0x4,%esp
  800454:	52                   	push   %edx
  800455:	50                   	push   %eax
  800456:	68 24 24 80 00       	push   $0x802424
  80045b:	e8 2a 03 00 00       	call   80078a <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800463:	a1 20 30 80 00       	mov    0x803020,%eax
  800468:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  80046e:	a1 20 30 80 00       	mov    0x803020,%eax
  800473:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  800479:	83 ec 04             	sub    $0x4,%esp
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	68 4c 24 80 00       	push   $0x80244c
  800483:	e8 02 03 00 00       	call   80078a <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 8d 24 80 00       	push   $0x80248d
  80049f:	e8 e6 02 00 00       	call   80078a <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	68 fc 23 80 00       	push   $0x8023fc
  8004af:	e8 d6 02 00 00       	call   80078a <cprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004b7:	e8 17 18 00 00       	call   801cd3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004bc:	e8 19 00 00 00       	call   8004da <exit>
}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	6a 00                	push   $0x0
  8004cf:	e8 16 16 00 00       	call   801aea <sys_env_destroy>
  8004d4:	83 c4 10             	add    $0x10,%esp
}
  8004d7:	90                   	nop
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <exit>:

void
exit(void)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  8004e0:	e8 6b 16 00 00       	call   801b50 <sys_env_exit>
}
  8004e5:	90                   	nop
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8004f1:	83 c0 04             	add    $0x4,%eax
  8004f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004f7:	a1 18 31 80 00       	mov    0x803118,%eax
  8004fc:	85 c0                	test   %eax,%eax
  8004fe:	74 16                	je     800516 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800500:	a1 18 31 80 00       	mov    0x803118,%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	50                   	push   %eax
  800509:	68 a4 24 80 00       	push   $0x8024a4
  80050e:	e8 77 02 00 00       	call   80078a <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800516:	a1 00 30 80 00       	mov    0x803000,%eax
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	50                   	push   %eax
  800522:	68 a9 24 80 00       	push   $0x8024a9
  800527:	e8 5e 02 00 00       	call   80078a <cprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80052f:	8b 45 10             	mov    0x10(%ebp),%eax
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	ff 75 f4             	pushl  -0xc(%ebp)
  800538:	50                   	push   %eax
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	6a 00                	push   $0x0
  800546:	68 c5 24 80 00       	push   $0x8024c5
  80054b:	e8 cf 01 00 00       	call   80071f <vcprintf>
  800550:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800553:	e8 82 ff ff ff       	call   8004da <exit>

	// should not return here
	while (1) ;
  800558:	eb fe                	jmp    800558 <_panic+0x70>

0080055a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800560:	a1 20 30 80 00       	mov    0x803020,%eax
  800565:	8b 50 74             	mov    0x74(%eax),%edx
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056b:	39 c2                	cmp    %eax,%edx
  80056d:	74 14                	je     800583 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80056f:	83 ec 04             	sub    $0x4,%esp
  800572:	68 c8 24 80 00       	push   $0x8024c8
  800577:	6a 26                	push   $0x26
  800579:	68 14 25 80 00       	push   $0x802514
  80057e:	e8 65 ff ff ff       	call   8004e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80058a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800591:	e9 b6 00 00 00       	jmp    80064c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800599:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	85 c0                	test   %eax,%eax
  8005a9:	75 08                	jne    8005b3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005ae:	e9 96 00 00 00       	jmp    800649 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  8005b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005c1:	eb 5d                	jmp    800620 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c8:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d1:	c1 e2 04             	shl    $0x4,%edx
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	8a 40 04             	mov    0x4(%eax),%al
  8005d9:	84 c0                	test   %al,%al
  8005db:	75 40                	jne    80061d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e2:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8005e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005eb:	c1 e2 04             	shl    $0x4,%edx
  8005ee:	01 d0                	add    %edx,%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005fd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800602:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 c8                	add    %ecx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800610:	39 c2                	cmp    %eax,%edx
  800612:	75 09                	jne    80061d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800614:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80061b:	eb 12                	jmp    80062f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061d:	ff 45 e8             	incl   -0x18(%ebp)
  800620:	a1 20 30 80 00       	mov    0x803020,%eax
  800625:	8b 50 74             	mov    0x74(%eax),%edx
  800628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80062b:	39 c2                	cmp    %eax,%edx
  80062d:	77 94                	ja     8005c3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80062f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800633:	75 14                	jne    800649 <CheckWSWithoutLastIndex+0xef>
			panic(
  800635:	83 ec 04             	sub    $0x4,%esp
  800638:	68 20 25 80 00       	push   $0x802520
  80063d:	6a 3a                	push   $0x3a
  80063f:	68 14 25 80 00       	push   $0x802514
  800644:	e8 9f fe ff ff       	call   8004e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800649:	ff 45 f0             	incl   -0x10(%ebp)
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800652:	0f 8c 3e ff ff ff    	jl     800596 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800658:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800666:	eb 20                	jmp    800688 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800668:	a1 20 30 80 00       	mov    0x803020,%eax
  80066d:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800673:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800676:	c1 e2 04             	shl    $0x4,%edx
  800679:	01 d0                	add    %edx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 30 80 00       	mov    0x803020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 d1                	ja     800668 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x159>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 74 25 80 00       	push   $0x802574
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 14 25 80 00       	push   $0x802514
  8006ae:	e8 35 fe ff ff       	call   8004e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 30 80 00       	mov    0x803024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 a7 13 00 00       	call   801aa8 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 30 80 00       	mov    0x803024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 30 13 00 00       	call   801aa8 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 f7 14 00 00       	call   801cb9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 f1 14 00 00       	call   801cd3 <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 b0 18 00 00       	call   8020dc <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 70 19 00 00       	call   8021ec <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 d4 27 80 00       	add    $0x8027d4,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 e5 27 80 00       	push   $0x8027e5
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 ee 27 80 00       	push   $0x8027ee
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be f1 27 80 00       	mov    $0x8027f1,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <malloc>:

struct info spaces[numPages];
int arraySize = 0;

void* malloc(uint32 size)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] malloc() [User Side]
	// Write your code here, remove the panic and write your code
	//This function should find the space of the required range
	//using the BEST FIT strategy
	//refer to the project presentation and documentation for details
	if(arraySize == 0)
  80151a:	a1 28 30 80 00       	mov    0x803028,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	75 33                	jne    801556 <malloc+0x42>
	{
		spaces[0].str_address = (void*)USER_HEAP_START;
  801523:	c7 05 20 31 80 00 00 	movl   $0x80000000,0x803120
  80152a:	00 00 80 
		spaces[0].end_address = (void*)USER_HEAP_MAX;
  80152d:	c7 05 24 31 80 00 00 	movl   $0xa0000000,0x803124
  801534:	00 00 a0 
		spaces[0].pages = numPages;
  801537:	c7 05 28 31 80 00 00 	movl   $0x20000,0x803128
  80153e:	00 02 00 
		spaces[0].isFree = 1;
  801541:	c7 05 2c 31 80 00 01 	movl   $0x1,0x80312c
  801548:	00 00 00 
		arraySize++;
  80154b:	a1 28 30 80 00       	mov    0x803028,%eax
  801550:	40                   	inc    %eax
  801551:	a3 28 30 80 00       	mov    %eax,0x803028
	}
	int min_diff = numPages + 1;
  801556:	c7 45 f4 01 00 02 00 	movl   $0x20001,-0xc(%ebp)
	int index = -1;
  80155d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	size = ROUNDUP(size,PAGE_SIZE);
  801564:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80156b:	8b 55 08             	mov    0x8(%ebp),%edx
  80156e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	48                   	dec    %eax
  801574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	f7 75 e8             	divl   -0x18(%ebp)
  801582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801585:	29 d0                	sub    %edx,%eax
  801587:	89 45 08             	mov    %eax,0x8(%ebp)
	int reqPages = size/PAGE_SIZE;
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	c1 e8 0c             	shr    $0xc,%eax
  801590:	89 45 e0             	mov    %eax,-0x20(%ebp)

	for(int i = 0 ; i < arraySize ; i++)
  801593:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80159a:	eb 57                	jmp    8015f3 <malloc+0xdf>
	{
		if(spaces[i].isFree == 0) continue;
  80159c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159f:	c1 e0 04             	shl    $0x4,%eax
  8015a2:	05 2c 31 80 00       	add    $0x80312c,%eax
  8015a7:	8b 00                	mov    (%eax),%eax
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	74 42                	je     8015ef <malloc+0xdb>

		if(spaces[i].pages >= reqPages)
  8015ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b0:	c1 e0 04             	shl    $0x4,%eax
  8015b3:	05 28 31 80 00       	add    $0x803128,%eax
  8015b8:	8b 00                	mov    (%eax),%eax
  8015ba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8015bd:	7c 31                	jl     8015f0 <malloc+0xdc>
		{
			if(min_diff > spaces[i].pages - reqPages)
  8015bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c2:	c1 e0 04             	shl    $0x4,%eax
  8015c5:	05 28 31 80 00       	add    $0x803128,%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8015cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d2:	7d 1c                	jge    8015f0 <malloc+0xdc>
			{
				min_diff = spaces[i].pages - reqPages;
  8015d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d7:	c1 e0 04             	shl    $0x4,%eax
  8015da:	05 28 31 80 00       	add    $0x803128,%eax
  8015df:	8b 00                	mov    (%eax),%eax
  8015e1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8015e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				index = i;
  8015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ed:	eb 01                	jmp    8015f0 <malloc+0xdc>
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  8015ef:	90                   	nop
	int min_diff = numPages + 1;
	int index = -1;
	size = ROUNDUP(size,PAGE_SIZE);
	int reqPages = size/PAGE_SIZE;

	for(int i = 0 ; i < arraySize ; i++)
  8015f0:	ff 45 ec             	incl   -0x14(%ebp)
  8015f3:	a1 28 30 80 00       	mov    0x803028,%eax
  8015f8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8015fb:	7c 9f                	jl     80159c <malloc+0x88>
			}
		}

	}

	if(index == -1 )
  8015fd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801601:	75 0a                	jne    80160d <malloc+0xf9>
	{
		return NULL;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	e9 34 01 00 00       	jmp    801741 <malloc+0x22d>
	}

	else
	{
		if(reqPages == spaces[index].pages)
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	c1 e0 04             	shl    $0x4,%eax
  801613:	05 28 31 80 00       	add    $0x803128,%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80161d:	75 38                	jne    801657 <malloc+0x143>
		{
			spaces[index].isFree = 0;
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	c1 e0 04             	shl    $0x4,%eax
  801625:	05 2c 31 80 00       	add    $0x80312c,%eax
  80162a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address,reqPages*PAGE_SIZE);
  801630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801633:	c1 e0 0c             	shl    $0xc,%eax
  801636:	89 c2                	mov    %eax,%edx
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163b:	c1 e0 04             	shl    $0x4,%eax
  80163e:	05 20 31 80 00       	add    $0x803120,%eax
  801643:	8b 00                	mov    (%eax),%eax
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	52                   	push   %edx
  801649:	50                   	push   %eax
  80164a:	e8 01 06 00 00       	call   801c50 <sys_allocateMem>
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	e9 dd 00 00 00       	jmp    801734 <malloc+0x220>
		}
		else
		{
			void* newEnd = spaces[index].str_address + (reqPages*PAGE_SIZE);
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	c1 e0 04             	shl    $0x4,%eax
  80165d:	05 20 31 80 00       	add    $0x803120,%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801667:	c1 e2 0c             	shl    $0xc,%edx
  80166a:	01 d0                	add    %edx,%eax
  80166c:	89 45 dc             	mov    %eax,-0x24(%ebp)
			//add new free space after allocation of new size
			spaces[arraySize].str_address = newEnd;
  80166f:	a1 28 30 80 00       	mov    0x803028,%eax
  801674:	c1 e0 04             	shl    $0x4,%eax
  801677:	8d 90 20 31 80 00    	lea    0x803120(%eax),%edx
  80167d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801680:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].end_address = spaces[index].end_address;
  801682:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	c1 e0 04             	shl    $0x4,%eax
  80168e:	05 24 31 80 00       	add    $0x803124,%eax
  801693:	8b 00                	mov    (%eax),%eax
  801695:	c1 e2 04             	shl    $0x4,%edx
  801698:	81 c2 24 31 80 00    	add    $0x803124,%edx
  80169e:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].pages = spaces[index].pages-reqPages;
  8016a0:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8016a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a9:	c1 e0 04             	shl    $0x4,%eax
  8016ac:	05 28 31 80 00       	add    $0x803128,%eax
  8016b1:	8b 00                	mov    (%eax),%eax
  8016b3:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8016b6:	c1 e2 04             	shl    $0x4,%edx
  8016b9:	81 c2 28 31 80 00    	add    $0x803128,%edx
  8016bf:	89 02                	mov    %eax,(%edx)
			spaces[arraySize].isFree = 1;
  8016c1:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c6:	c1 e0 04             	shl    $0x4,%eax
  8016c9:	05 2c 31 80 00       	add    $0x80312c,%eax
  8016ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
			arraySize++;
  8016d4:	a1 28 30 80 00       	mov    0x803028,%eax
  8016d9:	40                   	inc    %eax
  8016da:	a3 28 30 80 00       	mov    %eax,0x803028

			//modify space to represent allocated part
			spaces[index].end_address = newEnd;
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	c1 e0 04             	shl    $0x4,%eax
  8016e5:	8d 90 24 31 80 00    	lea    0x803124(%eax),%edx
  8016eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ee:	89 02                	mov    %eax,(%edx)
			spaces[index].pages = reqPages;
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	c1 e0 04             	shl    $0x4,%eax
  8016f6:	8d 90 28 31 80 00    	lea    0x803128(%eax),%edx
  8016fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ff:	89 02                	mov    %eax,(%edx)
			spaces[index].isFree = 0;
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	c1 e0 04             	shl    $0x4,%eax
  801707:	05 2c 31 80 00       	add    $0x80312c,%eax
  80170c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			sys_allocateMem((uint32)spaces[index].str_address, reqPages*PAGE_SIZE);
  801712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801715:	c1 e0 0c             	shl    $0xc,%eax
  801718:	89 c2                	mov    %eax,%edx
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	c1 e0 04             	shl    $0x4,%eax
  801720:	05 20 31 80 00       	add    $0x803120,%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	e8 1f 05 00 00       	call   801c50 <sys_allocateMem>
  801731:	83 c4 10             	add    $0x10,%esp
		}
		return spaces[index].str_address;
  801734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801737:	c1 e0 04             	shl    $0x4,%eax
  80173a:	05 20 31 80 00       	add    $0x803120,%eax
  80173f:	8b 00                	mov    (%eax),%eax
	}


}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
  801749:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
	int noMerge = 1;
  801750:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	for(int i = 0 ; i < arraySize ; i++)
  801757:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80175e:	eb 3f                	jmp    80179f <free+0x5c>
	{
		if(spaces[i].str_address == virtual_address)
  801760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801763:	c1 e0 04             	shl    $0x4,%eax
  801766:	05 20 31 80 00       	add    $0x803120,%eax
  80176b:	8b 00                	mov    (%eax),%eax
  80176d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801770:	75 2a                	jne    80179c <free+0x59>
		{
			index=i;
  801772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801775:	89 45 f4             	mov    %eax,-0xc(%ebp)
			sys_freeMem((uint32)virtual_address,spaces[i].pages*PAGE_SIZE);
  801778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177b:	c1 e0 04             	shl    $0x4,%eax
  80177e:	05 28 31 80 00       	add    $0x803128,%eax
  801783:	8b 00                	mov    (%eax),%eax
  801785:	c1 e0 0c             	shl    $0xc,%eax
  801788:	89 c2                	mov    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	52                   	push   %edx
  801791:	50                   	push   %eax
  801792:	e8 9d 04 00 00       	call   801c34 <sys_freeMem>
  801797:	83 c4 10             	add    $0x10,%esp
			break;
  80179a:	eb 0d                	jmp    8017a9 <free+0x66>
	//TODO: [PROJECT 2021 - [2] User Heap] free() [User Side]
	// Write your code here, remove the panic and write your code

	int index = -1 ;
	int noMerge = 1;
	for(int i = 0 ; i < arraySize ; i++)
  80179c:	ff 45 ec             	incl   -0x14(%ebp)
  80179f:	a1 28 30 80 00       	mov    0x803028,%eax
  8017a4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8017a7:	7c b7                	jl     801760 <free+0x1d>
			break;
		}

	}

	if(index == -1)
  8017a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8017ad:	75 17                	jne    8017c6 <free+0x83>
	{
		panic("Error");
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	68 50 29 80 00       	push   $0x802950
  8017b7:	68 81 00 00 00       	push   $0x81
  8017bc:	68 56 29 80 00       	push   $0x802956
  8017c1:	e8 22 ed ff ff       	call   8004e8 <_panic>
	}

	for(int i = 0 ; i < arraySize ; i++)
  8017c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017cd:	e9 cc 00 00 00       	jmp    80189e <free+0x15b>
	{
		if(spaces[i].isFree == 0) continue;
  8017d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d5:	c1 e0 04             	shl    $0x4,%eax
  8017d8:	05 2c 31 80 00       	add    $0x80312c,%eax
  8017dd:	8b 00                	mov    (%eax),%eax
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	0f 84 b3 00 00 00    	je     80189a <free+0x157>

		if(spaces[index].str_address == spaces[i].end_address)
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	c1 e0 04             	shl    $0x4,%eax
  8017ed:	05 20 31 80 00       	add    $0x803120,%eax
  8017f2:	8b 10                	mov    (%eax),%edx
  8017f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f7:	c1 e0 04             	shl    $0x4,%eax
  8017fa:	05 24 31 80 00       	add    $0x803124,%eax
  8017ff:	8b 00                	mov    (%eax),%eax
  801801:	39 c2                	cmp    %eax,%edx
  801803:	0f 85 92 00 00 00    	jne    80189b <free+0x158>
		{
			//merge
			spaces[i].end_address = spaces[index].end_address;
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	c1 e0 04             	shl    $0x4,%eax
  80180f:	05 24 31 80 00       	add    $0x803124,%eax
  801814:	8b 00                	mov    (%eax),%eax
  801816:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801819:	c1 e2 04             	shl    $0x4,%edx
  80181c:	81 c2 24 31 80 00    	add    $0x803124,%edx
  801822:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  801824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801827:	c1 e0 04             	shl    $0x4,%eax
  80182a:	05 28 31 80 00       	add    $0x803128,%eax
  80182f:	8b 10                	mov    (%eax),%edx
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	c1 e0 04             	shl    $0x4,%eax
  801837:	05 28 31 80 00       	add    $0x803128,%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	01 c2                	add    %eax,%edx
  801840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801843:	c1 e0 04             	shl    $0x4,%eax
  801846:	05 28 31 80 00       	add    $0x803128,%eax
  80184b:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  80184d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801850:	c1 e0 04             	shl    $0x4,%eax
  801853:	05 20 31 80 00       	add    $0x803120,%eax
  801858:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  80185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801861:	c1 e0 04             	shl    $0x4,%eax
  801864:	05 24 31 80 00       	add    $0x803124,%eax
  801869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  80186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801872:	c1 e0 04             	shl    $0x4,%eax
  801875:	05 28 31 80 00       	add    $0x803128,%eax
  80187a:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801883:	c1 e0 04             	shl    $0x4,%eax
  801886:	05 2c 31 80 00       	add    $0x80312c,%eax
  80188b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801891:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  801898:	eb 12                	jmp    8018ac <free+0x169>
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  80189a:	90                   	nop
	if(index == -1)
	{
		panic("Error");
	}

	for(int i = 0 ; i < arraySize ; i++)
  80189b:	ff 45 e8             	incl   -0x18(%ebp)
  80189e:	a1 28 30 80 00       	mov    0x803028,%eax
  8018a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8018a6:	0f 8c 26 ff ff ff    	jl     8017d2 <free+0x8f>
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  8018ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8018b3:	e9 cc 00 00 00       	jmp    801984 <free+0x241>
	{
		if(spaces[i].isFree == 0) continue;
  8018b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bb:	c1 e0 04             	shl    $0x4,%eax
  8018be:	05 2c 31 80 00       	add    $0x80312c,%eax
  8018c3:	8b 00                	mov    (%eax),%eax
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	0f 84 b3 00 00 00    	je     801980 <free+0x23d>

		if(spaces[index].end_address == spaces[i].str_address)
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	c1 e0 04             	shl    $0x4,%eax
  8018d3:	05 24 31 80 00       	add    $0x803124,%eax
  8018d8:	8b 10                	mov    (%eax),%edx
  8018da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018dd:	c1 e0 04             	shl    $0x4,%eax
  8018e0:	05 20 31 80 00       	add    $0x803120,%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	39 c2                	cmp    %eax,%edx
  8018e9:	0f 85 92 00 00 00    	jne    801981 <free+0x23e>
		{
			//merge
			spaces[i].str_address = spaces[index].str_address;
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	c1 e0 04             	shl    $0x4,%eax
  8018f5:	05 20 31 80 00       	add    $0x803120,%eax
  8018fa:	8b 00                	mov    (%eax),%eax
  8018fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ff:	c1 e2 04             	shl    $0x4,%edx
  801902:	81 c2 20 31 80 00    	add    $0x803120,%edx
  801908:	89 02                	mov    %eax,(%edx)
			spaces[i].pages += spaces[index].pages;
  80190a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190d:	c1 e0 04             	shl    $0x4,%eax
  801910:	05 28 31 80 00       	add    $0x803128,%eax
  801915:	8b 10                	mov    (%eax),%edx
  801917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191a:	c1 e0 04             	shl    $0x4,%eax
  80191d:	05 28 31 80 00       	add    $0x803128,%eax
  801922:	8b 00                	mov    (%eax),%eax
  801924:	01 c2                	add    %eax,%edx
  801926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801929:	c1 e0 04             	shl    $0x4,%eax
  80192c:	05 28 31 80 00       	add    $0x803128,%eax
  801931:	89 10                	mov    %edx,(%eax)

			//remove from spaces
			spaces[index].str_address = 0;
  801933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801936:	c1 e0 04             	shl    $0x4,%eax
  801939:	05 20 31 80 00       	add    $0x803120,%eax
  80193e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].end_address = 0;
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801947:	c1 e0 04             	shl    $0x4,%eax
  80194a:	05 24 31 80 00       	add    $0x803124,%eax
  80194f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			spaces[index].pages = -1;
  801955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801958:	c1 e0 04             	shl    $0x4,%eax
  80195b:	05 28 31 80 00       	add    $0x803128,%eax
  801960:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			spaces[index].isFree = 0;
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	c1 e0 04             	shl    $0x4,%eax
  80196c:	05 2c 31 80 00       	add    $0x80312c,%eax
  801971:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			noMerge = 0;
  801977:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
			break;
  80197e:	eb 12                	jmp    801992 <free+0x24f>
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
	{
		if(spaces[i].isFree == 0) continue;
  801980:	90                   	nop
			noMerge = 0;
			break;
		}
	}

	for(int i = 0 ; i < arraySize ; i++)
  801981:	ff 45 e4             	incl   -0x1c(%ebp)
  801984:	a1 28 30 80 00       	mov    0x803028,%eax
  801989:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80198c:	0f 8c 26 ff ff ff    	jl     8018b8 <free+0x175>
			noMerge = 0;
			break;
		}
	}

	if(noMerge == 1)
  801992:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  801996:	75 11                	jne    8019a9 <free+0x266>
	{
		spaces[index].isFree = 1;
  801998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199b:	c1 e0 04             	shl    $0x4,%eax
  80199e:	05 2c 31 80 00       	add    $0x80312c,%eax
  8019a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}

}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 18             	sub    $0x18,%esp
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	68 64 29 80 00       	push   $0x802964
  8019c0:	68 b9 00 00 00       	push   $0xb9
  8019c5:	68 56 29 80 00       	push   $0x802956
  8019ca:	e8 19 eb ff ff       	call   8004e8 <_panic>

008019cf <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	68 64 29 80 00       	push   $0x802964
  8019dd:	68 bf 00 00 00       	push   $0xbf
  8019e2:	68 56 29 80 00       	push   $0x802956
  8019e7:	e8 fc ea ff ff       	call   8004e8 <_panic>

008019ec <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 64 29 80 00       	push   $0x802964
  8019fa:	68 c5 00 00 00       	push   $0xc5
  8019ff:	68 56 29 80 00       	push   $0x802956
  801a04:	e8 df ea ff ff       	call   8004e8 <_panic>

00801a09 <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	68 64 29 80 00       	push   $0x802964
  801a17:	68 ca 00 00 00       	push   $0xca
  801a1c:	68 56 29 80 00       	push   $0x802956
  801a21:	e8 c2 ea ff ff       	call   8004e8 <_panic>

00801a26 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 64 29 80 00       	push   $0x802964
  801a34:	68 d0 00 00 00       	push   $0xd0
  801a39:	68 56 29 80 00       	push   $0x802956
  801a3e:	e8 a5 ea ff ff       	call   8004e8 <_panic>

00801a43 <shrink>:
}
void shrink(uint32 newSize)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 64 29 80 00       	push   $0x802964
  801a51:	68 d4 00 00 00       	push   $0xd4
  801a56:	68 56 29 80 00       	push   $0x802956
  801a5b:	e8 88 ea ff ff       	call   8004e8 <_panic>

00801a60 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	68 64 29 80 00       	push   $0x802964
  801a6e:	68 d9 00 00 00       	push   $0xd9
  801a73:	68 56 29 80 00       	push   $0x802956
  801a78:	e8 6b ea ff ff       	call   8004e8 <_panic>

00801a7d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	57                   	push   %edi
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a92:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a95:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a98:	cd 30                	int    $0x30
  801a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    

00801aa8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ab4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	50                   	push   %eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	e8 b2 ff ff ff       	call   801a7d <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 01                	push   $0x1
  801ae0:	e8 98 ff ff ff       	call   801a7d <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	50                   	push   %eax
  801af9:	6a 05                	push   $0x5
  801afb:	e8 7d ff ff ff       	call   801a7d <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 02                	push   $0x2
  801b14:	e8 64 ff ff ff       	call   801a7d <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 03                	push   $0x3
  801b2d:	e8 4b ff ff ff       	call   801a7d <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 04                	push   $0x4
  801b46:	e8 32 ff ff ff       	call   801a7d <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_env_exit>:


void sys_env_exit(void)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 06                	push   $0x6
  801b5f:	e8 19 ff ff ff       	call   801a7d <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	90                   	nop
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 07                	push   $0x7
  801b7d:	e8 fb fe ff ff       	call   801a7d <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b8c:	8b 75 18             	mov    0x18(%ebp),%esi
  801b8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	56                   	push   %esi
  801b9c:	53                   	push   %ebx
  801b9d:	51                   	push   %ecx
  801b9e:	52                   	push   %edx
  801b9f:	50                   	push   %eax
  801ba0:	6a 08                	push   $0x8
  801ba2:	e8 d6 fe ff ff       	call   801a7d <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	6a 09                	push   $0x9
  801bc4:	e8 b4 fe ff ff       	call   801a7d <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	ff 75 08             	pushl  0x8(%ebp)
  801bdd:	6a 0a                	push   $0xa
  801bdf:	e8 99 fe ff ff       	call   801a7d <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 0b                	push   $0xb
  801bf8:	e8 80 fe ff ff       	call   801a7d <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 0c                	push   $0xc
  801c11:	e8 67 fe ff ff       	call   801a7d <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 0d                	push   $0xd
  801c2a:	e8 4e fe ff ff       	call   801a7d <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	ff 75 0c             	pushl  0xc(%ebp)
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	6a 11                	push   $0x11
  801c45:	e8 33 fe ff ff       	call   801a7d <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
	return;
  801c4d:	90                   	nop
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	ff 75 0c             	pushl  0xc(%ebp)
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	6a 12                	push   $0x12
  801c61:	e8 17 fe ff ff       	call   801a7d <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
	return ;
  801c69:	90                   	nop
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 0e                	push   $0xe
  801c7b:	e8 fd fd ff ff       	call   801a7d <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 0f                	push   $0xf
  801c95:	e8 e3 fd ff ff       	call   801a7d <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 10                	push   $0x10
  801cae:	e8 ca fd ff ff       	call   801a7d <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 14                	push   $0x14
  801cc8:	e8 b0 fd ff ff       	call   801a7d <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	90                   	nop
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 15                	push   $0x15
  801ce2:	e8 96 fd ff ff       	call   801a7d <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	90                   	nop
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_cputc>:


void
sys_cputc(const char c)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	50                   	push   %eax
  801d06:	6a 16                	push   $0x16
  801d08:	e8 70 fd ff ff       	call   801a7d <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 17                	push   $0x17
  801d22:	e8 56 fd ff ff       	call   801a7d <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	90                   	nop
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	50                   	push   %eax
  801d3d:	6a 18                	push   $0x18
  801d3f:	e8 39 fd ff ff       	call   801a7d <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 1b                	push   $0x1b
  801d5c:	e8 1c fd ff ff       	call   801a7d <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	52                   	push   %edx
  801d76:	50                   	push   %eax
  801d77:	6a 19                	push   $0x19
  801d79:	e8 ff fc ff ff       	call   801a7d <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	90                   	nop
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	52                   	push   %edx
  801d94:	50                   	push   %eax
  801d95:	6a 1a                	push   $0x1a
  801d97:	e8 e1 fc ff ff       	call   801a7d <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	90                   	nop
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 10             	mov    0x10(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801db1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	6a 00                	push   $0x0
  801dba:	51                   	push   %ecx
  801dbb:	52                   	push   %edx
  801dbc:	ff 75 0c             	pushl  0xc(%ebp)
  801dbf:	50                   	push   %eax
  801dc0:	6a 1c                	push   $0x1c
  801dc2:	e8 b6 fc ff ff       	call   801a7d <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	52                   	push   %edx
  801ddc:	50                   	push   %eax
  801ddd:	6a 1d                	push   $0x1d
  801ddf:	e8 99 fc ff ff       	call   801a7d <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801def:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	51                   	push   %ecx
  801dfa:	52                   	push   %edx
  801dfb:	50                   	push   %eax
  801dfc:	6a 1e                	push   $0x1e
  801dfe:	e8 7a fc ff ff       	call   801a7d <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	6a 1f                	push   $0x1f
  801e1b:	e8 5d fc ff ff       	call   801a7d <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 20                	push   $0x20
  801e34:	e8 44 fc ff ff       	call   801a7d <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	ff 75 14             	pushl  0x14(%ebp)
  801e49:	ff 75 10             	pushl  0x10(%ebp)
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	50                   	push   %eax
  801e50:	6a 21                	push   $0x21
  801e52:	e8 26 fc ff ff       	call   801a7d <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	50                   	push   %eax
  801e6b:	6a 22                	push   $0x22
  801e6d:	e8 0b fc ff ff       	call   801a7d <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	90                   	nop
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_free_env>:

void
sys_free_env(int32 envId)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	50                   	push   %eax
  801e87:	6a 23                	push   $0x23
  801e89:	e8 ef fb ff ff       	call   801a7d <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	90                   	nop
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e9d:	8d 50 04             	lea    0x4(%eax),%edx
  801ea0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	52                   	push   %edx
  801eaa:	50                   	push   %eax
  801eab:	6a 24                	push   $0x24
  801ead:	e8 cb fb ff ff       	call   801a7d <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
	return result;
  801eb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ebe:	89 01                	mov    %eax,(%ecx)
  801ec0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	c9                   	leave  
  801ec7:	c2 04 00             	ret    $0x4

00801eca <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	ff 75 10             	pushl  0x10(%ebp)
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	6a 13                	push   $0x13
  801edc:	e8 9c fb ff ff       	call   801a7d <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 25                	push   $0x25
  801ef6:	e8 82 fb ff ff       	call   801a7d <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	50                   	push   %eax
  801f19:	6a 26                	push   $0x26
  801f1b:	e8 5d fb ff ff       	call   801a7d <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
	return ;
  801f23:	90                   	nop
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <rsttst>:
void rsttst()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 28                	push   $0x28
  801f35:	e8 43 fb ff ff       	call   801a7d <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3d:	90                   	nop
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	8b 45 14             	mov    0x14(%ebp),%eax
  801f49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801f4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	ff 75 10             	pushl  0x10(%ebp)
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	6a 27                	push   $0x27
  801f60:	e8 18 fb ff ff       	call   801a7d <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return ;
  801f68:	90                   	nop
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <chktst>:
void chktst(uint32 n)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	6a 29                	push   $0x29
  801f7b:	e8 fd fa ff ff       	call   801a7d <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
	return ;
  801f83:	90                   	nop
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <inctst>:

void inctst()
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 2a                	push   $0x2a
  801f95:	e8 e3 fa ff ff       	call   801a7d <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9d:	90                   	nop
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <gettst>:
uint32 gettst()
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 2b                	push   $0x2b
  801faf:	e8 c9 fa ff ff       	call   801a7d <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 2c                	push   $0x2c
  801fcb:	e8 ad fa ff ff       	call   801a7d <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
  801fd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fd6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fda:	75 07                	jne    801fe3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe1:	eb 05                	jmp    801fe8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 2c                	push   $0x2c
  801ffc:	e8 7c fa ff ff       	call   801a7d <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
  802004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802007:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80200b:	75 07                	jne    802014 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80200d:	b8 01 00 00 00       	mov    $0x1,%eax
  802012:	eb 05                	jmp    802019 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 2c                	push   $0x2c
  80202d:	e8 4b fa ff ff       	call   801a7d <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
  802035:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802038:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80203c:	75 07                	jne    802045 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	eb 05                	jmp    80204a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 2c                	push   $0x2c
  80205e:	e8 1a fa ff ff       	call   801a7d <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
  802066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802069:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80206d:	75 07                	jne    802076 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80206f:	b8 01 00 00 00       	mov    $0x1,%eax
  802074:	eb 05                	jmp    80207b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	ff 75 08             	pushl  0x8(%ebp)
  80208b:	6a 2d                	push   $0x2d
  80208d:	e8 eb f9 ff ff       	call   801a7d <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
	return ;
  802095:	90                   	nop
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80209c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80209f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	6a 00                	push   $0x0
  8020aa:	53                   	push   %ebx
  8020ab:	51                   	push   %ecx
  8020ac:	52                   	push   %edx
  8020ad:	50                   	push   %eax
  8020ae:	6a 2e                	push   $0x2e
  8020b0:	e8 c8 f9 ff ff       	call   801a7d <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	52                   	push   %edx
  8020cd:	50                   	push   %eax
  8020ce:	6a 2f                	push   $0x2f
  8020d0:	e8 a8 f9 ff ff       	call   801a7d <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    
  8020da:	66 90                	xchg   %ax,%ax

008020dc <__udivdi3>:
  8020dc:	55                   	push   %ebp
  8020dd:	57                   	push   %edi
  8020de:	56                   	push   %esi
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 1c             	sub    $0x1c,%esp
  8020e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f3:	89 ca                	mov    %ecx,%edx
  8020f5:	89 f8                	mov    %edi,%eax
  8020f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020fb:	85 f6                	test   %esi,%esi
  8020fd:	75 2d                	jne    80212c <__udivdi3+0x50>
  8020ff:	39 cf                	cmp    %ecx,%edi
  802101:	77 65                	ja     802168 <__udivdi3+0x8c>
  802103:	89 fd                	mov    %edi,%ebp
  802105:	85 ff                	test   %edi,%edi
  802107:	75 0b                	jne    802114 <__udivdi3+0x38>
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
  80210e:	31 d2                	xor    %edx,%edx
  802110:	f7 f7                	div    %edi
  802112:	89 c5                	mov    %eax,%ebp
  802114:	31 d2                	xor    %edx,%edx
  802116:	89 c8                	mov    %ecx,%eax
  802118:	f7 f5                	div    %ebp
  80211a:	89 c1                	mov    %eax,%ecx
  80211c:	89 d8                	mov    %ebx,%eax
  80211e:	f7 f5                	div    %ebp
  802120:	89 cf                	mov    %ecx,%edi
  802122:	89 fa                	mov    %edi,%edx
  802124:	83 c4 1c             	add    $0x1c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
  80212c:	39 ce                	cmp    %ecx,%esi
  80212e:	77 28                	ja     802158 <__udivdi3+0x7c>
  802130:	0f bd fe             	bsr    %esi,%edi
  802133:	83 f7 1f             	xor    $0x1f,%edi
  802136:	75 40                	jne    802178 <__udivdi3+0x9c>
  802138:	39 ce                	cmp    %ecx,%esi
  80213a:	72 0a                	jb     802146 <__udivdi3+0x6a>
  80213c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802140:	0f 87 9e 00 00 00    	ja     8021e4 <__udivdi3+0x108>
  802146:	b8 01 00 00 00       	mov    $0x1,%eax
  80214b:	89 fa                	mov    %edi,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	31 ff                	xor    %edi,%edi
  80215a:	31 c0                	xor    %eax,%eax
  80215c:	89 fa                	mov    %edi,%edx
  80215e:	83 c4 1c             	add    $0x1c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    
  802166:	66 90                	xchg   %ax,%ax
  802168:	89 d8                	mov    %ebx,%eax
  80216a:	f7 f7                	div    %edi
  80216c:	31 ff                	xor    %edi,%edi
  80216e:	89 fa                	mov    %edi,%edx
  802170:	83 c4 1c             	add    $0x1c,%esp
  802173:	5b                   	pop    %ebx
  802174:	5e                   	pop    %esi
  802175:	5f                   	pop    %edi
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    
  802178:	bd 20 00 00 00       	mov    $0x20,%ebp
  80217d:	89 eb                	mov    %ebp,%ebx
  80217f:	29 fb                	sub    %edi,%ebx
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e6                	shl    %cl,%esi
  802185:	89 c5                	mov    %eax,%ebp
  802187:	88 d9                	mov    %bl,%cl
  802189:	d3 ed                	shr    %cl,%ebp
  80218b:	89 e9                	mov    %ebp,%ecx
  80218d:	09 f1                	or     %esi,%ecx
  80218f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802193:	89 f9                	mov    %edi,%ecx
  802195:	d3 e0                	shl    %cl,%eax
  802197:	89 c5                	mov    %eax,%ebp
  802199:	89 d6                	mov    %edx,%esi
  80219b:	88 d9                	mov    %bl,%cl
  80219d:	d3 ee                	shr    %cl,%esi
  80219f:	89 f9                	mov    %edi,%ecx
  8021a1:	d3 e2                	shl    %cl,%edx
  8021a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a7:	88 d9                	mov    %bl,%cl
  8021a9:	d3 e8                	shr    %cl,%eax
  8021ab:	09 c2                	or     %eax,%edx
  8021ad:	89 d0                	mov    %edx,%eax
  8021af:	89 f2                	mov    %esi,%edx
  8021b1:	f7 74 24 0c          	divl   0xc(%esp)
  8021b5:	89 d6                	mov    %edx,%esi
  8021b7:	89 c3                	mov    %eax,%ebx
  8021b9:	f7 e5                	mul    %ebp
  8021bb:	39 d6                	cmp    %edx,%esi
  8021bd:	72 19                	jb     8021d8 <__udivdi3+0xfc>
  8021bf:	74 0b                	je     8021cc <__udivdi3+0xf0>
  8021c1:	89 d8                	mov    %ebx,%eax
  8021c3:	31 ff                	xor    %edi,%edi
  8021c5:	e9 58 ff ff ff       	jmp    802122 <__udivdi3+0x46>
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021d0:	89 f9                	mov    %edi,%ecx
  8021d2:	d3 e2                	shl    %cl,%edx
  8021d4:	39 c2                	cmp    %eax,%edx
  8021d6:	73 e9                	jae    8021c1 <__udivdi3+0xe5>
  8021d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021db:	31 ff                	xor    %edi,%edi
  8021dd:	e9 40 ff ff ff       	jmp    802122 <__udivdi3+0x46>
  8021e2:	66 90                	xchg   %ax,%ax
  8021e4:	31 c0                	xor    %eax,%eax
  8021e6:	e9 37 ff ff ff       	jmp    802122 <__udivdi3+0x46>
  8021eb:	90                   	nop

008021ec <__umoddi3>:
  8021ec:	55                   	push   %ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	83 ec 1c             	sub    $0x1c,%esp
  8021f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802207:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80220b:	89 f3                	mov    %esi,%ebx
  80220d:	89 fa                	mov    %edi,%edx
  80220f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802213:	89 34 24             	mov    %esi,(%esp)
  802216:	85 c0                	test   %eax,%eax
  802218:	75 1a                	jne    802234 <__umoddi3+0x48>
  80221a:	39 f7                	cmp    %esi,%edi
  80221c:	0f 86 a2 00 00 00    	jbe    8022c4 <__umoddi3+0xd8>
  802222:	89 c8                	mov    %ecx,%eax
  802224:	89 f2                	mov    %esi,%edx
  802226:	f7 f7                	div    %edi
  802228:	89 d0                	mov    %edx,%eax
  80222a:	31 d2                	xor    %edx,%edx
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
  802234:	39 f0                	cmp    %esi,%eax
  802236:	0f 87 ac 00 00 00    	ja     8022e8 <__umoddi3+0xfc>
  80223c:	0f bd e8             	bsr    %eax,%ebp
  80223f:	83 f5 1f             	xor    $0x1f,%ebp
  802242:	0f 84 ac 00 00 00    	je     8022f4 <__umoddi3+0x108>
  802248:	bf 20 00 00 00       	mov    $0x20,%edi
  80224d:	29 ef                	sub    %ebp,%edi
  80224f:	89 fe                	mov    %edi,%esi
  802251:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802255:	89 e9                	mov    %ebp,%ecx
  802257:	d3 e0                	shl    %cl,%eax
  802259:	89 d7                	mov    %edx,%edi
  80225b:	89 f1                	mov    %esi,%ecx
  80225d:	d3 ef                	shr    %cl,%edi
  80225f:	09 c7                	or     %eax,%edi
  802261:	89 e9                	mov    %ebp,%ecx
  802263:	d3 e2                	shl    %cl,%edx
  802265:	89 14 24             	mov    %edx,(%esp)
  802268:	89 d8                	mov    %ebx,%eax
  80226a:	d3 e0                	shl    %cl,%eax
  80226c:	89 c2                	mov    %eax,%edx
  80226e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802272:	d3 e0                	shl    %cl,%eax
  802274:	89 44 24 04          	mov    %eax,0x4(%esp)
  802278:	8b 44 24 08          	mov    0x8(%esp),%eax
  80227c:	89 f1                	mov    %esi,%ecx
  80227e:	d3 e8                	shr    %cl,%eax
  802280:	09 d0                	or     %edx,%eax
  802282:	d3 eb                	shr    %cl,%ebx
  802284:	89 da                	mov    %ebx,%edx
  802286:	f7 f7                	div    %edi
  802288:	89 d3                	mov    %edx,%ebx
  80228a:	f7 24 24             	mull   (%esp)
  80228d:	89 c6                	mov    %eax,%esi
  80228f:	89 d1                	mov    %edx,%ecx
  802291:	39 d3                	cmp    %edx,%ebx
  802293:	0f 82 87 00 00 00    	jb     802320 <__umoddi3+0x134>
  802299:	0f 84 91 00 00 00    	je     802330 <__umoddi3+0x144>
  80229f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022a3:	29 f2                	sub    %esi,%edx
  8022a5:	19 cb                	sbb    %ecx,%ebx
  8022a7:	89 d8                	mov    %ebx,%eax
  8022a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022ad:	d3 e0                	shl    %cl,%eax
  8022af:	89 e9                	mov    %ebp,%ecx
  8022b1:	d3 ea                	shr    %cl,%edx
  8022b3:	09 d0                	or     %edx,%eax
  8022b5:	89 e9                	mov    %ebp,%ecx
  8022b7:	d3 eb                	shr    %cl,%ebx
  8022b9:	89 da                	mov    %ebx,%edx
  8022bb:	83 c4 1c             	add    $0x1c,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	90                   	nop
  8022c4:	89 fd                	mov    %edi,%ebp
  8022c6:	85 ff                	test   %edi,%edi
  8022c8:	75 0b                	jne    8022d5 <__umoddi3+0xe9>
  8022ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cf:	31 d2                	xor    %edx,%edx
  8022d1:	f7 f7                	div    %edi
  8022d3:	89 c5                	mov    %eax,%ebp
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	31 d2                	xor    %edx,%edx
  8022d9:	f7 f5                	div    %ebp
  8022db:	89 c8                	mov    %ecx,%eax
  8022dd:	f7 f5                	div    %ebp
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	e9 44 ff ff ff       	jmp    80222a <__umoddi3+0x3e>
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	89 c8                	mov    %ecx,%eax
  8022ea:	89 f2                	mov    %esi,%edx
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    
  8022f4:	3b 04 24             	cmp    (%esp),%eax
  8022f7:	72 06                	jb     8022ff <__umoddi3+0x113>
  8022f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8022fd:	77 0f                	ja     80230e <__umoddi3+0x122>
  8022ff:	89 f2                	mov    %esi,%edx
  802301:	29 f9                	sub    %edi,%ecx
  802303:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802307:	89 14 24             	mov    %edx,(%esp)
  80230a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80230e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802312:	8b 14 24             	mov    (%esp),%edx
  802315:	83 c4 1c             	add    $0x1c,%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	2b 04 24             	sub    (%esp),%eax
  802323:	19 fa                	sbb    %edi,%edx
  802325:	89 d1                	mov    %edx,%ecx
  802327:	89 c6                	mov    %eax,%esi
  802329:	e9 71 ff ff ff       	jmp    80229f <__umoddi3+0xb3>
  80232e:	66 90                	xchg   %ax,%ax
  802330:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802334:	72 ea                	jb     802320 <__umoddi3+0x134>
  802336:	89 d9                	mov    %ebx,%ecx
  802338:	e9 62 ff ff ff       	jmp    80229f <__umoddi3+0xb3>
